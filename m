Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab3KWLsq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 06:48:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37848 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab3KWLsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 06:48:42 -0500
Date: Sat, 23 Nov 2013 12:48:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dvhart@linux.intel.com,
        tglx@linutronix.de, efault@gmx.de, jeffm@suse.com,
        torvalds@linux-foundation.org, scott.norton@hp.com, tom.vaden@hp.com,
        aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com
Subject: Re: [PATCH 5/5] sched,futex: Provide delayed wakeup list
Message-ID: <20131123114815.GC16796@laptop.programming.kicks-ass.net>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
 <1385168197-8612-6-git-send-email-davidlohr@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385168197-8612-6-git-send-email-davidlohr@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 04:56:37PM -0800, Davidlohr Bueso wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> Original patchset: https://lkml.org/lkml/2011/9/14/118
> 
> This is useful for locking primitives that can effect multiple
> wakeups per operation and want to avoid lock internal lock contention
> by delaying the wakeups until we've released the lock internal locks.
> 
> Alternatively it can be used to avoid issuing multiple wakeups, and
> thus save a few cycles, in packet processing. Queue all target tasks
> and wakeup once you've processed all packets. That way you avoid
> waking the target task multiple times if there were multiple packets
> for the same task.
> 
> This patch adds the needed infrastructure into the scheduler code
> and uses the new wake_list to delay the futex wakeups until
> after we've released the hash bucket locks. This avoids the newly
> woken tasks from immediately getting stuck on the hb->lock.
> 
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Darren Hart <dvhart@linux.intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Jeff Mahoney <jeffm@suse.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Scott Norton <scott.norton@hp.com>
> Cc: Tom Vaden <tom.vaden@hp.com>
> Cc: Aswin Chandramouleeswaran <aswin@hp.com>
> Cc: Waiman Long <Waiman.Long@hp.com>
> Tested-by: Jason Low <jason.low2@hp.com>
> [forward ported]
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> ---
> Please note that in the original thread there was some debate
> about spurious wakeups (https://lkml.org/lkml/2011/9/17/31), so
> you can consider this more of an RFC patch if folks believe that
> this functionality is incomplete/buggy.

Right, from what I remember, this patch can cause spurious wakeups, and
while all our regular sleeping lock / wait thingies can deal with this,
not all creative schedule() usage in the tree can deal with this.

There's about ~1400 (or there were that many 2 years ago, might be more
by now) schedule() calls, many of which are open coded wait constructs
of which most are buggy in one way or another.

So we first need to audit / fix all those before we can do this one.

I used to have a patch to schedule() that would always immediately fall
through and only actually block on the second call; it illustrated the
problem really well, in fact so well the kernels fails to boot most
times.
