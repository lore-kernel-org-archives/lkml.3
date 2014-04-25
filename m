Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaDYInD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:43:03 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:60293 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaDYIm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:42:58 -0400
Message-ID: <535A1FE2.3080703@linux.vnet.ibm.com>
Date: Fri, 25 Apr 2014 14:12:10 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Meelis Roos <mroos@linux.ee>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] cpufreq, powernow-k6: Fix double invocation of cpufreq_freq_transition_begin/end
References: <20140425081728.10258.63980.stgit@srivatsabhat.in.ibm.com> <20140425081815.10258.36201.stgit@srivatsabhat.in.ibm.com> <CAKohpomVzp7TE6sC0FfC4x9v+pM6R4hLhz-q2E+wWybK4UuV1g@mail.gmail.com>
In-Reply-To: <CAKohpomVzp7TE6sC0FfC4x9v+pM6R4hLhz-q2E+wWybK4UuV1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042508-2674-0000-0000-00000DF57EFA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 01:58 PM, Viresh Kumar wrote:
> On 25 April 2014 13:48, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> During frequency transitions, the cpufreq core takes the responsibility of
>> invoking cpufreq_freq_transition_begin() and cpufreq_freq_transition_end()
>> for those cpufreq drivers that define the ->target_index callback but don't
>> set the ASYNC_NOTIFICATION flag.
>>
>> The powernow-k6 cpufreq driver falls under this category, but this driver was
>> invoking the _begin() and _end() APIs itself around frequency transitions,
>> which led to double invocation of the _begin() API. The _begin API makes
>> contending callers wait until the previous invocation is complete. Hence,
>> the powernow-k6 driver ended up waiting on itself, leading to system hangs
>> during boot.
>>
>> Fix this by removing the calls to the _begin() and _end() APIs from the
>> powernow-k6 driver, since they rightly belong to the cpufreq core.
>>
>> (Note that during ->exit(), the powernow-k6 driver sets the frequency
>>  without any help from the cpufreq core. So add explicit calls to the
>>  _begin() and _end() APIs around that frequency transition alone, to take
>>  care of that special case. Also, add a missing 'break' statement there.)
>>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---
>>
>>  drivers/cpufreq/powernow-k6.c |   20 +++++++++++---------
>>  1 file changed, 11 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
>> index 49f120e..6a4c34e 100644
>> --- a/drivers/cpufreq/powernow-k6.c
>> +++ b/drivers/cpufreq/powernow-k6.c
>> @@ -138,22 +138,14 @@ static void powernow_k6_set_cpu_multiplier(unsigned int best_i)
>>  static int powernow_k6_target(struct cpufreq_policy *policy,
>>                 unsigned int best_i)
>>  {
>> -       struct cpufreq_freqs freqs;
>>
>>         if (clock_ratio[best_i].driver_data > max_multiplier) {
>>                 printk(KERN_ERR PFX "invalid target frequency\n");
>>                 return -EINVAL;
>>         }
>>
>> -       freqs.old = busfreq * powernow_k6_get_cpu_multiplier();
>> -       freqs.new = busfreq * clock_ratio[best_i].driver_data;
>> -
>> -       cpufreq_freq_transition_begin(policy, &freqs);
>> -
>>         powernow_k6_set_cpu_multiplier(best_i);
>>
>> -       cpufreq_freq_transition_end(policy, &freqs, 0);
>> -
>>         return 0;
>>  }
>>
>> @@ -228,8 +220,18 @@ static int powernow_k6_cpu_exit(struct cpufreq_policy *policy)
>>  {
>>         unsigned int i;
>>         for (i = 0; i < 8; i++) {
>> -               if (i == max_multiplier)
>> +               if (i == max_multiplier) {
> 
> This wouldn't work, it has to be: (clock_ratio[i].driver_data == max_multiplier)
>

Hmm, looks like an existing bug in the driver. Will fix this in the next
version.

Regards,
Srivatsa S. Bhat
 
>> +                       struct cpufreq_freqs freqs;
>> +
>> +                       freqs.old = policy->cur;
>> +                       freqs.new = clock_ratio[i].frequency;
>> +                       freqs.flags = 0;
>> +
>> +                       cpufreq_freq_transition_begin(policy, &freqs);
>>                         powernow_k6_target(policy, i);
>> +                       cpufreq_freq_transition_end(policy, &freqs, 0);
>> +                       break;
>> +               }
>>         }
>>         return 0;
>>  }
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> 

