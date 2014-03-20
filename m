Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbaCTJZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:25:20 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:42921 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaCTJZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:25:14 -0400
Message-ID: <532AB3E7.3090503@linux.vnet.ibm.com>
Date: Thu, 20 Mar 2014 14:54:55 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amit Daniel <amit.daniel@samsung.com>
Subject: Re: [RFC v3] cpufreq: Make sure frequency transitions are serialized
References: <2efc621827cbd96a05a3d34075154974b4816ecd.1394782795.git.viresh.kumar@linaro.org> <532840FD.308@linux.vnet.ibm.com> <CAKohpomhTJa06a1LSi9tK1+=6Y2MyidJSbYWuffAsU5KxVf7zw@mail.gmail.com> <53296870.5010505@linux.vnet.ibm.com> <CAKohpomr1s3SLs-K8+-BKguX4PyfHvSjyzd5PFjM4mJeyTj3-A@mail.gmail.com> <53298A7D.3080400@linux.vnet.ibm.com> <CAKohpon=VLfPiukzrtQOSVAQg-Z-Aq3+AkZ1myrE6XtVRMY8mQ@mail.gmail.com> <532AA7A8.3040508@linux.vnet.ibm.com> <CAKohpon-i7LUqALr3Bi1Sn02m93YZpBn3sjmDdo3VQCuW5bNYw@mail.gmail.com>
In-Reply-To: <CAKohpon-i7LUqALr3Bi1Sn02m93YZpBn3sjmDdo3VQCuW5bNYw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-9574-0000-0000-00000C886F99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 02:07 PM, Viresh Kumar wrote:
> On 20 March 2014 14:02, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index 199b52b..5283f10 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -349,6 +349,39 @@ void cpufreq_notify_post_transition(struct cpufreq_policy *policy,
>>  EXPORT_SYMBOL_GPL(cpufreq_notify_post_transition);
>>
>>
>> +void cpufreq_freq_transition_begin(struct cpufreq_policy *policy,
>> +               struct cpufreq_freqs *freqs, unsigned int state)
>> +{
>> +wait:
>> +       wait_event(&policy->transition_wait, !policy->transition_ongoing);
>> +
>> +       mutex_lock(&policy->transition_lock);
>> +
>> +       if (policy->transition_ongoing) {
>> +               mutex_unlock(&policy->transition_lock);
>> +               goto wait;
>> +       }
>> +
>> +       policy->transition_ongoing = true;
>> +
>> +       mutex_unlock(&policy->transition_lock);
>> +
>> +       cpufreq_notify_transition(policy, freqs, CPUFREQ_PRECHANGE);
>> +}
>> +
>> +void cpufreq_freq_transition_end(struct cpufreq_policy *policy,
>> +               struct cpufreq_freqs *freqs, unsigned int state)
>> +{
>> +       cpufreq_notify_transition(policy, freqs, CPUFREQ_POSTCHANGE);
>> +
>> +       mutex_lock(&policy->transition_lock);
> 
> Why do we need locking here? You explained that earlier :)
> 

Hmm.. I had thought of some complex race condition which would make
tasks miss the wake-up event and sleep forever, and hence added
the locking there to prevent that. But now that I think more closely,
I'm not able to recall that race... I will give some more thought to
it and if I can't find any loopholes in doing the second update to
the ongoing flag without locks, then I'll post the patchset with
that lockless version itself.

> Also, I would like to add this here:
> 
>     WARN_ON(policy->transition_ongoing);
>

Hmm? Won't it always be true? We are the ones who set that flag to
true earlier, right? I guess you meant WARN_ON(!policy->transition_ongoing)
perhaps? I'm not sure whether its really worth it, because it kinda looks
obvious. Not sure what kind of bugs it would catch. I can't think of any
such scenario :-(
 
>> +       policy->transition_ongoing = false;
>> +       mutex_unlock(&policy->transition_lock);
>> +
>> +       wake_up(&policy->transition_wait);
>> +}
> 

Regards,
Srivatsa S. Bhat

