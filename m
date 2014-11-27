Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbaK0Izr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:55:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:42582 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115AbaK0Iti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:49:38 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 72/91] perf: fix perf bug in fork()
Date: Thu, 27 Nov 2014 16:42:55 +0800
Message-Id: <1417077794-9299-72-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 6c72e3501d0d62fc064d3680e5234f3463ec5a86 upstream.

Oleg noticed that a cleanup by Sylvain actually uncovered a bug; by
calling perf_event_free_task() when failing sched_fork() we will not yet
have done the memset() on ->perf_event_ctxp[] and will therefore try and
'free' the inherited contexts, which are still in use by the parent
process.  This is bad..

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Sylvain 'ythier' Hitier <sylvain.hitier@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 kernel/events/core.c | 4 +++-
 kernel/fork.c        | 5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index c958be1..10c8fdd 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7127,8 +7127,10 @@ int perf_event_init_task(struct task_struct *child)
 
 	for_each_task_context_nr(ctxn) {
 		ret = perf_event_init_context(child, ctxn);
-		if (ret)
+		if (ret) {
+			perf_event_free_task(child);
 			return ret;
+		}
 	}
 
 	return 0;
diff --git a/kernel/fork.c b/kernel/fork.c
index 621c547..878dcb2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1285,7 +1285,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto bad_fork_cleanup_policy;
 	retval = audit_alloc(p);
 	if (retval)
-		goto bad_fork_cleanup_policy;
+		goto bad_fork_cleanup_perf;
 	/* copy all the process information */
 	retval = copy_semundo(clone_flags, p);
 	if (retval)
@@ -1480,8 +1480,9 @@ bad_fork_cleanup_semundo:
 	exit_sem(p);
 bad_fork_cleanup_audit:
 	audit_free(p);
-bad_fork_cleanup_policy:
+bad_fork_cleanup_perf:
 	perf_event_free_task(p);
+bad_fork_cleanup_policy:
 #ifdef CONFIG_NUMA
 	mpol_put(p->mempolicy);
 bad_fork_cleanup_cgroup:
-- 
1.9.1

