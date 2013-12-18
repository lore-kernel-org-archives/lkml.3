Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab3LRKcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:32:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44674 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab3LRKcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:32:46 -0500
Date: Wed, 18 Dec 2013 02:32:10 -0800
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-757dfcaa41844595964f1220f1d33182dae49976@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de
In-Reply-To: <49231385567953@web4m.yandex.ru>
References: <49231385567953@web4m.yandex.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt: Fix rq's cpupri leak while enqueue/
 dequeue child RT entities
Git-Commit-ID: 757dfcaa41844595964f1220f1d33182dae49976
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 18 Dec 2013 02:32:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  757dfcaa41844595964f1220f1d33182dae49976
Gitweb:     http://git.kernel.org/tip/757dfcaa41844595964f1220f1d33182dae49976
Author:     Kirill Tkhai <tkhai@yandex.ru>
AuthorDate: Wed, 27 Nov 2013 19:59:13 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 17 Dec 2013 15:08:44 +0100

sched/rt: Fix rq's cpupri leak while enqueue/dequeue child RT entities

This patch touches the RT group scheduling case.

Functions inc_rt_prio_smp() and dec_rt_prio_smp() change (global) rq's
priority, while rt_rq passed to them may be not the top-level rt_rq.
This is wrong, because changing of priority on a child level does not
guarantee that the priority is the highest all over the rq. So, this
leak makes RT balancing unusable.

The short example: the task having the highest priority among all rq's
RT tasks (no one other task has the same priority) are waking on a
throttle rt_rq.  The rq's cpupri is set to the task's priority
equivalent, but real rq->rt.highest_prio.curr is less.

The patch below fixes the problem.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/49231385567953@web4m.yandex.ru
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 7d57275..1c40655 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -901,6 +901,13 @@ inc_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
 {
 	struct rq *rq = rq_of_rt_rq(rt_rq);
 
+#ifdef CONFIG_RT_GROUP_SCHED
+	/*
+	 * Change rq's cpupri only if rt_rq is the top queue.
+	 */
+	if (&rq->rt != rt_rq)
+		return;
+#endif
 	if (rq->online && prio < prev_prio)
 		cpupri_set(&rq->rd->cpupri, rq->cpu, prio);
 }
@@ -910,6 +917,13 @@ dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
 {
 	struct rq *rq = rq_of_rt_rq(rt_rq);
 
+#ifdef CONFIG_RT_GROUP_SCHED
+	/*
+	 * Change rq's cpupri only if rt_rq is the top queue.
+	 */
+	if (&rq->rt != rt_rq)
+		return;
+#endif
 	if (rq->online && rt_rq->highest_prio.curr != prev_prio)
 		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio.curr);
 }
