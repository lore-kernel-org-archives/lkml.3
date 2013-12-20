Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab3LTPBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 10:01:37 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62790 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752890Ab3LTPBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 10:01:35 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [PATCH] cpufreq: remove sysfs files for CPU which failed to come back after resume
Date: Fri, 20 Dec 2013 16:14:57 +0100
Message-ID: <2118684.kuZSLHD0UA@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <c6b53b186145559668722120ea1f37d28ddb3177.1387516043.git.viresh.kumar@linaro.org>
References: <c6b53b186145559668722120ea1f37d28ddb3177.1387516043.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 20, 2013 10:38:20 AM Viresh Kumar wrote:
> There are cases where cpufreq_add_dev() may fail for some CPUs during resume.
> With the current code we will still have sysfs cpufreq files for such CPUs, and
> struct cpufreq_policy would be already freed for them. Hence any operation on
> those sysfs files would result in kernel warnings.
> 
> To fix this, lets remove those sysfs files or put the associated kobject in case
> of such errors. Also, to make it simple lets remove the sysfs links from all the
> CPUs (except policy->cpu) during suspend as that operation wouldn't result with a
> loss of sysfs file permissions. And so we will create those links during resume
> as well.
> 
> Reported-and-tested-by: Bjørn Mork <bjorn@mork.no>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c | 61 ++++++++++++++++++++++++-----------------------
>  1 file changed, 31 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 02d534d..cea96c9 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -845,8 +845,7 @@ static void cpufreq_init_policy(struct cpufreq_policy *policy)
>  
>  #ifdef CONFIG_HOTPLUG_CPU
>  static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
> -				  unsigned int cpu, struct device *dev,
> -				  bool frozen)
> +				  unsigned int cpu, struct device *dev)
>  {
>  	int ret = 0;
>  	unsigned long flags;
> @@ -877,9 +876,7 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
>  		}
>  	}
>  
> -	/* Don't touch sysfs links during light-weight init */
> -	if (!frozen)
> -		ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
> +	ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
>  
>  	return ret;
>  }

Well, this just looks odd.  Please do

	return sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");

And I'm fine with the rest of the patch.

Thanks,
Rafael

