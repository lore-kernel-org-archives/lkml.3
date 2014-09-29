Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaI2KMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 06:12:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:37002 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaI2KMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 06:12:05 -0400
Date: Mon, 29 Sep 2014 12:12:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Sylvain 'ythier' Hitier" <sylvain.hitier@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] fork.c: copy_process(): fix cleanup WRT
 perf_event_free_task()
Message-ID: <20140929101201.GE5430@worktop>
References: <20140926210652.GA27199@erable>
 <20140927180725.GA15594@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140927180725.GA15594@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2014 at 08:07:25PM +0200, Oleg Nesterov wrote:
> On 09/26, Sylvain 'ythier' Hitier wrote:
> >
> >     retval = sched_fork(clone_flags, p);
> >     if (retval)
> > //                                      // mustn't perf_event_free_task()
> >         goto bad_fork_cleanup_policy;
> 
> Agreed, this is wrong. Good catch.
> 
> but, unless I missed something,

Ah, indeed. It was meant to be a no-op there, but its before we do that
memset, so its still the inherited values, and we don't want to clean
those up I think.

> >     retval = perf_event_init_task(p);
> >     if (retval)
> > //                                      // mustn't perf_event_free_task()
>                                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> this is not right and thus the patch is not right too.

Agreed

> Suppose that perf_event_init_task() -> perf_event_init_context(ctxn => 0)
> succeeds and then perf_event_init_context(ctxn => 1) fails, we need
> perf_event_free_task() to cleanup ->perf_event_ctxp[0].
> 
> So if perf_event_init_task() fails, we still need "goto bad_fork_cleanup_perf".
> 
> No?

Yep

> Or, probably better, we need to change perf_event_init_context() to call
> perf_event_free_task() on failure.
> 
> Or. We can simply move memset(child->perf_event_ctxp, 0, ...) from
> perf_event_init_context() up. This reminds that we really need to cleanup
> copy_process(), in particular I think it asks for the new copy_xxx() helper
> which should do misc simple initializations which can't fail.
> 
> What do you think?

I prefer the former, as the latter scatters the perf specific bits over
more places. Something like so then?



---
Subject: perf: Fix perf bug in fork()

Oleg noticed that a cleanup by Sylvain actually uncovered a bug; by
calling perf_event_free_task() when failing sched_fork() we will not yet
have done the memset() on ->perf_event_ctxp[] and will therefore try and
'free' the inherited contexts, which are still in use by the parent
process. This is bad..

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Sylvain 'ythier' Hitier <sylvain.hitier@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
diff --git a/kernel/events/core.c b/kernel/events/core.c
index a232b40..4a0dbb2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8078,8 +8078,10 @@ int perf_event_init_task(struct task_struct *child)
 
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
index ad64248..b6cc3f2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1367,7 +1367,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto bad_fork_cleanup_policy;
 	retval = audit_alloc(p);
 	if (retval)
-		goto bad_fork_cleanup_policy;
+		goto bad_fork_cleanup_perf;
 	/* copy all the process information */
 	shm_init_task(p);
 	retval = copy_semundo(clone_flags, p);
@@ -1573,8 +1573,9 @@ bad_fork_cleanup_semundo:
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
