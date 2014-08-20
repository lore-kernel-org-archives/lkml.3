Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaHTIWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:22:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47017 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbaHTIWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:22:08 -0400
Date: Wed, 20 Aug 2014 01:18:54 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-5d07f4202c5d63b73ba1734ed38e08461a689313@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, seto.hidetoshi@jp.fujitsu.com,
        peterz@infradead.org, umgwanakikbuti@gmail.com, riel@redhat.com,
        fmayhar@google.com, akpm@linux-foundation.org, srao@redhat.com,
        fweisbec@redhat.com, tglx@linutronix.de, oleg@redhat.com,
        lwoodman@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, torvalds@linux-foundation.org,
        peterz@infradead.org, umgwanakikbuti@gmail.com, riel@redhat.com,
        fmayhar@google.com, akpm@linux-foundation.org, fweisbec@redhat.com,
        srao@redhat.com, oleg@redhat.com, tglx@linutronix.de,
        lwoodman@redhat.com
In-Reply-To: <20140813191953.GA19315@redhat.com>
References: <20140813191953.GA19315@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: s/do_each_thread/for_each_process_thread/
  in core.c
Git-Commit-ID: 5d07f4202c5d63b73ba1734ed38e08461a689313
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

Commit-ID:  5d07f4202c5d63b73ba1734ed38e08461a689313
Gitweb:     http://git.kernel.org/tip/5d07f4202c5d63b73ba1734ed38e08461a689313
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Wed, 13 Aug 2014 21:19:53 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 20 Aug 2014 09:47:17 +0200

sched: s/do_each_thread/for_each_process_thread/ in core.c

Change kernel/sched/core.c to use for_each_process_thread().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Frank Mayhar <fmayhar@google.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Sanjay Rao <srao@redhat.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140813191953.GA19315@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7d1ec6e..4f2826f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4505,7 +4505,7 @@ void show_state_filter(unsigned long state_filter)
 		"  task                        PC stack   pid father\n");
 #endif
 	rcu_read_lock();
-	do_each_thread(g, p) {
+	for_each_process_thread(g, p) {
 		/*
 		 * reset the NMI-timeout, listing all files on a slow
 		 * console might take a lot of time:
@@ -4513,7 +4513,7 @@ void show_state_filter(unsigned long state_filter)
 		touch_nmi_watchdog();
 		if (!state_filter || (p->state & state_filter))
 			sched_show_task(p);
-	} while_each_thread(g, p);
+	}
 
 	touch_all_softlockup_watchdogs();
 
@@ -7137,7 +7137,7 @@ void normalize_rt_tasks(void)
 	struct rq *rq;
 
 	read_lock_irqsave(&tasklist_lock, flags);
-	do_each_thread(g, p) {
+	for_each_process_thread(g, p) {
 		/*
 		 * Only normalize user tasks:
 		 */
@@ -7168,8 +7168,7 @@ void normalize_rt_tasks(void)
 
 		__task_rq_unlock(rq);
 		raw_spin_unlock(&p->pi_lock);
-	} while_each_thread(g, p);
-
+	}
 	read_unlock_irqrestore(&tasklist_lock, flags);
 }
 
@@ -7357,10 +7356,10 @@ static inline int tg_has_rt_tasks(struct task_group *tg)
 {
 	struct task_struct *g, *p;
 
-	do_each_thread(g, p) {
+	for_each_process_thread(g, p) {
 		if (rt_task(p) && task_rq(p)->rt.tg == tg)
 			return 1;
-	} while_each_thread(g, p);
+	}
 
 	return 0;
 }
