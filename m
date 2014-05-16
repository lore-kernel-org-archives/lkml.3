Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832AbaEPNiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:38:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54365 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932737AbaEPNiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:38:11 -0400
Date: Fri, 16 May 2014 06:37:19 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-1d008353ba088fdec0b2a944e140ff9154a5fb20@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tony.luck@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        tony.luck@intel.com
In-Reply-To: <20140507154340.302183048@linutronix.de>
References: <20140507154340.302183048@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Remove irq_reserve_irq[s]
Git-Commit-ID: 1d008353ba088fdec0b2a944e140ff9154a5fb20
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d008353ba088fdec0b2a944e140ff9154a5fb20
Gitweb:     http://git.kernel.org/tip/1d008353ba088fdec0b2a944e140ff9154a5fb20
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:21 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:22 +0200

genirq: Remove irq_reserve_irq[s]

No more users. And it's not going to come back. If you need
hotplugable irq chips, use irq domains.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-and-acked-by: Grant Likely <grant.likely@linaro.org>
Tested-by: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140507154340.302183048@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h  |  7 -------
 kernel/irq/irqdesc.c | 25 -------------------------
 2 files changed, 32 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index ac96342..2110f46 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -617,18 +617,11 @@ int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 	irq_alloc_descs(-1, from, cnt, node)
 
 void irq_free_descs(unsigned int irq, unsigned int cnt);
-int irq_reserve_irqs(unsigned int from, unsigned int cnt);
-
 static inline void irq_free_desc(unsigned int irq)
 {
 	irq_free_descs(irq, 1);
 }
 
-static inline int irq_reserve_irq(unsigned int irq)
-{
-	return irq_reserve_irqs(irq, 1);
-}
-
 #ifdef CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
 unsigned int irq_alloc_hwirqs(int cnt, int node);
 static inline unsigned int irq_alloc_hwirq(int node)
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 2402934..d514ed6 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -455,31 +455,6 @@ EXPORT_SYMBOL_GPL(irq_free_hwirqs);
 #endif
 
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
