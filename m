Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbaIZVHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 17:07:04 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:33981 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770AbaIZVHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 17:07:02 -0400
Date: Fri, 26 Sep 2014 21:06:52 +0000
From: "Sylvain 'ythier' Hitier" <sylvain.hitier@gmail.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] fork.c: copy_process(): fix cleanup WRT
 perf_event_free_task()
Message-ID: <20140926210652.GA27199@erable>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date:   Fri Sep 26 20:56:07 2014 +0000

fork.c: copy_process(): fix cleanup WRT perf_event_free_task()

Currently, in copy_process(), a failure of either sched_fork() or
perf_event_init_task() does trigger perf_event_free_task()!

Moreover, the label bad_fork_cleanup_policy does more than what its name
implies, because it includes perf_event_free_task()!

Let's explain the change with a grASCIIcally-enhanced kind-of-diff which
provides an adequate context.
                                        // Read vertically this column
                                        //   |  |  |  |  |  |  |  |  |
                                        //   v  v  v  v  v  v  v  v  v
 {
//SNIP//
    if (clone_flags & CLONE_THREAD)
        threadgroup_change_begin(current);
//SNIP//
 #ifdef CONFIG_NUMA
    p->mempolicy = mpol_dup(p->mempolicy);
    if (IS_ERR(p->mempolicy)) {
//SNIP//
        goto bad_fork_cleanup_threadgroup_lock;
    }
 #endif
//SNIP//
    retval = sched_fork(clone_flags, p);
    if (retval)
//                                      // mustn't perf_event_free_task()
        goto bad_fork_cleanup_policy;
    retval = perf_event_init_task(p);
    if (retval)
//                                      // mustn't perf_event_free_task()
        goto bad_fork_cleanup_policy;
    retval = audit_alloc(p);
    if (retval)
//                                      // must perf_event_free_task()
//                                      @@ Hence change this way:
-       goto bad_fork_cleanup_policy;
+       goto bad_fork_cleanup_perf;
//SNIP//
 bad_fork_cleanup_audit:
    audit_free(p);
//                                      // let's clean perf up
//                                      @@ Hence change this way:
-bad_fork_cleanup_policy:
+bad_fork_cleanup_perf:
    perf_event_free_task(p);
//                                      // no (longer) need to clean perf up
//                                      @@ Hence change this way:
+bad_fork_cleanup_policy:
 #ifdef CONFIG_NUMA
    mpol_put(p->mempolicy);
 bad_fork_cleanup_threadgroup_lock:
 #endif
    if (clone_flags & CLONE_THREAD)
        threadgroup_change_end(current);
//SNIP//
 }

Signed-off-by: Sylvain "ythier" Hitier <sylvain.hitier@gmail.com>
---
 kernel/fork.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 0cf9cdb..a91e47d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1360,7 +1360,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto bad_fork_cleanup_policy;
 	retval = audit_alloc(p);
 	if (retval)
-		goto bad_fork_cleanup_policy;
+		goto bad_fork_cleanup_perf;
 	/* copy all the process information */
 	shm_init_task(p);
 	retval = copy_semundo(clone_flags, p);
@@ -1566,8 +1566,9 @@ bad_fork_cleanup_semundo:
 	exit_sem(p);
 bad_fork_cleanup_audit:
 	audit_free(p);
-bad_fork_cleanup_policy:
+bad_fork_cleanup_perf:
 	perf_event_free_task(p);
+bad_fork_cleanup_policy:
 #ifdef CONFIG_NUMA
 	mpol_put(p->mempolicy);
 bad_fork_cleanup_threadgroup_lock:

Regards,
Sylvain "ythier" Hitier

-- 
Business is about being busy, not being rich...
Lived 777 days in a Debian package => http://en.wikipedia.org/wiki/Apt,_Vaucluse
There's THE room for ideals in this mechanical place!
