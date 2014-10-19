Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaJSL1E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 07:27:04 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:45959 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaJSL1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 07:27:00 -0400
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Replacing unexpected machine restart with kernel panic using SystemTap?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201410192026.AFG70955.OMQFtJOOFHSFLV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 19 Oct 2014 20:26:55 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Since I hear a few dozens of cases every year from users that their servers
rebooted unexpectedly, I'm trying to find out the reason of rebooting.

At first, I suggested users to try serial console or netconsole to see
if any kernel messages are printed just before rebooting.

For servers that are using heartbeat software, watchdog's timeout might be
the reason of unexpected reboots. Therefore, I started suggesting those who
are using softdog ( drivers/watchdog/softdog.ko ) as watchdog driver to try
soft_panic=1 module option so that softdog's timeout will trigger kernel panic
rather than unexpected reboots.

However, there would be other means to trigger unexpected reboots. Heartbeat
and/or clustering software might issue reboot(LINUX_REBOOT_CMD_RESTART)
syscall (which /sbin/reboot -f command does) for immediate rebooting.
System call auditing will not help for recording immediate rebooting.

Therefore, I came up with an idea that I can catch almost all cases by
inserting SystemTap probe so that any call to a function for restarting
a machine is replaced with kernel panic. For example, by inserting SystemTap
probe at native_machine_emergency_restart() in arch/x86/kernel/reboot.c

---------- Command line start ----------
# stap -p4 -m reboot2panic -g -e '
function call_panic() %{ panic("Calling panic() due to machine restart\n"); %}
probe kernel.function("native_machine_emergency_restart") { call_panic(); }'
# staprun reboot2panic.ko
---------- Command line end ----------

I can obtain

---------- Example of kernel messages start ----------
<2>SoftDog: Initiating system reboot.
<0>Kernel panic - not syncing: Calling panic() due to machine restart
<0>
<4>Pid: 0, comm: swapper Not tainted 2.6.32-431.29.2.el6.i686 #1
<4>Call Trace:
<4> [<c085dffc>] ? panic+0x6e/0x122
<4> [<f7ed2196>] ? probe_2069+0x26/0x50 [reboot2panic]
<4> [<f7ed4729>] ? enter_kprobe_probe+0x159/0x320 [reboot2panic]
<4> [<c042dea8>] ? local_apic_timer_interrupt+0x28/0x60
<4> [<c042aa10>] ? native_machine_emergency_restart+0x0/0x230
<4> [<c08639ab>] ? kprobe_exceptions_notify+0x32b/0x3a0
<4> [<c042aa11>] ? native_machine_emergency_restart+0x1/0x230
<4> [<c0863bc4>] ? notifier_call_chain+0x44/0x60
<4> [<c0863c0a>] ? atomic_notifier_call_chain+0x1a/0x20
<4> [<c04833e0>] ? notify_die+0x30/0x40
<4> [<c08618dd>] ? do_int3+0x2d/0x90
<4> [<c0861780>] ? int3+0x30/0x38
<4> [<f7e800e0>] ? mirror_status+0x50/0x2e0 [dm_mirror]
<4> [<c042aa10>] ? native_machine_emergency_restart+0x0/0x230
<4> [<c042a6c0>] ? machine_emergency_restart+0x10/0x20
<4> [<f7e8f056>] ? watchdog_fire+0x36/0x80 [softdog]
<4> [<c046b391>] ? run_timer_softirq+0x131/0x2b0
<4> [<f7e8f020>] ? watchdog_fire+0x0/0x80 [softdog]
<4> [<c046237a>] ? __do_softirq+0x8a/0x1a0
<4> [<c04624cd>] ? do_softirq+0x3d/0x50
<4> [<c0462625>] ? irq_exit+0x65/0x70
<4> [<c042df15>] ? smp_apic_timer_interrupt+0x35/0x50
<4> [<c0861205>] ? apic_timer_interrupt+0x31/0x38
<4> [<c0437482>] ? native_safe_halt+0x2/0x10
<4> [<c041255d>] ? default_idle+0x4d/0xc0
<4> [<c0408884>] ? cpu_idle+0x94/0xd0
<4> [<c085a27e>] ? start_secondary+0x2af/0x2f4
---------- Example of kernel messages end ----------

for softdog's timeout cases,

---------- Example of kernel messages start ----------
<0>Restarting system.
<4>machine restart
<0>Kernel panic - not syncing: Calling panic() due to machine restart
<0>
<4>Pid: 1381, comm: reboot Not tainted 2.6.32-431.29.2.el6.i686 #1
<4>Call Trace:
<4> [<c085dffc>] ? panic+0x6e/0x122
<4> [<f7ed2196>] ? probe_2069+0x26/0x50 [reboot2panic]
<4> [<f7ed4729>] ? enter_kprobe_probe+0x159/0x320 [reboot2panic]
<4> [<c042aa10>] ? native_machine_emergency_restart+0x0/0x230
<4> [<c08639ab>] ? kprobe_exceptions_notify+0x32b/0x3a0
<4> [<c042aa11>] ? native_machine_emergency_restart+0x1/0x230
<4> [<c0863bc4>] ? notifier_call_chain+0x44/0x60
<4> [<c0863c0a>] ? atomic_notifier_call_chain+0x1a/0x20
<4> [<c04833e0>] ? notify_die+0x30/0x40
<4> [<c08618dd>] ? do_int3+0x2d/0x90
<4> [<c0861780>] ? int3+0x30/0x38
<4> [<c04200d8>] ? uncore_pmu_event_add+0x2d8/0x3f0
<4> [<c04200e0>] ? uncore_pmu_event_add+0x2e0/0x3f0
<4> [<c042aa10>] ? native_machine_emergency_restart+0x0/0x230
<4> [<c042a77e>] ? native_machine_restart+0x2e/0x40
<4> [<c042a6d6>] ? machine_restart+0x6/0x10
<4> [<c0476cb4>] ? sys_reboot+0x184/0x220
<4> [<c043fb80>] ? kmap_atomic_prot+0x120/0x150
<4> [<c050e3b1>] ? handle_mm_fault+0x131/0x1d0
<4> [<c04399aa>] ? __do_page_fault+0x1aa/0x410
<4> [<c054cd56>] ? d_kill+0x36/0x50
<4> [<c054e22d>] ? dput+0x5d/0x110
<4> [<c05385d4>] ? __fput+0x164/0x1f0
<4> [<c0553ac5>] ? mntput_no_expire+0x15/0xd0
<4> [<c04b9dee>] ? audit_syscall_entry+0x1be/0x1e0
<4> [<c0863b1a>] ? do_page_fault+0x2a/0x90
<4> [<c04099bf>] ? sysenter_do_call+0x12/0x28
---------- Example of kernel messages end ----------

for /sbin/reboot -f cases, and regular reboot sequence remains
unchanged because the probe by staprun process is removed by
regular reboot sequence.

But I'm not sure whether it is appropriate to insert this probe at
native_machine_emergency_restart(). Could you give me suggestions
about where to insert this probe?

Regards.
