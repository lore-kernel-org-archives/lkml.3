Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaLRVYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 16:24:33 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:48457 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaLRVYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 16:24:32 -0500
MIME-Version: 1.0
In-Reply-To: <1417652569-1649-1-git-send-email-sasha.levin@oracle.com>
References: <1417652569-1649-1-git-send-email-sasha.levin@oracle.com>
Date: Thu, 18 Dec 2014 13:24:30 -0800
Message-ID: <CALAqxLXwjBVWK5qvh+48DKBAfzXScz_kdaR-W2hpD=KcZm4-ZA@mail.gmail.com>
Subject: Re: [PATCH v2] time: settimeofday: validate the values of tv from user
From: John Stultz <john.stultz@linaro.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. I've got this queued. I'm going to run it through some testing and
as long as nothing goes wrong I'll send it on cc'ing stable.

thanks
-john

On Wed, Dec 3, 2014 at 4:22 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> An unvalidated user input is multiplied by a constant, which can result in
> an undefined behaviour for large values. While this is validated later,
> we should avoid triggering undefined behaviour.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  include/linux/time.h |   13 +++++++++++++
>  kernel/time/time.c   |    4 ++++
>  2 files changed, 17 insertions(+)
>
> diff --git a/include/linux/time.h b/include/linux/time.h
> index 203c2ad..851d822 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -110,6 +110,19 @@ static inline bool timespec_valid_strict(const struct timespec *ts)
>         return true;
>  }
>
> +static inline bool timeval_valid(const struct timeval *tv)
> +{
> +       /* Dates before 1970 are bogus */
> +       if (tv->tv_sec < 0)
> +               return false;
> +
> +       /* Can't have more miliseconds then a second */
> +       if (tv->tv_usec < 0 || tv->tv_usec >= USEC_PER_SEC)
> +               return false;
> +
> +       return true;
> +}
> +
>  extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
>
>  #define CURRENT_TIME           (current_kernel_time())
> diff --git a/kernel/time/time.c b/kernel/time/time.c
> index 58c4c7c..d54ca39 100644
> --- a/kernel/time/time.c
> +++ b/kernel/time/time.c
> @@ -200,6 +200,10 @@ SYSCALL_DEFINE2(settimeofday, struct timeval __user *, tv,
>         if (tv) {
>                 if (copy_from_user(&user_tv, tv, sizeof(*tv)))
>                         return -EFAULT;
> +
> +               if (!timeval_valid(&user_tv))
> +                       return -EINVAL;
> +
>                 new_ts.tv_sec = user_tv.tv_sec;
>                 new_ts.tv_nsec = user_tv.tv_usec * NSEC_PER_USEC;
>         }
> --
> 1.7.10.4
>
