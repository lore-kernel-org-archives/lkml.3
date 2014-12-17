Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaLQSXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:23:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbaLQSXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 13:23:49 -0500
Date: Wed, 17 Dec 2014 13:22:41 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141217182241.GA4821@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
	Peter Anvin <hpa@linux.intel.com>
References: <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
 <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212185454.GB4716@redhat.com>
 <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
 <20141213165915.GA12756@redhat.com>
 <20141213223616.GA22559@redhat.com>
 <CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
 <20141214234654.GA396@redhat.com>
 <CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 04:38:00PM -0800, Linus Torvalds wrote:

 > And I could fairly easily imagine endless page faults due to the
 > exception table, or even endless signal handling loops due to getting
 > a signal while trying to handle a signal. Both things that would
 > actually reasonably result in a watchdog.
 > 
 > So I'm adding some x86 FPU save people to the cc.
 > 
 > Can anybody make sense of that backtrace, keeping in mind that we're
 > looking for some kind of endless loop where we don't make progress?
 > 
 > There's more in the original email (see on lkml if you haven't seen
 > the thread earlier already), but they look similar with that whole
 > do_signal -> save_xstate_sig -> do_page_fault thing just on other
 > CPU's.
 > 
 > DaveJ, do you have the kernel image for this? I'd love to see what the
 > code is around that "save_xstate_sig+0x81" or around those
 > __clear_user+0x17/0x36 points...

Finally back in front of that machine.

Here's save_xstate_sig:

ve_xstate_sig>:
ffffffff8100f370:       e8 0b 2b 7c 00          callq  ffffffff817d1e80 <__fentry__>
ffffffff8100f375:       55                      push   %rbp
ffffffff8100f376:       48 63 d2                movslq %edx,%rdx
ffffffff8100f379:       48 89 e5                mov    %rsp,%rbp
ffffffff8100f37c:       41 57                   push   %r15
ffffffff8100f37e:       41 56                   push   %r14
ffffffff8100f380:       45 31 f6                xor    %r14d,%r14d
ffffffff8100f383:       41 55                   push   %r13
ffffffff8100f385:       41 54                   push   %r12
ffffffff8100f387:       49 89 fc                mov    %rdi,%r12
ffffffff8100f38a:       53                      push   %rbx
ffffffff8100f38b:       48 89 f3                mov    %rsi,%rbx
ffffffff8100f38e:       48 83 ec 18             sub    $0x18,%rsp
ffffffff8100f392:       65 4c 8b 2c 25 00 aa    mov    %gs:0xaa00,%r13
ffffffff8100f399:       00 00 
ffffffff8100f39b:       48 39 f7                cmp    %rsi,%rdi
ffffffff8100f39e:       4d 8b bd 98 05 00 00    mov    0x598(%r13),%r15
ffffffff8100f3a5:       41 0f 95 c6             setne  %r14b
ffffffff8100f3a9:       65 48 8b 04 25 08 aa    mov    %gs:0xaa08,%rax
ffffffff8100f3b0:       00 00 
ffffffff8100f3b2:       48 01 fa                add    %rdi,%rdx
ffffffff8100f3b5:       48 8b 88 48 c0 ff ff    mov    -0x3fb8(%rax),%rcx
ffffffff8100f3bc:       b8 f3 ff ff ff          mov    $0xfffffff3,%eax
ffffffff8100f3c1:       0f 82 00 01 00 00       jb     ffffffff8100f4c7 <save_xstate_sig+0x157>
ffffffff8100f3c7:       48 39 d1                cmp    %rdx,%rcx
ffffffff8100f3ca:       0f 82 f7 00 00 00       jb     ffffffff8100f4c7 <save_xstate_sig+0x157>
ffffffff8100f3d0:       41 8b 85 94 05 00 00    mov    0x594(%r13),%eax
ffffffff8100f3d7:       85 c0                   test   %eax,%eax
ffffffff8100f3d9:       74 3d                   je     ffffffff8100f418 <save_xstate_sig+0xa8>
ffffffff8100f3db:       e9 00 01 00 00          jmpq   ffffffff8100f4e0 <save_xstate_sig+0x170>
ffffffff8100f3e0:       48 8d bb 00 02 00 00    lea    0x200(%rbx),%rdi
ffffffff8100f3e7:       be 40 00 00 00          mov    $0x40,%esi
ffffffff8100f3ec:       e8 3f 5e 36 00          callq  ffffffff81375230 <__clear_user>
ffffffff8100f3f1:       85 c0                   test   %eax,%eax
ffffffff8100f3f3:       0f 85 81 01 00 00       jne    ffffffff8100f57a <save_xstate_sig+0x20a>
ffffffff8100f3f9:       ba ff ff ff ff          mov    $0xffffffff,%edx
ffffffff8100f3fe:       89 c1                   mov    %eax,%ecx
ffffffff8100f400:       48 89 df                mov    %rbx,%rdi
ffffffff8100f403:       89 d0                   mov    %edx,%eax
ffffffff8100f405:       0f 1f 00                nopl   (%rax)
ffffffff8100f408:       48 0f ae 27             xsave64 (%rdi)
ffffffff8100f40c:       0f 1f 00                nopl   (%rax)
ffffffff8100f40f:       e9 ea 00 00 00          jmpq   ffffffff8100f4fe <save_xstate_sig+0x18e>
ffffffff8100f414:       0f 1f 40 00             nopl   0x0(%rax)
ffffffff8100f418:       e9 33 01 00 00          jmpq   ffffffff8100f550 <save_xstate_sig+0x1e0>
ffffffff8100f41d:       4c 89 ef                mov    %r13,%rdi
ffffffff8100f420:       e8 1b fe ff ff          callq  ffffffff8100f240 <__sanitize_i387_state>
ffffffff8100f425:       8b 05 95 d5 0b 01       mov    0x10bd595(%rip),%eax        # ffffffff820cc9c0 <xstate_size>
ffffffff8100f42b:       89 45 cc                mov    %eax,-0x34(%rbp)
ffffffff8100f42e:       e8 7d 33 19 00          callq  ffffffff811a27b0 <might_fault>
ffffffff8100f433:       48 89 df                mov    %rbx,%rdi
ffffffff8100f436:       4c 89 fe                mov    %r15,%rsi
ffffffff8100f439:       8b 55 cc                mov    -0x34(%rbp),%edx
ffffffff8100f43c:       e8 2f 44 36 00          callq  ffffffff81373870 <copy_user_generic_unrolled>
ffffffff8100f441:       85 c0                   test   %eax,%eax
ffffffff8100f443:       0f 85 27 01 00 00       jne    ffffffff8100f570 <save_xstate_sig+0x200>
ffffffff8100f449:       45 85 f6                test   %r14d,%r14d
ffffffff8100f44c:       0f 85 c4 00 00 00       jne    ffffffff8100f516 <save_xstate_sig+0x1a6>
ffffffff8100f452:       49 c7 c4 60 cd 0c 82    mov    $0xffffffff820ccd60,%r12
ffffffff8100f459:       e8 52 33 19 00          callq  ffffffff811a27b0 <might_fault>
ffffffff8100f45e:       48 8d bb d0 01 00 00    lea    0x1d0(%rbx),%rdi
ffffffff8100f465:       4c 89 e6                mov    %r12,%rsi
ffffffff8100f468:       ba 30 00 00 00          mov    $0x30,%edx
ffffffff8100f46d:       e8 fe 43 36 00          callq  ffffffff81373870 <copy_user_generic_unrolled>
ffffffff8100f472:       41 89 c5                mov    %eax,%r13d
ffffffff8100f475:       41 89 c4                mov    %eax,%r12d
ffffffff8100f478:       e9 bb 00 00 00          jmpq   ffffffff8100f538 <save_xstate_sig+0x1c8>
ffffffff8100f47d:       31 d2                   xor    %edx,%edx
ffffffff8100f47f:       8b 05 3b d5 0b 01       mov    0x10bd53b(%rip),%eax        # ffffffff820cc9c0 <xstate_size>
ffffffff8100f485:       41 89 d4                mov    %edx,%r12d
ffffffff8100f488:       0f 1f 00                nopl   (%rax)
ffffffff8100f48b:       c7 04 03 45 58 50 46    movl   $0x46505845,(%rbx,%rax,1)
ffffffff8100f492:       0f 1f 00                nopl   (%rax)
ffffffff8100f495:       89 d0                   mov    %edx,%eax
ffffffff8100f497:       0f 1f 00                nopl   (%rax)
ffffffff8100f49a:       8b 8b 00 02 00 00       mov    0x200(%rbx),%ecx
ffffffff8100f4a0:       0f 1f 00                nopl   (%rax)
ffffffff8100f4a3:       41 09 c4                or     %eax,%r12d
ffffffff8100f4a6:       83 c9 03                or     $0x3,%ecx
ffffffff8100f4a9:       89 d0                   mov    %edx,%eax
ffffffff8100f4ab:       45 09 ec                or     %r13d,%r12d
ffffffff8100f4ae:       0f 1f 00                nopl   (%rax)
ffffffff8100f4b1:       89 8b 00 02 00 00       mov    %ecx,0x200(%rbx)
ffffffff8100f4b7:       0f 1f 00                nopl   (%rax)
ffffffff8100f4ba:       41 09 c4                or     %eax,%r12d
ffffffff8100f4bd:       31 c0                   xor    %eax,%eax
ffffffff8100f4bf:       45 85 e4                test   %r12d,%r12d
ffffffff8100f4c2:       0f 95 c0                setne  %al
ffffffff8100f4c5:       f7 d8                   neg    %eax
ffffffff8100f4c7:       48 83 c4 18             add    $0x18,%rsp
ffffffff8100f4cb:       5b                      pop    %rbx
ffffffff8100f4cc:       41 5c                   pop    %r12
ffffffff8100f4ce:       41 5d                   pop    %r13
ffffffff8100f4d0:       41 5e                   pop    %r14
ffffffff8100f4d2:       41 5f                   pop    %r15
ffffffff8100f4d4:       5d                      pop    %rbp
ffffffff8100f4d5:       c3                      retq   



and  __clear_user :

ffffffff81375230 <__clear_user>:
ffffffff81375230:       e8 4b cc 45 00          callq  ffffffff817d1e80 <__fentry__>
ffffffff81375235:       55                      push   %rbp
ffffffff81375236:       48 89 e5                mov    %rsp,%rbp
ffffffff81375239:       41 54                   push   %r12
ffffffff8137523b:       49 89 fc                mov    %rdi,%r12
ffffffff8137523e:       53                      push   %rbx
ffffffff8137523f:       48 89 f3                mov    %rsi,%rbx
ffffffff81375242:       e8 69 d5 e2 ff          callq  ffffffff811a27b0 <might_fault>
ffffffff81375247:       0f 1f 00                nopl   (%rax)
ffffffff8137524a:       48 89 d8                mov    %rbx,%rax
ffffffff8137524d:       48 c1 eb 03             shr    $0x3,%rbx
ffffffff81375251:       4c 89 e7                mov    %r12,%rdi
ffffffff81375254:       83 e0 07                and    $0x7,%eax
ffffffff81375257:       48 89 d9                mov    %rbx,%rcx
ffffffff8137525a:       be 08 00 00 00          mov    $0x8,%esi
ffffffff8137525f:       31 d2                   xor    %edx,%edx
ffffffff81375261:       48 85 c9                test   %rcx,%rcx
ffffffff81375264:       74 0a                   je     ffffffff81375270 <__clear_user+0x40>
ffffffff81375266:       48 89 17                mov    %rdx,(%rdi)
ffffffff81375269:       48 01 f7                add    %rsi,%rdi
ffffffff8137526c:       ff c9                   dec    %ecx
ffffffff8137526e:       75 f6                   jne    ffffffff81375266 <__clear_user+0x36>
ffffffff81375270:       48 89 c1                mov    %rax,%rcx
ffffffff81375273:       85 c9                   test   %ecx,%ecx
ffffffff81375275:       74 09                   je     ffffffff81375280 <__clear_user+0x50>
ffffffff81375277:       88 17                   mov    %dl,(%rdi)
ffffffff81375279:       48 ff c7                inc    %rdi
ffffffff8137527c:       ff c9                   dec    %ecx
ffffffff8137527e:       75 f7                   jne    ffffffff81375277 <__clear_user+0x47>
ffffffff81375280:       0f 1f 00                nopl   (%rax)
ffffffff81375283:       5b                      pop    %rbx
ffffffff81375284:       48 89 c8                mov    %rcx,%rax
ffffffff81375287:       41 5c                   pop    %r12
ffffffff81375289:       5d                      pop    %rbp
ffffffff8137528a:       c3                      retq   
ffffffff8137528b:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)


If you need more, I've kept the vmlinux handy.  I'm going to try your two patches
on top of .18, with the same kernel config, and see where that takes us.
Hopefully to happier places.

	Dave

