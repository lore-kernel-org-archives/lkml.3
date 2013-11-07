Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab3KGNru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 08:47:50 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50843 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3KGNoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 08:44:20 -0500
From: Juri Lelli <juri.lelli@gmail.com>
To: peterz@infradead.org, tglx@linutronix.de
Cc: mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com
Subject: [PATCH 01/14] sched: add sched_class->task_dead.
Date: Thu,  7 Nov 2013 14:43:35 +0100
Message-Id: <1383831828-15501-2-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dario Faggioli <raistlin@linux.it>

Add a new function to the scheduling class interface. It is called
at the end of a context switch, if the prev task is in TASK_DEAD state.

It might be useful for the scheduling classes that want to be notified
when one of their task dies, e.g. to perform some cleanup actions.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 kernel/sched/core.c  |    3 +++
 kernel/sched/sched.h |    1 +
 2 files changed, 4 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5ac63c9..850a02c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1890,6 +1890,9 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
+		if (prev->sched_class->task_dead)
+			prev->sched_class->task_dead(prev);
+
 		/*
 		 * Remove function-return probe instances associated with this
 		 * task and put them back on the free list.
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b3c5653..64eda5c 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -992,6 +992,7 @@ struct sched_class {
 	void (*set_curr_task) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
 	void (*task_fork) (struct task_struct *p);
+	void (*task_dead) (struct task_struct *p);
 
 	void (*switched_from) (struct rq *this_rq, struct task_struct *task);
 	void (*switched_to) (struct rq *this_rq, struct task_struct *task);
-- 
1.7.9.5

