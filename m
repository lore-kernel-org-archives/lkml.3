Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab3G2F2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 01:28:37 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:34580 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab3G2F2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 01:28:32 -0400
Date: Mon, 29 Jul 2013 10:58:10 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        deepthi@linux.vnet.ibm.com, shangw@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, geoff@infradead.org,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, rjw@sisk.pl, paul.gortmaker@windriver.com,
        paulus@samba.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, john.stultz@linaro.org, tglx@linutronix.de,
        paulmck@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        chenhui.zhao@freescale.com
Subject: Re: [RFC PATCH 4/5] cpuidle/ppc: CPU goes tickless if there are no
 arch-specific constraints
Message-ID: <20130729052810.GB8832@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20130725090016.12500.28888.stgit@preeti.in.ibm.com>
 <20130725090302.12500.42998.stgit@preeti.in.ibm.com>
 <20130725133044.GA7400@somewhere>
 <51F1E15B.3050106@linux.vnet.ibm.com>
 <1374906605.3795.11.camel@pasglop>
 <51F37BCD.706@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <51F37BCD.706@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072905-9264-0000-0000-000004374EC5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Preeti U Murthy <preeti@linux.vnet.ibm.com> [2013-07-27 13:20:37]:

> Hi Ben,
> 
> On 07/27/2013 12:00 PM, Benjamin Herrenschmidt wrote:
> > On Fri, 2013-07-26 at 08:09 +0530, Preeti U Murthy wrote:
> >> *The lapic of a broadcast CPU is active always*. Say CPUX, wants the
> >> broadcast CPU to wake it up at timeX.  Since we cannot program the lapic
> >> of a remote CPU, CPUX will need to send an IPI to the broadcast CPU,
> >> asking it to program its lapic to fire at timeX so as to wake up CPUX.
> >> *With multiple CPUs the overhead of sending IPI, could result in
> >> performance bottlenecks and may not scale well.*
> >>
> >> Hence the workaround is that the broadcast CPU on each of its timer
> >> interrupt checks if any of the next timer event of a CPU in deep idle
> >> state has expired, which can very well be found from dev->next_event of
> >> that CPU. For example the timeX that has been mentioned above has
> >> expired. If so the broadcast handler is called to send an IPI to the
> >> idling CPU to wake it up.
> >>
> >> *If the broadcast CPU, is in tickless idle, its timer interrupt could be
> >> many ticks away. It could miss waking up a CPU in deep idle*, if its
> >> wakeup is much before this timer interrupt of the broadcast CPU. But
> >> without tickless idle, atleast at each period we are assured of a timer
> >> interrupt. At which time broadcast handling is done as stated in the
> >> previous paragraph and we will not miss wakeup of CPUs in deep idle states.
> > 
> > But that means a great loss of power saving on the broadcast CPU when the machine
> > is basically completely idle. We might be able to come up with some thing better.
> > 
> > (Note : I do no know the timer offload code if it exists already, I'm describing
> > how things could happen "out of the blue" without any knowledge of pre-existing
> > framework here)
> > 
> > We can know when the broadcast CPU expects to wake up next. When a CPU goes to
> > a deep sleep state, it can then
> > 
> >  - Indicate to the broadcast CPU when it intends to be woken up by queuing
> > itself into an ordered queue (ordered by target wakeup time). (OPTIMISATION:
> > Play with the locality of that: have one queue (and one "broadcast CPU") per
> > chip or per node instead of a global one to limit cache bouncing).
> > 
> >  - Check if that happens before the broadcast CPU intended wake time (we
> > need statistics to see how often that happens), and in that case send an IPI
> > to wake it up now. When the broadcast CPU goes to sleep, it limits its sleep
> > time to the min of it's intended sleep time and the new sleeper time.
> > (OPTIMISATION: Dynamically chose a broadcast CPU based on closest expiry ?)
> > 
> >  - We can probably limit spurrious wakeups a *LOT* by aligning that target time
> > to a global jiffy boundary, meaning that several CPUs going to idle are likely
> > to be choosing the same. Or maybe better, an adaptative alignment by essentially
> > getting more coarse grained as we go further in the future
> > 
> >  - When the "broadcast" CPU goes to sleep, it can play the same game of alignment.
> > 
> > I don't like the concept of a dedicated broadcast CPU however. I'd rather have a
> > general queue (or per node) of sleepers needing a wakeup and more/less dynamically
> > pick a waker to be the last man standing, but it does make things a bit more
> > tricky with tickless scheduler (non-idle).
> > 
> > Still, I wonder if we could just have some algorithm to actually pick wakers
> > more dynamically based on who ever has the closest "next wakeup" planned,
> > that sort of thing. A fixed broadcaster will create an imbalance in
> > power/thermal within the chip in addition to needing to be moved around on
> > hotplug etc...
> 
> Thank you for having listed out the above suggestions. Below, I will
> bring out some ideas about how the concerns that you have raised can be
> addressed in the increasing order of priority.
> 
> - To begin with, I think we can have the following model to have the
> responsibility of the broadcast CPU float around certain CPUs. i.e. Not
> have a dedicated broadcast CPU. I will refer to the broadcast CPU as the
> bc_cpu henceforth for convenience.
> 
> 1. The first CPU that intends to enter deep sleep state will be the bc_cpu.
> 
> 2. Every other CPU that intends to enter deep idle state will enter
> themselves into a mask, say the bc_mask, which is already being done
> today, after they check that a bc_cpu has been assigned.
> 
> 3. The bc_cpu should not enter tickless idle, until step 5a holds true.
> 
> 4. So on every timer interrupt, which is at-least every period, it
> checks the bc_mask to see if any CPUs need to be woken up.
> 
> 5. The bc cpu should not enter tickless idle *until* it is de-nominated
> as the bc_cpu. The de-nomination occurs when:
>   a. In one of its timer interrupts, it does broadcast handling to find
> out that there are no CPUs to be woken up.
> 
> 6. So if 5a holds, then there is no bc_cpu anymore until a CPU decides
> to enter deep idle state again, in which case steps 1 to 5 repeat.
> 
> 
> - We could optimize this further, to allow the bc_cpu to enter tickless
> idle, even while it is nominated as one. This can be the next step, if
> we can get the above to work stably.
> 
> You have already brought out this point, so I will just reword it. Each
> time broadcast handling is done, the bc_cpu needs to check if the wakeup
> time of a CPU, that has entered deep idle state, and is yet to be woken
> up, is before the bc_cpu's wakeup time, which was programmed to its
> local events.
> 
> If so, then reprogram the decrementer to the wakeup time of a CPU that
> is in deep idle state.
> 
> But we need to keep in mind one point. When CPUs go into deep idle, they
> cannot program the local timer of the bc_cpu to their wakeup time. This
> is because a CPU cannot program the timer of a remote CPU.
> 
> Therefore the only time we can check if 'wakeup time of the CPU that
> enters deep idle state is before broadcast CPU's intended wake time so
> as to reprogram the decrementer', is in the broadcast handler itself,
> which is done *on* the bc_cpu alone.
> 
> 
> 
> What do you think?
> 
> 
> - Coming to your third suggestion of aligning the wakeup time of CPUs, I
> will spend some time on this and get back regarding the same.

Hi Preeti,

One of Ben's suggestions is to coarse grain the waker's timer event.
The trade off is whether we issue an IPI for each CPU needing a wakeup
or let the bc_cpu wakeup periodically and *see* that there is a new
request.  The interval for a wakeup request will be much coarse grain
than a tick.  We maybe able to easily reduce the power impact of not
letting bc_cpu go tickless by choosing a right coarse grain period.
For example we can let the bc_cpu look for new wakeup requests once in
every 10 or 20 jiffies rather than every jiffy and align the wakeup
requests at this coarse grain wakeup.  We do pay a power penalty by
waking up few jiffies earlier which we can mitigate by reevaluating
the situation and queueing a fine grain timer to the right jiffy on
the bc_cpu if such a situation arises.

The point is a new wakeup request will *ask* for a wakeup later than
the coarse grain period.  So the bc_cpu can wakeup at the coarse time
period and reprogram its timer to the right jiffy.

--Vaidy

