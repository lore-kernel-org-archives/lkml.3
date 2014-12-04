Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaLDCjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 21:39:01 -0500
Received: from ozlabs.org ([103.22.144.67]:40714 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbaLDCi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 21:38:59 -0500
Message-ID: <1417660737.19381.1.camel@concordia>
Subject: Re: +
 all-arches-signal-move-restart_block-to-struct-task_struct.patch added to
 -mm tree
From: Michael Ellerman <mpe@ellerman.id.au>
To: luto@amacapital.net
Cc: LKML <linux-kernel@vger.kernel.org>,
        mm-commits <mm-commits@vger.kernel.org>, akpm@linux-foundation.org
Date: Thu, 04 Dec 2014 13:38:57 +1100
In-Reply-To: <547fa457.hlgB/Ig+t6HXFsjh%akpm@linux-foundation.org>
References: <547fa457.hlgB/Ig+t6HXFsjh%akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 16:01 -0800, akpm@linux-foundation.org wrote:
> The patch titled
>      Subject: all arches, signal: move restart_block to struct task_struct
> has been added to the -mm tree.  Its filename is
>      all-arches-signal-move-restart_block-to-struct-task_struct.patch
> 
> ------------------------------------------------------
> From: Andy Lutomirski <luto@amacapital.net>
> Subject: all arches, signal: move restart_block to struct task_struct
> 
> diff -puN arch/powerpc/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/powerpc/include/asm/thread_info.h
> --- a/arch/powerpc/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
> +++ a/arch/powerpc/include/asm/thread_info.h
> @@ -43,7 +43,6 @@ struct thread_info {
>  	int		cpu;			/* cpu we're on */
>  	int		preempt_count;		/* 0 => preemptable,
>  						   <0 => BUG */
> -	struct restart_block restart_block;
>  	unsigned long	local_flags;		/* private flags for thread */
>  
>  	/* low level flags - has atomic operations done on it */
> @@ -59,9 +58,6 @@ struct thread_info {
>  	.exec_domain =	&default_exec_domain,	\
>  	.cpu =		0,			\
>  	.preempt_count = INIT_PREEMPT_COUNT,	\
> -	.restart_block = {			\
> -		.fn = do_no_restart_syscall,	\
> -	},					\
>  	.flags =	0,			\
>  }
>  
> diff -puN arch/powerpc/kernel/signal_32.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/powerpc/kernel/signal_32.c
> --- a/arch/powerpc/kernel/signal_32.c~all-arches-signal-move-restart_block-to-struct-task_struct
> +++ a/arch/powerpc/kernel/signal_32.c
> @@ -1231,7 +1231,7 @@ long sys_rt_sigreturn(int r3, int r4, in
>  	int tm_restore = 0;
>  #endif
>  	/* Always make any pending restarted system calls return -EINTR */
> -	current_thread_info()->restart_block.fn = do_no_restart_syscall;
> +	current->restart_block.fn = do_no_restart_syscall;
>  
>  	rt_sf = (struct rt_sigframe __user *)
>  		(regs->gpr[1] + __SIGNAL_FRAMESIZE + 16);
> @@ -1504,7 +1504,7 @@ long sys_sigreturn(int r3, int r4, int r
>  #endif
>  
>  	/* Always make any pending restarted system calls return -EINTR */
> -	current_thread_info()->restart_block.fn = do_no_restart_syscall;
> +	current->restart_block.fn = do_no_restart_syscall;
>  
>  	sf = (struct sigframe __user *)(regs->gpr[1] + __SIGNAL_FRAMESIZE);
>  	sc = &sf->sctx;
> diff -puN arch/powerpc/kernel/signal_64.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/powerpc/kernel/signal_64.c
> --- a/arch/powerpc/kernel/signal_64.c~all-arches-signal-move-restart_block-to-struct-task_struct
> +++ a/arch/powerpc/kernel/signal_64.c
> @@ -666,7 +666,7 @@ int sys_rt_sigreturn(unsigned long r3, u
>  #endif
>  
>  	/* Always make any pending restarted system calls return -EINTR */
> -	current_thread_info()->restart_block.fn = do_no_restart_syscall;
> +	current->restart_block.fn = do_no_restart_syscall;
>  
>  	if (!access_ok(VERIFY_READ, uc, sizeof(*uc)))
>  		goto badframe;


This looks OK to me.

Gave it a quick boot test and it seems happy. I assume if you'd broken it
things would have gone badly pretty fast :)

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

cheers


