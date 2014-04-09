Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899AbaDIPO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:14:26 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:33084 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933782AbaDIPOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:14:22 -0400
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@alien8.de,
        bp@suse.de, m.chehab@samsung.com
Cc: linux-edac@vger.kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH 2/7] acpi, apei, ghes: Introduce more generic mechanism to init/deinit GHES error notifications.
Date: Wed,  9 Apr 2014 17:14:30 +0200
Message-Id: <1397056476-9183-3-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397056476-9183-1-git-send-email-tomasz.nowicki@linaro.org>
References: <1397056476-9183-1-git-send-email-tomasz.nowicki@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Init/deinit of GHES error notifications are moved to corresponding
functions e.g. for SCI ghes_notify_init_sci{sci} and ghes_notify_remove_{sci}
which in turn are gathered to ghes_notify_tab table.
ghes_probe and ghes_remove check notification support based on
function reference pointer in ghes_notify_tab and call it with ghes argument.

This approach allows us to change address of a given error notification
init/deinit function call in ghes_notify_tab in runtime. In turn,
we can avoid #ifdef usage in common code e.g. for NMI which is currently
supported by x86.

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
---
 drivers/acpi/apei/ghes.c |  242 ++++++++++++++++++++++++++++------------------
 1 file changed, 149 insertions(+), 93 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index f7edffc..ca8387e 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -148,6 +148,14 @@ static struct irq_work ghes_proc_irq_work;
 struct ghes_estatus_cache *ghes_estatus_caches[GHES_ESTATUS_CACHES_SIZE];
 static atomic_t ghes_estatus_cache_alloced;
 
+struct ghes_notify_setup {
+	const char *notif_name;
+	int 	   (*init_call)(struct ghes *ghes);
+	void 	   (*remove_call)(struct ghes *ghes);
+};
+
+static struct ghes_notify_setup	ghes_notify_tab[];
+
 static int ghes_ioremap_init(void)
 {
 	ghes_ioremap_area = __get_vm_area(PAGE_SIZE * GHES_IOREMAP_PAGES,
@@ -879,10 +887,6 @@ out:
 	return ret;
 }
 
-static struct notifier_block ghes_notifier_sci = {
-	.notifier_call = ghes_notify_sci,
-};
-
 static unsigned long ghes_esource_prealloc_size(
 	const struct acpi_hest_generic *generic)
 {
@@ -898,33 +902,151 @@ static unsigned long ghes_esource_prealloc_size(
 	return prealloc_size;
 }
 
+static int ghes_notify_init_nmi(struct ghes *ghes)
+{
+	unsigned long len;
+
+	len = ghes_esource_prealloc_size(ghes->generic);
+	ghes_estatus_pool_expand(len);
+	mutex_lock(&ghes_list_mutex);
+	if (list_empty(&ghes_nmi))
+		register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0, "ghes");
+	list_add_rcu(&ghes->list, &ghes_nmi);
+	mutex_unlock(&ghes_list_mutex);
+
+	return 0;
+}
+
+static void ghes_notify_remove_nmi(struct ghes *ghes)
+{
+	unsigned long len;
+
+	mutex_lock(&ghes_list_mutex);
+	list_del_rcu(&ghes->list);
+	if (list_empty(&ghes_nmi))
+		unregister_nmi_handler(NMI_LOCAL, "ghes");
+	mutex_unlock(&ghes_list_mutex);
+	/*
+	 * To synchronize with NMI handler, ghes can only be
+	 * freed after NMI handler finishes.
+	 */
+	synchronize_rcu();
+	len = ghes_esource_prealloc_size(ghes->generic);
+	ghes_estatus_pool_shrink(len);
+}
+
+static int ghes_notify_init_polled(struct ghes *ghes)
+{
+	ghes->timer.function = ghes_poll_func;
+	ghes->timer.data = (unsigned long)ghes;
+	init_timer_deferrable(&ghes->timer);
+	ghes_add_timer(ghes);
+
+	return 0;
+}
+
+static void ghes_notify_remove_polled(struct ghes *ghes)
+{
+	del_timer_sync(&ghes->timer);
+}
+
+static int ghes_notify_init_external(struct ghes *ghes)
+{
+	int rc;
+
+	/* External interrupt vector is GSI */
+	rc = acpi_gsi_to_irq(ghes->generic->notify.vector, &ghes->irq);
+	if (rc) {
+		pr_err(GHES_PFX "Failed to map GSI to IRQ for generic hardware "
+		       "error source: %d\n", ghes->generic->header.source_id);
+		goto out;
+	}
+
+	rc = request_irq(ghes->irq, ghes_irq_func, 0, "GHES IRQ", ghes);
+	if (rc)
+		pr_err(GHES_PFX "Failed to register IRQ for generic hardware "
+		       "error source: %d\n", ghes->generic->header.source_id);
+
+out:
+	return rc;
+}
+
+static void ghes_notify_remove_external(struct ghes *ghes)
+{
+	free_irq(ghes->irq, ghes);
+}
+
+static struct notifier_block ghes_notifier_sci = {
+	.notifier_call = ghes_notify_sci,
+};
+
+static int ghes_notify_init_sci(struct ghes *ghes)
+{
+	mutex_lock(&ghes_list_mutex);
+	if (list_empty(&ghes_sci))
+		register_acpi_hed_notifier(&ghes_notifier_sci);
+	list_add_rcu(&ghes->list, &ghes_sci);
+	mutex_unlock(&ghes_list_mutex);
+
+	return 0;
+}
+
+static void ghes_notify_remove_sci(struct ghes *ghes)
+{
+	mutex_lock(&ghes_list_mutex);
+	list_del_rcu(&ghes->list);
+	if (list_empty(&ghes_sci))
+		unregister_acpi_hed_notifier(&ghes_notifier_sci);
+	mutex_unlock(&ghes_list_mutex);
+}
+
+static struct ghes_notify_setup
+	ghes_notify_tab[ACPI_HEST_NOTIFY_RESERVED] = {
+		[ACPI_HEST_NOTIFY_POLLED]   = {"POLLED",
+					       ghes_notify_init_polled,
+					       ghes_notify_remove_polled},
+		[ACPI_HEST_NOTIFY_EXTERNAL] = {"EXT_IRQ",
+					       ghes_notify_init_external,
+					       ghes_notify_remove_external},
+		[ACPI_HEST_NOTIFY_LOCAL]    = {"LOCAL_IRQ", NULL, NULL},
+		[ACPI_HEST_NOTIFY_SCI]      = {"SCI",
+					       ghes_notify_init_sci,
+					       ghes_notify_remove_sci},
+		[ACPI_HEST_NOTIFY_NMI]      = {"NMI",
+					       ghes_notify_init_nmi,
+					       ghes_notify_remove_nmi},
+		[ACPI_HEST_NOTIFY_CMCI]     = {"CMCI", NULL, NULL},
+		[ACPI_HEST_NOTIFY_MCE]      = {"MCE", NULL, NULL},
+};
+
 static int ghes_probe(struct platform_device *ghes_dev)
 {
 	struct acpi_hest_generic *generic;
 	struct ghes *ghes = NULL;
-	unsigned long len;
 	int rc = -EINVAL;
+	int (*ghes_init_call)(struct ghes *ghes);
+	const char *ghes_notif_name;
 
 	generic = *(struct acpi_hest_generic **)ghes_dev->dev.platform_data;
 	if (!generic->enabled)
 		return -ENODEV;
 
-	switch (generic->notify.type) {
-	case ACPI_HEST_NOTIFY_POLLED:
-	case ACPI_HEST_NOTIFY_EXTERNAL:
-	case ACPI_HEST_NOTIFY_SCI:
-	case ACPI_HEST_NOTIFY_NMI:
-		break;
-	case ACPI_HEST_NOTIFY_LOCAL:
-		pr_warning(GHES_PFX "Generic hardware error source: %d notified via local interrupt is not supported!\n",
-			   generic->header.source_id);
-		goto err;
-	default:
-		pr_warning(FW_WARN GHES_PFX "Unknown notification type: %u for generic hardware error source: %d\n",
+	if (generic->notify.type >= ACPI_HEST_NOTIFY_RESERVED) {
+		pr_warning(FW_WARN GHES_PFX "Unknown notification type: %u for "
+			   "generic hardware error source: %d\n",
 			   generic->notify.type, generic->header.source_id);
 		goto err;
 	}
 
+	ghes_init_call = ghes_notify_tab[generic->notify.type].init_call;
+	ghes_notif_name = ghes_notify_tab[generic->notify.type].notif_name;
+	if (!ghes_init_call) {
+		pr_warning(GHES_PFX "Generic hardware error source: %d notified"
+			   " via %s is not supported!\n",
+			   generic->header.source_id, ghes_notif_name);
+		goto err;
+	}
+
 	rc = -EIO;
 	if (generic->error_block_length <
 	    sizeof(struct acpi_generic_status)) {
@@ -944,48 +1066,10 @@ static int ghes_probe(struct platform_device *ghes_dev)
 	if (rc < 0)
 		goto err;
 
-	switch (generic->notify.type) {
-	case ACPI_HEST_NOTIFY_POLLED:
-		ghes->timer.function = ghes_poll_func;
-		ghes->timer.data = (unsigned long)ghes;
-		init_timer_deferrable(&ghes->timer);
-		ghes_add_timer(ghes);
-		break;
-	case ACPI_HEST_NOTIFY_EXTERNAL:
-		/* External interrupt vector is GSI */
-		rc = acpi_gsi_to_irq(generic->notify.vector, &ghes->irq);
-		if (rc) {
-			pr_err(GHES_PFX "Failed to map GSI to IRQ for generic hardware error source: %d\n",
-			       generic->header.source_id);
-			goto err_edac_unreg;
-		}
-		rc = request_irq(ghes->irq, ghes_irq_func, 0, "GHES IRQ", ghes);
-		if (rc) {
-			pr_err(GHES_PFX "Failed to register IRQ for generic hardware error source: %d\n",
-			       generic->header.source_id);
-			goto err_edac_unreg;
-		}
-		break;
-	case ACPI_HEST_NOTIFY_SCI:
-		mutex_lock(&ghes_list_mutex);
-		if (list_empty(&ghes_sci))
-			register_acpi_hed_notifier(&ghes_notifier_sci);
-		list_add_rcu(&ghes->list, &ghes_sci);
-		mutex_unlock(&ghes_list_mutex);
-		break;
-	case ACPI_HEST_NOTIFY_NMI:
-		len = ghes_esource_prealloc_size(generic);
-		ghes_estatus_pool_expand(len);
-		mutex_lock(&ghes_list_mutex);
-		if (list_empty(&ghes_nmi))
-			register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0,
-						"ghes");
-		list_add_rcu(&ghes->list, &ghes_nmi);
-		mutex_unlock(&ghes_list_mutex);
-		break;
-	default:
-		BUG();
-	}
+	rc = (*ghes_init_call)(ghes);
+	if (rc)
+		goto err_edac_unreg;
+
 	platform_set_drvdata(ghes_dev, ghes);
 
 	return 0;
@@ -1003,44 +1087,16 @@ static int ghes_remove(struct platform_device *ghes_dev)
 {
 	struct ghes *ghes;
 	struct acpi_hest_generic *generic;
-	unsigned long len;
+	void (*ghes_remove_call)(struct ghes *ghes);
 
 	ghes = platform_get_drvdata(ghes_dev);
+	ghes->flags |= GHES_EXITING;
+
 	generic = ghes->generic;
+	ghes_remove_call = ghes_notify_tab[generic->notify.type].remove_call;
 
-	ghes->flags |= GHES_EXITING;
-	switch (generic->notify.type) {
-	case ACPI_HEST_NOTIFY_POLLED:
-		del_timer_sync(&ghes->timer);
-		break;
-	case ACPI_HEST_NOTIFY_EXTERNAL:
-		free_irq(ghes->irq, ghes);
-		break;
-	case ACPI_HEST_NOTIFY_SCI:
-		mutex_lock(&ghes_list_mutex);
-		list_del_rcu(&ghes->list);
-		if (list_empty(&ghes_sci))
-			unregister_acpi_hed_notifier(&ghes_notifier_sci);
-		mutex_unlock(&ghes_list_mutex);
-		break;
-	case ACPI_HEST_NOTIFY_NMI:
-		mutex_lock(&ghes_list_mutex);
-		list_del_rcu(&ghes->list);
-		if (list_empty(&ghes_nmi))
-			unregister_nmi_handler(NMI_LOCAL, "ghes");
-		mutex_unlock(&ghes_list_mutex);
-		/*
-		 * To synchronize with NMI handler, ghes can only be
-		 * freed after NMI handler finishes.
-		 */
-		synchronize_rcu();
-		len = ghes_esource_prealloc_size(generic);
-		ghes_estatus_pool_shrink(len);
-		break;
-	default:
-		BUG();
-		break;
-	}
+	if (ghes_remove_call)
+		(*ghes_remove_call)(ghes);
 
 	ghes_fini(ghes);
 
-- 
1.7.9.5

