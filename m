Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbaELRye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:54:34 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:38178 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbaELRyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:54:32 -0400
Message-ID: <53710AD5.504@linaro.org>
Date: Mon, 12 May 2014 10:54:29 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: linux-kernel@vger.kernel.org, Alexander Gordeev <lasaine@lvk.cs.msu.su>
Subject: Re: [PATCH] ntp: make is_error_status() use its argument
References: <20140512133548.31421.qmail@ns.horizon.com>
In-Reply-To: <20140512133548.31421.qmail@ns.horizon.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 06:35 AM, George Spelvin wrote:
> It's an inline function always called with the global time_status as an
> argument, so there's zero functional difference, but the non-CONFIG_SMP
> version uses the passed-in argument, while the CONFIG_SMP one ignores
> its argument and uses the global.

CONFIG_NTP_PPS not CONFIG_SMP, right?

Good catch though, looks like the check code was re-factored out, but
someone forgot to use the local variable.

Adding Alexander since he submitted the pps logic.

If there's no objections, I'll queue this (with a more verbose commit
message) for 3.16

thanks
-john


>     
> Make it use the argument always; shorter variable names are good.
>
> Signed-off-by: George Spelvin <linux@horizon.com>
> ---
> While poking about in the code, I came across this rather odd bit.
> It looked worth fixing, on general principles.
>
> diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
> index 419a52cecd..1a2aad3fff 100644
> --- a/kernel/time/ntp.c
> +++ b/kernel/time/ntp.c
> @@ -165,21 +165,21 @@ static inline void pps_set_freq(s64 freq)
>  
>  static inline int is_error_status(int status)
>  {
> -	return (time_status & (STA_UNSYNC|STA_CLOCKERR))
> +	return (status & (STA_UNSYNC|STA_CLOCKERR))
>  		/* PPS signal lost when either PPS time or
>  		 * PPS frequency synchronization requested
>  		 */
> -		|| ((time_status & (STA_PPSFREQ|STA_PPSTIME))
> -			&& !(time_status & STA_PPSSIGNAL))
> +		|| ((status & (STA_PPSFREQ|STA_PPSTIME))
> +			&& !(status & STA_PPSSIGNAL))
>  		/* PPS jitter exceeded when
>  		 * PPS time synchronization requested */
> -		|| ((time_status & (STA_PPSTIME|STA_PPSJITTER))
> +		|| ((status & (STA_PPSTIME|STA_PPSJITTER))
>  			== (STA_PPSTIME|STA_PPSJITTER))
>  		/* PPS wander exceeded or calibration error when
>  		 * PPS frequency synchronization requested
>  		 */
> -		|| ((time_status & STA_PPSFREQ)
> -			&& (time_status & (STA_PPSWANDER|STA_PPSERROR)));
> +		|| ((status & STA_PPSFREQ)
> +			&& (status & (STA_PPSWANDER|STA_PPSERROR)));
>  }
>  
>  static inline void pps_fill_timex(struct timex *txc)

