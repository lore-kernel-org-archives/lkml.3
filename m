Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab3JJOzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 10:55:06 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35895 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3JJOzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 10:55:03 -0400
Message-ID: <5256BFC4.70604@gmail.com>
Date: Thu, 10 Oct 2013 07:55:00 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Brennan Shacklett <bp.shacklett@gmail.com>
CC: rjw@sisk.pl, viresh.kumar@linaro.org, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org, dirk.brandewie@gmail.com
Subject: Re: [PATCH] cpufreq: intel_pstate: Improve accuracy by not truncating
 until final result
References: <20131003143840.GB6982@hulk.osd.wednet.edu>
In-Reply-To: <20131003143840.GB6982@hulk.osd.wednet.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 07:38 AM, Brennan Shacklett wrote:
> From: Brennan Shacklett <brennan@genyes.org>
>
> This patch addresses Bug 60727
> (https://bugzilla.kernel.org/show_bug.cgi?id=60727)
> which was due to the truncation of intermediate values in the
> calculations, which causes the code to consistently underestimate the
> current cpu frequency, specifically 100% cpu utilization was truncated
> down to the setpoint of 97%. This patch fixes the problem by keeping
> the results of all intermediate calculations as fixed point numbers
> rather scaling them back and forth between integers and fixed point.
>
> Signed-off-by: Brennan Shacklet <bpshacklett@gmail.com>
Acked-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> ---
> Tested on my Intel Core i7 2640M which also suffered from bug 60727. It
> is possible that some of the constants in the default_policy should
> be changed, because I notice that my cpu tends to run slightly faster
> with this patch, which makes sense because calculated values would have
> been consistently low without the patch.
>
>   drivers/cpufreq/intel_pstate.c | 33 +++++++++++++++------------------
>   1 file changed, 15 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index 9733f29..2409f7f 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -48,7 +48,7 @@ static inline int32_t div_fp(int32_t x, int32_t y)
>   }
>
>   struct sample {
> -	int core_pct_busy;
> +	int32_t core_pct_busy;
>   	u64 aperf;
>   	u64 mperf;
>   	int freq;
> @@ -68,7 +68,7 @@ struct _pid {
>   	int32_t i_gain;
>   	int32_t d_gain;
>   	int deadband;
> -	int last_err;
> +	int32_t last_err;
>   };
>
>   struct cpudata {
> @@ -153,16 +153,15 @@ static inline void pid_d_gain_set(struct _pid *pid, int percent)
>   	pid->d_gain = div_fp(int_tofp(percent), int_tofp(100));
>   }
>
> -static signed int pid_calc(struct _pid *pid, int busy)
> +static signed int pid_calc(struct _pid *pid, int32_t busy)
>   {
> -	signed int err, result;
> +	signed int result;
>   	int32_t pterm, dterm, fp_error;
>   	int32_t integral_limit;
>
> -	err = pid->setpoint - busy;
> -	fp_error = int_tofp(err);
> +	fp_error = int_tofp(pid->setpoint) - busy;
>
> -	if (abs(err) <= pid->deadband)
> +	if (abs(fp_error) <= int_tofp(pid->deadband))
>   		return 0;
>
>   	pterm = mul_fp(pid->p_gain, fp_error);
> @@ -176,8 +175,8 @@ static signed int pid_calc(struct _pid *pid, int busy)
>   	if (pid->integral < -integral_limit)
>   		pid->integral = -integral_limit;
>
> -	dterm = mul_fp(pid->d_gain, (err - pid->last_err));
> -	pid->last_err = err;
> +	dterm = mul_fp(pid->d_gain, fp_error - pid->last_err);
> +	pid->last_err = fp_error;
>
>   	result = pterm + mul_fp(pid->integral, pid->i_gain) + dterm;
>
> @@ -432,8 +431,9 @@ static inline void intel_pstate_calc_busy(struct cpudata *cpu,
>   					struct sample *sample)
>   {
>   	u64 core_pct;
> -	core_pct = div64_u64(sample->aperf * 100, sample->mperf);
> -	sample->freq = cpu->pstate.max_pstate * core_pct * 1000;
> +	core_pct = div64_u64(int_tofp(sample->aperf * 100),
> +			     sample->mperf);
> +	sample->freq = fp_toint(cpu->pstate.max_pstate * core_pct * 1000);
>
>   	sample->core_pct_busy = core_pct;
>   }
> @@ -465,22 +465,19 @@ static inline void intel_pstate_set_sample_time(struct cpudata *cpu)
>   	mod_timer_pinned(&cpu->timer, jiffies + delay);
>   }
>
> -static inline int intel_pstate_get_scaled_busy(struct cpudata *cpu)
> +static inline int32_t intel_pstate_get_scaled_busy(struct cpudata *cpu)
>   {
> -	int32_t busy_scaled;
>   	int32_t core_busy, max_pstate, current_pstate;
>
> -	core_busy = int_tofp(cpu->samples[cpu->sample_ptr].core_pct_busy);
> +	core_busy = cpu->samples[cpu->sample_ptr].core_pct_busy;
>   	max_pstate = int_tofp(cpu->pstate.max_pstate);
>   	current_pstate = int_tofp(cpu->pstate.current_pstate);
> -	busy_scaled = mul_fp(core_busy, div_fp(max_pstate, current_pstate));
> -
> -	return fp_toint(busy_scaled);
> +	return mul_fp(core_busy, div_fp(max_pstate, current_pstate));
>   }
>
>   static inline void intel_pstate_adjust_busy_pstate(struct cpudata *cpu)
>   {
> -	int busy_scaled;
> +	int32_t busy_scaled;
>   	struct _pid *pid;
>   	signed int ctl = 0;
>   	int steps;
>

