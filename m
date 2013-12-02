Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab3LBR2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 12:28:43 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41779 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab3LBR2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 12:28:42 -0500
Date: Mon, 2 Dec 2013 18:28:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sched: Revert 14a40ffccd61 ("sched: replace
 PF_THREAD_BOUND with PF_NO_SETAFFINITY")
Message-ID: <20131202172837.GB29537@gmail.com>
References: <20131202152956.GI16796@laptop.programming.kicks-ass.net>
 <20131202153746.GA27781@gmail.com>
 <20131202165006.GA19064@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131202165006.GA19064@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <htejun@gmail.com> wrote:

> Hello, guys.
> 
> On Mon, Dec 02, 2013 at 04:37:46PM +0100, Ingo Molnar wrote:
> > >  - We should strive to never consciously place artificial limitations on
> > >    kernel functionality; our main reason to place limitations should be
> > >    correctness.
> 
> It is a correctness issue tho.  We'd be promising, say, NUMA affinity
> and then possibly give out workers which aren't affine to the NUMA
> node. [...]

No, NUMA is a performance issue in this specific case, not a 
correctness issue. 'Correctness' for configuration details mostly 
means 'stuff does not crash'.

We try to give good, sensible, well performing defaults out of box, 
but otherwise we try to let root mis-configure (or improve!) their 
systems rather widely.

This is really fundamental: our affinity APIs are generic, and they 
should only ever be limited in such a drastic fashion in the very 
strict 'stuff crashes' case, and that is properly expressed via the 
PF_THREAD_BOUND flag.

(Your other arguments fail for similar reasons.)

> This is the same problem with bound workers.  Userland could be 
> actively breaking configured affinities of kworkers which may be 
> depended upon by its users and there's no way for userland to tell 
> which kworker is gonna serve which workqueue - there's no fixed 
> relationship between them, so it's not like userland can, say, 
> modify affinities on crypto kworkers in isolation.  Both userland 
> and kernel wouldn't have much idea of the impact of such fiddling.

That's only because 'private affinity' attributes detached scheduler 
affinity handling snuck into the workqueue code. It's bad design and 
it needs to be fixed - and the worst aspect is undone via this revert.

> > Peter's workqueue.c fixlet above to workqueue.c to this patch plus 
> > your Acked-by, so that the two changes are together?
> 
> The above would trigger the added warning if a new kworker is 
> created for a per-cpu workqueue while the cpu is down, which may 
> happen, so the patch itself is somewhat broken.

I'll wait for a new submission from Peter.

> I don't think this is the right path to accomodate HPC/RT use cases. 
> Let's please implement something proper if keeping unbound kworkers 
> off certain cpus is necessary.

We already have APIs to manage affinities, in the scheduler. 
Privatizing this function into workqueue.c is limiting and actively 
wrong.

Such APIs should be done properly, by extending existing scheduler 
APIs if needed, not by turning off the old APIs via a crude flag and 
creating some private, per subsystem implementation ...

Thanks,
	
	Ingo
