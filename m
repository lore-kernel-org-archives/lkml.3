Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbaHTPIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:08:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbaHTPIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:08:34 -0400
Date: Wed, 20 Aug 2014 17:06:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>, David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, richard@nod.at,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel: signal: NULL ptr deref when killing process
Message-ID: <20140820150619.GA12706@redhat.com>
References: <53F48402.4080302@oracle.com> <20140820141252.GA27301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820141252.GA27301@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20, Oleg Nesterov wrote:
>
> On 08/20, Sasha Levin wrote:
> >
> > Hi all,
> >
> > While fuzzing with trinity inside a KVM tools guest running the latest -next
> > kernel, I've stumbled on the following spew:
>
> Thanks...
>
> looks like, kill_ok_by_cred()->__task_cred(t) returns NULL at first glance.
> perhaps you can show the result of "make kernel/signal.s" to be sure? Or at
> least the full "objdump -d kernel/signal.o".
>
> This looks strange. ->real_cred can be NULL only after __put_task_struct(),
> so this task_struct is already freed or soon-to-be-freed. But everything looks
> correct in this path, this task was found by pid_task() under rcu_read_lock().

Hmm. I'll recheck and report tomorrow, but it seems that I found a bug:
bad_fork_free_pid()->free_pid() looks wrong. This _can_ explain this trace
afaics, but only in unlikely case...

David, any other reason why ->real_cred can be NULL ? (assuming that I interpret
this asm correctly).

> > [  512.602559] BUG: unable to handle kernel NULL pointer dereference at 000000000000001c
> > [  512.602566] IP: check_kill_permission (kernel/signal.c:746 kernel/signal.c:781)
> > [  512.602576] PGD 4c10d0067 PUD 4c1738067 PMD 0
> > [  512.602584] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> > [  512.602612] Dumping ftrace buffer:
> > [  512.602697]    (ftrace buffer empty)
> > [  512.602704] Modules linked in:
> > [  512.602708] CPU: 18 PID: 8516 Comm: trinity-watchdo Tainted: G    B          3.16.0-next-20140815-sasha-00034-g615561b #1071
> > [  512.602711] task: ffff8804c1e88000 ti: ffff8804c1290000 task.ti: ffff8804c1290000
> > [  512.602718] RIP: check_kill_permission (kernel/signal.c:746 kernel/signal.c:781)
> > [  512.602720] RSP: 0018:ffff8804c1293e00  EFLAGS: 00010246
> > [  512.602722] RAX: 0000000000000000 RBX: ffff8804c1293ec0 RCX: 0000000000000000
> > [  512.602723] RDX: ffff880546803000 RSI: ffff8804c1293ec0 RDI: 0000000000000000
> > [  512.602726] RBP: ffff8804c1293e28 R08: 0000000000000000 R09: 0000000000000000
> > [  512.602728] R10: 0000000000000000 R11: 0000000000000246 R12: ffff880546803000
> > [  512.602729] R13: 0000000000000000 R14: 0000000000000000 R15: ffff8804c3fe4200
> > [  512.602732] FS:  00007fb2ed5e8700(0000) GS:ffff88071c400000(0000) knlGS:0000000000000000
> > [  512.602735] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [  512.602737] CR2: 000000000000001c CR3: 00000004c16ff000 CR4: 00000000000006a0
> > [  512.602750] DR0: 00000000006f0000 DR1: 0000000000000000 DR2: 0000000000000000
> > [  512.602753] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> > [  512.602754] Stack:
> > [  512.602761]  00000000000026ce 0000000000000000 ffff8804c1293ec0 ffff880546803000
> > [  512.602769]  0000000000000002 ffff8804c1293e60 ffffffff8c17ccb5 ffffffff8c17cc55
> > [  512.602777]  00000000000026ce ffff880565319180 0000000000000000 ffff8804c1293ec0
> > [  512.602779] Call Trace:
> > [  512.602786] group_send_sig_info (kernel/signal.c:1300)
> > [  512.602791] ? group_send_sig_info (kernel/signal.c:1296)
> > [  512.602795] kill_pid_info (kernel/signal.c:1338)
> > [  512.602800] ? kill_pid_info (kernel/signal.c:1330)
> > [  512.602805] SYSC_kill (kernel/signal.c:1423 kernel/signal.c:2896)
> > [  512.602809] ? SYSC_kill (include/linux/rcupdate.h:814 kernel/signal.c:1422 kernel/signal.c:2896)
> > [  512.602814] ? _raw_spin_unlock (./arch/x86/include/asm/preempt.h:98 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:183)
> > [  512.602820] ? trace_hardirqs_on (kernel/locking/lockdep.c:2609)
> > [  512.602824] ? syscall_trace_enter (include/linux/context_tracking.h:27 arch/x86/kernel/ptrace.c:1461)
> > [  512.602828] SyS_kill (kernel/signal.c:2886)
> > [  512.602833] tracesys (arch/x86/kernel/entry_64.S:541)
> > [ 512.602921] Code: 06 00 4d 8b b4 24 38 0a 00 00 65 48 8b 04 25 c0 da 00 00 4c 8b b8 40 0a 00 00 e8 ab e3 06 00 85 c0 0f 85 8b 00 00 00 41 8b 47 24 <41> 8b 56 1c 39 d0 74 60 41 8b 4e 14 39 c8 74 58 41 8b 47 14 39
> > All code
> > ========
> >    0:	06                   	(bad)
> >    1:	00 4d 8b             	add    %cl,-0x75(%rbp)
> >    4:	b4 24                	mov    $0x24,%ah
> >    6:	38 0a                	cmp    %cl,(%rdx)
> >    8:	00 00                	add    %al,(%rax)
> >    a:	65 48 8b 04 25 c0 da 	mov    %gs:0xdac0,%rax
> >   11:	00 00
> >   13:	4c 8b b8 40 0a 00 00 	mov    0xa40(%rax),%r15
> >   1a:	e8 ab e3 06 00       	callq  0x6e3ca
> >   1f:	85 c0                	test   %eax,%eax
> >   21:	0f 85 8b 00 00 00    	jne    0xb2
> >   27:	41 8b 47 24          	mov    0x24(%r15),%eax
> >   2b:*	41 8b 56 1c          	mov    0x1c(%r14),%edx		<-- trapping instruction
> >   2f:	39 d0                	cmp    %edx,%eax
> >   31:	74 60                	je     0x93
> >   33:	41 8b 4e 14          	mov    0x14(%r14),%ecx
> >   37:	39 c8                	cmp    %ecx,%eax
> >   39:	74 58                	je     0x93
> >   3b:	41 8b 47 14          	mov    0x14(%r15),%eax
> >   3f:	39 00                	cmp    %eax,(%rax)
> > 
> > Code starting with the faulting instruction
> > ===========================================
> >    0:	41 8b 56 1c          	mov    0x1c(%r14),%edx
> >    4:	39 d0                	cmp    %edx,%eax
> >    6:	74 60                	je     0x68
> >    8:	41 8b 4e 14          	mov    0x14(%r14),%ecx
> >    c:	39 c8                	cmp    %ecx,%eax
> >    e:	74 58                	je     0x68
> >   10:	41 8b 47 14          	mov    0x14(%r15),%eax
> >   14:	39 00                	cmp    %eax,(%rax)
> > [  512.602927] RIP check_kill_permission (kernel/signal.c:746 kernel/signal.c:781)
> > [  512.602929]  RSP <ffff8804c1293e00>
> > [  512.602931] CR2: 000000000000001c
> > 
> > 
> > Thanks,
> > Sasha

