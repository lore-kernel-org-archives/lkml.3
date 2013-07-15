Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431Ab3GOXrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 19:47:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:53125 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148Ab3GOXrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 19:47:10 -0400
Date: Tue, 16 Jul 2013 01:47:05 +0200 (CEST)
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
In-Reply-To: <51E468A4.3030605@hp.com>
Message-ID: <alpine.DEB.2.02.1307160109490.11918@ionos.tec.linutronix.de>
References: <1373035656-40600-1-git-send-email-Waiman.Long@hp.com> <1373035656-40600-2-git-send-email-Waiman.Long@hp.com> <alpine.DEB.2.02.1307051911110.32106@ionos.tec.linutronix.de> <51DACADF.4000802@hp.com> <alpine.DEB.2.02.1307151612090.11918@ionos.tec.linutronix.de>
 <51E468A4.3030605@hp.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jul 2013, Waiman Long wrote:
> On 07/15/2013 10:41 AM, Thomas Gleixner wrote:
> > On Mon, 8 Jul 2013, Waiman Long wrote:
> > Sigh. GENERIC means, that you use the generic implementation, ARCH
> > means the architecture has a private implementation of that code.
> > 
> > The generic implementation can use arch specific includes and if there
> > is none we simply fallback to the asm-generic one.
> 
> I used the ARCH+GENERIC to mean using the generic code but with arch specific
> include.

And what's the point of that? I just explained it to you that you do
not need the ARCH=y and GENERIC=y at all.
 
> >   >  Let's start with a simple version because it IS simple and easy
> > > > to analyze and debug and then incrementally build improvements on it
> > > > instead of creating an heuristics monster in the first place, i.e.:
> > > > 
> > > >      if (!spin_is_locked(&lr->lock)&&   try_cmpxchg_once(lr))
> > > >         return 0;
> > > >      return 1;
> > > > 
> > > > Take numbers for this on a zoo of different machines: Intel and AMD,
> > > > old and new.
> > > > 
> > > > Then you can add an incremental patch on that, which add loops and
> > > > hoops. Along with numbers on the same zoo of machines.
> > > I originally tried to do a cmpxchg without waiting and there was
> > > practically no performance gain. I believe that as soon as
> > Well, you did not see a difference on your particular machine. Still
> > we don't have an idea how all of this works on a set of different
> > machines. There is a world beside 8 socket servers.
> 
> I understand that. I can live with try_cmpxchg_once, though doing it
> twice will give a slightly better performance. However, without

I asked you several times now to explain and document the whole thing
with numbers instead of your handwaving "slightly better performance"
arguments.

I CANNOT verify that at all simply because I have no access to a 8
socket machine. Hint: Ask your boss to send me one :)

> waiting for the lock to be free, this patch won't do much good. To
> keep it simple, I can remove the ability to do customization while
> doing cmpxchg once and wait until the lock is free. Please let me
> know if this is acceptable to you.

No, it's not acceptable at all if you are not able to provide data for
1,2,4,8 socket machines (from single core to your precious big
boxes). It's that simple. We are not accepting patches which optimize
for a single use case and might negatively affect 99,9999% of the
existing users which have no access to this kind of hardware unless
proven otherwise.

As I told you versus the qrwlocks: You are missing to explain WHY it
improves your particular workloads and WHY this change wont affect
other workloads. All I can see from your explanations is: Works better
on 8 socket big iron. I have yet to see any numbers that this wont
affect the vast majority of users.

> > Also what's the approach to tune that? Running some random testbench
> > and monitor the results for various settings?
> > 
> > If that's the case we better have a that as variables with generic
> > initial values in the code, which can be modified by sysctl.
> 
> As I said above, I can remove the customization. I may reintroduce user
> customization using sysctl as you suggested in the a follow up patch after
> this one is merged.

And I asked for a step by step approach in the first review, but you
decided to ignore that. And now you think that it's accetable for you
as long as you get what you want. That's not the way it works, really.

> > > > > +		getnstimeofday(&tv2);
> > > > > +		ns = (tv2.tv_sec - tv1.tv_sec) * NSEC_PER_SEC +
> > > > > +		     (tv2.tv_nsec - tv1.tv_nsec);
> > > > > +		pr_info("lockref wait loop time = %lu ns\n", ns);
> > > > Using getnstimeofday() for timestamping and spamming the logs with
> > > > printouts? You can't be serious about that?
> > > > 
q > > > > Thats what tracepoints are for. Tracing is the only way to get proper
> > > > numbers which take preemption, interrupts etc. into account without
> > > > hurting runtime performace.
> > > The _SHOW_WAIT_LOOP_TIME is for debugging and instrumentation purpose only
> > > during development cycle. It is not supposed to be turned on at production
> > > system. I will document that in the code.
> > No, no, no! Again: That's what tracepoints are for.
> > 
> > This kind of debugging is completely pointless. Tracepoints are
> > designed to be low overhead and can be enabled on production
> > systems.
> > 
> > Your debugging depends on slow timestamps against CLOCK_REALTIME and
> > an even slower output via printk. How useful is that if you want to
> > really instrument the behaviour of this code?
> 
> This code is not critical and I can certainly remove it.

Did you even try to understand what I wrote? I did not ask you to
remove instrumentation. I asked you to use useful instrumentation
instead of some totally useless crap.

Thanks,

	tglx


