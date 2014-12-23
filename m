Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbaLWIa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 03:30:56 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:50883 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbaLWIaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 03:30:55 -0500
Message-ID: <5499283B.7020002@amacapital.net>
Date: Tue, 23 Dec 2014 00:30:51 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: root <chenggang.qin@gmail.com>, linux-kernel@vger.kernel.org
CC: Chenggang Qin <chenggang.qcg@taobao.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>
Subject: Re: [PATCH] perf core: Use KSTK_ESP() instead of pt_regs->sp while
 output user regs
References: <1419315745-20767-1-git-send-email-user@chenggang-laptop>
In-Reply-To: <1419315745-20767-1-git-send-email-user@chenggang-laptop>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2014 10:22 PM, root wrote:
> From: Chenggang Qin <chenggang.qcg@taobao.com>
> 
> For x86_64, the exact value of user stack's esp should be got by KSTK_ESP(current).
> current->thread.usersp is copied from PDA while enter ring0. 
> Now, we output the value of sp from pt_regs. But pt_regs->sp has changed before
> it was pushed into kernel stack.
> 
> So, we cannot get the correct callchain while unwind some user stacks.
> For example, if the stack contains __lll_unlock_wake()/__lll_lock_wait(), the
> callchain will break some times with the latest version of libunwind.
> The root cause is the sp that is used by libunwind may be wrong.
> 
> If we use KSTK_ESP(current), the correct callchain can be got everytime.
> Other architectures also have KSTK_ESP() macro.
> 
> Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Namhyung Kim <namhyung@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Cc: Yanmin Zhang <yanmin.zhang@intel.com>
> 
> ---
>  arch/x86/kernel/perf_regs.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kernel/perf_regs.c b/arch/x86/kernel/perf_regs.c
> index e309cc5..5da8df8 100644
> --- a/arch/x86/kernel/perf_regs.c
> +++ b/arch/x86/kernel/perf_regs.c
> @@ -60,6 +60,9 @@ u64 perf_reg_value(struct pt_regs *regs, int idx)
>  	if (WARN_ON_ONCE(idx >= ARRAY_SIZE(pt_regs_offset)))
>  		return 0;
>  
> +	if (idx == PERF_REG_X86_SP)
> +		return KSTK_ESP(current);
> +

This patch is probably fine, but KSTK_ESP seems to be bogus:

unsigned long KSTK_ESP(struct task_struct *task)
{
	return (test_tsk_thread_flag(task, TIF_IA32)) ?
			(task_pt_regs(task)->sp) : ((task)->thread.usersp);
}

I swear that every time I've looked at anything that references TIF_IA32
in the last two weeks, it's been wrong.  This should be something like:

if (task_thread_info(task)->status & TS_COMPAT)
	return task_pt_regs(task)->sp;
else if (task == current && task is in a syscall)
	return current_user_stack_pointer();
else if (task is not running && task is in a syscall)
	return task->thread.usersp;
else if (task is not in a syscall)
	return task_pt_regs(task)->sp;
else
	we're confused; give up.

What context are you using KSTK_ESP in?

--Andy

>  	return regs_get_register(regs, pt_regs_offset[idx]);
>  }
>  
> 

