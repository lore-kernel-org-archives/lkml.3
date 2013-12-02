Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab3LBUNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:13:54 -0500
Received: from mail-qe0-f42.google.com ([209.85.128.42]:40513 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab3LBTRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:33 -0500
Date: Mon, 2 Dec 2013 14:17:27 -0500
From: Tejun Heo <htejun@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sched: Revert 14a40ffccd61 ("sched: replace
 PF_THREAD_BOUND with PF_NO_SETAFFINITY")
Message-ID: <20131202191727.GC3626@htj.dyndns.org>
References: <20131202152956.GI16796@laptop.programming.kicks-ass.net>
 <20131202153746.GA27781@gmail.com>
 <20131202165006.GA19064@htj.dyndns.org>
 <20131202172837.GB29537@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131202172837.GB29537@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

On Mon, Dec 02, 2013 at 06:28:37PM +0100, Ingo Molnar wrote:
> No, NUMA is a performance issue in this specific case, not a 
> correctness issue. 'Correctness' for configuration details mostly 
> means 'stuff does not crash'.

That's exactly the thing.  Workqueue users can set any random affinity
be that per-cpu, per-NUMA or whatever (I'm not talking about the
automatic NUMA affinity here), and they should be able to depend on
the configured affinity being honored as long as that request has
succeeded.  Changing affinity underneath workqueue code actively
breaks the API and has possibility to lead to crashes.

> We try to give good, sensible, well performing defaults out of box, 
> but otherwise we try to let root mis-configure (or improve!) their 
> systems rather widely.

Yeah, sure, that's why there's custom attributes interface which can
be exposed via sysfs.

> That's only because 'private affinity' attributes detached scheduler 
> affinity handling snuck into the workqueue code. It's bad design and 
> it needs to be fixed - and the worst aspect is undone via this revert.

You can't do that because of the very nature of workqueue - the tasks
are completely ephemeral and automatically pooled.  Nothing is
per-task.  There are attributes which aren't even defined for
individual tasks.  For workqueue attributes to be customizable, it
needs some form of custom interface.

> We already have APIs to manage affinities, in the scheduler. 
> Privatizing this function into workqueue.c is limiting and actively 
> wrong.

Those are pool attributes which the tasks are keyed by.  workqueue
needs to know them to put the matching ones in the same pool.

> Such APIs should be done properly, by extending existing scheduler 
> APIs if needed, not by turning off the old APIs via a crude flag and 
> creating some private, per subsystem implementation ...

I don't really follow this logic.  workqueue is a super structure
built on top of tasks and has certain requirements on how its member
tasks behave and will break, in ways which would be difficult to track
down, if those requirements are breached.  This is something
structurally fundamental.

I suppose workqueue can taint / generate warnings if workers which are
breaking out of the requested parameters are detected, if people are
hell-bent on doing it, but the pros aren't clear at all to me.

Thanks.

-- 
tejun
