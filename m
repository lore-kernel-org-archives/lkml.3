Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaEDO6v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 10:58:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbaEDO6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 10:58:50 -0400
Date: Sun, 4 May 2014 16:58:47 +0200
From: Jan Kara <jack@suse.cz>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Bohac <jbohac@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/4] printk: Re-add irqsave/restore in printk_sched
Message-ID: <20140504145847.GA7433@quack.suse.cz>
References: <1399068558-2373-1-git-send-email-john.stultz@linaro.org>
 <1399068558-2373-2-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399068558-2373-2-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 02-05-14 15:09:15, John Stultz wrote:
> A commit in akpm's tree (printk: remove separate printk_sched
> buffers...), removed the printk_sched irqsave/restore lines
> since it was safe for current users. Since we may be expanding
> usage of printk_sched(), re-add the irqsave/restore logic
> to make the functionality more generally safe.
  So I'm just wondering: Do you have anything particular for which you need
interrupts disabled? Won't e.g. disabling preemption be enough?

								Honza

> Cc: Jan Kara <jack@suse.cz>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Jiri Bohac <jbohac@suse.cz>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  kernel/printk/printk.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 82d19e6..bf62f2b 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -2586,15 +2586,18 @@ void wake_up_klogd(void)
>  
>  int printk_sched(const char *fmt, ...)
>  {
> +	unsigned long flags;
>  	va_list args;
>  	int r;
>  
> +	local_irq_save(flags);
>  	va_start(args, fmt);
>  	r = vprintk_emit(0, SCHED_MESSAGE_LOGLEVEL, NULL, 0, fmt, args);
>  	va_end(args);
>  
>  	__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
>  	irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
> +	local_irq_restore(flags);
>  
>  	return r;
>  }
> -- 
> 1.9.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
