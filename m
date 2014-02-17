Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaBQItE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:49:04 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:52239 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaBQItC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:49:02 -0500
Message-ID: <5301CBAE.3000102@linux.vnet.ibm.com>
Date: Mon, 17 Feb 2014 14:13:26 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@rjwysocki.net, linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pierre-list@ossman.eu
Subject: Re: [PATCH 2/2] cpufreq: don't call cpufreq_update_policy() on CPU
 addition
References: <15ccc0609cb9ee3db0ad3a95b29bf69d11ea197c.1392375504.git.viresh.kumar@linaro.org> <8f2fc4d6240b567fdb69a0b47f073d174b7ef9b2.1392375504.git.viresh.kumar@linaro.org>
In-Reply-To: <8f2fc4d6240b567fdb69a0b47f073d174b7ef9b2.1392375504.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021708-2000-0000-0000-00000FC2DA9A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 04:30 PM, Viresh Kumar wrote:
> cpufreq_update_policy() is called from two places currently. From a workqueue
> handled queued from cpufreq_bp_resume() for boot CPU and from
> cpufreq_cpu_callback() whenever a CPU is added.
> 
> The first one makes sure that boot CPU is running on the frequency present in
> policy->cpu. But we don't really need a call from cpufreq_cpu_callback(),
> because we always call cpufreq_driver->init() (which will set policy->cur
> correctly) whenever first CPU of any policy is added back. And so every policy
> structure is guaranteed to have the right frequency in policy->cur.
>

This wording is slightly inaccurate. ->init() may or may not set policy->cur
(for example, powernowk8 driver doesn't set it in the init routine)..
But we set it for sure in __cpufreq_add_dev():

1117         if (cpufreq_driver->get) {
1118                 policy->cur = cpufreq_driver->get(policy->cpu);
1119                 if (!policy->cur) {
1120                         pr_err("%s: ->get() failed\n", __func__);
1121                         goto err_get_freq;
1122                 }
1123         }

 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

The reasoning and the code looks good to me.

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> ---
>  drivers/cpufreq/cpufreq.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 383362b..b6eb4ed 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -2194,7 +2194,6 @@ static int cpufreq_cpu_callback(struct notifier_block *nfb,
>  		switch (action & ~CPU_TASKS_FROZEN) {
>  		case CPU_ONLINE:
>  			__cpufreq_add_dev(dev, NULL, frozen);
> -			cpufreq_update_policy(cpu);
>  			break;
> 
>  		case CPU_DOWN_PREPARE:
> 

