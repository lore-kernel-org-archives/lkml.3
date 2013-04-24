Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab3DXJeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:34:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39229 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877Ab3DXJeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:34:12 -0400
Date: Wed, 24 Apr 2013 02:33:48 -0700
From: tip-bot for Joonsoo Kim <tipbot@zytor.com>
Message-ID: <tip-de5eb2dd7f171ee8a45d23cd41aa2efe9ab922b3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@kernel.org, davidlohr.bueso@hp.com, a.p.zijlstra@chello.nl,
        peterz@infradead.org, jason.low2@hp.com, tglx@linutronix.de,
        iamjoonsoo.kim@lge.com
Reply-To: mingo@kernel.org, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, davidlohr.bueso@hp.com,
        a.p.zijlstra@chello.nl, peterz@infradead.org, jason.low2@hp.com,
        iamjoonsoo.kim@lge.com, tglx@linutronix.de
In-Reply-To: <1366705662-3587-3-git-send-email-iamjoonsoo.kim@lge.com>
References: <1366705662-3587-3-git-send-email-iamjoonsoo.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Explicitly cpu_idle_type checking in rebalance_domains()
Git-Commit-ID: de5eb2dd7f171ee8a45d23cd41aa2efe9ab922b3
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

Commit-ID:  de5eb2dd7f171ee8a45d23cd41aa2efe9ab922b3
Gitweb:     http://git.kernel.org/tip/de5eb2dd7f171ee8a45d23cd41aa2efe9ab922b3
Author:     Joonsoo Kim <iamjoonsoo.kim@lge.com>
AuthorDate: Tue, 23 Apr 2013 17:27:38 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Apr 2013 08:52:43 +0200

sched: Explicitly cpu_idle_type checking in rebalance_domains()

After commit 88b8dac0, dst-cpu can be changed in load_balance(),
then we can't know cpu_idle_type of dst-cpu when load_balance()
return positive. So, add explicit cpu_idle_type checking.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Tested-by: Jason Low <jason.low2@hp.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1366705662-3587-3-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 25aaf93..726e129 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5523,10 +5523,11 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
 			if (load_balance(cpu, rq, sd, idle, &balance)) {
 				/*
-				 * We've pulled tasks over so either we're no
-				 * longer idle.
+				 * The LBF_SOME_PINNED logic could have changed
+				 * env->dst_cpu, so we can't know our idle
+				 * state even if we migrated tasks. Update it.
 				 */
-				idle = CPU_NOT_IDLE;
+				idle = idle_cpu(cpu) ? CPU_IDLE : CPU_NOT_IDLE;
 			}
 			sd->last_balance = jiffies;
 		}
