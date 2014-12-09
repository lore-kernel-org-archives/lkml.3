Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbaLIKSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:18:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52359 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923AbaLIKSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:18:31 -0500
Date: Tue, 9 Dec 2014 02:17:54 -0800
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-fd7de1e8d5b2b2b35e71332fafb899f584597150@git.kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com,
        peterz@infradead.org, luto@amacapital.net, tglx@linutronix.de,
        mingo@kernel.org
Reply-To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, chuansheng.liu@intel.com,
        peterz@infradead.org, luto@amacapital.net
In-Reply-To: <729365dddca178506dfd0a9451006344cd6808bc.1417277372.git.luto@amacapital.net>
References: <729365dddca178506dfd0a9451006344cd6808bc.1417277372.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Add missing rcu protection to wake_up_all_idle_cpus
Git-Commit-ID: fd7de1e8d5b2b2b35e71332fafb899f584597150
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

Commit-ID:  fd7de1e8d5b2b2b35e71332fafb899f584597150
Gitweb:     http://git.kernel.org/tip/fd7de1e8d5b2b2b35e71332fafb899f584597150
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Sat, 29 Nov 2014 08:13:51 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 8 Dec 2014 11:44:19 +0100

sched: Add missing rcu protection to wake_up_all_idle_cpus

Locklessly doing is_idle_task(rq->curr) is only okay because of
RCU protection.  The older variant of the broken code checked
rq->curr == rq->idle instead and therefore didn't need RCU.

Fixes: f6be8af1c95d ("sched: Add new API wake_up_if_idle() to wake up the idle cpu")
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Reviewed-by: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/729365dddca178506dfd0a9451006344cd6808bc.1417277372.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d44d0c5..88f49bc 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1628,8 +1628,10 @@ void wake_up_if_idle(int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
 
-	if (!is_idle_task(rq->curr))
-		return;
+	rcu_read_lock();
+
+	if (!is_idle_task(rcu_dereference(rq->curr)))
+		goto out;
 
 	if (set_nr_if_polling(rq->idle)) {
 		trace_sched_wake_idle_without_ipi(cpu);
@@ -1640,6 +1642,9 @@ void wake_up_if_idle(int cpu)
 		/* Else cpu is not in idle, do nothing here */
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
 	}
+
+out:
+	rcu_read_unlock();
 }
 
 bool cpus_share_cache(int this_cpu, int that_cpu)
