Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab3F0REU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:04:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab3F0RET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:04:19 -0400
Message-ID: <51CC708B.7040605@redhat.com>
Date: Thu, 27 Jun 2013 13:04:11 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, athorlton@sgi.com,
        CAI Qian <caiqian@redhat.com>
Subject: Re: BUG: tick device NULL pointer during system initialization and
 shutdown
References: <51C0AB09.2090605@redhat.com> <alpine.DEB.2.02.1306241551020.4013@ionos.tec.linutronix.de> <51CA2CBF.70404@redhat.com> <alpine.DEB.2.02.1306261303260.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306261303260.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/26/2013 07:05 AM, Thomas Gleixner wrote:
> On Tue, 25 Jun 2013, Prarit Bhargava wrote:
>> On 06/24/2013 09:57 AM, Thomas Gleixner wrote:
>>> Does the patch below fix it?
>>>
>>
>> Thomas,
>>
>> Thanks for the patch.
>>
>> The reproducibility appears to be quite low.  I'm seeing this roughly 1 time
>> every six hours of continuous system reboots.  I'm testing right now with your
>> patch.  I'll update the thread in a couple of days...
> 
> I have a proper version of that patch now along with an explanation of
> the failure.
> 
> -------------------->
> 
> Subject: tick: Make oneshot broadcast robust vs. CPU offlining
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Wed, 26 Jun 2013 12:17:32 +0200
> 
> In periodic mode we remove offline cpus from the broadcast propagation
> mask. In oneshot mode we fail to do so. This was not a problem so far,
> but the recent changes to the broadcast propagation introduced a
> constellation which can result in a NULL pointer dereference.
> 

Unfortunately this patch causes an NMI watchdog during system shutdown.  Most of
the CPUs are in start_secondary+0x254/0x256.

CPU 0, however, is

[  270.579581] NMI backtrace for cpu 0^M
[  270.583480] CPU: 0 PID: 595 Comm: kworker/0:2 Not tainted 3.10.0-rc4+ #2^M
[  270.590954] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS
QSSC-S4R.QCI.01.00.T030.072620111404 07/26/2011^M
[  270.601345] task: ffff880851c50000 ti: ffff880851c72000 task.ti:
ffff880851c72000^M
[  270.609691] RIP: 0010:[<ffffffff8109a8c0>]  [<ffffffff8109a8c0>]
update_cfs_shares+0xf0/0xf0^M
[  270.619126] RSP: 0018:ffff880851c73d78  EFLAGS: 00000086^M
[  270.625049] RAX: ffffffff81626180 RBX: ffff880851c50048 RCX: 0000000000000000^M
[  270.633007] RDX: 0000000000000001 RSI: ffff880851c50048 RDI: ffff88085f414670^M
[  270.640965] RBP: ffff880851c73dc0 R08: 0000003effcc9cfd R09: 0000000000000000^M
[  270.648923] R10: 0000000000000000 R11: 0000000000000005 R12: ffff88085f414670^M
[  270.656881] R13: ffff88085f414600 R14: 0000000000000001 R15: 0000000000000001^M
[  270.664841] FS:  0000000000000000(0000) GS:ffff88085f400000(0000)
knlGS:0000000000000000^M
[  270.673865] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b^M
[  270.680272] CR2: 00000000000000b8 CR3: 00000000018f8000 CR4: 00000000000007f0^M
[  270.688229] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000^M
[  270.696188] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400^M
[  270.704146] Stack:^M
[  270.706388]  ffffffff8109b019 ffff88085f414600 ffff88085f414600
0000000000000000^M
[  270.714684]  ffff88085f414600 ffff88085f414600 0000000000000000
ffff880851c50000^M
[  270.722981]  ffff8808521ec700 ffff880851c73de8 ffffffff8108ed39
0000000168d36c00^M
[  270.731276] Call Trace:^M
[  270.734007]  [<ffffffff8109b019>] ? dequeue_task_fair+0x59/0x640^M
[  270.740713]  [<ffffffff8108ed39>] dequeue_task+0x79/0xa0^M
[  270.746638]  [<ffffffff81091be3>] deactivate_task+0x23/0x30^M
[  270.752857]  [<ffffffff816023f9>] __schedule+0x589/0x7d0^M
[  270.758782]  [<ffffffff81602669>] schedule+0x29/0x70^M
[  270.764323]  [<ffffffff8107de03>] worker_thread+0x1c3/0x3a0^M
[  270.770541]  [<ffffffff8107dc40>] ? rescuer_thread+0x350/0x350^M
[  270.777041]  [<ffffffff81084300>] kthread+0xc0/0xd0^M
[  270.782474]  [<ffffffff81084240>] ? insert_kthread_work+0x40/0x40^M
[  270.789272]  [<ffffffff8160c56c>] ret_from_fork+0x7c/0xb0^M
[  270.795295]  [<ffffffff81084240>] ? insert_kthread_work+0x40/0x40^M

and CPU63 is doing the back trace:

[  272.655049] CPU: 63 PID: 0 Comm: swapper/63 Not tainted 3.10.0-rc4+ #2^M
[  272.662331] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS
QSSC-S4R.QCI.01.00.T030.072620111404 07/26/2011^M
[  272.672714] task: ffff880854df4de0 ti: ffff880854e02000 task.ti:
ffff880854e02000^M
[  272.681062] RIP: 0010:[<ffffffff812f3c82>]  [<ffffffff812f3c82>]
delay_tsc+0x32/0x80^M
[  272.689720] RSP: 0018:ffff88106f3c3dd0  EFLAGS: 00000083^M
[  272.695647] RAX: 000000000000009e RBX: 00000000cea08f3d RCX: 0000000000000001^M
[  272.703607] RDX: 00000000cea08fdb RSI: 0000000000000050 RDI: 00000000001e7000^M
[  272.711569] RBP: ffff88106f3c3de8 R08: ffffffff81a02928 R09: 000000000000070e^M
[  272.719529] R10: 0000000000000000 R11: ffff88106f3c3b46 R12: 00000000001e7000^M
[  272.727491] R13: 000000000000003f R14: ffff88106f3cec80 R15: ffffffff81949480^M
[  272.735452] FS:  0000000000000000(0000) GS:ffff88106f3c0000(0000)
knlGS:0000000000000000^M
[  272.744470] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b^M
[  272.750879] CR2: 00007f114a8f7920 CR3: 0000000c61b5f000 CR4: 00000000000007e0^M
[  272.758841] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000^M
[  272.766801] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400^M
[  272.774759] Stack:^M
[  272.777001]  0000000000002710 ffffffff81949300 ffffffff81949000
ffff88106f3c3df8^M
[  272.785303]  ffffffff812f3be8 ffff88106f3c3e10 ffffffff81036faa
ffffffff81a02ba0^M
[  272.793605]  ffff88106f3c3e70 ffffffff810f8060 0000000354df4de0
0000000000000242^M
[  272.801908] Call Trace:^M
[  272.804634]  <IRQ> ^M
[  272.806782]  [<ffffffff812f3be8>] __const_udelay+0x28/0x30^M
[  272.813122]  [<ffffffff81036faa>] arch_trigger_all_cpu_backtrace+0x7a/0xa0^M
[  272.820799]  [<ffffffff810f8060>] rcu_check_callbacks+0x5b0/0x600^M
[  272.827603]  [<ffffffff81070217>] update_process_times+0x47/0x80^M
[  272.834313]  [<ffffffff810b94f5>] tick_sched_handle.isra.15+0x25/0x60^M
[  272.841500]  [<ffffffff810b9571>] tick_sched_timer+0x41/0x60^M
[  272.847821]  [<ffffffff81087c74>] __run_hrtimer+0x74/0x1d0^M
[  272.853943]  [<ffffffff810b9530>] ? tick_sched_handle.isra.15+0x60/0x60^M
[  272.861325]  [<ffffffff81088457>] hrtimer_interrupt+0xf7/0x240^M
[  272.867841]  [<ffffffff8160e429>] smp_apic_timer_interrupt+0x69/0x9c^M
[  272.874933]  [<ffffffff8160d29d>] apic_timer_interrupt+0x6d/0x80^M
[  272.881634]  <EOI> ^M
[  272.883781]  [<ffffffff810b0432>] ? cpu_startup_entry+0x132/0x230^M
[  272.890803]  [<ffffffff810b0400>] ? cpu_startup_entry+0x100/0x230^M
[  272.897605]  [<ffffffff815ed4e8>] start_secondary+0x254/0x256^M
[  272.904014] Code: 89 e5 41 55 41 54 41 89 fc 53 65 44 8b 2c 25 1c b0 00 00 66
66 90 0f ae e8 e8 5b 46 d2 ff 66 90 89 c3 eb 14 0f 1f 44 00 00 f3 90 <65> 8b 04
25 1c b0 00 00 41 39 c5 75 1d 66 66 90 0f ae e8 e8 36 ^M

P.

