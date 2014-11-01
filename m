Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084AbaKABAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 21:00:38 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:59385 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbaKABAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 21:00:37 -0400
MIME-Version: 1.0
In-Reply-To: <877fzf4vqg.fsf@rustcorp.com.au>
References: <cover.1412189265.git.luto@amacapital.net> <877fzf4vqg.fsf@rustcorp.com.au>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 31 Oct 2014 18:00:14 -0700
Message-ID: <CALCETrWJ4-PaLpceb7NCm6pKgkNXh77x1F6XHHxafcvBRFAoxg@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] x86_64,entry: Clear NT on entry and speed up switch_to
To: Rusty Russell <rusty@ozlabs.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Sebastian Lackner <sebastian@fds-team.de>,
        Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 5:20 PM, Rusty Russell <rusty@ozlabs.org> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>> Anish Bhatt noticed that user programs can set RFLAGS.NT before
>> syscall or sysenter, and the kernel entry code doesn't filter out
>> NT.  This causes kernel C code and, depending on thread flags, the
>> exit slow path to run with NT set.
>
> OK, this causes oopsen as a guest under kvm for me.  Details below:
>
> commit 8c7aa698baca5e8f1ba9edb68081f1e7a1abf455
> Author: Andy Lutomirski <luto@amacapital.net>
> Date:   Wed Oct 1 11:49:04 2014 -0700
>
>     x86_64, entry: Filter RFLAGS.NT on entry from userspace

Well, crap.

>
> Some dmesg:
>

> [    1.126953] BUG: unable to handle kernel paging request at ffff88001da4c018
> [    1.128482] IP: [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
> [    1.129513] PGD 2d6c067 PUD 2d6d067 PMD 1fdf4067 PTE 800000001da4c060
> [    1.129513] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> [    1.129513] Modules linked in:
> [    1.129513] CPU: 0 PID: 69 Comm: init Not tainted 3.17.0-rc7+ #245
> [    1.129513] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_171129-lamiak 04/01/2014
> [    1.129513] task: ffff88001da08000 ti: ffff88001da48000 task.ti: ffff88001da48000
> [    1.129513] RIP: 0010:[<ffffffff8170703d>]  [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
> [    1.129513] RSP: 0018:ffff88001da4bf88  EFLAGS: 00010296

So we're 0x78 bytes below the page boundary...

> [    1.129513] RAX: 0000000000000137 RBX: 00000000f754e730 RCX: 000000000000000c
> [    1.129513] RDX: 00000000f7711000 RSI: 0000000000000000 RDI: 00000000f77c3040
> [    1.129513] RBP: 00000000ffca97c8 R08: ffffffff8138aa0b R09: 00000000ffcaba58
> [    1.129513] R10: 00000000f77a1b70 R11: 0000000000000000 R12: 0000000000000000
> [    1.129513] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [    1.129513] FS:  0000000000000000(0000) GS:ffff88001fa00000(0063) knlGS:00000000f754e6c0
> [    1.129513] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> [    1.129513] CR2: ffff88001da4c018 CR3: 000000001da2c000 CR4: 00000000000006f0
> [    1.129513] Stack:
> [    1.129513]  0000000000000000 0000000000000000 00000000ffcaba58 ffffffff8138aa0b
> [    1.129513]  0000000000000137 000000000000000c 00000000f7711000 0000000000000000
> [    1.129513]  00000000f77c3040 0000000000000137 00000000f77a1b70 0000000000000023
> [    1.129513] Call Trace:
> [    1.129513]  [<ffffffff8138aa0b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [    1.129513] Code: c0 41 52 50 fc 48 83 ec 48 48 89 7c 24 40 48 89 74 24 38 48 89 54 24 30 48 89 4c 24 28 48 89 44 24 20 66 66 90 8b 6d 00 66 66 90 <f7> 84 24 90 00 00 00 00 40 00 00 0f 85 2f 01 00 00 83 8c 24 8c

   0:    c0 41 52 50              rolb   $0x50,0x52(%rcx)
   4:    fc                       cld
   5:    48 83 ec 48              sub    $0x48,%rsp
   9:    48 89 7c 24 40           mov    %rdi,0x40(%rsp)
   e:    48 89 74 24 38           mov    %rsi,0x38(%rsp)
  13:    48 89 54 24 30           mov    %rdx,0x30(%rsp)
  18:    48 89 4c 24 28           mov    %rcx,0x28(%rsp)
  1d:    48 89 44 24 20           mov    %rax,0x20(%rsp)
  22:    66 66 90                 data32 xchg %ax,%ax
  25:    8b 6d 00                 mov    0x0(%rbp),%ebp
  28:    66 66 90                 data32 xchg %ax,%ax
  2b:*    f7 84 24 90 00 00 00     testl  $0x4000,0x90(%rsp)
<-- trapping instruction

This seems to be just slightly out of bounds.

[Insert large number of expletives here]  This is really bad.  It
worked when I tested it because of dumb luck.  If I read random
garbage there, there's a pretty good chance that the code will work.
But somehow you're right at the end of the entire memory map, and
you're totally screwed.

Fix coming.
