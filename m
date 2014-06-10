Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaFJQ1C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 12:27:02 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:57421 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751063AbaFJQ1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 12:27:00 -0400
Message-ID: <539731D1.6040504@semaphore.gr>
Date: Tue, 10 Jun 2014 19:26:57 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] cpufreq: intel_pstate: Avoid duplicate call of intel_pstate_get_scaled_busy
References: <53962067.4060504@semaphore.gr> <53972CE1.1060209@gmail.com>
In-Reply-To: <53972CE1.1060209@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2014 07:05 μμ, Dirk Brandewie wrote:
> On 06/09/2014 02:00 PM, Stratos Karafotis wrote:
>> Store busy_scaled value to avoid to duplicate call of
>> intel_pstate_get_scaled_busy on every sampling interval.
>>
> 
> The second call *only* happens if the tracepoint is being used otherwise
> the whole function call to  trace_pstate_sample() is a noop.

Yes, I'm sorry, I forgot to add this in my changelog. I have written this
in cover letter.
I made this change mostly to support patch 3/7.

> This makes the code less readable IMHO the reader is left wondering
> how cpu->sample.busy_scaled was set in intel_pstate_adjust_busy_pstate()
> 

I agree that the the original code is more readable. If we don't care
about the small overhead when tracing is on and forget patch 3/7,
of course the original code is by far better.


>> Also, rename the function to intel_pstate_calc_scaled_busy.
>>
>> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
>> ---
>>   drivers/cpufreq/intel_pstate.c | 12 ++++++------
>>   1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
>> index 4e7f492..31e2ae5 100644
>> --- a/drivers/cpufreq/intel_pstate.c
>> +++ b/drivers/cpufreq/intel_pstate.c
>> @@ -55,6 +55,7 @@ static inline int32_t div_fp(int32_t x, int32_t y)
>>
>>   struct sample {
>>       int32_t core_pct_busy;
>> +    int32_t busy_scaled;
>>       u64 aperf;
>>       u64 mperf;
>>       int freq;
>> @@ -604,7 +605,7 @@ static inline void intel_pstate_set_sample_time(struct cpudata *cpu)
>>       mod_timer_pinned(&cpu->timer, jiffies + delay);
>>   }
>>
>> -static inline int32_t intel_pstate_get_scaled_busy(struct cpudata *cpu)
>> +static inline void intel_pstate_calc_scaled_busy(struct cpudata *cpu)
>>   {
>>       int32_t core_busy, max_pstate, current_pstate, sample_ratio;
>>       u32 duration_us;
>> @@ -624,20 +625,19 @@ static inline int32_t intel_pstate_get_scaled_busy(struct cpudata *cpu)
>>           core_busy = mul_fp(core_busy, sample_ratio);
>>       }
>>
>> -    return core_busy;
>> +    cpu->sample.busy_scaled = core_busy;
>>   }
>>
>>   static inline void intel_pstate_adjust_busy_pstate(struct cpudata *cpu)
>>   {
>> -    int32_t busy_scaled;
>>       struct _pid *pid;
>>       signed int ctl = 0;
>>       int steps;
>>
>>       pid = &cpu->pid;
>> -    busy_scaled = intel_pstate_get_scaled_busy(cpu);
>> +    intel_pstate_calc_scaled_busy(cpu);
>>
>> -    ctl = pid_calc(pid, busy_scaled);
>> +    ctl = pid_calc(pid, cpu->sample.busy_scaled);
>>
>>       steps = abs(ctl);
>>
>> @@ -659,7 +659,7 @@ static void intel_pstate_timer_func(unsigned long __data)
>>       intel_pstate_adjust_busy_pstate(cpu);
>>
>>       trace_pstate_sample(fp_toint(sample->core_pct_busy),
>> -            fp_toint(intel_pstate_get_scaled_busy(cpu)),
>> +            fp_toint(sample->busy_scaled),
>>               cpu->pstate.current_pstate,
>>               sample->mperf,
>>               sample->aperf,
>>
> 
> 

