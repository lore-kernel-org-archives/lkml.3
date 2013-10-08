Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab3JHCnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 22:43:31 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:32830 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab3JHCn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 22:43:29 -0400
MIME-Version: 1.0
In-Reply-To: <20131008020918.GA1220@localhost>
References: <20131006082340.GA24568@localhost>
	<CA+55aFxk2FoG7+BpHJAysR2bz-WQXpje6buMd8Sp6-SBqHexZg@mail.gmail.com>
	<20131007021118.GA27927@localhost>
	<20131007051038.GA9764@localhost>
	<CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com>
	<20131007083505.GA22585@localhost>
	<CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com>
	<CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com>
	<20131008020918.GA1220@localhost>
Date: Mon, 7 Oct 2013 19:43:28 -0700
X-Google-Sender-Auth: _9yrV8o3pgUwfcN2-nk_-3VwFuo
Message-ID: <CA+55aFzRyMnuSW2mLUEwRj7RGmM1J95JjnPNX4YJijb4zR0L8Q@mail.gmail.com>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 7, 2013 at 7:09 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>
> Thanks for the hints! I run a kernel with pr_alert() for several times
> and here is the screen log. Note that this kernel is compiled with gcc
> 4.6.3 and the decoded code looks different than gcc 4.8.1

Ok, I think we have something.

> NULL pointer dereference at 0000000000000008
> [    3.901119] IP: [<ffffffff81098f60>] run_timer_softirq+0x126/0x1da
> [    3.901119] PGD 0
> [    3.901119] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [    3.901119] CPU: 1 PID: 22 Comm: kworker/1:1 Not tainted 3.11.0-rc2-00010-gc817a67-dirty #5
> [    3.901119] Workqueue: events power_supply_changed_work
> [    3.901119] task: ffff8800002dc5c0 ti: ffff8800002de000 task.ti: ffff8800002de000
> [    3.901119] RIP: 0010:[<ffffffff81098f60>]  [<ffffffff81098f60>] run_timer_softirq+0x126/0x1da
> [    3.901119] RSP: 0000:ffff88000dd03ea8  EFLAGS: 00010002
> [    3.901119] RAX: ffff880006dc28a0 RBX: ffff88000015c000 RCX: ffff88000dd03ec8
> [    3.901119] RDX: ffff880006dc2860 RSI: ffffffff810a1b7b RDI: 0000000000000000
> [    3.901119] RBP: ffff88000dd03f08 R08: 0000000000000002 R09: dead000000200200
> [    3.901119] R10: ffff88000015c018 R11: ffff8800002dc5c0 R12: ffff88000dd03ec8
> [    3.901119] R13: ffff88000015d858 R14: ffff88000015d458 R15: ffff88000015d058
> [    3.901119] FS:  0000000000000000(0000) GS:ffff88000dd00000(0000) knlGS:0000000000000000
> [    3.901119] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    3.901119] CR2: 0000000000000008 CR3: 0000000001c47000 CR4: 00000000000006a0
> [    3.901119] Stack:
> [    3.901119]  ffff88000dd0e1b0 ffff88000dd0e170 ffffffff810a1b7b 000000c000000000
> [    3.901119]  ffff880006dc28a0 ffff88000dd0e300 ffff88000dd03ef8 ffff8800002dffd8
> [    3.901119]  ffffffff81c43088 0000000010000100 0000000000000141 0000000000000001
> [    3.901119] Call Trace:
> [    3.901119]  <IRQ>
> [    3.901119]  [<ffffffff810a1b7b>] ? __queue_work+0x1ee/0x1ee
> [    3.901119]  [<ffffffff8109555f>] __do_softirq+0xc6/0x18f
> [    3.901119]  [<ffffffff81095745>] irq_exit+0x58/0x9e
> [    3.901119]  [<ffffffff81044e69>] smp_apic_timer_interrupt+0x31/0x3e
> [    3.901119]  [<ffffffff8185a772>] apic_timer_interrupt+0x72/0x80
> [    3.901119]  <EOI>
> [    3.901119]  [<ffffffff81859277>] ? retint_restore_args+0x13/0x13
> [    3.901119]  [<ffffffff810af994>] ? arch_local_irq_enable+0xb/0xd
> [    3.901119]  [<ffffffff810c707f>] ? trace_hardirqs_on+0xd/0xf
> [    3.901119]  [<ffffffff81857904>] preempt_schedule_irq+0x36/0x5a
> [    3.901119]  [<ffffffff818593a6>] retint_kernel+0x26/0x30
> [    3.901119]  [<ffffffff8108f47c>] ? arch_local_irq_restore+0x6/0xd
> [    3.901119]  [<ffffffff81090db8>] vprintk_emit+0x3f9/0x422
> [    3.901119]  [<ffffffff8121a640>] ? snprintf+0x34/0x36
> [    3.901119]  [<ffffffff81483ca2>] dev_vprintk_emit+0x1a3/0x1c9
> [    3.901119]  [<ffffffff81219385>] ? string.isra.3+0x3d/0xa2
> [    3.901119]  [<ffffffff81483cfc>] dev_printk_emit+0x34/0x36
> [    3.901119]  [<ffffffff81483d6f>] __dev_printk+0x71/0x78
> [    3.901119]  [<ffffffff81483db6>] dev_printk+0x40/0x42
> [    3.901119]  [<ffffffff8111b1b4>] ? __kmalloc+0x93/0xb8
> [    3.901119]  [<ffffffff815dd5a4>] power_supply_uevent+0x183/0x1ec
> [    3.901119]  [<ffffffff81483451>] dev_uevent+0x179/0x1a2
> [    3.901119]  [<ffffffff812130dc>] ? kzalloc+0xf/0x11
> [    3.901119]  [<ffffffff812142ce>] kobject_uevent_env+0x195/0x414
> [    3.901119]  [<ffffffff81214558>] kobject_uevent+0xb/0xd
> [    3.901119]  [<ffffffff815dcc14>] power_supply_changed_work+0x60/0x65
> [    3.901119]  [<ffffffff810a2733>] process_one_work+0x1de/0x2fd
> [    3.901119]  [<ffffffff810a26c9>] ? process_one_work+0x174/0x2fd
> [    3.901119]  [<ffffffff810a2c54>] worker_thread+0x159/0x1ee
> [    3.901119]  [<ffffffff810a2afb>] ? rescuer_thread+0x27f/0x27f
> [    3.901119]  [<ffffffff810a859a>] kthread+0xac/0xb4
> [    3.901119]  [<ffffffff810a84ee>] ? __kthread_parkme+0x68/0x68
> [    3.901119]  [<ffffffff81859a3c>] ret_from_fork+0x7c/0xb0
> [    3.901119]  [<ffffffff810a84ee>] ? __kthread_parkme+0x68/0x68
> [    3.901119] Code: 08 e9 99 00 00 00 4c 8b 40 18 48 8b 70 20 49 b9 00 02 20 00 00 00 ad de 48 8b 50 28 48 89 43 38 48 8b 38 48 8b 48 08 41 83 e0 02 <48> 89 4f 08 48 89 39 f6 40 18 01 48 c7 00 00 00 00 00 4c 89 48
> [    3.901119] RIP  [<ffffffff81098f60>] run_timer_softirq+0x126/0x1da

So this is the same bug, now the code decodes to

   5: 4c 8b 40 18           mov    0x18(%rax),%r8
   9: 48 8b 70 20           mov    0x20(%rax),%rsi
   d: 49 b9 00 02 20 00 00 movabs $0xdead000000200200,%r9
  14: 00 ad de
  17: 48 8b 50 28           mov    0x28(%rax),%rdx
  1b: 48 89 43 38           mov    %rax,0x38(%rbx)
  1f: 48 8b 38             mov    (%rax),%rdi
  22: 48 8b 48 08           mov    0x8(%rax),%rcx
  26: 41 83 e0 02           and    $0x2,%r8d
  2a:* 48 89 4f 08           mov    %rcx,0x8(%rdi) <-- trapping instruction
  2e: 48 89 39             mov    %rdi,(%rcx)
  31: f6 40 18 01           testb  $0x1,0x18(%rax)
  35: 48 c7 00 00 00 00 00 movq   $0x0,(%rax)

so the NULL pointer in %rdi (which _should_ be a list pointer) got
loaded from %rax. So the prime suspect is an allocation near

  RAX: ffff880006dc28a0.

and looking backwards in your dump, we have

[    2.807742] kobject: 'parport_pc.888' (ffff880006dc2020):
kobject_release, parent           (null) (delayed)
[    2.810494] kobject: 'parport_pc.632' (ffff880006dca820):
kobject_release, parent           (null) (delayed)

so it looks like that "parparport_pc.632" thing.

Another one, same code:

> [    3.992074] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> [    3.994126] IP: [<ffffffff81098f60>] run_timer_softirq+0x126/0x1da
> [    3.995677] PGD 0
> [    3.996037] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [    3.996037] CPU: 1 PID: 1 Comm: init Not tainted 3.11.0-rc2-00010-gc817a67-dirty #5
> [    3.996037] task: ffff88000010a040 ti: ffff88000010c000 task.ti: ffff88000010c000
> [    3.996037] RIP: 0010:[<ffffffff81098f60>]  [<ffffffff81098f60>] run_timer_softirq+0x126/0x1da
> [    3.996037] RSP: 0000:ffff88000dd03ea8  EFLAGS: 00010002
> [    3.996037] RAX: ffff880006da20a0 RBX: ffff88000015c000 RCX: ffff88000dd03ec8

and for that boot we had

[    2.990338] kobject: 'parport_pc.956' (ffff880006da2020):
kobject_release, parent           (null) (delayed)
[    2.992654] kobject: 'parport_pc.888' (ffff880006db5820):
kobject_release, parent           (null) (delayed)
[    2.994905] kobject: 'parport_pc.632' (ffff880006db5020):
kobject_release, parent           (null) (delayed)

so now it's 'parport_pc.956'.

Anyway, that does look like a strong pattern.

Does the problem go away if you disable the parport_pc driver?

              Linus
