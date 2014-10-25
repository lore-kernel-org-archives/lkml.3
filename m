Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaJYStH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:49:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:50861 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbaJYSsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:48:52 -0400
Date: Sat, 25 Oct 2014 10:36:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: linux-kernel@vger.kernel.org, eparis@redhat.com, przanoni@gmail.com,
        mingo@kernel.org, hpa@linux.intel.com, rgb@redhat.com, hpa@zytor.com
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] i386/audit: stop scribbling on the stack
 frame
In-Reply-To: <tip-26c2d2b39128adba276d140eefa2745591b88536@git.kernel.org>
Message-ID: <alpine.DEB.2.11.1410251034320.5308@nanos>
References: <1414037043-30647-1-git-send-email-eparis@redhat.com> <tip-26c2d2b39128adba276d140eefa2745591b88536@git.kernel.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014, tip-bot for Eric Paris wrote:
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
> +	/* movl PT_EAX(%esp), %eax	already set, syscall number: 1st arg to audit */
> +	movl PT_EBX(%esp), %edx		/* ebx/a0: 2nd arg to audit */
> +	/* movl PT_ECX(%esp), %ecx	already set, a1: 3nd arg to audit */
> +	pushl_cfi PT_ESI(%esp)		/* a3: 5th arg */
> +	pushl_cfi PT_EDX+4(%esp)	/* a2: 4th arg */

Why are we grabbing that from the stack? AFAICT all arguments are in
the registers still.

Thanks,

	tglx
