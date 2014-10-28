Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaJ1Pnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:43:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:49571 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaJ1Pnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:43:45 -0400
Date: Tue, 28 Oct 2014 16:43:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Heena Sirwani <heenasirwani@gmail.com>
cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, arnd@arndb.de
Subject: Re: [PATCH v2] timekeeping: Added a function to return tv_sec portion
 of ktime_get_real_ts64()
In-Reply-To: <20141027050804.GA8550@heena-HP-Compaq-8200-Elite-MT-PC>
Message-ID: <alpine.DEB.2.11.1410281641350.5308@nanos>
References: <20141027050804.GA8550@heena-HP-Compaq-8200-Elite-MT-PC>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Heena Sirwani wrote:
> The following patch adds a function to return tv_sec portion of
> ktime_get_real_ts64() function in order to have a function that returns
> seconds as 64-bit integers instead of 32-bit integers to address the
> y2038 problem.
> 
> The function is similar to get_seconds() function except that it
> includes read_seqcount_retry loop which is required for 32-bit
> architectures. This is because 32-bit machines cannot access 64-bit
> tk->xtime_sec variable atomically, requiring two 32-bit register loads.
>  
> Signed-off-by: Heena Sirwani <heenasirwani@gmail.com>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Changes in v2:
>         - Removed the local variable nsecs as it was not required.
> 
>  include/linux/timekeeping.h |  1 +
>  kernel/time/timekeeping.c   | 19 +++++++++++++++++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
> index 115d55e..91454de 100644
> --- a/include/linux/timekeeping.h
> +++ b/include/linux/timekeeping.h
> @@ -29,6 +29,7 @@ struct timespec get_monotonic_coarse(void);
>  extern void getrawmonotonic(struct timespec *ts);
>  extern void ktime_get_ts64(struct timespec64 *ts);
>  extern time64_t ktime_get_seconds(void);
> +extern time64_t ktime_get_real_seconds(void);
>  
>  extern int __getnstimeofday64(struct timespec64 *tv);
>  extern void getnstimeofday64(struct timespec64 *tv);
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 93fc596..c17c620 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -673,6 +673,25 @@ time64_t ktime_get_seconds(void)
>  }
>  EXPORT_SYMBOL_GPL(ktime_get_seconds);
>  
> +time64_t ktime_get_real_seconds(void)
> +{
> +	time64_t seconds;
> +	struct timekeeper *tk = &tk_core.timekeeper;
> +	unsigned int seq;
> +
> +	if (IS_ENABLED(CONFIG_64BIT))
> +		return tk->xtime_sec;
> +
> +	do {
> +		seq = read_seqcount_begin(&tk_core.seq);
> +		seconds = tk->xtime_sec;
> +
> +	} while (read_seqcount_retry(&tk_core.seq, seq));
> +
> +	return seconds;
> +}
> +EXPORT_SYMBOL_GPL(ktime_get_real_seconds);

Nice and clean implementation! Though I wonder whether we should just
name it get_seconds64().

Thanks,

	tglx
