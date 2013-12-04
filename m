Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab3LDV3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 16:29:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697Ab3LDV3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 16:29:20 -0500
Date: Wed, 4 Dec 2013 16:29:16 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ben Zhang <benzh@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] watchdog: Add a sysctl to disable soft lockup detector
Message-ID: <20131204212916.GJ35219@redhat.com>
References: <1386107674-15903-1-git-send-email-benzh@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386107674-15903-1-git-send-email-benzh@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 01:54:34PM -0800, Ben Zhang wrote:
> This provides usermode a way to disable only the soft
> lockup detector while keeping the hard lockup detector
> running.
> 
> kernel.softlockup_detector_enable=1:
> This is the default. The soft lockup detector is enabled.
> When a soft lockup is detected, a warning message with
> debug info is printed. The kernel may be configured to
> panics in this case via the sysctl kernel.softlockup_panic.
> 
> kernel.softlockup_detector_enable=0:
> The soft lockup detector is disabled. Warning message is
> not printed on soft lockup. The kernel does not panic on
> soft lockup regardless of the value of kernel.softlockup_panic.
> Note kernel.softlockup_detector_enable does not affect
> the hard lockup detector.

As Andrew said, I wouldn't mind see an explaination for the need.

The softlockup was designed to be always running when the hardlockup
detector was running (though this patch is cute way to work around that).

So your patch disables the check but not the overhead.  I am not sure if
that would confuse an end user or not.

Cheers,
Don

> 
> Signed-off-by: Ben Zhang <benzh@chromium.org>
> ---
>  include/linux/sched.h |  1 +
>  kernel/sysctl.c       |  9 +++++++++
>  kernel/watchdog.c     | 15 +++++++++++++++
>  3 files changed, 25 insertions(+)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 768b037..93ebec4 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -270,6 +270,7 @@ extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
>  				  void __user *buffer,
>  				  size_t *lenp, loff_t *ppos);
>  extern unsigned int  softlockup_panic;
> +extern unsigned int  softlockup_detector_enable;
>  void lockup_detector_init(void);
>  #else
>  static inline void touch_softlockup_watchdog(void)
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 34a6047..8ae1f36 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -840,6 +840,15 @@ static struct ctl_table kern_table[] = {
>  		.extra2		= &one,
>  	},
>  	{
> +		.procname	= "softlockup_detector_enable",
> +		.data		= &softlockup_detector_enable,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= &zero,
> +		.extra2		= &one,
> +	},
> +	{
>  		.procname       = "nmi_watchdog",
>  		.data           = &watchdog_user_enabled,
>  		.maxlen         = sizeof (int),
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 4431610..b9594e6 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -80,6 +80,18 @@ static int __init softlockup_panic_setup(char *str)
>  }
>  __setup("softlockup_panic=", softlockup_panic_setup);
>  
> +unsigned int __read_mostly softlockup_detector_enable = 1;
> +
> +static int __init softlockup_detector_enable_setup(char *str)
> +{
> +	unsigned long res;
> +	if (kstrtoul(str, 0, &res))
> +		res = 1;
> +	softlockup_detector_enable = res;
> +	return 1;
> +}
> +__setup("softlockup_detector_enable=", softlockup_detector_enable_setup);
> +
>  static int __init nowatchdog_setup(char *str)
>  {
>  	watchdog_user_enabled = 0;
> @@ -293,6 +305,9 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>  		return HRTIMER_RESTART;
>  	}
>  
> +	if (!softlockup_detector_enable)
> +		return HRTIMER_RESTART;
> +
>  	/* check for a softlockup
>  	 * This is done by making sure a high priority task is
>  	 * being scheduled.  The task touches the watchdog to
> -- 
> 1.8.4.1
> 
