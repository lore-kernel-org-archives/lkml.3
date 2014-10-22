Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaJVOiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:38:46 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:38381 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaJVOio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:38:44 -0400
Date: Wed, 22 Oct 2014 07:38:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: lockdep splat in CPU hotplug
Message-ID: <20141022143837.GW4977@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LNX.2.00.1410211255531.24255@pobox.suse.cz>
 <alpine.LNX.2.00.1410221125280.22681@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1410221125280.22681@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102214-0033-0000-0000-0000026B47B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 11:53:49AM +0200, Jiri Kosina wrote:
> On Tue, 21 Oct 2014, Jiri Kosina wrote:
> 
> > Hi,
> > 
> > I am seeing the lockdep report below when resuming from suspend-to-disk 
> > with current Linus' tree (c2661b80609).
> > 
> > The reason for CCing Ingo and Peter is that I can't make any sense of one 
> > of the stacktraces lockdep is providing.
> > 
> > Please have a look at the very first stacktrace in the dump, where lockdep 
> > is trying to explain where cpu_hotplug.lock#2 has been acquired. It seems 
> > to imply that cpuidle_pause() is taking cpu_hotplug.lock, but that's not 
> > the case at all.
> > 
> > What am I missing?
> 
> Okay, reverting 442bf3aaf55a ("sched: Let the scheduler see CPU idle 
> states") and followup 83a0a96a5f26 ("sched/fair: Leverage the idle state 
> info when choosing the "idlest" cpu") which depends on it makes the splat 
> go away.
> 
> Just for the sake of testing the hypothesis, I did just the minimal change 
> below on top of current Linus' tree, and it also makes the splat go away 
> (of course it's totally incorrect thing to do by itself alone):
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 125150d..d31e04c 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -225,12 +225,6 @@ void cpuidle_uninstall_idle_handler(void)
>  		initialized = 0;
>  		wake_up_all_idle_cpus();
>  	}
> -
> -	/*
> -	 * Make sure external observers (such as the scheduler)
> -	 * are done looking at pointed idle states.
> -	 */
> -	synchronize_rcu();
>  }
> 
>  /**
> 
> So indeed 442bf3aaf55a is guilty.
> 
> Paul was stating yesterday that it can't be the try_get_online_cpus() in 
> synchronize_sched_expedited(), as it's doing only trylock. There are 
> however more places where synchronize_sched_expedited() is acquiring 
> cpu_hotplug.lock unconditionally by calling put_online_cpus(), so the race 
> seems real.

Gah!  So I only half-eliminated the deadlock between
synchronize_sched_expedited() and CPU hotplug.  Back to the drawing
board...

							Thanx, Paul

> Adding people involved in 442bf3aaf55a to CC.
> 
> Still, the lockdep stacktrace is bogus and didn't really help 
> understanding this. Any idea why it's wrong?
> 
> >  ======================================================
> >  [ INFO: possible circular locking dependency detected ]
> >  3.18.0-rc1-00069-gc2661b8 #1 Not tainted
> >  -------------------------------------------------------
> >  do_s2disk/2367 is trying to acquire lock:
> >   (cpuidle_lock){+.+.+.}, at: [<ffffffff814916c2>] cpuidle_pause_and_lock+0x12/0x20
> >  
> > but task is already holding lock:
> >   (cpu_hotplug.lock#2){+.+.+.}, at: [<ffffffff810522ea>] cpu_hotplug_begin+0x4a/0x80
> >  
> > which lock already depends on the new lock.
> > 
> > the existing dependency chain (in reverse order) is:
> > 
> > -> #1 (cpu_hotplug.lock#2){+.+.+.}:
> >         [<ffffffff81099fac>] lock_acquire+0xac/0x130
> >         [<ffffffff815b9f2c>] mutex_lock_nested+0x5c/0x3b0
> >         [<ffffffff81491892>] cpuidle_pause+0x12/0x30
> >         [<ffffffff81402314>] dpm_suspend_noirq+0x44/0x340
> >         [<ffffffff81402958>] dpm_suspend_end+0x38/0x80
> >         [<ffffffff810a07bd>] hibernation_snapshot+0xcd/0x370
> >         [<ffffffff810a1248>] hibernate+0x168/0x210
> >         [<ffffffff8109e9b4>] state_store+0xe4/0xf0
> >         [<ffffffff813003ef>] kobj_attr_store+0xf/0x20
> >         [<ffffffff8121e9a3>] sysfs_kf_write+0x43/0x60
> >         [<ffffffff8121e287>] kernfs_fop_write+0xe7/0x170
> >         [<ffffffff811a7342>] vfs_write+0xb2/0x1f0
> >         [<ffffffff811a7da4>] SyS_write+0x44/0xb0
> >         [<ffffffff815be856>] system_call_fastpath+0x16/0x1b
> >  
> > -> #0 (cpuidle_lock){+.+.+.}:
> >         [<ffffffff81099433>] __lock_acquire+0x1a03/0x1e30
> >         [<ffffffff81099fac>] lock_acquire+0xac/0x130
> >         [<ffffffff815b9f2c>] mutex_lock_nested+0x5c/0x3b0
> >         [<ffffffff814916c2>] cpuidle_pause_and_lock+0x12/0x20
> >         [<ffffffffc02e184c>] acpi_processor_hotplug+0x45/0x8a [processor]
> >         [<ffffffffc02df25a>] acpi_cpu_soft_notify+0xad/0xe3 [processor]
> >         [<ffffffff81071393>] notifier_call_chain+0x53/0xa0
> >         [<ffffffff810713e9>] __raw_notifier_call_chain+0x9/0x10
> >         [<ffffffff810521ce>] cpu_notify+0x1e/0x40
> >         [<ffffffff810524a8>] _cpu_up+0x148/0x160
> >         [<ffffffff815a7b99>] enable_nonboot_cpus+0xc9/0x1d0
> >         [<ffffffff810a0955>] hibernation_snapshot+0x265/0x370
> >         [<ffffffff810a1248>] hibernate+0x168/0x210
> >         [<ffffffff8109e9b4>] state_store+0xe4/0xf0
> >         [<ffffffff813003ef>] kobj_attr_store+0xf/0x20
> >         [<ffffffff8121e9a3>] sysfs_kf_write+0x43/0x60
> >         [<ffffffff8121e287>] kernfs_fop_write+0xe7/0x170
> >         [<ffffffff811a7342>] vfs_write+0xb2/0x1f0
> >         [<ffffffff811a7da4>] SyS_write+0x44/0xb0
> >         [<ffffffff815be856>] system_call_fastpath+0x16/0x1b
> >  
> > other info that might help us debug this:
> > 
> >   Possible unsafe locking scenario:
> > 
> >         CPU0                    CPU1
> >         ----                    ----
> >    lock(cpu_hotplug.lock#2);
> >                                 lock(cpuidle_lock);
> >                                 lock(cpu_hotplug.lock#2);
> >    lock(cpuidle_lock);
> >  
> >  *** DEADLOCK ***
> > 
> >  8 locks held by do_s2disk/2367:
> >   #0:  (sb_writers#6){.+.+.+}, at: [<ffffffff811a7443>] vfs_write+0x1b3/0x1f0
> >   #1:  (&of->mutex){+.+.+.}, at: [<ffffffff8121e25b>] kernfs_fop_write+0xbb/0x170
> >   #2:  (s_active#188){.+.+.+}, at: [<ffffffff8121e263>] kernfs_fop_write+0xc3/0x170
> >   #3:  (pm_mutex){+.+.+.}, at: [<ffffffff810a112e>] hibernate+0x4e/0x210
> >   #4:  (device_hotplug_lock){+.+.+.}, at: [<ffffffff813f1b52>] lock_device_hotplug+0x12/0x20
> >   #5:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff815a7aef>] enable_nonboot_cpus+0x1f/0x1d0
> >   #6:  (cpu_hotplug.lock){++++++}, at: [<ffffffff810522a0>] cpu_hotplug_begin+0x0/0x80
> >   #7:  (cpu_hotplug.lock#2){+.+.+.}, at: [<ffffffff810522ea>] cpu_hotplug_begin+0x4a/0x80
> >  
> > stack backtrace:
> >  CPU: 1 PID: 2367 Comm: do_s2disk Not tainted 3.18.0-rc1-00069-g4da0564 #1
> >  Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
> >   ffffffff823e4330 ffff8800789e7a48 ffffffff815b6754 0000000000001a69
> >   ffffffff823e4330 ffff8800789e7a98 ffffffff815b078b ffff8800741a5510
> >   ffff8800789e7af8 ffff8800741a5ea8 5a024e919538010b ffff8800741a5ea8
> >  Call Trace:
> >   [<ffffffff815b6754>] dump_stack+0x4e/0x68
> >   [<ffffffff815b078b>] print_circular_bug+0x203/0x214
> >   [<ffffffff81099433>] __lock_acquire+0x1a03/0x1e30
> >   [<ffffffff8109766d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
> >   [<ffffffff81099fac>] lock_acquire+0xac/0x130
> >   [<ffffffff814916c2>] ? cpuidle_pause_and_lock+0x12/0x20
> >   [<ffffffff815b9f2c>] mutex_lock_nested+0x5c/0x3b0
> >   [<ffffffff814916c2>] ? cpuidle_pause_and_lock+0x12/0x20
> >   [<ffffffff814916c2>] cpuidle_pause_and_lock+0x12/0x20
> >   [<ffffffffc02e184c>] acpi_processor_hotplug+0x45/0x8a [processor]
> >   [<ffffffffc02df25a>] acpi_cpu_soft_notify+0xad/0xe3 [processor]
> >   [<ffffffff81071393>] notifier_call_chain+0x53/0xa0
> >   [<ffffffff810713e9>] __raw_notifier_call_chain+0x9/0x10
> >   [<ffffffff810521ce>] cpu_notify+0x1e/0x40
> >   [<ffffffff810524a8>] _cpu_up+0x148/0x160
> >   [<ffffffff815a7b99>] enable_nonboot_cpus+0xc9/0x1d0
> >   [<ffffffff810a0955>] hibernation_snapshot+0x265/0x370
> >   [<ffffffff810a1248>] hibernate+0x168/0x210
> >   [<ffffffff8109e9b4>] state_store+0xe4/0xf0
> >   [<ffffffff813003ef>] kobj_attr_store+0xf/0x20
> >   [<ffffffff8121e9a3>] sysfs_kf_write+0x43/0x60
> >   [<ffffffff8121e287>] kernfs_fop_write+0xe7/0x170
> >   [<ffffffff811a7342>] vfs_write+0xb2/0x1f0
> >   [<ffffffff815be87b>] ? sysret_check+0x1b/0x56
> >   [<ffffffff811a7da4>] SyS_write+0x44/0xb0
> >   [<ffffffff815be856>] system_call_fastpath+0x16/0x1b
> 
> -- 
> Jiri Kosina
> SUSE Labs
> 

