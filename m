Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab3IANPS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 09:15:18 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49723 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab3IANPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 09:15:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: sboyd@codeaurora.org, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cpufreq: don't allow governor limits to be changed when it is disabled
Date: Sun, 01 Sep 2013 15:26:05 +0200
Message-ID: <5575182.3vsARQoTdN@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <085013f4e584e3fef97187bcb349c3fa76942e19.1378012620.git.viresh.kumar@linaro.org>
References: <085013f4e584e3fef97187bcb349c3fa76942e19.1378012620.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, September 01, 2013 10:56:01 AM Viresh Kumar wrote:
> __cpufreq_governor() returns with -EBUSY when governor is already stopped and we
> try to stop it again, but when it is stopped we must not allow calls to
> CPUFREQ_GOV_LIMITS event as well.
> 
> This patch adds this check in __cpufreq_governor().
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> Hi Rafael,
> 
> Its better if we can get these in for 3.11, otherwise we need to get them in the
> stable tree..

There's no way they could go into 3.11 or even 3.12 without speding time
in linux-next.  I'll queue them up for the second part of the 3.12 merge
window, unless there is 3.11-rc8 (which I doubt will happen).

> Anyway, we will get these in 3.10 stable tree but that requires us to identify
> few more patches that will go with these. I will do that later.
> 
> This must fix the issues reported by Stephen.
> 
> Tested on my thinkpad over your linux-next branch.
> 
>  drivers/cpufreq/cpufreq.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 5c75e31..f320a20 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1692,8 +1692,9 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
>  						policy->cpu, event);
>  
>  	mutex_lock(&cpufreq_governor_lock);
> -	if ((!policy->governor_enabled && (event == CPUFREQ_GOV_STOP)) ||
> -	    (policy->governor_enabled && (event == CPUFREQ_GOV_START))) {
> +	if ((policy->governor_enabled && (event == CPUFREQ_GOV_START)) ||
> +		(!policy->governor_enabled && ((event == CPUFREQ_GOV_LIMITS) ||
> +					       (event == CPUFREQ_GOV_STOP)))) {

Broken white space, but never mind.

>  		mutex_unlock(&cpufreq_governor_lock);
>  		return -EBUSY;
>  	}

Thanks,
Rafael

