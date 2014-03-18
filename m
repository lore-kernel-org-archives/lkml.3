Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617AbaCRTJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 15:09:03 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:43955 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757503AbaCRTI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 15:08:57 -0400
Message-ID: <532899B9.70306@linux.vnet.ibm.com>
Date: Wed, 19 Mar 2014 00:38:41 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: dirk.brandewie@gmail.com
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@rjwysocki.net,
        patrick.marlier@gmail.com, viresh.kumar@linaro.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH 2/2] intel_pstate: Set core to min P state during core
 offline
References: <1394831037-15553-1-git-send-email-dirk.j.brandewie@intel.com> <1395163361-26380-1-git-send-email-dirk.j.brandewie@intel.com> <1395163361-26380-3-git-send-email-dirk.j.brandewie@intel.com>
In-Reply-To: <1395163361-26380-3-git-send-email-dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031819-8256-0000-0000-00000C031130
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2014 10:52 PM, dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
> 
> Change to use ->exit_prepare() callback to do clean up during CPU

->stop()

> hotplug. The requested P state for an offline core will be used by the
> hardware coordination function to select the package P state. If the
> core is under load when it is offlined it will fix the package P state
> floor to the requested P state of offline core.
> 
> Reported-by: Patrick Marlier <patrick.marlier@gmail.com>
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> ---
>  drivers/cpufreq/intel_pstate.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index 2cd36b9..e9092fd 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -447,7 +447,7 @@ static void core_set_pstate(struct cpudata *cpudata, int pstate)
>  	if (limits.no_turbo)
>  		val |= (u64)1 << 32;
> 
> -	wrmsrl(MSR_IA32_PERF_CTL, val);
> +	wrmsrl_on_cpu(cpudata->cpu, MSR_IA32_PERF_CTL, val);
>  }
> 
>  static struct cpu_defaults core_params = {
> @@ -773,16 +773,22 @@ static int intel_pstate_verify_policy(struct cpufreq_policy *policy)
>  	return 0;
>  }
> 
> -static int intel_pstate_cpu_exit(struct cpufreq_policy *policy)
> +static int intel_pstate_cpu_stop(struct cpufreq_policy *policy)
>  {
> -	int cpu = policy->cpu;
> +	int cpu_num = policy->cpu;
> +	struct cpudata *cpu = all_cpu_data[cpu_num];
> +
> +	pr_info("intel_pstate CPU %d exiting\n", cpu_num);
> +
> +	del_timer(&all_cpu_data[cpu_num]->timer);
> +	intel_pstate_set_pstate(cpu, cpu->pstate.min_pstate);
> +	kfree(all_cpu_data[cpu_num]);
> +	all_cpu_data[cpu_num] = NULL;
>

I think it should be relatively simple to keep the intel_pstate_set_pstate()
here inside ->stop() and move the rest of the code to ->exit().

Regards,
Srivatsa S. Bhat
 
> -	del_timer(&all_cpu_data[cpu]->timer);
> -	kfree(all_cpu_data[cpu]);
> -	all_cpu_data[cpu] = NULL;
>  	return 0;
>  }
> 
> +
>  static int intel_pstate_cpu_init(struct cpufreq_policy *policy)
>  {
>  	struct cpudata *cpu;
> @@ -818,7 +824,7 @@ static struct cpufreq_driver intel_pstate_driver = {
>  	.setpolicy	= intel_pstate_set_policy,
>  	.get		= intel_pstate_get,
>  	.init		= intel_pstate_cpu_init,
> -	.exit		= intel_pstate_cpu_exit,
> +	.stop		= intel_pstate_cpu_stop,
>  	.name		= "intel_pstate",
>  };
> 

