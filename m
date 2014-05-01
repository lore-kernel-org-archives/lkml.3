Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaEAXVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 19:21:12 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40219 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbaEAXS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 19:18:57 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 5/8] irq: Kill irq_reserve_irq/irq_reserve_irqs
Date: Thu,  1 May 2014 16:18:19 -0700
Message-Id: <1398986302-30455-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1398986302-30455-1-git-send-email-yinghai@kernel.org>
References: <1398986302-30455-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No user any more.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/irq.h  |  6 ------
 kernel/irq/irqdesc.c | 25 -------------------------
 2 files changed, 31 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 28cbd3e..02dc0e4 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -623,7 +623,6 @@ int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 	irq_alloc_descs(-1, from, cnt, node)
 
 void irq_free_descs(unsigned int irq, unsigned int cnt);
-int irq_reserve_irqs(unsigned int from, unsigned int cnt);
 int arch_probe_early_allocate_nr_irqs(void);
 
 static inline void irq_free_desc(unsigned int irq)
@@ -631,11 +630,6 @@ static inline void irq_free_desc(unsigned int irq)
 	irq_free_descs(irq, 1);
 }
 
-static inline int irq_reserve_irq(unsigned int irq)
-{
-	return irq_reserve_irqs(irq, 1);
-}
-
 #ifndef irq_reg_writel
 # define irq_reg_writel(val, addr)	writel(val, addr)
 #endif
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index dfb971c..49bf891 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -400,31 +400,6 @@ err:
 EXPORT_SYMBOL_GPL(__irq_alloc_descs);
 
 /**
- * irq_reserve_irqs - mark irqs allocated
- * @from:	mark from irq number
- * @cnt:	number of irqs to mark
- *
- * Returns 0 on success or an appropriate error code
- */
-int irq_reserve_irqs(unsigned int from, unsigned int cnt)
-{
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
-}
-
-/**
  * irq_get_next_irq - get next allocated irq number
  * @offset:	where to start the search
  *
-- 
1.8.4.5

