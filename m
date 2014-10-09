Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbaJIJBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 05:01:48 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:59220 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbaJIJBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 05:01:41 -0400
MIME-Version: 1.0
Date: Thu, 9 Oct 2014 11:01:39 +0200
Message-ID: <CAFLxGvyMO-HCaVOghrjXZkAEtmytrDgi4CqiRs0nFzQSnvg4UA@mail.gmail.com>
Subject: trace_printk() broken wrt %pV
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

my code does something like:

void my_printf(const char *fmt, ...)
{
        struct va_format vaf;
        va_list args;

        va_start(args, fmt);
        vaf.fmt = fmt;
        vaf.va = &args;
        trace_printk("%pV", &vaf);
        va_end(args);
}

While reading from /sys/kernel/debug/tracing/trace a kernel oops happens.

[   54.406617] BUG: unable to handle kernel paging request at ffffffffffffffff
[   54.407078] IP: [<ffffffff81358f3c>] pointer.isra.18+0x1fc/0x450
[   54.407078] PGD 1e14067 PUD 1e16067 PMD 0
[   54.407078] Oops: 0000 [#1] PREEMPT SMP
[   54.407078] Modules linked in:
[   54.407078] CPU: 1 PID: 2700 Comm: cat Not tainted 3.17.0-rc6+ #274
[   54.407078] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.7.5-0-ge51488c-20140816_022509-build35 04/01/2014
[   54.407078] task: ffff8800391c1660 ti: ffff880035fe4000 task.ti:
ffff880035fe4000
[   54.407078] RIP: 0010:[<ffffffff81358f3c>]  [<ffffffff81358f3c>]
pointer.isra.18+0x1fc/0x450
[   54.407078] RSP: 0018:ffff880035fe7d20  EFLAGS: 00010283
[   54.407078] RAX: ffffffffffffffff RBX: 0000000000000010 RCX: ffff880035fe7d38
[   54.407078] RDX: ffff880035fea0fb RSI: ffff880035fe9137 RDI: ffff880035fe9137
[   54.407078] RBP: ffff880035fe7d78 R08: 0000000000000000 R09: 000000000000000a
[   54.407078] R10: 0000000000000014 R11: ffffffff815633e0 R12: ffff88000013fdd0
[   54.407078] R13: ffff880035fe9137 R14: ffff880035fea0fb R15: ffff880035fe9137
[   54.407078] FS:  00007f4c7627f700(0000) GS:ffff88003e000000(0000)
knlGS:0000000000000000
[   54.407078] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   54.407078] CR2: ffffffffffffffff CR3: 0000000038459000 CR4: 00000000000006e0
[   54.407078] Stack:
[   54.407078]  ffff880035fea0fb ffff880035fe7d90 ffffffff81359414
000000000000ffff
[   54.407078]  fffffffdff0a0003 0000000000000002 ffff880035fea0fb
ffff88003cfac03c
[   54.407078]  ffffffff81cefe16 ffffffff81cefe16 ffff880035fe9137
ffff880035fe7de8
[   54.407078] Call Trace:
[   54.407078]  [<ffffffff81359414>] ? vsnprintf+0x284/0x590
[   54.407078]  [<ffffffff8135990c>] bstr_printf+0xcc/0x3e0
[   54.407078]  [<ffffffff810fed03>] ? trace_seq_printf+0x83/0xd0
[   54.407078]  [<ffffffff810fedfb>] trace_seq_bprintf+0x4b/0x90
[   54.407078]  [<ffffffff810fe413>] trace_bprint_print+0x63/0x90
[   54.407078]  [<ffffffff810fadc3>] print_trace_line+0x183/0x440
[   54.407078]  [<ffffffff810fba3b>] s_show+0x2b/0xc0
[   54.407078]  [<ffffffff81199df6>] seq_read+0x226/0x3a0
[   54.407078]  [<ffffffff81175576>] vfs_read+0x96/0x180
[   54.407078]  [<ffffffff81176214>] SyS_read+0x44/0xb0
[   54.407078]  [<ffffffff818fa892>] system_call_fastpath+0x16/0x1b
[   54.407078] Code: 10 4c 89 e2 48 89 3c 24 4c 89 f6 4c 89 ef e8 8c
f2 ff ff e9 8f fe ff ff 0f 1f 80 00 00 00 00 49 8b 44 24 08 48 8d 4d
c0 4c 89 ef <48> 8b 10 48 89 55 c0 48 8b 50 08 48 89 55 c8 48 8b 40 10
49 8b
[   54.407078] RIP  [<ffffffff81358f3c>] pointer.isra.18+0x1fc/0x450
[   54.407078]  RSP <ffff880035fe7d20>
[   54.407078] CR2: ffffffffffffffff
[   54.407078] ---[ end trace 2e14557c4e24855c ]---

-- 
Thanks,
//richard
