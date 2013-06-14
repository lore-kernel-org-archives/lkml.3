Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab3FNTGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 15:06:06 -0400
Received: from mout.gmx.net ([212.227.17.20]:63761 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab3FNTGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 15:06:04 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/QI1ZTODrQH37W6wsMwtQg6YzgjOOuLFSgInZbMi
	8T36W0wcqgIC8P
Message-ID: <1371236750.5796.54.camel@marge.simpson.net>
Subject: Re: [PATCH 0/6] ipc/sem.c: performance improvements, FIFO
From: Mike Galbraith <efault@gmx.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Jun 2013 21:05:50 +0200
In-Reply-To: <51BB38FA.6080607@colorfullife.com>
References: <1370884611-3861-1-git-send-email-manfred@colorfullife.com>
	 <51BB38FA.6080607@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-14 at 17:38 +0200, Manfred Spraul wrote: 
> Hi all,
> 
> On 06/10/2013 07:16 PM, Manfred Spraul wrote:
> > Hi Andrew,
> >
> > I have cleaned up/improved my updates to sysv sem.
> > Could you replace my patches in -akpm with this series?
> >
> > - 1: cacheline align output from ipc_rcu_alloc
> > - 2: cacheline align semaphore structures
> > - 3: seperate-wait-for-zero-and-alter-tasks
> > - 4: Always-use-only-one-queue-for-alter-operations
> > - 5: Replace the global sem_otime with a distributed otime
> > - 6: Rename-try_atomic_semop-to-perform_atomic
> Just to keep everyone updated:
> I have updated my testapp:
> https://github.com/manfred-colorfu/ipcscale/blob/master/sem-waitzero.cpp
> 
> Something like this gives a nice output:
> 
>      # sem-waitzero -t 5 -m 0 | grep 'Cpus' | gawk '{printf("%f - 
> %s\n",$7/$2,$0);}' | sort -n -r
> 
> The first number is the number of operations per cpu during 5 seconds.
> 
> Mike was kind enough to run in on a 32-core (4-socket) Intel system:
> - master doesn't scale at all when multiple sockets are used:
>      interleave 4: (i.e.: use cpu 0, then 4, then 8 (2nd socket), then 12):
>          34,717586.000000 - Cpus 1, interleave 4 delay 0: 34717586 in 5 secs
>          24,507337.500000 - Cpus 2, interleave 4 delay 0: 49014675 in 5 secs
>           3,487540.000000 - Cpus 3, interleave 4 delay 0: 10462620 in 5 secs
>           2,708145.000000 - Cpus 4, interleave 4 delay 0: 10832580 in 5 secs
>      interleave 8: (i.e.: use cpu 0, then 8 (2nd socket):
>          34,587329.000000 - Cpus 1, interleave 8 delay 0: 34587329 in 5 secs
>           7,746981.500000 - Cpus 2, interleave 8 delay 0: 15493963 in 5 secs
> 
> - with my patches applied, it scales linearly - but only sometimes
>      example for good scaling (18 threads in parallel - linear scaling):
>          33,928616.111111 - Cpus 18, interleave 8 delay 0: 610715090 in 
> 5 secs
>      example for bad scaling:
>          5,829109.600000 - Cpus 5, interleave 8 delay 0: 29145548 in 5 secs
> 
> For me, it looks like a livelock somewhere:
> Good example: all threads contribute the same amount to the final result:
> > Result matrix:
> >   Thread   0: 33476433
> >   Thread   1: 33697100
> >   Thread   2: 33514249
> >   Thread   3: 33657413
> >   Thread   4: 33727959
> >   Thread   5: 33580684
> >   Thread   6: 33530294
> >   Thread   7: 33666761
> >   Thread   8: 33749836
> >   Thread   9: 32636493
> >   Thread  10: 33550620
> >   Thread  11: 33403314
> >   Thread  12: 33594457
> >   Thread  13: 33331920
> >   Thread  14: 33503588
> >   Thread  15: 33585348
> > Cpus 16, interleave 8 delay 0: 536206469 in 5 secs
> Bad example: one thread is as fast as it should be, others are slow:
> > Result matrix:
> >   Thread   0: 31629540
> >   Thread   1:  5336968
> >   Thread   2:  6404314
> >   Thread   3:  9190595
> >   Thread   4:  9681006
> >   Thread   5:  9935421
> >   Thread   6:  9424324
> > Cpus 7, interleave 8 delay 0: 81602168 in 5 secs
> 
> The results are not stable: the same test is sometimes fast, sometimes slow.
> I have no idea where the livelock could be and I wasn't able to notice 
> anything on my i3 laptop.
> 
> Thus: Who has an idea?
> What I can say is that the livelock can't be in do_smart_update(): The 
> function is never called.

64 core DL980, using all cores is stable at being horribly _unstable_,
much worse than the 32 core UV2000, but if using only 32 cores, it
becomes considerably more stable than the newer/faster UV box.

32 of 64 cores DL980 without the -rt killing goto again loop removal I
showed you.  Unstable, not wonderful throughput.

Result matrix:
  Thread   0:  7253945
  Thread   1:  9050395
  Thread   2:  7708921
  Thread   3:  7274316
  Thread   4:  9815215
  Thread   5:  9924773
  Thread   6:  7743325
  Thread   7:  8643970
  Thread   8: 11268731
  Thread   9:  9610031
  Thread  10:  7540230
  Thread  11:  8432077
  Thread  12: 11071762
  Thread  13: 10436946
  Thread  14:  8051919
  Thread  15:  7461884
  Thread  16: 11706359
  Thread  17: 10512449
  Thread  18:  8225636
  Thread  19:  7809035
  Thread  20: 10465783
  Thread  21: 10072878
  Thread  22:  7632289
  Thread  23:  6758903
  Thread  24: 10763830
  Thread  25:  8974703
  Thread  26:  7054996
  Thread  27:  7367430
  Thread  28:  9816388
  Thread  29:  9622796
  Thread  30:  6500835
  Thread  31:  7959901

# Events: 802K cycles
#
# Overhead                                      Symbol
# ........  ..........................................
#
    18.42%  [k] SYSC_semtimedop
    15.39%  [k] sem_lock
    10.26%  [k] _raw_spin_lock
     9.00%  [k] perform_atomic_semop
     7.89%  [k] system_call
     7.70%  [k] ipc_obtain_object_check
     6.95%  [k] ipcperms
     6.62%  [k] copy_user_generic_string
     4.16%  [.] __semop
     2.57%  [.] worker_thread(void*)
     2.30%  [k] copy_from_user
     1.75%  [k] sem_unlock
     1.25%  [k] ipc_obtain_object

With -goto again loop whacked, it's nearly stable, but not quite, and
throughput mostly looks like so..

Result matrix:
  Thread   0: 24164305
  Thread   1: 24224024
  Thread   2: 24112445
  Thread   3: 24076559
  Thread   4: 24364901
  Thread   5: 24249681
  Thread   6: 24048409
  Thread   7: 24267064
  Thread   8: 24614799
  Thread   9: 24330378
  Thread  10: 24132766
  Thread  11: 24158460
  Thread  12: 24456538
  Thread  13: 24300952
  Thread  14: 24079298
  Thread  15: 24100075
  Thread  16: 24643074
  Thread  17: 24369761
  Thread  18: 24151657
  Thread  19: 24143953
  Thread  20: 24575677
  Thread  21: 24169945
  Thread  22: 24055378
  Thread  23: 24016710
  Thread  24: 24548028
  Thread  25: 24290316
  Thread  26: 24169379
  Thread  27: 24119776
  Thread  28: 24399737
  Thread  29: 24256724
  Thread  30: 23914777
  Thread  31: 24215780

and profile like so.

# Events: 802K cycles
#
# Overhead                           Symbol
# ........  ...............................
#
    17.38%  [k] SYSC_semtimedop
    13.26%  [k] system_call
    11.31%  [k] copy_user_generic_string
     7.62%  [.] __semop
     7.18%  [k] _raw_spin_lock
     5.66%  [k] ipcperms
     5.40%  [k] sem_lock
     4.65%  [k] perform_atomic_semop
     4.22%  [k] ipc_obtain_object_check
     4.08%  [.] worker_thread(void*)
     4.06%  [k] copy_from_user
     2.40%  [k] ipc_obtain_object
     1.98%  [k] pid_vnr
     1.45%  [k] wake_up_sem_queue_do
     1.39%  [k] sys_semop
     1.35%  [k] sys_semtimedop
     1.30%  [k] sem_unlock
     1.14%  [k] security_ipc_permission

So that goto again loop is not only an -rt killer, it seems to be part
of the instability picture too.

Back to virgin source + your patch series

Using 64 cores with or without loop removed, it's uniformly unstable as
hell.  With goto again loop removed, it improves some, but not much, so
loop isn't the biggest deal, except to -rt, where it's utterly deadly.
. 
Result matrix:
  Thread   0:   997088
  Thread   1:  1962065
  Thread   2:   117899
  Thread   3:   125918
  Thread   4:    80233
  Thread   5:    85001
  Thread   6:    88413
  Thread   7:   104424
  Thread   8:  1549782
  Thread   9:  2172206
  Thread  10:   119314
  Thread  11:   127109
  Thread  12:    81179
  Thread  13:    89026
  Thread  14:    91497
  Thread  15:   103410
  Thread  16:  1661969
  Thread  17:  2223131
  Thread  18:   119739
  Thread  19:   126294
  Thread  20:    81172
  Thread  21:    87850
  Thread  22:    90621
  Thread  23:   102964
  Thread  24:  1641042
  Thread  25:  2152851
  Thread  26:   118818
  Thread  27:   125801
  Thread  28:    79316
  Thread  29:    99029
  Thread  30:   101513
  Thread  31:    91206
  Thread  32:  1825614
  Thread  33:  2432801
  Thread  34:   120599
  Thread  35:   131854
  Thread  36:    81346
  Thread  37:   103464
  Thread  38:   105223
  Thread  39:   101554
  Thread  40:  1980013
  Thread  41:  2574055
  Thread  42:   122887
  Thread  43:   131096
  Thread  44:    80521
  Thread  45:   105162
  Thread  46:   110329
  Thread  47:   104078
  Thread  48:  1925173
  Thread  49:  2552441
  Thread  50:   123806
  Thread  51:   134857
  Thread  52:    82148
  Thread  53:   105312
  Thread  54:   109728
  Thread  55:   107766
  Thread  56:  1999696
  Thread  57:  2699455
  Thread  58:   128375
  Thread  59:   128289
  Thread  60:    80071
  Thread  61:   106968
  Thread  62:   111768
  Thread  63:   115243

# Events: 1M cycles
#
# Overhead                                   Symbol
# ........  .......................................
#
    30.73%  [k] ipc_obtain_object_check
    29.46%  [k] sem_lock
    25.12%  [k] ipcperms
     4.93%  [k] SYSC_semtimedop
     4.35%  [k] perform_atomic_semop
     2.83%  [k] _raw_spin_lock
     0.40%  [k] system_call

ipc_obtain_object_check():

         :         * Call inside the RCU critical section.                                                                                                                                                                                 ↑
         :         * The ipc object is *not* locked on exit.                                                                                                                                                                               ▒
         :         */                                                                                                                                                                                                                      ▒
         :        struct kern_ipc_perm *ipc_obtain_object_check(struct ipc_ids *ids, int id)                                                                                                                                               ▒
         :        {                                                                                                                                                                                                                        ▒
         :                struct kern_ipc_perm *out = ipc_obtain_object(ids, id);                                                                                                                                                          ▒
    0.00 :        ffffffff81256a2b:       48 89 c2                mov    %rax,%rdx                                                                                                                                                         ▒
         :                                                                                                                                                                                                                                 ▒
         :                if (IS_ERR(out))                                                                                                                                                                                                 ▒
    0.02 :        ffffffff81256a2e:       77 20                   ja     ffffffff81256a50 <ipc_obtain_object_check+0x40>                                                                                                                   ▒
         :                        goto out;                                                                                                                                                                                                ▒
         :                                                                                                                                                                                                                                 ▒
         :                if (ipc_checkid(out, id))                                                                                                                                                                                        ▒
    0.00 :        ffffffff81256a30:       8d 83 ff 7f 00 00       lea    0x7fff(%rbx),%eax                                                                                                                                                 ▒
    0.00 :        ffffffff81256a36:       85 db                   test   %ebx,%ebx                                                                                                                                                         ▒
    0.00 :        ffffffff81256a38:       0f 48 d8                cmovs  %eax,%ebx                                                                                                                                                         ▒
    0.02 :        ffffffff81256a3b:       c1 fb 0f                sar    $0xf,%ebx                                                                                                                                                         ▒
    0.00 :        ffffffff81256a3e:       48 63 c3                movslq %ebx,%rax                                                                                                                                                         ▒
    0.00 :        ffffffff81256a41:       48 3b 42 28             cmp    0x28(%rdx),%rax                                                                                                                                                   ▒
   99.84 :        ffffffff81256a45:       48 c7 c0 d5 ff ff ff    mov    $0xffffffffffffffd5,%rax                                                                                                                                          ▒
    0.00 :        ffffffff81256a4c:       48 0f 45 d0             cmovne %rax,%rdx                                                                                                                                                         ▒
         :                        return ERR_PTR(-EIDRM);                                                                                                                                                                                  ▒
         :        out:                                                                                                                                                                                                                     ▒
         :                return out;                                                                                                                                                                                                      ▒
         :        }                                                                                                                                                                                                                        ▒
    0.03 :        ffffffff81256a50:       48 83 c4 08             add    $0x8,%rsp                                                                                                                                                         ▒
    0.00 :        ffffffff81256a54:       48 89 d0                mov    %rdx,%rax                                                                                                                                                         ▒
    0.02 :        ffffffff81256a57:       5b                      pop    %rbx                                                                                                                                                              ▒
    0.00 :        ffffffff81256a58:       c9                      leaveq 

sem_lock():

         :        static inline void spin_lock(spinlock_t *lock)                                                                                                                                                                           ▒
         :        {                                                                                                                                                                                                                        ▒
         :                raw_spin_lock(&lock->rlock);                                                                                                                                                                                     ▒
    0.10 :        ffffffff81258a7c:       4c 8d 6b 08             lea    0x8(%rbx),%r13                                                                                                                                                    ▒
    0.01 :        ffffffff81258a80:       4c 89 ef                mov    %r13,%rdi                                                                                                                                                         ▒
    0.01 :        ffffffff81258a83:       e8 08 4f 35 00          callq  ffffffff815ad990 <_raw_spin_lock>                                                                                                                                 ▒
         :                                                                                                                                                                                                                                 ▒
         :                        /*                                                                                                                                                                                                       ▒
         :                         * If sma->complex_count was set while we were spinning,                                                                                                                                                 ▒
         :                         * we may need to look at things we did not lock here.                                                                                                                                                   ▒
         :                         */                                                                                                                                                                                                      ▒
         :                        if (unlikely(sma->complex_count)) {                                                                                                                                                                      ▒
    0.02 :        ffffffff81258a88:       41 8b 44 24 7c          mov    0x7c(%r12),%eax                                                                                                                                                   ▮
    6.18 :        ffffffff81258a8d:       85 c0                   test   %eax,%eax                                                                                                                                                         ▒
    0.00 :        ffffffff81258a8f:       75 29                   jne    ffffffff81258aba <sem_lock+0x7a>                                                                                                                                  ▒
         :                __add(&lock->tickets.head, 1, UNLOCK_LOCK_PREFIX);                                                                                                                                                               ▒
         :        }                                                                                                                                                                                                                        ▒
         :                                                                                                                                                                                                                                 ▒
         :        static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)                                                                                                                                                         ▒
         :        {                                                                                                                                                                                                                        ▒
         :                struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);                                                                                                                                                           ▒
    0.00 :        ffffffff81258a91:       41 0f b7 54 24 02       movzwl 0x2(%r12),%edx                                                                                                                                                    ▒
   84.33 :        ffffffff81258a97:       41 0f b7 04 24          movzwl (%r12),%eax                                                                                                                                                       ▒
         :                        /*                                                                                                                                                                                                       ▒
         :                         * Another process is holding the global lock on the                                                                                                                                                     ▒
         :                         * sem_array; we cannot enter our critical section,                                                                                                                                                      ▒
         :                         * but have to wait for the global lock to be released.                                                                                                                                                  ▒
         :                         */                                                                                                                                                                                                      ▒
         :                        if (unlikely(spin_is_locked(&sma->sem_perm.lock))) {                                                                                                                                                     ▒
    0.42 :        ffffffff81258a9c:       66 39 c2                cmp    %ax,%dx                                                                                                                                                           ▒
    0.01 :        ffffffff81258a9f:       75 76                   jne    ffffffff81258b17 <sem_lock+0xd7>                                                                                                                                  ▒
         :                                spin_unlock(&sem->lock);                                                                                                                                                                         ▒
         :                                spin_unlock_wait(&sma->sem_perm.lock);                                                                                                                                                           ▒
         :                                goto again;


ipcperms():

         :        static inline int audit_dummy_context(void)                                                                                                                                                                              ▒
         :        {                                                                                                                                                                                                                        ▒
         :                void *p = current->audit_context;                                                                                                                                                                                ▒
    0.01 :        ffffffff81255f9e:       48 8b 82 d0 05 00 00    mov    0x5d0(%rdx),%rax                                                                                                                                                  ▒
         :                return !p || *(int *)p;                                                                                                                                                                                          ▒
    0.01 :        ffffffff81255fa5:       48 85 c0                test   %rax,%rax                                                                                                                                                         ▒
    0.00 :        ffffffff81255fa8:       74 06                   je     ffffffff81255fb0 <ipcperms+0x50>                                                                                                                                  ▒
    0.00 :        ffffffff81255faa:       8b 00                   mov    (%rax),%eax                                                                                                                                                       ▒
    0.00 :        ffffffff81255fac:       85 c0                   test   %eax,%eax                                                                                                                                                         ▒
    0.00 :        ffffffff81255fae:       74 60                   je     ffffffff81256010 <ipcperms+0xb0>                                                                                                                                  ▒
         :                int requested_mode, granted_mode;                                                                                                                                                                                ▒
         :                                                                                                                                                                                                                                 ▒
         :                audit_ipc_obj(ipcp);                                                                                                                                                                                             ▒
         :                requested_mode = (flag >> 6) | (flag >> 3) | flag;                                                                                                                                                               ▒
         :                granted_mode = ipcp->mode;                                                                                                                                                                                       ▒
         :                if (uid_eq(euid, ipcp->cuid) ||                                                                                                                                                                                  ▒
    0.02 :        ffffffff81255fb0:       45 3b 6c 24 18          cmp    0x18(%r12),%r13d                                                                                                                                                  ▒
         :                kuid_t euid = current_euid();                                                                                                                                                                                    ▒
         :                int requested_mode, granted_mode;                                                                                                                                                                                ▒
         :                                                                                                                                                                                                                                 ▒
         :                audit_ipc_obj(ipcp);                                                                                                                                                                                             ▒
         :                requested_mode = (flag >> 6) | (flag >> 3) | flag;                                                                                                                                                               ▒
         :                granted_mode = ipcp->mode;                                                                                                                                                                                       ▒
   99.18 :        ffffffff81255fb5:       41 0f b7 5c 24 20       movzwl 0x20(%r12),%ebx                                                                                                                                                   ▒
         :                if (uid_eq(euid, ipcp->cuid) ||                                                                                                                                                                                  ▒
    0.46 :        ffffffff81255fbb:       74 07                   je     ffffffff81255fc4 <ipcperms+0x64>                                                                                                                                  ▒
    0.00 :        ffffffff81255fbd:       45 3b 6c 24 10          cmp    0x10(%r12),%r13d                                                                                                                                                  ▒
    0.00 :        ffffffff81255fc2:       75 5c                   jne    ffffffff81256020 <ipcperms+0xc0>                                                                                                                                  ▒
         :                    uid_eq(euid, ipcp->uid))                                                                                                                                                                                     ▒
         :                        granted_mode >>= 6;                                                                                                                                                                                      ▮
    0.02 :        ffffffff81255fc4:       c1 fb 06                sar    $0x6,%ebx                                                                                                                                                         ▒
         :                else if (in_group_p(ipcp->cgid) || in_group_p(ipcp->gid))                                                                                                                                                        ▒
         :                        granted_mode >>= 3;                                                                                                                                                                                      ▒
         :                /* is there some bit set in requested_mode but not in granted_mode? */                                                                                                                                           ▒
         :                if ((requested_mode & ~granted_mode & 0007) &&                                                                                                                                                                   ▒
    0.00 :        ffffffff81255fc7:       44 89 f0                mov    %r14d,%eax                                                                                                                                                        ▒
    0.00 :        ffffffff81255fca:       44 89 f2                mov    %r14d,%edx                                                                                                                                                        ▒
    0.00 :        ffffffff81255fcd:       f7 d3                   not    %ebx                                                                                                                                                              ▒
    0.02 :        ffffffff81255fcf:       66 c1 f8 06             sar    $0x6,%ax                                                                                                                                                          ▒
    0.00 :        ffffffff81255fd3:       66 c1 fa 03             sar    $0x3,%dx                                                                                                                                                          ▒
    0.00 :        ffffffff81255fd7:       09 d0                   or     %edx,%eax                                                                                                                                                         ▒
    0.02 :        ffffffff81255fd9:       44 09 f0                or     %r14d,%eax                                                                                                                                                        ▒
    0.00 :        ffffffff81255fdc:       83 e0 07                and    $0x7,%eax                                                                                                                                                         ▒
    0.00 :        ffffffff81255fdf:       85 d8                   test   %ebx,%eax                                                                                                                                                         ▒
    0.00 :        ffffffff81255fe1:       75 75                   jne    ffffffff81256058 <ipcperms+0xf8>                                                                                                                                  ▒
         :                    !ns_capable(ns-





