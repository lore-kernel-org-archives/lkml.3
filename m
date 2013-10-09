Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab3JIMuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:50:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab3JIMuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:50:15 -0400
Date: Wed, 9 Oct 2013 14:43:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131009124310.GA11769@redhat.com>
References: <20131005234430.GA22485@localhost> <CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com> <20131008143400.GA14721@redhat.com> <20131009080459.GA2298@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009080459.GA2298@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fengguang,

On 10/09, Fengguang Wu wrote:
>
> Thanks for looking into this. Attached is the task_work.s for you.

Thanks a lot!

I'm afraid I am wrong, my asm skills are close to zero... but this
code looks wrong to me, and this can explain the oopses.

> task_work_add:
> 	pushl	%ebp	#
> 	movl	%esp, %ebp	#,
> 	pushl	%edi	#
> 	pushl	%esi	#
> 	pushl	%ebx	#
> 	subl	$12, %esp	#,
> 	call	mcount
> 	movl	%eax, %edi	# task, task
> 	movl	%edx, -16(%ebp)	# work, %sfp
> 	movb	%cl, -21(%ebp)	# notify, %sfp
> 	.p2align 4,,15
> .L3:
> 	movl	904(%edi), %esi	# task_3(D)->task_works, head
> 	cmpl	$work_exited, %esi	#, head
> 	sete	%bl	#, D.14145
> 	andl	$255, %ebx	#, D.14145
> 	xorl	%ecx, %ecx	#
> 	movl	%ebx, %edx	# D.14145,
> 	movl	$______f.14042, %eax	#,
> 	call	ftrace_likely_update	#
> 	testl	%ebx, %ebx	# D.14145
> 	jne	.L4	#,
> 	movl	-16(%ebp), %edx	# %sfp,
> 	movl	%esi, (%edx)	# head, work_13(D)->next
> 	movl	%esi, %eax	# head, __ret
> #APP
> # 34 "/c/wfg/tip/kernel/task_work.c" 1
> 	cmpxchgl %edx,904(%edi)	#, *__ptr_16
> # 0 "" 2
> #NO_APP
> 	cmpl	%eax, %esi	# __ret, head
> 	jne	.L3	#,

OK, we added the new work successfully, we should return 0. If we return
non-zero, fput() (the likely caller) assumes that it should use the workqueues
to close/free this file. Then later task_work_run() will do __fput() again.

> 	cmpb	$0, -21(%ebp)	#, %sfp
> 	je	.L5	#,
> 	movl	4(%edi), %eax	# task_3(D)->stack, task_3(D)->stack
> #APP
> # 208 "/c/wfg/tip/arch/x86/include/asm/bitops.h" 1
> 	bts $1, 8(%eax); jc .L2	#, MEM[(volatile long unsigned int *)D.14203_29],

This is set_notify_resume(). Probably !CONFIG_SMP (I do not see kick_process).

> # 0 "" 2
> #NO_APP
> .L5:
> 	movl	$0, -20(%ebp)	#, %sfp
> .L2:
> 	movl	-20(%ebp), %eax	# %sfp,

This is what we are going to return. But note that -20(%ebp) was not
initialized if TIF_NOTIFY_RESUME was already set, "jc .L2" skips .L5
above. IOW, in this case we seem to return a random value from stack.

Oleg.

