Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaACJZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 04:25:36 -0500
Received: from canardo.mork.no ([148.122.252.1]:60579 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbaACJZb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 04:25:31 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: cpufreq@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cpufreq: try to resume policies which failed on last resume
Organization: m
References: <f9d7b0d5424e4443597d2ed39bec3fedd2b10d1e.1387848958.git.viresh.kumar@linaro.org>
	<5562479.pVWRuDL0y6@vostro.rjw.lan> <87zjne7f75.fsf@nemi.mork.no>
	<2302938.b8tymqrMEz@vostro.rjw.lan>
Date: Fri, 03 Jan 2014 10:24:45 +0100
In-Reply-To: <2302938.b8tymqrMEz@vostro.rjw.lan> (Rafael J. Wysocki's message
	of "Fri, 03 Jan 2014 01:40:42 +0100")
Message-ID: <878uuxquxu.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@rjwysocki.net> writes:

> OK, thanks!  Well, this is somewhat worrisome.
>
> Could you also check the linux-pm.git/fixes branch that contains all patches
> I'm planning to push for 3.13-rc7 shortly?

It's definitely still there.  But I'm less sure about the exact trigger.

I have now booted and suspend that branch a few times trying to figure
out which actions it depends on. It seems to depend on a modified
scaling_max_freq (or any other attribute, I guess - haven't testing
anything else) in combination with suspend.  But the order doesn't
necessarily matter.  I can sometimes set off the warning by writing to
sysfs after resuming, and sometimes at suspend time if the value is
already modified.  The results are not consistent though.  Sometimes
there is no warning at all.

But what's 100% sure is that I still can trigger this with the
linux-pm.git/fixes branch.


For example, triggered by

  echo 800000 >/sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq

after resume (I believe the taint is due to a _request_firmware failure
for one of the bluetooth devices):

 
 ======================================================
 [ INFO: possible circular locking dependency detected ]
 3.13.0-rc6+ #183 Tainted: G        W   
 -------------------------------------------------------
 bash/4897 is trying to acquire lock:
  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff81039f4a>] get_online_cpus+0x3c/0x50
 
 but task is already holding lock:
  (s_active#273){++++.+}, at: [<ffffffff8118a93f>] sysfs_write_file+0xd6/0x18b
 
 which lock already depends on the new lock.
 
 
 the existing dependency chain (in reverse order) is:
 
 -> #1 (s_active#273){++++.+}:
        [<ffffffff81075027>] lock_acquire+0xfb/0x144
        [<ffffffff8118b027>] sysfs_deactivate+0xa5/0x108
        [<ffffffff8118b9d7>] sysfs_addrm_finish+0x28/0x46
        [<ffffffff8118bd3f>] sysfs_remove+0x2a/0x31
        [<ffffffff8118be2f>] sysfs_remove_dir+0x66/0x6b
        [<ffffffff811d5d11>] kobject_del+0x18/0x42
        [<ffffffff811d5e1c>] kobject_cleanup+0xe1/0x14f
        [<ffffffff811d5ede>] kobject_put+0x45/0x49
        [<ffffffff812a6ed5>] cpufreq_policy_put_kobj+0x37/0x83
        [<ffffffff812a8bfb>] __cpufreq_add_dev.isra.18+0x75e/0x78c
        [<ffffffff812a8c89>] cpufreq_cpu_callback+0x53/0x88
        [<ffffffff813a314c>] notifier_call_chain+0x67/0x92
        [<ffffffff8105bce4>] __raw_notifier_call_chain+0x9/0xb
        [<ffffffff81039e7c>] __cpu_notify+0x1b/0x32
        [<ffffffff81039ea1>] cpu_notify+0xe/0x10
        [<ffffffff8103a12b>] _cpu_up+0xf1/0x124
        [<ffffffff8138ee7d>] enable_nonboot_cpus+0x52/0xbf
        [<ffffffff8107a2a3>] hibernation_snapshot+0x1be/0x2ed
        [<ffffffff8107eb84>] snapshot_ioctl+0x1e5/0x431
        [<ffffffff81139080>] do_vfs_ioctl+0x45e/0x4a8
        [<ffffffff8113911c>] SyS_ioctl+0x52/0x82
        [<ffffffff813a57a2>] system_call_fastpath+0x16/0x1b
 
 -> #0 (cpu_hotplug.lock){+.+.+.}:
        [<ffffffff81074760>] __lock_acquire+0xae3/0xe68
        [<ffffffff81075027>] lock_acquire+0xfb/0x144
        [<ffffffff8139d4d2>] mutex_lock_nested+0x6c/0x397
        [<ffffffff81039f4a>] get_online_cpus+0x3c/0x50
        [<ffffffff812a69c4>] store+0x20/0xad
        [<ffffffff8118a9a1>] sysfs_write_file+0x138/0x18b
        [<ffffffff8112a428>] vfs_write+0x9c/0x102
        [<ffffffff8112a716>] SyS_write+0x50/0x85
        [<ffffffff813a57a2>] system_call_fastpath+0x16/0x1b
 
 other info that might help us debug this:
 
  Possible unsafe locking scenario:
 
        CPU0                    CPU1
        ----                    ----
   lock(s_active#273);
                                lock(cpu_hotplug.lock);
                                lock(s_active#273);
   lock(cpu_hotplug.lock);
 
  *** DEADLOCK ***
 
 3 locks held by bash/4897:
  #0:  (sb_writers#5){.+.+.+}, at: [<ffffffff811297c7>] file_start_write+0x27/0x29
  #1:  (&of->mutex){+.+.+.}, at: [<ffffffff8118a937>] sysfs_write_file+0xce/0x18b
  #2:  (s_active#273){++++.+}, at: [<ffffffff8118a93f>] sysfs_write_file+0xd6/0x18b
 
 stack backtrace:
 CPU: 1 PID: 4897 Comm: bash Tainted: G        W    3.13.0-rc6+ #183
 Hardware name: LENOVO 2776LEG/2776LEG, BIOS 6EET55WW (3.15 ) 12/19/2011
  ffffffff81ca83b0 ffff88021fa65c08 ffffffff81399cac 0000000000000006
  ffffffff81ca83b0 ffff88021fa65c58 ffffffff81397dc5 0000000000000002
  ffff8800b1af2810 0000000000000003 ffff8800b1af2ef0 0000000000000003
 Call Trace:
  [<ffffffff81399cac>] dump_stack+0x4e/0x68
  [<ffffffff81397dc5>] print_circular_bug+0x1f8/0x209
  [<ffffffff81074760>] __lock_acquire+0xae3/0xe68
  [<ffffffff81075027>] lock_acquire+0xfb/0x144
  [<ffffffff81039f4a>] ? get_online_cpus+0x3c/0x50
  [<ffffffff8139d4d2>] mutex_lock_nested+0x6c/0x397
  [<ffffffff81039f4a>] ? get_online_cpus+0x3c/0x50
  [<ffffffff81071b04>] ? __lock_is_held+0x32/0x54
  [<ffffffff81039f4a>] ? get_online_cpus+0x3c/0x50
  [<ffffffff81039f4a>] get_online_cpus+0x3c/0x50
  [<ffffffff812a69c4>] store+0x20/0xad
  [<ffffffff8118a9a1>] sysfs_write_file+0x138/0x18b
  [<ffffffff8112a428>] vfs_write+0x9c/0x102
  [<ffffffff8112a716>] SyS_write+0x50/0x85
  [<ffffffff813a57a2>] system_call_fastpath+0x16/0x1b


Or by s2disk (not the same boot - this time without the taint):

 ======================================================
 [ INFO: possible circular locking dependency detected ]
 3.13.0-rc6+ #183 Not tainted
 -------------------------------------------------------
 s2disk/5123 is trying to acquire lock:
  (s_active#171){++++.+}, at: [<ffffffff8118b9d7>] sysfs_addrm_finish+0x28/0x46
 
 but task is already holding lock:
  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff81039ff5>] cpu_hotplug_begin+0x28/0x50
 
 which lock already depends on the new lock.
 
 
 the existing dependency chain (in reverse order) is:
 
 -> #1 (cpu_hotplug.lock){+.+.+.}:
        [<ffffffff81075027>] lock_acquire+0xfb/0x144
        [<ffffffff8139d4d2>] mutex_lock_nested+0x6c/0x397
        [<ffffffff81039f4a>] get_online_cpus+0x3c/0x50
        [<ffffffff812a69c4>] store+0x20/0xad
        [<ffffffff8118a9a1>] sysfs_write_file+0x138/0x18b
        [<ffffffff8112a428>] vfs_write+0x9c/0x102
        [<ffffffff8112a716>] SyS_write+0x50/0x85
        [<ffffffff813a57a2>] system_call_fastpath+0x16/0x1b
 
 -> #0 (s_active#171){++++.+}:
        [<ffffffff81074760>] __lock_acquire+0xae3/0xe68
        [<ffffffff81075027>] lock_acquire+0xfb/0x144
        [<ffffffff8118b027>] sysfs_deactivate+0xa5/0x108
        [<ffffffff8118b9d7>] sysfs_addrm_finish+0x28/0x46
        [<ffffffff8118bd3f>] sysfs_remove+0x2a/0x31
        [<ffffffff8118be2f>] sysfs_remove_dir+0x66/0x6b
        [<ffffffff811d5d11>] kobject_del+0x18/0x42
        [<ffffffff811d5e1c>] kobject_cleanup+0xe1/0x14f
        [<ffffffff811d5ede>] kobject_put+0x45/0x49
        [<ffffffff812a6ed5>] cpufreq_policy_put_kobj+0x37/0x83
        [<ffffffff812a8bfb>] __cpufreq_add_dev.isra.18+0x75e/0x78c
        [<ffffffff812a8c89>] cpufreq_cpu_callback+0x53/0x88
        [<ffffffff813a314c>] notifier_call_chain+0x67/0x92
        [<ffffffff8105bce4>] __raw_notifier_call_chain+0x9/0xb
        [<ffffffff81039e7c>] __cpu_notify+0x1b/0x32
        [<ffffffff81039ea1>] cpu_notify+0xe/0x10
        [<ffffffff8103a12b>] _cpu_up+0xf1/0x124
        [<ffffffff8138ee7d>] enable_nonboot_cpus+0x52/0xbf
        [<ffffffff8107a2a3>] hibernation_snapshot+0x1be/0x2ed
        [<ffffffff8107eb84>] snapshot_ioctl+0x1e5/0x431
        [<ffffffff81139080>] do_vfs_ioctl+0x45e/0x4a8
        [<ffffffff8113911c>] SyS_ioctl+0x52/0x82
        [<ffffffff813a57a2>] system_call_fastpath+0x16/0x1b
 
 other info that might help us debug this:
 
  Possible unsafe locking scenario:
 
        CPU0                    CPU1
        ----                    ----
   lock(cpu_hotplug.lock);
                                lock(s_active#171);
                                lock(cpu_hotplug.lock);
   lock(s_active#171);
 
  *** DEADLOCK ***
 
 7 locks held by s2disk/5123:
  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107e9ea>] snapshot_ioctl+0x4b/0x431
  #1:  (device_hotplug_lock){+.+.+.}, at: [<ffffffff812837ac>] lock_device_hotplug+0x12/0x14
  #2:  (acpi_scan_lock){+.+.+.}, at: [<ffffffff8122c6d3>] acpi_scan_lock_acquire+0x12/0x14
  #3:  (console_lock){+.+.+.}, at: [<ffffffff810817f2>] suspend_console+0x20/0x38
  #4:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff81039fb9>] cpu_maps_update_begin+0x12/0x14
  #5:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff81039ff5>] cpu_hotplug_begin+0x28/0x50
  #6:  (cpufreq_rwsem){.+.+.+}, at: [<ffffffff812a851c>] __cpufreq_add_dev.isra.18+0x7f/0x78c
 
 stack backtrace:
 CPU: 0 PID: 5123 Comm: s2disk Not tainted 3.13.0-rc6+ #183
 Hardware name: LENOVO 2776LEG/2776LEG, BIOS 6EET55WW (3.15 ) 12/19/2011
  ffffffff81d3de70 ffff8800b10718f8 ffffffff81399cac 0000000000003a93
  ffffffff81d3de70 ffff8800b1071948 ffffffff81397dc5 ffff8800b1071928
  ffff8800b10c8bd0 0000000000000006 ffff8800b10c9358 0000000000000006
 Call Trace:
  [<ffffffff81399cac>] dump_stack+0x4e/0x68
  [<ffffffff81397dc5>] print_circular_bug+0x1f8/0x209
  [<ffffffff81074760>] __lock_acquire+0xae3/0xe68
  [<ffffffff8107565d>] ? debug_check_no_locks_freed+0x12c/0x143
  [<ffffffff81075027>] lock_acquire+0xfb/0x144
  [<ffffffff8118b9d7>] ? sysfs_addrm_finish+0x28/0x46
  [<ffffffff81072201>] ? lockdep_init_map+0x14e/0x160
  [<ffffffff8118b027>] sysfs_deactivate+0xa5/0x108
  [<ffffffff8118b9d7>] ? sysfs_addrm_finish+0x28/0x46
  [<ffffffff8118b9d7>] sysfs_addrm_finish+0x28/0x46
  [<ffffffff8118bd3f>] sysfs_remove+0x2a/0x31
  [<ffffffff8118be2f>] sysfs_remove_dir+0x66/0x6b
  [<ffffffff811d5d11>] kobject_del+0x18/0x42
  [<ffffffff811d5e1c>] kobject_cleanup+0xe1/0x14f
  [<ffffffff811d5ede>] kobject_put+0x45/0x49
  [<ffffffff812a6ed5>] cpufreq_policy_put_kobj+0x37/0x83
  [<ffffffff812a8bfb>] __cpufreq_add_dev.isra.18+0x75e/0x78c
  [<ffffffff81071b04>] ? __lock_is_held+0x32/0x54
  [<ffffffff812a8c89>] cpufreq_cpu_callback+0x53/0x88
  [<ffffffff813a314c>] notifier_call_chain+0x67/0x92
  [<ffffffff8105bce4>] __raw_notifier_call_chain+0x9/0xb
  [<ffffffff81039e7c>] __cpu_notify+0x1b/0x32
  [<ffffffff81039ea1>] cpu_notify+0xe/0x10
  [<ffffffff8103a12b>] _cpu_up+0xf1/0x124
  [<ffffffff8138ee7d>] enable_nonboot_cpus+0x52/0xbf
  [<ffffffff8107a2a3>] hibernation_snapshot+0x1be/0x2ed
  [<ffffffff8107eb84>] snapshot_ioctl+0x1e5/0x431
  [<ffffffff81139080>] do_vfs_ioctl+0x45e/0x4a8
  [<ffffffff811414c8>] ? fcheck_files+0xa1/0xe4
  [<ffffffff81141a67>] ? fget_light+0x33/0x9a
  [<ffffffff8113911c>] SyS_ioctl+0x52/0x82
  [<ffffffff811df4ce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
  [<ffffffff813a57a2>] system_call_fastpath+0x16/0x1b
 CPU1 is up
 ACPI: Waking up from system sleep state S4
 PM: noirq thaw of devices complete after 1.722 msecs
 PM: early thaw of devices complete after 1.180 msecs



Bjørn
