Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964841AbaDIPOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:14:32 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:64082 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933893AbaDIPO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:14:26 -0400
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@alien8.de,
        bp@suse.de, m.chehab@samsung.com
Cc: linux-edac@vger.kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH 4/7] acpi, apei, ghes: Factor out NMI error notification context.
Date: Wed,  9 Apr 2014 17:14:32 +0200
Message-Id: <1397056476-9183-5-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397056476-9183-1-git-send-email-tomasz.nowicki@linaro.org>
References: <1397056476-9183-1-git-send-email-tomasz.nowicki@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use CONFIG_ACPI_APEI_NMI to isolate NMI error notification path. NMI related
data and functions are grouped so they can be wrapped inside one

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
---
 drivers/acpi/apei/ghes.c |   54 +++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index ca8387e..7a0d66e 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -53,7 +53,9 @@
 #include <asm/mce.h>
 #endif
 #include <asm/tlbflush.h>
+#ifdef CONFIG_ACPI_APEI_NMI
 #include <asm/nmi.h>
+#endif
 
 #include "apei-internal.h"
 
@@ -88,8 +90,6 @@
 bool ghes_disable;
 module_param_named(disable, ghes_disable, bool, 0);
 
-static int ghes_panic_timeout	__read_mostly = 30;
-
 /*
  * All error sources notified with SCI shares one notifier function,
  * so they need to be linked and checked one by one.  This is applied
@@ -99,16 +99,9 @@ static int ghes_panic_timeout	__read_mostly = 30;
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
@@ -132,18 +125,8 @@ static struct vm_struct *ghes_ioremap_area;
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
@@ -259,11 +242,6 @@ static int ghes_estatus_pool_expand(unsigned long len)
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
@@ -744,6 +722,28 @@ static int ghes_notify_sci(struct notifier_block *this,
 	return ret;
 }
 
+#ifdef CONFIG_ACPI_APEI_NMI
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
@@ -902,6 +902,12 @@ static unsigned long ghes_esource_prealloc_size(
 	return prealloc_size;
 }
 
+static void ghes_estatus_pool_shrink(unsigned long len)
+{
+	ghes_estatus_pool_size_request -= PAGE_ALIGN(len);
+}
+#endif
+
 static int ghes_notify_init_nmi(struct ghes *ghes)
 {
 	unsigned long len;
-- 
1.7.9.5

