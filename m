Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbaFYPch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:32:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59664 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290AbaFYPce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:32:34 -0400
Date: Wed, 25 Jun 2014 17:32:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org
Subject: __schedule #DF splat
Message-ID: <20140625153227.GA13845@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

so I'm looking at this splat below when booting current linus+tip/master
in a kvm guest. Initially I thought this is something related to the
PARAVIRT gunk but it happens with and without it.

So, from what I can see, we first #DF and then lockdep fires a deadlock
warning. That I can understand but what I can't understand is why we #DF
with this RIP:

[    2.744062] RIP: 0010:[<ffffffff816139df>]  [<ffffffff816139df>] __schedule+0x28f/0xab0

disassembling this points to

	/*
	 * Since the runqueue lock will be released by the next
	 * task (which is an invalid locking op but in the case
	 * of the scheduler it's an obvious special-case), so we
	 * do an early lockdep release here:
	 */
#ifndef __ARCH_WANT_UNLOCKED_CTXSW
	spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
#endif

this call in context_switch() (provided this RIP is correct, of course).
(btw, various dumps at the end of this mail with the "<---- faulting"
marker).

And that's lock_release() in lockdep.c.

What's also interesting is that we have two __schedule calls on the stack
before #DF:

[    2.744062]  [<ffffffff816139ce>] ? __schedule+0x27e/0xab0
[    2.744062]  [<ffffffff816139df>] ? __schedule+0x28f/0xab0

The show_stack_log_lvl() I'm attributing to the userspace stack not
being mapped while we're trying to walk it (we do have a %cr3 write
shortly before the RIP we're faulting at) which is another snafu and
shouldn't happen, i.e., we should detect that and not walk it or
whatever...

Anyway, this is what I can see - any and all suggestions on how to debug
this further are appreciated. More info available upon request.

Thanks.

[    1.932807] devtmpfs: mounted
[    1.938324] Freeing unused kernel memory: 2872K (ffffffff819ad000 - ffffffff81c7b000)
[    2.450824] udevd[814]: starting version 175
[    2.743648] PANIC: double fault, error_code: 0x0
[    2.743657] 
[    2.744062] ======================================================
[    2.744062] [ INFO: possible circular locking dependency detected ]
[    2.744062] 3.16.0-rc2+ #2 Not tainted
[    2.744062] -------------------------------------------------------
[    2.744062] vmmouse_detect/957 is trying to acquire lock:
[    2.744062]  ((console_sem).lock){-.....}, at: [<ffffffff81092dcd>] down_trylock+0x1d/0x50
[    2.744062] 
[    2.744062] but task is already holding lock:
[    2.744062]  (&rq->lock){-.-.-.}, at: [<ffffffff8161382f>] __schedule+0xdf/0xab0
[    2.744062] 
[    2.744062] which lock already depends on the new lock.
[    2.744062] 
[    2.744062] 
[    2.744062] the existing dependency chain (in reverse order) is:
[    2.744062] 
-> #2 (&rq->lock){-.-.-.}:
[    2.744062]        [<ffffffff8109c0d9>] lock_acquire+0xb9/0x200
[    2.744062]        [<ffffffff81619111>] _raw_spin_lock+0x41/0x80
[    2.744062]        [<ffffffff8108090b>] wake_up_new_task+0xbb/0x290
[    2.744062]        [<ffffffff8104e847>] do_fork+0x147/0x770
[    2.744062]        [<ffffffff8104ee96>] kernel_thread+0x26/0x30
[    2.744062]        [<ffffffff8160e282>] rest_init+0x22/0x140
[    2.744062]        [<ffffffff81b82e3e>] start_kernel+0x408/0x415
[    2.744062]        [<ffffffff81b82463>] x86_64_start_reservations+0x2a/0x2c
[    2.744062]        [<ffffffff81b8255b>] x86_64_start_kernel+0xf6/0xf9
[    2.744062] 
-> #1 (&p->pi_lock){-.-.-.}:
[    2.744062]        [<ffffffff8109c0d9>] lock_acquire+0xb9/0x200
[    2.744062]        [<ffffffff81619333>] _raw_spin_lock_irqsave+0x53/0x90
[    2.744062]        [<ffffffff810803b1>] try_to_wake_up+0x31/0x450
[    2.744062]        [<ffffffff810807f3>] wake_up_process+0x23/0x40
[    2.744062]        [<ffffffff816177ff>] __up.isra.0+0x1f/0x30
[    2.744062]        [<ffffffff81092fc1>] up+0x41/0x50
[    2.744062]        [<ffffffff810ac7b8>] console_unlock+0x258/0x490
[    2.744062]        [<ffffffff810acc81>] vprintk_emit+0x291/0x610
[    2.744062]        [<ffffffff8161185c>] printk+0x4f/0x57
[    2.744062]        [<ffffffff81486ad1>] input_register_device+0x401/0x4d0
[    2.744062]        [<ffffffff814909b4>] atkbd_connect+0x2b4/0x2e0
[    2.744062]        [<ffffffff81481a3b>] serio_connect_driver+0x3b/0x60
[    2.744062]        [<ffffffff81481a80>] serio_driver_probe+0x20/0x30
[    2.744062]        [<ffffffff813cd8e5>] really_probe+0x75/0x230
[    2.744062]        [<ffffffff813cdbc1>] __driver_attach+0xb1/0xc0
[    2.744062]        [<ffffffff813cb97b>] bus_for_each_dev+0x6b/0xb0
[    2.744062]        [<ffffffff813cd43e>] driver_attach+0x1e/0x20
[    2.744062]        [<ffffffff81482ded>] serio_handle_event+0x14d/0x1f0
[    2.744062]        [<ffffffff8106c9d7>] process_one_work+0x1c7/0x680
[    2.744062]        [<ffffffff8106d77b>] worker_thread+0x6b/0x540
[    2.744062]        [<ffffffff81072ec8>] kthread+0x108/0x120
[    2.744062]        [<ffffffff8161a3ac>] ret_from_fork+0x7c/0xb0
[    2.744062] 
-> #0 ((console_sem).lock){-.....}:
[    2.744062]        [<ffffffff8109b564>] __lock_acquire+0x1f14/0x2290
[    2.744062]        [<ffffffff8109c0d9>] lock_acquire+0xb9/0x200
[    2.744062]        [<ffffffff81619333>] _raw_spin_lock_irqsave+0x53/0x90
[    2.744062]        [<ffffffff81092dcd>] down_trylock+0x1d/0x50
[    2.744062]        [<ffffffff810ac2ae>] console_trylock+0x1e/0xb0
[    2.744062]        [<ffffffff810acc63>] vprintk_emit+0x273/0x610
[    2.744062]        [<ffffffff8161185c>] printk+0x4f/0x57
[    2.744062]        [<ffffffff8103d10b>] df_debug+0x1b/0x40
[    2.744062]        [<ffffffff81003d1d>] do_double_fault+0x5d/0x80
[    2.744062]        [<ffffffff8161bf87>] double_fault+0x27/0x30
[    2.744062] 
[    2.744062] other info that might help us debug this:
[    2.744062] 
[    2.744062] Chain exists of:
  (console_sem).lock --> &p->pi_lock --> &rq->lock

[    2.744062]  Possible unsafe locking scenario:
[    2.744062] 
[    2.744062]        CPU0                    CPU1
[    2.744062]        ----                    ----
[    2.744062]   lock(&rq->lock);
[    2.744062]                                lock(&p->pi_lock);
[    2.744062]                                lock(&rq->lock);
[    2.744062]   lock((console_sem).lock);
[    2.744062] 
[    2.744062]  *** DEADLOCK ***
[    2.744062] 
[    2.744062] 1 lock held by vmmouse_detect/957:
[    2.744062]  #0:  (&rq->lock){-.-.-.}, at: [<ffffffff8161382f>] __schedule+0xdf/0xab0
[    2.744062] 
[    2.744062] stack backtrace:
[    2.744062] CPU: 0 PID: 957 Comm: vmmouse_detect Not tainted 3.16.0-rc2+ #2
[    2.744062] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.744062]  ffffffff823f00a0 ffff88007c205c50 ffffffff8161206f ffffffff823f2d30
[    2.744062]  ffff88007c205c90 ffffffff81095b3b ffffffff827f4980 ffff88007aab9ad8
[    2.744062]  ffff88007aab93a8 ffff88007aab9370 0000000000000001 ffff88007aab9aa0
[    2.744062] Call Trace:
[    2.744062]  <#DF>  [<ffffffff8161206f>] dump_stack+0x4e/0x7a
[    2.744062]  [<ffffffff81095b3b>] print_circular_bug+0x1fb/0x330
[    2.744062]  [<ffffffff8109b564>] __lock_acquire+0x1f14/0x2290
[    2.744062]  [<ffffffff8109c0d9>] lock_acquire+0xb9/0x200
[    2.744062]  [<ffffffff81092dcd>] ? down_trylock+0x1d/0x50
[    2.744062]  [<ffffffff81619333>] _raw_spin_lock_irqsave+0x53/0x90
[    2.744062]  [<ffffffff81092dcd>] ? down_trylock+0x1d/0x50
[    2.744062]  [<ffffffff810acc63>] ? vprintk_emit+0x273/0x610
[    2.744062]  [<ffffffff81092dcd>] down_trylock+0x1d/0x50
[    2.744062]  [<ffffffff810acc63>] ? vprintk_emit+0x273/0x610
[    2.744062]  [<ffffffff810ac2ae>] console_trylock+0x1e/0xb0
[    2.744062]  [<ffffffff810acc63>] vprintk_emit+0x273/0x610
[    2.744062]  [<ffffffff8161185c>] printk+0x4f/0x57
[    2.744062]  [<ffffffff8103d10b>] df_debug+0x1b/0x40
[    2.744062]  [<ffffffff81003d1d>] do_double_fault+0x5d/0x80
[    2.744062]  [<ffffffff8161bf87>] double_fault+0x27/0x30
[    2.744062]  [<ffffffff816139ce>] ? __schedule+0x27e/0xab0
[    2.744062]  [<ffffffff816139df>] ? __schedule+0x28f/0xab0
[    2.744062]  <<EOE>>  <UNK> 
[    2.744062] CPU: 0 PID: 957 Comm: vmmouse_detect Not tainted 3.16.0-rc2+ #2
[    2.744062] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.744062] task: ffff88007aab9370 ti: ffff88007abb8000 task.ti: ffff88007abb8000
[    2.744062] RIP: 0010:[<ffffffff816139df>]  [<ffffffff816139df>] __schedule+0x28f/0xab0
[    2.744062] RSP: 002b:00007fffb47a8730  EFLAGS: 00013086
[    2.744062] RAX: 000000007b4b2000 RBX: ffff88007b0cb200 RCX: 0000000000000028
[    2.744062] RDX: ffffffff816139ce RSI: 0000000000000001 RDI: ffff88007c3d3a18
[    2.744062] RBP: 00007fffb47a8820 R08: 0000000000000000 R09: 0000000000002dd4
[    2.744062] R10: 0000000000000001 R11: 0000000000000019 R12: ffff88007c3d3a00
[    2.744062] R13: ffff880079c24a00 R14: 0000000000000000 R15: ffff88007aab9370
[    2.744062] FS:  00007f48052ad700(0000) GS:ffff88007c200000(0000) knlGS:0000000000000000
[    2.744062] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.744062] CR2: 00007fffb47a8728 CR3: 000000007b4b2000 CR4: 00000000000006f0
[    2.744062] Stack:
[    2.744062] BUG: unable to handle kernel paging request at 00007fffb47a8730
[    2.744062] IP: [<ffffffff81005a4c>] show_stack_log_lvl+0x11c/0x1d0
[    2.744062] PGD 7b210067 PUD 0 
[    2.744062] Oops: 0000 [#1] PREEMPT SMP 
[    2.744062] Modules linked in:
[    2.744062] CPU: 0 PID: 957 Comm: vmmouse_detect Not tainted 3.16.0-rc2+ #2
[    2.744062] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.744062] task: ffff88007aab9370 ti: ffff88007abb8000 task.ti: ffff88007abb8000
[    2.744062] RIP: 0010:[<ffffffff81005a4c>]  [<ffffffff81005a4c>] show_stack_log_lvl+0x11c/0x1d0
[    2.744062] RSP: 002b:ffff88007c205e58  EFLAGS: 00013046
[    2.744062] RAX: 00007fffb47a8738 RBX: 0000000000000000 RCX: ffff88007c203fc0
[    2.744062] RDX: 00007fffb47a8730 RSI: ffff88007c200000 RDI: ffffffff8184e0ea
[    2.744062] RBP: ffff88007c205ea8 R08: ffff88007c1fffc0 R09: 0000000000000000
[    2.744062] R10: 000000007c200000 R11: 0000000000000000 R12: ffff88007c205f58
[    2.744062] R13: 0000000000000000 R14: ffffffff8181b584 R15: 0000000000000000
[    2.744062] FS:  00007f48052ad700(0000) GS:ffff88007c200000(0000) knlGS:0000000000000000
[    2.744062] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.744062] CR2: 00007fffb47a8730 CR3: 000000007b4b2000 CR4: 00000000000006f0
[    2.744062] Stack:
[    2.744062]  0000000000000008 ffff88007c205eb8 ffff88007c205e70 000000007b4b2000
[    2.744062]  00007fffb47a8730 ffff88007c205f58 00007fffb47a8730 0000000000000040
[    2.744062]  0000000000000ac0 ffff88007aab9370 ffff88007c205f08 ffffffff81005ba0
[    2.744062] Call Trace:
[    2.744062]  <#DF> 
[    2.744062]  [<ffffffff81005ba0>] show_regs+0xa0/0x280
[    2.744062]  [<ffffffff8103d113>] df_debug+0x23/0x40
[    2.744062]  [<ffffffff81003d1d>] do_double_fault+0x5d/0x80
[    2.744062]  [<ffffffff8161bf87>] double_fault+0x27/0x30
[    2.744062]  [<ffffffff816139ce>] ? __schedule+0x27e/0xab0
[    2.744062]  [<ffffffff816139df>] ? __schedule+0x28f/0xab0
[    2.744062]  <<EOE>> 
[    2.744062]  <UNK> Code: 7a ff ff ff 0f 1f 00 e8 d3 80 00 00 eb a5 48 39 ca 0f 84 8d 00 00 00 45 85 ff 0f 1f 44 00 00 74 06 41 f6 c7 03 74 55 48 8d 42 08 <48> 8b 32 48 c7 c7 7c b5 81 81 4c 89 45 b8 48 89 4d c0 41 ff c7 
[    2.744062] RIP  [<ffffffff81005a4c>] show_stack_log_lvl+0x11c/0x1d0
[    2.744062]  RSP <ffff88007c205e58>
[    2.744062] CR2: 00007fffb47a8730
[    2.744062] ---[ end trace 5cdf016839902dea ]---
[    2.744062] note: vmmouse_detect[957] exited with preempt_count 3



     247:       48 8b 7b 40             mov    0x40(%rbx),%rdi
     24b:       e8 00 00 00 00          callq  250 <__schedule+0x250>
     250:       0f 22 d8                mov    %rax,%cr3
     253:       f0 4d 0f b3 b5 88 03    lock btr %r14,0x388(%r13)
     25a:       00 00 
     25c:       4c 8b b3 90 03 00 00    mov    0x390(%rbx),%r14
     263:       4d 39 b5 90 03 00 00    cmp    %r14,0x390(%r13)
     26a:       0f 85 38 06 00 00       jne    8a8 <__schedule+0x8a8>
     270:       49 83 bf 88 02 00 00    cmpq   $0x0,0x288(%r15)
     277:       00 
     278:       0f 84 9a 03 00 00       je     618 <__schedule+0x618>
     27e:       49 8d 7c 24 18          lea    0x18(%r12),%rdi
     283:       48 c7 c2 00 00 00 00    mov    $0x0,%rdx
     28a:       be 01 00 00 00          mov    $0x1,%esi
     28f:       e8 00 00 00 00          callq  294 <__schedule+0x294>		<--- faulting
     294:       48 8b 74 24 18          mov    0x18(%rsp),%rsi
     299:       4c 89 ff                mov    %r15,%rdi
     29c:       9c                      pushfq 
     29d:       55                      push   %rbp
     29e:       48 89 f5                mov    %rsi,%rbp
     2a1:       48 89 a7 f0 04 00 00    mov    %rsp,0x4f0(%rdi)
     2a8:       48 8b a6 f0 04 00 00    mov    0x4f0(%rsi),%rsp
     2af:       e8 00 00 00 00          callq  2b4 <__schedule+0x2b4>
     2b4:       65 48 8b 34 25 00 00    mov    %gs:0x0,%rsi


ffffffff81613997:       48 8b 7b 40             mov    0x40(%rbx),%rdi
ffffffff8161399b:       e8 50 28 a3 ff          callq  ffffffff810461f0 <__phys_addr>
ffffffff816139a0:       0f 22 d8                mov    %rax,%cr3
ffffffff816139a3:       f0 4d 0f b3 b5 88 03    lock btr %r14,0x388(%r13)
ffffffff816139aa:       00 00 
ffffffff816139ac:       4c 8b b3 90 03 00 00    mov    0x390(%rbx),%r14
ffffffff816139b3:       4d 39 b5 90 03 00 00    cmp    %r14,0x390(%r13)
ffffffff816139ba:       0f 85 38 06 00 00       jne    ffffffff81613ff8 <__schedule+0x8a8>
ffffffff816139c0:       49 83 bf 88 02 00 00    cmpq   $0x0,0x288(%r15)
ffffffff816139c7:       00 
ffffffff816139c8:       0f 84 9a 03 00 00       je     ffffffff81613d68 <__schedule+0x618>
ffffffff816139ce:       49 8d 7c 24 18          lea    0x18(%r12),%rdi
ffffffff816139d3:       48 c7 c2 ce 39 61 81    mov    $0xffffffff816139ce,%rdx
ffffffff816139da:       be 01 00 00 00          mov    $0x1,%esi
ffffffff816139df:       e8 bc 82 a8 ff          callq  ffffffff8109bca0 <lock_release>		<--- faulting
ffffffff816139e4:       48 8b 74 24 18          mov    0x18(%rsp),%rsi
ffffffff816139e9:       4c 89 ff                mov    %r15,%rdi
ffffffff816139ec:       9c                      pushfq 
ffffffff816139ed:       55                      push   %rbp
ffffffff816139ee:       48 89 f5                mov    %rsi,%rbp
ffffffff816139f1:       48 89 a7 f0 04 00 00    mov    %rsp,0x4f0(%rdi)
ffffffff816139f8:       48 8b a6 f0 04 00 00    mov    0x4f0(%rsi),%rsp
ffffffff816139ff:       e8 cc d9 9e ff          callq  ffffffff810013d0 <__switch_to>
ffffffff81613a04:       65 48 8b 34 25 00 b9    mov    %gs:0xb900,%rsi


# 80 "./arch/x86/include/asm/bitops.h" 1
	.pushsection .smp_locks,"a"
.balign 4
.long 671f - .
.popsection
671:
	lock; bts %r14,904(%rbx)	# D.63059, MEM[(volatile long int *)_201]
# 0 "" 2
#NO_APP
	movq	64(%rbx), %rdi	# mm_193->pgd, mm_193->pgd
	call	__phys_addr	#
#APP
# 54 "./arch/x86/include/asm/special_insns.h" 1
	mov %rax,%cr3	# D.63056
# 0 "" 2
# 117 "./arch/x86/include/asm/bitops.h" 1
	.pushsection .smp_locks,"a"
.balign 4
.long 671f - .
.popsection
671:
	lock; btr %r14,904(%r13)	# D.63059, MEM[(volatile long int *)_215]
# 0 "" 2
#NO_APP
	movq	912(%rbx), %r14	# mm_193->context.ldt, D.63062
	cmpq	%r14, 912(%r13)	# D.63062, oldmm_194->context.ldt
	jne	.L2117	#,
.L2023:
	cmpq	$0, 648(%r15)	#, prev_21->mm
	je	.L2118	#,
.L2029:
	leaq	24(%r12), %rdi	#, D.63079
	movq	$.L2029, %rdx	#,
	movl	$1, %esi	#,
	call	lock_release	#				<---faulting
	movq	24(%rsp), %rsi	# %sfp, D.63067
	movq	%r15, %rdi	# prev, prev
#APP
# 2338 "kernel/sched/core.c" 1
	pushf ; pushq %rbp ; movq %rsi,%rbp
	movq %rsp,1264(%rdi)	#, prev
	movq 1264(%rsi),%rsp	#, D.63067
	call __switch_to
	movq %gs:current_task,%rsi	# current_task
	movq 760(%rsi),%r8	#
	movq %r8,%gs:irq_stack_union+40	# irq_stack_union.D.4635.stack_canary
	movq 8(%rsi),%r8	#
	movq %rax,%rdi
	testl  $262144,16(%r8)	#,
	jnz   ret_from_fork
	movq %rbp,%rsi ; popq %rbp ; popf	
# 0 "" 2
#NO_APP
	movq	%rax, 24(%rsp)	# prev, %sfp
	call	debug_smp_processor_id	#
	movl	%eax, %eax	# D.63055, D.63055
	movq	$runqueues, %rbx	#, __ptr
	movq	24(%rsp), %rsi	# %sfp, prev
	movq	%rbx, %rdi	# __ptr, D.63056
	addq	__per_cpu_offset(,%rax,8), %rdi	# __per_cpu_offset, D.63056
	movq	$runqueues, %r12	#, __ptr
	call	finish_task_switch	#
	call	debug_smp_processor_id	#

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
