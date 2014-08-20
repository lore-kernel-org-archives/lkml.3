Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaHTIVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:21:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46992 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaHTIVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:21:05 -0400
Date: Wed, 20 Aug 2014 01:19:21 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-1e4dda08b4c39b3d8f4a3ee7269d49e0200c8af8@git.kernel.org>
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
In-Reply-To: <20140813192000.GA19327@redhat.com>
References: <20140813192000.GA19327@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Change thread_group_cputime()
  to use for_each_thread()
Git-Commit-ID: 1e4dda08b4c39b3d8f4a3ee7269d49e0200c8af8
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

Commit-ID:  1e4dda08b4c39b3d8f4a3ee7269d49e0200c8af8
Gitweb:     http://git.kernel.org/tip/1e4dda08b4c39b3d8f4a3ee7269d49e0200c8af8
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Wed, 13 Aug 2014 21:20:00 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 20 Aug 2014 09:47:18 +0200

sched: Change thread_group_cputime() to use for_each_thread()

Change thread_group_cputime() to use for_each_thread() instead of
buggy while_each_thread(). This also makes the pid_alive() check
unnecessary.

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
Link: http://lkml.kernel.org/r/20140813192000.GA19327@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/cputime.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 72fdf06..3e52836 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -294,18 +294,12 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 	times->sum_exec_runtime = sig->sum_sched_runtime;
 
 	rcu_read_lock();
-	/* make sure we can trust tsk->thread_group list */
-	if (!likely(pid_alive(tsk)))
-		goto out;
-
-	t = tsk;
-	do {
+	for_each_thread(tsk, t) {
 		task_cputime(t, &utime, &stime);
 		times->utime += utime;
 		times->stime += stime;
 		times->sum_exec_runtime += task_sched_runtime(t);
-	} while_each_thread(tsk, t);
-out:
+	}
 	rcu_read_unlock();
 }
 
