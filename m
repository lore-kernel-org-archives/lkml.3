Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934785Ab3FSM55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:57:57 -0400
Received: from mout.gmx.net ([212.227.15.18]:62364 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933796Ab3FSM5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:57:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/3nE0thTP3FKDh0lE2+CMxN8W57DY26OnUT3bluT
	DoF+VjF10tiFHv
Message-ID: <1371646663.5845.56.camel@marge.simpson.net>
Subject: Re: [PATCH 0/6] ipc/sem.c: performance improvements, FIFO
From: Mike Galbraith <efault@gmx.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 19 Jun 2013 14:57:43 +0200
In-Reply-To: <1371539652.6091.91.camel@marge.simpson.net>
References: <1370884611-3861-1-git-send-email-manfred@colorfullife.com>
	 <51BB38FA.6080607@colorfullife.com>
	 <1371236750.5796.54.camel@marge.simpson.net>
	 <51BC4B99.4050506@colorfullife.com>
	 <1371538123.6091.87.camel@marge.simpson.net>
	 <1371539652.6091.91.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-18 at 09:14 +0200, Mike Galbraith wrote: 
> On Tue, 2013-06-18 at 08:48 +0200, Mike Galbraith wrote: 
> > On Sat, 2013-06-15 at 13:10 +0200, Manfred Spraul wrote: 
> 
> P.S.
> 
> > > My current guess:
> > > sem_lock() somehow ends up in lock_array.
> 
> Tracing shows that happens precisely one time, at end of benchmark.

FWIW, below is a profile of 3.8-rt scaling to 64 cores.  No mucking
about with sem_array, only livelock hack doing it's thing.. whatever
that is.

# Events: 1M cycles
#
# Overhead                                   Symbol
# ........  .......................................
#
    16.71%  [k] sys_semtimedop
    11.31%  [k] system_call
    11.23%  [k] copy_user_generic_string
     7.59%  [.] __semop
     4.88%  [k] sem_lock
     4.52%  [k] rt_spin_lock
     4.48%  [k] rt_spin_unlock
     3.75%  [.] worker_thread(void*)
     3.56%  [k] perform_atomic_semop
     3.15%  [k] idr_find
     3.15%  [k] ipc_obtain_object_check
     3.04%  [k] pid_vnr
     2.97%  [k] migrate_enable
     2.79%  [k] migrate_disable
     2.46%  [k] ipcperms
     2.01%  [k] sysret_check
     1.86%  [k] pin_current_cpu
     1.49%  [k] unpin_current_cpu
     1.13%  [k] __rcu_read_lock
     1.11%  [k] __rcu_read_unlock
     1.11%  [k] ipc_obtain_object

 Percent |      Source code & Disassembly of vmlinux
------------------------------------------------
         :
         :
         :
         :      Disassembly of section .text:
         :
         :      ffffffff81273390 <sem_lock>:
         :       * checking each local lock once. This means that the local lock paths
         :       * cannot start their critical sections while the global lock is held.
         :       */
         :      static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
         :                                    int nsops)
         :      {
    3.90 :      ffffffff81273390:       41 55                   push   %r13
    0.00 :      ffffffff81273392:       49 89 f5                mov    %rsi,%r13
    0.00 :      ffffffff81273395:       41 54                   push   %r12
    0.00 :      ffffffff81273397:       41 89 d4                mov    %edx,%r12d
    3.86 :      ffffffff8127339a:       55                      push   %rbp
    0.00 :      ffffffff8127339b:       48 89 fd                mov    %rdi,%rbp
    0.00 :      ffffffff8127339e:       53                      push   %rbx
    0.00 :      ffffffff8127339f:       48 83 ec 08             sub    $0x8,%rsp
         :              struct sem *sem;
         :              int locknum;
         :
         :              if (nsops == 1 && !sma->complex_count) {
    3.76 :      ffffffff812733a3:       83 fa 01                cmp    $0x1,%edx
    0.00 :      ffffffff812733a6:       75 0c                   jne    ffffffff812733b4 <sem_lock+0x24>
    0.00 :      ffffffff812733a8:       44 8b 87 a4 00 00 00    mov    0xa4(%rdi),%r8d
    8.92 :      ffffffff812733af:       45 85 c0                test   %r8d,%r8d
    0.00 :      ffffffff812733b2:       74 5c                   je     ffffffff81273410 <sem_lock+0x80>
         :                       * individual semaphore locks to go away.  The code
         :                       * above ensures no new single-lock holders will enter
         :                       * their critical section while the array lock is held.
         :                       */
         :       lock_array:
         :                      spin_lock(&sma->sem_perm.lock);
    0.00 :      ffffffff812733b4:       e8 57 4b e1 ff          callq  ffffffff81087f10 <migrate_disable>
    0.00 :      ffffffff812733b9:       48 89 ef                mov    %rbp,%rdi
    0.00 :      ffffffff812733bc:       e8 1f d4 34 00          callq  ffffffff815c07e0 <rt_spin_lock>
         :       wait_array:
         :                      for (i = 0; i < sma->sem_nsems; i++) {
    0.00 :      ffffffff812733c1:       8b 8d a0 00 00 00       mov    0xa0(%rbp),%ecx
    0.00 :      ffffffff812733c7:       85 c9                   test   %ecx,%ecx
    0.00 :      ffffffff812733c9:       7e 2b                   jle    ffffffff812733f6 <sem_lock+0x66>
    0.00 :      ffffffff812733cb:       31 db                   xor    %ebx,%ebx
    0.00 :      ffffffff812733cd:       0f 1f 00                nopl   (%rax)
         :                              sem = sma->sem_base + i;
    0.00 :      ffffffff812733d0:       48 63 c3                movslq %ebx,%rax
    0.00 :      ffffffff812733d3:       48 c1 e0 07             shl    $0x7,%rax
    0.00 :      ffffffff812733d7:       48 03 45 68             add    0x68(%rbp),%rax
         :      #ifdef CONFIG_PREEMPT_RT_BASE
         :                              if (spin_is_locked(&sem->lock))
    0.00 :      ffffffff812733db:       48 83 78 20 00          cmpq   $0x0,0x20(%rax)
    0.00 :      ffffffff812733e0:       74 09                   je     ffffffff812733eb <sem_lock+0x5b>
         :      #endif
         :                              spin_unlock_wait(&sem->lock);
    0.00 :      ffffffff812733e2:       48 8d 78 08             lea    0x8(%rax),%rdi
    0.00 :      ffffffff812733e6:       e8 b5 d4 34 00          callq  ffffffff815c08a0 <rt_spin_unlock_wait>
         :                       * their critical section while the array lock is held.
         :                       */
         :       lock_array:
         :                      spin_lock(&sma->sem_perm.lock);
         :       wait_array:
         :                      for (i = 0; i < sma->sem_nsems; i++) {
    0.00 :      ffffffff812733eb:       83 c3 01                add    $0x1,%ebx
    0.00 :      ffffffff812733ee:       39 9d a0 00 00 00       cmp    %ebx,0xa0(%rbp)
    0.00 :      ffffffff812733f4:       7f da                   jg     ffffffff812733d0 <sem_lock+0x40>
         :      #endif
         :                              spin_unlock_wait(&sem->lock);
         :                      }
         :                      locknum = -1;
         :
         :                      if (nsops == 1 && !sma->complex_count) {
    0.00 :      ffffffff812733f6:       41 83 ec 01             sub    $0x1,%r12d
    0.00 :      ffffffff812733fa:       74 51                   je     ffffffff8127344d <sem_lock+0xbd>
         :                              spin_unlock(&sma->sem_perm.lock);
         :                              locknum = sops->sem_num;
         :                      }
         :              }
         :              return locknum;
         :      }
    0.00 :      ffffffff812733fc:       48 83 c4 08             add    $0x8,%rsp
         :
         :                      if (nsops == 1 && !sma->complex_count) {
         :                              sem = sma->sem_base + sops->sem_num;
         :                              spin_lock(&sem->lock);
         :                              spin_unlock(&sma->sem_perm.lock);
         :                              locknum = sops->sem_num;
    0.00 :      ffffffff81273400:       b8 ff ff ff ff          mov    $0xffffffff,%eax
         :                      }
         :              }
         :              return locknum;
         :      }
    0.00 :      ffffffff81273405:       5b                      pop    %rbx
    0.00 :      ffffffff81273406:       5d                      pop    %rbp
    0.00 :      ffffffff81273407:       41 5c                   pop    %r12
    0.00 :      ffffffff81273409:       41 5d                   pop    %r13
    0.00 :      ffffffff8127340b:       c3                      retq   
    0.00 :      ffffffff8127340c:       0f 1f 40 00             nopl   0x0(%rax)
         :      {
         :              struct sem *sem;
         :              int locknum;
         :
         :              if (nsops == 1 && !sma->complex_count) {
         :                      sem = sma->sem_base + sops->sem_num;
    3.69 :      ffffffff81273410:       0f b7 1e                movzwl (%rsi),%ebx
    0.01 :      ffffffff81273413:       48 c1 e3 07             shl    $0x7,%rbx
    3.98 :      ffffffff81273417:       48 03 5f 68             add    0x68(%rdi),%rbx
         :                      /*
         :                       * Another process is holding the global lock on the
         :                       * sem_array; we cannot enter our critical section,
         :                       * but have to wait for the global lock to be released.
         :                       */
         :                      if (unlikely(spin_is_locked(&sma->sem_perm.lock))) {
   10.68 :      ffffffff8127341b:       48 83 7f 18 00          cmpq   $0x0,0x18(%rdi)
   22.07 :      ffffffff81273420:       75 60                   jne    ffffffff81273482 <sem_lock+0xf2>
         :                               */
         :                              spin_lock(&sem->lock);
         :                              spin_unlock(&sma->sem_perm.lock);
         :                      } else {
         :                              /* Lock just the semaphore we are interested in. */
         :                              spin_lock(&sem->lock);
    0.01 :      ffffffff81273422:       48 83 c3 08             add    $0x8,%rbx
    3.69 :      ffffffff81273426:       e8 e5 4a e1 ff          callq  ffffffff81087f10 <migrate_disable>
    7.42 :      ffffffff8127342b:       48 89 df                mov    %rbx,%rdi
    0.00 :      ffffffff8127342e:       e8 ad d3 34 00          callq  ffffffff815c07e0 <rt_spin_lock>
         :
         :                              /*
         :                               * If sma->complex_count was set prior to acquisition,
         :                               * we must fall back to the global array lock.
         :                               */
         :                              if (unlikely(sma->complex_count)) {
    3.75 :      ffffffff81273433:       8b b5 a4 00 00 00       mov    0xa4(%rbp),%esi
   16.44 :      ffffffff81273439:       85 f6                   test   %esi,%esi
    0.00 :      ffffffff8127343b:       75 68                   jne    ffffffff812734a5 <sem_lock+0x115>
         :
         :                      if (nsops == 1 && !sma->complex_count) {
         :                              sem = sma->sem_base + sops->sem_num;
         :                              spin_lock(&sem->lock);
         :                              spin_unlock(&sma->sem_perm.lock);
         :                              locknum = sops->sem_num;
    0.00 :      ffffffff8127343d:       41 0f b7 45 00          movzwl 0x0(%r13),%eax
         :                      }
         :              }
         :              return locknum;
         :      }
    0.00 :      ffffffff81273442:       48 83 c4 08             add    $0x8,%rsp
    3.94 :      ffffffff81273446:       5b                      pop    %rbx
    0.00 :      ffffffff81273447:       5d                      pop    %rbp
    0.01 :      ffffffff81273448:       41 5c                   pop    %r12
    3.86 :      ffffffff8127344a:       41 5d                   pop    %r13
    0.00 :      ffffffff8127344c:       c3                      retq   
         :      #endif
         :                              spin_unlock_wait(&sem->lock);
         :                      }
         :                      locknum = -1;
         :
         :                      if (nsops == 1 && !sma->complex_count) {
    0.00 :      ffffffff8127344d:       8b 95 a4 00 00 00       mov    0xa4(%rbp),%edx
    0.00 :      ffffffff81273453:       85 d2                   test   %edx,%edx
    0.00 :      ffffffff81273455:       75 a5                   jne    ffffffff812733fc <sem_lock+0x6c>
         :                              sem = sma->sem_base + sops->sem_num;
    0.00 :      ffffffff81273457:       41 0f b7 5d 00          movzwl 0x0(%r13),%ebx
    0.00 :      ffffffff8127345c:       48 c1 e3 07             shl    $0x7,%rbx
    0.00 :      ffffffff81273460:       48 03 5d 68             add    0x68(%rbp),%rbx
         :                              spin_lock(&sem->lock);
    0.00 :      ffffffff81273464:       e8 a7 4a e1 ff          callq  ffffffff81087f10 <migrate_disable>
    0.00 :      ffffffff81273469:       48 8d 7b 08             lea    0x8(%rbx),%rdi
    0.00 :      ffffffff8127346d:       e8 6e d3 34 00          callq  ffffffff815c07e0 <rt_spin_lock>
         :                              spin_unlock(&sma->sem_perm.lock);
    0.00 :      ffffffff81273472:       48 89 ef                mov    %rbp,%rdi
    0.00 :      ffffffff81273475:       e8 e6 d3 34 00          callq  ffffffff815c0860 <rt_spin_unlock>
    0.00 :      ffffffff8127347a:       e8 41 48 e1 ff          callq  ffffffff81087cc0 <migrate_enable>
    0.00 :      ffffffff8127347f:       90                      nop
    0.00 :      ffffffff81273480:       eb bb                   jmp    ffffffff8127343d <sem_lock+0xad>
    0.00 :      ffffffff81273482:       66 0f 1f 44 00 00       nopw   0x0(%rax,%rax,1)
         :                       * Another process is holding the global lock on the
         :                       * sem_array; we cannot enter our critical section,
         :                       * but have to wait for the global lock to be released.
         :                       */
         :                      if (unlikely(spin_is_locked(&sma->sem_perm.lock))) {
         :                              spin_lock(&sma->sem_perm.lock);
    0.00 :      ffffffff81273488:       e8 83 4a e1 ff          callq  ffffffff81087f10 <migrate_disable>
    0.00 :      ffffffff8127348d:       48 89 ef                mov    %rbp,%rdi
    0.00 :      ffffffff81273490:       e8 4b d3 34 00          callq  ffffffff815c07e0 <rt_spin_lock>
         :                              if (sma->complex_count)
    0.00 :      ffffffff81273495:       8b bd a4 00 00 00       mov    0xa4(%rbp),%edi
    0.00 :      ffffffff8127349b:       85 ff                   test   %edi,%edi
    0.00 :      ffffffff8127349d:       0f 85 1e ff ff ff       jne    ffffffff812733c1 <sem_lock+0x31>
    0.00 :      ffffffff812734a3:       eb bf                   jmp    ffffffff81273464 <sem_lock+0xd4>
         :                              /*
         :                               * If sma->complex_count was set prior to acquisition,
         :                               * we must fall back to the global array lock.
         :                               */
         :                              if (unlikely(sma->complex_count)) {
         :                                      spin_unlock(&sem->lock);
    0.00 :      ffffffff812734a5:       48 89 df                mov    %rbx,%rdi
    0.00 :      ffffffff812734a8:       e8 b3 d3 34 00          callq  ffffffff815c0860 <rt_spin_unlock>
    0.00 :      ffffffff812734ad:       0f 1f 00                nopl   (%rax)
    0.00 :      ffffffff812734b0:       e8 0b 48 e1 ff          callq  ffffffff81087cc0 <migrate_enable>
         :                                      goto lock_array;
    0.00 :      ffffffff812734b5:       e9 fa fe ff ff          jmpq   ffffffff812733b4 <sem_lock+0x24>


