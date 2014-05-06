Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669AbaEFBeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:34:03 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29210 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933466AbaEFBeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:34:00 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 6/8] irq: Add new reserved_irqs clear/mark functions
Date: Mon,  5 May 2014 18:33:24 -0700
Message-Id: <1399340006-31550-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1399340006-31550-1-git-send-email-yinghai@kernel.org>
References: <1399340006-31550-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for ioapic hotplug.

-v2: Add reserved_or_allocated_irqs to simplify the code.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/irq.h  |  3 +++
 kernel/irq/irqdesc.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 02dc0e4..2ba3245 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -603,6 +603,9 @@ static inline u32 irq_get_trigger_type(unsigned int irq)
 	return d ? irqd_get_trigger_type(d) : 0;
 }
 
+int irq_clear_reserved_irqs(unsigned int from, unsigned int cnt);
+int irq_mark_reserved_irqs(int irq, unsigned int from, unsigned int cnt);
+
 int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 		struct module *owner);
 
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 49bf891..d55297a 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -98,6 +98,8 @@ EXPORT_SYMBOL_GPL(nr_irqs);
 
 static DEFINE_MUTEX(sparse_irq_lock);
 static DECLARE_BITMAP(allocated_irqs, IRQ_BITMAP_BITS);
+static DECLARE_BITMAP(reserved_irqs, IRQ_BITMAP_BITS);
+static DECLARE_BITMAP(reserved_or_allocated_irqs, IRQ_BITMAP_BITS);
 
 #ifdef CONFIG_SPARSE_IRQ
 
@@ -400,6 +402,69 @@ err:
 EXPORT_SYMBOL_GPL(__irq_alloc_descs);
 
 /**
+ * irq_clear_reserved_irqs - clear irqs reserved
+ * @from:	clear from irq number
+ * @cnt:	number of irqs to clear
+ *
+ * Returns 0 on success or an appropriate error code
+ */
+int irq_clear_reserved_irqs(unsigned int from, unsigned int cnt)
+{
+	if (!cnt || (from + cnt) > nr_irqs)
+		return -EINVAL;
+
+	mutex_lock(&sparse_irq_lock);
+	bitmap_clear(reserved_irqs, from, cnt);
+	mutex_unlock(&sparse_irq_lock);
+
+	return 0;
+}
+
+/**
+ * irq_mark_reserved_irqs - mark irqs reserved
+ * @irq:	Reserve for specific irq number if irq >= 0
+ * @from:	mark from irq number
+ * @cnt:	number of irqs to mark
+ *
+ * Returns the first irq number or error code
+ */
+int irq_mark_reserved_irqs(int irq, unsigned int from, unsigned int cnt)
+{
+	int start, ret;
+
+	if (!cnt)
+		return -EINVAL;
+
+	if (irq >= 0) {
+		if (from > irq)
+			return -EINVAL;
+		from = irq;
+	}
+
+	mutex_lock(&sparse_irq_lock);
+	bitmap_or(reserved_or_allocated_irqs, reserved_irqs, allocated_irqs,
+			 IRQ_BITMAP_BITS);
+	start = bitmap_find_next_zero_area(reserved_or_allocated_irqs,
+					   IRQ_BITMAP_BITS, from, cnt, 0);
+	ret = -EEXIST;
+	if (irq >= 0 && start != irq)
+		goto err;
+
+	if (start + cnt > nr_irqs) {
+		ret = irq_expand_nr_irqs(start + cnt);
+		if (ret < 0)
+			goto err;
+	}
+
+	bitmap_set(reserved_irqs, start, cnt);
+	ret = start;
+
+err:
+	mutex_unlock(&sparse_irq_lock);
+	return ret;
+}
+
+/**
  * irq_get_next_irq - get next allocated irq number
  * @offset:	where to start the search
  *
-- 
1.8.4.5

