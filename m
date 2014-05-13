Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbaEMV1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 17:27:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:38122 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbaEMV1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 17:27:16 -0400
Date: Tue, 13 May 2014 23:27:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <darren@dvhart.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>,
        Roland McGrath <roland@hack.frob.com>,
        Carlos ODonell <carlos@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 1/3] rtmutex: Add missing deadlock check
In-Reply-To: <20140513203619.GV18164@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1405132301530.6261@ionos.tec.linutronix.de>
References: <20140512190438.314125476@linutronix.de> <20140512201700.999660035@linutronix.de> <5371B2D9.8060405@cn.fujitsu.com> <20140513084815.GB2485@laptop.programming.kicks-ass.net> <alpine.DEB.2.02.1405132117110.6261@ionos.tec.linutronix.de>
 <20140513162041.3405b668@gandalf.local.home> <20140513203619.GV18164@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014, Paul E. McKenney wrote:
> On Tue, May 13, 2014 at 04:20:41PM -0400, Steven Rostedt wrote:
> > What about having a module that creates a bunch of threads and forces
> > all the scenarios that we want to test? Wouldn't it be easier to do
> > than to have a userspace interface to dictate commands to the kernel?
> 
> I second this approach!  The kernel environment makes it -much- easier
> to force races and other conditions, which turns into much simpler and
> more effective tests.

The point of the rtmutex tester was NOT to force races and stuff, it
was intended to be a formal test for certain static scenarios:

   - verify boosting / debosting
   - verify set_scheduler interaction
   - verify deadlock detection 

The latter was incomplete and therefor missed the futex wreckage :(

Having a formal checker makes a lot of sense.

Plastering the code with a gazillion of trace_printks, waiting several
hours for each iteration and staring into several GB of traces just to
figure out, that it is an algorithmic issue, is utter waste of time
and nerves. And that stuff is definitely complex enough to justify a
static checker.

Back then when I wrote it, it unearthed quite some logic bugs. And I
needed the schedule_rt_mutex() hack to verify the BKL interaction and
the lock steal machinery, which made it impossible to be a module. It
could have been done, but that'd have been even more ugly hackery.

So I made it a user space interface to add/modify test cases without
recompiling the kernel.  But now with BKL and the lock steal muck
gone, we simply might kill it.

Now that allows a module, but then I'm still not sure whether formal
verification rules are fun to code in C. There are certainly better
ways than the *.tst rules I defined back then. But yes, we could add a
similar cryptic thing with static arrays of OP/Data pairs in C.

Thanks,

	tglx


