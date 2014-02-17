Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaBQIYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:24:53 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:53980 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaBQIYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:24:52 -0500
Message-ID: <5301C605.3030205@linux.vnet.ibm.com>
Date: Mon, 17 Feb 2014 13:49:17 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pierre Ossman <pierre-list@ossman.eu>
Subject: Re: [PATCH 1/2] cpufreq: Return error if ->get() failed in cpufreq_update_policy()
References: <15ccc0609cb9ee3db0ad3a95b29bf69d11ea197c.1392375504.git.viresh.kumar@linaro.org> <4772234.6D4cUIJHX4@vostro.rjw.lan> <CAKohpo=uPbqMcDEHYEMahRF0rCO8KYscj2nocz81_OTKyU+Tfw@mail.gmail.com>
In-Reply-To: <CAKohpo=uPbqMcDEHYEMahRF0rCO8KYscj2nocz81_OTKyU+Tfw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021708-2674-0000-0000-00000CBF3452
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 10:44 AM, Viresh Kumar wrote:
> On 17 February 2014 05:58, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> On Friday, February 14, 2014 04:30:40 PM Viresh Kumar wrote:
> 
>> Good to know that you chat with each other, but it really is not a useful piece
>> of information until you say what *exactly* you were talking about.
> 
> All that is mentioned in commit logs of both the patches :) .. That's all we
> discussed.
> 
>>>  drivers/cpufreq/cpufreq.c | 7 +++++++
>>>  1 file changed, 7 insertions(+)
>>>
>>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>>> index 08ca8c9..383362b 100644
>>> --- a/drivers/cpufreq/cpufreq.c
>>> +++ b/drivers/cpufreq/cpufreq.c
>>> @@ -2151,6 +2151,13 @@ int cpufreq_update_policy(unsigned int cpu)
>>>        */
>>>       if (cpufreq_driver->get) {
>>>               new_policy.cur = cpufreq_driver->get(cpu);
>>> +
>>> +             if (!new_policy.cur) {
>>> +                     pr_err("%s: ->get() returned 0 KHz\n", __func__);
>>> +                     ret = -EINVAL;
>>
>> That isn't -EINVAL.  It may be -EIO or -ENODEV, but not -EINVAL.  Please.
> 
> Hmm.. Correct. I will use EIO then..
> 
>>> +                     goto no_policy;
>>
>> And is it unsafe to continue here?  Or can we continue regardless of getting 0?
> 
> We were supposed to set this frequency as the current frequency in policy->cur,
> what else can we do now in this function when we aren't able to read current
> freq? And so I thought that's all we can do here.
> 

Quick question: Looking at cpufreq_update_policy() and cpufreq_out_of_sync(),
I understand that if the cpufreq subsystem's notion of the current frequency
does not match with the actual frequency of the CPU, it tries to adjust and
notify everyone that the current frequency is so-and-so, as read from the
hardware. Instead, why can't we simply set the frequency to the value that
we _want_ it to be at? I mean, if cpufreq subsystem thinks it is X KHz and
the actual frequency is Y KHz, we can as well fix the anomaly by setting the
frequency immediately to X KHz right?

The reason I ask this is that, if we follow this approach, then we can avoid
ambiguities in dealing with the out-of-sync situation. That is, it becomes
very straightforward to decide _what_ to do, when we detect scenarios where
the frequency goes out of sync.

Thoughts?

Regards,
Srivatsa S. Bhat

>>> +             }
>>> +
>>>               if (!policy->cur) {
>>>                       pr_debug("Driver did not initialize current freq");
>>>                       policy->cur = new_policy.cur;
>>>


