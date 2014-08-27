Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934993AbaH0OSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:18:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934979AbaH0OSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:18:41 -0400
Date: Wed, 27 Aug 2014 16:16:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, richard@nod.at,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel: signal: NULL ptr deref when killing process
Message-ID: <20140827141618.GA31549@redhat.com>
References: <20140820150619.GA12706@redhat.com> <53F48402.4080302@oracle.com> <20140820141252.GA27301@redhat.com> <3200.1408638173@warthog.procyon.org.uk> <20140821171726.GB27140@redhat.com> <53FD52C6.60603@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FD52C6.60603@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26, Sasha Levin wrote:
>
> On 08/21/2014 01:17 PM, Oleg Nesterov wrote:
> >> Is there a race between kill() and exit() brought on by the kill path only
> >> > using the RCU read lock?  This doesn't prevent ->real_cred from being
> >> > modified, but it looks like this should, in combination with
> >> > delayed_put_task_struct(), prevent it from being cleared.
> > Yes, rcu should protect us from both delayed_put_pid() and delayed_put_task().
> > Everything looks correct... And there are a lot of other similar users of
> > find_vpid/find_task_by_vpid/pid_task/etc under rcu, I can't recall any bug
> > in this area.
> >
> > I am puzzled. Note also that ->signal == NULL. Will try to think more,
> > but so far I have no any idea.
>
> I've hit something similar earlier today, and it might be related:

Thanks.

rsi == &current->signal->shared_pending == 0x2a0, so current->signal == 544.

Given that this task is current, we can rule out RCU/find_pind/etc problems,
this task_struct and its ->signal must be stable.

Looks like, something was broken recently. I do not remember the bug reports
like this. Say, an unbalanced put_task_struct()... Hmm.

> [  973.452840] BUG: unable to handle kernel NULL pointer dereference at 00000000000002b0
> [  973.455347] IP: flush_sigqueue_mask (include/linux/signal.h:118 kernel/signal.c:715)
> [  973.457526] PGD 4dfdc7067 PUD 5f77d9067 PMD 0
> [  973.459216] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [  973.460086] Dumping ftrace buffer:
> [  973.460086]    (ftrace buffer empty)
> [  973.460086] Modules linked in:
> [  973.460086] CPU: 4 PID: 13145 Comm: trinity-c767 Not tainted 3.17.0-rc2-next-20140826-sasha-00031-gc48c9ac-dirty #1079
> [  973.460086] task: ffff880604800000 ti: ffff880586648000 task.ti: ffff880586648000
> [  973.460086] RIP: flush_sigqueue_mask (include/linux/signal.h:118 kernel/signal.c:715)
> [  973.460086] RSP: 0018:ffff88058664bec8  EFLAGS: 00010046
> [  973.460086] RAX: 0000000000000000 RBX: fffffffffffff730 RCX: 0000000000010000
> [  973.460086] RDX: 0000000000000000 RSI: 00000000000002a0 RDI: ffff88058664bed8
> [  973.460086] RBP: ffff88058664bf10 R08: 0000000000000001 R09: 0000000000000001
> [  973.460086] R10: 000000000002d201 R11: 0000000000000254 R12: 0000000000000000
> [  973.460086] R13: ffff88058664bf40 R14: ffff880604800000 R15: 0000000000000010
> [  973.460086] FS:  00007fe3a3045700(0000) GS:ffff880277c00000(0000) knlGS:0000000000000000
> [  973.460086] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  973.460086] CR2: 00000000000002b0 CR3: 00000004e23d5000 CR4: 00000000000006a0
> [  973.460086] Stack:
> [  973.460086]  ffffffffac183690 01017fffb3247180 0000000000010000 0000000000000000
> [  973.460086]  00007fffb3247180 00007fffb3247220 0000000000000011 0000000000000000
> [  973.460086]  0000000000000000 ffff88058664bf78 ffffffffac183ef5 0000000000000000
> [  973.460086] Call Trace:
> [  973.460086] ? do_sigaction (kernel/signal.c:3124 (discriminator 17))
> [  973.460086] SyS_rt_sigaction (kernel/signal.c:3360 kernel/signal.c:3341)
> [  973.460086] tracesys (arch/x86/kernel/entry_64.S:542)
> [ 973.460086] Code: b7 49 09 d5 4d 89 6e 10 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 8b 0f 31 c0 <48> 8b 56 10 48 85 ca 74 7b 55 48 f7 d1 48 89 e5 41 56 48 21 ca
> All code
> ========
>    0:	b7 49                	mov    $0x49,%bh
>    2:	09 d5                	or     %edx,%ebp
>    4:	4d 89 6e 10          	mov    %r13,0x10(%r14)
>    8:	48 83 c4 08          	add    $0x8,%rsp
>    c:	5b                   	pop    %rbx
>    d:	41 5c                	pop    %r12
>    f:	41 5d                	pop    %r13
>   11:	41 5e                	pop    %r14
>   13:	41 5f                	pop    %r15
>   15:	5d                   	pop    %rbp
>   16:	c3                   	retq
>   17:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
>   1e:	00 00 00
>   21:	66 66 66 66 90       	data32 data32 data32 xchg %ax,%ax
>   26:	48 8b 0f             	mov    (%rdi),%rcx
>   29:	31 c0                	xor    %eax,%eax
>   2b:*	48 8b 56 10          	mov    0x10(%rsi),%rdx		<-- trapping instruction
>   2f:	48 85 ca             	test   %rcx,%rdx
>   32:	74 7b                	je     0xaf
>   34:	55                   	push   %rbp
>   35:	48 f7 d1             	not    %rcx
>   38:	48 89 e5             	mov    %rsp,%rbp
>   3b:	41 56                	push   %r14
>   3d:	48 21 ca             	and    %rcx,%rdx
> 	...
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	48 8b 56 10          	mov    0x10(%rsi),%rdx
>    4:	48 85 ca             	test   %rcx,%rdx
>    7:	74 7b                	je     0x84
>    9:	55                   	push   %rbp
>    a:	48 f7 d1             	not    %rcx
>    d:	48 89 e5             	mov    %rsp,%rbp
>   10:	41 56                	push   %r14
>   12:	48 21 ca             	and    %rcx,%rdx
> 	...
> [  973.460086] RIP flush_sigqueue_mask (include/linux/signal.h:118 kernel/signal.c:715)
> [  973.460086]  RSP <ffff88058664bec8>
> [  973.460086] CR2: 00000000000002b0
> 
> 
> Thanks,
> Sasha

