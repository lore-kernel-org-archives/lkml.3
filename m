Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760735AbaJ3Otm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:49:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:35709 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760524AbaJ3Otk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:49:40 -0400
Date: Thu, 30 Oct 2014 15:49:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "pang.xunlei" <pang.xunlei@linaro.org>
cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        xen-devel@lists.xenproject.org, John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [RFC PATCH v2 05/11] time: Convert all users of do_settimeofday()
 to use do_settimeofday64()
In-Reply-To: <1414667745-7703-6-git-send-email-pang.xunlei@linaro.org>
Message-ID: <alpine.DEB.2.11.1410301507350.5308@nanos>
References: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org> <1414667745-7703-6-git-send-email-pang.xunlei@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014, pang.xunlei wrote:

> As part of addressing 2038 saftey for in-kernel uses, this patch
> converts all users of do_settimeofday() to use do_settimeofday64().

You forgot to insert 'blindly' between 'converts' and 'all'.

> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -486,6 +486,7 @@ static void __init xen_time_init(void)
>  {
>  	int cpu = smp_processor_id();
>  	struct timespec tp;
> +	struct timespec64 tp64;
>  
>  	clocksource_register_hz(&xen_clocksource, NSEC_PER_SEC);
>  
> @@ -496,9 +497,13 @@ static void __init xen_time_init(void)
>  		xen_clockevent = &xen_vcpuop_clockevent;
>  	}
>  
> -	/* Set initial system time with full resolution */
> +	/*
> +	 * Set initial system time with full resolution
> +	 * TODO: [2038 safety] xen_read_wallclock() uses timespec64

This is the wrong approach, really.

First of all this wants to be a seperate patch. Secondly it wants to
be a patch series which addresses the whole XEN space which is
involved in this. That involves other changes to x86 as well, but we
really can do better than mechanically pushing the problem one step
deeper just to get rid of the non safe do_settimeofday() variant.

It does not matter WHEN we remove that. What matters is that we do the
conversion in sensible contexts and not by mechanically pushing the
problem one layer down, leave cryptic TODO comments around and think
we achieved something.

> diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
> index 3b9c9ef..c91167e 100644
> --- a/drivers/hv/hv_util.c
> +++ b/drivers/hv/hv_util.c
> @@ -166,12 +166,12 @@ static void shutdown_onchannelcallback(void *context)
>  static inline void do_adj_guesttime(u64 hosttime)
>  {
>  	s64 host_tns;
> -	struct timespec host_ts;
> +	struct timespec64 host_ts;
>  
>  	host_tns = (hosttime - WLTIMEDELTA) * 100;
> -	host_ts = ns_to_timespec(host_tns);
> +	host_ts = ns_to_timespec64(host_tns);
>  
> -	do_settimeofday(&host_ts);
> +	do_settimeofday64(&host_ts);

That part is obvious, but it wants to be a seperate patch.

>  /*
> diff --git a/drivers/rtc/hctosys.c b/drivers/rtc/hctosys.c
> index 4aa60d7..239400a 100644
> --- a/drivers/rtc/hctosys.c
> +++ b/drivers/rtc/hctosys.c
> @@ -26,7 +26,7 @@ static int __init rtc_hctosys(void)
>  {
>  	int err = -ENODEV;
>  	struct rtc_time tm;
> -	struct timespec tv = {
> +	struct timespec64 tv = {
>  		.tv_nsec = NSEC_PER_SEC >> 1,
>  	};
>  	struct rtc_device *rtc = rtc_class_open(CONFIG_RTC_HCTOSYS_DEVICE);
> @@ -52,16 +52,16 @@ static int __init rtc_hctosys(void)
>  		goto err_invalid;
>  	}
>  
> -	rtc_tm_to_time(&tm, &tv.tv_sec);
> +	rtc_tm_to_time64(&tm, &tv.tv_sec);
>  
> -	err = do_settimeofday(&tv);
> +	err = do_settimeofday64(&tv);
>  
>  	dev_info(rtc->dev.parent,
>  		"setting system clock to "
> -		"%d-%02d-%02d %02d:%02d:%02d UTC (%u)\n",
> +		"%d-%02d-%02d %02d:%02d:%02d UTC (%llu)\n",
>  		tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
>  		tm.tm_hour, tm.tm_min, tm.tm_sec,
> -		(unsigned int) tv.tv_sec);
> +		(unsigned long long) tv.tv_sec);
>  
>  err_invalid:
>  err_read:

Ditto.

> diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
> index ff4b3e8..01017ff 100644
> --- a/drivers/staging/android/alarm-dev.c
> +++ b/drivers/staging/android/alarm-dev.c
> @@ -152,16 +152,19 @@ static int alarm_wait(void)
>  	return rv;
>  }
>  
> +/* TODO: [2038 safety] alarm_set_rtc() uses timespec64 */
>  static int alarm_set_rtc(struct timespec *ts)
>  {
> +	struct timespec ts64;
>  	struct rtc_time new_rtc_tm;
>  	struct rtc_device *rtc_dev;
>  	unsigned long flags;
>  	int rv = 0;
>  
> -	rtc_time_to_tm(ts->tv_sec, &new_rtc_tm);
> +	ts64 = timespec_to_timespec64(*ts);
> +	rtc_time_to_tm64(ts64.tv_sec, &new_rtc_tm);
>  	rtc_dev = alarmtimer_get_rtcdev();
> -	rv = do_settimeofday(ts);
> +	rv = do_settimeofday64(&ts64);

John: What kind of weird hackery is that alarm-dev thing? This should
rather die than being fixed.

>  	if (rv < 0)
>  		return rv;
>  	if (rtc_dev)
> diff --git a/include/linux/time64.h b/include/linux/time64.h
> index a383147..2f0cde4 100644
> --- a/include/linux/time64.h
> +++ b/include/linux/time64.h
> @@ -3,15 +3,15 @@
>  
>  #include <uapi/linux/time.h>
>  
> -typedef __s64 time64_t;
> -
>  /*
>   * This wants to go into uapi/linux/time.h once we agreed about the
>   * userspace interfaces.
>   */
>  #if __BITS_PER_LONG == 64
> +typedef __kernel_time_t time64_t;
>  # define timespec64 timespec
>  #else
> +typedef __s64 time64_t;
>  struct timespec64 {
>  	time64_t	tv_sec;			/* seconds */
>  	long		tv_nsec;		/* nanoseconds */

This is a completely seperate change and should not be in that patch
at all.

> diff --git a/kernel/compat.c b/kernel/compat.c
> index ebb3c36..29d3234 100644
> --- a/kernel/compat.c
> +++ b/kernel/compat.c
> @@ -1047,6 +1047,7 @@ COMPAT_SYSCALL_DEFINE1(time, compat_time_t __user *, tloc)
>  COMPAT_SYSCALL_DEFINE1(stime, compat_time_t __user *, tptr)
>  {
>  	struct timespec tv;
> +	struct timespec64 tv64;
>  	int err;
>  
>  	if (get_user(tv.tv_sec, tptr))
> @@ -1054,11 +1055,13 @@ COMPAT_SYSCALL_DEFINE1(stime, compat_time_t __user *, tptr)
>  
>  	tv.tv_nsec = 0;
>  
> +	/* TODO: [2038 safety] security_settime() uses timespec64 */

Wrong again. Provide security_settime64() first. Then convert this file in one go.

>  	err = security_settime(&tv, NULL);
>  	if (err)
>  		return err;
>  
> -	do_settimeofday(&tv);
> +	tv64 = timespec_to_timespec64(tv);
> +	do_settimeofday64(&tv64);
>  	return 0;
>  }
>  
> diff --git a/kernel/time/time.c b/kernel/time/time.c
> index f44efdb..5074b9b 100644
> --- a/kernel/time/time.c
> +++ b/kernel/time/time.c
> @@ -82,6 +82,7 @@ SYSCALL_DEFINE1(time, time_t __user *, tloc)
>  SYSCALL_DEFINE1(stime, time_t __user *, tptr)
>  {
>  	struct timespec tv;
> +	struct timespec64 tv64;
>  	int err;
>  
>  	if (get_user(tv.tv_sec, tptr))
> @@ -93,7 +94,8 @@ SYSCALL_DEFINE1(stime, time_t __user *, tptr)
>  	if (err)
>  		return err;
>  
> -	do_settimeofday(&tv);
> +	tv64 = timespec_to_timespec64(tv);
> +	do_settimeofday64(&tv64);
>  	return 0;

Same here.

>  }
>  
> @@ -162,6 +164,7 @@ static inline void warp_clock(void)
>  
>  int do_sys_settimeofday(const struct timespec *tv, const struct timezone *tz)
>  {
> +	struct timespec64 tv64;
>  	static int firsttime = 1;
>  	int error = 0;
>  
> @@ -181,8 +184,12 @@ int do_sys_settimeofday(const struct timespec *tv, const struct timezone *tz)
>  				warp_clock();
>  		}
>  	}
> -	if (tv)
> -		return do_settimeofday(tv);
> +
> +	if (tv) {
> +		tv64 = timespec_to_timespec64(*tv);
> +		return do_settimeofday64(&tv64);

And here.

And once you converted these 3 files, you can remove
security_settime(). That makes a lot more sense than what you are
trying to do here.

Thanks,

	tglx

