Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab3JIOYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:24:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab3JIOYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:24:44 -0400
Date: Wed, 9 Oct 2013 16:17:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Richard Henderson <rth@twiddle.net>,
        Jakub Jelinek <jakub@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131009141737.GA16168@redhat.com>
References: <20131005234430.GA22485@localhost> <CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com> <20131008143400.GA14721@redhat.com> <20131009080459.GA2298@localhost> <20131009124310.GA11769@redhat.com> <20131009140734.GH3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009140734.GH3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, thanks...

I didn't notice Richard and Jakub were not cc'ed... Add them, perhaps
they can take a look.

On 10/09, Peter Zijlstra wrote:
>
> On Wed, Oct 09, 2013 at 02:43:10PM +0200, Oleg Nesterov wrote:
> > I'm afraid I am wrong, my asm skills are close to zero... but this
> > code looks wrong to me, and this can explain the oopses.
> >
> > > task_work_add:
> > > 	pushl	%ebp	#
> > > 	movl	%esp, %ebp	#,
> > > 	pushl	%edi	#
> > > 	pushl	%esi	#
> > > 	pushl	%ebx	#
> > > 	subl	$12, %esp	#,
> > > 	call	mcount
> > > 	movl	%eax, %edi	# task, task
> > > 	movl	%edx, -16(%ebp)	# work, %sfp
> > > 	movb	%cl, -21(%ebp)	# notify, %sfp
> > > 	.p2align 4,,15
> > > .L3:
> > > 	movl	904(%edi), %esi	# task_3(D)->task_works, head
> > > 	cmpl	$work_exited, %esi	#, head
> > > 	sete	%bl	#, D.14145
> > > 	andl	$255, %ebx	#, D.14145
> > > 	xorl	%ecx, %ecx	#
> > > 	movl	%ebx, %edx	# D.14145,
> > > 	movl	$______f.14042, %eax	#,
> > > 	call	ftrace_likely_update	#
> > > 	testl	%ebx, %ebx	# D.14145
> > > 	jne	.L4	#,
> > > 	movl	-16(%ebp), %edx	# %sfp,
> > > 	movl	%esi, (%edx)	# head, work_13(D)->next
> > > 	movl	%esi, %eax	# head, __ret
> > > #APP
> > > # 34 "/c/wfg/tip/kernel/task_work.c" 1
> > > 	cmpxchgl %edx,904(%edi)	#, *__ptr_16
> > > # 0 "" 2
> > > #NO_APP
> > > 	cmpl	%eax, %esi	# __ret, head
> > > 	jne	.L3	#,
> >
> > OK, we added the new work successfully, we should return 0. If we return
> > non-zero, fput() (the likely caller) assumes that it should use the workqueues
> > to close/free this file. Then later task_work_run() will do __fput() again.
> >
> > > 	cmpb	$0, -21(%ebp)	#, %sfp
> > > 	je	.L5	#,
> > > 	movl	4(%edi), %eax	# task_3(D)->stack, task_3(D)->stack
> > > #APP
> > > # 208 "/c/wfg/tip/arch/x86/include/asm/bitops.h" 1
> > > 	bts $1, 8(%eax); jc .L2	#, MEM[(volatile long unsigned int *)D.14203_29],
> >
> > This is set_notify_resume(). Probably !CONFIG_SMP (I do not see kick_process).
> >
> > > # 0 "" 2
> > > #NO_APP
> > > .L5:
> > > 	movl	$0, -20(%ebp)	#, %sfp
> > > .L2:
> > > 	movl	-20(%ebp), %eax	# %sfp,
> >
> > This is what we are going to return. But note that -20(%ebp) was not
> > initialized if TIF_NOTIFY_RESUME was already set, "jc .L2" skips .L5
> > above. IOW, in this case we seem to return a random value from stack.
>
> I think you're quite right, and I can confirm I can reproduce this with
> gcc-4.8.1 and Wu's .config:
>
>         .p2align 4,,15
>         .globl  task_work_add
>         .type   task_work_add, @function
> task_work_add:
>         pushl   %ebp    #
>         movl    %esp, %ebp      #,
>         pushl   %edi    #
>         pushl   %esi    #
>         pushl   %ebx    #
>         subl    $12, %esp       #,
>         call    mcount
>         movl    %eax, %esi      # task, task
>         movl    %edx, %edi      # work, work
>         movl    %ecx, -24(%ebp) # notify, %sfp
>         jmp     .L4     #
>         .p2align 4,,15
> .L9:
>         movl    %ebx, (%edi)    # __old, work_15(D)->next
>         movl    %ebx, %eax      # __old, __ret
> #APP
> # 34 "/usr/src/linux-2.6/kernel/task_work.c" 1
>         cmpxchgl %edi,904(%esi) # work, *__ptr_17
> # 0 "" 2
> #NO_APP
>         cmpl    %eax, %ebx      # __ret, __old
>         je      .L8     #,
> .L4:
>         movl    904(%esi), %ebx # task_7(D)->task_works, __old
>         cmpl    $work_exited, %ebx      #, __old
>         sete    -13(%ebp)       #, %sfp
>         xorl    %edx, %edx      # ______r
>         movb    -13(%ebp), %dl  # %sfp, ______r
>         xorl    %ecx, %ecx      #
>         movl    $______f.14204, %eax    #,
>         call    ftrace_likely_update    #
>         cmpb    $0, -13(%ebp)   #, %sfp
>         je      .L9     #,
>         movl    $-3, -20(%ebp)  #, %sfp
> .L2:
>         movl    -20(%ebp), %eax # %sfp,
>         addl    $12, %esp       #,
>         popl    %ebx    #
>         popl    %esi    #
>         popl    %edi    #
>         popl    %ebp    #
>         ret
>         .p2align 4,,15
> .L8:
>         cmpb    $0, -24(%ebp)   #, %sfp
>         je      .L6     #,
>         movl    4(%esi), %eax   # task_7(D)->stack, task_7(D)->stack
> #APP
> # 208 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h" 1
>         bts $1, 8(%eax); jc .L2 #, MEM[(volatile long unsigned int *)_23],
> # 0 "" 2
> #NO_APP
> .L6:
>         movl    $0, -20(%ebp)   #, %sfp
>         movl    -20(%ebp), %eax # %sfp,
>         addl    $12, %esp       #,
>         popl    %ebx    #
>         popl    %esi    #
>         popl    %edi    #
>         popl    %ebp    #
>         ret
>         .size   task_work_add, .-task_work_add
>
> Once I force a x86_64 build using the 'same' config it goes away and
> generates 'sensible' code again (although I don't see why L9 isn't
> merged with L2):
>
>         .p2align 4,,15
>         .globl  task_work_add
>         .type   task_work_add, @function
> task_work_add:
>         call    __fentry__
>         pushq   %rbp    #
>         movq    %rsp, %rbp      #,
>         pushq   %r15    #
>         pushq   %r14    #
>         movl    %edx, %r14d     # notify, notify
>         pushq   %r13    #
>         movq    %rsi, %r13      # work, work
>         pushq   %r12    #
>         movq    %rdi, %r12      # task, task
>         pushq   %rbx    #
>         jmp     .L4     #
>         .p2align 4,,10
>         .p2align 3
> .L11:
>         movq    %rbx, 0(%r13)   # __old, work_17(D)->next
>         movq    %rbx, %rax      # __old, __ret
> #APP
> # 34 "/usr/src/linux-2.6/kernel/task_work.c" 1
>         cmpxchgq %r13,1312(%r12)        # work, *__ptr_19
> # 0 "" 2
> #NO_APP
>         cmpq    %rax, %rbx      # __ret, __old
>         je      .L10    #,
> .L4:
>         movq    1312(%r12), %rbx        # task_7(D)->task_works, __old
>         movq    $______f.14855, %rdi    #,
>         cmpq    $work_exited, %rbx      #, __old
>         sete    %r15b   #, tmp72
>         xorl    %edx, %edx      #
>         movzbl  %r15b, %esi     # tmp72, ______r
>         call    ftrace_likely_update    #
>         testb   %r15b, %r15b    # tmp72
>         je      .L11    #,
>         movl    $-3, %eax       #, D.15034
> .L2:
>         popq    %rbx    #
>         popq    %r12    #
>         popq    %r13    #
>         popq    %r14    #
>         popq    %r15    #
>         popq    %rbp    #
>         ret
>         .p2align 4,,10
>         .p2align 3
> .L10:
>         xorl    %eax, %eax      # D.15034
>         testb   %r14b, %r14b    # notify
>         je      .L2     #,
>         movq    8(%r12), %rdx   # task_7(D)->stack, task_7(D)->stack
> #APP
> # 208 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h" 1
>         bts $1, 16(%rdx); jc .L9        #, MEM[(volatile long unsigned int *)_25],
> # 0 "" 2
> #NO_APP
> .L9:
>         popq    %rbx    #
>         popq    %r12    #
>         popq    %r13    #
>         popq    %r14    #
>         popq    %r15    #
>         popq    %rbp    #
>         ret
>         .size   task_work_add, .-task_work_add
>
>

