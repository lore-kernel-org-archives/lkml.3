Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaEAXTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 19:19:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40311 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbaEAXTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 19:19:20 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 7/8] irq: Add irq_alloc_reserved_desc()
Date: Thu,  1 May 2014 16:18:21 -0700
Message-Id: <1398986302-30455-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1398986302-30455-1-git-send-email-yinghai@kernel.org>
References: <1398986302-30455-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
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

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 include/linux/irq.h  |  3 +++
 kernel/irq/irqdesc.c | 23 +++++++++++++++++++++++
 2 files changed, 26 insertions(+)

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
index 865ebc0..1a7e663 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -467,6 +467,29 @@ err:
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
+	if (irq < 0)
+		return -EINVAL;
+
+	mutex_lock(&sparse_irq_lock);
+	if (!test_bit(irq, reserved_irqs)) {
+		mutex_unlock(&sparse_irq_lock);
+		return -EINVAL;
+	}
+	mutex_unlock(&sparse_irq_lock);
+
+	return __irq_alloc_descs(irq, irq, 1, node, owner);
+}
+
 /**
  * irq_get_next_irq - get next allocated irq number
  * @offset:	where to start the search
-- 
1.8.4.5

