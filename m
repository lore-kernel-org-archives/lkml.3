Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaBMAmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 19:42:14 -0500
Received: from mga03.intel.com ([143.182.124.21]:58101 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbaBMAmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 19:42:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,835,1384329600"; 
   d="scan'208";a="340672662"
Message-ID: <52FC14E2.6070402@linux.intel.com>
Date: Thu, 13 Feb 2014 08:42:10 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: dirk.brandewie@gmail.com, linux-pm@vger.kernel.org, rjw@rjwysocki.net
CC: linux-kernel@vger.kernel.org, Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH 2/5] intel_pstate: remove unneeded sample buffers
References: <1392228067-14817-1-git-send-email-dirk.j.brandewie@intel.com> <1392228067-14817-3-git-send-email-dirk.j.brandewie@intel.com>
In-Reply-To: <1392228067-14817-3-git-send-email-dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/13 2:01, dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
> 
> Remove unneeded sample buffers, intel_pstate operates on the most
> recent sample only.  This save some memory and make the code more
> readable.
> 
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> ---
>  drivers/cpufreq/intel_pstate.c | 25 ++++++++++++-------------
>  1 file changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index c788abf..d692b10 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -96,8 +96,7 @@ struct cpudata {
>  	u64	prev_aperf;
>  	u64	prev_mperf;
>  	unsigned long long prev_tsc;
> -	int	sample_ptr;
> -	struct sample samples[SAMPLE_COUNT];
> +	struct sample sample;
>  };
>  
>  static struct cpudata **all_cpu_data;
> @@ -570,15 +569,15 @@ static inline void intel_pstate_sample(struct cpudata *cpu)
>  	rdmsrl(MSR_IA32_MPERF, mperf);
>  	tsc = native_read_tsc();

To be pikcy, just want the ratio more accurate, since aperf and mperf
are a pair, do you want to turn interrupt off to make sure nothing
occurs between reading aperf and mperf? and since native_read_tsc() is
called here, better to put into no interrupt context as well.

Thanks,
-Aubrey

>  
> -	cpu->sample_ptr = (cpu->sample_ptr + 1) % SAMPLE_COUNT;
> -	cpu->samples[cpu->sample_ptr].aperf = aperf;
> -	cpu->samples[cpu->sample_ptr].mperf = mperf;
> -	cpu->samples[cpu->sample_ptr].tsc = tsc;
> -	cpu->samples[cpu->sample_ptr].aperf -= cpu->prev_aperf;
> -	cpu->samples[cpu->sample_ptr].mperf -= cpu->prev_mperf;
> -	cpu->samples[cpu->sample_ptr].tsc -= cpu->prev_tsc;
>  
> -	intel_pstate_calc_busy(cpu, &cpu->samples[cpu->sample_ptr]);
> +	cpu->sample.aperf = aperf;
> +	cpu->sample.mperf = mperf;
> +	cpu->sample.tsc = tsc;
> +	cpu->sample.aperf -= cpu->prev_aperf;
> +	cpu->sample.mperf -= cpu->prev_mperf;
> +	cpu->sample.tsc -= cpu->prev_tsc;
> +
> +	intel_pstate_calc_busy(cpu, &cpu->sample);
>  
>  	cpu->prev_aperf = aperf;
>  	cpu->prev_mperf = mperf;
> @@ -598,7 +597,7 @@ static inline int32_t intel_pstate_get_scaled_busy(struct cpudata *cpu)
>  {
>  	int32_t core_busy, max_pstate, current_pstate;
>  
> -	core_busy = cpu->samples[cpu->sample_ptr].core_pct_busy;
> +	core_busy = cpu->sample.core_pct_busy;
>  	max_pstate = int_tofp(cpu->pstate.max_pstate);
>  	current_pstate = int_tofp(cpu->pstate.current_pstate);
>  	return mul_fp(core_busy, div_fp(max_pstate, current_pstate));
> @@ -631,7 +630,7 @@ static void intel_pstate_timer_func(unsigned long __data)
>  
>  	intel_pstate_sample(cpu);
>  
> -	sample = &cpu->samples[cpu->sample_ptr];
> +	sample = &cpu->sample;
>  
>  	intel_pstate_adjust_busy_pstate(cpu);
>  
> @@ -712,7 +711,7 @@ static unsigned int intel_pstate_get(unsigned int cpu_num)
>  	cpu = all_cpu_data[cpu_num];
>  	if (!cpu)
>  		return 0;
> -	sample = &cpu->samples[cpu->sample_ptr];
> +	sample = &cpu->sample;
>  	return sample->freq;
>  }
>  
> 

