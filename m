Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937058Ab3DJQL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:11:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54925 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935205Ab3DJQL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:11:26 -0400
Date: Wed, 10 Apr 2013 18:11:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 0/4] x86: FPU detection in C
Message-ID: <20130410161122.GI6857@pd.tnic>
References: <1365436666-9837-1-git-send-email-bp@alien8.de>
 <20130410110840.GA29752@gmail.com>
 <20130410122411.GE13394@pd.tnic>
 <20130410122527.GB8686@gmail.com>
 <20130410133251.GC6857@pd.tnic>
 <516586CF.90909@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <516586CF.90909@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 08:35:43AM -0700, H. Peter Anvin wrote:
> OK, this thread took off in another direction but you're still looking
> at this, right?

Yep, and I think I have the rootcause, let's start (oops below for
info).

When the oops happens, we're on the following path:

start_kernel
|-> trap_init
    |-> cpu_init
        |-> fpu_init

and down that path we do mxcsr_feature_mask_init() at some point which does

	b13cf456:       0f ae 05 80 54 58 b1    fxsave 0xb1585480

This causes an #NM for the first time since we have CR0.EM set. We enter
the handler do_device_not_available which calls into math_emulate()
because we have CONFIG_MATH_EMULATION on.

It, in the beginning, does init_fpu(current) which does fpu_alloc, which in
turn, does kmem_cache_alloc(task_xstate_cachep...

Since we have SLUB on in this particular .config, we go to
slab_alloc_node() in slub.c and the following code (cf. the Code section
below):

kmem_cache_alloc:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
	pushl	%edi	#
	pushl	%esi	#
	pushl	%ebx	#
	subl	$32, %esp	#,
	call	mcount
	movl	%eax, %edi	# s, s
	movl	%edx, -28(%ebp)	# gfpflags, %sfp
.L825:
	movl	(%edi), %eax	# s_3(D)->cpu_slab, tcp_ptr__		<---
#APP
# 2341 "mm/slub.c" 1
	add %fs:this_cpu_off, %eax	# this_cpu_off, tcp_ptr__
# 0 "" 2
#NO_APP

and %edi, is of course, 0.

Finally, this happens because we haven't initialized task_xstate_cachep.

We still do the initialization albeit a bit further down in the same
function:

start_kernel
|-> fork_init(totalram_pages)
    |-> arch_task_cache_init

This, however, is *after* trap_init -> Boom.

Provided I haven't made a mistake, this is the problem we're seeing.

[    0.000000] Initializing CPU#0
[    0.000000] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.000000] IP: [<b10fa893>] kmem_cache_alloc+0x13/0x130
[    0.000000] *pde = 00000000 
[    0.000000] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 3.9.0-rc5+ #2  
[    0.000000] EIP: 0060:[<b10fa893>] EFLAGS: 00210046 CPU: 0
[    0.000000] EIP is at kmem_cache_alloc+0x13/0x130
[    0.000000] EAX: 00000000 EBX: b1557fa0 ECX: 0000007b EDX: 000000d0
[    0.000000] ESI: f77df9a0 EDI: 00000000 EBP: b154dea4 ESP: b154de78
[    0.000000]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    0.000000] CR0: 80050037 CR2: 00000000 CR3: 015e8000 CR4: 00000290
[    0.000000] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    0.000000] DR6: ffff0ff0 DR7: 00000400
[    0.000000] Process swapper (pid: 0, ti=b154c000 task=b1557fa0 task.ti=b154c000)
[    0.000000] Stack:
[    0.000000]  3b9aca00 00000000 b154de8c b11d033c 000000d0 b154deb8 b1028952 b16f4040
[    0.000000]  b1557fa0 f77df9a0 b13de290 b154deb0 b1009897 b154df44 b154df3c b1320715
[    0.000000]  b154ded8 b1028e00 00000000 00000000 b16f4062 00000001 b154dee0 00200046
[    0.000000] Call Trace:
[    0.000000]  [<b11d033c>] ? sprintf+0x1c/0x20
[    0.000000]  [<b1028952>] ? print_time.part.5+0x82/0xc0
[    0.000000]  [<b13de290>] ? do_debug+0x150/0x150
[    0.000000]  [<b1009897>] init_fpu+0x67/0xa0
[    0.000000]  [<b1320715>] math_emulate+0x695/0xc40
[    0.000000]  [<b1028e00>] ? print_prefix+0x60/0xa0
[    0.000000]  [<b13e04e8>] ? sub_preempt_count+0x8/0x80
[    0.000000]  [<b13e04e8>] ? sub_preempt_count+0x8/0x80
[    0.000000]  [<b1029899>] ? wake_up_klogd+0x49/0x70
[    0.000000]  [<b1029c25>] ? console_unlock+0x365/0x4c0
[    0.000000]  [<b13de290>] ? do_debug+0x150/0x150
[    0.000000]  [<b13de2ce>] do_device_not_available+0x3e/0x80
[    0.000000]  [<b13ddc6c>] error_code+0x6c/0x74
[    0.000000]  [<b13cf456>] ? fpu_init+0x80/0xf5
[    0.000000]  [<b13d14b1>] cpu_init+0x2b0/0x2b8
[    0.000000]  [<b1594335>] trap_init+0x243/0x24b
[    0.000000]  [<b159289f>] start_kernel+0x1a2/0x34f
[    0.000000]  [<b1592532>] ? repair_env_string+0x51/0x51
[    0.000000]  [<b1592376>] i386_start_kernel+0x12c/0x12f
[    0.000000] Code: 0c 89 f0 e8 50 f4 ff ff 5b 5e 5d c3 8d b6 00 00 00 00 8d bf 00 00 00 00 55 89 e5 57 56 53 83 ec 20 e8 72 93 2e 00 89 c7 89 55 e4 <8b> 07 64 03 05 94 b6 5d b1 8b 58 04 8b 00 85 c0 89 45 ec 74 76
[    0.000000] EIP: [<b10fa893>] kmem_cache_alloc+0x13/0x130 SS:ESP 0068:b154de78
[    0.000000] CR2: 0000000000000000
[    0.000000] ---[ end trace a7919e7f17c0a725 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
