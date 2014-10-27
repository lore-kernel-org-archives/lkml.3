Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaJ0UwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:52:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:40621 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaJ0UwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:52:22 -0400
Date: Mon, 27 Oct 2014 21:52:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Guy Briggs <rgb@redhat.com>
cc: linux-kernel@vger.kernel.org, eparis@redhat.com, przanoni@gmail.com,
        mingo@kernel.org, hpa@linux.intel.com, hpa@zytor.com,
        linux-tip-commits@vger.kernel.org, linux-audit@redhat.com
Subject: Re: [PATCH] i386/audit: stop scribbling on the stack frame
In-Reply-To: <20141027023457.GY15532@madcap2.tricolour.ca>
Message-ID: <alpine.DEB.2.11.1410272150000.5308@nanos>
References: <1414037043-30647-1-git-send-email-eparis@redhat.com> <tip-26c2d2b39128adba276d140eefa2745591b88536@git.kernel.org> <alpine.DEB.2.11.1410251034320.5308@nanos> <20141027023457.GY15532@madcap2.tricolour.ca>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2014, Richard Guy Briggs wrote:
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index b553ed8..344b63f 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -447,15 +447,14 @@ sysenter_exit:
>  sysenter_audit:
>  	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%ebp)
>  	jnz syscall_trace_entry
> -	addl $4,%esp
> -	CFI_ADJUST_CFA_OFFSET -4
> -	movl %esi,4(%esp)		/* 5th arg: 4th syscall arg */
> -	movl %edx,(%esp)		/* 4th arg: 3rd syscall arg */
> -	/* %ecx already in %ecx		   3rd arg: 2nd syscall arg */
> -	movl %ebx,%edx			/* 2nd arg: 1st syscall arg */
> -	/* %eax already in %eax		   1st arg: syscall number */
> +	/* movl PT_ECX(%esp), %ecx	already set, a1: 3nd arg to audit */
> +	/* movl PT_EAX(%esp), %eax	already set, syscall number: 1st arg to audit */
> +	pushl_cfi %esi			/* a3: 5th arg */
> +	pushl_cfi %edx			/* a2: 4th arg */
> +	movl %ebx, %edx			/* ebx/a0: 2nd arg to audit */
>  	call __audit_syscall_entry
> -	pushl_cfi %ebx
> +	popl_cfi %ecx /* get that remapped edx off the stack */
> +	popl_cfi %ecx /* get that remapped esi off the stack */

Why use pop instead of simply adjusting esp and CFI by 8?

Thanks,

	tglx
