Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab3KZSWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:22:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932329Ab3KZSWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:22:08 -0500
Date: Tue, 26 Nov 2013 13:21:57 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: odd userspace lockups.
Message-ID: <20131126182157.GA503@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been seeing this a few times on your current tree while fuzz testing.

When it happens, the machine responds to ping, but ssh always times out.
I can log in on a tty, but as soon as it tries to exec something, that tty hangs.

I've been away for a week, but don't recall seeing it before I left, so it's
likely caused by something merged in the last week.  I'll attempt a bisect
if no-one has any ideas.  sysrq output below.

At first I thought it was just being really slow, (especially after seeing
all those congestion related symbols in the stack traces), but even after
being left for hours, it doesn't seem to progress.

I've been trying to narrow down a sequence of syscalls for an aio oops I'm
chasing, but this keeps getting in my way.

	Dave


CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-rc1+ #11 
task: ffffffff81c104c0 ti: ffffffff81c00000 task.ti: ffffffff81c00000
RIP: 0010:[<ffffffff815c4741>]  [<ffffffff815c4741>] poll_idle+0x41/0x80
RSP: 0018:ffffffff81c01e68  EFLAGS: 00000246
RAX: 0000000000080000 RBX: ffffffff82aa1348 RCX: 0000000000080000
RDX: 0000000000000000 RSI: ffffffff81c01fd8 RDI: ffffffff81c104c0
RBP: ffffffff81c01e80 R08: 00000000006f9081 R09: ffffffffffffffff
R10: 000006a464b8145a R11: 0000000225c17d03 R12: ffffffff810aa45d
R13: ffffffff81c01de8 R14: ffffffff810a9fae R15: ffffffff81c01dc8
FS:  0000000000000000(0000) GS:ffff880244800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f50e005b930 CR3: 00000001d3b4e000 CR4: 00000000001407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Stack:
 ffffe8ffff600600 ffffffff81c9b7c0 0000000000000000 ffffffff81c01eb8
 ffffffff815c3f30 0000000000000002 ffffe8ffff600600 0000000000000000
 0000000000000000 ffffffff81c9b7c0 ffffffff81c01ef8 ffffffff815c406d
Call Trace:
 [<ffffffff815c3f30>] cpuidle_enter_state+0x40/0xc0
 [<ffffffff815c406d>] cpuidle_idle_call+0xbd/0x3b0
 [<ffffffff8100cd3e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810b883a>] cpu_startup_entry+0xca/0x470
 [<ffffffff81731397>] rest_init+0x137/0x140
 [<ffffffff81731265>] ? rest_init+0x5/0x140
 [<ffffffff81ee2e6a>] start_kernel+0x415/0x422
 [<ffffffff81ee285d>] ? repair_env_string+0x5c/0x5c
 [<ffffffff81ee2571>] x86_64_start_reservations+0x2a/0x2c
 [<ffffffff81ee2664>] x86_64_start_kernel+0xf1/0xf4
Code: b0 ff 49 89 c5 e8 10 88 ae ff fb 65 48 8b 34 25 f0 b9 00 00 48 8b 86 38 e0 ff ff a8 08 75 11 0f 1f 00 f3 90 48 8b 8e 38 e0 ff ff <83> e1 08 74 f2 e8 d5 c7 b0 ff 4c 29 e8 48 89 c7 e8 aa 44 a9 ff 
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-rc1+ #11
task: ffffffff81c104c0 ti: ffffffff81c00000 task.ti: ffffffff81c00000
RIP: 0010:[<ffffffff815c473a>]  [<ffffffff815c473a>] poll_idle+0x3a/0x80
RSP: 0018:ffffffff81c01e68  EFLAGS: 00000246
RAX: 0000000000080000 RBX: ffffffff82aa1348 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff81c01fd8 RDI: ffffffff81c104c0
RBP: ffffffff81c01e80 R08: 00000000006f9080 R09: ffffffffffffffff
R10: 000006a64a44c96d R11: 0000000225c17d03 R12: ffffffff810aa45d
R13: ffffffff81c01de8 R14: ffffffff810a9fae R15: ffffffff81c01dc8
FS:  0000000000000000(0000) GS:ffff880244800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f50e005b930 CR3: 000000022bb5c000 CR4: 00000000001407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Stack:
 ffffe8ffff600600 ffffffff81c9b7c0 0000000000000000 ffffffff81c01eb8
 ffffffff815c3f30 0000000000000002 ffffe8ffff600600 0000000000000000
 0000000000000000 ffffffff81c9b7c0 ffffffff81c01ef8 ffffffff815c406d
Call Trace:
 [<ffffffff815c3f30>] cpuidle_enter_state+0x40/0xc0
 [<ffffffff815c406d>] cpuidle_idle_call+0xbd/0x3b0
 [<ffffffff8100cd3e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810b883a>] cpu_startup_entry+0xca/0x470
 [<ffffffff81731397>] rest_init+0x137/0x140
 [<ffffffff81731265>] ? rest_init+0x5/0x140
 [<ffffffff81ee2e6a>] start_kernel+0x415/0x422
 [<ffffffff81ee285d>] ? repair_env_string+0x5c/0x5c
 [<ffffffff81ee2571>] x86_64_start_reservations+0x2a/0x2c
 [<ffffffff81ee2664>] x86_64_start_kernel+0xf1/0xf4
Code: fc 53 89 d3 e8 08 c8 b0 ff 49 89 c5 e8 10 88 ae ff fb 65 48 8b 34 25 f0 b9 00 00 48 8b 86 38 e0 ff ff a8 08 75 11 0f 1f 00 f3 90 <48> 8b 8e 38 e0 ff ff 83 e1 08 74 f2 e8 d5 c7 b0 ff 4c 29 e8 48 
 [<ffffffff810c6d20>] rcu_nocb_kthread+0x5b0/0xfe0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff810c6770>] ? rcu_gp_kthread+0x1440/0x1440
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
rcu_bh          S 0000000000000000  6576    19      2 0x00000000
 ffff880243255d60 0000000000000006 ffffffff81c49fa0 ffff88024324c170
 00000000001d3fc0 ffff880243255fd8 00000000001d3fc0 ffff88024324aba0
 ffff88024324c170 ffffffff81c49fa0 ffffffff81a2cb06 fffffffffffffed4
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810c53ea>] rcu_gp_kthread+0xba/0x1440
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810acf3d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff810c5330>] ? rcu_boost_kthread+0x610/0x610
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
rcuob/0         S 0000000000000000  6592    20      2 0x00000000
 ffff880243261d70 0000000000000006 ffff8802449cd978 ffff88024324aba0
 00000000001d3fc0 ffff880243261fd8 00000000001d3fc0 ffff880243268000
 ffff88024324aba0 ffff88024377f260 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810c6d20>] rcu_nocb_kthread+0x5b0/0xfe0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff810c6770>] ? rcu_gp_kthread+0x1440/0x1440
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
rcuob/1         S 0000000000000000  6592    21      2 0x00000000
 ffff880243263d70 0000000000000006 ffff880244bcd978 ffff880243268000
 00000000001d3fc0 ffff880243263fd8 00000000001d3fc0 ffff88024326d740
 ffff880243268000 ffff88024377f260 0000000000000001 0000000000000001
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810c6d20>] rcu_nocb_kthread+0x5b0/0xfe0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff810c6770>] ? rcu_gp_kthread+0x1440/0x1440
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
rcuob/2         S 0000000000000000  6592    22      2 0x00000000
 ffff880243265d70 0000000000000006 ffff880244dcd978 ffff88024326d740
 00000000001d3fc0 ffff880243265fd8 00000000001d3fc0 ffff8802432695d0
 ffff88024326d740 ffff88024377f260 0000000000000001 0000000000000002
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810c6d20>] rcu_nocb_kthread+0x5b0/0xfe0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff810c6770>] ? rcu_gp_kthread+0x1440/0x1440
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
rcuob/3         S 0000000000000000  6592    23      2 0x00000000
 ffff880243267d70 0000000000000006 ffff880244fcd978 ffff8802432695d0
 00000000001d3fc0 ffff880243267fd8 00000000001d3fc0 ffff88024326c170
 ffff8802432695d0 ffff88024377f260 0000000000000001 0000000000000003
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810c6d20>] rcu_nocb_kthread+0x5b0/0xfe0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff810c6770>] ? rcu_gp_kthread+0x1440/0x1440
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
migration/0     S 0000000000000000  6336    24      2 0x00000000
 ffff880243271dd8 0000000000000002 ffff880243271d98 ffff88024326c170
 00000000001d3fc0 ffff880243271fd8 00000000001d3fc0 ffffffff81c104c0
 ffff88024326c170 ffff88024326c170 ffff8802437fd988 ffffffff81c521c0
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810882b3>] smpboot_thread_fn+0x133/0x2d0
 [<ffffffff81088180>] ? SyS_setgroups+0x190/0x190
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8174108f>] ? wait_for_completion+0xdf/0x110
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
watchdog/0      S 0000000000000000  5736    25      2 0x00000000
 ffff880243295dd8 0000000000000002 0000000000000000 ffff88024326aba0
 00000000001d3fc0 ffff880243295fd8 00000000001d3fc0 ffff88023e700000
 ffff88024326aba0 ffff88024326aba0 ffff880243290158 ffffffff81c52b80
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810882b3>] smpboot_thread_fn+0x133/0x2d0
 [<ffffffff81088180>] ? SyS_setgroups+0x190/0x190
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8174108f>] ? wait_for_completion+0xdf/0x110
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
watchdog/1      S 0000000000000000  6032    26      2 0x00000000
 ffff8802432a7dd8 0000000000000002 0000000000000001 ffff88024329c170
 00000000001d3fc0 ffff8802432a7fd8 00000000001d3fc0 ffff880243298000
 ffff88024329c170 ffff88024329c170 ffff880243291c38 ffffffff81c52b80
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810882b3>] smpboot_thread_fn+0x133/0x2d0
 [<ffffffff81088180>] ? SyS_setgroups+0x190/0x190
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8174108f>] ? wait_for_completion+0xdf/0x110
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
migration/1     S 0000000000000000  6336    27      2 0x00000000
 ffff8802432b9dd8 0000000000000002 ffff8802432b9d98 ffff88024329aba0
 00000000001d3fc0 ffff8802432b9fd8 00000000001d3fc0 ffff880243298000
 ffff88024329aba0 ffff88024329aba0 ffff8802432902b0 ffffffff81c521c0
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810882b3>] smpboot_thread_fn+0x133/0x2d0
 [<ffffffff81088180>] ? SyS_setgroups+0x190/0x190
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8174108f>] ? wait_for_completion+0xdf/0x110
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
rcuc/1          S 0000000000000000  6592    28      2 0x00000000
 ffff8802432bbdd8 0000000000000002 ffff880200000078 ffff8802432c0000
 00000000001d3fc0 ffff8802432bbfd8 00000000001d3fc0 ffff8802432c15d0
 ffff8802432c0000 ffff8802432c0000 ffff880243291ae0 ffffffff81c49460
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810882b3>] smpboot_thread_fn+0x133/0x2d0
 [<ffffffff8173fc09>] ? schedule+0x29/0x70
 [<ffffffff81088180>] ? SyS_setgroups+0x190/0x190
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8174108f>] ? wait_for_completion+0xdf/0x110
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
ksoftirqd/1     S 0000000000000000  6096    29      2 0x00000000
 ffff8802432bddd8 0000000000000002 0000000000000246 ffff8802432c5740
 00000000001d3fc0 ffff8802432bdfd8 00000000001d3fc0 ffff880243298000
 ffff8802432c5740 ffff8802432c5740 ffff880243290408 ffffffff81c35c80
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810882b3>] smpboot_thread_fn+0x133/0x2d0
 [<ffffffff81088180>] ? SyS_setgroups+0x190/0x190
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8174108f>] ? wait_for_completion+0xdf/0x110
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kworker/1:0H    S 0000000000000000  6624    31      2 0x00000000
 ffff8802432cddd0 0000000000000002 ffffffff81744d7c ffff8802432c4170
 00000000001d3fc0 ffff8802432cdfd8 00000000001d3fc0 ffff880243298000
 ffff8802432c4170 ffff880244bd3a00 ffff880244bd3a58 ffff8802437f9590
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076b40>] worker_thread+0x1c0/0x3a0
 [<ffffffff81076980>] ? process_one_work+0x6f0/0x6f0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
watchdog/2      S 0000000000000000  6032    32      2 0x00000000
 ffff8802432f5dd8 0000000000000002 0000000000000002 ffff8802432c2ba0
 00000000001d3fc0 ffff8802432f5fd8 00000000001d3fc0 ffff88024329d740
 ffff8802432c2ba0 ffff8802432c2ba0 ffff880243291988 ffffffff81c52b80
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810882b3>] smpboot_thread_fn+0x133/0x2d0
 [<ffffffff81088180>] ? SyS_setgroups+0x190/0x190
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8174108f>] ? wait_for_completion+0xdf/0x110
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
migration/2     S 0000000000000000  6336    33      2 0x00000000
 ffff8802432f7dd8 0000000000000002 ffff8802432f7d98 ffff8802432f8000
 00000000001d3fc0 ffff8802432f7fd8 00000000001d3fc0 ffff88024329d740
 ffff8802432f8000 ffff8802432f8000 ffff880243290560 ffffffff81c521c0
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810882b3>] smpboot_thread_fn+0x133/0x2d0
 [<ffffffff81088180>] ? SyS_setgroups+0x190/0x190
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8174108f>] ? wait_for_completion+0xdf/0x110
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
rcuc/2          S 0000000000000000  6592    34      2 0x00000000
 ffff880243341dd8 0000000000000002 ffff880200000078 ffff8802432fd740
 00000000001d3fc0 ffff880243341fd8 00000000001d3fc0 ffff8802432f95d0
 ffff8802432fd740 ffff8802432fd740 ffff880243291830 ffffffff81c49460
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810882b3>] smpboot_thread_fn+0x133/0x2d0
 [<ffffffff8173fc09>] ? schedule+0x29/0x70
 [<ffffffff81088180>] ? SyS_setgroups+0x190/0x190
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8174108f>] ? wait_for_completion+0xdf/0x110
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
ksoftirqd/2     S 0000000000000000  6208    35      2 0x00000000
 ffff880243343dd8 0000000000000002 0000000000000246 ffff8802432f95d0
 00000000001d3fc0 ffff880243343fd8 00000000001d3fc0 ffff8802416dd740
 ffff8802432f95d0 ffff8802432f95d0 ffff8802432906b8 ffffffff81c35c80
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810882b3>] smpboot_thread_fn+0x133/0x2d0
 [<ffffffff81088180>] ? SyS_setgroups+0x190/0x190
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8174108f>] ? wait_for_completion+0xdf/0x110
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kworker/2:0H    S ffff88023e6b22a0  6624    37      2 0x00000000
 ffff880243347dd0 0000000000000002 ffffffff81744d7c ffff8802432faba0
 00000000001d3fc0 ffff880243347fd8 00000000001d3fc0 ffff88009ed02ba0
 ffff8802432faba0 ffff880244dd3a00 ffff880244dd3a58 ffff8802437f9038
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076b40>] worker_thread+0x1c0/0x3a0
 [<ffffffff81076980>] ? process_one_work+0x6f0/0x6f0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
watchdog/3      S 0000000000000000  5904    38      2 0x00000000
 ffff88024335bdd8 0000000000000002 0000000000000003 ffff880243360000
 00000000001d3fc0 ffff88024335bfd8 00000000001d3fc0 ffff8802432995d0
 ffff880243360000 ffff880243360000 ffff8802432916d8 ffffffff81c52b80
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810882b3>] smpboot_thread_fn+0x133/0x2d0
 [<ffffffff81088180>] ? SyS_setgroups+0x190/0x190
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8174108f>] ? wait_for_completion+0xdf/0x110
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
migration/3     S 0000000000000000  6336    39      2 0x00000000
 ffff880243369dd8 0000000000000002 ffff880243369d98 ffff880243365740
 00000000001d3fc0 ffff880243369fd8 00000000001d3fc0 ffff8802432995d0
 ffff880243365740 ffff880243365740 ffff880243290810 ffffffff81c521c0
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810882b3>] smpboot_thread_fn+0x133/0x2d0
 [<ffffffff81088180>] ? SyS_setgroups+0x190/0x190
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8174108f>] ? wait_for_completion+0xdf/0x110
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
rcuc/3          S 0000000000000000  6592    40      2 0x00000000
 ffff88024336bdd8 0000000000000002 ffff880200000078 ffff8802433615d0
 00000000001d3fc0 ffff88024336bfd8 00000000001d3fc0 ffff880243364170
 ffff8802433615d0 ffff8802433615d0 ffff880243291580 ffffffff81c49460
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810882b3>] smpboot_thread_fn+0x133/0x2d0
 [<ffffffff8173fc09>] ? schedule+0x29/0x70
 [<ffffffff81088180>] ? SyS_setgroups+0x190/0x190
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8174108f>] ? wait_for_completion+0xdf/0x110
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
ksoftirqd/3     S 0000000000000000  6208    41      2 0x00000000
 ffff88024336ddd8 0000000000000002 0000000000000246 ffff880243364170
 00000000001d3fc0 ffff88024336dfd8 00000000001d3fc0 ffff88009f5d5740
 ffff880243364170 ffff880243364170 ffff880243290968 ffffffff81c35c80
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810882b3>] smpboot_thread_fn+0x133/0x2d0
 [<ffffffff81088180>] ? SyS_setgroups+0x190/0x190
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8174108f>] ? wait_for_completion+0xdf/0x110
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kworker/3:0     S ffff88023e6b52a0  5592    42      2 0x00000000
 ffff88024336fdd0 0000000000000002 ffffffff81744d7c ffff880243362ba0
 00000000001d3fc0 ffff88024336ffd8 00000000001d3fc0 ffff88009f628000
 ffff880243362ba0 ffff880244fd3440 ffff880244fd3498 ffff8802437f8e70
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076b40>] worker_thread+0x1c0/0x3a0
 [<ffffffff81076980>] ? process_one_work+0x6f0/0x6f0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kworker/3:0H    S ffff88023cdb8aa0  6624    43      2 0x00000000
 ffff880243373dd0 0000000000000002 ffffffff81744d7c ffff880243378000
 00000000001d3fc0 ffff880243373fd8 00000000001d3fc0 ffff88009ecf0000
 ffff880243378000 ffff880244fd3a00 ffff880244fd3a58 ffff880243370030
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076b40>] worker_thread+0x1c0/0x3a0
 [<ffffffff81076980>] ? process_one_work+0x6f0/0x6f0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
khelper         S 0000000000000000  6560    44      2 0x00000000
 ffff880243395da8 0000000000000002 ffffffff81744d7c ffff88024337d740
 00000000001d3fc0 ffff880243395fd8 00000000001d3fc0 ffff88024329d740
 ffff88024337d740 ffff88024337d740 ffff88024337d740 ffff88024338c790
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kdevtmpfs       S 0000000000000002  4872    45      2 0x00000000
 ffff880243397df0 0000000000000002 ffff880243397db0 ffff8802433795d0
 00000000001d3fc0 ffff880243397fd8 00000000001d3fc0 ffff88007ace15d0
 ffff8802433795d0 0000000000000000 0000000000000000 ffff8802433795d0
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff814ce09e>] devtmpfsd+0x16e/0x180
 [<ffffffff814cdf30>] ? handle_create.isra.2+0x200/0x200
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
netns           S 0000000000000000  6560    46      2 0x00000000
 ffff8802433edda8 0000000000000002 ffffffff81744d7c ffff88024337c170
 00000000001d3fc0 ffff8802433edfd8 00000000001d3fc0 ffff88024329d740
 ffff88024337c170 ffff88024337c170 ffff88024337c170 ffff88024338f580
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
writeback       S 0000000000000000  6560    47      2 0x00000000
 ffff880242d9bda8 0000000000000002 ffffffff81744d7c ffff88024337aba0
 00000000001d3fc0 ffff880242d9bfd8 00000000001d3fc0 ffff88024329d740
 ffff88024337aba0 ffff88024337aba0 ffff88024337aba0 ffff880242c161d0
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kintegrityd     S 0000000000000000  6560    48      2 0x00000000
 ffff880242dbbda8 0000000000000002 ffffffff81744d7c ffff880242dc0000
 00000000001d3fc0 ffff880242dbbfd8 00000000001d3fc0 ffff88024329d740
 ffff880242dc0000 ffff880242dc0000 ffff880242dc0000 ffff880242dbc100
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
bioset          S 0000000000000000  6560    49      2 0x00000000
 ffff880242dcbda8 0000000000000002 ffffffff81744d7c ffff880242dc5740
 00000000001d3fc0 ffff880242dcbfd8 00000000001d3fc0 ffff88024329d740
 ffff880242dc5740 ffff880242dc5740 ffff880242dc5740 ffff880242dbfc10
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kworker/u9:0    S 0000000000000000  5112    50      2 0x00000000
 ffff880242de5dd0 0000000000000002 ffffffff81744d7c ffff880242dc15d0
 00000000001d3fc0 ffff880242de5fd8 00000000001d3fc0 ffff8801c1eec170
 ffff880242dc15d0 ffff880242da8948 ffff880242da89a0 ffff880242d8f758
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076b40>] worker_thread+0x1c0/0x3a0
 [<ffffffff81076980>] ? process_one_work+0x6f0/0x6f0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kblockd         S 0000000000000000  6560    51      2 0x00000000
 ffff880242de7da8 0000000000000002 ffffffff81744d7c ffff880242dc4170
 00000000001d3fc0 ffff880242de7fd8 00000000001d3fc0 ffff88024329d740
 ffff880242dc4170 ffff880242dc4170 ffff880242dc4170 ffff880242dbc448
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
ata_sff         S 0000000000000000  6560    52      2 0x00000000
 ffff880242b53da8 0000000000000002 ffffffff81744d7c ffff880242dc2ba0
 00000000001d3fc0 ffff880242b53fd8 00000000001d3fc0 ffff88024329d740
 ffff880242dc2ba0 ffff880242dc2ba0 ffff880242dc2ba0 ffff880242dbeef0
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
khubd           S 0000000000000000  3448    53      2 0x00000000
 ffff880242b7bd10 0000000000000002 ffffffff81cb9980 ffff880242b80000
 00000000001d3fc0 ffff880242b7bfd8 00000000001d3fc0 ffffffff81c104c0
 ffff880242b80000 0000000000000000 0000000000000009 ffffffff81cb99e0
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81528435>] hub_thread+0x1135/0x1690
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810acf3d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff81527300>] ? usb_reset_device+0x1d0/0x1d0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
md              S 0000000000000000  6560    54      2 0x00000000
 ffff880242b8dda8 0000000000000002 ffffffff81744d7c ffff880242b85740
 00000000001d3fc0 ffff880242b8dfd8 00000000001d3fc0 ffff88024329d740
 ffff880242b85740 ffff880242b85740 ffff880242b85740 ffff880242dbd4b0
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
khungtaskd      S 0000000000000000  6448    80      2 0x00000000
 ffff88023e727ce0 0000000000000002 ffffffff81744d22 ffff88023e7015d0
 00000000001d3fc0 ffff88023e727fd8 00000000001d3fc0 ffff8802432995d0
 ffff88023e7015d0 ffff8802422096f8 0000000000000000 ffffffff8110cc00
Call Trace:
 [<ffffffff81744d22>] ? _raw_spin_unlock_irqrestore+0x42/0x70
 [<ffffffff8110cc00>] ? reset_hung_task_detector+0x20/0x20
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eba9>] schedule_timeout+0x1b9/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff8108a27e>] ? finish_task_switch+0x12e/0x180
 [<ffffffff8108a194>] ? finish_task_switch+0x44/0x180
 [<ffffffff8110cc00>] ? reset_hung_task_detector+0x20/0x20
 [<ffffffff8173ed4e>] schedule_timeout_interruptible+0x1e/0x20
 [<ffffffff8110cc61>] watchdog+0x61/0x650
 [<ffffffff8110cc00>] ? reset_hung_task_detector+0x20/0x20
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kswapd0         D 0000000000000002  4656    81      2 0x00000000
 ffff88023e743920 0000000000000002 ffff88023e704170 ffff88023e704170
 00000000001d3fc0 ffff88023e743fd8 00000000001d3fc0 ffff88009ecf5740
 ffff88023e704170 ffff88023e743950 ffff88024335c000 0000000100046486
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff811653cf>] kswapd_shrink_zone.constprop.64+0xef/0x1c0
 [<ffffffff81166388>] kswapd+0x448/0x9b0
 [<ffffffff81165f40>] ? try_to_free_pages+0xaa0/0xaa0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
ksmd            S 0000000000000000  6528    82      2 0x00000000
 ffff88023e749d88 0000000000000002 ffffffff81c62c80 ffff88023e702ba0
 00000000001d3fc0 ffff88023e749fd8 00000000001d3fc0 ffff8802432995d0
 ffff88023e702ba0 0000000000000000 0000000000000000 ffffffff811a1330
Call Trace:
 [<ffffffff811a1330>] ? try_to_merge_with_ksm_page+0x710/0x710
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff811a19d5>] ksm_scan_thread+0x6a5/0x1070
 [<ffffffff8173f61d>] ? __schedule+0x37d/0x940
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811a1330>] ? try_to_merge_with_ksm_page+0x710/0x710
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
khugepaged      S 0000000000000000  6048    83      2 0x00000000
 ffff88009f441c60 0000000000000002 ffff88023e6c8000 ffff88023e6c8000
 00000000001d3fc0 ffff88009f441fd8 00000000001d3fc0 ffff88023e700000
 ffff88023e6c8000 ffff88009f441c90 ffffffff820d2180 00000001000465c6
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff810a4117>] ? prepare_to_wait_event+0x87/0xf0
 [<ffffffff811ae7fe>] khugepaged+0x8fe/0x12a0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811adf00>] ? collect_mm_slot+0x90/0x90
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
fsnotify_mark   S 0000000000000003  6320    84      2 0x00000000
 ffff88023e129dc0 0000000000000002 ffffffff81c72640 ffff880242b82ba0
 00000000001d3fc0 ffff88023e129fd8 00000000001d3fc0 ffff880231db2ba0
 ffff880242b82ba0 ffff88023e129de0 ffff88009ed44c00 ffff88023e129d48
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81205b4a>] fsnotify_mark_destroy+0x11a/0x160
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff81205a30>] ? fsnotify_put_mark+0x40/0x40
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
crypto          S 0000000000000000  6560    85      2 0x00000000
 ffff88023e1b9da8 0000000000000002 ffffffff81744d7c ffff88023e66aba0
 00000000001d3fc0 ffff88023e1b9fd8 00000000001d3fc0 ffff880243298000
 ffff88023e66aba0 ffff88023e66aba0 ffff88023e66aba0 ffff88023e60c790
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kthrotld        S 0000000000000000  6560    93      2 0x00000000
 ffff88023e1d7da8 0000000000000002 ffffffff81744d7c ffff88023e1c95d0
 00000000001d3fc0 ffff88023e1d7fd8 00000000001d3fc0 ffff880243298000
 ffff88023e1c95d0 ffff88023e1c95d0 ffff88023e1c95d0 ffff88023e60cad8
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
scsi_eh_0       S 0000000000000000  6376    94      2 0x00000000
 ffff88023d409db0 0000000000000002 ffff88023e1cd740 ffff88023e1cd740
 00000000001d3fc0 ffff88023d409fd8 00000000001d3fc0 ffff88024376d740
 ffff88023e1cd740 ffff88023ddf0000 0000000000000286 0000000000000000
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff814e0faf>] scsi_error_handler+0x8f/0x7f0
 [<ffffffff814e0f20>] ? scsi_eh_get_sense+0x2a0/0x2a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
scsi_eh_1       S 0000000000000000  3992    95      2 0x00000000
 ffff88023d425db0 0000000000000002 ffff88023e1caba0 ffff88023e1caba0
 00000000001d3fc0 ffff88023d425fd8 00000000001d3fc0 ffffffff81c104c0
 ffff88023e1caba0 ffff88023ddf67b0 0000000000000286 0000000000000000
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff814e0faf>] scsi_error_handler+0x8f/0x7f0
 [<ffffffff814e0f20>] ? scsi_eh_get_sense+0x2a0/0x2a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
scsi_eh_2       S ffff88023e6b0aa0  4640    96      2 0x00000000
 ffff88023d42ddb0 0000000000000002 ffff88023e1c8000 ffff88023e1c8000
 00000000001d3fc0 ffff88023d42dfd8 00000000001d3fc0 ffff8802404995d0
 ffff88023e1c8000 ffff88023ddf1148 0000000000000286 0000000000000000
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff814e0faf>] scsi_error_handler+0x8f/0x7f0
 [<ffffffff814e0f20>] ? scsi_eh_get_sense+0x2a0/0x2a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
scsi_eh_3       S 0000000000000000  6544    97      2 0x00000000
 ffff88023d437db0 0000000000000002 ffff88023e1cc170 ffff88023e1cc170
 00000000001d3fc0 ffff88023d437fd8 00000000001d3fc0 ffffffff81c104c0
 ffff88023e1cc170 ffff88023ddf5668 0000000000000286 0000000000000000
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff814e0faf>] scsi_error_handler+0x8f/0x7f0
 [<ffffffff814e0f20>] ? scsi_eh_get_sense+0x2a0/0x2a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
scsi_eh_4       S 0000000000000000  6544    98      2 0x00000000
 ffff88023d441db0 0000000000000002 ffff88023e668000 ffff88023e668000
 00000000001d3fc0 ffff88023d441fd8 00000000001d3fc0 ffffffff81c104c0
 ffff88023e668000 ffff88023ddf2290 0000000000000286 0000000000000000
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff814e0faf>] scsi_error_handler+0x8f/0x7f0
 [<ffffffff814e0f20>] ? scsi_eh_get_sense+0x2a0/0x2a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
scsi_eh_5       S 0000000000000000  6544    99      2 0x00000000
 ffff88023d44ddb0 0000000000000002 ffff88023e66d740 ffff88023e66d740
 00000000001d3fc0 ffff88023d44dfd8 00000000001d3fc0 ffffffff81c104c0
 ffff88023e66d740 ffff88023ddf4520 0000000000000286 0000000000000000
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff814e0faf>] scsi_error_handler+0x8f/0x7f0
 [<ffffffff814e0f20>] ? scsi_eh_get_sense+0x2a0/0x2a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kpsmoused       S 0000000000000000  6560   105      2 0x00000000
 ffff88023d5d7da8 0000000000000002 ffffffff81744d7c ffff88023e6cc170
 00000000001d3fc0 ffff88023d5d7fd8 00000000001d3fc0 ffff880243298000
 ffff88023e6cc170 ffff88023e6cc170 ffff88023e6cc170 ffff88023deae1d0
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kworker/u8:6    S 0000000000000000  3512   107      2 0x00000000
 ffff88009f4a1dd0 0000000000000002 ffffffff81744d7c ffff88023e6e8000
 00000000001d3fc0 ffff88009f4a1fd8 00000000001d3fc0 ffff8802432995d0
 ffff88023e6e8000 ffff880244441290 ffff8802444412e8 ffff88009f49a588
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076b40>] worker_thread+0x1c0/0x3a0
 [<ffffffff81076980>] ? process_one_work+0x6f0/0x6f0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
deferwq         S 0000000000000000  6560   108      2 0x00000000
 ffff88023d605da8 0000000000000002 ffffffff81744d7c ffff88023e6ec170
 00000000001d3fc0 ffff88023d605fd8 00000000001d3fc0 ffff8802432995d0
 ffff88023e6ec170 ffff88023e6ec170 ffff88023e6ec170 ffff88009f559168
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kworker/0:2     R  running task     4104   112      2 0x00000000
 ffff88023d7e3dd0 0000000000000002 ffffffff81744d7c ffff88023e700000
 00000000001d3fc0 ffff88023d7e3fd8 00000000001d3fc0 ffffffff81c104c0
 ffff88023e700000 ffff8802449d3440 ffff8802449d3498 ffff88023d7bc3c0
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076b40>] worker_thread+0x1c0/0x3a0
 [<ffffffff81076980>] ? process_one_work+0x6f0/0x6f0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kworker/3:2     S ffff88023e6b52a0  4584   168      2 0x00000000
 ffff88023ce4ddd0 0000000000000002 ffffffff81744d7c ffff88009f5d5740
 00000000001d3fc0 ffff88023ce4dfd8 00000000001d3fc0 ffff88009f628000
 ffff88009f5d5740 ffff880244fd3440 ffff880244fd3498 ffff88009ed6bcb0
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076b40>] worker_thread+0x1c0/0x3a0
 [<ffffffff81076980>] ? process_one_work+0x6f0/0x6f0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
jbd2/sda3-8     D 0000000000000001  4064   170      2 0x00000000
 ffff88023e33d4f0 0000000000000002 ffff88023d1595d0 ffff88023d1595d0
 00000000001d3fc0 ffff88023e33dfd8 00000000001d3fc0 ffff88009ecf5740
 ffff88023d1595d0 ffff88023e33d520 ffff8802432d0000 000000010004649a
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119b9f6>] alloc_pages_current+0x106/0x1f0
 [<ffffffff8114e5ff>] ? __page_cache_alloc+0x11f/0x150
 [<ffffffff8114e5ff>] __page_cache_alloc+0x11f/0x150
 [<ffffffff8114f011>] find_or_create_page+0x41/0x90
 [<ffffffff811f4c98>] __getblk+0x108/0x300
 [<ffffffff812a7088>] ? jbd2_journal_bmap+0x28/0xa0
 [<ffffffff812a71cd>] jbd2_journal_get_descriptor_buffer+0x3d/0xb0
 [<ffffffff8129e472>] jbd2_journal_commit_transaction+0xdc2/0x2330
 [<ffffffff81744d22>] ? _raw_spin_unlock_irqrestore+0x42/0x70
 [<ffffffff812a420d>] kjournald2+0x12d/0x3a0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff812a40e0>] ? commit_timeout+0x10/0x10
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
ext4-rsv-conver S 0000000000000000  6560   171      2 0x00000000
 ffff88023d7ffda8 0000000000000002 ffffffff81744d7c ffff88009f62c170
 00000000001d3fc0 ffff88023d7fffd8 00000000001d3fc0 ffffffff81c104c0
 ffff88009f62c170 ffff88009f62c170 ffff88009f62c170 ffff88023d2861d0
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
systemd-journal D 0000000000000001  3960   204      1 0x00000000
 ffff88023d4e7880 0000000000000002 ffff88009f5d4170 ffff88009f5d4170
 00000000001d3fc0 ffff88023d4e7fd8 00000000001d3fc0 ffff88023171aba0
 ffff88009f5d4170 ffff88023d4e78b0 ffff8802432d0000 000000010004649a
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119b9f6>] alloc_pages_current+0x106/0x1f0
 [<ffffffff811543c4>] ? __get_free_pages+0x14/0x50
 [<ffffffff811543c4>] __get_free_pages+0x14/0x50
 [<ffffffff81231307>] proc_info_read+0x47/0x100
 [<ffffffff811b9d08>] vfs_read+0x98/0x170
 [<ffffffff811ba84c>] SyS_read+0x4c/0xa0
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
systemd-udevd   S 0000000000000000  4880   209      1 0x00000000
 ffff88024102fdc0 0000000000000002 00000075dcfcded5 ffff88009ecf0000
 00000000001d3fc0 ffff88024102ffd8 00000000001d3fc0 ffff8802432995d0
 ffff88009ecf0000 0000000000000000 0000000000000000 ffff88023d1d7cb0
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173f12d>] schedule_hrtimeout_range_clock+0x17d/0x1a0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff81744d3d>] ? _raw_spin_unlock_irqrestore+0x5d/0x70
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff8173f163>] schedule_hrtimeout_range+0x13/0x20
 [<ffffffff8120be49>] ep_poll+0x289/0x360
 [<ffffffff810926c0>] ? wake_up_state+0x20/0x20
 [<ffffffff8120d195>] SyS_epoll_wait+0xd5/0x100
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
kworker/1:2     S 0000000000000000  4200   233      2 0x00000000
 ffff88009ee5fdd0 0000000000000002 ffffffff81744d7c ffff88009f6295d0
 00000000001d3fc0 ffff88009ee5ffd8 00000000001d3fc0 ffff88023d1595d0
 ffff88009f6295d0 ffff880244bd3440 ffff880244bd3498 ffff880240df0e70
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076b40>] worker_thread+0x1c0/0x3a0
 [<ffffffff81076980>] ? process_one_work+0x6f0/0x6f0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
hd-audio0       S 0000000000000000  6560   259      2 0x00000000
 ffff88009ee15da8 0000000000000002 ffffffff81744d7c ffff88023e6a15d0
 00000000001d3fc0 ffff88009ee15fd8 00000000001d3fc0 ffffffff81c104c0
 ffff88023e6a15d0 ffff88023e6a15d0 ffff88023e6a15d0 ffff88009ecbf238
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kvm-irqfd-clean S 0000000000000000  6560   260      2 0x00000000
 ffff88009eee1da8 0000000000000002 ffffffff81744d7c ffff88009d900000
 00000000001d3fc0 ffff88009eee1fd8 00000000001d3fc0 ffff88024329d740
 ffff88009d900000 ffff88009d900000 ffff88009d900000 ffff88009ecbdb40
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
hd-audio1       S 0000000000000000  6560   262      2 0x00000000
 ffff88009db3fda8 0000000000000002 ffffffff81744d7c ffff88009d9015d0
 00000000001d3fc0 ffff88009db3ffd8 00000000001d3fc0 ffffffff81c104c0
 ffff88009d9015d0 ffff88009d9015d0 ffff88009d9015d0 ffff88023d12aba8
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kworker/2:3     S 0000000000000000  5240   295      2 0x00000000
 ffff88009b8f9dd0 0000000000000002 ffffffff81744d7c ffff8802416dd740
 00000000001d3fc0 ffff88009b8f9fd8 00000000001d3fc0 ffff88023e704170
 ffff8802416dd740 ffff880244dd3440 ffff880244dd3498 ffff88023d260750
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076b40>] worker_thread+0x1c0/0x3a0
 [<ffffffff81076980>] ? process_one_work+0x6f0/0x6f0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
jbd2/sda1-8     S 0000000000000000  6304   296      2 0x00000000
 ffff88009b91bdb0 0000000000000006 ffff88009b91bd70 ffff8802416d8000
 00000000001d3fc0 ffff88009b91bfd8 00000000001d3fc0 ffff8802416daba0
 ffff8802416d8000 ffff88023d783400 ffff88023d783a80 ffff88023d7835c0
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff812a43d3>] kjournald2+0x2f3/0x3a0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff812a40e0>] ? commit_timeout+0x10/0x10
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
ext4-rsv-conver S 0000000000000000  6560   297      2 0x00000000
 ffff88009b91dda8 0000000000000002 ffffffff81744d7c ffff8802416daba0
 00000000001d3fc0 ffff88009b91dfd8 00000000001d3fc0 ffff8802432995d0
 ffff8802416daba0 ffff8802416daba0 ffff8802416daba0 ffff88009f67a1d0
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
xfsalloc        S 0000000000000000  6560   299      2 0x00000000
 ffff88009db09da8 0000000000000002 ffffffff81744d7c ffff88024049aba0
 00000000001d3fc0 ffff88009db09fd8 00000000001d3fc0 ffffffff81c104c0
 ffff88024049aba0 ffff88024049aba0 ffff88024049aba0 ffff88009f6797f8
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
xfs_mru_cache   S 0000000000000000  6560   300      2 0x00000000
 ffff88009db17da8 0000000000000002 ffffffff81744d7c ffff880240498000
 00000000001d3fc0 ffff88009db17fd8 00000000001d3fc0 ffff88024329d740
 ffff880240498000 ffff880240498000 ffff880240498000 ffff88009f6794b0
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
xfslogd         S 0000000000000000  6560   301      2 0x00000000
 ffff88009d871da8 0000000000000002 ffffffff81744d7c ffff8802404995d0
 00000000001d3fc0 ffff88009d871fd8 00000000001d3fc0 ffff88024329d740
 ffff8802404995d0 ffff8802404995d0 ffff8802404995d0 ffff88009f679168
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
xfs-data/sda5   S 0000000000000000  6560   302      2 0x00000000
 ffff88009d873da8 0000000000000002 ffffffff81744d7c ffff88024049c170
 00000000001d3fc0 ffff88009d873fd8 00000000001d3fc0 ffff88024329d740
 ffff88024049c170 ffff88024049c170 ffff88024049c170 ffff88009f679e88
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
xfs-conv/sda5   S 0000000000000000  6560   303      2 0x00000000
 ffff88009bea5da8 0000000000000002 ffffffff81744d7c ffff88024049d740
 00000000001d3fc0 ffff88009bea5fd8 00000000001d3fc0 ffff88024329d740
 ffff88024049d740 ffff88024049d740 ffff88024049d740 ffff88009f67a860
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
xfs-cil/sda5    S 0000000000000000  6560   304      2 0x00000000
 ffff88009bea7da8 0000000000000002 ffffffff81744d7c ffff88009d904170
 00000000001d3fc0 ffff88009bea7fd8 00000000001d3fc0 ffff88024329d740
 ffff88009d904170 ffff88009d904170 ffff88009d904170 ffff88009f67a518
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kworker/0:1H    S 0000000000000000  5640   305      2 0x00000000
 ffff88009ef75dd0 0000000000000002 ffffffff81744d7c ffff88009d905740
 00000000001d3fc0 ffff88009ef75fd8 00000000001d3fc0 ffffffff81c104c0
 ffff88009d905740 ffff8802449d3a00 ffff8802449d3a58 ffff8802412c5590
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076b40>] worker_thread+0x1c0/0x3a0
 [<ffffffff81076980>] ? process_one_work+0x6f0/0x6f0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
xfsaild/sda5    S 0000000000000000  4672   306      2 0x00000000
 ffff88009ef77d60 0000000000000002 ffff88009ef77d20 ffff88009d902ba0
 00000000001d3fc0 ffff88009ef77fd8 00000000001d3fc0 ffff880243298000
 ffff88009d902ba0 0000000000000000 0000000000000001 ffffffffa02c96b0
Call Trace:
 [<ffffffffa02c96b0>] ? xfs_trans_ail_cursor_first+0xb0/0xb0 [xfs]
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffffa02c9d57>] xfsaild+0x6a7/0x9d0 [xfs]
 [<ffffffffa02c96b0>] ? xfs_trans_ail_cursor_first+0xb0/0xb0 [xfs]
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
rsyslogd        S ffff88023e6b3aa0  5088   312      1 0x00000000
 ffff88009d8618f8 0000000000000006 ffffffff81083903 ffff88009f5d15d0
 00000000001d3fc0 ffff88009d861fd8 00000000001d3fc0 ffff88009d878000
 ffff88009f5d15d0 ffff88009d861ad8 0000000005f5e100 0000000000000000
Call Trace:
 [<ffffffff81083903>] ? __hrtimer_start_range_ns+0x1b3/0x4d0
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173f10c>] schedule_hrtimeout_range_clock+0x15c/0x1a0
 [<ffffffff81082b00>] ? hrtimer_get_res+0x50/0x50
 [<ffffffff8173f078>] ? schedule_hrtimeout_range_clock+0xc8/0x1a0
 [<ffffffff8173f163>] schedule_hrtimeout_range+0x13/0x20
 [<ffffffff811cf719>] poll_schedule_timeout+0x49/0x70
 [<ffffffff811d01c9>] do_select+0x659/0x950
 [<ffffffff811cfb75>] ? do_select+0x5/0x950
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810ad505>] ? __lock_acquire+0x2e5/0x19f0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810ad505>] ? __lock_acquire+0x2e5/0x19f0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff811d0740>] core_sys_select+0x280/0x4d0
 [<ffffffff811d04f9>] ? core_sys_select+0x39/0x4d0
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810d15c9>] ? ktime_get_ts+0x79/0x160
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810acf3d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff810d15f5>] ? ktime_get_ts+0xa5/0x160
 [<ffffffff811cfb3c>] ? poll_select_set_timeout+0x5c/0x90
 [<ffffffff811d0a40>] SyS_select+0xb0/0x100
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
in:imuxsock     S 0000000000000000  5104   314      1 0x00000000
 ffff88009ef898f8 0000000000000002 0000000000000282 ffff8802416dc170
 00000000001d3fc0 ffff88009ef89fd8 00000000001d3fc0 ffff8802432995d0
 ffff8802416dc170 0000000000000000 0000000000000040 0000000000000010
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173f12d>] schedule_hrtimeout_range_clock+0x17d/0x1a0
 [<ffffffff811cf65f>] ? __pollwait+0x7f/0xf0
 [<ffffffff816cdc8c>] ? unix_dgram_poll+0x5c/0x240
 [<ffffffff8173f163>] schedule_hrtimeout_range+0x13/0x20
 [<ffffffff811cf719>] poll_schedule_timeout+0x49/0x70
 [<ffffffff811d01c9>] do_select+0x659/0x950
 [<ffffffff811cfb75>] ? do_select+0x5/0x950
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810acf3d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff810af7f8>] ? lock_release_non_nested+0x308/0x350
 [<ffffffff81177bdf>] ? might_fault+0x5f/0xb0
 [<ffffffff811d0740>] core_sys_select+0x280/0x4d0
 [<ffffffff811d04f9>] ? core_sys_select+0x39/0x4d0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff8114d71e>] ? context_tracking_user_exit+0x4e/0x190
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff811d0a40>] SyS_select+0xb0/0x100
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
in:imklog       S 0000000000000000  6088   315      1 0x00000000
 ffff88009d867e38 0000000000000002 ffffffff81c47ea0 ffff88009ed02ba0
 00000000001d3fc0 ffff88009d867fd8 00000000001d3fc0 ffff880243298000
 ffff88009ed02ba0 0000000000000000 0000000000000002 0000000000000001
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810b7a42>] do_syslog+0x492/0x520
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff8123fbf7>] kmsg_read+0x47/0x60
 [<ffffffff8122ef7d>] proc_reg_read+0x3d/0x80
 [<ffffffff811b9d08>] vfs_read+0x98/0x170
 [<ffffffff811ba84c>] SyS_read+0x4c/0xa0
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
rs:main Q:Reg   S 0000000000000000  4384   316      1 0x00000000
 ffff88009b8cdca0 0000000000000002 ffff88009b8cdc60 ffff88009d878000
 00000000001d3fc0 ffff88009b8cdfd8 00000000001d3fc0 ffff88024329d740
 ffff88009d878000 ffff88009d878000 0000000000000000 ffff88009d878000
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810dca2d>] futex_wait_queue_me+0xdd/0x170
 [<ffffffff810dd6f2>] futex_wait+0x182/0x2a0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810df415>] do_futex+0xe5/0xc80
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff8114d71e>] ? context_tracking_user_exit+0x4e/0x190
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810e0021>] SyS_futex+0x71/0x150
 [<ffffffff81010a25>] ? syscall_trace_enter+0x145/0x2a0
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
NetworkManager  S 0000000000000000  3656   317      1 0x00000000
 ffff88009d865a48 0000000000000002 ffffffff81083903 ffff88009ed015d0
 00000000001d3fc0 ffff88009d865fd8 00000000001d3fc0 ffffffff81c104c0
 ffff88009ed015d0 ffff88009d865b98 0000000004f60ccf 0000000000000000
Call Trace:
 [<ffffffff81083903>] ? __hrtimer_start_range_ns+0x1b3/0x4d0
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173f10c>] schedule_hrtimeout_range_clock+0x15c/0x1a0
 [<ffffffff81082b00>] ? hrtimer_get_res+0x50/0x50
 [<ffffffff8173f078>] ? schedule_hrtimeout_range_clock+0xc8/0x1a0
 [<ffffffff8173f163>] schedule_hrtimeout_range+0x13/0x20
 [<ffffffff811cf719>] poll_schedule_timeout+0x49/0x70
 [<ffffffff811d10f9>] do_sys_poll+0x429/0x560
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff810af7f8>] ? lock_release_non_nested+0x308/0x350
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff810d15c9>] ? ktime_get_ts+0x79/0x160
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810acf3d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff810d15f5>] ? ktime_get_ts+0xa5/0x160
 [<ffffffff811cfb3c>] ? poll_select_set_timeout+0x5c/0x90
 [<ffffffff811d1305>] SyS_poll+0x65/0x100
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
NetworkManager  S 0000000000000003  6592   324      1 0x00000000
 ffff880240473d70 0000000000000002 ffff880240473dd0 ffff88009ecf2ba0
 00000000001d3fc0 ffff880240473fd8 00000000001d3fc0 ffff88009f628000
 ffff88009ecf2ba0 ffff88009ecf2ba0 7fffffffffffffff ffff880240473ed0
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eba9>] schedule_timeout+0x1b9/0x340
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff8173ed4e>] schedule_timeout_interruptible+0x1e/0x20
 [<ffffffff8106b62f>] do_sigtimedwait+0x16f/0x240
 [<ffffffff8106b789>] SYSC_rt_sigtimedwait+0x89/0xf0
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810acf3d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81010a25>] ? syscall_trace_enter+0x145/0x2a0
 [<ffffffff8106b7fe>] SyS_rt_sigtimedwait+0xe/0x10
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
gdbus           S 0000000000000000  5696   334      1 0x00000000
 ffff88009ef53a48 0000000000000002 0000000000000002 ffff88009da695d0
 00000000001d3fc0 ffff88009ef53fd8 00000000001d3fc0 ffff8802432995d0
 ffff88009da695d0 0000000000000000 0000000000000000 ffff88009ef53bc4
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173f12d>] schedule_hrtimeout_range_clock+0x17d/0x1a0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff81744d3d>] ? _raw_spin_unlock_irqrestore+0x5d/0x70
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff8173f163>] schedule_hrtimeout_range+0x13/0x20
 [<ffffffff811cf719>] poll_schedule_timeout+0x49/0x70
 [<ffffffff811d10f9>] do_sys_poll+0x429/0x560
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff81744c81>] ? _raw_spin_unlock+0x31/0x50
 [<ffffffff811a61b4>] ? deactivate_slab+0x614/0x6d0
 [<ffffffff811bbd61>] ? get_empty_filp+0x61/0x240
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff8114d71e>] ? context_tracking_user_exit+0x4e/0x190
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810acf3d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff811d1305>] SyS_poll+0x65/0x100
 [<ffffffff8174de45>] ? tracesys+0x7e/0xe2
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
gmain           S ffff88023e6b22a0  5776   356      1 0x00000000
 ffff88009f5b9a48 0000000000000002 0000000000000002 ffff880240d72ba0
 00000000001d3fc0 ffff88009f5b9fd8 00000000001d3fc0 ffff88009ed015d0
 ffff880240d72ba0 0000000000000000 0000000000000000 ffff88009f5b9bb4
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173f12d>] schedule_hrtimeout_range_clock+0x17d/0x1a0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff81744d3d>] ? _raw_spin_unlock_irqrestore+0x5d/0x70
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff8173f163>] schedule_hrtimeout_range+0x13/0x20
 [<ffffffff811cf719>] poll_schedule_timeout+0x49/0x70
 [<ffffffff811d10f9>] do_sys_poll+0x429/0x560
 [<ffffffff81159146>] ? __alloc_pages_nodemask+0x196/0xb50
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff810ad505>] ? __lock_acquire+0x2e5/0x19f0
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff8114d71e>] ? context_tracking_user_exit+0x4e/0x190
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810acf3d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff811d1305>] SyS_poll+0x65/0x100
 [<ffffffff8174de45>] ? tracesys+0x7e/0xe2
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
chronyd         S 0000000000000000  4368   320      1 0x00000000
 ffff88009d8d38f8 0000000000000002 ffffffff81083903 ffff88009d87c170
 00000000001d3fc0 ffff88009d8d3fd8 00000000001d3fc0 ffffffff81c104c0
 ffff88009d87c170 ffff88009d8d3ad8 0000000005f5e100 0000000000000000
Call Trace:
 [<ffffffff81083903>] ? __hrtimer_start_range_ns+0x1b3/0x4d0
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173f10c>] schedule_hrtimeout_range_clock+0x15c/0x1a0
 [<ffffffff81082b00>] ? hrtimer_get_res+0x50/0x50
 [<ffffffff8173f078>] ? schedule_hrtimeout_range_clock+0xc8/0x1a0
 [<ffffffff8173f163>] schedule_hrtimeout_range+0x13/0x20
 [<ffffffff811cf719>] poll_schedule_timeout+0x49/0x70
 [<ffffffff811d01c9>] do_select+0x659/0x950
 [<ffffffff811cfb75>] ? do_select+0x5/0x950
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff810af7f8>] ? lock_release_non_nested+0x308/0x350
 [<ffffffff81177bdf>] ? might_fault+0x5f/0xb0
 [<ffffffff811d0740>] core_sys_select+0x280/0x4d0
 [<ffffffff811d04f9>] ? core_sys_select+0x39/0x4d0
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810d15c9>] ? ktime_get_ts+0x79/0x160
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810acf3d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff810d15f5>] ? ktime_get_ts+0xa5/0x160
 [<ffffffff811cfb3c>] ? poll_select_set_timeout+0x5c/0x90
 [<ffffffff811d0a40>] SyS_select+0xb0/0x100
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
smartd          S 0000000000000000  5024   321      1 0x00000000
 ffff88009d8dfe50 0000000000000002 ffffffff81083903 ffff88009d87aba0
 00000000001d3fc0 ffff88009d8dffd8 00000000001d3fc0 ffffffff81c104c0
 ffff88009d87aba0 ffff88009d8dfeb0 ffff88009d87aba0 ffff88009d87aba0
Call Trace:
 [<ffffffff81083903>] ? __hrtimer_start_range_ns+0x1b3/0x4d0
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173ee65>] do_nanosleep+0xd5/0x160
 [<ffffffff810846ab>] hrtimer_nanosleep+0xcb/0x1a0
 [<ffffffff81082b00>] ? hrtimer_get_res+0x50/0x50
 [<ffffffff8173ee01>] ? do_nanosleep+0x71/0x160
 [<ffffffff810847ee>] SyS_nanosleep+0x6e/0x90
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
systemd-logind  S 0000000000000000  4784   322      1 0x00000000
 ffff880240d67dc0 0000000000000002 000002e123d9556c ffff88009f628000
 00000000001d3fc0 ffff880240d67fd8 00000000001d3fc0 ffff8802432995d0
 ffff88009f628000 0000000000000000 0000000000000000 ffff8802404a32d8
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173f12d>] schedule_hrtimeout_range_clock+0x17d/0x1a0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff81744d3d>] ? _raw_spin_unlock_irqrestore+0x5d/0x70
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff8173f163>] schedule_hrtimeout_range+0x13/0x20
 [<ffffffff8120be49>] ep_poll+0x289/0x360
 [<ffffffff810926c0>] ? wake_up_state+0x20/0x20
 [<ffffffff8120d195>] SyS_epoll_wait+0xd5/0x100
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
avahi-daemon    S 0000000000000000  4760   323      1 0x00000000
 ffff880240471a48 0000000000000002 ffffffff81083903 ffff88009ecf4170
 00000000001d3fc0 ffff880240471fd8 00000000001d3fc0 ffffffff81c104c0
 ffff88009ecf4170 ffff880240471b98 0000000005bbd59f 0000000000000000
Call Trace:
 [<ffffffff81083903>] ? __hrtimer_start_range_ns+0x1b3/0x4d0
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173f10c>] schedule_hrtimeout_range_clock+0x15c/0x1a0
 [<ffffffff81082b00>] ? hrtimer_get_res+0x50/0x50
 [<ffffffff8173f078>] ? schedule_hrtimeout_range_clock+0xc8/0x1a0
 [<ffffffff8173f163>] schedule_hrtimeout_range+0x13/0x20
 [<ffffffff811cf719>] poll_schedule_timeout+0x49/0x70
 [<ffffffff811d10f9>] do_sys_poll+0x429/0x560
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff810acf3d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff810d15f5>] ? ktime_get_ts+0xa5/0x160
 [<ffffffff811cfb3c>] ? poll_select_set_timeout+0x5c/0x90
 [<ffffffff811d1305>] SyS_poll+0x65/0x100
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
dbus-daemon     S 0000000000000000  4760   326      1 0x00000000
 ffff8802380a9dc0 0000000000000002 000002e123d8332a ffff880238080000
 00000000001d3fc0 ffff8802380a9fd8 00000000001d3fc0 ffff88024329d740
 ffff880238080000 0000000000000000 0000000000000000 ffff8802417b9f28
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173f12d>] schedule_hrtimeout_range_clock+0x17d/0x1a0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff81744d3d>] ? _raw_spin_unlock_irqrestore+0x5d/0x70
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff8173f163>] schedule_hrtimeout_range+0x13/0x20
 [<ffffffff8120be49>] ep_poll+0x289/0x360
 [<ffffffff810926c0>] ? wake_up_state+0x20/0x20
 [<ffffffff8120d195>] SyS_epoll_wait+0xd5/0x100
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
avahi-daemon    S 0000000000000000  5696   327    323 0x00000000
 ffff880236563bc0 0000000000000002 ffffffff815fc00d ffff880238085740
 00000000001d3fc0 ffff880236563fd8 00000000001d3fc0 ffff880243298000
 ffff880238085740 ffff880240453480 ffff880238085740 7fffffffffffffff
Call Trace:
 [<ffffffff815fc00d>] ? __scm_destroy+0x4d/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eba9>] schedule_timeout+0x1b9/0x340
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff816ce48c>] unix_stream_recvmsg+0x32c/0x920
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff815e9b51>] sock_aio_read.part.9+0x101/0x120
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff815e9b91>] sock_aio_read+0x21/0x40
 [<ffffffff811b964a>] do_sync_read+0x5a/0x90
 [<ffffffff811b9db5>] vfs_read+0x145/0x170
 [<ffffffff811ba84c>] SyS_read+0x4c/0xa0
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
crond           D 0000000000000001  4224   333      1 0x00000000
 ffff88009da5b4d0 0000000000000002 ffff88009da68000 ffff88009da68000
 00000000001d3fc0 ffff88009da5bfd8 00000000001d3fc0 ffff88009f5d4170
 ffff88009da68000 ffff88009da5b500 ffff8802432d0000 00000001000464c2
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119d681>] alloc_pages_vma+0xf1/0x1b0
 [<ffffffff8117c752>] ? handle_mm_fault+0x982/0xbb0
 [<ffffffff8117c752>] handle_mm_fault+0x982/0xbb0
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81748ddf>] __do_page_fault+0x16f/0x610
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8174929a>] do_page_fault+0x1a/0x70
 [<ffffffff81745cd2>] page_fault+0x22/0x30
 [<ffffffff8115100f>] ? file_read_actor+0x3f/0x1c0
 [<ffffffff8114ee0c>] ? find_get_page+0x11c/0x260
 [<ffffffff8115148e>] generic_file_aio_read+0x2fe/0x750
 [<ffffffff811b964a>] do_sync_read+0x5a/0x90
 [<ffffffff811b9d08>] vfs_read+0x98/0x170
 [<ffffffff811ba84c>] SyS_read+0x4c/0xa0
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
login           S 0000000000000000  3920   335      1 0x00000000
 ffff88009be83e78 0000000000000002 ffff88009be83e38 ffff88009da6c170
 00000000001d3fc0 ffff88009be83fd8 00000000001d3fc0 ffff8802416dd740
 ffff88009da6c170 ffff88009be83f00 ffff88009da6c3f0 ffff88009da6c170
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810575e1>] do_wait+0x201/0x340
 [<ffffffff81057ae4>] SyS_wait4+0x64/0xe0
 [<ffffffff81054cd0>] ? task_stopped_code+0x60/0x60
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
polkitd         S ffff88023e6b10a0  5008   336      1 0x00000000
 ffff880241153a48 0000000000000002 0000000000000002 ffff88009da6d740
 00000000001d3fc0 ffff880241153fd8 00000000001d3fc0 ffff88009da6aba0
 ffff88009da6d740 0000000000000000 0000000000000000 ffff880241153bc4
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173f12d>] schedule_hrtimeout_range_clock+0x17d/0x1a0
 [<ffffffff817424cd>] ? __mutex_unlock_slowpath+0xdd/0x190
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810acf3d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8173f163>] schedule_hrtimeout_range+0x13/0x20
 [<ffffffff811cf719>] poll_schedule_timeout+0x49/0x70
 [<ffffffff811d10f9>] do_sys_poll+0x429/0x560
 [<ffffffff8100640f>] ? print_context_stack+0x8f/0x100
 [<ffffffff81005189>] ? dump_trace+0x189/0x2e0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff8114d71e>] ? context_tracking_user_exit+0x4e/0x190
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810acf3d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff811d1305>] SyS_poll+0x65/0x100
 [<ffffffff8174de45>] ? tracesys+0x7e/0xe2
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
gdbus           S 0000000000000000  5424   337      1 0x00000000
 ffff8802413a3a48 0000000000000002 0000000000000002 ffff88009da6aba0
 00000000001d3fc0 ffff8802413a3fd8 00000000001d3fc0 ffff8802432995d0
 ffff88009da6aba0 0000000000000000 0000000000000000 ffff8802413a3bc4
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173f12d>] schedule_hrtimeout_range_clock+0x17d/0x1a0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff81744d3d>] ? _raw_spin_unlock_irqrestore+0x5d/0x70
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff8173f163>] schedule_hrtimeout_range+0x13/0x20
 [<ffffffff811cf719>] poll_schedule_timeout+0x49/0x70
 [<ffffffff811d10f9>] do_sys_poll+0x429/0x560
 [<ffffffff815ef5b5>] ? sock_def_readable+0x5/0x1e0
 [<ffffffff815ea6cb>] ? sock_sendmsg+0x8b/0xc0
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff8114d71e>] ? context_tracking_user_exit+0x4e/0x190
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810acf3d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff811d1305>] SyS_poll+0x65/0x100
 [<ffffffff8174de45>] ? tracesys+0x7e/0xe2
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
JS GC Helper    S 0000000000000000  6368   338      1 0x00000000
 ffff880241155ca0 0000000000000002 ffff880241155c60 ffff88023d158000
 00000000001d3fc0 ffff880241155fd8 00000000001d3fc0 ffff8802432995d0
 ffff88023d158000 ffff88023d158000 0000000000000000 ffff88023d158000
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810dca2d>] futex_wait_queue_me+0xdd/0x170
 [<ffffffff810dd6f2>] futex_wait+0x182/0x2a0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810df415>] do_futex+0xe5/0xc80
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff8114d71e>] ? context_tracking_user_exit+0x4e/0x190
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810e0021>] SyS_futex+0x71/0x150
 [<ffffffff81010a25>] ? syscall_trace_enter+0x145/0x2a0
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
JS Sour~ Thread S ffff88023e6b10a0  6368   339      1 0x00000000
 ffff880241249ca0 0000000000000002 ffff880241249c60 ffff88009d8795d0
 00000000001d3fc0 ffff880241249fd8 00000000001d3fc0 ffff88009da6d740
 ffff88009d8795d0 ffff88009d8795d0 0000000000000000 ffff88009d8795d0
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810dca2d>] futex_wait_queue_me+0xdd/0x170
 [<ffffffff810dd6f2>] futex_wait+0x182/0x2a0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810df415>] do_futex+0xe5/0xc80
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff8114d71e>] ? context_tracking_user_exit+0x4e/0x190
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810e0021>] SyS_futex+0x71/0x150
 [<ffffffff81010a25>] ? syscall_trace_enter+0x145/0x2a0
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
runaway-killer- S 0000000000000000  5776   340      1 0x00000000
 ffff88009ef4da48 0000000000000002 0000000000000002 ffff88009ed04170
 00000000001d3fc0 ffff88009ef4dfd8 00000000001d3fc0 ffff880243298000
 ffff88009ed04170 0000000000000000 0000000000000000 ffff88009ef4dbb4
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173f12d>] schedule_hrtimeout_range_clock+0x17d/0x1a0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff81744d3d>] ? _raw_spin_unlock_irqrestore+0x5d/0x70
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff8173f163>] schedule_hrtimeout_range+0x13/0x20
 [<ffffffff811cf719>] poll_schedule_timeout+0x49/0x70
 [<ffffffff811d10f9>] do_sys_poll+0x429/0x560
 [<ffffffff810ad505>] ? __lock_acquire+0x2e5/0x19f0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff81334b4e>] ? __list_add+0x1e/0x70
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff810ad505>] ? __lock_acquire+0x2e5/0x19f0
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff8114d71e>] ? context_tracking_user_exit+0x4e/0x190
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810acf3d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff811d1305>] SyS_poll+0x65/0x100
 [<ffffffff8174de45>] ? tracesys+0x7e/0xe2
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
gmain           S 0000000000000000  5776   341      1 0x00000000
 ffff88009da73a48 0000000000000002 0000000000000002 ffff8802416d95d0
 00000000001d3fc0 ffff88009da73fd8 00000000001d3fc0 ffff88024329d740
 ffff8802416d95d0 0000000000000000 0000000000000000 ffff88009da73bb4
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173f12d>] schedule_hrtimeout_range_clock+0x17d/0x1a0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff81744d3d>] ? _raw_spin_unlock_irqrestore+0x5d/0x70
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff8173f163>] schedule_hrtimeout_range+0x13/0x20
 [<ffffffff811cf719>] poll_schedule_timeout+0x49/0x70
 [<ffffffff811d10f9>] do_sys_poll+0x429/0x560
 [<ffffffff81159146>] ? __alloc_pages_nodemask+0x196/0xb50
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff810ad505>] ? __lock_acquire+0x2e5/0x19f0
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff8114d71e>] ? context_tracking_user_exit+0x4e/0x190
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810acf3d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff811d1305>] SyS_poll+0x65/0x100
 [<ffffffff8174de45>] ? tracesys+0x7e/0xe2
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
rpcbind         S 0000000000000000  5376   347      1 0x00000000
 ffff88024168da48 0000000000000002 ffffffff81083903 ffff880240d05740
 00000000001d3fc0 ffff88024168dfd8 00000000001d3fc0 ffff88023e700000
 ffff880240d05740 ffff88024168db98 0000000001c9c37f 0000000000000000
Call Trace:
 [<ffffffff81083903>] ? __hrtimer_start_range_ns+0x1b3/0x4d0
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173f10c>] schedule_hrtimeout_range_clock+0x15c/0x1a0
 [<ffffffff81082b00>] ? hrtimer_get_res+0x50/0x50
 [<ffffffff8173f078>] ? schedule_hrtimeout_range_clock+0xc8/0x1a0
 [<ffffffff8173f163>] schedule_hrtimeout_range+0x13/0x20
 [<ffffffff811cf719>] poll_schedule_timeout+0x49/0x70
 [<ffffffff811d10f9>] do_sys_poll+0x429/0x560
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff810d15c9>] ? ktime_get_ts+0x79/0x160
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810acf3d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff810d15f5>] ? ktime_get_ts+0xa5/0x160
 [<ffffffff811cfb3c>] ? poll_select_set_timeout+0x5c/0x90
 [<ffffffff811d1305>] SyS_poll+0x65/0x100
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
sshd            S 0000000000000000  4912   350      1 0x00000000
 ffff880240d0f8f8 0000000000000002 ffff880240d04170 ffff880240d04170
 00000000001d3fc0 ffff880240d0ffd8 00000000001d3fc0 ffffffff81c104c0
 ffff880240d04170 0000000000000000 0000000000000040 0000000000000020
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173f12d>] schedule_hrtimeout_range_clock+0x17d/0x1a0
 [<ffffffff811cf65f>] ? __pollwait+0x7f/0xf0
 [<ffffffff8165b916>] ? tcp_poll+0x116/0x430
 [<ffffffff8165b805>] ? tcp_poll+0x5/0x430
 [<ffffffff8173f163>] schedule_hrtimeout_range+0x13/0x20
 [<ffffffff811cf719>] poll_schedule_timeout+0x49/0x70
 [<ffffffff811d01c9>] do_select+0x659/0x950
 [<ffffffff811cfb75>] ? do_select+0x5/0x950
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff810e8a9f>] ? is_module_text_address+0x2f/0x50
 [<ffffffff8107bf58>] ? __kernel_text_address+0x58/0x80
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff810af7f8>] ? lock_release_non_nested+0x308/0x350
 [<ffffffff81177bdf>] ? might_fault+0x5f/0xb0
 [<ffffffff811d0740>] core_sys_select+0x280/0x4d0
 [<ffffffff811d04f9>] ? core_sys_select+0x39/0x4d0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff8114d71e>] ? context_tracking_user_exit+0x4e/0x190
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff811d0a40>] SyS_select+0xb0/0x100
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
dhclient        S 0000000000000000  5328   355    317 0x00000000
 ffff88009ec158f8 0000000000000002 ffffffff81083903 ffff880240d74170
 00000000001d3fc0 ffff88009ec15fd8 00000000001d3fc0 ffff880243298000
 ffff880240d74170 ffff88009ec15ad8 0000000005f5e100 0000000000000000
Call Trace:
 [<ffffffff81083903>] ? __hrtimer_start_range_ns+0x1b3/0x4d0
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173f10c>] schedule_hrtimeout_range_clock+0x15c/0x1a0
 [<ffffffff81082b00>] ? hrtimer_get_res+0x50/0x50
 [<ffffffff8173f078>] ? schedule_hrtimeout_range_clock+0xc8/0x1a0
 [<ffffffff8173f163>] schedule_hrtimeout_range+0x13/0x20
 [<ffffffff811cf719>] poll_schedule_timeout+0x49/0x70
 [<ffffffff811d01c9>] do_select+0x659/0x950
 [<ffffffff811cfb75>] ? do_select+0x5/0x950
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff810af7f8>] ? lock_release_non_nested+0x308/0x350
 [<ffffffff81177bdf>] ? might_fault+0x5f/0xb0
 [<ffffffff811d0740>] core_sys_select+0x280/0x4d0
 [<ffffffff811d04f9>] ? core_sys_select+0x39/0x4d0
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810d15c9>] ? ktime_get_ts+0x79/0x160
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810acf3d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff810d15f5>] ? ktime_get_ts+0xa5/0x160
 [<ffffffff811cfb3c>] ? poll_select_set_timeout+0x5c/0x90
 [<ffffffff811d0a40>] SyS_select+0xb0/0x100
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
sshd            S 0000000000000000  4128   445    350 0x00000000
 ffff88009bf41a48 0000000000000002 ffffffff81744d3d ffff88023d15aba0
 00000000001d3fc0 ffff88009bf41fd8 00000000001d3fc0 ffff8802317195d0
 ffff88023d15aba0 0000000000000000 0000000000000000 ffff88009bf41bb4
Call Trace:
 [<ffffffff81744d3d>] ? _raw_spin_unlock_irqrestore+0x5d/0x70
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173f12d>] schedule_hrtimeout_range_clock+0x17d/0x1a0
 [<ffffffff810a3dbc>] ? add_wait_queue+0x3c/0x50
 [<ffffffff811cf65f>] ? __pollwait+0x7f/0xf0
 [<ffffffff816cd1b5>] ? unix_poll+0x55/0x130
 [<ffffffff8173f163>] schedule_hrtimeout_range+0x13/0x20
 [<ffffffff811cf719>] poll_schedule_timeout+0x49/0x70
 [<ffffffff811d10f9>] do_sys_poll+0x429/0x560
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff811cf8c0>] ? poll_select_copy_remaining+0x130/0x130
 [<ffffffff810ad505>] ? __lock_acquire+0x2e5/0x19f0
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff8114d71e>] ? context_tracking_user_exit+0x4e/0x190
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810acf3d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff811d1305>] SyS_poll+0x65/0x100
 [<ffffffff8174de45>] ? tracesys+0x7e/0xe2
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
sshd            D 0000000000000003  4216   467    445 0x00000000
 ffff88023cf93590 0000000000000002 ffff88009ecf5740 ffff88009ecf5740
 00000000001d3fc0 ffff88023cf93fd8 00000000001d3fc0 ffff880240d75740
 ffff88009ecf5740 ffff88023cf935c0 ffff880243374000 00000001000464d6
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119b9f6>] alloc_pages_current+0x106/0x1f0
 [<ffffffff8103e297>] ? pte_alloc_one+0x17/0x70
 [<ffffffff8103e297>] pte_alloc_one+0x17/0x70
 [<ffffffff81178957>] __pte_alloc+0x27/0x130
 [<ffffffff8117a29f>] copy_pte_range+0x40f/0x560
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8117b7a4>] copy_page_range+0x2e4/0x460
 [<ffffffff810515f9>] dup_mm+0x2e9/0x510
 [<ffffffff81052cfd>] copy_process.part.28+0x14ad/0x17f0
 [<ffffffff810531ee>] do_fork+0xce/0x450
 [<ffffffff8114d71e>] ? context_tracking_user_exit+0x4e/0x190
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810acf3d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff810535f6>] SyS_clone+0x16/0x20
 [<ffffffff8174e039>] stub_clone+0x69/0x90
 [<ffffffff8174dea4>] ? tracesys+0xdd/0xe2
bash            S 0000000000000000  3704   480    467 0x00000000
 ffff88023d27be78 0000000000000002 ffff88023d27be38 ffff88023e6a5740
 00000000001d3fc0 ffff88023d27bfd8 00000000001d3fc0 ffff880243298000
 ffff88023e6a5740 ffff88023d27bf00 ffff88023e6a59c0 ffff88023e6a5740
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810575e1>] do_wait+0x201/0x340
 [<ffffffff81057ae4>] SyS_wait4+0x64/0xe0
 [<ffffffff81054cd0>] ? task_stopped_code+0x60/0x60
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
ten.sh          S 0000000000000003  4432   542    480 0x00000000
 ffff88023d0b3e78 0000000000000002 ffff88023d0b3e38 ffff88023d15c170
 00000000001d3fc0 ffff88023d0b3fd8 00000000001d3fc0 ffff88023e6e95d0
 ffff88023d15c170 ffff88023d0b3f00 ffff88023d15c3f0 ffff88023d15c170
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810575e1>] do_wait+0x201/0x340
 [<ffffffff81057ae4>] SyS_wait4+0x64/0xe0
 [<ffffffff81054cd0>] ? task_stopped_code+0x60/0x60
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
krdsd           S 0000000000000000  6560   607      2 0x00000000
 ffff880236457da8 0000000000000002 ffffffff81744d7c ffff88009ed88000
 00000000001d3fc0 ffff880236457fd8 00000000001d3fc0 ffff8802432995d0
 ffff88009ed88000 ffff88009ed88000 ffff88009ed88000 ffff8802417ba518
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
iscsi_eh        S 0000000000000000  6560  7753      2 0x00000000
 ffff8801fd4edda8 0000000000000002 ffffffff81744d7c ffff88023ce52ba0
 00000000001d3fc0 ffff8801fd4edfd8 00000000001d3fc0 ffffffff81c104c0
 ffff88023ce52ba0 ffff88023ce52ba0 ffff88023ce52ba0 ffff88023d0a1e88
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076f8a>] rescuer_thread+0x26a/0x350
 [<ffffffff81076d20>] ? worker_thread+0x3a0/0x3a0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kworker/1:1     S 0000000000000000  6544 14519      2 0x00000000
 ffff88009ed91dd0 0000000000000002 ffffffff81744d7c ffff88023ce55740
 00000000001d3fc0 ffff88009ed91fd8 00000000001d3fc0 ffff880243298000
 ffff88023ce55740 ffff880244bd3440 ffff880244bd3498 ffff880236789038
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076b40>] worker_thread+0x1c0/0x3a0
 [<ffffffff81076980>] ? process_one_work+0x6f0/0x6f0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kworker/u8:0    D 0000000000000003  3664 15478      2 0x00000000
Workqueue: events_freezable_power_ disk_events_workfn
 ffff8801c25ff470 0000000000000002 ffff880238082ba0 ffff880238082ba0
 00000000001d3fc0 ffff8801c25fffd8 00000000001d3fc0 ffff880242b84170
 ffff880238082ba0 ffff8801c25ff4a0 ffff880243374000 00000001000464e0
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119b9f6>] alloc_pages_current+0x106/0x1f0
 [<ffffffff811f9c1f>] ? bio_copy_user_iov+0x22f/0x440
 [<ffffffff811f9c1f>] bio_copy_user_iov+0x22f/0x440
 [<ffffffff812f141c>] ? get_request+0x40c/0xb20
 [<ffffffff812f1015>] ? get_request+0x5/0xb20
 [<ffffffff811f9e9f>] bio_copy_kern+0x3f/0xd0
 [<ffffffff812f85b4>] blk_rq_map_kern+0x74/0x170
 [<ffffffff814e1918>] scsi_execute+0x138/0x160
 [<ffffffff814e302c>] scsi_execute_req_flags+0x8c/0x100
 [<ffffffff814f29eb>] sr_check_events+0xbb/0x2e0
 [<ffffffff8151bbb8>] cdrom_check_events+0x18/0x30
 [<ffffffff814f2e89>] sr_block_check_events+0x39/0x50
 [<ffffffff81300bd1>] disk_check_events+0x51/0x160
 [<ffffffff81300cfc>] disk_events_workfn+0x1c/0x20
 [<ffffffff810764a1>] process_one_work+0x211/0x6f0
 [<ffffffff81076435>] ? process_one_work+0x1a5/0x6f0
 [<ffffffff81076a9b>] worker_thread+0x11b/0x3a0
 [<ffffffff81076980>] ? process_one_work+0x6f0/0x6f0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kworker/0:0     S 0000000000000000  6336 15479      2 0x00000000
 ffff8802127b1dd0 0000000000000002 ffffffff81744d7c ffff88023e6695d0
 00000000001d3fc0 ffff8802127b1fd8 00000000001d3fc0 ffffffff81c104c0
 ffff88023e6695d0 ffff8802449d3440 ffff8802449d3498 ffff8801b4cfee70
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076b40>] worker_thread+0x1c0/0x3a0
 [<ffffffff81076980>] ? process_one_work+0x6f0/0x6f0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kworker/2:1     S 0000000000000000  6544 17390      2 0x00000000
 ffff88016c2cbdd0 0000000000000002 ffffffff81744d7c ffff88009f62d740
 00000000001d3fc0 ffff88016c2cbfd8 00000000001d3fc0 ffff88024329d740
 ffff88009f62d740 ffff880244dd3440 ffff880244dd3498 ffff88016c2163c0
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076b40>] worker_thread+0x1c0/0x3a0
 [<ffffffff81076980>] ? process_one_work+0x6f0/0x6f0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
krfcommd        S 0000000000000000  5664 18115      2 0x00000000
 ffff880090341d70 0000000000000002 0000000000000000 ffff880240d02ba0
 00000000001d3fc0 ffff880090341fd8 00000000001d3fc0 ffff88024329d740
 ffff880240d02ba0 ffff8800791f0000 ffff8801f45dcd00 ffffffffa055d030
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffffa0555059>] rfcomm_run+0xdd9/0x19e0 [rfcomm]
 [<ffffffff8108a194>] ? finish_task_switch+0x44/0x180
 [<ffffffff810ace65>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffffa0554280>] ? rfcomm_check_accept+0xb0/0xb0 [rfcomm]
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kworker/u9:2    S 0000000000000000  5728 19193      2 0x00000000
 ffff8800702b1dd0 0000000000000002 ffffffff81744d7c ffff8801c1eec170
 00000000001d3fc0 ffff8800702b1fd8 00000000001d3fc0 ffff880243298000
 ffff8801c1eec170 ffff880242da8948 ffff880242da89a0 ffff8802367fe918
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076b40>] worker_thread+0x1c0/0x3a0
 [<ffffffff81076980>] ? process_one_work+0x6f0/0x6f0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
trinity         S 0000000000000000  5568 20237    542 0x00000000
 ffff8801ecf95e78 0000000000000002 ffff8801ecf95e38 ffff88024376c170
 00000000001d3fc0 ffff8801ecf95fd8 00000000001d3fc0 ffff880243298000
 ffff88024376c170 ffff8801ecf95f00 ffff88024376c3f0 ffff88024376c170
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810575e1>] do_wait+0x201/0x340
 [<ffffffff81057ae4>] SyS_wait4+0x64/0xe0
 [<ffffffff81054cd0>] ? task_stopped_code+0x60/0x60
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
trinity-watchdo S 0000000000000000  6224 20238  20237 0x00000000
 ffff8801688c1e50 0000000000000002 ffffffff81083903 ffff88023e6e95d0
 00000000001d3fc0 ffff8801688c1fd8 00000000001d3fc0 ffffffff81c104c0
 ffff88023e6e95d0 ffff8801688c1eb0 ffff88023e6e95d0 ffff88023e6e95d0
Call Trace:
 [<ffffffff81083903>] ? __hrtimer_start_range_ns+0x1b3/0x4d0
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173ee65>] do_nanosleep+0xd5/0x160
 [<ffffffff810846ab>] hrtimer_nanosleep+0xcb/0x1a0
 [<ffffffff81082b00>] ? hrtimer_get_res+0x50/0x50
 [<ffffffff8173ee01>] ? do_nanosleep+0x71/0x160
 [<ffffffff810847ee>] SyS_nanosleep+0x6e/0x90
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
trinity-main    S 0000000000000000  4816 20239  20237 0x00000000
 ffff8801a0733e78 0000000000000002 ffff8801a0733e38 ffff88023e6eaba0
 00000000001d3fc0 ffff8801a0733fd8 00000000001d3fc0 ffffffff81c104c0
 ffff88023e6eaba0 ffff8801a0733f00 ffff88023e6eae20 ffff88023e6eaba0
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810575e1>] do_wait+0x201/0x340
 [<ffffffff81057ae4>] SyS_wait4+0x64/0xe0
 [<ffffffff81054cd0>] ? task_stopped_code+0x60/0x60
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
trinity-child3  D 0000000000000003  4336 21141  20239 0x00000004
 ffff8801b65a77e0 0000000000000002 ffff880242b84170 ffff880242b84170
 00000000001d3fc0 ffff8801b65a7fd8 00000000001d3fc0 ffff88023ce54170
 ffff880242b84170 ffff8801b65a7810 ffff880243374000 00000001000464ea
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119b9f6>] alloc_pages_current+0x106/0x1f0
 [<ffffffff8114e5ff>] ? __page_cache_alloc+0x11f/0x150
 [<ffffffff8114e5ff>] __page_cache_alloc+0x11f/0x150
 [<ffffffff8114f011>] find_or_create_page+0x41/0x90
 [<ffffffff81211bf0>] SyS_io_setup+0x300/0xf00
 [<ffffffff812180e2>] compat_sys_io_setup+0x62/0xb0
 [<ffffffff8174f9e9>] ia32_do_call+0x13/0x13
trinity-child21 D 0000000000000000  4264 21159  20239 0x00000004
 ffff880228c6d750 0000000000000002 ffff880243218000 ffff880243218000
 00000000001d3fc0 ffff880228c6dfd8 00000000001d3fc0 ffff88009f5d0000
 ffff880243218000 ffff880228c6d780 ffffffff820d2180 0000000100046454
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119d681>] alloc_pages_vma+0xf1/0x1b0
 [<ffffffff8117c752>] ? handle_mm_fault+0x982/0xbb0
 [<ffffffff8117c752>] handle_mm_fault+0x982/0xbb0
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81748ddf>] __do_page_fault+0x16f/0x610
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff81744c81>] ? _raw_spin_unlock+0x31/0x50
 [<ffffffff8174929a>] do_page_fault+0x1a/0x70
 [<ffffffff81745cd2>] page_fault+0x22/0x30
trinity-child25 D 0000000000000000  4400 21163  20239 0x00000004
 ffff88005a20d750 0000000000000002 ffff88009ed895d0 ffff88009ed895d0
 00000000001d3fc0 ffff88005a20dfd8 00000000001d3fc0 ffffffff81c104c0
 ffff88009ed895d0 ffff88005a20d780 ffffffff820d2180 0000000100046454
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119d681>] alloc_pages_vma+0xf1/0x1b0
 [<ffffffff8117c752>] ? handle_mm_fault+0x982/0xbb0
 [<ffffffff8117c752>] handle_mm_fault+0x982/0xbb0
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81748ddf>] __do_page_fault+0x16f/0x610
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff81744c81>] ? _raw_spin_unlock+0x31/0x50
 [<ffffffff8174929a>] do_page_fault+0x1a/0x70
 [<ffffffff81745cd2>] page_fault+0x22/0x30
trinity-child26 D 0000000000000003  4192 21164  20239 0x00000004
 ffff88005b8e5820 0000000000000002 ffff88009ed8d740 ffff88009ed8d740
 00000000001d3fc0 ffff88005b8e5fd8 00000000001d3fc0 ffff880242b84170
 ffff88009ed8d740 ffff88005b8e5850 ffff880243374000 00000001000464ea
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119b9f6>] alloc_pages_current+0x106/0x1f0
 [<ffffffff8114e5ff>] ? __page_cache_alloc+0x11f/0x150
 [<ffffffff8114e5ff>] __page_cache_alloc+0x11f/0x150
 [<ffffffff8114f011>] find_or_create_page+0x41/0x90
 [<ffffffff81211bf0>] SyS_io_setup+0x300/0xf00
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
trinity-child29 D 0000000000000000  4272 21167  20239 0x00000004
 ffff880031f75750 0000000000000002 ffff88009f5d0000 ffff88009f5d0000
 00000000001d3fc0 ffff880031f75fd8 00000000001d3fc0 ffff880242b815d0
 ffff88009f5d0000 ffff880031f75780 ffffffff820d2180 0000000100046454
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119d681>] alloc_pages_vma+0xf1/0x1b0
 [<ffffffff8117c752>] ? handle_mm_fault+0x982/0xbb0
 [<ffffffff8117c752>] handle_mm_fault+0x982/0xbb0
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81748ddf>] __do_page_fault+0x16f/0x610
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff81744c81>] ? _raw_spin_unlock+0x31/0x50
 [<ffffffff8174929a>] do_page_fault+0x1a/0x70
 [<ffffffff81745cd2>] page_fault+0x22/0x30
trinity-child30 D 0000000000000001  4400 21168  20239 0x00000004
 ffff88006fb3b7e0 0000000000000002 ffff88009f5d2ba0 ffff88009f5d2ba0
 00000000001d3fc0 ffff88006fb3bfd8 00000000001d3fc0 ffff8802432fc170
 ffff88009f5d2ba0 ffff88006fb3b810 ffff8802432d0000 00000001000464f4
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119b9f6>] alloc_pages_current+0x106/0x1f0
 [<ffffffff8114e5ff>] ? __page_cache_alloc+0x11f/0x150
 [<ffffffff8114e5ff>] __page_cache_alloc+0x11f/0x150
 [<ffffffff8114f011>] find_or_create_page+0x41/0x90
 [<ffffffff81211bf0>] SyS_io_setup+0x300/0xf00
 [<ffffffff812180e2>] compat_sys_io_setup+0x62/0xb0
 [<ffffffff8174f9e9>] ia32_do_call+0x13/0x13
trinity-child4  D 0000000000000000  4016 21170  20239 0x00000004
 ffff8801013c9550 0000000000000002 ffff880238084170 ffff880238084170
 00000000001d3fc0 ffff8801013c9fd8 00000000001d3fc0 ffff880243298000
 ffff880238084170 ffff8801013c9580 ffff8802432d0000 00000001000464f4
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff81157f90>] ? drain_pages+0xc0/0xc0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119d681>] alloc_pages_vma+0xf1/0x1b0
 [<ffffffff8117975a>] ? do_wp_page+0xca/0x800
 [<ffffffff8117975a>] do_wp_page+0xca/0x800
 [<ffffffff8117c561>] handle_mm_fault+0x791/0xbb0
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81748ddf>] __do_page_fault+0x16f/0x610
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8174929a>] do_page_fault+0x1a/0x70
 [<ffffffff81745cd2>] page_fault+0x22/0x30
 [<ffffffff81327e89>] ? copy_user_enhanced_fast_string+0x9/0x20
 [<ffffffff81058b77>] ? SYSC_adjtimex+0x57/0x80
 [<ffffffff81058fae>] SyS_adjtimex+0xe/0x10
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
trinity-child5  D 0000000000000003  4736 21173  20239 0x00000004
 ffff880151249820 0000000000000002 ffff88023e6caba0 ffff88023e6caba0
 00000000001d3fc0 ffff880151249fd8 00000000001d3fc0 ffff88023e6c95d0
 ffff88023e6caba0 ffff880151249850 ffff880243374000 00000001000464f4
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119b9f6>] alloc_pages_current+0x106/0x1f0
 [<ffffffff8114e5ff>] ? __page_cache_alloc+0x11f/0x150
 [<ffffffff8114e5ff>] __page_cache_alloc+0x11f/0x150
 [<ffffffff8114f011>] find_or_create_page+0x41/0x90
 [<ffffffff81211bf0>] SyS_io_setup+0x300/0xf00
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
trinity-child7  D 0000000000000003  4672 21174  20239 0x00000004
 ffff88015c55f820 0000000000000002 ffff880231718000 ffff880231718000
 00000000001d3fc0 ffff88015c55ffd8 00000000001d3fc0 ffff8801c1eeaba0
 ffff880231718000 ffff88015c55f850 ffff880243374000 00000001000464f4
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119b9f6>] alloc_pages_current+0x106/0x1f0
 [<ffffffff8114e5ff>] ? __page_cache_alloc+0x11f/0x150
 [<ffffffff8114e5ff>] __page_cache_alloc+0x11f/0x150
 [<ffffffff8114f011>] find_or_create_page+0x41/0x90
 [<ffffffff81211bf0>] SyS_io_setup+0x300/0xf00
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
trinity-child10 D 0000000000000003  4576 21177  20239 0x00000004
 ffff88007326d820 0000000000000002 ffff88023171c170 ffff88023171c170
 00000000001d3fc0 ffff88007326dfd8 00000000001d3fc0 ffff880231718000
 ffff88023171c170 ffff88007326d850 ffff880243374000 00000001000464f4
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119b9f6>] alloc_pages_current+0x106/0x1f0
 [<ffffffff8114e5ff>] ? __page_cache_alloc+0x11f/0x150
 [<ffffffff8114e5ff>] __page_cache_alloc+0x11f/0x150
 [<ffffffff8114f011>] find_or_create_page+0x41/0x90
 [<ffffffff81211bf0>] SyS_io_setup+0x300/0xf00
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
trinity-child14 R  running task     4464 21179  20239 0x00000004
 ffff880198abb820 0000000000000002 ffff88023ce515d0 ffff88023ce515d0
 00000000001d3fc0 ffff880198abbfd8 00000000001d3fc0 ffff88023171aba0
 ffff88023ce515d0 ffff880198abb850 ffff880243374000 00000001000464fe
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119b9f6>] alloc_pages_current+0x106/0x1f0
 [<ffffffff8114e5ff>] ? __page_cache_alloc+0x11f/0x150
 [<ffffffff8114e5ff>] __page_cache_alloc+0x11f/0x150
 [<ffffffff8114f011>] find_or_create_page+0x41/0x90
 [<ffffffff81211bf0>] SyS_io_setup+0x300/0xf00
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
trinity-child6  D 0000000000000003  4360 21181  20239 0x00000004
 ffff88015fdab750 0000000000000002 ffff88023e6c95d0 ffff88023e6c95d0
 00000000001d3fc0 ffff88015fdabfd8 00000000001d3fc0 ffff880231718000
 ffff88023e6c95d0 ffff88015fdab780 ffff880243374000 00000001000464fe
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119d681>] alloc_pages_vma+0xf1/0x1b0
 [<ffffffff8117c752>] ? handle_mm_fault+0x982/0xbb0
 [<ffffffff8117c752>] handle_mm_fault+0x982/0xbb0
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81748ddf>] __do_page_fault+0x16f/0x610
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff81744c81>] ? _raw_spin_unlock+0x31/0x50
 [<ffffffff8174929a>] do_page_fault+0x1a/0x70
 [<ffffffff81745cd2>] page_fault+0x22/0x30
trinity-child12 D 0000000000000003  4360 21183  20239 0x00000004
 ffff88018ce13820 0000000000000002 ffff880240d75740 ffff880240d75740
 00000000001d3fc0 ffff88018ce13fd8 00000000001d3fc0 ffff88023ce515d0
 ffff880240d75740 ffff88018ce13850 ffff880243374000 00000001000464fe
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119b9f6>] alloc_pages_current+0x106/0x1f0
 [<ffffffff8114e5ff>] ? __page_cache_alloc+0x11f/0x150
 [<ffffffff8114e5ff>] __page_cache_alloc+0x11f/0x150
 [<ffffffff8114f011>] find_or_create_page+0x41/0x90
 [<ffffffff81211bf0>] SyS_io_setup+0x300/0xf00
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
trinity-child2  D 0000000000000002  4880 21184  20239 0x00000004
 ffff88023bae7820 0000000000000002 ffff880240d715d0 ffff880240d715d0
 00000000001d3fc0 ffff88023bae7fd8 00000000001d3fc0 ffff88009f62aba0
 ffff880240d715d0 ffff88023bae7850 ffff88024335c000 00000001000464fe
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119b9f6>] alloc_pages_current+0x106/0x1f0
 [<ffffffff8114e5ff>] ? __page_cache_alloc+0x11f/0x150
 [<ffffffff8114e5ff>] __page_cache_alloc+0x11f/0x150
 [<ffffffff8114f011>] find_or_create_page+0x41/0x90
 [<ffffffff81211bf0>] SyS_io_setup+0x300/0xf00
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
trinity-child28 D 0000000000000000  4672 21188  20239 0x00000004
 ffff88023aa1d750 0000000000000002 ffff8801c1eeaba0 ffff8801c1eeaba0
 00000000001d3fc0 ffff88023aa1dfd8 00000000001d3fc0 ffff8802432995d0
 ffff8801c1eeaba0 ffff88023aa1d780 ffff880243374000 00000001000464fe
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119d681>] alloc_pages_vma+0xf1/0x1b0
 [<ffffffff8117c752>] ? handle_mm_fault+0x982/0xbb0
 [<ffffffff8117c752>] handle_mm_fault+0x982/0xbb0
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81748ddf>] __do_page_fault+0x16f/0x610
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff81744c81>] ? _raw_spin_unlock+0x31/0x50
 [<ffffffff8174929a>] do_page_fault+0x1a/0x70
 [<ffffffff81745cd2>] page_fault+0x22/0x30
trinity-child8  D 0000000000000001  4672 21189  20239 0x00000004
 ffff88023b975750 0000000000000002 ffff880240d00000 ffff880240d00000
 00000000001d3fc0 ffff88023b975fd8 00000000001d3fc0 ffff88023e705740
 ffff880240d00000 ffff88023b975780 ffff8802432d0000 00000001000464fe
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119d681>] alloc_pages_vma+0xf1/0x1b0
 [<ffffffff8117c752>] ? handle_mm_fault+0x982/0xbb0
 [<ffffffff8117c752>] handle_mm_fault+0x982/0xbb0
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81748ddf>] __do_page_fault+0x16f/0x610
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff81744c81>] ? _raw_spin_unlock+0x31/0x50
 [<ffffffff8174929a>] do_page_fault+0x1a/0x70
 [<ffffffff81745cd2>] page_fault+0x22/0x30
trinity-child11 D 0000000000000000  4672 21190  20239 0x00000004
 ffff88023b93b750 0000000000000002 ffff88009f62aba0 ffff88009f62aba0
 00000000001d3fc0 ffff88023b93bfd8 00000000001d3fc0 ffff880243298000
 ffff88009f62aba0 ffff88023b93b780 ffff8802432d0000 0000000100046508
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119d681>] alloc_pages_vma+0xf1/0x1b0
 [<ffffffff8117c752>] ? handle_mm_fault+0x982/0xbb0
 [<ffffffff8117c752>] handle_mm_fault+0x982/0xbb0
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81748ddf>] __do_page_fault+0x16f/0x610
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff81744c81>] ? _raw_spin_unlock+0x31/0x50
 [<ffffffff8174929a>] do_page_fault+0x1a/0x70
 [<ffffffff81745cd2>] page_fault+0x22/0x30
trinity-child18 D 0000000000000001  4880 21191  20239 0x00000004
 ffff880153c15820 0000000000000002 ffff88023ce50000 ffff88023ce50000
 00000000001d3fc0 ffff880153c15fd8 00000000001d3fc0 ffff88023e705740
 ffff88023ce50000 ffff880153c15850 ffff8802432d0000 0000000100046508
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119b9f6>] alloc_pages_current+0x106/0x1f0
 [<ffffffff8114e5ff>] ? __page_cache_alloc+0x11f/0x150
 [<ffffffff8114e5ff>] __page_cache_alloc+0x11f/0x150
 [<ffffffff8114f011>] find_or_create_page+0x41/0x90
 [<ffffffff81211bf0>] SyS_io_setup+0x300/0xf00
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
trinity-child13 D 0000000000000003  4880 21192  20239 0x00000004
 ffff880160e27820 0000000000000002 ffff88023ce54170 ffff88023ce54170
 00000000001d3fc0 ffff880160e27fd8 00000000001d3fc0 ffff88023e6caba0
 ffff88023ce54170 ffff880160e27850 ffff880243374000 0000000100046508
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119b9f6>] alloc_pages_current+0x106/0x1f0
 [<ffffffff8114e5ff>] ? __page_cache_alloc+0x11f/0x150
 [<ffffffff8114e5ff>] __page_cache_alloc+0x11f/0x150
 [<ffffffff8114f011>] find_or_create_page+0x41/0x90
 [<ffffffff81211bf0>] SyS_io_setup+0x300/0xf00
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
trinity-child22 D 0000000000000000  4880 21193  20239 0x00000004
 ffff8801843c7820 0000000000000002 ffff8802432c15d0 ffff8802432c15d0
 00000000001d3fc0 ffff8801843c7fd8 00000000001d3fc0 ffff880243218000
 ffff8802432c15d0 ffff8801843c7850 ffffffff820d2180 0000000100046454
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119b9f6>] alloc_pages_current+0x106/0x1f0
 [<ffffffff8114e5ff>] ? __page_cache_alloc+0x11f/0x150
 [<ffffffff8114e5ff>] __page_cache_alloc+0x11f/0x150
 [<ffffffff8114f011>] find_or_create_page+0x41/0x90
 [<ffffffff81211bf0>] SyS_io_setup+0x300/0xf00
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
trinity-child17 D 0000000000000000  4672 21194  20239 0x00000004
 ffff8802125ab750 0000000000000002 ffff880242b815d0 ffff880242b815d0
 00000000001d3fc0 ffff8802125abfd8 00000000001d3fc0 ffff88009ed895d0
 ffff880242b815d0 ffff8802125ab780 ffffffff820d2180 0000000100046454
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119d681>] alloc_pages_vma+0xf1/0x1b0
 [<ffffffff8117c752>] ? handle_mm_fault+0x982/0xbb0
 [<ffffffff8117c752>] handle_mm_fault+0x982/0xbb0
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81748ddf>] __do_page_fault+0x16f/0x610
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff81744c81>] ? _raw_spin_unlock+0x31/0x50
 [<ffffffff8174929a>] do_page_fault+0x1a/0x70
 [<ffffffff81745cd2>] page_fault+0x22/0x30
trinity-child0  D 0000000000000000  4688 21195  20239 0x00000004
 ffff8802269577e0 0000000000000002 ffff88009ed05740 ffff88009ed05740
 00000000001d3fc0 ffff880226957fd8 00000000001d3fc0 ffff8802432c15d0
 ffff88009ed05740 ffff880226957810 ffffffff820d2180 0000000100046454
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119b9f6>] alloc_pages_current+0x106/0x1f0
 [<ffffffff8114e5ff>] ? __page_cache_alloc+0x11f/0x150
 [<ffffffff8114e5ff>] __page_cache_alloc+0x11f/0x150
 [<ffffffff8114f011>] find_or_create_page+0x41/0x90
 [<ffffffff81211bf0>] SyS_io_setup+0x300/0xf00
 [<ffffffff812180e2>] compat_sys_io_setup+0x62/0xb0
 [<ffffffff8174f9e9>] ia32_do_call+0x13/0x13
trinity-child31 D 0000000000000003  4816 21196  20239 0x00000004
 ffff88023191d7e0 0000000000000002 ffff8802432fc170 ffff8802432fc170
 00000000001d3fc0 ffff88023191dfd8 00000000001d3fc0 ffff88023ce50000
 ffff8802432fc170 ffff88023191d810 ffff880243374000 0000000100046512
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119b9f6>] alloc_pages_current+0x106/0x1f0
 [<ffffffff8114e5ff>] ? __page_cache_alloc+0x11f/0x150
 [<ffffffff8114e5ff>] __page_cache_alloc+0x11f/0x150
 [<ffffffff8114f011>] find_or_create_page+0x41/0x90
 [<ffffffff81211bf0>] SyS_io_setup+0x300/0xf00
 [<ffffffff812180e2>] compat_sys_io_setup+0x62/0xb0
 [<ffffffff8174f9e9>] ia32_do_call+0x13/0x13
trinity-child27 D 0000000000000003  4672 21197  20239 0x00000004
 ffff8801fd43b750 0000000000000002 ffff88023e705740 ffff88023e705740
 00000000001d3fc0 ffff8801fd43bfd8 00000000001d3fc0 ffff880238084170
 ffff88023e705740 ffff8801fd43b780 ffff880243374000 0000000100046512
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119d681>] alloc_pages_vma+0xf1/0x1b0
 [<ffffffff8117c752>] ? handle_mm_fault+0x982/0xbb0
 [<ffffffff8117c752>] handle_mm_fault+0x982/0xbb0
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff81748ddf>] __do_page_fault+0x16f/0x610
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff81744c81>] ? _raw_spin_unlock+0x31/0x50
 [<ffffffff8174929a>] do_page_fault+0x1a/0x70
 [<ffffffff81745cd2>] page_fault+0x22/0x30
trinity-child1  D 0000000000000000  4880 21198  20239 0x00000004
 ffff8801c4997820 0000000000000002 ffff880240d70000 ffff880240d70000
 00000000001d3fc0 ffff8801c4997fd8 00000000001d3fc0 ffff880243298000
 ffff880240d70000 ffff8801c4997850 ffff8802432d0000 0000000100046512
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119b9f6>] alloc_pages_current+0x106/0x1f0
 [<ffffffff8114e5ff>] ? __page_cache_alloc+0x11f/0x150
 [<ffffffff8114e5ff>] __page_cache_alloc+0x11f/0x150
 [<ffffffff8114f011>] find_or_create_page+0x41/0x90
 [<ffffffff81211bf0>] SyS_io_setup+0x300/0xf00
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
trinity-child19 D 0000000000000003  4880 21199  20239 0x00000004
 ffff8801c1e8b820 0000000000000002 ffff88023e66c170 ffff88023e66c170
 00000000001d3fc0 ffff8801c1e8bfd8 00000000001d3fc0 ffff88023171c170
 ffff88023e66c170 ffff8801c1e8b850 ffff880243374000 0000000100046512
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119b9f6>] alloc_pages_current+0x106/0x1f0
 [<ffffffff8114e5ff>] ? __page_cache_alloc+0x11f/0x150
 [<ffffffff8114e5ff>] __page_cache_alloc+0x11f/0x150
 [<ffffffff8114f011>] find_or_create_page+0x41/0x90
 [<ffffffff81211bf0>] SyS_io_setup+0x300/0xf00
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
trinity-child9  D 0000000000000003  4880 21200  20239 0x00000004
 ffff8801bafdf820 0000000000000002 ffff88023171aba0 ffff88023171aba0
 00000000001d3fc0 ffff8801bafdffd8 00000000001d3fc0 ffff88023ce54170
 ffff88023171aba0 ffff8801bafdf850 ffff880243374000 0000000100046512
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eb4e>] schedule_timeout+0x15e/0x340
 [<ffffffff81062060>] ? __internal_add_timer+0x130/0x130
 [<ffffffff817403ab>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81170107>] congestion_wait+0x77/0x1d0
 [<ffffffff810a43c0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff811642ec>] shrink_inactive_list+0x2ec/0x570
 [<ffffffff81164d41>] shrink_lruvec+0x4d1/0x650
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff81164ef1>] shrink_zone+0x31/0x100
 [<ffffffff8116587a>] try_to_free_pages+0x3da/0xaa0
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff811597da>] __alloc_pages_nodemask+0x82a/0xb50
 [<ffffffff8119b9f6>] alloc_pages_current+0x106/0x1f0
 [<ffffffff8114e5ff>] ? __page_cache_alloc+0x11f/0x150
 [<ffffffff8114e5ff>] __page_cache_alloc+0x11f/0x150
 [<ffffffff8114f011>] find_or_create_page+0x41/0x90
 [<ffffffff81211bf0>] SyS_io_setup+0x300/0xf00
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
kworker/u8:1    S 0000000000000000  4736 21201      2 0x00000000
 ffff8801c1e3fdd0 0000000000000002 ffffffff81744d7c ffff8802317195d0
 00000000001d3fc0 ffff8801c1e3ffd8 00000000001d3fc0 ffff88023e700000
 ffff8802317195d0 ffff880244441290 ffff8802444412e8 ffff8801a068d200
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076b40>] worker_thread+0x1c0/0x3a0
 [<ffffffff81076980>] ? process_one_work+0x6f0/0x6f0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
kworker/3:1     S 0000000000000000  6320 21211      2 0x00000000
 ffff880230c13dd0 0000000000000002 ffffffff81744d7c ffff88009ed8aba0
 00000000001d3fc0 ffff880230c13fd8 00000000001d3fc0 ffff880238082ba0
 ffff88009ed8aba0 ffff880244fd3440 ffff880244fd3498 ffff88006b2a23c0
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81076b40>] worker_thread+0x1c0/0x3a0
 [<ffffffff81076980>] ? process_one_work+0x6f0/0x6f0
 [<ffffffff8107f41f>] kthread+0xff/0x120
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8174dbec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f320>] ? insert_kthread_work+0x80/0x80
bash            S 0000000000000000  3816 21220    335 0x00000000
 ffff8801a40e5e78 0000000000000002 ffff8801a40e5e38 ffff88023d15d740
 00000000001d3fc0 ffff8801a40e5fd8 00000000001d3fc0 ffffffff81c104c0
 ffff88023d15d740 ffff8801a40e5f00 ffff88023d15d9c0 ffff88023d15d740
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff810575e1>] do_wait+0x201/0x340
 [<ffffffff81057ae4>] SyS_wait4+0x64/0xe0
 [<ffffffff81054cd0>] ? task_stopped_code+0x60/0x60
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
htop            D 0000000000000000  3976 21280  21220 0x00000000
 ffff880109947cd8 0000000000000002 ffffffff81744d7c ffff88009ed8c170
 00000000001d3fc0 ffff880109947fd8 00000000001d3fc0 ffff88024329d740
 ffff88009ed8c170 ffff88009ed8c170 ffff88023cdb80a8 fffffffeffffffff
Call Trace:
 [<ffffffff81744d7c>] ? _raw_spin_unlock_irq+0x2c/0x60
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff81743f05>] rwsem_down_read_failed+0xc5/0x120
 [<ffffffff81329584>] call_rwsem_down_read_failed+0x14/0x30
 [<ffffffff81095fcf>] ? local_clock+0x3f/0x50
 [<ffffffff8174388e>] ? down_read+0x7e/0xa0
 [<ffffffff8117d014>] ? __access_remote_vm+0x44/0x1e0
 [<ffffffff8117d014>] __access_remote_vm+0x44/0x1e0
 [<ffffffff81744c81>] ? _raw_spin_unlock+0x31/0x50
 [<ffffffff8117d230>] access_process_vm+0x50/0x70
 [<ffffffff8123045a>] proc_pid_cmdline+0x8a/0x120
 [<ffffffff8123135f>] proc_info_read+0x9f/0x100
 [<ffffffff811b9d08>] vfs_read+0x98/0x170
 [<ffffffff811ba84c>] SyS_read+0x4c/0xa0
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
agetty          S 0000000000000000  4160 21281      1 0x00000000
 ffff8802350f1cc0 0000000000000002 ffffffff824c7a90 ffff88023e6cd740
 00000000001d3fc0 ffff8802350f1fd8 00000000001d3fc0 ffff88024329d740
 ffff88023e6cd740 ffff8802372ec3c8 ffff8802372ec0f8 7fffffffffffffff
Call Trace:
 [<ffffffff8173fc09>] schedule+0x29/0x70
 [<ffffffff8173eba9>] schedule_timeout+0x1b9/0x340
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810a9fae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff810aa45d>] ? lock_release_holdtime.part.29+0x9d/0x160
 [<ffffffff813e6b37>] n_tty_read+0x517/0xba0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810a9829>] ? get_lock_stats+0x19/0x60
 [<ffffffff810926c0>] ? wake_up_state+0x20/0x20
 [<ffffffff813e1e9d>] tty_read+0x8d/0x100
 [<ffffffff811b9d08>] vfs_read+0x98/0x170
 [<ffffffff811ba84c>] SyS_read+0x4c/0xa0
 [<ffffffff8174dea4>] tracesys+0xdd/0xe2
Sched Debug Version: v0.11, 3.13.0-rc1+ #11
ktime                                   : 3180221.946595
sched_clk                               : 3178300.420862
cpu_clk                                 : 3178300.420887
jiffies                                 : 4295255314
sched_clock_stable                      : 1

sysctl_sched
  .sysctl_sched_latency                    : 18.000000
  .sysctl_sched_min_granularity            : 2.250000
  .sysctl_sched_wakeup_granularity         : 3.000000
  .sysctl_sched_child_runs_first           : 0
  .sysctl_sched_features                   : 11899
  .sysctl_sched_tunable_scaling            : 1 (logaritmic)

cpu#0, 2294.765 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 1305158
  .nr_load_updates               : 317826
  .nr_uninterruptible            : 39265
  .next_balance                  : 4295.255122
  .curr->pid                     : 0
  .clock                         : 3176330.097066
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 0

cfs_rq[0]:/autogroup-53
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 5398218.413899
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 4804432.525108
  .nr_spread_over                : 0
  .nr_running                    : 0
  .load                          : 0
  .runnable_load_avg             : 0
  .blocked_load_avg              : 0
  .tg_load_contrib               : 0
  .tg_runnable_contrib           : 0
  .tg_load_avg                   : 4
  .tg->runnable_avg              : 216
  .tg->cfs_bandwidth.timer_active: 0
  .throttled                     : 0
  .throttle_count                : 0
  .se->exec_start                : 3176259.840953
  .se->vruntime                  : 593785.888791
  .se->sum_exec_runtime          : 131269.532642
  .se->load.weight               : 2
  .se->avg.runnable_avg_sum      : 40
  .se->avg.runnable_avg_period   : 47025
  .se->avg.load_avg_contrib      : 0
  .se->avg.decay_count           : 3029118

cfs_rq[0]:/
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 593776.937917
  .min_vruntime                  : 593785.888791
  .max_vruntime                  : 593776.937917
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_spread_over                : 0
  .nr_running                    : 1
  .load                          : 1024
  .runnable_load_avg             : 1
  .blocked_load_avg              : 0
  .tg_load_contrib               : 1
  .tg_runnable_contrib           : 1
  .tg_load_avg                   : 2
  .tg->runnable_avg              : 14
  .tg->cfs_bandwidth.timer_active: 0
  .throttled                     : 0
  .throttle_count                : 0
  .avg->runnable_avg_sum         : 91
  .avg->runnable_avg_period      : 47892

rt_rq[0]:/system/getty@.service/getty@tty2.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[0]:/system/rpcbind.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[0]:/system/sshd.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[0]:/system/polkit.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[0]:/system/getty@.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[0]:/system/crond.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[0]:/system/dbus.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[0]:/system/avahi-daemon.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[0]:/system/systemd-logind.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[0]:/system/smartd.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[0]:/system/NetworkManager.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[0]:/system/chronyd.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[0]:/system/rsyslog.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[0]:/system/systemd-fsck@.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[0]:/system/initrd-switch-root.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[0]:/system/systemd-udevd.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[0]:/system/systemd-journald.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[0]:/system
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[0]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
         systemd     1       527.543397      1620   120               0               0               0.000000               0.000000               0.000000 /autogroup-1
        kthreadd     2    593438.648186       145   120               0               0               0.000000               0.000000               0.000000 /
     ksoftirqd/0     3    593776.894133      1017   120               0               0               0.000000               0.000000               0.000000 /
    kworker/0:0H     5      7120.323957         6   100               0               0               0.000000               0.000000               0.000000 /
          rcuc/0     7        -3.000000         4    98               0               0               0.000000               0.000000               0.000000 /
          rcub/0     8        -3.000000         3    98               0               0               0.000000               0.000000               0.000000 /
       rcu_sched    14    593447.303605       323   120               0               0               0.000000               0.000000               0.000000 /
         rcuos/1    16    585823.101992        50   120               0               0               0.000000               0.000000               0.000000 /
         rcuos/3    18    586032.618173        50   120               0               0               0.000000               0.000000               0.000000 /
          rcu_bh    19       141.461966         2   120               0               0               0.000000               0.000000               0.000000 /
         rcuob/0    20       143.465338         2   120               0               0               0.000000               0.000000               0.000000 /
         rcuob/1    21       145.468585         2   120               0               0               0.000000               0.000000               0.000000 /
         rcuob/2    22       147.471732         2   120               0               0               0.000000               0.000000               0.000000 /
         rcuob/3    23       149.474999         2   120               0               0               0.000000               0.000000               0.000000 /
     migration/0    24         0.000000      6508     0               0               0               0.000000               0.000000               0.000000 /
      watchdog/0    25        -5.634339       799     0               0               0               0.000000               0.000000               0.000000 /
           khubd    53      3255.288515       137   120               0               0               0.000000               0.000000               0.000000 /
      khugepaged    83    593755.632521       319   139               0               0               0.000000               0.000000               0.000000 /
       scsi_eh_1    95      1798.982841        21   120               0               0               0.000000               0.000000               0.000000 /
       scsi_eh_3    97      1721.237238         3   120               0               0               0.000000               0.000000               0.000000 /
       scsi_eh_4    98      1721.246193         3   120               0               0               0.000000               0.000000               0.000000 /
       scsi_eh_5    99      1721.231109         3   120               0               0               0.000000               0.000000               0.000000 /
     kworker/0:2   112    593776.937917    349263   120               0               0               0.000000               0.000000               0.000000 /
 ext4-rsv-conver   171      3331.981653         2   100               0               0               0.000000               0.000000               0.000000 /
       hd-audio0   259      6401.122459         2   100               0               0               0.000000               0.000000               0.000000 /
       hd-audio1   262      6449.906114         2   100               0               0               0.000000               0.000000               0.000000 /
        xfsalloc   299      7129.321959         2   100               0               0               0.000000               0.000000               0.000000 /
    kworker/0:1H   305    593743.829014       751   100               0               0               0.000000               0.000000               0.000000 /
        rsyslogd   312         8.426856         7   120               0               0               0.000000               0.000000               0.000000 /system/rsyslog.service
  NetworkManager   317       127.706833       294   120               0               0               0.000000               0.000000               0.000000 /system/NetworkManager.service
           gmain   356        63.698697         3   120               0               0               0.000000               0.000000               0.000000 /system/NetworkManager.service
         chronyd   320        33.659334       207   120               0               0               0.000000               0.000000               0.000000 /system/chronyd.service
          smartd   321        10.032745        29   120               0               0               0.000000               0.000000               0.000000 /system/smartd.service
    avahi-daemon   323        85.251978       598   120               0               0               0.000000               0.000000               0.000000 /system/avahi-daemon.service
         rpcbind   347         2.716963       117   120               0               0               0.000000               0.000000               0.000000 /system/rpcbind.service
            sshd   350        70.770486        44   120               0               0               0.000000               0.000000               0.000000 /system/sshd.service
        iscsi_eh  7753    128775.343763         2   100               0               0               0.000000               0.000000               0.000000 /
     kworker/0:0 15479    341684.826507        30   120               0               0               0.000000               0.000000               0.000000 /
 trinity-watchdo 20238   5398202.281363      4814   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
    trinity-main 20239   5392953.394285       671   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
 trinity-child21 21159   5398214.638683     28347   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
 trinity-child25 21163   5398218.413899     28302   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
 trinity-child29 21167   5398215.802290     28392   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
 trinity-child22 21193   5398208.187294     21131   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
 trinity-child17 21194   5398217.523361     21227   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
  trinity-child0 21195   5398206.345449     21178   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
    kworker/u8:1 21201    593776.896684      9707   120               0               0               0.000000               0.000000               0.000000 /
            bash 21220       131.175399       127   120               0               0               0.000000               0.000000               0.000000 /autogroup-57

cpu#1, 2294.765 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 980142
  .nr_load_updates               : 159113
  .nr_uninterruptible            : -24356
  .next_balance                  : 4295.255335
  .curr->pid                     : 0
  .clock                         : 3178458.548304
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 0

cfs_rq[1]:/system/crond.service
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 2.655808
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -593783.232983
  .nr_spread_over                : 0
  .nr_running                    : 0
  .load                          : 0
  .runnable_load_avg             : 0
  .blocked_load_avg              : 1
  .tg_load_contrib               : 1
  .tg_runnable_contrib           : 0
  .tg_load_avg                   : 1
  .tg->runnable_avg              : 0
  .tg->cfs_bandwidth.timer_active: 0
  .throttled                     : 0
  .throttle_count                : 0
  .se->exec_start                : 3178458.510459
  .se->vruntime                  : 4167.223977
  .se->sum_exec_runtime          : 3.704384
  .se->load.weight               : 2
  .se->avg.runnable_avg_sum      : 73
  .se->avg.runnable_avg_period   : 47687
  .se->avg.load_avg_contrib      : 0
  .se->avg.decay_count           : 3031215

cfs_rq[1]:/system
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 4176.038822
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -589609.849969
  .nr_spread_over                : 0
  .nr_running                    : 0
  .load                          : 0
  .runnable_load_avg             : 0
  .blocked_load_avg              : 0
  .tg_load_contrib               : 0
  .tg_runnable_contrib           : 0
  .tg_load_avg                   : 0
  .tg->runnable_avg              : 1
  .tg->cfs_bandwidth.timer_active: 0
  .throttled                     : 0
  .throttle_count                : 0
  .se->exec_start                : 3178458.529384
  .se->vruntime                  : 599883.151633
  .se->sum_exec_runtime          : 2253.638677
  .se->load.weight               : 2
  .se->avg.runnable_avg_sum      : 172
  .se->avg.runnable_avg_period   : 47003
  .se->avg.load_avg_contrib      : 0
  .se->avg.decay_count           : 3031215

cfs_rq[1]:/autogroup-53
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 4678427.324519
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 4084641.435728
  .nr_spread_over                : 0
  .nr_running                    : 0
  .load                          : 0
  .runnable_load_avg             : 0
  .blocked_load_avg              : 0
  .tg_load_contrib               : 0
  .tg_runnable_contrib           : 76
  .tg_load_avg                   : 3
  .tg->runnable_avg              : 246
  .tg->cfs_bandwidth.timer_active: 0
  .throttled                     : 0
  .throttle_count                : 0
  .se->exec_start                : 3178458.547324
  .se->vruntime                  : 599891.258445
  .se->sum_exec_runtime          : 122864.657241
  .se->load.weight               : 2
  .se->avg.runnable_avg_sum      : 3677
  .se->avg.runnable_avg_period   : 46492
  .se->avg.load_avg_contrib      : 0
  .se->avg.decay_count           : 3031215

cfs_rq[1]:/
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 599891.258445
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 6105.369654
  .nr_spread_over                : 0
  .nr_running                    : 0
  .load                          : 0
  .runnable_load_avg             : 0
  .blocked_load_avg              : 0
  .tg_load_contrib               : 0
  .tg_runnable_contrib           : 2
  .tg_load_avg                   : 9
  .tg->runnable_avg              : 14
  .tg->cfs_bandwidth.timer_active: 0
  .throttled                     : 0
  .throttle_count                : 0
  .avg->runnable_avg_sum         : 124
  .avg->runnable_avg_period      : 47386

cfs_rq[1]:/system/systemd-journald.service
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 429.406847
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -593356.481944
  .nr_spread_over                : 0
  .nr_running                    : 0
  .load                          : 0
  .runnable_load_avg             : 0
  .blocked_load_avg              : 0
  .tg_load_contrib               : 0
  .tg_runnable_contrib           : 0
  .tg_load_avg                   : 0
  .tg->runnable_avg              : 1
  .tg->cfs_bandwidth.timer_active: 0
  .throttled                     : 0
  .throttle_count                : 0
  .se->exec_start                : 3178458.529384
  .se->vruntime                  : 4176.038822
  .se->sum_exec_runtime          : 430.482333
  .se->load.weight               : 2
  .se->avg.runnable_avg_sum      : 171
  .se->avg.runnable_avg_period   : 47789
  .se->avg.load_avg_contrib      : 0
  .se->avg.decay_count           : 3031215

rt_rq[1]:/system/getty@.service/getty@tty2.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[1]:/system/rpcbind.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[1]:/system/sshd.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[1]:/system/polkit.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[1]:/system/getty@.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[1]:/system/crond.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[1]:/system/dbus.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[1]:/system/avahi-daemon.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[1]:/system/systemd-logind.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[1]:/system/smartd.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[1]:/system/NetworkManager.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[1]:/system/chronyd.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[1]:/system/rsyslog.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[1]:/system/systemd-fsck@.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[1]:/system/initrd-switch-root.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[1]:/system/systemd-udevd.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[1]:/system/systemd-journald.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[1]:/system
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[1]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
     rcu_preempt     9    599869.494789     44411   120               0               0               0.000000               0.000000               0.000000 /
      watchdog/1    26        -2.917865       799     0               0               0               0.000000               0.000000               0.000000 /
     migration/1    27         0.000000      5787     0               0               0               0.000000               0.000000               0.000000 /
          rcuc/1    28        -1.946602         4    98               0               0               0.000000               0.000000               0.000000 /
     ksoftirqd/1    29    599141.229062       232   120               0               0               0.000000               0.000000               0.000000 /
    kworker/1:0H    31      6261.844596         5   100               0               0               0.000000               0.000000               0.000000 /
    kworker/u9:0    50    591934.124336      2007   100               0               0               0.000000               0.000000               0.000000 /
          crypto    85       524.220091         2   100               0               0               0.000000               0.000000               0.000000 /
        kthrotld    93       598.315165         2   100               0               0               0.000000               0.000000               0.000000 /
       kpsmoused   105       715.268369         2   100               0               0               0.000000               0.000000               0.000000 /
     jbd2/sda3-8   170    599882.292543     25328   120               0               0               0.000000               0.000000               0.000000 /
 systemd-journal   204       429.430752     25775   120               0               0               0.000000               0.000000               0.000000 /system/systemd-journald.service
     kworker/1:2   233    599882.271592    176729   120               0               0               0.000000               0.000000               0.000000 /
    xfsaild/sda5   306    594047.392958      6651   120               0               0               0.000000               0.000000               0.000000 /
       in:imklog   315        15.138965        36   120               0               0               0.000000               0.000000               0.000000 /system/rsyslog.service
    avahi-daemon   327         7.631789         2   120               0               0               0.000000               0.000000               0.000000 /system/avahi-daemon.service
           crond   333         2.683096      8974   120               0               0               0.000000               0.000000               0.000000 /system/crond.service
 runaway-killer-   340         9.273282         3   120               0               0               0.000000               0.000000               0.000000 /system/polkit.service
        dhclient   355        48.511664        11   120               0               0               0.000000               0.000000               0.000000 /system/NetworkManager.service
            sshd   445      5235.011496        52   120               0               0               0.000000               0.000000               0.000000 /autogroup-52
            bash   480       264.297929       117   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
     kworker/1:1 14519    329720.099520         4   120               0               0               0.000000               0.000000               0.000000 /
    kworker/u9:2 19193    599869.441302       354   100               0               0               0.000000               0.000000               0.000000 /
         trinity 20237   4654443.699839        97   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
  trinity-child1 21198   4678428.536457     21185   139               0               0               0.000000               0.000000               0.000000 /autogroup-53

cpu#2, 2294.765 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 1022877
  .nr_load_updates               : 164351
  .nr_uninterruptible            : -18522
  .next_balance                  : 4295.255345
  .curr->pid                     : 0
  .clock                         : 3178558.564118
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 0

cfs_rq[2]:/autogroup-52
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 7285.069491
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -586500.819300
  .nr_spread_over                : 0
  .nr_running                    : 0
  .load                          : 0
  .runnable_load_avg             : 0
  .blocked_load_avg              : 0
  .tg_load_contrib               : 0
  .tg_runnable_contrib           : 0
  .tg_load_avg                   : 0
  .tg->runnable_avg              : 1
  .tg->cfs_bandwidth.timer_active: 0
  .throttled                     : 0
  .throttle_count                : 0
  .se->exec_start                : 3178558.462475
  .se->vruntime                  : 603323.893566
  .se->sum_exec_runtime          : 129.103633
  .se->load.weight               : 2
  .se->avg.runnable_avg_sum      : 126
  .se->avg.runnable_avg_period   : 48111
  .se->avg.load_avg_contrib      : 0
  .se->avg.decay_count           : 3031310

cfs_rq[2]:/autogroup-53
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 4557632.079499
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 3963846.190708
  .nr_spread_over                : 0
  .nr_running                    : 0
  .load                          : 0
  .runnable_load_avg             : 0
  .blocked_load_avg              : 2
  .tg_load_contrib               : 2
  .tg_runnable_contrib           : 88
  .tg_load_avg                   : 4
  .tg->runnable_avg              : 210
  .tg->cfs_bandwidth.timer_active: 0
  .throttled                     : 0
  .throttle_count                : 0
  .se->exec_start                : 3178558.563196
  .se->vruntime                  : 603332.969663
  .se->sum_exec_runtime          : 121717.588030
  .se->load.weight               : 2
  .se->avg.runnable_avg_sum      : 4057
  .se->avg.runnable_avg_period   : 46156
  .se->avg.load_avg_contrib      : 0
  .se->avg.decay_count           : 3031405

cfs_rq[2]:/
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 603332.989841
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 9547.101050
  .nr_spread_over                : 0
  .nr_running                    : 0
  .load                          : 0
  .runnable_load_avg             : 0
  .blocked_load_avg              : 12
  .tg_load_contrib               : 12
  .tg_runnable_contrib           : 3
  .tg_load_avg                   : 96
  .tg->runnable_avg              : 17
  .tg->cfs_bandwidth.timer_active: 0
  .throttled                     : 0
  .throttle_count                : 0
  .avg->runnable_avg_sum         : 143
  .avg->runnable_avg_period      : 47396

rt_rq[2]:/system/getty@.service/getty@tty2.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[2]:/system/rpcbind.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[2]:/system/sshd.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[2]:/system/polkit.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[2]:/system/getty@.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[2]:/system/crond.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[2]:/system/dbus.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[2]:/system/avahi-daemon.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[2]:/system/systemd-logind.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[2]:/system/smartd.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[2]:/system/NetworkManager.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[2]:/system/chronyd.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[2]:/system/rsyslog.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[2]:/system/systemd-fsck@.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[2]:/system/initrd-switch-root.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[2]:/system/systemd-udevd.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[2]:/system/systemd-journald.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[2]:/system
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[2]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.019411
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
         rcuop/0    10    603311.078331    105931   120               0               0               0.000000               0.000000               0.000000 /
         rcuop/2    12    603310.680807     25937   120               0               0               0.000000               0.000000               0.000000 /
         rcuos/0    15    598661.847129        52   120               0               0               0.000000               0.000000               0.000000 /
         rcuos/2    17    603111.006335        56   120               0               0               0.000000               0.000000               0.000000 /
      watchdog/2    32        -4.880853       800     0               0               0               0.000000               0.000000               0.000000 /
     migration/2    33         0.000000      7673     0               0               0               0.000000               0.000000               0.000000 /
          rcuc/2    34        -4.945713         4    98               0               0               0.000000               0.000000               0.000000 /
     ksoftirqd/2    35    602404.662081       240   120               0               0               0.000000               0.000000               0.000000 /
    kworker/2:0H    37      6667.931965         5   100               0               0               0.000000               0.000000               0.000000 /
         khelper    44         7.970245         2   100               0               0               0.000000               0.000000               0.000000 /
       kdevtmpfs    45    182678.847335       190   120               0               0               0.000000               0.000000               0.000000 /
           netns    46        26.452322         2   100               0               0               0.000000               0.000000               0.000000 /
       writeback    47        35.467575         2   100               0               0               0.000000               0.000000               0.000000 /
     kintegrityd    48        44.482047         2   100               0               0               0.000000               0.000000               0.000000 /
          bioset    49        53.496391         2   100               0               0               0.000000               0.000000               0.000000 /
         kblockd    51        71.519050         2   100               0               0               0.000000               0.000000               0.000000 /
         ata_sff    52        80.535093         2   100               0               0               0.000000               0.000000               0.000000 /
              md    54        98.579843         2   100               0               0               0.000000               0.000000               0.000000 /
       scsi_eh_2    96      4900.733635        35   120               0               0               0.000000               0.000000               0.000000 /
     jbd2/sda3-8   170    603324.012988     25329   120               0               0               0.000000               0.000000               0.000000 /
 kvm-irqfd-clean   260      6042.773270         2   100               0               0               0.000000               0.000000               0.000000 /
     kworker/2:3   295    603323.987129    181827   120               0               0               0.000000               0.000000               0.000000 /
   xfs_mru_cache   300      6676.931853         2   100               0               0               0.000000               0.000000               0.000000 /
         xfslogd   301      6685.963982         2   100               0               0               0.000000               0.000000               0.000000 /
   xfs-data/sda5   302      6695.000543         2   100               0               0               0.000000               0.000000               0.000000 /
   xfs-conv/sda5   303      6704.035734         2   100               0               0               0.000000               0.000000               0.000000 /
    xfs-cil/sda5   304      6713.070534         2   100               0               0               0.000000               0.000000               0.000000 /
   rs:main Q:Reg   316         7.117183       221   120               0               0               0.000000               0.000000               0.000000 /system/rsyslog.service
     dbus-daemon   326        22.688581       233   120               0               0               0.000000               0.000000               0.000000 /system/dbus.service
           login   335         8.430718       128   120               0               0               0.000000               0.000000               0.000000 /autogroup-49
 JS Sour~ Thread   339        -1.829037         6   120               0               0               0.000000               0.000000               0.000000 /system/polkit.service
           gmain   341        17.079596         1   120               0               0               0.000000               0.000000               0.000000 /system/polkit.service
            sshd   467      7287.005943     11173   139               0               0               0.000000               0.000000               0.000000 /autogroup-52
     kworker/2:1 17390    486042.780156        26   120               0               0               0.000000               0.000000               0.000000 /
        krfcommd 18115    488408.679096         2   110               0               0               0.000000               0.000000               0.000000 /
 trinity-child26 21164   4557625.962640     28338   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
  trinity-child4 21170   4557634.934959     26276   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
 trinity-child14 21179   4557626.195144     26475   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
 trinity-child12 21183   4557625.578934     25089   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
  trinity-child2 21184   4557628.853080     24405   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
  trinity-child8 21189   4557633.553241     21175   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
 trinity-child31 21196   4557634.074175     21199   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
            htop 21280       369.811313        27   120               0               0               0.000000               0.000000               0.000000 /autogroup-57
          agetty 21281         5.157986        10   120               0               0               0.000000               0.000000               0.000000 /system/getty@.service/getty@tty2.service

cpu#3, 2294.765 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 975563
  .nr_load_updates               : 159404
  .nr_uninterruptible            : 3639
  .next_balance                  : 4295.255365
  .curr->pid                     : 0
  .clock                         : 3178758.507066
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 0

cfs_rq[3]:/system/crond.service
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 8.968652
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -593776.920139
  .nr_spread_over                : 0
  .nr_running                    : 0
  .load                          : 0
  .runnable_load_avg             : 0
  .blocked_load_avg              : 0
  .tg_load_contrib               : 0
  .tg_runnable_contrib           : 0
  .tg_load_avg                   : 0
  .tg->runnable_avg              : 2
  .tg->cfs_bandwidth.timer_active: 0
  .throttled                     : 0
  .throttle_count                : 0
  .se->exec_start                : 3178658.432198
  .se->vruntime                  : 4402.374334
  .se->sum_exec_runtime          : 9.765426
  .se->load.weight               : 2
  .se->avg.runnable_avg_sum      : 12
  .se->avg.runnable_avg_period   : 47411
  .se->avg.load_avg_contrib      : 0
  .se->avg.decay_count           : 3031405

cfs_rq[3]:/system
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 4411.304092
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -589374.584699
  .nr_spread_over                : 0
  .nr_running                    : 0
  .load                          : 0
  .runnable_load_avg             : 0
  .blocked_load_avg              : 0
  .tg_load_contrib               : 0
  .tg_runnable_contrib           : 0
  .tg_load_avg                   : 0
  .tg->runnable_avg              : 0
  .tg->cfs_bandwidth.timer_active: 0
  .throttled                     : 0
  .throttle_count                : 0
  .se->exec_start                : 3178658.432198
  .se->vruntime                  : 601581.421502
  .se->sum_exec_runtime          : 1909.048825
  .se->load.weight               : 2
  .se->avg.runnable_avg_sum      : 13
  .se->avg.runnable_avg_period   : 48009
  .se->avg.load_avg_contrib      : 0
  .se->avg.decay_count           : 3031405

cfs_rq[3]:/autogroup-53
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 4333761.032180
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 3739975.143389
  .nr_spread_over                : 0
  .nr_running                    : 0
  .load                          : 0
  .runnable_load_avg             : 0
  .blocked_load_avg              : 2
  .tg_load_contrib               : 2
  .tg_runnable_contrib           : 42
  .tg_load_avg                   : 4
  .tg->runnable_avg              : 116
  .tg->cfs_bandwidth.timer_active: 0
  .throttled                     : 0
  .throttle_count                : 0
  .se->exec_start                : 3178758.505807
  .se->vruntime                  : 601590.891582
  .se->sum_exec_runtime          : 119680.151216
  .se->load.weight               : 2
  .se->avg.runnable_avg_sum      : 2183
  .se->avg.runnable_avg_period   : 47410
  .se->avg.load_avg_contrib      : 9
  .se->avg.decay_count           : 3031501

cfs_rq[3]:/
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 601590.891582
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 7805.002791
  .nr_spread_over                : 0
  .nr_running                    : 0
  .load                          : 0
  .runnable_load_avg             : 0
  .blocked_load_avg              : 10
  .tg_load_contrib               : 10
  .tg_runnable_contrib           : 6
  .tg_load_avg                   : 19
  .tg->runnable_avg              : 15
  .tg->cfs_bandwidth.timer_active: 0
  .throttled                     : 0
  .throttle_count                : 0
  .avg->runnable_avg_sum         : 279
  .avg->runnable_avg_period      : 46162

rt_rq[3]:/system/getty@.service/getty@tty2.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[3]:/system/rpcbind.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[3]:/system/sshd.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[3]:/system/polkit.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[3]:/system/getty@.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[3]:/system/crond.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[3]:/system/dbus.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[3]:/system/avahi-daemon.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[3]:/system/systemd-logind.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[3]:/system/smartd.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[3]:/system/NetworkManager.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[3]:/system/chronyd.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[3]:/system/rsyslog.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[3]:/system/systemd-fsck@.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[3]:/system/initrd-switch-root.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[3]:/system/systemd-udevd.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[3]:/system/systemd-journald.service
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[3]:/system
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[3]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.014199
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
         rcuop/1    11    601556.920684     28495   120               0               0               0.000000               0.000000               0.000000 /
         rcuop/3    13    601556.018844     31297   120               0               0               0.000000               0.000000               0.000000 /
      watchdog/3    38        -4.886406       800     0               0               0               0.000000               0.000000               0.000000 /
     migration/3    39         0.000000      7706     0               0               0               0.000000               0.000000               0.000000 /
          rcuc/3    40        -4.945878         4    98               0               0               0.000000               0.000000               0.000000 /
     ksoftirqd/3    41    596941.386772        85   120               0               0               0.000000               0.000000               0.000000 /
     kworker/3:0    42    601413.486571        95   120               0               0               0.000000               0.000000               0.000000 /
    kworker/3:0H    43      7078.869074         5   100               0               0               0.000000               0.000000               0.000000 /
      khungtaskd    80      3156.726881         3   120               0               0               0.000000               0.000000               0.000000 /
            ksmd    82    489189.523229         3   125               0               0               0.000000               0.000000               0.000000 /
   fsnotify_mark    84     25342.630950        31   120               0               0               0.000000               0.000000               0.000000 /
       scsi_eh_0    94       225.865860         3   120               0               0               0.000000               0.000000               0.000000 /
    kworker/u8:6   107    597915.854698     48878   120               0               0               0.000000               0.000000               0.000000 /
         deferwq   108       253.095620         2   100               0               0               0.000000               0.000000               0.000000 /
     kworker/3:2   168    601413.513027    173059   120               0               0               0.000000               0.000000               0.000000 /
   systemd-udevd   209       467.814333       863   120               0               0               0.000000               0.000000               0.000000 /system/systemd-udevd.service
     jbd2/sda1-8   296      7074.818541         3   120               0               0               0.000000               0.000000               0.000000 /
 ext4-rsv-conver   297      7080.823516         2   100               0               0               0.000000               0.000000               0.000000 /
     in:imuxsock   314        14.681289       194   120               0               0               0.000000               0.000000               0.000000 /system/rsyslog.service
  NetworkManager   324        10.119630         1   120               0               0               0.000000               0.000000               0.000000 /system/NetworkManager.service
           gdbus   334        35.018204        42   120               0               0               0.000000               0.000000               0.000000 /system/NetworkManager.service
  systemd-logind   322        18.015474        77   120               0               0               0.000000               0.000000               0.000000 /system/systemd-logind.service
         polkitd   336        24.422295        78   120               0               0               0.000000               0.000000               0.000000 /system/polkit.service
           gdbus   337        31.284696        78   120               0               0               0.000000               0.000000               0.000000 /system/polkit.service
    JS GC Helper   338        10.472721         2   120               0               0               0.000000               0.000000               0.000000 /system/polkit.service
            sshd   467      9388.323005     11175   139               0               0               0.000000               0.000000               0.000000 /autogroup-52
          ten.sh   542   4306406.592251       191   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
           krdsd   607      9145.014122         2   100               0               0               0.000000               0.000000               0.000000 /
  trinity-child3 21141   4333757.887613     28136   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
 trinity-child26 21164   4333753.548347     28339   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
 trinity-child30 21168   4333761.549597     28575   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
  trinity-child4 21170   4333762.206298     26277   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
  trinity-child5 21173   4333758.886238     26390   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
  trinity-child7 21174   4333760.857936     26271   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
 trinity-child10 21177   4333760.591930     26390   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
 trinity-child14 21179   4333754.240150     26476   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
 trinity-child12 21183   4333753.391574     25090   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
 trinity-child28 21188   4333761.822710     22589   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
  trinity-child8 21189   4333761.257186     21176   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
 trinity-child13 21192   4333760.166763     21147   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
 trinity-child31 21196   4333761.397875     21200   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
 trinity-child19 21199   4333760.137338     21158   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
  trinity-child9 21200   4333758.661491     19354   139               0               0               0.000000               0.000000               0.000000 /autogroup-53
     kworker/3:1 21211    601581.911902       364   120               0               0               0.000000               0.000000               0.000000 /


Showing all locks held in the system:
1 lock held by crond/333:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81748d71>] __do_page_fault+0x101/0x610
2 locks held by sshd/467:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff810513c6>] dup_mm+0xb6/0x510
 #1:  (&mm->mmap_sem/1){+.+.+.}, at: [<ffffffff810513df>] dup_mm+0xcf/0x510
2 locks held by kworker/u8:0/15478:
 #0:  (events_freezable_power_efficient){.+.+.+}, at: [<ffffffff81076435>] process_one_work+0x1a5/0x6f0
 #1:  ((&(&ev->dwork)->work)){+.+.+.}, at: [<ffffffff81076435>] process_one_work+0x1a5/0x6f0
1 lock held by trinity-child21/21159:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81748d71>] __do_page_fault+0x101/0x610
1 lock held by trinity-child25/21163:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81748d71>] __do_page_fault+0x101/0x610
1 lock held by trinity-child29/21167:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81748d71>] __do_page_fault+0x101/0x610
1 lock held by trinity-child4/21170:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81748d71>] __do_page_fault+0x101/0x610
1 lock held by trinity-child6/21181:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81748d71>] __do_page_fault+0x101/0x610
1 lock held by trinity-child28/21188:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81748d71>] __do_page_fault+0x101/0x610
1 lock held by trinity-child8/21189:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81748d71>] __do_page_fault+0x101/0x610
1 lock held by trinity-child11/21190:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81748d71>] __do_page_fault+0x101/0x610
1 lock held by trinity-child17/21194:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81748d71>] __do_page_fault+0x101/0x610
1 lock held by trinity-child27/21197:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81748d71>] __do_page_fault+0x101/0x610
1 lock held by htop/21280:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff8117d014>] __access_remote_vm+0x44/0x1e0
2 locks held by agetty/21281:
 #0:  (&tty->ldisc_sem){++++++}, at: [<ffffffff813ea3b0>] tty_ldisc_ref_wait+0x20/0x50
 #1:  (&ldata->atomic_read_lock){+.+...}, at: [<ffffffff813e66d0>] n_tty_read+0xb0/0xba0

=============================================

