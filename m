Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab3G2FMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 01:12:06 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:41605 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab3G2FMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 01:12:03 -0400
Date: Mon, 29 Jul 2013 10:41:25 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>, deepthi@linux.vnet.ibm.com,
        shangw@linux.vnet.ibm.com, arnd@arndb.de, linux-pm@vger.kernel.org,
        geoff@infradead.org, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, rjw@sisk.pl,
        paul.gortmaker@windriver.com, paulus@samba.org,
        srivatsa.bhat@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        john.stultz@linaro.org, tglx@linutronix.de, paulmck@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, chenhui.zhao@freescale.com
Subject: Re: [RFC PATCH 4/5] cpuidle/ppc: CPU goes tickless if there are no
 arch-specific constraints
Message-ID: <20130729051125.GA8832@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20130725090016.12500.28888.stgit@preeti.in.ibm.com>
 <20130725090302.12500.42998.stgit@preeti.in.ibm.com>
 <20130725133044.GA7400@somewhere>
 <51F1E15B.3050106@linux.vnet.ibm.com>
 <1374906605.3795.11.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1374906605.3795.11.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072905-8256-0000-0000-0000088D99B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Benjamin Herrenschmidt <benh@kernel.crashing.org> [2013-07-27 16:30:05]:

> On Fri, 2013-07-26 at 08:09 +0530, Preeti U Murthy wrote:
> > *The lapic of a broadcast CPU is active always*. Say CPUX, wants the
> > broadcast CPU to wake it up at timeX.  Since we cannot program the lapic
> > of a remote CPU, CPUX will need to send an IPI to the broadcast CPU,
> > asking it to program its lapic to fire at timeX so as to wake up CPUX.
> > *With multiple CPUs the overhead of sending IPI, could result in
> > performance bottlenecks and may not scale well.*
> > 
> > Hence the workaround is that the broadcast CPU on each of its timer
> > interrupt checks if any of the next timer event of a CPU in deep idle
> > state has expired, which can very well be found from dev->next_event of
> > that CPU. For example the timeX that has been mentioned above has
> > expired. If so the broadcast handler is called to send an IPI to the
> > idling CPU to wake it up.
> > 
> > *If the broadcast CPU, is in tickless idle, its timer interrupt could be
> > many ticks away. It could miss waking up a CPU in deep idle*, if its
> > wakeup is much before this timer interrupt of the broadcast CPU. But
> > without tickless idle, atleast at each period we are assured of a timer
> > interrupt. At which time broadcast handling is done as stated in the
> > previous paragraph and we will not miss wakeup of CPUs in deep idle states.
> 
> But that means a great loss of power saving on the broadcast CPU when the machine
> is basically completely idle. We might be able to come up with some thing better.

Hi Ben,

Yes, we will need to improve on this case in stages.  In the current
design, we will have to hold one of the CPU in shallow idle state
(nap) to wakeup other deep idle cpus.  The cost of keeping the
periodic tick ON on the broadcast CPU in minimal (but not zero) since
we would not allow that CPU to enter any deep idle states even if
there were no periodic timers queued.
 
> (Note : I do no know the timer offload code if it exists already, I'm describing
> how things could happen "out of the blue" without any knowledge of pre-existing
> framework here)
> 
> We can know when the broadcast CPU expects to wake up next. When a CPU goes to
> a deep sleep state, it can then
> 
>  - Indicate to the broadcast CPU when it intends to be woken up by queuing
> itself into an ordered queue (ordered by target wakeup time). (OPTIMISATION:
> Play with the locality of that: have one queue (and one "broadcast CPU") per
> chip or per node instead of a global one to limit cache bouncing).
> 
>  - Check if that happens before the broadcast CPU intended wake time (we
> need statistics to see how often that happens), and in that case send an IPI
> to wake it up now. When the broadcast CPU goes to sleep, it limits its sleep
> time to the min of it's intended sleep time and the new sleeper time.
> (OPTIMISATION: Dynamically chose a broadcast CPU based on closest expiry ?)

This will be an improvement and the idea we have is to have
a hierarchical method of finding a waking CPU within core/socket/node
in order to find a better fit and ultimately send IPI to wakeup
a broadcast CPU only if there is no other fit.  This condition would
imply that more CPUs are in deep idle state and the cost of sending an
IPI to reprogram the broadcast cpu's local timer may well payoff.

>  - We can probably limit spurrious wakeups a *LOT* by aligning that target time
> to a global jiffy boundary, meaning that several CPUs going to idle are likely
> to be choosing the same. Or maybe better, an adaptative alignment by essentially
> getting more coarse grained as we go further in the future
> 
>  - When the "broadcast" CPU goes to sleep, it can play the same game of alignment.

CPUs entering deep idle state would need to wakeup only at a jiffy
boundary or the jiffy boundary earlier than the target wakeup time.
Your point is can the broadcast cpu wakeup the sleeping CPU *around*
the designated wakeup time (earlier) so as to avoid reprogramming its
timer.
 
> I don't like the concept of a dedicated broadcast CPU however. I'd rather have a
> general queue (or per node) of sleepers needing a wakeup and more/less dynamically
> pick a waker to be the last man standing, but it does make things a bit more
> tricky with tickless scheduler (non-idle).
> 
> Still, I wonder if we could just have some algorithm to actually pick wakers
> more dynamically based on who ever has the closest "next wakeup" planned,
> that sort of thing. A fixed broadcaster will create an imbalance in
> power/thermal within the chip in addition to needing to be moved around on
> hotplug etc...

Right Ben.  The hierarchical way of selecting the waker will help us
have multiple wakers in different sockets/cores.  The broadcast
framework allows us to decouple the cpu going to idle and the waker to
be selected independently.  This patch series is the start where we
pick one and allow it to move around.  The ideal goal to achieve would
be that we can have multiple wakers serving wakeup requests from
a queue (mask) and wakers are generally busy or just idle cpu who need
not prevent itself from going to tickless idle or deep idle states
just to wakeup another one.  This optimizations can adapt to the case
where we will need the last cpu to stay in shallow idle mode and in
tickless with the wakeup events queued to target one of the deep idle
cpu.

--Vaidy

