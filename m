Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761624Ab3EFXr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:47:28 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:64865 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761560Ab3EFXrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:47:23 -0400
Date: Tue, 7 May 2013 01:47:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: kosaki.motohiro@gmail.com
Cc: linux-kernel@vger.kernel.org, Olivier Langlois <olivier@trillion01.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 1/7] posix-cpu-timers: don't account cpu timer after
 stopped thread runtime accounting
Message-ID: <20130506234717.GA1703@somewhere>
References: <1367556468-4021-1-git-send-email-kosaki.motohiro@gmail.com>
 <1367556468-4021-3-git-send-email-kosaki.motohiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367556468-4021-3-git-send-email-kosaki.motohiro@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 12:47:42AM -0400, kosaki.motohiro@gmail.com wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> When tsk->signal->cputimer->running is 1, signal->cputimer and
> tsk->sum_sched_runtime increase at the same pace because update_curr()
> increases both accounting.
> 
> However, there is one exception. When thread exiting, __exit_signal() turns
> over task's sum_shced_runtime to sig->sum_sched_runtime, but it doesn't stop
> signal->cputimer accounting.
> 
> This inconsistency makes POSIX timer wake up too early. This patch fixes it.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Acked-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  kernel/sched/stats.h |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
> index 2ef90a5..5a0cfc4 100644
> --- a/kernel/sched/stats.h
> +++ b/kernel/sched/stats.h
> @@ -225,6 +225,13 @@ static inline void account_group_exec_runtime(struct task_struct *tsk,
>  	if (!cputimer->running)
>  		return;
>  
> +	/*
> +	 * After turning over se.sum_exec_runtime to sig->sum_sched_runtime
> +	 * in __exit_signal(), we must not account exec_runtime for consistency.
> +	 */
> +	if (unlikely(!tsk->sighand))
> +		return;

Ok, if we want the clock and timer to be consistent, do we also want the same check in
account_group_user_time() and account_group_system_time()? The task can still account
a tick after autoreaping itself between release_task() and the final schedule().

> +
>  	raw_spin_lock(&cputimer->lock);
>  	cputimer->cputime.sum_exec_runtime += ns;
>  	raw_spin_unlock(&cputimer->lock);
> -- 
> 1.7.1
> 
