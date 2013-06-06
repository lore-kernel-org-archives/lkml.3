Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab3FFSvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 14:51:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab3FFSv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 14:51:29 -0400
Date: Thu, 6 Jun 2013 20:47:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Imre Deak <imre.deak@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Jones <davej@redhat.com>,
        David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lukas Czerner <lczerner@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wait: fix false timeouts when using
	wait_event_timeout()
Message-ID: <20130606184703.GA29312@redhat.com>
References: <20130604192818.GA31316@redhat.com> <1370381717.8432.14.camel@ideak-mobl> <1370382051.8432.16.camel@ideak-mobl> <20130605163702.GA26135@redhat.com> <20130605190723.GA4957@redhat.com> <20130606014507.GR10693@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606014507.GR10693@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 06/05, Tejun Heo wrote:
>
> Heh, yeah, this looks good to me and a lot better than trying to do
> the same thing over and over again and ending up with subtle
> differences.

Yes, this is the goal. Of course we could fix wait_event_timout() and
wait_event_interruptible_timeout() without unification, but this would
add more copy-and-paste.

> > Hmm. I compiled the kernel with the patch below,
> >
> > 		$ size vmlinux
> > 		   text	   data	    bss	    dec	    hex	filename
> > 	-	4978601	2935080	10104832	18018513	112f0d1	vmlinux
> > 	+	4977769	2930984	10104832	18013585	112dd91	vmlinux
>
> Nice.  Provided you went over assembly outputs of at least some
> combinations,

I did, and that is why I am surprized by the numbers above.

Yes, gcc optimizes out the unwanted checks but the generated code
differs, of course. And sometimes the difference looks "random" to me.

Simplest example:

	extern wait_queue_head_t WQ;
	extern int COND;

	void we(void)
	{
		wait_event(WQ, COND);
	}

before:
	we:
		pushq	%rbp	#
		movq	%rsp, %rbp	#,
		pushq	%rbx	#
		subq	$56, %rsp	#,
		call	mcount
		movl	COND(%rip), %edx	# COND,
		testl	%edx, %edx	#
		jne	.L5	#,
		leaq	-64(%rbp), %rbx	#, tmp66
		movq	$0, -64(%rbp)	#, __wait
		movq	$autoremove_wake_function, -48(%rbp)	#, __wait.func
	#APP
	# 14 "/home/tmp/K/misc/arch/x86/include/asm/current.h" 1
		movq %gs:current_task,%rax	#, pfo_ret__
	# 0 "" 2
	#NO_APP
		movq	%rax, -56(%rbp)	# pfo_ret__, __wait.private
		leaq	24(%rbx), %rax	#, tmp61
		movq	%rax, -40(%rbp)	# tmp61, __wait.task_list.next
		movq	%rax, -32(%rbp)	# tmp61, __wait.task_list.prev
		.p2align 4,,10
		.p2align 3
	.L4:
		movl	$2, %edx	#,
		movq	%rbx, %rsi	# tmp66,
		movq	$WQ, %rdi	#,
		call	prepare_to_wait	#
		movl	COND(%rip), %eax	# COND,
		testl	%eax, %eax	#
		jne	.L3	#,
		call	schedule	#
		jmp	.L4	#
		.p2align 4,,10
		.p2align 3
	.L3:
		movq	%rbx, %rsi	# tmp66,
		movq	$WQ, %rdi	#,
		call	finish_wait	#
	.L5:
		addq	$56, %rsp	#,
		popq	%rbx	#
		leave
		ret

after:
	we:
		pushq	%rbp	#
		movq	%rsp, %rbp	#,
		pushq	%rbx	#
		subq	$56, %rsp	#,
		call	mcount
		movl	COND(%rip), %edx	# COND,
		testl	%edx, %edx	#
		jne	.L5	#,
		leaq	-64(%rbp), %rbx	#, tmp66
		movq	$0, -64(%rbp)	#, __wait
		movq	$autoremove_wake_function, -48(%rbp)	#, __wait.func
	#APP
	# 14 "/home/tmp/K/misc/arch/x86/include/asm/current.h" 1
		movq %gs:current_task,%rax	#, pfo_ret__
	# 0 "" 2
	#NO_APP
		movq	%rax, -56(%rbp)	# pfo_ret__, __wait.private
		leaq	24(%rbx), %rax	#, tmp61
		movq	%rax, -40(%rbp)	# tmp61, __wait.task_list.next
		movq	%rax, -32(%rbp)	# tmp61, __wait.task_list.prev
		.p2align 4,,10
		.p2align 3
	.L4:
		movl	$2, %edx	#,
		movq	%rbx, %rsi	# tmp66,
		movq	$WQ, %rdi	#,
		call	prepare_to_wait	#
		movl	COND(%rip), %eax	# COND,
		testl	%eax, %eax	#
		je	.L3	#,
		movq	%rbx, %rsi	# tmp66,
		movq	$WQ, %rdi	#,
		call	finish_wait	#
		jmp	.L5	#
		.p2align 4,,10
		.p2align 3
	.L3:
		call	schedule	#
		.p2align 4,,8
		.p2align 3
		jmp	.L4	#
		.p2align 4,,10
		.p2align 3
	.L5:
		addq	$56, %rsp	#,
		popq	%rbx	#
		leave
		.p2align 4,,4
		.p2align 3
		ret

As you can see, with this patch gcc generates a bit more code. But
only because reorderes finish_wait() and inserts the additional nops,
otherwise code the same. I think this difference is not "reliable"
and can be ignored.

But, the code like "return wait_even_timeout(true, non_const_timeout)"
really generates more code and this is correct: the patch tries to fix
the bug (at least I think this is a bug) and the additional code ensures
that __ret != 0.

>  Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks! I'll send this patch soon.

Oleg.

