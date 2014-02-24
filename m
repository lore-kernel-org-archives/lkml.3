Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbaBXPQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:16:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40343 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaBXPQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:16:56 -0500
Date: Mon, 24 Feb 2014 16:16:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: mingo@kernel.org, tglx@linutronix.de, rjw@rjwysocki.net,
        nicolas.pitre@linaro.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/5] idle/cpuidle: Split cpuidle_idle_call main
 function into smaller functions
Message-ID: <20140224151644.GY27965@twins.programming.kicks-ass.net>
References: <1393250151-6982-1-git-send-email-daniel.lezcano@linaro.org>
 <20140224150004.GX27965@twins.programming.kicks-ass.net>
 <530B6147.6010301@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530B6147.6010301@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 04:12:07PM +0100, Daniel Lezcano wrote:
> On 02/24/2014 04:00 PM, Peter Zijlstra wrote:
> >
> >
> >None of this actually applies :/ I'm having major conflicts in
> >driveres/cpuidle/cpuidle.c.
> 
> Ok, except if I am missing something, the patchset is based on top of
> tip/sched/core (commit 6990566).

Ah! So the below commit from the timers/core branch is in the way.

Thomas, Ingo, how do we go about solving this sched/core vs timers/core
conflict?

---

# git log 6990566..tip/master drivers/cpuidle/
commit 2f60b8ae0b2a006e4d3452e57ea98b59ce985d14
Merge: 9eaf844efc23 849401b66d30
Author: Ingo Molnar <mingo@kernel.org>
Date:   Sat Feb 22 18:52:27 2014 +0100

    Merge branch 'timers/core'

commit ba8f20c2eb4158a443e9d6a909aee5010efa0c69
Author: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date:   Fri Feb 7 13:36:52 2014 +0530

    cpuidle: Handle clockevents_notify(BROADCAST_ENTER) failure
    
    Some archs set the CPUIDLE_FLAG_TIMER_STOP flag for idle states in which the
    local timers stop. The cpuidle_idle_call() currently handles such idle states
    by calling into the broadcast framework so as to wakeup CPUs at their next
    wakeup event. With the hrtimer mode of broadcast, the BROADCAST_ENTER call
    into the broadcast frameowork can fail for archs that do not have an external
    clock device to handle wakeups and the CPU in question has thus to be made
    the stand by CPU. This patch handles such cases by failing the call into
    cpuidle so that the arch can take some default action. The arch will certainly
    not enter a similar idle state because a failed cpuidle call will also implicitly
    indicate that the broadcast framework has not registered this CPU to be woken up.
    Hence we are safe if we fail the cpuidle call.
    
    In the process move the functions that trace idle statistics just before and
    after the entry and exit into idle states respectively. In other
    scenarios where the call to cpuidle fails, we end up not tracing idle
    entry and exit since a decision on an idle state could not be taken. Similarly
    when the call to broadcast framework fails, we skip tracing idle statistics
    because we are in no further position to take a decision on an alternative
    idle state to enter into.
    
    Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
    Cc: deepthi@linux.vnet.ibm.com
    Cc: paulmck@linux.vnet.ibm.com
    Cc: fweisbec@gmail.com
    Cc: paulus@samba.org
    Cc: srivatsa.bhat@linux.vnet.ibm.com
    Cc: svaidy@linux.vnet.ibm.com
    Cc: peterz@infradead.org
    Cc: benh@kernel.crashing.org
    Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Cc: linuxppc-dev@lists.ozlabs.org
    Link: http://lkml.kernel.org/r/20140207080652.17187.66344.stgit@preeti.in.ibm.com
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

