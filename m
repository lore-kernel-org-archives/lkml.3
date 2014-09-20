Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbaITL6Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 07:58:16 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:59190 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbaITL6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 07:58:15 -0400
Date: Sat, 20 Sep 2014 06:58:10 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, james.hogan@imgtec.com,
        atomlin@redhat.com, tglx@linutronix.de
Subject: Re: [tip:sched/urgent] sched: Fix end_of_stack()  and location of
 stack canary for architectures using CONFIG_STACK_GROWSUP
Message-ID: <20140920065810.794d6bbd@as>
In-Reply-To: <tip-a3215fb47c7ecb814dc16815245db4f375841268@git.kernel.org>
References: <20140919093505.62681e43@as>
	<tip-a3215fb47c7ecb814dc16815245db4f375841268@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2014 23:42:37 -0700
tip-bot for Chuck Ebbert <tipbot@zytor.com> wrote:

> Commit-ID:  a3215fb47c7ecb814dc16815245db4f375841268
> Gitweb:     http://git.kernel.org/tip/a3215fb47c7ecb814dc16815245db4f375841268
> Author:     Chuck Ebbert <cebbert.lkml@gmail.com>
> AuthorDate: Fri, 19 Sep 2014 09:35:05 -0500
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Sat, 20 Sep 2014 08:38:16 +0200
> 
> sched: Fix end_of_stack() and location of stack canary for architectures using CONFIG_STACK_GROWSUP
> 
> Aaron Tomlin recently posted patches to enable checking the
> stack canary on every task switch:
> 
>   http://lkml.org/lkml/2014/9/12/293
> 
> Looking at the canary code, I realized that every arch
> (except ia64, which adds some space for register spill
> above the stack) shares a definition of end_of_stack()
> that makes it the first long after the threadinfo.
> 
> For stacks that grow down, this low address is correct
> because the stack starts at the end of the thread area
> and grows toward lower addresses. However, for stacks
> that grow up, toward higher addresses, this is wrong.
> (The stack actually grows away from the canary.)
> 
> On these archs end_of_stack() should return the address
> of the last long, at the highest possible address for
> the stack.
> 
> Signed-off-by: Chuck Ebbert <cebbert.lkml@gmail.com>
> Tested-by: James Hogan <james.hogan@imgtec.com> [metag]
> Acked-by: James Hogan <james.hogan@imgtec.com>
> Acked-by: Aaron Tomlin <atomlin@redhat.com>
> Link: http://lkml.kernel.org/r/20140919093505.62681e43@as
> [ Added comments to end_of_stack(). ]
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  include/linux/sched.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 5c2c885..0e20a24 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2608,9 +2608,22 @@ static inline void setup_thread_stack(struct task_struct *p, struct task_struct
>  	task_thread_info(p)->task = p;
>  }
>  
> +/*
> + * Return the address of the first long before (or after,
> + * depending on the architecture's default stack growth
> + * direction) * a task's task_info structure, which is the
> + * kernel stack's last usable spot.
> + *
> + * This is the point of no return, if the stack grows
> + * beyond that position, we corrupt the task's state.
> + */

This comment you added is not correct for archs where the stack grows
up. The threadinfo is always at the lowest address on the stack in
every case. Instead of corrupting the thread info, a stack overflow
will corrupt whatever is on the next page after the stack if it grows
upward.

>  static inline unsigned long *end_of_stack(struct task_struct *p)
>  {
> +#ifdef CONFIG_STACK_GROWSUP
> +	return (unsigned long *)((unsigned long)task_thread_info(p) + THREAD_SIZE) - 1;
> +#else
>  	return (unsigned long *)(task_thread_info(p) + 1);
> +#endif
>  }
>  
>  #endif

