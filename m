Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab3K0OLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:11:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47818 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104Ab3K0OLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:11:46 -0500
Date: Wed, 27 Nov 2013 06:10:59 -0800
From: tip-bot for Dario Faggioli <tipbot@zytor.com>
Message-ID: <tip-e6c390f2dfd04c165ce45b0032f73fba85b1f282@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, pjt@google.com, raistlin@linux.it,
        tglx@linutronix.de, juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pjt@google.com, peterz@infradead.org, raistlin@linux.it,
        tglx@linutronix.de, juri.lelli@gmail.com
In-Reply-To: <1383831828-15501-2-git-send-email-juri.lelli@gmail.com>
References: <1383831828-15501-2-git-send-email-juri.lelli@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add sched_class->task_dead() method
Git-Commit-ID: e6c390f2dfd04c165ce45b0032f73fba85b1f282
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 27 Nov 2013 06:11:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6c390f2dfd04c165ce45b0032f73fba85b1f282
Gitweb:     http://git.kernel.org/tip/e6c390f2dfd04c165ce45b0032f73fba85b1f282
Author:     Dario Faggioli <raistlin@linux.it>
AuthorDate: Thu, 7 Nov 2013 14:43:35 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 27 Nov 2013 14:08:50 +0100

sched: Add sched_class->task_dead() method

Add a new function to the scheduling class interface. It is called
at the end of a context switch, if the prev task is in TASK_DEAD state.

It will be useful for the scheduling classes that want to be notified
when one of their tasks dies, e.g. to perform some cleanup actions,
such as SCHED_DEADLINE.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Reviewed-by: Paul Turner <pjt@google.com>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Cc: bruce.ashfield@windriver.com
Cc: claudio@evidence.eu.com
Cc: darren@dvhart.com
Cc: dhaval.giani@gmail.com
Cc: fchecconi@gmail.com
Cc: fweisbec@gmail.com
Cc: harald.gustafsson@ericsson.com
Cc: hgu1972@gmail.com
Cc: insop.song@gmail.com
Cc: jkacur@redhat.com
Cc: johan.eker@ericsson.com
Cc: liming.wang@windriver.com
Cc: luca.abeni@unitn.it
Cc: michael@amarulasolutions.com
Cc: nicola.manica@disi.unitn.it
Cc: oleg@redhat.com
Cc: paulmck@linux.vnet.ibm.com
Cc: p.faure@akatech.ch
Cc: rostedt@goodmis.org
Cc: tommaso.cucinotta@sssup.it
Cc: vincent.guittot@linaro.org
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1383831828-15501-2-git-send-email-juri.lelli@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  | 3 +++
 kernel/sched/sched.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 19db8f3..25b3779 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2003,6 +2003,9 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	if (unlikely(prev_state == TASK_DEAD)) {
 		task_numa_free(prev);
 
+		if (prev->sched_class->task_dead)
+			prev->sched_class->task_dead(prev);
+
 		/*
 		 * Remove function-return probe instances associated with this
 		 * task and put them back on the free list.
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 88c85b2..b3b4a49 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1023,6 +1023,7 @@ struct sched_class {
 	void (*set_curr_task) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
 	void (*task_fork) (struct task_struct *p);
+	void (*task_dead) (struct task_struct *p);
 
 	void (*switched_from) (struct rq *this_rq, struct task_struct *task);
 	void (*switched_to) (struct rq *this_rq, struct task_struct *task);
