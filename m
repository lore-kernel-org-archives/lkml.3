Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801AbaDIPZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:25:24 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:37657 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932826AbaDIPZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:25:19 -0400
Date: Wed, 9 Apr 2014 11:25:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: konrad.wilk@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/xen: Fix 32-bit PV guests's usage of kernel_stack
Message-ID: <20140409112517.570b24e9@gandalf.local.home>
In-Reply-To: <1397052401-20220-1-git-send-email-boris.ostrovsky@oracle.com>
References: <1397052401-20220-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Apr 2014 11:12:33 -0400
Boris Ostrovsky <boris.ostrovsky@oracle.com> wrote:

> Commit 198d208df4371734ac4728f69cb585c284d20a15 made 32-bit kernels use
> kernel_stack to point to thread_info. That change missed a couple of
> updates needed by Xen's PV guests:
> 
> 1. kernel_stack needs to be initialized for secondary CPUs
> 2. GET_THREAD_INFO() now uses %fs register which may not be the kernel's
> version when executing xen_iret()
> 
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> ---
>  arch/x86/xen/smp.c        |    3 ++-
>  arch/x86/xen/xen-asm_32.S |    4 ++++
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index a18eadd..7005974 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -441,10 +441,11 @@ static int xen_cpu_up(unsigned int cpu, struct task_struct *idle)
>  	irq_ctx_init(cpu);
>  #else
>  	clear_tsk_thread_flag(idle, TIF_FORK);
> +#endif
>  	per_cpu(kernel_stack, cpu) =
>  		(unsigned long)task_stack_page(idle) -
>  		KERNEL_STACK_OFFSET + THREAD_SIZE;
> -#endif
> +
>  	xen_setup_runstate_info(cpu);
>  	xen_setup_timer(cpu);
>  	xen_init_lock_cpu(cpu);
> diff --git a/arch/x86/xen/xen-asm_32.S b/arch/x86/xen/xen-asm_32.S
> index 33ca6e4..d433637 100644
> --- a/arch/x86/xen/xen-asm_32.S
> +++ b/arch/x86/xen/xen-asm_32.S
> @@ -88,7 +88,11 @@ ENTRY(xen_iret)
>  	 * avoid having to reload %fs

Looks like this patch makes the above comment incorrect.

>  	 */
>  #ifdef CONFIG_SMP
> +	pushw %fs
> +	movl $(__KERNEL_PERCPU), %eax
> +	movl %eax, %fs
>  	GET_THREAD_INFO(%eax)
> +	popw %fs
>  	movl %ss:TI_cpu(%eax), %eax

Hmm, you're using GET_THREAD_INFO() to get the thread info to find the
current CPU for later use to avoid using %fs. ??

Is it possible to just push the cpu on the kernel irq stack and be able
to retrieve it manually? Looks like the only reason to use the
thread_info here is to get to the CPU index for below.

>  	movl %ss:__per_cpu_offset(,%eax,4), %eax
>  	mov %ss:xen_vcpu(%eax), %eax

-- Steve

