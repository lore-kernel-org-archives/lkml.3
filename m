Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937032Ab3DIOz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:55:58 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:57036 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934477Ab3DIOz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:55:57 -0400
Date: Tue, 9 Apr 2013 22:55:46 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: tglx <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        mingo@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Fix 32bit race in sched_clock_remote()
Message-ID: <20130409145546.GA14231@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1365179800.2609.135.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1365179800.2609.135.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 06:36:40PM +0200, Peter Zijlstra wrote:
> Thomas spotted a nasty 32bit race in sched_clock_remote() after way too
> many hours of debugging weirdness.
> 
> What happens is that sched_clock_remote() does regular machine word
> reads of sched_clock_data::clock; this appears safe since we use
> cmpxchg64() to update the variable and any half-read value would
> trigger a retry.
> 
> Except we don't validate the new value 'val' in the same way! Thus we
> can propagate non-atomic read errors into the clock value.
> 
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Debugged-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched/clock.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
> index c685e31..7042ef7 100644
> --- a/kernel/sched/clock.c
> +++ b/kernel/sched/clock.c
> @@ -170,6 +170,21 @@ static u64 sched_clock_local(struct sched_clock_data *scd)
>  	return clock;
>  }
>  
> +#ifndef CONFIG_64BIT
> +/*
> + * 32bit machines can't atomically read a u64 except using cmpxchg64()
> + */
> +static inline u64 scd_read_clock(struct sched_clock_data *scd)
> +{
> +	return cmpxchg64(&scd->clock, 0, 0);
> +}
> +#else
> +static inline u64 scd_read_clock(struct sched_clock_data *scd)
> +{
> +	return scd->clock;
> +}
> +#endif
> +
>  static u64 sched_clock_remote(struct sched_clock_data *scd)
>  {
>  	struct sched_clock_data *my_scd = this_scd();
> @@ -178,8 +193,8 @@ static u64 sched_clock_remote(struct sched_clock_data *scd)
>  
>  	sched_clock_local(my_scd);
>  again:
> -	this_clock = my_scd->clock;
> -	remote_clock = scd->clock;
> +	this_clock = scd_clock_read(my_scd);
> +	remote_clock = scd_clock_read(scd);
		       ^^^^^^^^^^^^^^
		       it doesn't match the declaration: scd_read_clock().

Thanks,
Yong

>  
>  	/*
>  	 * Use the opportunity that we have both locks
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
