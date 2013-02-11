Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183Ab3BKSvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 13:51:41 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:58354 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759081Ab3BKSvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 13:51:39 -0500
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
        vincent.guittot@linaro.org
Subject: [PATCH 01/14] sched: add sched_class->task_dead.
Date: Mon, 11 Feb 2013 10:50:43 -0800
Message-Id: <1360608656-7969-2-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360608656-7969-1-git-send-email-juri.lelli@gmail.com>
References: <1360608656-7969-1-git-send-email-juri.lelli@gmail.com>
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
 include/linux/sched.h |    1 +
 kernel/sched/core.c   |    3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d211247..640c741 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1104,6 +1104,7 @@ struct sched_class {
 	void (*set_curr_task) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
 	void (*task_fork) (struct task_struct *p);
+	void (*task_dead) (struct task_struct *p);
 
 	void (*switched_from) (struct rq *this_rq, struct task_struct *task);
 	void (*switched_to) (struct rq *this_rq, struct task_struct *task);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 26058d0..7e99105 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1843,6 +1843,9 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
+		if (prev->sched_class->task_dead)
+			prev->sched_class->task_dead(prev);
+
 		/*
 		 * Remove function-return probe instances associated with this
 		 * task and put them back on the free list.
-- 
1.7.9.5

