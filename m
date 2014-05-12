Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550AbaELC1c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:27:32 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:39146 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753163AbaELC13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 22:27:29 -0400
Message-ID: <5370318D.2010309@semaphore.gr>
Date: Mon, 12 May 2014 05:27:25 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: rjw@rjwysocki.net, dirk.brandewie@gmail.com,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 4/5] intel_pstate: Remove C0 tracking
References: <1399579047-5792-1-git-send-email-dirk.j.brandewie@intel.com>	<1399579047-5792-5-git-send-email-dirk.j.brandewie@intel.com> <CADmjqpOnzRrB8gJsmHWG=4bvhERLovnKyP0Pcki_uVJ3qpfD0g@mail.gmail.com>
In-Reply-To: <CADmjqpOnzRrB8gJsmHWG=4bvhERLovnKyP0Pcki_uVJ3qpfD0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/05/2014 05:14 πμ, Stratos Karafotis wrote:
> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
> 
> Commit fcb6a15c intel_pstate: Take core C0 time into account for core busy
> introduced a regression referenced below.  The issue with "lockup"
> after suspend that this commit was addressing is now dealt with in the
> suspend path.
> 
> References:
>    https://bugzilla.kernel.org/show_bug.cgi?id=66581
>    https://bugzilla.kernel.org/show_bug.cgi?id=75121
> 
> Reported-by: Doug Smythies <dsmythies@telus.net>
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> ---
>  drivers/cpufreq/intel_pstate.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index bb20881..4c26faf 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -59,7 +59,6 @@ struct sample {
>         int32_t core_pct_busy;
>         u64 aperf;
>         u64 mperf;
> -       unsigned long long tsc;
>         int freq;
>  };
> 
> @@ -100,7 +99,6 @@ struct cpudata {
> 
>         u64     prev_aperf;
>         u64     prev_mperf;
> -       unsigned long long prev_tsc;
>         struct sample sample;
>  };
> 
> @@ -561,46 +559,37 @@ static inline void intel_pstate_calc_busy(struct
> cpudata *cpu,
>                                         struct sample *sample)
>  {
>         int32_t core_pct;
> -       int32_t c0_pct;
> 
>         core_pct = div_fp(int_tofp((sample->aperf)),
>                         int_tofp((sample->mperf)));
>         core_pct = mul_fp(core_pct, int_tofp(100));
>         FP_ROUNDUP(core_pct);
> 
> -       c0_pct = div_fp(int_tofp(sample->mperf), int_tofp(sample->tsc));
> -
>         sample->freq = fp_toint(
>                 mul_fp(int_tofp(cpu->pstate.max_pstate * 1000), core_pct));
> 
> -       sample->core_pct_busy = mul_fp(core_pct, c0_pct);
> +       sample->core_pct_busy = core_pct;
>  }
> 
>  static inline void intel_pstate_sample(struct cpudata *cpu)
>  {
>         u64 aperf, mperf;
> -       unsigned long long tsc;
> 
>         rdmsrl(MSR_IA32_APERF, aperf);
>         rdmsrl(MSR_IA32_MPERF, mperf);
> -       tsc = native_read_tsc();
> 
>         aperf = aperf >> FRAC_BITS;
>         mperf = mperf >> FRAC_BITS;
> -       tsc = tsc >> FRAC_BITS;
> 
>         cpu->sample.aperf = aperf;
>         cpu->sample.mperf = mperf;
> -       cpu->sample.tsc = tsc;
>         cpu->sample.aperf -= cpu->prev_aperf;
>         cpu->sample.mperf -= cpu->prev_mperf;
> -       cpu->sample.tsc -= cpu->prev_tsc;
> 
>         intel_pstate_calc_busy(cpu, &cpu->sample);
> 
>         cpu->prev_aperf = aperf;
>         cpu->prev_mperf = mperf;
> -       cpu->prev_tsc = tsc;
>  }
> 
>  static inline void intel_pstate_set_sample_time(struct cpudata *cpu)
> --
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

With this patch, my CPU (Core i7-3770 @ 3.90GHz) seems to never use lowest
frequencies. Even on an idle system I get always ~2GHz. Normally,
on an idle system it used to be 1.6GHz.
On very small loads (mp3 decoding) the CPU goes up to 2.7G GHz (it used to
be 1.6GHz)

Reverting, this patch on my local build, the problem is resolved.


Thanks,
Stratos Karafotis

