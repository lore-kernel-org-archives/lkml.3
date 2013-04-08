Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936163Ab3DHVRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:17:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6307 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757938Ab3DHVRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:17:00 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=yW1noe_gaAEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=GG96gKI6ZmgA:10 a=VwQbUJbxAAAA:8 a=kcbKClAOYQChjYnbyocA:9 a=QEXdDO2ut3YA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365455818.25498.30.camel@gandalf.local.home>
Subject: Re: [PATCH] sched: Fix 32bit race in sched_clock_remote()
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: tglx <tglx@linutronix.de>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 08 Apr 2013 17:16:58 -0400
In-Reply-To: <1365179800.2609.135.camel@laptop>
References: <1365179800.2609.135.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-05 at 18:36 +0200, Peter Zijlstra wrote:
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

We need to add a Kconfig:

config 32BIT
	depends on BROKEN

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

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
>  
>  	/*
>  	 * Use the opportunity that we have both locks
> 


