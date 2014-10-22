Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbaJVSq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:46:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54570 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbaJVSq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:46:56 -0400
Date: Wed, 22 Oct 2014 20:46:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: lockdep splat in CPU hotplug
Message-ID: <20141022184627.GA3010@pd.tnic>
References: <alpine.LNX.2.00.1410211255531.24255@pobox.suse.cz>
 <20141021145809.GA799@home.goodmis.org>
 <alpine.LNX.2.00.1410211703170.24255@pobox.suse.cz>
 <20141022143728.18d1eb3d@gandalf.local.home>
 <alpine.LNX.2.00.1410222040080.17725@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1410222040080.17725@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 08:40:21PM +0200, Jiri Kosina wrote:
> Yes, it's 100% reliable for me.

FWIW, I see that same splat here too, after a suspend-to-disk run:

...
[60077.352314] PM: Hibernation mode set to 'shutdown'
[60077.467384] PM: Syncing filesystems ... done.
[60077.479538] Freezing user space processes ... (elapsed 0.003 seconds) done.
[60077.490367] PM: Marking nosave pages: [mem 0x00000000-0x00000fff]
[60077.496504] PM: Marking nosave pages: [mem 0x0009e000-0x000fffff]
[60077.502622] PM: Marking nosave pages: [mem 0xba9b8000-0xbca4dfff]
[60077.508843] PM: Marking nosave pages: [mem 0xbca4f000-0xbcc54fff]
[60077.514962] PM: Marking nosave pages: [mem 0xbd083000-0xbd7f3fff]
[60077.521088] PM: Marking nosave pages: [mem 0xbd800000-0x100000fff]
[60077.527846] PM: Basic memory bitmaps created
[60077.532122] PM: Preallocating image memory... done (allocated 988772 pages)
[60078.526047] PM: Allocated 3955088 kbytes in 0.98 seconds (4035.80 MB/s)
[60078.532681] Freezing remaining freezable tasks ... (elapsed 0.002 seconds) done.
[60078.545755] serial 00:06: disabled
[60078.546092] serial 00:06: System wakeup disabled by ACPI
[60080.973122] PM: freeze of devices complete after 2431.225 msecs
[60080.975511] PM: late freeze of devices complete after 2.206 msecs
[60080.980676] PM: noirq freeze of devices complete after 4.982 msecs
[60080.980877] Disabling non-boot CPUs ...
[60080.985500] smpboot: CPU 1 is now offline
[60080.990958] smpboot: CPU 2 is now offline
[60080.996340] smpboot: CPU 3 is now offline
[60081.003775] smpboot: CPU 4 is now offline
[60081.009236] smpboot: CPU 5 is now offline
[60081.017157] smpboot: CPU 6 is now offline
[60081.022512] smpboot: CPU 7 is now offline
[60081.025702] PM: Creating hibernation image:
[60082.243068] PM: Need to copy 1010324 pages
[60082.243219] PM: Normal pages needed: 1010324 + 1024, available pages: 3158476
[60081.301349] LVT offset 0 assigned for vector 0x400
[60081.302020] Enabling non-boot CPUs ...
[60081.302249] x86: Booting SMP configuration:
[60081.302378] smpboot: Booting Node 0 Processor 1 APIC 0x11
[60081.316879] 
[60081.316933] ======================================================
[60081.317119] [ INFO: possible circular locking dependency detected ]
[60081.317308] 3.18.0-rc1+ #1 Not tainted
[60081.317423] -------------------------------------------------------
[60081.317640] hib.sh/2232 is trying to acquire lock:
[60081.317786]  (cpuidle_lock){+.+.+.}, at: [<ffffffff814e3c67>] cpuidle_pause_and_lock+0x17/0x20
[60081.318070] 
[60081.318070] but task is already holding lock:
[60081.318247]  (cpu_hotplug.lock#2){+.+.+.}, at: [<ffffffff810516c8>] cpu_hotplug_begin+0x58/0x90
[60081.318537] 
[60081.318537] which lock already depends on the new lock.
[60081.318537] 
[60081.318810] 
[60081.318810] the existing dependency chain (in reverse order) is:
[60081.319034] 
[60081.319034] -> #1 (cpu_hotplug.lock#2){+.+.+.}:
[60081.319206]        [<ffffffff8109f68d>] lock_acquire+0xdd/0x2d0
[60081.319391]        [<ffffffff81644d2e>] mutex_lock_nested+0x5e/0x410
[60081.319589]        [<ffffffff814e3e27>] cpuidle_pause+0x17/0x30
[60081.319774]        [<ffffffff813fda8e>] dpm_suspend_noirq+0x6e/0x640
[60081.319999]        [<ffffffff813fe6bf>] dpm_suspend_end+0x3f/0x90
[60081.320189]        [<ffffffff810a8f61>] hibernation_snapshot+0xe1/0x790
[60081.320394]        [<ffffffff810a9d5a>] hibernate+0x14a/0x1d0
[60081.320574]        [<ffffffff810a59c4>] state_store+0xe4/0xf0
[60081.320755]        [<ffffffff812f0f2f>] kobj_attr_store+0xf/0x20
[60081.320944]        [<ffffffff811fbce0>] sysfs_kf_write+0x50/0x70
[60081.321131]        [<ffffffff811fafe5>] kernfs_fop_write+0x105/0x190
[60081.321357]        [<ffffffff8118335d>] vfs_write+0xbd/0x1d0
[60081.321534]        [<ffffffff81183dc2>] SyS_write+0x52/0xc0
[60081.321709]        [<ffffffff816490d6>] system_call_fastpath+0x16/0x1b
[60081.321912] 
[60081.321912] -> #0 (cpuidle_lock){+.+.+.}:
[60081.322062]        [<ffffffff8109e9a4>] __lock_acquire+0x2034/0x2410
[60081.322259]        [<ffffffff8109f68d>] lock_acquire+0xdd/0x2d0
[60081.322472]        [<ffffffff81644d2e>] mutex_lock_nested+0x5e/0x410
[60081.322669]        [<ffffffff814e3c67>] cpuidle_pause_and_lock+0x17/0x20
[60081.322877]        [<ffffffff8138032c>] acpi_processor_hotplug+0x4f/0x8d
[60081.323085]        [<ffffffff8137e512>] acpi_cpu_soft_notify+0xb2/0xe8
[60081.323287]        [<ffffffff81076255>] notifier_call_chain+0x55/0xb0
[60081.323487]        [<ffffffff810762be>] __raw_notifier_call_chain+0xe/0x10
[60081.323727]        [<ffffffff810515a3>] cpu_notify+0x23/0x40
[60081.323904]        [<ffffffff810518a0>] _cpu_up+0x160/0x170
[60081.324079]        [<ffffffff8163cda3>] enable_nonboot_cpus+0xf3/0x4b0
[60081.324282]        [<ffffffff810a9165>] hibernation_snapshot+0x2e5/0x790
[60081.324489]        [<ffffffff810a9d5a>] hibernate+0x14a/0x1d0
[60081.324669]        [<ffffffff810a59c4>] state_store+0xe4/0xf0
[60081.324878]        [<ffffffff812f0f2f>] kobj_attr_store+0xf/0x20
[60081.325066]        [<ffffffff811fbce0>] sysfs_kf_write+0x50/0x70
[60081.325253]        [<ffffffff811fafe5>] kernfs_fop_write+0x105/0x190
[60081.325450]        [<ffffffff8118335d>] vfs_write+0xbd/0x1d0
[60081.325627]        [<ffffffff81183dc2>] SyS_write+0x52/0xc0
[60081.325801]        [<ffffffff816490d6>] system_call_fastpath+0x16/0x1b
[60081.326032] 
[60081.326032] other info that might help us debug this:
[60081.326032] 
[60081.326272]  Possible unsafe locking scenario:
[60081.326272] 
[60081.326451]        CPU0                    CPU1
[60081.326589]        ----                    ----
[60081.326726]   lock(cpu_hotplug.lock#2);
[60081.326861]                                lock(cpuidle_lock);
[60081.327048]                                lock(cpu_hotplug.lock#2);
[60081.327284]   lock(cpuidle_lock);
[60081.327398] 
[60081.327398]  *** DEADLOCK ***
[60081.327398] 
[60081.327577] 8 locks held by hib.sh/2232:
[60081.327697]  #0:  (sb_writers#6){.+.+.+}, at: [<ffffffff8118342b>] vfs_write+0x18b/0x1d0
[60081.327974]  #1:  (&of->mutex){+.+.+.}, at: [<ffffffff811fafb7>] kernfs_fop_write+0xd7/0x190
[60081.328255]  #2:  (s_active#141){.+.+.+}, at: [<ffffffff811fafc0>] kernfs_fop_write+0xe0/0x190
[60081.328575]  #3:  (pm_mutex){+.+.+.}, at: [<ffffffff810a9c4a>] hibernate+0x3a/0x1d0
[60081.328835]  #4:  (device_hotplug_lock){+.+.+.}, at: [<ffffffff813eeae7>] lock_device_hotplug+0x17/0x20
[60081.329145]  #5:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8163ccdf>] enable_nonboot_cpus+0x2f/0x4b0
[60081.329456]  #6:  (cpu_hotplug.lock){++++++}, at: [<ffffffff81051675>] cpu_hotplug_begin+0x5/0x90
[60081.329779]  #7:  (cpu_hotplug.lock#2){+.+.+.}, at: [<ffffffff810516c8>] cpu_hotplug_begin+0x58/0x90
[60081.330085] 
[60081.330085] stack backtrace:
[60081.330220] CPU: 0 PID: 2232 Comm: hib.sh Not tainted 3.18.0-rc1+ #1
[60081.330411] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97 EVO R2.0, BIOS 1503 01/16/2013
[60081.330706]  ffffffff8242aa50 ffff880381fcf9f8 ffffffff81640239 0000000000000000
[60081.330980]  ffffffff8247aee0 ffff880381fcfa48 ffffffff8163f3e8 0000000000000008
[60081.331224]  ffff880381fcfaa8 ffff880381fcfa48 ffff88038d7e9c28 ffff88038d7e9530
[60081.331468] Call Trace:
[60081.331548]  [<ffffffff81640239>] dump_stack+0x4f/0x7c
[60081.331705]  [<ffffffff8163f3e8>] print_circular_bug+0x2b8/0x2c9
[60081.331888]  [<ffffffff8109e9a4>] __lock_acquire+0x2034/0x2410
[60081.332066]  [<ffffffff811758c9>] ? kfree+0xc9/0x3a0
[60081.332247]  [<ffffffff8109f68d>] lock_acquire+0xdd/0x2d0
[60081.332412]  [<ffffffff814e3c67>] ? cpuidle_pause_and_lock+0x17/0x20
[60081.332606]  [<ffffffff814e3c67>] ? cpuidle_pause_and_lock+0x17/0x20
[60081.332799]  [<ffffffff81644d2e>] mutex_lock_nested+0x5e/0x410
[60081.332976]  [<ffffffff814e3c67>] ? cpuidle_pause_and_lock+0x17/0x20
[60081.333169]  [<ffffffff81354c1d>] ? acpi_evaluate_integer+0x34/0x52
[60081.333387]  [<ffffffff814e3c67>] ? cpuidle_pause_and_lock+0x17/0x20
[60081.333580]  [<ffffffff814e3c67>] cpuidle_pause_and_lock+0x17/0x20
[60081.333767]  [<ffffffff8138032c>] acpi_processor_hotplug+0x4f/0x8d
[60081.333955]  [<ffffffff8137e512>] acpi_cpu_soft_notify+0xb2/0xe8
[60081.334137]  [<ffffffff81076255>] notifier_call_chain+0x55/0xb0
[60081.334316]  [<ffffffff810762be>] __raw_notifier_call_chain+0xe/0x10
[60081.334537]  [<ffffffff810515a3>] cpu_notify+0x23/0x40
[60081.334694]  [<ffffffff810518a0>] _cpu_up+0x160/0x170
[60081.334849]  [<ffffffff8163cda3>] enable_nonboot_cpus+0xf3/0x4b0
[60081.335031]  [<ffffffff810a9165>] hibernation_snapshot+0x2e5/0x790
[60081.335218]  [<ffffffff810a9d5a>] hibernate+0x14a/0x1d0
[60081.335378]  [<ffffffff810a59c4>] state_store+0xe4/0xf0
[60081.335537]  [<ffffffff812f0f2f>] kobj_attr_store+0xf/0x20
[60081.335704]  [<ffffffff811fbce0>] sysfs_kf_write+0x50/0x70
[60081.335900]  [<ffffffff811fafe5>] kernfs_fop_write+0x105/0x190
[60081.336077]  [<ffffffff8118335d>] vfs_write+0xbd/0x1d0
[60081.336234]  [<ffffffff81183dc2>] SyS_write+0x52/0xc0
[60081.336389]  [<ffffffff816490d6>] system_call_fastpath+0x16/0x1b
[60081.336850] CPU1 is up
[60081.336970] smpboot: Booting Node 0 Processor 2 APIC 0x12
[60081.350648] CPU2 is up
[60081.350761] smpboot: Booting Node 0 Processor 3 APIC 0x13
[60081.364940] CPU3 is up
[60081.365047] smpboot: Booting Node 0 Processor 4 APIC 0x14
[60081.378750] CPU4 is up
[60081.378862] smpboot: Booting Node 0 Processor 5 APIC 0x15
[60081.393019] CPU5 is up
[60081.393125] smpboot: Booting Node 0 Processor 6 APIC 0x16
[60081.406864] CPU6 is up
[60081.406974] smpboot: Booting Node 0 Processor 7 APIC 0x17
[60081.421176] CPU7 is up
[60081.444773] PM: noirq restore of devices complete after 14.013 msecs
[60081.446047] PM: early restore of devices complete after 1.020 msecs
[60081.653282] rtc_cmos 00:03: System wakeup disabled by ACPI
[60081.653687] snd_hda_intel 0000:01:00.1: irq 49 for MSI/MSI-X
[60081.654224] serial 00:06: activated
[60081.655162] [drm] enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0
...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
