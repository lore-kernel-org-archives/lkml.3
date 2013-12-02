Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab3LBQ4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 11:56:01 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:41020 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab3LBQz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 11:55:59 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Dec 2013 11:55:59 EST
Date: Mon, 2 Dec 2013 11:50:06 -0500
From: Tejun Heo <htejun@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sched: Revert 14a40ffccd61 ("sched: replace
 PF_THREAD_BOUND with PF_NO_SETAFFINITY")
Message-ID: <20131202165006.GA19064@htj.dyndns.org>
References: <20131202152956.GI16796@laptop.programming.kicks-ass.net>
 <20131202153746.GA27781@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131202153746.GA27781@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

On Mon, Dec 02, 2013 at 04:37:46PM +0100, Ingo Molnar wrote:
> >  - We should strive to never consciously place artificial limitations on
> >    kernel functionality; our main reason to place limitations should be
> >    correctness.

It is a correctness issue tho.  We'd be promising, say, NUMA affinity
and then possibly give out workers which aren't affine to the NUMA
node.  Workqueue provides an API to set random affinity and its users
can rightfully expect the configured affinity and code accordingly.

> >    There are cases where limiting affinity is justified: for example the
> >    case of single cpu workqueue threads, which are special for their
> >    limited concurrency, esp. when coupled with per-cpu resources --
> >    allowing such threads to run on other cpus is a correctness violation
> >    and can crash the kernel.

So can any requested affinity if the wq user configured it.  I think
you're too focused on the binary bound / unbound distinction.  Things
are a lot more generic now.

> >  - But using it outside this case is overly broad; it dis-allows usage
> >    that is functionally fine and in some cases desired.
> > 
> >    In particular; tj argues ( http://lkml.kernel.org/r/20131128143848.GD3925@htj.dyndns.org )
> > 
> >    "That's just inviting people to do weirdest things and then
> >    reporting things like "crypt jobs on some of our 500 machines end up
> >    stuck on a single cpu once in a while" which will eventually be
> >    tracked down to some weird shell script setting affinity on workers
> >    doing something else."
> > 
> >    While that is exactly what HPC/RT people _want_ in order to avoid
> >    disturbing the other CPUs with said crypt work.

Hmmm... I think you're missing the point there.  The point is that you
can't really do that reliably by meddling with kworkers from userland
directly.  It's gonna be fragile and dangerous.  Userland would have
to continously poll for new kworkers while kernel workqueue users
would get their affinity expectations broken.  I don't think that's
what HPC/RT people want.  If HPC/RT people want to limit the cpus that
unbound workqueues without specific affinity configured can run on,
let's please implement that properly.

> >  - Furthermore, the above example is also wrong in that you should not
> >    protect root from itself; there's plenty root can do to shoot his
> >    own foot off, let alone shoot his head off.
> > 
> >    Setting affinities is limited to root, and if root messes up the
> >    system he can keep the pieces. But limiting in an overly broad
> >    fashion stifles the functionality of the system.

This is the same problem with bound workers.  Userland could be
actively breaking configured affinities of kworkers which may be
depended upon by its users and there's no way for userland to tell
which kworker is gonna serve which workqueue - there's no fixed
relationship between them, so it's not like userland can, say, modify
affinities on crypto kworkers in isolation.  Both userland and kernel
wouldn't have much idea of the impact of such fiddling.

> >  - Lastly; the flag actually blocks entry into cgroups as well asn
> >    sched_setaffinity(), so the name is misleading at best.

Yeah, the name could be better.

> > The right fix is to only set PF_THREAD_BOUND on per-cpu workers:
> > 
> >  --- a/kernel/workqueue.c
> >  +++ b/kernel/workqueue.c
> > 
> >          set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
> > 
> >  -       /* prevent userland from meddling with cpumask of workqueue workers */
> >  -       worker->task->flags |= PF_NO_SETAFFINITY;
> >  -
> >          /*
> >           * The caller is responsible for ensuring %POOL_DISASSOCIATED
> >           * remains stable across this function.  See the comments above the
> >           * flag definition for details.
> >           */
> >  -       if (pool->flags & POOL_DISASSOCIATED)
> >  +       if (pool->flags & POOL_DISASSOCIATED) {
> >                  worker->flags |= WORKER_UNBOUND;
> >  +       } else {
> >  +               /*
> >  +                * Prevent userland from meddling with cpumask of workqueue
> >  +                * workers:
> >  +                */
> >  +               worker->task->flags |= PF_THREAD_BOUND;
> >  +       }
> > 
> > Therefore revert the patch and add an annoying but non-destructive warning
> > check against abuse.
> 
> Hm, I missed these problems with the approach, but I think you are 
> right.
> 
> Tejun, I suspect you concur with Peter's analysis, can I also add 

So, not really.

> Peter's workqueue.c fixlet above to workqueue.c to this patch plus 
> your Acked-by, so that the two changes are together?

The above would trigger the added warning if a new kworker is created
for a per-cpu workqueue while the cpu is down, which may happen, so
the patch itself is somewhat broken.

I don't think this is the right path to accomodate HPC/RT use cases.
Let's please implement something proper if keeping unbound kworkers
off certain cpus is necessary.

Thanks.

-- 
tejun
