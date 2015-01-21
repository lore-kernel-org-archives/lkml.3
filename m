Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130AbbAUKWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:22:50 -0500
Received: from www.linutronix.de ([62.245.132.108]:53568 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbbAUKWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:22:41 -0500
Date: Wed, 21 Jan 2015 11:22:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xunlei Pang <pang.xunlei@linaro.org>
cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Feng Tang <feng.tang@intel.com>, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 1/3] time: Don't bother to run rtc_resume() for nonstop
 clocksource
In-Reply-To: <1421772090-13113-1-git-send-email-pang.xunlei@linaro.org>
Message-ID: <alpine.DEB.2.11.1501211109410.5526@nanos>
References: <1421772090-13113-1-git-send-email-pang.xunlei@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Xunlei Pang wrote:
> ---
>  drivers/rtc/class.c         |  2 +-
>  include/linux/timekeeping.h | 11 +++++++++++
>  kernel/time/timekeeping.c   |  3 ++-
>  3 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
> index 472a5ad..c8f35a5 100644
> --- a/drivers/rtc/class.c
> +++ b/drivers/rtc/class.c
> @@ -102,7 +102,7 @@ static int rtc_resume(struct device *dev)
>  	struct timespec64	sleep_time;
>  	int err;
>  
> -	if (has_persistent_clock())
> +	if (rtc_resume_skip())
>  		return 0;
>  
>  	rtc_hctosys_ret = -ENODEV;
> diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
> index 9b63d13..6f3283b 100644
> --- a/include/linux/timekeeping.h
> +++ b/include/linux/timekeeping.h
> @@ -238,6 +238,17 @@ extern void getnstime_raw_and_real(struct timespec *ts_raw,
>   */
>  extern bool persistent_clock_exist;
>  extern int persistent_clock_is_local;
> +extern bool suspendtime_found;
> +
> +#ifdef CONFIG_RTC_LIB
> +/* Used by rtc_resume() */
> +static inline bool rtc_resume_skip(void)
> +{
> +	return suspendtime_found;
> +}
> +#else
> +static inline void rtc_resume_skip(void) { }
> +#endif

What's the point of this ifdeffery and the inline which is different
than the real one?

>  static inline bool has_persistent_clock(void)
>  {
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 6a93185..586bb5c 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -65,6 +65,7 @@ int __read_mostly timekeeping_suspended;
>  
>  /* Flag for if there is a persistent clock on this platform */
>  bool __read_mostly persistent_clock_exist = false;
> +bool suspendtime_found;

This is horrible. The variable name was ugly already, so now you just
make it global without any thought. Global variables are supposed to
have a proper name which allows us to figure out what they are used
for and to which susbsystem they belong.

Aside of that we have now two different mechanisms to guard
timekeeping_inject_sleeptime64(). One in the rtc code and one in the
timekeeping code itself. This is just wrong.

Thanks,

	tglx

