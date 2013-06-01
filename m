Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab3FAQGo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 12:06:44 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:38902 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751901Ab3FAQGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 12:06:35 -0400
Message-ID: <51AA1BFF.20803@semaphore.gr>
Date: Sat, 01 Jun 2013 19:06:23 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] cpufreq: ondemand: Change the calculation of target frequency
References: <51A7BFA6.3070800@semaphore.gr> <CAKohpo=oD9Wgr0Y9zA3aVCdMq5MUC5GESWyL45h=izRyp9-CLA@mail.gmail.com> <51A8D0C2.1080801@semaphore.gr> <CAKohpokmn-Rf-1w2aQHMMMkMbJqxokWXm5ye3DNuc-yzzk=7pQ@mail.gmail.com>
In-Reply-To: <CAKohpokmn-Rf-1w2aQHMMMkMbJqxokWXm5ye3DNuc-yzzk=7pQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2013 05:56 PM, Viresh Kumar wrote:
> On 31 May 2013 22:03, Stratos Karafotis <stratosk@semaphore.gr> wrote:
>> On 05/31/2013 11:51 AM, Viresh Kumar wrote:
>>> I believe you should have removed other users of getavg() in a separate
>>> patch and also cc'd relevant people so that you can some review comments
>>> from  them.
>>
>> I will split the patch in two. If it's OK, I will keep the removal of
>> __cpufreq_driver_getavg in the original patch and move the clean up of
>> APERF/MPERF support in a second patch. I will also cc relevant people.
> 
> Even removal of __cpufreq_driver_getavg() should be done in a separate
> patch, so that it can be reverted easily if required later.

Thanks, Viresh. I will do the removal of that function in a seperate patch.
Should I use a third patch for it? Or should I include it in the patch which
will remove APERF/MPERF support?

>>> "Proportional to load" means C * load, so why is "policy->max / 100" *the* right C?
>>
>> I think, finally(?) I see your point. The right C should be "policy->cpuinfo.max_freq / 100".
> 
> Why are you changing it to cpuinfo.max_freq?? This is fixed once a driver is
> initialized.. but user may request a lower max freq for a governor or policy.
> Which is actually reflected in policy->max I believe.

My initial thought is to have a linear function to calculate the target freq 
proportional to load: (I will use 'C' as the function's slope as Rafael used it) 

freq_target = C * load

For simplicity, let's assume that load is between 0 and 1 as initially is calculated
in governor.
Ideally,  for a load = 0, we should have freq_target = 0 and for load = 1,
freq_target = cpuinfo.max

So, the slope C = cpuinfo.max 

I think, it's matter of definition about what policy->min and policy->max can do.
Should they change the slope C? Or only limit freq_target?
I don't think that the policy->max (or min) should affect HOW (slope C) governor
calculates freq_target but only limit the calculated result.

Maybe, we could have separate tunables to a affect the slope C.

If I'm wrong about the definition of policy->min, policy->max, I would change
the code accordingly.


> Over that why keeping following check is useful anymore?
> 
> if (load_freq > od_tuners->up_threshold)
>      goto max.
> 
> As, if load is over 95, then even policy->max * 95 / 100 will even give almost
> the same freq.
> 

I thought that too. But maybe user selects a lower value for up_threshold.
(For example, up_threshold = 60). In my opinion, we have to keep up_theshold,
to give the possibility to user to have max freq with small loads.


Thanks for your comments!
Stratos 
