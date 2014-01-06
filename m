Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbaAFJZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:25:06 -0500
Received: from canardo.mork.no ([148.122.252.1]:36922 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbaAFJZA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:25:00 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq\@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] cpufreq: try to resume policies which failed on last resume
Organization: m
References: <f9d7b0d5424e4443597d2ed39bec3fedd2b10d1e.1387848958.git.viresh.kumar@linaro.org>
	<5562479.pVWRuDL0y6@vostro.rjw.lan> <87zjne7f75.fsf@nemi.mork.no>
	<2302938.b8tymqrMEz@vostro.rjw.lan> <878uuxquxu.fsf@nemi.mork.no>
	<871u0po0gx.fsf@nemi.mork.no>
	<CAKohpo=9p8ArfWyyWkdQm_BWtyWbWe_dsg6VAUP60VUFcAjFSw@mail.gmail.com>
	<87wqihmg9a.fsf@nemi.mork.no>
	<CAKohpo=3s6=gw8OJTrUdLH8o2ouA=8a8MhrgNRXwHmOf0si5Pw@mail.gmail.com>
Date: Mon, 06 Jan 2014 10:01:26 +0100
In-Reply-To: <CAKohpo=3s6=gw8OJTrUdLH8o2ouA=8a8MhrgNRXwHmOf0si5Pw@mail.gmail.com>
	(Viresh Kumar's message of "Mon, 6 Jan 2014 11:57:19 +0530")
Message-ID: <87iotx32mx.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh Kumar <viresh.kumar@linaro.org> writes:
> On 3 January 2014 17:25, Bjørn Mork <bjorn@mork.no> wrote:
>> Correct. And users not running a lock debugging kernel will of course
>> not even see the warning.
>
> Okay..
>
>>> - It only happens when cpufreq_add_dev() fails during hibernation while
>>> we enable non-boot CPUs again to save image to disk. So, isn't a problem
>>> for a system which doesn't have any issues with add_dev() failing on
>>> hibernation
>>
>> Wrong.  This was my initial assumption but I later found out that the
>> issue is unrelated to hibernation failures.  Sorry about the confusion.
>
> Hmm.. Can we have the latest warning logs you have? Earlier ones were
> related to hibernation..

That's correct.  I have not observed this on suspend to RAM.  But then
again I haven't rigged any way to log that, so I don't think it's
conclusive..

The point I tried to make is that it isn't related to any hibernation
*failures*.  The warning appears even if the add_dev() is successful,
and it also appears if I touch only the *boot* cpu cpufreq attributes.

I.e., this seems to be unrelated to the hotplugging code.

Here's another copy of the warning, captured by cancelling hibernation
as I don't have any other way to log it at the moment.  But I do see the
warning appear on the console *before* cancelling.  And I also see this
warning appear when trying the in-kernel hibernation instead of
userspace.

[  267.893084] ======================================================
[  267.893085] [ INFO: possible circular locking dependency detected ]
[  267.893087] 3.13.0-rc6+ #183 Tainted: G        W   
[  267.893089] -------------------------------------------------------
[  267.893090] s2disk/5450 is trying to acquire lock:
[  267.893101]  (s_active#164){++++.+}, at: [<ffffffff8118b9d7>] sysfs_addrm_finish+0x28/0x46
[  267.893102] 
[  267.893102] but task is already holding lock:
[  267.893111]  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff81039ff5>] cpu_hotplug_begin+0x28/0x50
[  267.893112] 
[  267.893112] which lock already depends on the new lock.
[  267.893112] 
[  267.893113] 
[  267.893113] the existing dependency chain (in reverse order) is:
[  267.893117] 
[  267.893117] -> #1 (cpu_hotplug.lock){+.+.+.}:
[  267.893123]        [<ffffffff81075027>] lock_acquire+0xfb/0x144
[  267.893128]        [<ffffffff8139d4d2>] mutex_lock_nested+0x6c/0x397
[  267.893132]        [<ffffffff81039f4a>] get_online_cpus+0x3c/0x50
[  267.893137]        [<ffffffff812a69c4>] store+0x20/0xad
[  267.893142]        [<ffffffff8118a9a1>] sysfs_write_file+0x138/0x18b
[  267.893147]        [<ffffffff8112a428>] vfs_write+0x9c/0x102
[  267.893151]        [<ffffffff8112a716>] SyS_write+0x50/0x85
[  267.893155]        [<ffffffff813a57a2>] system_call_fastpath+0x16/0x1b
[  267.893160] 
[  267.893160] -> #0 (s_active#164){++++.+}:
[  267.893164]        [<ffffffff81074760>] __lock_acquire+0xae3/0xe68
[  267.893168]        [<ffffffff81075027>] lock_acquire+0xfb/0x144
[  267.893172]        [<ffffffff8118b027>] sysfs_deactivate+0xa5/0x108
[  267.893175]        [<ffffffff8118b9d7>] sysfs_addrm_finish+0x28/0x46
[  267.893178]        [<ffffffff8118bd3f>] sysfs_remove+0x2a/0x31
[  267.893182]        [<ffffffff8118be2f>] sysfs_remove_dir+0x66/0x6b
[  267.893186]        [<ffffffff811d5d11>] kobject_del+0x18/0x42
[  267.893190]        [<ffffffff811d5e1c>] kobject_cleanup+0xe1/0x14f
[  267.893193]        [<ffffffff811d5ede>] kobject_put+0x45/0x49
[  267.893197]        [<ffffffff812a6ed5>] cpufreq_policy_put_kobj+0x37/0x83
[  267.893201]        [<ffffffff812a8bfb>] __cpufreq_add_dev.isra.18+0x75e/0x78c
[  267.893204]        [<ffffffff812a8c89>] cpufreq_cpu_callback+0x53/0x88
[  267.893208]        [<ffffffff813a314c>] notifier_call_chain+0x67/0x92
[  267.893213]        [<ffffffff8105bce4>] __raw_notifier_call_chain+0x9/0xb
[  267.893217]        [<ffffffff81039e7c>] __cpu_notify+0x1b/0x32
[  267.893221]        [<ffffffff81039ea1>] cpu_notify+0xe/0x10
[  267.893225]        [<ffffffff8103a12b>] _cpu_up+0xf1/0x124
[  267.893230]        [<ffffffff8138ee7d>] enable_nonboot_cpus+0x52/0xbf
[  267.893234]        [<ffffffff8107a2a3>] hibernation_snapshot+0x1be/0x2ed
[  267.893238]        [<ffffffff8107eb84>] snapshot_ioctl+0x1e5/0x431
[  267.893242]        [<ffffffff81139080>] do_vfs_ioctl+0x45e/0x4a8
[  267.893245]        [<ffffffff8113911c>] SyS_ioctl+0x52/0x82
[  267.893249]        [<ffffffff813a57a2>] system_call_fastpath+0x16/0x1b
[  267.893250] 
[  267.893250] other info that might help us debug this:
[  267.893250] 
[  267.893251]  Possible unsafe locking scenario:
[  267.893251] 
[  267.893252]        CPU0                    CPU1
[  267.893253]        ----                    ----
[  267.893256]   lock(cpu_hotplug.lock);
[  267.893259]                                lock(s_active#164);
[  267.893261]                                lock(cpu_hotplug.lock);
[  267.893265]   lock(s_active#164);
[  267.893266] 
[  267.893266]  *** DEADLOCK ***
[  267.893266] 
[  267.893268] 7 locks held by s2disk/5450:
[  267.893275]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107e9ea>] snapshot_ioctl+0x4b/0x431
[  267.893283]  #1:  (device_hotplug_lock){+.+.+.}, at: [<ffffffff812837ac>] lock_device_hotplug+0x12/0x14
[  267.893290]  #2:  (acpi_scan_lock){+.+.+.}, at: [<ffffffff8122c6d3>] acpi_scan_lock_acquire+0x12/0x14
[  267.893297]  #3:  (console_lock){+.+.+.}, at: [<ffffffff810817f2>] suspend_console+0x20/0x38
[  267.893305]  #4:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff81039fb9>] cpu_maps_update_begin+0x12/0x14
[  267.893311]  #5:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff81039ff5>] cpu_hotplug_begin+0x28/0x50
[  267.893318]  #6:  (cpufreq_rwsem){.+.+.+}, at: [<ffffffff812a851c>] __cpufreq_add_dev.isra.18+0x7f/0x78c
[  267.893319] 
[  267.893319] stack backtrace:
[  267.893322] CPU: 0 PID: 5450 Comm: s2disk Tainted: G        W    3.13.0-rc6+ #183
[  267.893324] Hardware name: LENOVO 2776LEG/2776LEG, BIOS 6EET55WW (3.15 ) 12/19/2011
[  267.893329]  ffffffff81d3cd00 ffff8800b7acd8f8 ffffffff81399cac 00000000000068f7
[  267.893334]  ffffffff81d3cd00 ffff8800b7acd948 ffffffff81397dc5 ffff8800b7acd928
[  267.893338]  ffff8800b7b24990 0000000000000006 ffff8800b7b25118 0000000000000006
[  267.893339] Call Trace:
[  267.893344]  [<ffffffff81399cac>] dump_stack+0x4e/0x68
[  267.893349]  [<ffffffff81397dc5>] print_circular_bug+0x1f8/0x209
[  267.893353]  [<ffffffff81074760>] __lock_acquire+0xae3/0xe68
[  267.893357]  [<ffffffff8107565d>] ? debug_check_no_locks_freed+0x12c/0x143
[  267.893361]  [<ffffffff81075027>] lock_acquire+0xfb/0x144
[  267.893365]  [<ffffffff8118b9d7>] ? sysfs_addrm_finish+0x28/0x46
[  267.893369]  [<ffffffff81072201>] ? lockdep_init_map+0x14e/0x160
[  267.893372]  [<ffffffff8118b027>] sysfs_deactivate+0xa5/0x108
[  267.893376]  [<ffffffff8118b9d7>] ? sysfs_addrm_finish+0x28/0x46
[  267.893380]  [<ffffffff8118b9d7>] sysfs_addrm_finish+0x28/0x46
[  267.893383]  [<ffffffff8118bd3f>] sysfs_remove+0x2a/0x31
[  267.893386]  [<ffffffff8118be2f>] sysfs_remove_dir+0x66/0x6b
[  267.893390]  [<ffffffff811d5d11>] kobject_del+0x18/0x42
[  267.893393]  [<ffffffff811d5e1c>] kobject_cleanup+0xe1/0x14f
[  267.893396]  [<ffffffff811d5ede>] kobject_put+0x45/0x49
[  267.893400]  [<ffffffff812a6ed5>] cpufreq_policy_put_kobj+0x37/0x83
[  267.893404]  [<ffffffff812a8bfb>] __cpufreq_add_dev.isra.18+0x75e/0x78c
[  267.893407]  [<ffffffff81071b04>] ? __lock_is_held+0x32/0x54
[  267.893413]  [<ffffffff812a8c89>] cpufreq_cpu_callback+0x53/0x88
[  267.893416]  [<ffffffff813a314c>] notifier_call_chain+0x67/0x92
[  267.893421]  [<ffffffff8105bce4>] __raw_notifier_call_chain+0x9/0xb
[  267.893425]  [<ffffffff81039e7c>] __cpu_notify+0x1b/0x32
[  267.893428]  [<ffffffff81039ea1>] cpu_notify+0xe/0x10
[  267.893432]  [<ffffffff8103a12b>] _cpu_up+0xf1/0x124
[  267.893436]  [<ffffffff8138ee7d>] enable_nonboot_cpus+0x52/0xbf
[  267.893439]  [<ffffffff8107a2a3>] hibernation_snapshot+0x1be/0x2ed
[  267.893443]  [<ffffffff8107eb84>] snapshot_ioctl+0x1e5/0x431
[  267.893447]  [<ffffffff81139080>] do_vfs_ioctl+0x45e/0x4a8
[  267.893451]  [<ffffffff811414c8>] ? fcheck_files+0xa1/0xe4
[  267.893454]  [<ffffffff81141a67>] ? fget_light+0x33/0x9a
[  267.893457]  [<ffffffff8113911c>] SyS_ioctl+0x52/0x82
[  267.893462]  [<ffffffff811df4ce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  267.893466]  [<ffffffff813a57a2>] system_call_fastpath+0x16/0x1b



I don't think I do anything extra-ordinary to trigger this, so I would
be surprised if you can't reproduce it by doing 

  export x=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
  echo $x >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
  s2disk

or similar on a kernel with CONFIG_PROVE_LOCKING=y


Bjørn
