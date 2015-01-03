Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbbACEG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 23:06:59 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:57360 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbbACEG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 23:06:58 -0500
Message-ID: <54A76ADE.5070305@amacapital.net>
Date: Fri, 02 Jan 2015 20:06:54 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>
CC: Sasha Levin <sasha.levin@oracle.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] time: settimeofday: Validate the values of tv from
 user
References: <1420228268-2161-1-git-send-email-john.stultz@linaro.org> <1420228268-2161-2-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1420228268-2161-2-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2015 11:51 AM, John Stultz wrote:
> From: Sasha Levin <sasha.levin@oracle.com>
> 
> An unvalidated user input is multiplied by a constant, which can result in
> an undefined behaviour for large values. While this is validated later,
> we should avoid triggering undefined behaviour.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  include/linux/time.h | 13 +++++++++++++
>  kernel/time/time.c   |  4 ++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/include/linux/time.h b/include/linux/time.h
> index 8c42cf8..7a10ec1 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -99,6 +99,19 @@ static inline bool timespec_valid_strict(const struct timespec *ts)
>  	return true;
>  }
>  
> +static inline bool timeval_valid(const struct timeval *tv)
> +{
> +	/* Dates before 1970 are bogus */
> +	if (tv->tv_sec < 0)
> +		return false;
> +
> +	/* Can't have more miliseconds then a second */

Trivial nit: that should be "microseconds".

--Andy

> +	if (tv->tv_usec < 0 || tv->tv_usec >= USEC_PER_SEC)
> +		return false;
> +
> +	return true;
> +}
> +
>  extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
>  
>  #define CURRENT_TIME		(current_kernel_time())
> diff --git a/kernel/time/time.c b/kernel/time/time.c
> index a9ae20f..22d5d3b 100644
> --- a/kernel/time/time.c
> +++ b/kernel/time/time.c
> @@ -196,6 +196,10 @@ SYSCALL_DEFINE2(settimeofday, struct timeval __user *, tv,
>  	if (tv) {
>  		if (copy_from_user(&user_tv, tv, sizeof(*tv)))
>  			return -EFAULT;
> +
> +		if (!timeval_valid(&user_tv))
> +			return -EINVAL;
> +
>  		new_ts.tv_sec = user_tv.tv_sec;
>  		new_ts.tv_nsec = user_tv.tv_usec * NSEC_PER_USEC;
>  	}
> 

