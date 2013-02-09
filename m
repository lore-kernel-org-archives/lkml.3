Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947541Ab3BIA3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 19:29:07 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:44556 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947419Ab3BIA3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 19:29:05 -0500
Date: Fri, 8 Feb 2013 16:28:58 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        "Magnus Damm <magnus.damm@gmail.com> Linus Torvalds" 
	<torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 00/40] CPU hotplug rework - episode I
Message-ID: <20130209002858.GU2666@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130131120348.372374706@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131120348.372374706@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020900-7408-0000-0000-00000CA509FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 12:11:11PM -0000, Thomas Gleixner wrote:
> The current CPU hotplug implementation has become an increasing
> nightmare full of races and undocumented behaviour. The main issue of
> the current hotplug scheme is the completely asymetric
> startup/teardown process. The hotplug notifiers are mostly
> undocumented and the CPU_* actions in lots of implementations seem to
> be randomly chosen.
> 
> We had a long discussion in San Diego last year about reworking the
> hotplug core into a fully symetric state machine. After a few doomed
> attempts to convert the existing code into a state machine, I finally
> found a workable solution.
> 
> The following patch series implements a trivial array based state
> machine, which replaces the existing steps in cpu_up/down and also the
> notifiers which must run on the hotplugged cpu are converted to a
> callback array. This documents clearly the ordering of the callbacks
> and also makes the asymetric behaviour very obvious.
> 
> This series converts the stop_machine thread to the smpboot
> infrastructure, implements the core state machine and converts all
> notifiers which have ordering constraints plus a randomly chosen bunch
> of other notifiers to the state machine.
> 
> The runtime installed callbacks are immediately executed by the core
> code on or on behalf of all cpus which have already reached the
> corresponding state. A non executing installer function is there as
> well to allow simple migration of the existing notifier maze.
> 
> The diffstat of the complete series is appended below.
> 
>  36 files changed, 1300 insertions(+), 1179 deletions(-)
> 
> We add slightly more code at this stage (225 lines alone in a header
> file), but most of the conversions are removing code and we have only
> tackled about 30 of 130+ instances. Even with the current conversion
> state, the resulting text size shrinks already.
> 
> Known issues:
> The current series has a not yet solved section mismatch issue versus
> the array callbacks which are already installed at compile time.
> 
> There is more work in the pipeline:
> 
>  - Convert all notifiers to the state machine callbacks
> 
>  - Analyze the asymetric callbacks and fix them if possible or at
>    least document why they need to be asymetric.
> 
>  - Unify the low level bringup across the architectures
>    (e.g. synchronization between boot and hotplugged cpus, common
>    setups, scheduler exposure, etc.)
> 
> At the end hotplug should run through an array of callbacks on both
> sides with explicit core synchronization points. The ordering should
> look like this:
> 
> CPUHP_OFFLINE                   // Start state.
> CPUHP_PREP_<hardware>           // Kick CPU into life / let it die
> CPUHP_PREP_<datastructures>     // Get datastructures set up / freed.
> CPUHP_PREP_<threads>            // Create threads for cpu
> CPUHP_SYNC			// Synchronization point
> CPUHP_INIT_<hardware>		// Startup/teardown on the CPU (interrupts, timers ...)
> CPUHP_SCHED_<stuff on CPU>      // Unpark/park per cpu local threads on the CPU.
> CPUHP_ENABLE_<stuff_on_CPU>	// Enable/disable facilities 
> CPUHP_SYNC			// Synchronization point
> CPUHP_SCHED                     // Expose/remove CPU from general scheduler.
> CPUHP_ONLINE                    // Final state
> 
> All PREP states can fail and the corresponding teardown callbacks are
> invoked in the same way as they are invoked on offlining.
> 
> The existing DOWN_PREPARE notifier has only two instances which
> actually might prevent the CPU from going down: rcu_tree and
> padata. We might need to keep them, but these can be explicitly
> documented asymetric states.
> 
> Quite some of the ONLINE/DOWN_PREPARE notifiers are racy and need a
> proper inspection. All other valid users of ONLINE/DOWN_PREPARE
> notifiers should be put into the CPUHP_ENABLE state block and be
> executed on the hotplugged CPU. I have not seen a single instance
> (except scheduler) which needs to be executed before we remove the CPU
> from the general scheduler itself.
> 
> This final design needs quite some massaging of the current scheduler
> code, but last time I discussed this with scheduler folks it seemed to
> be doable with a reasonable effort. Other than that I don't see any
> (un)real showstoppers on the horizon.

Very cool!!!  At first glance, this looks like it dovetails very
nicely with Srivatsa Bhat's work on the hotplug locking.

							Thanx, Paul

> Thanks,
> 
> 	tglx
> ---
>  arch/arm/kernel/perf_event_cpu.c              |   28 -
>  arch/arm/vfp/vfpmodule.c                      |   29 -
>  arch/blackfin/kernel/perf_event.c             |   25 -
>  arch/powerpc/perf/core-book3s.c               |   29 -
>  arch/s390/kernel/perf_cpum_cf.c               |   37 -
>  arch/s390/kernel/vtime.c                      |   18 
>  arch/sh/kernel/perf_event.c                   |   22 
>  arch/x86/kernel/apic/x2apic_cluster.c         |   80 +--
>  arch/x86/kernel/cpu/perf_event.c              |   78 +--
>  arch/x86/kernel/cpu/perf_event_amd.c          |    6 
>  arch/x86/kernel/cpu/perf_event_amd_ibs.c      |   54 --
>  arch/x86/kernel/cpu/perf_event_intel.c        |    6 
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c |  109 +---
>  arch/x86/kernel/tboot.c                       |   23 
>  drivers/clocksource/arm_generic.c             |   40 -
>  drivers/cpufreq/cpufreq_stats.c               |   55 --
>  include/linux/cpu.h                           |   45 -
>  include/linux/cpuhotplug.h                    |  207 ++++++++
>  include/linux/perf_event.h                    |   21 
>  include/linux/smpboot.h                       |    5 
>  init/main.c                                   |   15 
>  kernel/cpu.c                                  |  613 ++++++++++++++++++++++----
>  kernel/events/core.c                          |   36 -
>  kernel/hrtimer.c                              |   47 -
>  kernel/profile.c                              |   92 +--
>  kernel/rcutree.c                              |   95 +---
>  kernel/sched/core.c                           |  251 ++++------
>  kernel/sched/fair.c                           |   16 
>  kernel/smp.c                                  |   50 --
>  kernel/smpboot.c                              |   11 
>  kernel/smpboot.h                              |    4 
>  kernel/stop_machine.c                         |  154 ++----
>  kernel/time/clockevents.c                     |   13 
>  kernel/timer.c                                |   43 -
>  kernel/workqueue.c                            |   80 +--
>  virt/kvm/kvm_main.c                           |   42 -
>  36 files changed, 1300 insertions(+), 1179 deletions(-)
> 
> 
> 

