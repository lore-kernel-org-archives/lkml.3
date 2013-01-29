Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab3A2LgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 06:36:10 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:58443 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab3A2LgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 06:36:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: fli24 <fei.li@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, chuansheng.liu@intel.com
Subject: Re: [PATCH] suspend: enable freeze timeout configuration through sysctl
Date: Tue, 29 Jan 2013 12:42:16 +0100
Message-ID: <2146878.OLeVueUb0g@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1359428300.3211.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
References: <1359428300.3211.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 29, 2013 10:58:20 AM fli24 wrote:
> 
> At present, the timeout value for freezing tasks is fixed as 20s,
> which is too long for handheld device usage, especially for mobile
> phone.
> 
> In order to improve user experience, we enable freeze timeout
> configuration through sysctl, so that we can tune the value easily
> for concrete usage, such as smaller value for handheld device such
> as mobile phone.

Well, I'd argue that you shouldn't see freeze problems on such systems.
If you're seeing them, it's better to fix them than to try to hide them
from users (they are problems after all).

Do you have a specific example in which that new knob will be useful?

Why do you want to do that through sysctl and not sysfs?

Rafael


> Signed-off-by: Liu Chuansheng <chuansheng.liu@intel.com>
> Signed-off-by: Li Fei <fei.li@intel.com>
> ---
>  include/linux/freezer.h |    5 +++++
>  kernel/power/process.c  |    4 ++--
>  kernel/sysctl.c         |   12 ++++++++++++
>  3 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> index e4238ce..f37b3be 100644
> --- a/include/linux/freezer.h
> +++ b/include/linux/freezer.h
> @@ -13,6 +13,11 @@ extern bool pm_freezing;		/* PM freezing in effect */
>  extern bool pm_nosig_freezing;		/* PM nosig freezing in effect */
>  
>  /*
> + * Timeout for stopping processes
> + */
> +extern unsigned int sysctl_freeze_process_timeout_secs;
> +
> +/*
>   * Check if a process has been frozen
>   */
>  static inline bool frozen(struct task_struct *p)
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index d5a258b..f7eb7c9 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -21,7 +21,7 @@
>  /* 
>   * Timeout for stopping processes
>   */
> -#define TIMEOUT	(20 * HZ)
> +unsigned int __read_mostly sysctl_freeze_process_timeout_secs = 20;
>  
>  static int try_to_freeze_tasks(bool user_only)
>  {
> @@ -36,7 +36,7 @@ static int try_to_freeze_tasks(bool user_only)
>  
>  	do_gettimeofday(&start);
>  
> -	end_time = jiffies + TIMEOUT;
> +	end_time = jiffies + sysctl_freeze_process_timeout_secs * HZ;
>  
>  	if (!user_only)
>  		freeze_workqueues_begin();
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index c88878d..f88bcb9 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -90,6 +90,9 @@
>  #include <linux/nmi.h>
>  #endif
>  
> +#ifdef CONFIG_FREEZER
> +#include <linux/freezer.h>
> +#endif
>  
>  #if defined(CONFIG_SYSCTL)
>  
> @@ -1047,6 +1050,15 @@ static struct ctl_table kern_table[] = {
>  		.proc_handler	= proc_dointvec,
>  	},
>  #endif
> +#ifdef CONFIG_FREEZER
> +	{
> +		.procname	= "freeze_process_timeout_secs",
> +		.data		= &sysctl_freeze_process_timeout_secs,
> +		.maxlen		= sizeof(unsigned int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec,
> +	},
> +#endif
>  	{ }
>  };
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
