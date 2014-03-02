Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaCAXp7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 18:45:59 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52886 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753328AbaCAXp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 18:45:56 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, nm@ti.com,
        swarren@wwwdotorg.org, kgene.kim@samsung.com, jinchoi@broadcom.com,
        tianyu.lan@intel.com, sebastian.capella@linaro.org,
        jhbird.choi@samsung.com
Subject: Re: [PATCH V6 2/7] cpufreq: suspend governors from dpm_{suspend|resume}()
Date: Sun, 02 Mar 2014 01:01:03 +0100
Message-ID: <3426517.B7CbpxFO4d@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5b79cd9aa706d988d242d80d73cfe67c0e6c5b3d.1392629003.git.viresh.kumar@linaro.org>
References: <cover.1392629003.git.viresh.kumar@linaro.org> <5b79cd9aa706d988d242d80d73cfe67c0e6c5b3d.1392629003.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 17, 2014 02:55:08 PM Viresh Kumar wrote:
> Previous patch added support for suspending governors, with callbacks being
> called from dpm_{suspend|resume}_noirq(). The problem here is that most of the
> devices (i.e. devices with ->suspend() callbacks) have already been suspended by
> now and so if drivers want to change frequency before suspending, then it might
> not be possible for many platforms (which depend on other peripherals like i2c,
> regulators, etc).
> 
> So, we actually need to do this from dpm_{suspend|resume}() instead. This patch
> does it.

Please fold this into [1/7].

> Tested-by: Lan Tianyu <tianyu.lan@intel.com>
> Tested-by: Nishanth Menon <nm@ti.com>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/base/power/main.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index da49882..0f82012 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -582,7 +582,6 @@ static void dpm_resume_noirq(pm_message_t state)
>  	dpm_show_time(starttime, state, "noirq");
>  	resume_device_irqs();
>  	cpuidle_resume();
> -	cpufreq_resume();
>  }
>  
>  /**
> @@ -858,6 +857,8 @@ void dpm_resume(pm_message_t state)
>  	mutex_unlock(&dpm_list_mtx);
>  	async_synchronize_full();
>  	dpm_show_time(starttime, state, NULL);
> +
> +	cpufreq_resume();
>  }
>  
>  /**
> @@ -1063,7 +1064,6 @@ static int dpm_suspend_noirq(pm_message_t state)
>  	ktime_t starttime = ktime_get();
>  	int error = 0;
>  
> -	cpufreq_suspend();
>  	cpuidle_pause();
>  	suspend_device_irqs();
>  	mutex_lock(&dpm_list_mtx);
> @@ -1415,6 +1415,8 @@ int dpm_suspend(pm_message_t state)
>  
>  	might_sleep();
>  
> +	cpufreq_suspend();
> +
>  	mutex_lock(&dpm_list_mtx);
>  	pm_transition = state;
>  	async_error = 0;
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
