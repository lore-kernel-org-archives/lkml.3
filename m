Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933719AbaEFBeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:34:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:36663 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933701AbaEFBeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:34:13 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v3 7/8] irq: Add irq_alloc_reserved_desc()
Date: Mon,  5 May 2014 18:33:25 -0700
Message-Id: <1399340006-31550-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1399340006-31550-1-git-send-email-yinghai@kernel.org>
References: <1399340006-31550-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For ioapic hot-add support, it would be easy if we have continuous
irq numbers for hot added ioapic controller.

We can reserve irq range at first, and later allocate desc for those
pre-reserved irqs when they are needed.

The reasons for not allocating them during reserving:
1. only several pins of one ioapic are used, allocate for all pins, will
   waste memory for not used pins.
2. allocate later when is needed could make sure irq_desc is allocated
   on local node ram, as dev->node is set at that point.

-v2: update changelog by adding reasons, requested by Konrad.
-v3: according to tglx:
       separate core code change with arch code change.
       change function name to irq_alloc_reserved_desc.
       kill __irq_is_reserved().
       remove not need exports.
     according to Sebastian:
       spare one comments by put two functions together.
-v4: Fix the bug that tglx pointed out.
     irq_alloc_descs() should avoid reserved irqs.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 include/linux/irq.h  |  3 ++
 kernel/irq/irqdesc.c | 97 ++++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 74 insertions(+), 26 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 2ba3245..97b60b9 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -608,10 +608,13 @@ int irq_mark_reserved_irqs(int irq, unsigned int from, unsigned int cnt);
 
 int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 		struct module *owner);
+int __irq_alloc_reserved_desc(int at, int node, struct module *owner);
 
 /* use macros to avoid needing export.h for THIS_MODULE */
 #define irq_alloc_descs(irq, from, cnt, node)	\
 	__irq_alloc_descs(irq, from, cnt, node, THIS_MODULE)
+#define irq_alloc_reserved_desc_at(at, node)	\
+	__irq_alloc_reserved_desc(at, node, THIS_MODULE)
 
 #define irq_alloc_desc(node)			\
 	irq_alloc_descs(-1, 0, 1, node)
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index d55297a..7b2b83a 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -352,21 +352,11 @@ void irq_free_descs(unsigned int from, unsigned int cnt)
 }
 EXPORT_SYMBOL_GPL(irq_free_descs);
 
-/**
- * irq_alloc_descs - allocate and initialize a range of irq descriptors
- * @irq:	Allocate for specific irq number if irq >= 0
- * @from:	Start the search from this irq number
- * @cnt:	Number of consecutive irqs to allocate.
- * @node:	Preferred node on which the irq descriptor should be allocated
- * @owner:	Owning module (can be NULL)
- *
- * Returns the first irq number or error code
- */
-int __ref
-__irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
-		  struct module *owner)
+/* Should be used with sparse_irq_lock */
+static int __irq_mark_allocated_irqs(int irq, unsigned int from,
+				     unsigned int cnt, int avoid_reserved)
 {
-	int start, ret;
+	int start;
 
 	if (!cnt)
 		return -EINVAL;
@@ -377,26 +367,55 @@ __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 		from = irq;
 	}
 
-	mutex_lock(&sparse_irq_lock);
+	if (avoid_reserved) {
+		bitmap_or(reserved_or_allocated_irqs, reserved_irqs,
+			  allocated_irqs, IRQ_BITMAP_BITS);
 
-	start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,
-					   from, cnt, 0);
-	ret = -EEXIST;
-	if (irq >=0 && start != irq)
-		goto err;
+		start = bitmap_find_next_zero_area(reserved_or_allocated_irqs,
+							IRQ_BITMAP_BITS,
+							from, cnt, 0);
+	} else
+		start = bitmap_find_next_zero_area(allocated_irqs,
+							IRQ_BITMAP_BITS,
+							from, cnt, 0);
+
+	if (irq >= 0 && start != irq)
+		return -EEXIST;
 
 	if (start + cnt > nr_irqs) {
-		ret = irq_expand_nr_irqs(start + cnt);
-		if (ret)
-			goto err;
+		int ret = irq_expand_nr_irqs(start + cnt);
+
+		if (ret < 0)
+			return ret;
 	}
 
 	bitmap_set(allocated_irqs, start, cnt);
-	mutex_unlock(&sparse_irq_lock);
-	return alloc_descs(start, cnt, node, owner);
 
-err:
+	return start;
+}
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
+{	int ret;
+
+	mutex_lock(&sparse_irq_lock);
+	ret = __irq_mark_allocated_irqs(irq, from, cnt, 1);
 	mutex_unlock(&sparse_irq_lock);
+
+	if (ret >= 0)
+		return alloc_descs(ret, cnt, node, owner);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(__irq_alloc_descs);
@@ -464,6 +483,32 @@ err:
 	return ret;
 }
 
+ /**
+ * __irq_alloc_reserved_desc - allocate irq descriptor for irq that is already reserved
+ * @irq:	Allocate for specific irq number if irq >= 0
+ * @node:	Preferred node on which the irq descriptor should be allocated
+ * @owner:	Owning module (can be NULL)
+ *
+ * Returns the irq number or error code
+ */
+int __ref __irq_alloc_reserved_desc(int irq, int node, struct module *owner)
+{
+	int ret = -EINVAL;
+
+	if (irq < 0 || irq >= nr_irqs)
+		return -EINVAL;
+
+	mutex_lock(&sparse_irq_lock);
+	if (test_bit(irq, reserved_irqs))
+		ret = __irq_mark_allocated_irqs(irq, irq, 1, 0);
+	mutex_unlock(&sparse_irq_lock);
+
+	if (ret >= 0)
+		return alloc_descs(ret, 1, node, owner);
+
+	return ret;
+}
+
 /**
  * irq_get_next_irq - get next allocated irq number
  * @offset:	where to start the search
-- 
1.8.4.5

