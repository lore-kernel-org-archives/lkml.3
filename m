Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3FOLhN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 07:37:13 -0400
Received: from mout.gmx.net ([212.227.15.18]:61156 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab3FOLhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 07:37:11 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18jCUxrXsEjOXO9vvSSWKtfaIxgqZByzsSA3/2oSI
	cmr0+TI2ABizMP
Message-ID: <1371296221.5363.2.camel@marge.simpson.net>
Subject: Re: [PATCH 0/6] ipc/sem.c: performance improvements, FIFO
From: Mike Galbraith <efault@gmx.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 15 Jun 2013 13:37:01 +0200
In-Reply-To: <51BC4B99.4050506@colorfullife.com>
References: <1370884611-3861-1-git-send-email-manfred@colorfullife.com>
	 <51BB38FA.6080607@colorfullife.com>
	 <1371236750.5796.54.camel@marge.simpson.net>
	 <51BC4B99.4050506@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-15 at 13:10 +0200, Manfred Spraul wrote: 
> On 06/14/2013 09:05 PM, Mike Galbraith wrote:
> > # Events: 802K cycles
> > #
> > # Overhead                                      Symbol
> > # ........  ..........................................
> > #
> >      18.42%  [k] SYSC_semtimedop
> >      15.39%  [k] sem_lock
> >      10.26%  [k] _raw_spin_lock
> >       9.00%  [k] perform_atomic_semop
> >       7.89%  [k] system_call
> >       7.70%  [k] ipc_obtain_object_check
> >       6.95%  [k] ipcperms
> >       6.62%  [k] copy_user_generic_string
> >       4.16%  [.] __semop
> >       2.57%  [.] worker_thread(void*)
> >       2.30%  [k] copy_from_user
> >       1.75%  [k] sem_unlock
> >       1.25%  [k] ipc_obtain_object
> ~ 280 mio ops.
> 2.3% copy_from_user,
> 9% perform_atomic_semop.
> 
> > # Events: 802K cycles
> > #
> > # Overhead                           Symbol
> > # ........  ...............................
> > #
> >      17.38%  [k] SYSC_semtimedop
> >      13.26%  [k] system_call
> >      11.31%  [k] copy_user_generic_string
> >       7.62%  [.] __semop
> >       7.18%  [k] _raw_spin_lock
> >       5.66%  [k] ipcperms
> >       5.40%  [k] sem_lock
> >       4.65%  [k] perform_atomic_semop
> >       4.22%  [k] ipc_obtain_object_check
> >       4.08%  [.] worker_thread(void*)
> >       4.06%  [k] copy_from_user
> >       2.40%  [k] ipc_obtain_object
> >       1.98%  [k] pid_vnr
> >       1.45%  [k] wake_up_sem_queue_do
> >       1.39%  [k] sys_semop
> >       1.35%  [k] sys_semtimedop
> >       1.30%  [k] sem_unlock
> >       1.14%  [k] security_ipc_permission
> ~ 700 mio ops.
> 4% copy_from_user -> as expected a bit more
> 4.6% perform_atomic_semop --> less.
> 
> Thus: Could you send the oprofile output from perform_atomic_semop()?

Ok, newly profiled 32 core run.


Percent |	Source code & Disassembly of vmlinux
------------------------------------------------
         :
         :
         :
         :	Disassembly of section .text:
         :
         :	ffffffff812584d0 <perform_atomic_semop>:
         :	 * Negative values are error codes.
         :	 */
         :
         :	static int perform_atomic_semop(struct sem_array *sma, struct sembuf *sops,
         :	                             int nsops, struct sem_undo *un, int pid)
         :	{
    3.70 :	ffffffff812584d0:       55                      push   %rbp
    0.00 :	ffffffff812584d1:       48 89 e5                mov    %rsp,%rbp
    0.00 :	ffffffff812584d4:       41 54                   push   %r12
    3.40 :	ffffffff812584d6:       53                      push   %rbx
    0.00 :	ffffffff812584d7:       e8 64 dc 35 00          callq  ffffffff815b6140 <mcount>
         :	        int result, sem_op;
         :	        struct sembuf *sop;
         :	        struct sem * curr;
         :
         :	        for (sop = sops; sop < sops + nsops; sop++) {
    0.00 :	ffffffff812584dc:       48 63 d2                movslq %edx,%rdx
         :	 * Negative values are error codes.
         :	 */
         :
         :	static int perform_atomic_semop(struct sem_array *sma, struct sembuf *sops,
         :	                             int nsops, struct sem_undo *un, int pid)
         :	{
    0.00 :	ffffffff812584df:       45 89 c4                mov    %r8d,%r12d
    3.62 :	ffffffff812584e2:       48 89 cb                mov    %rcx,%rbx
         :	        int result, sem_op;
         :	        struct sembuf *sop;
         :	        struct sem * curr;
         :
         :	        for (sop = sops; sop < sops + nsops; sop++) {
    0.00 :	ffffffff812584e5:       48 8d 14 52             lea    (%rdx,%rdx,2),%rdx
    0.00 :	ffffffff812584e9:       49 89 f2                mov    %rsi,%r10
    0.00 :	ffffffff812584ec:       4c 8d 04 56             lea    (%rsi,%rdx,2),%r8
    3.53 :	ffffffff812584f0:       4c 39 c6                cmp    %r8,%rsi
    0.00 :	ffffffff812584f3:       0f 83 17 01 00 00       jae    ffffffff81258610 <perform_atomic_semop+0x140>
         :	                curr = sma->sem_base + sop->sem_num;
    0.00 :	ffffffff812584f9:       0f b7 0e                movzwl (%rsi),%ecx
         :	                sem_op = sop->sem_op;
    0.00 :	ffffffff812584fc:       0f bf 56 02             movswl 0x2(%rsi),%edx
         :	        int result, sem_op;
         :	        struct sembuf *sop;
         :	        struct sem * curr;
         :
         :	        for (sop = sops; sop < sops + nsops; sop++) {
         :	                curr = sma->sem_base + sop->sem_num;
    0.00 :	ffffffff81258500:       49 89 c9                mov    %rcx,%r9
    3.75 :	ffffffff81258503:       49 c1 e1 06             shl    $0x6,%r9
    0.00 :	ffffffff81258507:       4c 03 4f 40             add    0x40(%rdi),%r9
         :	                sem_op = sop->sem_op;
         :	                result = curr->semval;
         :	  
         :	                if (!sem_op && result)
    4.52 :	ffffffff8125850b:       85 d2                   test   %edx,%edx
         :	        struct sem * curr;
         :
         :	        for (sop = sops; sop < sops + nsops; sop++) {
         :	                curr = sma->sem_base + sop->sem_num;
         :	                sem_op = sop->sem_op;
         :	                result = curr->semval;
    0.00 :	ffffffff8125850d:       41 8b 01                mov    (%r9),%eax
         :	  
         :	                if (!sem_op && result)
   18.66 :	ffffffff81258510:       0f 84 e2 00 00 00       je     ffffffff812585f8 <perform_atomic_semop+0x128>
         :	                        goto would_block;
         :
         :	                result += sem_op;
         :	                if (result < 0)
    3.52 :	ffffffff81258516:       41 89 d3                mov    %edx,%r11d
    0.00 :	ffffffff81258519:       41 01 c3                add    %eax,%r11d
    0.00 :	ffffffff8125851c:       0f 88 de 00 00 00       js     ffffffff81258600 <perform_atomic_semop+0x130>
         :	                        goto would_block;
         :	                if (result > SEMVMX)
    0.00 :	ffffffff81258522:       41 81 fb ff 7f 00 00    cmp    $0x7fff,%r11d
    3.84 :	ffffffff81258529:       49 89 f2                mov    %rsi,%r10
    0.00 :	ffffffff8125852c:       0f 8f bb 00 00 00       jg     ffffffff812585ed <perform_atomic_semop+0x11d>
    0.00 :	ffffffff81258532:       66 0f 1f 44 00 00       nopw   0x0(%rax,%rax,1)
         :	                        goto out_of_range;
         :	                if (sop->sem_flg & SEM_UNDO) {
    0.00 :	ffffffff81258538:       41 f6 42 05 10          testb  $0x10,0x5(%r10)
    3.66 :	ffffffff8125853d:       74 1a                   je     ffffffff81258559 <perform_atomic_semop+0x89>
         :	                        int undo = un->semadj[sop->sem_num] - sem_op;
         :	                        /*
         :	                         *      Exceeding the undo range is an error.
         :	                         */
         :	                        if (undo < (-SEMAEM - 1) || undo > SEMAEM)
    0.00 :	ffffffff8125853f:       48 8b 43 40             mov    0x40(%rbx),%rax
    0.00 :	ffffffff81258543:       0f bf 04 48             movswl (%rax,%rcx,2),%eax
    0.00 :	ffffffff81258547:       29 d0                   sub    %edx,%eax
    0.00 :	ffffffff81258549:       05 00 80 00 00          add    $0x8000,%eax
    0.00 :	ffffffff8125854e:       3d ff ff 00 00          cmp    $0xffff,%eax
    0.00 :	ffffffff81258553:       0f 87 94 00 00 00       ja     ffffffff812585ed <perform_atomic_semop+0x11d>
         :	{
         :	        int result, sem_op;
         :	        struct sembuf *sop;
         :	        struct sem * curr;
         :
         :	        for (sop = sops; sop < sops + nsops; sop++) {
    3.70 :	ffffffff81258559:       49 83 c2 06             add    $0x6,%r10
         :	                         *      Exceeding the undo range is an error.
         :	                         */
         :	                        if (undo < (-SEMAEM - 1) || undo > SEMAEM)
         :	                                goto out_of_range;
         :	                }
         :	                curr->semval = result;
    0.01 :	ffffffff8125855d:       45 89 19                mov    %r11d,(%r9)
         :	{
         :	        int result, sem_op;
         :	        struct sembuf *sop;
         :	        struct sem * curr;
         :
         :	        for (sop = sops; sop < sops + nsops; sop++) {
    0.01 :	ffffffff81258560:       4d 39 c2                cmp    %r8,%r10
    0.00 :	ffffffff81258563:       0f 83 a7 00 00 00       jae    ffffffff81258610 <perform_atomic_semop+0x140>
         :	                curr = sma->sem_base + sop->sem_num;
    0.00 :	ffffffff81258569:       41 0f b7 0a             movzwl (%r10),%ecx
         :	                sem_op = sop->sem_op;
    0.00 :	ffffffff8125856d:       41 0f bf 52 02          movswl 0x2(%r10),%edx
         :	        int result, sem_op;
         :	        struct sembuf *sop;
         :	        struct sem * curr;
         :
         :	        for (sop = sops; sop < sops + nsops; sop++) {
         :	                curr = sma->sem_base + sop->sem_num;
    0.00 :	ffffffff81258572:       49 89 c9                mov    %rcx,%r9
    0.00 :	ffffffff81258575:       49 c1 e1 06             shl    $0x6,%r9
    0.00 :	ffffffff81258579:       4c 03 4f 40             add    0x40(%rdi),%r9
         :	                sem_op = sop->sem_op;
         :	                result = curr->semval;
         :	  
         :	                if (!sem_op && result)
    0.00 :	ffffffff8125857d:       85 d2                   test   %edx,%edx
         :	        struct sem * curr;
         :
         :	        for (sop = sops; sop < sops + nsops; sop++) {
         :	                curr = sma->sem_base + sop->sem_num;
         :	                sem_op = sop->sem_op;
         :	                result = curr->semval;
    0.00 :	ffffffff8125857f:       41 8b 01                mov    (%r9),%eax
         :	  
         :	                if (!sem_op && result)
    0.00 :	ffffffff81258582:       75 54                   jne    ffffffff812585d8 <perform_atomic_semop+0x108>
    0.00 :	ffffffff81258584:       85 c0                   test   %eax,%eax
    0.00 :	ffffffff81258586:       74 50                   je     ffffffff812585d8 <perform_atomic_semop+0x108>
         :
         :	out_of_range:
         :	        result = -ERANGE;
         :	        goto undo;
         :
         :	would_block:
    0.00 :	ffffffff81258588:       4c 89 d0                mov    %r10,%rax
         :	        if (sop->sem_flg & IPC_NOWAIT)
    0.00 :	ffffffff8125858b:       0f bf 40 04             movswl 0x4(%rax),%eax
    0.00 :	ffffffff8125858f:       25 00 08 00 00          and    $0x800,%eax
    0.00 :	ffffffff81258594:       83 f8 01                cmp    $0x1,%eax
    0.00 :	ffffffff81258597:       45 19 c0                sbb    %r8d,%r8d
    0.00 :	ffffffff8125859a:       41 83 e0 0c             and    $0xc,%r8d
    0.00 :	ffffffff8125859e:       41 83 e8 0b             sub    $0xb,%r8d
         :	                result = -EAGAIN;
         :	        else
         :	                result = 1;
         :
         :	undo:
         :	        sop--;
    0.00 :	ffffffff812585a2:       49 8d 4a fa             lea    -0x6(%r10),%rcx
         :	        while (sop >= sops) {
    0.00 :	ffffffff812585a6:       48 39 ce                cmp    %rcx,%rsi
    0.00 :	ffffffff812585a9:       77 1f                   ja     ffffffff812585ca <perform_atomic_semop+0xfa>
    0.00 :	ffffffff812585ab:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
         :	                sma->sem_base[sop->sem_num].semval -= sop->sem_op;
    0.00 :	ffffffff812585b0:       0f b7 01                movzwl (%rcx),%eax
    0.00 :	ffffffff812585b3:       0f bf 51 02             movswl 0x2(%rcx),%edx
         :	                sop--;
    0.00 :	ffffffff812585b7:       48 83 e9 06             sub    $0x6,%rcx
         :	                result = 1;
         :
         :	undo:
         :	        sop--;
         :	        while (sop >= sops) {
         :	                sma->sem_base[sop->sem_num].semval -= sop->sem_op;
    0.00 :	ffffffff812585bb:       48 c1 e0 06             shl    $0x6,%rax
    0.00 :	ffffffff812585bf:       48 03 47 40             add    0x40(%rdi),%rax
    0.00 :	ffffffff812585c3:       29 10                   sub    %edx,(%rax)
         :	        else
         :	                result = 1;
         :
         :	undo:
         :	        sop--;
         :	        while (sop >= sops) {
    0.00 :	ffffffff812585c5:       48 39 ce                cmp    %rcx,%rsi
    0.00 :	ffffffff812585c8:       76 e6                   jbe    ffffffff812585b0 <perform_atomic_semop+0xe0>
         :	                sma->sem_base[sop->sem_num].semval -= sop->sem_op;
         :	                sop--;
         :	        }
         :
         :	        return result;
         :	}
    0.00 :	ffffffff812585ca:       5b                      pop    %rbx
    0.00 :	ffffffff812585cb:       44 89 c0                mov    %r8d,%eax
    0.00 :	ffffffff812585ce:       41 5c                   pop    %r12
    0.00 :	ffffffff812585d0:       c9                      leaveq 
    0.00 :	ffffffff812585d1:       c3                      retq   
    0.00 :	ffffffff812585d2:       66 0f 1f 44 00 00       nopw   0x0(%rax,%rax,1)
         :	  
         :	                if (!sem_op && result)
         :	                        goto would_block;
         :
         :	                result += sem_op;
         :	                if (result < 0)
    0.00 :	ffffffff812585d8:       41 89 d3                mov    %edx,%r11d
    0.00 :	ffffffff812585db:       41 01 c3                add    %eax,%r11d
    0.00 :	ffffffff812585de:       78 a8                   js     ffffffff81258588 <perform_atomic_semop+0xb8>
         :	                        goto would_block;
         :	                if (result > SEMVMX)
    0.00 :	ffffffff812585e0:       41 81 fb ff 7f 00 00    cmp    $0x7fff,%r11d
    0.00 :	ffffffff812585e7:       0f 8e 4b ff ff ff       jle    ffffffff81258538 <perform_atomic_semop+0x68>
         :	        if (sop->sem_flg & IPC_NOWAIT)
         :	                result = -EAGAIN;
         :	        else
         :	                result = 1;
         :
         :	undo:
    0.00 :	ffffffff812585ed:       41 b8 de ff ff ff       mov    $0xffffffde,%r8d
    0.00 :	ffffffff812585f3:       eb ad                   jmp    ffffffff812585a2 <perform_atomic_semop+0xd2>
    0.00 :	ffffffff812585f5:       0f 1f 00                nopl   (%rax)
         :	        for (sop = sops; sop < sops + nsops; sop++) {
         :	                curr = sma->sem_base + sop->sem_num;
         :	                sem_op = sop->sem_op;
         :	                result = curr->semval;
         :	  
         :	                if (!sem_op && result)
    3.56 :	ffffffff812585f8:       85 c0                   test   %eax,%eax
    0.00 :	ffffffff812585fa:       0f 84 16 ff ff ff       je     ffffffff81258516 <perform_atomic_semop+0x46>
         :
         :	out_of_range:
         :	        result = -ERANGE;
         :	        goto undo;
         :
         :	would_block:
    0.00 :	ffffffff81258600:       48 89 f0                mov    %rsi,%rax
    0.00 :	ffffffff81258603:       49 89 f2                mov    %rsi,%r10
    0.00 :	ffffffff81258606:       e9 80 ff ff ff          jmpq   ffffffff8125858b <perform_atomic_semop+0xbb>
    0.00 :	ffffffff8125860b:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
         :	                                goto out_of_range;
         :	                }
         :	                curr->semval = result;
         :	        }
         :
         :	        sop--;
    3.58 :	ffffffff81258610:       4d 8d 4a fa             lea    -0x6(%r10),%r9
         :	        while (sop >= sops) {
    0.00 :	ffffffff81258614:       4c 39 ce                cmp    %r9,%rsi
    0.00 :	ffffffff81258617:       77 3b                   ja     ffffffff81258654 <perform_atomic_semop+0x184>
    0.00 :	ffffffff81258619:       0f 1f 80 00 00 00 00    nopl   0x0(%rax)
         :	                sma->sem_base[sop->sem_num].sempid = pid;
    0.00 :	ffffffff81258620:       41 0f b7 01             movzwl (%r9),%eax
    3.51 :	ffffffff81258624:       48 8b 57 40             mov    0x40(%rdi),%rdx
   22.37 :	ffffffff81258628:       48 c1 e0 06             shl    $0x6,%rax
    0.00 :	ffffffff8125862c:       44 89 64 02 04          mov    %r12d,0x4(%rdx,%rax,1)
         :	                if (sop->sem_flg & SEM_UNDO)
    3.79 :	ffffffff81258631:       41 f6 41 05 10          testb  $0x10,0x5(%r9)
    0.00 :	ffffffff81258636:       74 13                   je     ffffffff8125864b <perform_atomic_semop+0x17b>
         :	                        un->semadj[sop->sem_num] -= sop->sem_op;
    0.00 :	ffffffff81258638:       41 0f b7 01             movzwl (%r9),%eax
    0.00 :	ffffffff8125863c:       41 0f b7 51 02          movzwl 0x2(%r9),%edx
    0.00 :	ffffffff81258641:       48 01 c0                add    %rax,%rax
    0.00 :	ffffffff81258644:       48 03 43 40             add    0x40(%rbx),%rax
    0.00 :	ffffffff81258648:       66 29 10                sub    %dx,(%rax)
         :	                sop--;
    3.58 :	ffffffff8125864b:       49 83 e9 06             sub    $0x6,%r9
         :	                }
         :	                curr->semval = result;
         :	        }
         :
         :	        sop--;
         :	        while (sop >= sops) {
    0.00 :	ffffffff8125864f:       4c 39 ce                cmp    %r9,%rsi
    0.00 :	ffffffff81258652:       76 cc                   jbe    ffffffff81258620 <perform_atomic_semop+0x150>
         :	                sma->sem_base[sop->sem_num].semval -= sop->sem_op;
         :	                sop--;
         :	        }
         :
         :	        return result;
         :	}
    0.00 :	ffffffff81258654:       5b                      pop    %rbx
         :	        else
         :	                result = 1;
         :
         :	undo:
         :	        sop--;
         :	        while (sop >= sops) {
    0.00 :	ffffffff81258655:       45 31 c0                xor    %r8d,%r8d
         :	                sma->sem_base[sop->sem_num].semval -= sop->sem_op;
         :	                sop--;
         :	        }
         :
         :	        return result;
         :	}
    3.67 :	ffffffff81258658:       44 89 c0                mov    %r8d,%eax
    0.00 :	ffffffff8125865b:       41 5c                   pop    %r12
    0.00 :	ffffffff8125865d:       c9                      leaveq 


