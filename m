Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401AbaFJOwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:52:03 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:57279 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750777AbaFJOwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:52:01 -0400
Message-ID: <53971B8E.4040302@semaphore.gr>
Date: Tue, 10 Jun 2014 17:51:58 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] cpufreq: intel_pstate: Simplify code in intel_pstate_adjust_busy_pstate
References: <5396207D.7030704@semaphore.gr> <CAKohpokYB4oKxrEwHH888T5hg=zrpb0PCs_QKTLS0bd-_fqeTA@mail.gmail.com>
In-Reply-To: <CAKohpokYB4oKxrEwHH888T5hg=zrpb0PCs_QKTLS0bd-_fqeTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2014 08:27 πμ, Viresh Kumar wrote:
> On 10 June 2014 02:30, Stratos Karafotis <stratosk@semaphore.gr> wrote:
>> Simplify the code by removing the inline functions
>> pstate_increase and pstate_decrease and use directly the
>> intel_pstate_set_pstate.
>>
>> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
>> ---
>>  drivers/cpufreq/intel_pstate.c | 26 +++-----------------------
>>  1 file changed, 3 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
>> index 3a49269..26a0262 100644
>> --- a/drivers/cpufreq/intel_pstate.c
>> +++ b/drivers/cpufreq/intel_pstate.c
>> @@ -588,21 +588,6 @@ static void intel_pstate_set_pstate(struct cpudata *cpu, int pstate)
>>         pstate_funcs.set(cpu, pstate);
>>  }
>>
>> -static inline void intel_pstate_pstate_increase(struct cpudata *cpu, int steps)
>> -{
>> -       int target;
>> -       target = cpu->pstate.current_pstate + steps;
>> -
>> -       intel_pstate_set_pstate(cpu, target);
>> -}
>> -
>> -static inline void intel_pstate_pstate_decrease(struct cpudata *cpu, int steps)
>> -{
>> -       int target;
>> -       target = cpu->pstate.current_pstate - steps;
>> -       intel_pstate_set_pstate(cpu, target);
>> -}
>> -
>>  static void intel_pstate_get_cpu_pstates(struct cpudata *cpu)
>>  {
>>         cpu->pstate.min_pstate = pstate_funcs.get_min();
>> @@ -695,20 +680,15 @@ static inline void intel_pstate_calc_scaled_busy(struct cpudata *cpu)
>>  static inline void intel_pstate_adjust_busy_pstate(struct cpudata *cpu)
>>  {
>>         struct _pid *pid;
>> -       signed int ctl = 0;
>> -       int steps;
>> +       signed int ctl;
>>
>>         pid = &cpu->pid;
>>         intel_pstate_calc_scaled_busy(cpu);
>>
>>         ctl = pid_calc(pid, cpu->sample.busy_scaled);
>>
>> -       steps = abs(ctl);
>> -
>> -       if (ctl < 0)
>> -               intel_pstate_pstate_increase(cpu, steps);
>> -       else
>> -               intel_pstate_pstate_decrease(cpu, steps);
>> +       /* Negative values of ctl increase the pstate and vice versa */
>> +       intel_pstate_set_pstate(cpu, cpu->pstate.current_pstate - ctl);
>>  }
> 
> I am not very good at this driver but there is some obvious functional
> change here. Earlier we used to pass
> 'cpu->pstate.current_pstate {-|+} steps' and now you are doing '-ctl' only
> 

The original code is:	

	if (ctl < 0)
		intel_pstate_pstate_increase(cpu, steps);
	else
		intel_pstate_pstate_decrease(cpu, steps);
		
Without inlines functions intel_pstate_pstate_increase() and
intel_pstate_pstate_decrease() we get:

	if (ctl < 0)
		intel_pstate_set_pstate(cpu, cpu->pstate.current_pstate + steps);
	else
		intel_pstate_set_pstate(cpu, cpu->pstate.current_pstate - steps);

	
But steps = abs(ctl), so:

	if (ctl < 0)
		intel_pstate_set_pstate(cpu, cpu->pstate.current_pstate + abs(ctl));
	else
		intel_pstate_set_pstate(cpu, cpu->pstate.current_pstate - abs(ctl));
	
By definition, abs(ctl) = ctl if ctl >= 0, -ctl if ctl < 0. Thus:

	if (ctl < 0)
		intel_pstate_set_pstate(cpu, cpu->pstate.current_pstate + (-ctl));
	else
		intel_pstate_set_pstate(cpu, cpu->pstate.current_pstate - ctl);

And:
	if (ctl < 0)
		intel_pstate_set_pstate(cpu, cpu->pstate.current_pstate - ctl);
	else
		intel_pstate_set_pstate(cpu, cpu->pstate.current_pstate - ctl);

Finally remove the unnecessary if statement.		
	intel_pstate_set_pstate(cpu, cpu->pstate.current_pstate - ctl);

So, this is equivalent with the original code.

Thanks,
Stratos
