Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab3DXJdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:33:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39188 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab3DXJdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:33:05 -0400
Date: Wed, 24 Apr 2013 02:32:35 -0700
From: tip-bot for Joonsoo Kim <tipbot@zytor.com>
Message-ID: <tip-f1cd0858100c67273f2c74344e0c464344c4a982@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@kernel.org, davidlohr.bueso@hp.com, a.p.zijlstra@chello.nl,
        peterz@infradead.org, jason.low2@hp.com, tglx@linutronix.de,
        iamjoonsoo.kim@lge.com
Reply-To: mingo@kernel.org, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, davidlohr.bueso@hp.com,
        a.p.zijlstra@chello.nl, peterz@infradead.org, jason.low2@hp.com,
        iamjoonsoo.kim@lge.com, tglx@linutronix.de
In-Reply-To: <1366705662-3587-2-git-send-email-iamjoonsoo.kim@lge.com>
References: <1366705662-3587-2-git-send-email-iamjoonsoo.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Change position of resched_cpu()
  in load_balance()
Git-Commit-ID: f1cd0858100c67273f2c74344e0c464344c4a982
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

Commit-ID:  f1cd0858100c67273f2c74344e0c464344c4a982
Gitweb:     http://git.kernel.org/tip/f1cd0858100c67273f2c74344e0c464344c4a982
Author:     Joonsoo Kim <iamjoonsoo.kim@lge.com>
AuthorDate: Tue, 23 Apr 2013 17:27:37 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Apr 2013 08:52:43 +0200

sched: Change position of resched_cpu() in load_balance()

cur_ld_moved is reset if env.flags hit LBF_NEED_BREAK.
So, there is possibility that we miss doing resched_cpu().
Correct it as changing position of resched_cpu()
before checking LBF_NEED_BREAK.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Tested-by: Jason Low <jason.low2@hp.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1366705662-3587-2-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1c97735..25aaf93 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5080,17 +5080,17 @@ more_balance:
 		double_rq_unlock(env.dst_rq, busiest);
 		local_irq_restore(flags);
 
-		if (env.flags & LBF_NEED_BREAK) {
-			env.flags &= ~LBF_NEED_BREAK;
-			goto more_balance;
-		}
-
 		/*
 		 * some other cpu did the load balance for us.
 		 */
 		if (cur_ld_moved && env.dst_cpu != smp_processor_id())
 			resched_cpu(env.dst_cpu);
 
+		if (env.flags & LBF_NEED_BREAK) {
+			env.flags &= ~LBF_NEED_BREAK;
+			goto more_balance;
+		}
+
 		/*
 		 * Revisit (affine) tasks on src_cpu that couldn't be moved to
 		 * us and move them to an alternate dst_cpu in our sched_group
