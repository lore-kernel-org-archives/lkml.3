Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbaA0K2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:28:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51361 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaA0K2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:28:16 -0500
Date: Mon, 27 Jan 2014 11:27:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
Message-ID: <20140127102759.GY11314@laptop.programming.kicks-ass.net>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 02:28:15PM -0800, Linus Torvalds wrote:
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 1e96c3628bf2..15b5953da958 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -658,30 +658,24 @@ sysret_check:
>  	/* Handle reschedules */
>  	/* edx:	work, edi: workmask */
>  sysret_careful:
>  	TRACE_IRQS_ON
>  	ENABLE_INTERRUPTS(CLBR_NONE)
> +	SAVE_REST
> +	FIXUP_TOP_OF_STACK %r11
> +	movq %rsp,%rdi
> +	movl %edx,%esi
> +	call syscall_exit_slowpath
> +	movl $_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT,%edi
> +	testl %eax,%eax
> +	jne sysret_using_iret
> +	addq $REST_SKIP,%rsp
> +	jmp sysret_check;

Obviously I don't particularly like the SAVE_REST/FIXUP_TOP_OF_STACK
being added to the reschedule path.

Can't we do as Al suggested earlier and have 2 slowpath calls, one
without PT_REGS and one with?

That said, yes its a nice cleanup, entry.S always hurts my brain.
