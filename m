Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbaGNVcC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:32:02 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:52213 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878AbaGNVb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:31:59 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVz7a7RVLhYTrGvHkJR2dGHJbRuATOaWaXgkrSABR7YFA@mail.gmail.com>
References: <CALCETrXrVNKNQtxncfOth5OqaSOC7KygerbB-+QQb4_VKESVsA@mail.gmail.com>
 <53C40D83.3090501@zytor.com> <CALCETrU44CM5=hSOMQGB6eEM2g-h6y5_+-SwoMwu+-qp-Pxd7g@mail.gmail.com>
 <CALCETrVz7a7RVLhYTrGvHkJR2dGHJbRuATOaWaXgkrSABR7YFA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 14 Jul 2014 14:31:37 -0700
Message-ID: <CALCETrU9dmM+bsQYwULjiqw5+erKsu5yUmHJDGYUW1wpcdp-5Q@mail.gmail.com>
Subject: Re: Is espfix64's double-fault thing OK on Xen?
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm now rather confused.

On Xen 64-bit, AFAICS, syscall handlers run with CS = 0xe033.  I think
that Xen is somehow fixing up traps that came from "kernel" mode to
show CS = 0xe030, which is an impossible selector value (unless that
segment is conforming) to keep user_mode_vm happy.

I'm running this test:

https://gitorious.org/linux-test-utils/linux-clock-tests/source/1e13516a41416a7282f43c83097c9dfe4619344b:sigreturn.c

It requires a kernel with my SS sigcontext change; otherwise it
doesn't do anything.

Without Xen, it works reliably.  On Xen, it seems to OOPS some
fraction of the time.  It gets a null pointer dereference here:

    movq %rax,(0*8)(%rdi)    /* RAX */

It looks like:

[    0.565752] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[    0.566706] IP: [<ffffffff81775493>] irq_return_ldt+0x11/0x5c
[    0.566706] PGD 4eb40067 PUD 4eb38067 PMD 0
[    0.566706] Oops: 0002 [#1] SMP
[    0.566706] Modules linked in:
[    0.566706] CPU: 1 PID: 81 Comm: sigreturn Not tainted 3.16.0-rc4+ #47
[    0.566706] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.566706] task: ffff88004e8aa180 ti: ffff88004eb68000 task.ti:
ffff88004eb68000
[    0.566706] RIP: e030:[<ffffffff81775493>]  [<ffffffff81775493>]
irq_return_ldt+0x11/0x5c
[    0.566706] RSP: e02b:ffff88004eb6bfc8  EFLAGS: 00010002
[    0.566706] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffffffffffff
[    0.566706] RDX: 000000000000000a RSI: 0000000000000051 RDI: 0000000000000000
[    0.566706] RBP: 00000000006d3018 R08: 0000000000000000 R09: 0000000000000000
[    0.566706] R10: 0000000000000008 R11: 0000000000000202 R12: 0000000000000000
[    0.566706] R13: 0000000000000001 R14: 000000000040eec0 R15: 0000000000000000
[    0.566706] FS:  0000000000000000(0063) GS:ffff880056300000(0000)
knlGS:0000000000000000
[    0.566706] CS:  e033 DS: 000f ES: 000f CR0: 0000000080050033
[    0.566706] CR2: 0000000000000000 CR3: 000000004eb3c000 CR4: 0000000000042660
[    0.566706] Stack:
[    0.566706]  0000000000000051 0000000000000000 0000000000000000
0000000000000007
[    0.566706]  0000000000000202 8badf00d5aad0000 000000000000000f
[    0.566706] Call Trace:
[    0.566706] Code: 44 24 20 04 75 14 e9 9d 5a 89 ff 90 66 66 66 2e
0f 1f 84 00 00 00 00 00 48 cf 50 57 66 66 90 66 66 90 65 48 8b 3c 25
00 b0 00 00 <48> 89 07 48 8b 44 24 10 48 89 47 08 48 8b 44 24 18 48 89
47 10
[    0.566706] RIP  [<ffffffff81775493>] irq_return_ldt+0x11/0x5c
[    0.566706]  RSP <ffff88004eb6bfc8>
[    0.566706] CR2: 0000000000000000
[    0.566706] ---[ end trace a62b7f28ce379a48 ]---

When it doesn't OOPS, it segfaults.  I don't know why.  I suspect that
Xen either has a bug in modify_ldt, sigreturn, or iret when returning
to a CS that lives in the LDT.


--Andy
