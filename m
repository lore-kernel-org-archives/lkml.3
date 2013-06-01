Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab3FAMuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 08:50:13 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:37678 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756026Ab3FAMuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 08:50:06 -0400
Message-ID: <51A9EDFA.3050901@semaphore.gr>
Date: Sat, 01 Jun 2013 15:50:02 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] cpufreq: ondemand: Change the calculation of target frequency
References: <51A7BFA6.3070800@semaphore.gr> <CAKohpo=oD9Wgr0Y9zA3aVCdMq5MUC5GESWyL45h=izRyp9-CLA@mail.gmail.com> <51A8D0C2.1080801@semaphore.gr> <4850488.DDEIRKBtQx@vostro.rjw.lan>
In-Reply-To: <4850488.DDEIRKBtQx@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2013 03:27 PM, Rafael J. Wysocki wrote:
> On Friday, May 31, 2013 07:33:06 PM Stratos Karafotis wrote:
>> On 05/31/2013 11:51 AM, Viresh Kumar wrote:
>>>> ---
>>>>    arch/x86/include/asm/processor.h   | 29 ----------------------
>>>>    drivers/cpufreq/Makefile           |  2 +-
>>>>    drivers/cpufreq/acpi-cpufreq.c     |  5 ----
>>>>    drivers/cpufreq/cpufreq.c          | 21 ----------------
>>>>    drivers/cpufreq/cpufreq_governor.c | 10 +-------
>>>>    drivers/cpufreq/cpufreq_governor.h |  1 -
>>>>    drivers/cpufreq/cpufreq_ondemand.c | 39 ++++++-----------------------
>>>>    drivers/cpufreq/mperf.c            | 51 --------------------------------------
>>>>    drivers/cpufreq/mperf.h            |  9 -------
>>>>    include/linux/cpufreq.h            |  6 -----
>>>>    10 files changed, 9 insertions(+), 164 deletions(-)
>>>>    delete mode 100644 drivers/cpufreq/mperf.c
>>>>    delete mode 100644 drivers/cpufreq/mperf.h
>>>
>>> I believe you should have removed other users of getavg() in a separate
>>> patch and also cc'd relevant people so that you can some review comments
>>> from  them.
>>
>> I will split the patch in two. If it's OK, I will keep the removal of
>> __cpufreq_driver_getavg in the original patch and move the clean up of
>> APERF/MPERF support in a second patch. I will also cc relevant people.
>>
>>
>>>>           /* Check for frequency increase */
>>>> -       if (load_freq > od_tuners->up_threshold * policy->cur) {
>>>> +       if (load > od_tuners->up_threshold) {
>>>
>>> Chances of this getting hit are minimal now.. I don't know if keeping
>>> this will change anything now :)
>>
>> Actually, no. This getting hit pretty often.
>> Please find attached the cpufreq statistics - trans_table during build
>> of 3.4 kernel. With default up_threshold (95), the transition to max
>> happened many times because of load was greater than up_threshold.
>> I also thought to keep this code to leave up_threshold functionality unaffected.
>>   
>> On 05/31/2013 03:42 PM, Rafael J. Wysocki wrote:
>>> On Friday, May 31, 2013 02:24:59 PM Viresh Kumar wrote:
>>>>> +       } else {
>>>>> +               /* Calculate the next frequency proportional to load */
>>>>>                   unsigned int freq_next;
>>>>> -               freq_next = load_freq / od_tuners->adj_up_threshold;
>>>>> +               freq_next = load * policy->max / 100;
>>>>
>>>> Rafael asked why you believe this is the right formula and I really couldn't
>>>> find an appropriate answer to that, sorry :(
>>>
>>> Right, it would be good to explain that.
>>>
>>> "Proportional to load" means C * load, so why is "policy->max / 100" *the* right C?
>>>
>>
>> I think, finally(?) I see your point. The right C should be "policy->cpuinfo.max_freq / 100".
>> This way the target frequency will be proportional to load and the calculation will
>> "map" the load to CPU freq table.
> 
> That seems to mean "take the percentage of policy->cpuinfo.max_freq proportional
> to the current load and use the available frequency closest to that".  Is that
> correct?
> 
> Rafael
> 
> 

In my opinion, yes. I thought, yesterday, after your question, to normalize load
to policy->min - policy->max. But I think it's a more correct approach to take 
the percentage of cpuinfo.max, as you said.
Actually, I did my tests on the percentage of policy->max that was equal to 
cpuinfo.max.

Unless, I miss something here. :)

Thanks,
Stratos
