Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab3LXOgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 09:36:09 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:65178 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab3LXOgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 09:36:06 -0500
MIME-Version: 1.0
Date: Tue, 24 Dec 2013 09:36:02 -0500
X-Google-Sender-Auth: OmHF4L1V2DXSsmfCcs5oTEC5EYA
Message-ID: <CA+5PVA6YpKc6kYK5UiTnGLZpB8uts=-QPtyhotAyZ2kuoG8PPQ@mail.gmail.com>
Subject: intel_pstate divide error with v3.13-rc4-256-gb7000ad
From: Josh Boyer <jwboyer@fedoraproject.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We've had a report [1] that the pstate driver causes KVM guests to
fail to boot because of a divide error.  See the backtrace below.

    4.839784] Intel P-state driver initializing.
[    4.859972] Intel pstate controlling: cpu 0
[    4.867653] cpufreq: __cpufreq_add_dev: ->get() failed
[    4.877269] divide error: 0000 [#1] SMP
[    4.878127] Modules linked in:
[    4.878127] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
3.13.0-0.rc4.git5.1.fc21.x86_64 #1
[    4.878127] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.878127] task: ffff88001ea20000 ti: ffff88001e9bc000 task.ti:
ffff88001e9bc000
[    4.878127] RIP: 0010:[<ffffffff815c551d>]  [<ffffffff815c551d>]
intel_pstate_timer_func+0x11d/0x2b0
[    4.878127] RSP: 0000:ffff88001ee03e18  EFLAGS: 00010246
[    4.878127] RAX: 0000000000000000 RBX: ffff88001a454348 RCX: 0000000000006100
[    4.878127] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[    4.878127] RBP: ffff88001ee03e38 R08: 0000000000000000 R09: 0000000000000000
[    4.878127] R10: ffff88001ea20000 R11: 0000000000000000 R12: 00000c0a1ea20000
[    4.878127] R13: 1ea200001ea20000 R14: ffffffff815c5400 R15: ffff88001a454348
[    4.878127] FS:  0000000000000000(0000) GS:ffff88001ee00000(0000)
knlGS:0000000000000000
[    4.878127] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    4.878127] CR2: 0000000000000000 CR3: 0000000001c0c000 CR4: 00000000000006f0
[    4.878127] Stack:
[    4.878127]  fffffffb1a454390 ffffffff821a4500 ffff88001a454390
0000000000000100
[    4.878127]  ffff88001ee03ea8 ffffffff81083e9a ffffffff81083e15
ffffffff82d5ed40
[    4.878127]  ffffffff8258cc60 0000000000000000 ffffffff81ac39de
0000000000000000
[    4.878127] Call Trace:
[    4.878127]  <IRQ>
[    4.878127]  [<ffffffff81083e9a>] call_timer_fn+0x8a/0x310
[    4.878127]  [<ffffffff81083e15>] ? call_timer_fn+0x5/0x310
[    4.878127]  [<ffffffff815c5400>] ? pid_param_set+0x130/0x130
[    4.878127]  [<ffffffff81084354>] run_timer_softirq+0x234/0x380
[    4.878127]  [<ffffffff8107aee4>] __do_softirq+0x104/0x430
[    4.878127]  [<ffffffff8107b5fd>] irq_exit+0xcd/0xe0
[    4.878127]  [<ffffffff81770645>] smp_apic_timer_interrupt+0x45/0x60
[    4.878127]  [<ffffffff8176efb2>] apic_timer_interrupt+0x72/0x80
[    4.878127]  <EOI>
[    4.878127]  [<ffffffff810e15cd>] ? vprintk_emit+0x1dd/0x5e0
[    4.878127]  [<ffffffff81757719>] printk+0x67/0x69
[    4.878127]  [<ffffffff815c1493>] __cpufreq_add_dev.isra.13+0x883/0x8d0
[    4.878127]  [<ffffffff815c14f0>] cpufreq_add_dev+0x10/0x20
[    4.878127]  [<ffffffff814a14d1>] subsys_interface_register+0xb1/0xf0
[    4.878127]  [<ffffffff815bf5cf>] cpufreq_register_driver+0x9f/0x210
[    4.878127]  [<ffffffff81fb19af>] intel_pstate_init+0x27d/0x3be
[    4.878127]  [<ffffffff81761e3e>] ? mutex_unlock+0xe/0x10
[    4.878127]  [<ffffffff81fb1732>] ? cpufreq_gov_dbs_init+0x12/0x12
[    4.878127]  [<ffffffff8100214a>] do_one_initcall+0xfa/0x1b0
[    4.878127]  [<ffffffff8109dbf5>] ? parse_args+0x225/0x3f0
[    4.878127]  [<ffffffff81f64193>] kernel_init_freeable+0x1fc/0x287
[    4.878127]  [<ffffffff81f638d0>] ? do_early_param+0x88/0x88
[    4.878127]  [<ffffffff8174b530>] ? rest_init+0x150/0x150
[    4.878127]  [<ffffffff8174b53e>] kernel_init+0xe/0x130
[    4.878127]  [<ffffffff8176e27c>] ret_from_fork+0x7c/0xb0
[    4.878127]  [<ffffffff8174b530>] ? rest_init+0x150/0x150
[    4.878127] Code: c1 e0 05 48 63 bc 03 10 01 00 00 48 63 83 d0 00
00 00 48 63 d6 48 c1 e2 08 c1 e1 08 4c 63 c2 48 c1 e0 08 48 98 48 c1
e0 08 48 99 <49> f7 f8 48 98 48 0f af f8 48 c1 ff 08 29 f9 89 ca c1 fa
1f 89
[    4.878127] RIP  [<ffffffff815c551d>] intel_pstate_timer_func+0x11d/0x2b0
[    4.878127]  RSP <ffff88001ee03e18>
[    5.438189] ---[ end trace f166110ed22cc37a ]---
[    5.446428] Kernel panic - not syncing: Fatal exception in interrupt
