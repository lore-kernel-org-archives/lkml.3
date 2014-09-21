Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbaITXpE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 19:45:04 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59203 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751067AbaITXpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 19:45:01 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Amit Pundir <amit.pundir@linaro.org>
Cc: linux-kernel@vger.kernel.org, Todd Poynor <toddpoynor@google.com>,
        Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH v2] PM: Print wall time at suspend entry and exit
Date: Sun, 21 Sep 2014 02:04:45 +0200
Message-ID: <11057554.xulDPUC6Ej@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411082832-4713-1-git-send-email-amit.pundir@linaro.org>
References: <1411082832-4713-1-git-send-email-amit.pundir@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 19, 2014 04:57:12 AM Amit Pundir wrote:
> From: Todd Poynor <toddpoynor@google.com>
> 
> Existing timestamps in a dmesg only log suspend activities
> (e.g. filesystem syncs, freezing/unfreezing tasks etc) while the
> system has already started to enter/exit the suspend state.
> 
> Sometimes it is handy to have suspend entry/exit overhead
> information while debugging suspend issues. This patch print
> markers with wall timestamps at suspend Entry and Exit in
> the kernel log. These timestamps can be used to compute how
> long the system spent in low-power suspend state plus the
> entry/exit overhead.

Don't we already have tracepoints for that?

> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Len Brown <len.brown@intel.com>
> Cc: linux-pm@vger.kernel.org
> Cc: Android Kernel Team <kernel-team@android.com>
> Signed-off-by: Todd Poynor <toddpoynor@google.com>
> [Amit Pundir: Reworded the commit message]
> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> ---
> Resending this patch assuming that it might have got lost in between merge
> window rush last time and now people might have some time to look at it.
> 
>  kernel/power/suspend.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index 18c6219..5390c6c 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -26,6 +26,7 @@
>  #include <linux/suspend.h>
>  #include <linux/syscore_ops.h>
>  #include <linux/ftrace.h>
> +#include <linux/rtc.h>
>  #include <trace/events/power.h>
>  #include <linux/compiler.h>
>  
> @@ -443,6 +444,18 @@ static int enter_state(suspend_state_t state)
>  	return error;
>  }
>  
> +static void pm_suspend_marker(char *annotation)
> +{
> +	struct timespec ts;
> +	struct rtc_time tm;
> +
> +	getnstimeofday(&ts);
> +	rtc_time_to_tm(ts.tv_sec, &tm);
> +	pr_info("PM: suspend %s %d-%02d-%02d %02d:%02d:%02d.%09lu UTC\n",
> +		annotation, tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
> +		tm.tm_hour, tm.tm_min, tm.tm_sec, ts.tv_nsec);
> +}
> +
>  /**
>   * pm_suspend - Externally visible function for suspending the system.
>   * @state: System sleep state to enter.
> @@ -457,6 +470,7 @@ int pm_suspend(suspend_state_t state)
>  	if (state <= PM_SUSPEND_ON || state >= PM_SUSPEND_MAX)
>  		return -EINVAL;
>  
> +	pm_suspend_marker("entry");
>  	error = enter_state(state);
>  	if (error) {
>  		suspend_stats.fail++;
> @@ -464,6 +478,7 @@ int pm_suspend(suspend_state_t state)
>  	} else {
>  		suspend_stats.success++;
>  	}
> +	pm_suspend_marker("exit");
>  	return error;
>  }
>  EXPORT_SYMBOL(pm_suspend);
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
