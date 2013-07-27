Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab3G0GcD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 02:32:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:35861 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985Ab3G0Gb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 02:31:59 -0400
Message-ID: <1374906605.3795.11.camel@pasglop>
Subject: Re: [RFC PATCH 4/5] cpuidle/ppc: CPU goes tickless if there are no
 arch-specific constraints
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, rjw@sisk.pl,
        shangw@linux.vnet.ibm.com, arnd@arndb.de, linux-pm@vger.kernel.org,
        geoff@infradead.org, rostedt@goodmis.org, deepthi@linux.vnet.ibm.com,
        paul.gortmaker@windriver.com, paulus@samba.org,
        srivatsa.bhat@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        john.stultz@linaro.org, tglx@linutronix.de, paulmck@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        chenhui.zhao@freescale.com
Date: Sat, 27 Jul 2013 16:30:05 +1000
In-Reply-To: <51F1E15B.3050106@linux.vnet.ibm.com>
References: <20130725090016.12500.28888.stgit@preeti.in.ibm.com>
	 <20130725090302.12500.42998.stgit@preeti.in.ibm.com>
	 <20130725133044.GA7400@somewhere> <51F1E15B.3050106@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-26 at 08:09 +0530, Preeti U Murthy wrote:
> *The lapic of a broadcast CPU is active always*. Say CPUX, wants the
> broadcast CPU to wake it up at timeX.  Since we cannot program the lapic
> of a remote CPU, CPUX will need to send an IPI to the broadcast CPU,
> asking it to program its lapic to fire at timeX so as to wake up CPUX.
> *With multiple CPUs the overhead of sending IPI, could result in
> performance bottlenecks and may not scale well.*
> 
> Hence the workaround is that the broadcast CPU on each of its timer
> interrupt checks if any of the next timer event of a CPU in deep idle
> state has expired, which can very well be found from dev->next_event of
> that CPU. For example the timeX that has been mentioned above has
> expired. If so the broadcast handler is called to send an IPI to the
> idling CPU to wake it up.
> 
> *If the broadcast CPU, is in tickless idle, its timer interrupt could be
> many ticks away. It could miss waking up a CPU in deep idle*, if its
> wakeup is much before this timer interrupt of the broadcast CPU. But
> without tickless idle, atleast at each period we are assured of a timer
> interrupt. At which time broadcast handling is done as stated in the
> previous paragraph and we will not miss wakeup of CPUs in deep idle states.

But that means a great loss of power saving on the broadcast CPU when the machine
is basically completely idle. We might be able to come up with some thing better.

(Note : I do no know the timer offload code if it exists already, I'm describing
how things could happen "out of the blue" without any knowledge of pre-existing
framework here)

We can know when the broadcast CPU expects to wake up next. When a CPU goes to
a deep sleep state, it can then

 - Indicate to the broadcast CPU when it intends to be woken up by queuing
itself into an ordered queue (ordered by target wakeup time). (OPTIMISATION:
Play with the locality of that: have one queue (and one "broadcast CPU") per
chip or per node instead of a global one to limit cache bouncing).

 - Check if that happens before the broadcast CPU intended wake time (we
need statistics to see how often that happens), and in that case send an IPI
to wake it up now. When the broadcast CPU goes to sleep, it limits its sleep
time to the min of it's intended sleep time and the new sleeper time.
(OPTIMISATION: Dynamically chose a broadcast CPU based on closest expiry ?)

 - We can probably limit spurrious wakeups a *LOT* by aligning that target time
to a global jiffy boundary, meaning that several CPUs going to idle are likely
to be choosing the same. Or maybe better, an adaptative alignment by essentially
getting more coarse grained as we go further in the future

 - When the "broadcast" CPU goes to sleep, it can play the same game of alignment.

I don't like the concept of a dedicated broadcast CPU however. I'd rather have a
general queue (or per node) of sleepers needing a wakeup and more/less dynamically
pick a waker to be the last man standing, but it does make things a bit more
tricky with tickless scheduler (non-idle).

Still, I wonder if we could just have some algorithm to actually pick wakers
more dynamically based on who ever has the closest "next wakeup" planned,
that sort of thing. A fixed broadcaster will create an imbalance in
power/thermal within the chip in addition to needing to be moved around on
hotplug etc...

Cheers,
Ben.


