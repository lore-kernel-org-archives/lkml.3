Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab3GOOlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:41:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:50254 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136Ab3GOOla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:41:30 -0400
Date: Mon, 15 Jul 2013 16:41:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Waiman Long <waiman.long@hp.com>
cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v5 01/12] spinlock: A new lockref structure for lockless
 update of refcount
In-Reply-To: <51DACADF.4000802@hp.com>
Message-ID: <alpine.DEB.2.02.1307151612090.11918@ionos.tec.linutronix.de>
References: <1373035656-40600-1-git-send-email-Waiman.Long@hp.com> <1373035656-40600-2-git-send-email-Waiman.Long@hp.com> <alpine.DEB.2.02.1307051911110.32106@ionos.tec.linutronix.de> <51DACADF.4000802@hp.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jul 2013, Waiman Long wrote:
> On 07/05/2013 02:59 PM, Thomas Gleixner wrote:
> > On Fri, 5 Jul 2013, Waiman Long wrote:
> I think it is OK to add the GENERIC option, but I would like to make available
> a slightly different set of options:
> 1) Always take the lock
> 2) Use the generic implementation with the default parameters
> 3) Use the generic implementation with a customized set of parameters
> 4) Use an architecture specific implementation.
> 
> 2) set only GENERIC_SPINLOCK_REFCOUNT
> 3) set both GENERIC_SPINLOCK_REFCOUNT and ARCH_SPINLOCK_REFCOUNT
> 4) set only ARCH_SPINLOCK_REFCOUNT
> 
> The customized parameters will be set in the "asm/spinlock_refcount.h" file.
> Currently ,there is 2 parameters that can be customized for each architecture:
> 1) How much time will the function wait until the lock is free
> 2) How many attempts to do a lockless cmpxchg to update reference count

Sigh. GENERIC means, that you use the generic implementation, ARCH
means the architecture has a private implementation of that code.

The generic implementation can use arch specific includes and if there
is none we simply fallback to the asm-generic one.

 > Let's start with a simple version because it IS simple and easy
> > to analyze and debug and then incrementally build improvements on it
> > instead of creating an heuristics monster in the first place, i.e.:
> > 
> >     if (!spin_is_locked(&lr->lock)&&  try_cmpxchg_once(lr))
> >        return 0;
> >     return 1;
> > 
> > Take numbers for this on a zoo of different machines: Intel and AMD,
> > old and new.
> > 
> > Then you can add an incremental patch on that, which add loops and
> > hoops. Along with numbers on the same zoo of machines.
> 
> I originally tried to do a cmpxchg without waiting and there was
> practically no performance gain. I believe that as soon as

Well, you did not see a difference on your particular machine. Still
we don't have an idea how all of this works on a set of different
machines. There is a world beside 8 socket servers.

> contention happens, it will force all the upcoming reference count
> update threads to take the lock eliminating any potential
> performance gain that we can have. To make it simple, I can change
> the default to wait indefinitely until the lock is free instead of
> looping a certain number of times, but I still like the option of
> letting each architecture to decide how many times they want to
> try. I agree that the actual waiting time even for one architecture
> is depending on the actual CPU chip that is being used. I have done
> some experiment on that. As long as the count is large enough,
> increasing the loop count doesn't have any significant impact on
> performance any more. The main reason for having a finite time is to
> avoid having the waiting thread to wait virtually forever if the
> lock happens to be busy for a long time.

Again, if we make this tunable then we still want documentation for
the behaviour on small, medium and large machines.

Also what's the approach to tune that? Running some random testbench
and monitor the results for various settings?

If that's the case we better have a that as variables with generic
initial values in the code, which can be modified by sysctl.


> > > +		getnstimeofday(&tv2);
> > > +		ns = (tv2.tv_sec - tv1.tv_sec) * NSEC_PER_SEC +
> > > +		     (tv2.tv_nsec - tv1.tv_nsec);
> > > +		pr_info("lockref wait loop time = %lu ns\n", ns);
> > Using getnstimeofday() for timestamping and spamming the logs with
> > printouts? You can't be serious about that?
> > 
> > Thats what tracepoints are for. Tracing is the only way to get proper
> > numbers which take preemption, interrupts etc. into account without
> > hurting runtime performace.
> 
> The _SHOW_WAIT_LOOP_TIME is for debugging and instrumentation purpose only
> during development cycle. It is not supposed to be turned on at production
> system. I will document that in the code.

No, no, no! Again: That's what tracepoints are for.

This kind of debugging is completely pointless. Tracepoints are
designed to be low overhead and can be enabled on production
systems.

Your debugging depends on slow timestamps against CLOCK_REALTIME and
an even slower output via printk. How useful is that if you want to
really instrument the behaviour of this code?

Thanks,

	tglx
