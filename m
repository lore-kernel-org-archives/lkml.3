Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946951Ab3BHT2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:28:53 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:33292 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760228Ab3BHT2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:28:51 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 11/26] genirq: Split __irq_reserve_irqs from irq_alloc_descs
Date: Fri,  8 Feb 2013 11:28:08 -0800
Message-Id: <1360351703-20571-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_alloc_descs and irq_reserve_irqs are almost the same.
Separate code out to __irq_reserved_irqs, and other two reuse
__irq_reserve_irqs.

And will use __irq_reserve_irqs for coming ioapic hotplug support.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/irq.h  |    1 +
 kernel/irq/irqdesc.c |   54 +++++++++++++++++++++++++++++---------------------
 2 files changed, 32 insertions(+), 23 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index bc4e066..4e0fcbb 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -600,6 +600,7 @@ int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 
 void irq_free_descs(unsigned int irq, unsigned int cnt);
 int irq_reserve_irqs(unsigned int from, unsigned int cnt);
+int __irq_reserve_irqs(int irq, unsigned int from, unsigned int cnt);
 
 static inline void irq_free_desc(unsigned int irq)
 {
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 192a302..3b9fb92 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -340,18 +340,15 @@ void irq_free_descs(unsigned int from, unsigned int cnt)
 EXPORT_SYMBOL_GPL(irq_free_descs);
 
 /**
- * irq_alloc_descs - allocate and initialize a range of irq descriptors
- * @irq:	Allocate for specific irq number if irq >= 0
+ * __irq_reserve_descs - reserve and initialize a range of irq descriptors
+ * @irq:	Reserve for specific irq number if irq >= 0
  * @from:	Start the search from this irq number
- * @cnt:	Number of consecutive irqs to allocate.
- * @node:	Preferred node on which the irq descriptor should be allocated
- * @owner:	Owning module (can be NULL)
+ * @cnt:	Number of consecutive irqs to reserve.
  *
  * Returns the first irq number or error code
  */
 int __ref
-__irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
-		  struct module *owner)
+__irq_reserve_irqs(int irq, unsigned int from, unsigned int cnt)
 {
 	int start, ret;
 
@@ -369,7 +366,7 @@ __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 	start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,
 					   from, cnt, 0);
 	ret = -EEXIST;
-	if (irq >=0 && start != irq)
+	if (irq >= 0 && start != irq)
 		goto err;
 
 	if (start + cnt > nr_irqs) {
@@ -380,12 +377,36 @@ __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 
 	bitmap_set(allocated_irqs, start, cnt);
 	mutex_unlock(&sparse_irq_lock);
-	return alloc_descs(start, cnt, node, owner);
+	return start;
 
 err:
 	mutex_unlock(&sparse_irq_lock);
 	return ret;
 }
+
+/**
+ * irq_alloc_descs - allocate and initialize a range of irq descriptors
+ * @irq:	Allocate for specific irq number if irq >= 0
+ * @from:	Start the search from this irq number
+ * @cnt:	Number of consecutive irqs to allocate.
+ * @node:	Preferred node on which the irq descriptor should be allocated
+ * @owner:	Owning module (can be NULL)
+ *
+ * Returns the first irq number or error code
+ */
+int __ref
+__irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
+		  struct module *owner)
+{
+	int start;
+
+	start = __irq_reserve_irqs(irq, from, cnt);
+
+	if (start < 0)
+		return start;
+
+	return alloc_descs(start, cnt, node, owner);
+}
 EXPORT_SYMBOL_GPL(__irq_alloc_descs);
 
 /**
@@ -397,20 +418,7 @@ EXPORT_SYMBOL_GPL(__irq_alloc_descs);
  */
 int irq_reserve_irqs(unsigned int from, unsigned int cnt)
 {
-	unsigned int start;
-	int ret = 0;
-
-	if (!cnt || (from + cnt) > nr_irqs)
-		return -EINVAL;
-
-	mutex_lock(&sparse_irq_lock);
-	start = bitmap_find_next_zero_area(allocated_irqs, nr_irqs, from, cnt, 0);
-	if (start == from)
-		bitmap_set(allocated_irqs, start, cnt);
-	else
-		ret = -EEXIST;
-	mutex_unlock(&sparse_irq_lock);
-	return ret;
+	return __irq_reserve_irqs(from, from, cnt);
 }
 
 /**
-- 
1.7.10.4

