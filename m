Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaGVJVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:21:19 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:42298 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbaGVJUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:20:42 -0400
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@alien8.de,
        m.chehab@samsung.com, bp@suse.de, rric@kernel.org
Cc: linux-edac@vger.kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH v5 2/3] acpi, apei, ghes: Make NMI error notification to be GHES architecture extension.
Date: Tue, 22 Jul 2014 11:20:12 +0200
Message-Id: <1406020813-9176-3-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406020813-9176-1-git-send-email-tomasz.nowicki@linaro.org>
References: <1406020813-9176-1-git-send-email-tomasz.nowicki@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently APEI depends on x86 architecture. It is because of NMI hardware
error notification of GHES which is currently supported by x86 only.
However, many other APEI features can be still used perfectly by other
architectures.

This commit adds two symbols:
1. HAVE_ACPI_APEI for those archs which support APEI.
2. HAVE_ACPI_APEI_NMI which is used for NMI code isolation in ghes.c
   file. NMI related data and functions are grouped so they can be wrapped
   inside one #ifdef section. Appropriate function stubs are provided for
   !NMI case.

Note there is no functional changes for x86 due to hard selected
HAVE_ACPI_APEI and HAVE_ACPI_APEI_NMI symbols.

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
---
 arch/x86/Kconfig          |   2 +
 drivers/acpi/apei/Kconfig |   8 ++-
 drivers/acpi/apei/ghes.c  | 149 ++++++++++++++++++++++++++++++----------------
 include/linux/nmi.h       |   4 ++
 4 files changed, 110 insertions(+), 53 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3fc9b12..e7cca5d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -132,6 +132,8 @@ config X86
 	select HAVE_CC_STACKPROTECTOR
 	select GENERIC_CPU_AUTOPROBE
 	select HAVE_ARCH_AUDITSYSCALL
+	select HAVE_ACPI_APEI
+	select HAVE_ACPI_APEI_NMI
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index c4dac71..b0140c8 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -1,9 +1,15 @@
+config HAVE_ACPI_APEI
+	bool
+
+config HAVE_ACPI_APEI_NMI
+	bool
+
 config ACPI_APEI
 	bool "ACPI Platform Error Interface (APEI)"
 	select MISC_FILESYSTEMS
 	select PSTORE
 	select UEFI_CPER
-	depends on X86
+	depends on HAVE_ACPI_APEI
 	help
 	  APEI allows to report errors (for example from the chipset)
 	  to the operating system. This improves NMI handling
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 352170a..7fcf4d7 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -47,11 +47,11 @@
 #include <linux/genalloc.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
+#include <linux/nmi.h>
 
 #include <acpi/ghes.h>
 #include <acpi/apei.h>
 #include <asm/tlbflush.h>
-#include <asm/nmi.h>
 
 #include "apei-internal.h"
 
@@ -86,8 +86,6 @@
 bool ghes_disable;
 module_param_named(disable, ghes_disable, bool, 0);
 
-static int ghes_panic_timeout	__read_mostly = 30;
-
 /*
  * All error sources notified with SCI shares one notifier function,
  * so they need to be linked and checked one by one.  This is applied
@@ -97,16 +95,9 @@ static int ghes_panic_timeout	__read_mostly = 30;
  * list changing, not for traversing.
  */
 static LIST_HEAD(ghes_sci);
-static LIST_HEAD(ghes_nmi);
 static DEFINE_MUTEX(ghes_list_mutex);
 
 /*
- * NMI may be triggered on any CPU, so ghes_nmi_lock is used for
- * mutual exclusion.
- */
-static DEFINE_RAW_SPINLOCK(ghes_nmi_lock);
-
-/*
  * Because the memory area used to transfer hardware error information
  * from BIOS to Linux can be determined only in NMI, IRQ or timer
  * handler, but general ioremap can not be used in atomic context, so
@@ -130,18 +121,8 @@ static struct vm_struct *ghes_ioremap_area;
 static DEFINE_RAW_SPINLOCK(ghes_ioremap_lock_nmi);
 static DEFINE_SPINLOCK(ghes_ioremap_lock_irq);
 
-/*
- * printk is not safe in NMI context.  So in NMI handler, we allocate
- * required memory from lock-less memory allocator
- * (ghes_estatus_pool), save estatus into it, put them into lock-less
- * list (ghes_estatus_llist), then delay printk into IRQ context via
- * irq_work (ghes_proc_irq_work).  ghes_estatus_size_request record
- * required pool size by all NMI error source.
- */
 static struct gen_pool *ghes_estatus_pool;
 static unsigned long ghes_estatus_pool_size_request;
-static struct llist_head ghes_estatus_llist;
-static struct irq_work ghes_proc_irq_work;
 
 struct ghes_estatus_cache *ghes_estatus_caches[GHES_ESTATUS_CACHES_SIZE];
 static atomic_t ghes_estatus_cache_alloced;
@@ -249,11 +230,6 @@ static int ghes_estatus_pool_expand(unsigned long len)
 	return 0;
 }
 
-static void ghes_estatus_pool_shrink(unsigned long len)
-{
-	ghes_estatus_pool_size_request -= PAGE_ALIGN(len);
-}
-
 static struct ghes *ghes_new(struct acpi_hest_generic *generic)
 {
 	struct ghes *ghes;
@@ -732,6 +708,32 @@ static int ghes_notify_sci(struct notifier_block *this,
 	return ret;
 }
 
+static struct notifier_block ghes_notifier_sci = {
+	.notifier_call = ghes_notify_sci,
+};
+
+#ifdef CONFIG_HAVE_ACPI_APEI_NMI
+/*
+ * printk is not safe in NMI context.  So in NMI handler, we allocate
+ * required memory from lock-less memory allocator
+ * (ghes_estatus_pool), save estatus into it, put them into lock-less
+ * list (ghes_estatus_llist), then delay printk into IRQ context via
+ * irq_work (ghes_proc_irq_work).  ghes_estatus_size_request record
+ * required pool size by all NMI error source.
+ */
+static struct llist_head ghes_estatus_llist;
+static struct irq_work ghes_proc_irq_work;
+
+/*
+ * NMI may be triggered on any CPU, so ghes_nmi_lock is used for
+ * mutual exclusion.
+ */
+static DEFINE_RAW_SPINLOCK(ghes_nmi_lock);
+
+static LIST_HEAD(ghes_nmi);
+
+static int ghes_panic_timeout	__read_mostly = 30;
+
 static struct llist_node *llist_nodes_reverse(struct llist_node *llnode)
 {
 	struct llist_node *next, *tail = NULL;
@@ -875,10 +877,6 @@ out:
 	return ret;
 }
 
-static struct notifier_block ghes_notifier_sci = {
-	.notifier_call = ghes_notify_sci,
-};
-
 static unsigned long ghes_esource_prealloc_size(
 	const struct acpi_hest_generic *generic)
 {
@@ -894,11 +892,71 @@ static unsigned long ghes_esource_prealloc_size(
 	return prealloc_size;
 }
 
+static void ghes_estatus_pool_shrink(unsigned long len)
+{
+	ghes_estatus_pool_size_request -= PAGE_ALIGN(len);
+}
+
+static void ghes_nmi_add(struct ghes *ghes)
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
+}
+
+static void ghes_nmi_remove(struct ghes *ghes)
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
+static void ghes_nmi_init_cxt(void)
+{
+	init_irq_work(&ghes_proc_irq_work, ghes_proc_in_irq);
+}
+#else /* CONFIG_HAVE_ACPI_APEI_NMI */
+static inline void ghes_nmi_add(struct ghes *ghes)
+{
+	pr_err(GHES_PFX "ID: %d, trying to add NMI notification which is not supported!\n",
+	       ghes->generic->header.source_id);
+	BUG();
+}
+
+static inline void ghes_nmi_remove(struct ghes *ghes)
+{
+	pr_err(GHES_PFX "ID: %d, trying to remove NMI notification which is not supported!\n",
+	       ghes->generic->header.source_id);
+	BUG();
+}
+
+static inline void ghes_nmi_init_cxt(void)
+{
+}
+#endif /* CONFIG_HAVE_ACPI_APEI_NMI */
+
 static int ghes_probe(struct platform_device *ghes_dev)
 {
 	struct acpi_hest_generic *generic;
 	struct ghes *ghes = NULL;
-	unsigned long len;
+
 	int rc = -EINVAL;
 
 	generic = *(struct acpi_hest_generic **)ghes_dev->dev.platform_data;
@@ -909,7 +967,13 @@ static int ghes_probe(struct platform_device *ghes_dev)
 	case ACPI_HEST_NOTIFY_POLLED:
 	case ACPI_HEST_NOTIFY_EXTERNAL:
 	case ACPI_HEST_NOTIFY_SCI:
+		break;
 	case ACPI_HEST_NOTIFY_NMI:
+		if (!IS_ENABLED(CONFIG_HAVE_ACPI_APEI_NMI)) {
+			pr_warn(GHES_PFX "Generic hardware error source: %d notified via NMI interrupt is not supported!\n",
+				generic->header.source_id);
+			goto err;
+		}
 		break;
 	case ACPI_HEST_NOTIFY_LOCAL:
 		pr_warning(GHES_PFX "Generic hardware error source: %d notified via local interrupt is not supported!\n",
@@ -970,14 +1034,7 @@ static int ghes_probe(struct platform_device *ghes_dev)
 		mutex_unlock(&ghes_list_mutex);
 		break;
 	case ACPI_HEST_NOTIFY_NMI:
-		len = ghes_esource_prealloc_size(generic);
-		ghes_estatus_pool_expand(len);
-		mutex_lock(&ghes_list_mutex);
-		if (list_empty(&ghes_nmi))
-			register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0,
-						"ghes");
-		list_add_rcu(&ghes->list, &ghes_nmi);
-		mutex_unlock(&ghes_list_mutex);
+		ghes_nmi_add(ghes);
 		break;
 	default:
 		BUG();
@@ -999,7 +1056,6 @@ static int ghes_remove(struct platform_device *ghes_dev)
 {
 	struct ghes *ghes;
 	struct acpi_hest_generic *generic;
-	unsigned long len;
 
 	ghes = platform_get_drvdata(ghes_dev);
 	generic = ghes->generic;
@@ -1020,18 +1076,7 @@ static int ghes_remove(struct platform_device *ghes_dev)
 		mutex_unlock(&ghes_list_mutex);
 		break;
 	case ACPI_HEST_NOTIFY_NMI:
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
+		ghes_nmi_remove(ghes);
 		break;
 	default:
 		BUG();
@@ -1075,7 +1120,7 @@ static int __init ghes_init(void)
 		return -EINVAL;
 	}
 
-	init_irq_work(&ghes_proc_irq_work, ghes_proc_in_irq);
+	ghes_nmi_init_cxt();
 
 	rc = ghes_ioremap_init();
 	if (rc)
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 447775e..1d2a6ab 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -63,4 +63,8 @@ extern int proc_dowatchdog(struct ctl_table *, int ,
 			   void __user *, size_t *, loff_t *);
 #endif
 
+#ifdef CONFIG_HAVE_ACPI_APEI_NMI
+#include <asm/nmi.h>
+#endif
+
 #endif
-- 
1.9.1

