Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934042Ab3GPVTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 17:19:34 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:45470 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933472Ab3GPVTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 17:19:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Peter Wu <lekensteyn@gmail.com>
Subject: Re: [LOCKDEP] cpufreq: possible circular locking dependency detected
Date: Tue, 16 Jul 2013 23:29:23 +0200
Message-ID: <1393546.xyp1i3uNyq@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51E56482.7020608@linux.vnet.ibm.com>
References: <20130710231305.GA4046@swordfish> <20130716104400.GA2359@swordfish.minsk.epam.com> <51E56482.7020608@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 16, 2013 08:49:30 PM Srivatsa S. Bhat wrote:
> On 07/16/2013 04:14 PM, Sergey Senozhatsky wrote:
> > On (07/16/13 14:03), Srivatsa S. Bhat wrote:
> >>>> So here is the solution:
> >>>>
> >>>> On 3.11-rc1, apply these patches in the order mentioned below, and check
> >>>> whether it fixes _all_ problems (both the warnings about IPI as well as the
> >>>> lockdep splat).
> >>>>
> >>>> 1. Patch given in:  https://lkml.org/lkml/2013/7/11/661
> >>>>    (Just apply patch 1, not the entire patchset).
> >>>>
> >>>> 2. Apply the patch shown below, on top of the above patch:
> >>>>
> >>>> ---------------------------------------------------------------------------
> >>>>
> >>>
> >>> Hello Srivatsa,
> >>> Thanks, I'll test a bit later -- in the morning. (laptop stopped resuming from
> >>> suspend, probably radeon dmp).
> >>>
> >>>
> >>
> >> Sure, thanks!
> >>
> >>>
> >>> Shouldn't we also kick the console lock?
> >>>
> >>>
> >>>  kernel/printk.c | 3 +++
> >>>  1 file changed, 3 insertions(+)
> >>>
> >>> diff --git a/kernel/printk.c b/kernel/printk.c
> >>> index d37d45c..3e20233 100644
> >>> --- a/kernel/printk.c
> >>> +++ b/kernel/printk.c
> >>> @@ -1926,8 +1926,11 @@ static int __cpuinit console_cpu_notify(struct notifier_block *self,
> >>>  {
> >>>  	switch (action) {
> >>>  	case CPU_ONLINE:
> >>> +	case CPU_ONLINE_FROZEN:
> >>>  	case CPU_DEAD:
> >>> +	case CPU_DEAD_FROZEN:
> >>>  	case CPU_DOWN_FAILED:
> >>> +	case CPU_DOWN_FAILED_FROZEN:
> >>>  	case CPU_UP_CANCELED:
> >>>  		console_lock();
> >>>  		console_unlock();
> >>>
> >>>
> >>
> >> No need. suspend_console() and resume_console() already handle it
> >> properly in the suspend/resume case, from what I can see.
> >>
> > 
> > I've managed to wake up my laptop from suspend, and something's not right.
> > 
> > 
> > 	# for i in {1..5}; do \
> > 	echo 0 > /sys/devices/system/cpu/cpu3/online; \
> > 	echo 0 > /sys/devices/system/cpu/cpu2/online; \
> > 	echo 1 > /sys/devices/system/cpu/cpu3/online; \
> > 	echo 0 > /sys/devices/system/cpu/cpu1/online; \
> > 	echo 1 > /sys/devices/system/cpu/cpu1/online; \
> > 	echo 1 > /sys/devices/system/cpu/cpu2/online; \
> > 	done
> > 	# systemctl suspend
> > 	->	resume
> > 
> > 
> > [  227.329656] ACPI: Preparing to enter system sleep state S3
> > [  227.353334] PM: Saving platform NVS memory
> > 
> > [  227.355403] ======================================================
> > [  227.355404] [ INFO: possible circular locking dependency detected ]
> > [  227.355407] 3.11.0-rc1-dbg-01398-gf537e41-dirty #1838 Not tainted
> > [  227.355408] -------------------------------------------------------
> > [  227.355411] systemd-sleep/2280 is trying to acquire lock:
> > [  227.355426]  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8104dab4>]
> > disable_nonboot_cpus+0x24/0x120
> > [  227.355427] 
> > but task is already holding lock:
> > [  227.355434]  (console_lock){+.+.+.}, at: [<ffffffff8104c956>]
> > suspend_console+0x26/0x40
> > [  227.355435] 
> > which lock already depends on the new lock.
> > 
> > [  227.355436] 
> > the existing dependency chain (in reverse order) is:
> > [  227.355441] 
> > -> #2 (console_lock){+.+.+.}:
> > [  227.355448]        [<ffffffff810b8fb4>] lock_acquire+0xa4/0x200
> > [  227.355452]        [<ffffffff8104b197>] console_lock+0x77/0x80
> > [  227.355456]        [<ffffffff8104cf91>] console_cpu_notify+0x31/0x40
> > [  227.355462]        [<ffffffff8107cd6d>] notifier_call_chain+0x5d/0x110
> > [  227.355466]        [<ffffffff8107ce2e>] __raw_notifier_call_chain+0xe/0x10
> > [  227.355469]        [<ffffffff8104d5a3>] cpu_notify+0x23/0x50
> > [  227.355473]        [<ffffffff8104d5de>] cpu_notify_nofail+0xe/0x20
> > [  227.355482]        [<ffffffff815fafad>] _cpu_down+0x1ad/0x330
> > [  227.355486]        [<ffffffff815fb166>] cpu_down+0x36/0x50
> > [  227.355493]        [<ffffffff814ad8cd>] cpu_subsys_offline+0x1d/0x30
> > [  227.355498]        [<ffffffff814a8de5>] device_offline+0x95/0xc0
> > [  227.355502]        [<ffffffff814a8ee2>] store_online+0x42/0x90
> > [  227.355506]        [<ffffffff814a64f8>] dev_attr_store+0x18/0x30
> > [  227.355513]        [<ffffffff811ec71b>] sysfs_write_file+0xdb/0x150
> > [  227.355517]        [<ffffffff8117a68d>] vfs_write+0xbd/0x1e0
> > [  227.355522]        [<ffffffff8117ad7c>] SyS_write+0x4c/0xa0
> > [  227.355527]        [<ffffffff8160cbfe>] tracesys+0xd0/0xd5
> > [  227.355531] 
> > -> #1 (cpu_hotplug.lock){+.+.+.}:
> > [  227.355535]        [<ffffffff810b8fb4>] lock_acquire+0xa4/0x200
> > [  227.355541]        [<ffffffff81605b47>] mutex_lock_nested+0x67/0x410
> > [  227.355545]        [<ffffffff8104d54b>] cpu_hotplug_begin+0x2b/0x60
> > [  227.355549]        [<ffffffff8104d61a>] _cpu_up+0x2a/0x170
> > [  227.355552]        [<ffffffff8104d7b9>] cpu_up+0x59/0x80
> > [  227.355558]        [<ffffffff81cf51b6>] smp_init+0x64/0x95
> > [  227.355566]        [<ffffffff81cdaf21>] kernel_init_freeable+0x84/0x191
> > [  227.355570]        [<ffffffff815fa34e>] kernel_init+0xe/0x180
> > [  227.355574]        [<ffffffff8160c9ac>] ret_from_fork+0x7c/0xb0
> > [  227.355578] 
> > -> #0 (cpu_add_remove_lock){+.+.+.}:
> > [  227.355582]        [<ffffffff810b8106>] __lock_acquire+0x1766/0x1d30
> > [  227.355586]        [<ffffffff810b8fb4>] lock_acquire+0xa4/0x200
> > [  227.355590]        [<ffffffff81605b47>] mutex_lock_nested+0x67/0x410
> > [  227.355594]        [<ffffffff8104dab4>] disable_nonboot_cpus+0x24/0x120
> > [  227.355601]        [<ffffffff810a0973>] suspend_devices_and_enter+0x1f3/0x680
> > [  227.355605]        [<ffffffff810a0fd2>] pm_suspend+0x1d2/0x240
> > [  227.355609]        [<ffffffff8109fa19>] state_store+0x79/0xf0
> > [  227.355614]        [<ffffffff81312dbf>] kobj_attr_store+0xf/0x20
> > [  227.355618]        [<ffffffff811ec71b>] sysfs_write_file+0xdb/0x150
> > [  227.355621]        [<ffffffff8117a68d>] vfs_write+0xbd/0x1e0
> > [  227.355624]        [<ffffffff8117ad7c>] SyS_write+0x4c/0xa0
> > [  227.355628]        [<ffffffff8160cbfe>] tracesys+0xd0/0xd5
> > [  227.355629] 
> > other info that might help us debug this:
> > 
> > [  227.355635] Chain exists of:
> >   cpu_add_remove_lock --> cpu_hotplug.lock --> console_lock
> > 
> >   [  227.355637]  Possible unsafe locking scenario:
> > 
> >   [  227.355638]        CPU0                    CPU1
> >   [  227.355639]        ----                    ----
> >   [  227.355642]   lock(console_lock);
> >   [  227.355644]                                lock(cpu_hotplug.lock);
> >   [  227.355647]                                lock(console_lock);
> >   [  227.355650]   lock(cpu_add_remove_lock);
> >   [  227.355651] 
> >    *** DEADLOCK ***
> > 
> >    [  227.355653] 5 locks held by systemd-sleep/2280:
> >    [  227.355661]  #0:  (sb_writers#6){.+.+.+}, at: [<ffffffff8117a78b>]   vfs_write+0x1bb/0x1e0
> >    [  227.355668]  #1:  (&buffer->mutex){+.+.+.}, at:   [<ffffffff811ec67c>] sysfs_write_file+0x3c/0x150
> >    [  227.355676]  #2:  (s_active#110){.+.+.+}, at: [<ffffffff811ec703>]   sysfs_write_file+0xc3/0x150
> >    [  227.355683]  #3:  (pm_mutex){+.+.+.}, at: [<ffffffff810a0e32>]   pm_suspend+0x32/0x240
> >    [  227.355690]  #4:  (console_lock){+.+.+.}, at: [<ffffffff8104c956>]   suspend_console+0x26/0x40
> >    [  227.355691] 
> >    stack backtrace:
> >    [  227.355695] CPU: 0 PID: 2280 Comm: systemd-sleep Not tainted   3.11.0-rc1-dbg-01398-gf537e41-dirty #1838
> >    [  227.355697] Hardware name: Acer             Aspire 5741G   /Aspire 5741G    , BIOS V1.20 02/08/2011
> >    [  227.355703]  ffffffff82208680 ffff88015151bbc8 ffffffff81603038   ffffffff822073f0
> >    [  227.355707]  ffff88015151bc08 ffffffff815ffdaa ffff880153389fa0   ffff88015338a788
> >    [  227.355712]  1d81e4832c04c441 ffff88015338a760 ffff88015338a788   ffff880153389fa0
> >    [  227.355713] Call Trace:
> >    [  227.355719]  [<ffffffff81603038>] dump_stack+0x4e/0x82
> >    [  227.355723]  [<ffffffff815ffdaa>] print_circular_bug+0x2b6/0x2c5
> >    [  227.355727]  [<ffffffff810b8106>] __lock_acquire+0x1766/0x1d30
> >    [  227.355733]  [<ffffffff81054aec>] ?   walk_system_ram_range+0x5c/0x140
> >    [  227.355737]  [<ffffffff810b63f4>] ? mark_held_locks+0x94/0x140
> >    [  227.355741]  [<ffffffff810b8fb4>] lock_acquire+0xa4/0x200
> >    [  227.355745]  [<ffffffff8104dab4>] ?   disable_nonboot_cpus+0x24/0x120
> >    [  227.355749]  [<ffffffff8104dab4>] ?   disable_nonboot_cpus+0x24/0x120
> >    [  227.355753]  [<ffffffff81605b47>] mutex_lock_nested+0x67/0x410
> >    [  227.355757]  [<ffffffff8104dab4>] ?   disable_nonboot_cpus+0x24/0x120
> >    [  227.355761]  [<ffffffff81607e9e>] ? mutex_unlock+0xe/0x10
> >    [  227.355768]  [<ffffffff8135bd2f>] ? acpi_os_get_iomem+0x4c/0x54
> >    [  227.355772]  [<ffffffff8104dab4>] disable_nonboot_cpus+0x24/0x120
> >    [  227.355777]  [<ffffffff810a0973>]   suspend_devices_and_enter+0x1f3/0x680
> >    [  227.355780]  [<ffffffff815fefc6>] ? printk+0x67/0x69
> >    [  227.355785]  [<ffffffff810a0fd2>] pm_suspend+0x1d2/0x240
> >    [  227.355789]  [<ffffffff8109fa19>] state_store+0x79/0xf0
> >    [  227.355792]  [<ffffffff81312dbf>] kobj_attr_store+0xf/0x20
> >    [  227.355796]  [<ffffffff811ec71b>] sysfs_write_file+0xdb/0x150
> >    [  227.355799]  [<ffffffff8117a68d>] vfs_write+0xbd/0x1e0
> >    [  227.355804]  [<ffffffff81198490>] ? fget_light+0x320/0x4b0
> >    [  227.355808]  [<ffffffff8117ad7c>] SyS_write+0x4c/0xa0
> >    [  227.355811]  [<ffffffff8160cbfe>] tracesys+0xd0/0xd5
> >    [  227.355814] Disabling non-boot CPUs ...
> >    [  227.357731] smpboot: CPU 1 is now offline
> >    [  227.461072] smpboot: CPU 2 is now offline
> >    [  227.565119] smpboot: CPU 3 is now offline
> > 
> >
> 
> This also looks like a different issue altogether, and IMHO deserves
> attention in a separate, dedicated email thread. Can you post it in a
> new thread please?
> 
> Also, since you didn't get the original lockdep warning you reported,
> and since you didn't hit the IPI-to-offline-cpus warnings as well, I
> think we can safely conclude that my patches fixed your original problem.
> 
> Rafael, could you kindly pick up this second patch[2] as well (with CC
> to stable)? (I'm aware that you already picked up the first one[1]).

Sure, I will.

Thanks a lot for working on this!

Rafael


> [1]. https://lkml.org/lkml/2013/7/11/661
> [2]. http://marc.info/?l=linux-kernel&m=137389460805002&w=2
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
