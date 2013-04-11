Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935675Ab3DKOXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:23:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58202 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab3DKOXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:23:39 -0400
Date: Thu, 11 Apr 2013 16:23:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86, FPU: Fix FPU initialization
Message-ID: <20130411142331.GD27062@pd.tnic>
References: <1365436666-9837-1-git-send-email-bp@alien8.de>
 <20130410110840.GA29752@gmail.com>
 <20130410122411.GE13394@pd.tnic>
 <20130410122527.GB8686@gmail.com>
 <20130410133251.GC6857@pd.tnic>
 <516586CF.90909@zytor.com>
 <20130410161122.GI6857@pd.tnic>
 <20130410212950.GA6899@pd.tnic>
 <20130411120952.GA18879@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130411120952.GA18879@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 02:09:52PM +0200, Ingo Molnar wrote:
> Even with this applied, the attached config is still unhappy and
> crashes/locks up during user-space init, see the crashlog attached
> below.
>
> The config has MATH_EMULATION=y, so I suspect it's the same problem
> category.
>
> (I'll keep tip:x86/cpu excluded from tip:master so that others are not
> affected by this bug.)

Right,

of course, I can't trigger it here :(

Let's see:

> INIT: version 2.86 booting
> [   14.723352] mount (55) used greatest stack depth: 5820 bytes left
> [   14.723352] mount (55) used greatest stack depth: 5820 bytes left

Don't you just hate the repeated lines? :-)

> [   15.187354] awk (64) used greatest stack depth: 5816 bytes left
> [   15.187354] awk (64) used greatest stack depth: 5816 bytes left
> 		Welcome to [   15.327059] gzip (70) used greatest stack depth: 5576 bytes left
> [   15.327059] gzip (70) used greatest stack depth: 5576 bytes left
> Fedora Core
> 		Press 'I' to enter interactive startup.
> modprobe: FATAL: Could not load /lib/modules/3.9.0-rc6+/modules.dep: No such file or directory
> 
> [   15.921486] BUG: unable to handle kernel [   15.921486] BUG: unable to handle kernel paging requestpaging request at 0000407a
>  at 0000407a
> [   15.921486] IP:[   15.921486] IP: [<41071ab0>] __lock_acquire.isra.19+0x3e0/0xb00
>  [<41071ab0>] __lock_acquire.isra.19+0x3e0/0xb00
> [   15.921486] *pde = 00000000 [   15.921486] *pde = 00000000 
> 
> [   15.921486] Oops: 0002 [#1] [   15.921486] Oops: 0002 [#1] SMP SMP 
> 
> [   15.921486] Modules linked in:[   15.921486] Modules linked in:
> 
> [   15.921486] Pid: 73, comm: hwclock Tainted: G        W    3.9.0-rc6+ #222032 System manufacturer System Product Name/A8N-E
> [   15.921486] Pid: 73, comm: hwclock Tainted: G        W    3.9.0-rc6+ #222032 System manufacturer System Product Name/A8N-E

Ok, so you're running a M686 32-bit kernel on an Athlon 64?

Also, what exactly is that kernel: 3.9.0-rc6+? tip:x86/cpu is
v3.9-rc5-11-g3019653a5758

> [   15.921486] EIP: 0060:[<41071ab0>] EFLAGS: 00013002 CPU: 0
> [   15.921486] EIP: 0060:[<41071ab0>] EFLAGS: 00013002 CPU: 0
> [   15.921486] EIP is at __lock_acquire.isra.19+0x3e0/0xb00
> [   15.921486] EIP is at __lock_acquire.isra.19+0x3e0/0xb00
> [   15.921486] EAX: 7e917f94 EBX: 00003f76 ECX: 00000000 EDX: 00000000
> [   15.921486] EAX: 7e917f94 EBX: 00003f76 ECX: 00000000 EDX: 00000000
> [   15.921486] ESI: 00000000 EDI: 7e9469c0 EBP: 7e9cfed8 ESP: 7e9cfe88
> [   15.921486] ESI: 00000000 EDI: 7e9469c0 EBP: 7e9cfed8 ESP: 7e9cfe88
> [   15.921486]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [   15.921486]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [   15.921486] CR0: 8005003b CR2: 0000407a CR3: 01768000 CR4: 00000690
> [   15.921486] CR0: 8005003b CR2: 0000407a CR3: 01768000 CR4: 00000690
> [   15.921486] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   15.921486] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   15.921486] DR6: ffff0ff0 DR7: 00000400
> [   15.921486] DR6: ffff0ff0 DR7: 00000400
> [   15.921486] Process hwclock (pid: 73, ti=7e9ce000 task=7e9469c0 task.ti=7e9ce000)
> [   15.921486] Process hwclock (pid: 73, ti=7e9ce000 task=7e9469c0 task.ti=7e9ce000)
> [   15.921486] Stack:
> [   15.921486] Stack:
> [   15.921486]  00000003[   15.921486]  00000003 b4fe9c00 b4fe9c00 00000003 00000003 00000001 00000001 7e999500 7e999500 00000000 00000000 7e999d00 7e999d00 7e995340 7e995340
> 
> [   15.921486]  00003002[   15.921486]  00003002 7e8e8920 7e8e8920 7e9c0207 7e9c0207 80100008 80100008 7e999500 7e999500 7e9c0207 7e9c0207 7e946d24 7e946d24 7e946d20 7e946d20
> 
> [   15.921486]  7e917f94[   15.921486]  7e917f94 00000000 00000000 7e9469c0 7e9469c0 00003246 00003246 7e9cff00 7e9cff00 4107264d 4107264d 00000000 00000000 00000000 00000000
> 
> [   15.921486] Call Trace:
> [   15.921486] Call Trace:
> [   15.921486]  [<4107264d>] lock_acquire+0x5d/0x80
> [   15.921486]  [<4107264d>] lock_acquire+0x5d/0x80
> [   15.921486]  [<41109905>] ? exit_fs+0x35/0x70
> [   15.921486]  [<41109905>] ? exit_fs+0x35/0x70

Right, so I can't see how exit_fs grabbing a bunch of locks could be
related to MATH_EMULATION. I'm not saying it can't - I just don't see it
from the trace.

> [   15.921486]  [<413deba1>] _raw_spin_lock+0x41/0x70
> [   15.921486]  [<413deba1>] _raw_spin_lock+0x41/0x70
> [   15.921486]  [<41109905>] ? exit_fs+0x35/0x70
> [   15.921486]  [<41109905>] ? exit_fs+0x35/0x70
> [   15.921486]  [<41109905>] exit_fs+0x35/0x70
> [   15.921486]  [<41109905>] exit_fs+0x35/0x70
> [   15.921486]  [<4102ddab>] do_exit+0x2fb/0x850
> [   15.921486]  [<4102ddab>] do_exit+0x2fb/0x850
> [   15.921486]  [<4102e48c>] do_group_exit+0x6c/0xb0
> [   15.921486]  [<4102e48c>] do_group_exit+0x6c/0xb0
> [   15.921486]  [<4102e4e3>] sys_exit_group+0x13/0x20
> [   15.921486]  [<4102e4e3>] sys_exit_group+0x13/0x20
> [   15.921486]  [<413e4f05>] sysenter_do_call+0x12/0x31
> [   15.921486]  [<413e4f05>] sysenter_do_call+0x12/0x31
> [   15.921486] Code:[   15.921486] Code: 00 00 83 83 3d 3d c0 c0 14 14 d0 d0 41 41 00 00 0f 0f 85 85 18 18 05 05 00 00 00 00 ba ba 34 34 03 03 00 00 00 00 b8 b8 cb cb e0 e0 4e 4e 41 41 e8 e8 ee ee 74 74 fb fb ff ff e9 e9 04 04 05 05 00 00 00 00 85 85 db db 0f 0f 84 84 fc fc 04 04 00 00 00 00 90 90 <3e> <3e> ff ff 83 83 04 04 01 01 00 00 00 00 a1 a1 48 48 48 48 77 77 41 41 8b 8b b7 b7 5c 5c 03 03 00 00 00 00 85 85 c0 c0 0f 0f
> 
> [   15.921486] EIP: [<41071ab0>] [   15.921486] EIP: [<41071ab0>] __lock_acquire.isra.19+0x3e0/0xb00__lock_acquire.isra.19+0x3e0/0xb00 SS:ESP 0068:7e9cfe88
>  SS:ESP 0068:7e9cfe88
> [   15.921486] CR2: 000000000000407a
> [   15.921486] CR2: 000000000000407a
> [   15.921486] ---[ end trace 630c66e4c0c7a4b4 ]---
> [   15.921486] ---[ end trace 630c66e4c0c7a4b4 ]---

Ok, so I can't trigger this in kvm. What happens here is that the guest
simply reboots.

Can you please checkout tip:x86/cpu to the commit before the FPU patch,
i.e. before this one:

commit c70293d0e3fef6b989cd8268027d410cf06ce384
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Mon Apr 8 17:57:43 2013 +0200

    x86: Get rid of ->hard_math and all the FPU asm fu

and see whether it still triggers or not.

That would give us some triage insights on what's going on.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
