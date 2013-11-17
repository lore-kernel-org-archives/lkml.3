Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab3KQJzx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 04:55:53 -0500
Received: from smtprelay0237.hostedemail.com ([216.40.44.237]:58696 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752464Ab3KQJzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 04:55:18 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3871:4321:4605:5007:6119:6120:6261:7875:7901:7903:7904:9592:10004:10026:10848:11026:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:13868,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: drain29_10f6de1030f1e
X-Filterd-Recvd-Size: 2859
From: Joe Perches <joe@perches.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] softirq: Use ffs in __do_softirq
Date: Sun, 17 Nov 2013 01:55:10 -0800
Message-Id: <8d10077333476c5c0e054cf060006999cf150f0c.1384656563.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1384656563.git.joe@perches.com>
References: <cover.1384656563.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Possible speed improvement of the __do_softirq function by using ffs
instead of using a while loop with an & 1 test then single bit shift.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/softirq.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 11025cc..7be95d7 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -219,6 +219,7 @@ asmlinkage void __do_softirq(void)
 	int cpu;
 	unsigned long old_flags = current->flags;
 	int max_restart = MAX_SOFTIRQ_RESTART;
+	int softirq_bit;
 
 	/*
 	 * Mask out PF_MEMALLOC s current task context is borrowed for the
@@ -242,30 +243,30 @@ restart:
 
 	h = softirq_vec;
 
-	do {
-		if (pending & 1) {
-			unsigned int vec_nr = h - softirq_vec;
-			int prev_count = preempt_count();
-
-			kstat_incr_softirqs_this_cpu(vec_nr);
-
-			trace_softirq_entry(vec_nr);
-			h->action(h);
-			trace_softirq_exit(vec_nr);
-			if (unlikely(prev_count != preempt_count())) {
-				printk(KERN_ERR "huh, entered softirq %u %s %p"
-				       "with preempt_count %08x,"
-				       " exited with %08x?\n", vec_nr,
-				       softirq_to_name[vec_nr], h->action,
-				       prev_count, preempt_count());
-				preempt_count_set(prev_count);
-			}
+	while ((softirq_bit = ffs(pending))) {
+		unsigned int vec_nr;
+		int prev_count;
+
+		h += softirq_bit - 1;
+
+		vec_nr = h - softirq_vec;
+		prev_count = preempt_count();
 
-			rcu_bh_qs(cpu);
+		kstat_incr_softirqs_this_cpu(vec_nr);
+
+		trace_softirq_entry(vec_nr);
+		h->action(h);
+		trace_softirq_exit(vec_nr);
+		if (unlikely(prev_count != preempt_count())) {
+			printk(KERN_ERR "huh, entered softirq %u %s %p with preempt_count %08x, exited with %08x?\n",
+			       vec_nr, softirq_to_name[vec_nr], h->action,
+			       prev_count, preempt_count());
+			preempt_count_set(prev_count);
 		}
+		rcu_bh_qs(cpu);
 		h++;
-		pending >>= 1;
-	} while (pending);
+		pending >>= softirq_bit;
+	}
 
 	local_irq_disable();
 
-- 
1.8.1.2.459.gbcd45b4.dirty

