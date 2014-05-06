Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934767AbaEFKKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 06:10:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60378 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934643AbaEFKKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 06:10:51 -0400
Date: Tue, 6 May 2014 12:10:50 +0200
From: Jan Kara <jack@suse.cz>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Bohac <jbohac@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/4] printk: Disable preemption for printk_sched
Message-ID: <20140506101050.GC9291@quack.suse.cz>
References: <1399322864-22861-1-git-send-email-john.stultz@linaro.org>
 <1399322864-22861-2-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399322864-22861-2-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 05-05-14 13:47:41, John Stultz wrote:
> An earlier change in -mm (printk: remove separate printk_sched
> buffers...), removed the printk_sched irqsave/restore lines
> since it was safe for current users. Since we may be expanding
> usage of printk_sched(), disable preepmtion for this function
> to make it more generally safe to call.
  Looks good to me. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

							Honza
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Jiri Bohac <jbohac@suse.cz>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  kernel/printk/printk.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 82d19e6..57467df 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -2589,12 +2589,14 @@ int printk_sched(const char *fmt, ...)
>  	va_list args;
>  	int r;
>  
> +	preempt_disable();
>  	va_start(args, fmt);
>  	r = vprintk_emit(0, SCHED_MESSAGE_LOGLEVEL, NULL, 0, fmt, args);
>  	va_end(args);
>  
>  	__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
>  	irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
> +	preempt_enable();
>  
>  	return r;
>  }
> -- 
> 1.9.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
