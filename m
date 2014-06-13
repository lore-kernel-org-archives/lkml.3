Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaFMLDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 07:03:39 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:51792 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbaFMLD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 07:03:27 -0400
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@alien8.de,
        m.chehab@samsung.com, bp@suse.de
Cc: linux-edac@vger.kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        rric@kernel.org, Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH v3 3/5] acpi, apei, ghes: Introduce more generic mechanism to init/deinit GHES error notifications.
Date: Fri, 13 Jun 2014 13:02:58 +0200
Message-Id: <1402657380-18539-4-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402657380-18539-1-git-send-email-tomasz.nowicki@linaro.org>
References: <1402657380-18539-1-git-send-email-tomasz.nowicki@linaro.org>
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
we will avoid #ifdef usage in common code for NMI which is currently
supported by x86.

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
---
 drivers/acpi/apei/ghes.c |  271 +++++++++++++++++++++++++++++-----------------
 1 file changed, 174 insertions(+), 97 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index e7dc5c6..6db5110 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -146,6 +146,14 @@ static struct irq_work ghes_proc_irq_work;
 struct ghes_estatus_cache *ghes_estatus_caches[GHES_ESTATUS_CACHES_SIZE];
 static atomic_t ghes_estatus_cache_alloced;
 
+struct ghes_notify_setup {
+	const char *notif_name;
+	int (*init_call)(struct ghes *ghes);
+	void (*remove_call)(struct ghes *ghes);
+};
+
+static struct ghes_notify_setup	ghes_notify_tab[];
+
 static int ghes_ioremap_init(void)
 {
 	ghes_ioremap_area = __get_vm_area(PAGE_SIZE * GHES_IOREMAP_PAGES,
@@ -811,6 +819,8 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 	int sev, sev_global = -1;
 	int ret = NMI_DONE;
 
+	BUG_ON(!IS_ENABLED(ARCH_HAS_ACPI_APEI_NMI));
+
 	raw_spin_lock(&ghes_nmi_lock);
 	list_for_each_entry_rcu(ghes, &ghes_nmi, list) {
 		if (ghes_read_estatus(ghes, 1)) {
@@ -875,10 +885,6 @@ out:
 	return ret;
 }
 
-static struct notifier_block ghes_notifier_sci = {
-	.notifier_call = ghes_notify_sci,
-};
-
 static unsigned long ghes_esource_prealloc_size(
 	const struct acpi_hest_generic *generic)
 {
@@ -894,39 +900,169 @@ static unsigned long ghes_esource_prealloc_size(
 	return prealloc_size;
 }
 
+static int ghes_notify_init_nmi(struct ghes *ghes)
+{
+	unsigned long len;
+	int status = 0;
+
+	len = ghes_esource_prealloc_size(ghes->generic);
+	ghes_estatus_pool_expand(len);
+	mutex_lock(&ghes_list_mutex);
+	if (list_empty(&ghes_nmi))
+		status = register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0,
+					      "ghes");
+	list_add_rcu(&ghes->list, &ghes_nmi);
+	mutex_unlock(&ghes_list_mutex);
+
+	return status;
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
+static void ghes_init_nmi(void)
+{
+	if (!IS_ENABLED(ARCH_HAS_ACPI_APEI_NMI))
+		return;
+
+	init_irq_work(&ghes_proc_irq_work, ghes_proc_in_irq);
+	ghes_notify_tab[ACPI_HEST_NOTIFY_NMI].init_call = ghes_notify_init_nmi;
+	ghes_notify_tab[ACPI_HEST_NOTIFY_NMI].remove_call =
+							ghes_notify_remove_nmi;
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
+		pr_err(GHES_PFX "Failed to map GSI to IRQ for generic hardware error source: %d\n",
+		       ghes->generic->header.source_id);
+		goto out;
+	}
+
+	rc = request_irq(ghes->irq, ghes_irq_func, 0, "GHES IRQ", ghes);
+	if (rc)
+		pr_err(GHES_PFX "Failed to register IRQ for generic hardware error source: %d\n",
+		       ghes->generic->header.source_id);
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
+		[ACPI_HEST_NOTIFY_NMI]      = {"NMI", NULL, NULL},
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
+	u8 notify_type;
+
 
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
+	notify_type = generic->notify.type;
+	if (notify_type >= ACPI_HEST_NOTIFY_RESERVED) {
+		pr_warn(FW_WARN GHES_PFX "Unknown notification type: %u for generic hardware error source: %d\n",
+			notify_type, generic->header.source_id);
 		goto err;
-	default:
-		pr_warning(FW_WARN GHES_PFX "Unknown notification type: %u for generic hardware error source: %d\n",
-			   generic->notify.type, generic->header.source_id);
+	}
+
+	ghes_init_call = ghes_notify_tab[notify_type].init_call;
+	ghes_notif_name = ghes_notify_tab[notify_type].notif_name;
+	if (!ghes_init_call) {
+		pr_warn(GHES_PFX "Generic hardware error source: %d notified via %s is not supported!\n",
+			generic->header.source_id, ghes_notif_name);
 		goto err;
 	}
 
 	rc = -EIO;
 	if (generic->error_block_length <
 	    sizeof(struct acpi_generic_status)) {
-		pr_warning(FW_BUG GHES_PFX "Invalid error block length: %u for generic hardware error source: %d\n",
-			   generic->error_block_length,
-			   generic->header.source_id);
+		pr_warn(FW_BUG GHES_PFX "Invalid error block length: %u for generic hardware error source: %d\n",
+			generic->error_block_length,
+			generic->header.source_id);
 		goto err;
 	}
 	ghes = ghes_new(generic);
@@ -940,48 +1076,10 @@ static int ghes_probe(struct platform_device *ghes_dev)
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
@@ -999,45 +1097,24 @@ static int ghes_remove(struct platform_device *ghes_dev)
 {
 	struct ghes *ghes;
 	struct acpi_hest_generic *generic;
-	unsigned long len;
+	void (*ghes_remove_call)(struct ghes *ghes);
+	u8 notify_type;
 
 	ghes = platform_get_drvdata(ghes_dev);
-	generic = ghes->generic;
-
 	ghes->flags |= GHES_EXITING;
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
+
+	generic = ghes->generic;
+	notify_type = generic->notify.type;
+	if (notify_type >= ACPI_HEST_NOTIFY_RESERVED) {
+		pr_warn(FW_WARN GHES_PFX "Unknown notification type: %u for generic hardware error source: %d\n",
+			notify_type, generic->header.source_id);
+		return -EINVAL;
 	}
 
+	ghes_remove_call = ghes_notify_tab[notify_type].remove_call;
+	if (ghes_remove_call)
+		(*ghes_remove_call)(ghes);
+
 	ghes_fini(ghes);
 
 	ghes_edac_unregister(ghes);
@@ -1075,7 +1152,7 @@ static int __init ghes_init(void)
 		return -EINVAL;
 	}
 
-	init_irq_work(&ghes_proc_irq_work, ghes_proc_in_irq);
+	ghes_init_nmi();
 
 	rc = ghes_ioremap_init();
 	if (rc)
-- 
1.7.9.5

