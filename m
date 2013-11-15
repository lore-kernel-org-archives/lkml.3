Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab3KOOUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:20:54 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53847 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752791Ab3KOOUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:20:37 -0500
Date: Fri, 15 Nov 2013 14:19:12 +0000
From: Will Deacon <will.deacon@arm.com>
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Subject: Re: [PATCH] arm: check stack pointer in get_wchan
Message-ID: <20131115141912.GE19468@mudshark.cambridge.arm.com>
References: <20131115121907.4707.82671.stgit@buzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115121907.4707.82671.stgit@buzz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 12:19:07PM +0000, Konstantin Khlebnikov wrote:
> get_wchan() is lockless. Task may wakeup at any time and change its own stack,
> thus each next stack frame may be overwritten and filled with random stuff.
> 
> /proc/$pid/stack interface had been disabled for non-current tasks, see [1]
> But 'wchan' still allows to trigger stack frame unwinding on volatile stack.
> 
> This patch fixes oops in unwind_frame() by adding stack pointer validation on
> each step (as x86 code do), unwind_frame() already checks frame pointer.
> 
> Also I've found another report of this oops on stackoverflow (irony).

For that comment alone:

  Acked-by: Will Deacon <will.deacon@arm.com>

[also, the patch looks sane to me].

Will

> Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
> Cc: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
> Link: http://www.spinics.net/lists/arm-kernel/msg110589.html [1]
> Link: http://stackoverflow.com/questions/18479894/unwind-frame-cause-a-kernel-paging-error
> ---
>  arch/arm/kernel/process.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index 94f6b05..92f7b15 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -404,6 +404,7 @@ EXPORT_SYMBOL(dump_fpu);
>  unsigned long get_wchan(struct task_struct *p)
>  {
>  	struct stackframe frame;
> +	unsigned long stack_page;
>  	int count = 0;
>  	if (!p || p == current || p->state == TASK_RUNNING)
>  		return 0;
> @@ -412,9 +413,11 @@ unsigned long get_wchan(struct task_struct *p)
>  	frame.sp = thread_saved_sp(p);
>  	frame.lr = 0;			/* recovered from the stack */
>  	frame.pc = thread_saved_pc(p);
> +	stack_page = (unsigned long)task_stack_page(p);
>  	do {
> -		int ret = unwind_frame(&frame);
> -		if (ret < 0)
> +		if (frame.sp < stack_page ||
> +		    frame.sp >= stack_page + THREAD_SIZE ||
> +		    unwind_frame(&frame) < 0)
>  			return 0;
>  		if (!in_sched_functions(frame.pc))
>  			return frame.pc;
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
