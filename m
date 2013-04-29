Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab3D2QJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:09:40 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:53015 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436Ab3D2QJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:09:37 -0400
Date: Mon, 29 Apr 2013 18:09:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] ptrace: PTRACE_DETACH should do
 flush_ptrace_hw_breakpoint(child)
Message-ID: <20130429160931.GD31230@somewhere>
References: <20130418184350.GA4407@redhat.com>
 <20130418184425.GA4454@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418184425.GA4454@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 08:44:25PM +0200, Oleg Nesterov wrote:
> Change ptrace_detach() to call flush_ptrace_hw_breakpoint(child).
> This frees the slots for non-ptrace PERF_TYPE_BREAKPOINT users, and
> this ensures that the tracee won't be killed by SIGTRAP triggered by
> the active breakpoints.
> 
> Test-case:
> 
> 	unsigned long encode_dr7(int drnum, int enable, unsigned int type, unsigned int len)
> 	{
> 		unsigned long dr7;
> 
> 		dr7 = ((len | type) & 0xf)
> 			<< (DR_CONTROL_SHIFT + drnum * DR_CONTROL_SIZE);
> 		if (enable)
> 			dr7 |= (DR_GLOBAL_ENABLE << (drnum * DR_ENABLE_SIZE));
> 
> 		return dr7;
> 	}
> 
> 	int write_dr(int pid, int dr, unsigned long val)
> 	{
> 		return ptrace(PTRACE_POKEUSER, pid,
> 				offsetof (struct user, u_debugreg[dr]),
> 				val);
> 	}
> 
> 	void func(void)
> 	{
> 	}
> 
> 	int main(void)
> 	{
> 		int pid, stat;
> 		unsigned long dr7;
> 
> 		pid = fork();
> 		if (!pid) {
> 			assert(ptrace(PTRACE_TRACEME, 0,0,0) == 0);
> 			kill(getpid(), SIGHUP);
> 
> 			func();
> 			return 0x13;
> 		}
> 
> 		assert(pid == waitpid(-1, &stat, 0));
> 		assert(WSTOPSIG(stat) == SIGHUP);
> 
> 		assert(write_dr(pid, 0, (long)func) == 0);
> 		dr7 = encode_dr7(0, 1, DR_RW_EXECUTE, DR_LEN_1);
> 		assert(write_dr(pid, 7, dr7) == 0);
> 
> 		assert(ptrace(PTRACE_DETACH, pid, 0,0) == 0);
> 		assert(pid == waitpid(-1, &stat, 0));
> 		assert(stat == 0x1300);
> 
> 		return 0;
> 	}
> 
> Before this patch the child is killed after PTRACE_DETACH.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/ptrace.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 776ab3b..33752d9 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -467,6 +467,7 @@ static int ptrace_detach(struct task_struct *child, unsigned int data)
>  	/* Architecture-specific hardware disable .. */
>  	ptrace_disable(child);
>  	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
> +	flush_ptrace_hw_breakpoint(child);

So I assume the tracee is still guaranteed to be stopped at that time, right? Or already
killed? But it can't be concurrently killed given the patch you did that prevented that?

I'm just asking to make sure we can't have two concurrent calls to flush_ptrace_hw_breakpoint()
at the same time.

Also it seems to be a regression since we brought the breakpoint/perf infrastructure. But
backporting this patch prior to "ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL"
might be racy. Hmm...

Thanks.

>  
>  	write_lock_irq(&tasklist_lock);
>  	/*
> -- 
> 1.5.5.1
> 
