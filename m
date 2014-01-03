Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaACA1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:27:05 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54133 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751136AbaACA1B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:27:01 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>, cpufreq@vger.kernel.org
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cpufreq: try to resume policies which failed on last resume
Date: Fri, 03 Jan 2014 01:40:42 +0100
Message-ID: <2302938.b8tymqrMEz@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.13.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <87zjne7f75.fsf@nemi.mork.no>
References: <f9d7b0d5424e4443597d2ed39bec3fedd2b10d1e.1387848958.git.viresh.kumar@linaro.org> <5562479.pVWRuDL0y6@vostro.rjw.lan> <87zjne7f75.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 02, 2014 01:15:10 PM Bjørn Mork wrote:
> "Rafael J. Wysocki" <rjw@rjwysocki.net> writes:
> 
> > On Tuesday, December 24, 2013 07:11:00 AM Viresh Kumar wrote:
> >> __cpufreq_add_dev() can fail sometimes while we are resuming our system.
> >> Currently we are clearing all sysfs nodes for cpufreq's failed policy as that
> >> could make userspace unstable. But if we suspend/resume again, we should atleast
> >> try to bring back those policies.
> >> 
> >> This patch fixes this issue by clearing fallback data on failure and trying to
> >> allocate a new struct cpufreq_policy on second resume.
> >> 
> >> Reported-and-tested-by: Bjørn Mork <bjorn@mork.no>
> >> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> >
> > Well, while I appreciate the work done here, I don't like the changelog,
> > I don't really like the way the code is written and I don't like the comments.
> > Sorry about that.
> >
> > Bjorn, can you please test the patch below instead along with the [2/2]
> > from this series (on top of linux-pm.git/pm-cpufreq)?
> 
> I tested this series with your modified 1/2 today, but on top of a
> current mainline (commit 9a0bb2966ef) instead of linux-pm.git/pm-cpufreq.
> Shouldn't make much difference since Linus already has pulled your
> 'pm+acpi-3.13-rc6' tag, which included that pm-cpufreq branch.
> 
> This series fixes the reported bug for me.
> 
> 
> But I observed this, most likely unrelated, splat during the test:
> 
> ACPI Exception: AE_BAD_PARAMETER, Returned by Handler for [EmbeddedControl] (20131115/evregion-282)
> ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPC_.EC__.LPMD] (Node ffff880232499c18), AE_BAD_PARAMETER (20131115/psparse-536)
> ACPI Error: Method parse/execution failed [\_PR_.CPU0._PPC] (Node ffff8802326f93d0), AE_BAD_PARAMETER (20131115/psparse-536)
> ACPI Error: Method parse/execution failed [\_PR_.CPU1._PPC] (Node ffff8802326f9268), AE_BAD_PARAMETER (20131115/psparse-536)
> ACPI Exception: AE_BAD_PARAMETER, Evaluating _PPC (20131115/processor_perflib-140)
> 
> ======================================================
> [ INFO: possible circular locking dependency detected ]
> 3.13.0-rc6+ #181 Not tainted
> -------------------------------------------------------
> s2disk/5651 is trying to acquire lock:
>  (s_active#170){++++.+}, at: [<ffffffff8118b9d7>] sysfs_addrm_finish+0x28/0x46
> 
> but task is already holding lock:
>  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff81039ff5>] cpu_hotplug_begin+0x28/0x50
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (cpu_hotplug.lock){+.+.+.}:
>        [<ffffffff81075027>] lock_acquire+0xfb/0x144
>        [<ffffffff8139d4d2>] mutex_lock_nested+0x6c/0x397
>        [<ffffffff81039f4a>] get_online_cpus+0x3c/0x50
>        [<ffffffff812a6974>] store+0x20/0xad
>        [<ffffffff8118a9a1>] sysfs_write_file+0x138/0x18b
>        [<ffffffff8112a428>] vfs_write+0x9c/0x102
>        [<ffffffff8112a716>] SyS_write+0x50/0x85
>        [<ffffffff813a57a2>] system_call_fastpath+0x16/0x1b
> 
> -> #0 (s_active#170){++++.+}:
>        [<ffffffff81074760>] __lock_acquire+0xae3/0xe68
>        [<ffffffff81075027>] lock_acquire+0xfb/0x144
>        [<ffffffff8118b027>] sysfs_deactivate+0xa5/0x108
>        [<ffffffff8118b9d7>] sysfs_addrm_finish+0x28/0x46
>        [<ffffffff8118bd3f>] sysfs_remove+0x2a/0x31
>        [<ffffffff8118be2f>] sysfs_remove_dir+0x66/0x6b
>        [<ffffffff811d5d11>] kobject_del+0x18/0x42
>        [<ffffffff811d5e1c>] kobject_cleanup+0xe1/0x14f
>        [<ffffffff811d5ede>] kobject_put+0x45/0x49
>        [<ffffffff812a6e85>] cpufreq_policy_put_kobj+0x37/0x83
>        [<ffffffff812a8bab>] __cpufreq_add_dev.isra.18+0x75e/0x78c
>        [<ffffffff812a8c39>] cpufreq_cpu_callback+0x53/0x88
>        [<ffffffff813a314c>] notifier_call_chain+0x67/0x92
>        [<ffffffff8105bce4>] __raw_notifier_call_chain+0x9/0xb
>        [<ffffffff81039e7c>] __cpu_notify+0x1b/0x32
>        [<ffffffff81039ea1>] cpu_notify+0xe/0x10
>        [<ffffffff8103a12b>] _cpu_up+0xf1/0x124
>        [<ffffffff8138ee7d>] enable_nonboot_cpus+0x52/0xbf
>        [<ffffffff8107a2a3>] hibernation_snapshot+0x1be/0x2ed
>        [<ffffffff8107eb84>] snapshot_ioctl+0x1e5/0x431
>        [<ffffffff81139080>] do_vfs_ioctl+0x45e/0x4a8
>        [<ffffffff8113911c>] SyS_ioctl+0x52/0x82
>        [<ffffffff813a57a2>] system_call_fastpath+0x16/0x1b
> 
> other info that might help us debug this:
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(cpu_hotplug.lock);
>                                lock(s_active#170);
>                                lock(cpu_hotplug.lock);
>   lock(s_active#170);
> 
>  *** DEADLOCK ***
> 
> 7 locks held by s2disk/5651:
>  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107e9ea>] snapshot_ioctl+0x4b/0x431
>  #1:  (device_hotplug_lock){+.+.+.}, at: [<ffffffff81283730>] lock_device_hotplug+0x12/0x14
>  #2:  (acpi_scan_lock){+.+.+.}, at: [<ffffffff8122c657>] acpi_scan_lock_acquire+0x12/0x14
>  #3:  (console_lock){+.+.+.}, at: [<ffffffff810817f2>] suspend_console+0x20/0x38
>  #4:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff81039fb9>] cpu_maps_update_begin+0x12/0x14
>  #5:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff81039ff5>] cpu_hotplug_begin+0x28/0x50
>  #6:  (cpufreq_rwsem){.+.+.+}, at: [<ffffffff812a84cc>] __cpufreq_add_dev.isra.18+0x7f/0x78c
> 
> stack backtrace:
> CPU: 0 PID: 5651 Comm: s2disk Not tainted 3.13.0-rc6+ #181
> Hardware name: LENOVO 2776LEG/2776LEG, BIOS 6EET55WW (3.15 ) 12/19/2011
>  ffffffff81d3edf0 ffff8802174898f8 ffffffff81399cac 0000000000004549
>  ffffffff81d3edf0 ffff880217489948 ffffffff81397dc5 ffff880217489928
>  ffff88023198ea50 0000000000000006 ffff88023198f1d8 0000000000000006
> Call Trace:
>  [<ffffffff81399cac>] dump_stack+0x4e/0x68
>  [<ffffffff81397dc5>] print_circular_bug+0x1f8/0x209
>  [<ffffffff81074760>] __lock_acquire+0xae3/0xe68
>  [<ffffffff8107565d>] ? debug_check_no_locks_freed+0x12c/0x143
>  [<ffffffff81075027>] lock_acquire+0xfb/0x144
>  [<ffffffff8118b9d7>] ? sysfs_addrm_finish+0x28/0x46
>  [<ffffffff81072201>] ? lockdep_init_map+0x14e/0x160
>  [<ffffffff8118b027>] sysfs_deactivate+0xa5/0x108
>  [<ffffffff8118b9d7>] ? sysfs_addrm_finish+0x28/0x46
>  [<ffffffff8118b9d7>] sysfs_addrm_finish+0x28/0x46
>  [<ffffffff8118bd3f>] sysfs_remove+0x2a/0x31
>  [<ffffffff8118be2f>] sysfs_remove_dir+0x66/0x6b
>  [<ffffffff811d5d11>] kobject_del+0x18/0x42
>  [<ffffffff811d5e1c>] kobject_cleanup+0xe1/0x14f
>  [<ffffffff811d5ede>] kobject_put+0x45/0x49
>  [<ffffffff812a6e85>] cpufreq_policy_put_kobj+0x37/0x83
>  [<ffffffff812a8bab>] __cpufreq_add_dev.isra.18+0x75e/0x78c
>  [<ffffffff81071b04>] ? __lock_is_held+0x32/0x54
>  [<ffffffff812a8c39>] cpufreq_cpu_callback+0x53/0x88
>  [<ffffffff813a314c>] notifier_call_chain+0x67/0x92
>  [<ffffffff8105bce4>] __raw_notifier_call_chain+0x9/0xb
>  [<ffffffff81039e7c>] __cpu_notify+0x1b/0x32
>  [<ffffffff81039ea1>] cpu_notify+0xe/0x10
>  [<ffffffff8103a12b>] _cpu_up+0xf1/0x124
>  [<ffffffff8138ee7d>] enable_nonboot_cpus+0x52/0xbf
>  [<ffffffff8107a2a3>] hibernation_snapshot+0x1be/0x2ed
>  [<ffffffff8107eb84>] snapshot_ioctl+0x1e5/0x431
>  [<ffffffff81139080>] do_vfs_ioctl+0x45e/0x4a8
>  [<ffffffff811414c8>] ? fcheck_files+0xa1/0xe4
>  [<ffffffff81141a67>] ? fget_light+0x33/0x9a
>  [<ffffffff8113911c>] SyS_ioctl+0x52/0x82
>  [<ffffffff811df4ce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff813a57a2>] system_call_fastpath+0x16/0x1b
> CPU1 is up
> ACPI: Waking up from system sleep state S4
> PM: noirq thaw of devices complete after 2.727 msecs
> PM: early thaw of devices complete after 1.137 msecs
> 
> 
> 
> This warning appeared when I tried cancelling hibernation, which is
> known to fail when using the acpi-cpufreq driver.  The point of the test
> was to verify that such failures still produce the expected result:
> 
>  - all stale sysfs files are cleaned up and removed
>  - later suspend/resume actions will restore (or actually reinitiate)
>    the cpufreq driver for the non-boot CPUs
> 
> Which was successful, except that it produced the above lockdep warning.
> 
> I have not verified that this is a new warning (which means that it most
> likely is not).  And I expect the whole acpi-cpufreq problem, including
> that warning, to go away when you eventually push
> http://www.spinics.net/lists/cpufreq/msg08714.html with your improved
> changelog (thanks for doing that BTW).  So I don't worry too much about
> it.  Just wanted to let you know.

OK, thanks!  Well, this is somewhat worrisome.

Could you also check the linux-pm.git/fixes branch that contains all patches
I'm planning to push for 3.13-rc7 shortly?

Rafael

