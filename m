Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaHMTWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 15:22:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbaHMTW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 15:22:28 -0400
Date: Wed, 13 Aug 2014 21:20:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] sched: change thread_group_cputime() to use
	for_each_thread()
Message-ID: <20140813192000.GA19327@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813191938.GA19301@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change thread_group_cputime() to use for_each_thread() instead of
buggy while_each_thread(). This also makes the pid_alive() check
unnecessary.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sched/cputime.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

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
 
-- 
1.5.5.1

