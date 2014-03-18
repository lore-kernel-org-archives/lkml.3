Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaCRMQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 08:16:37 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:56203 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaCRMQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 08:16:36 -0400
Message-ID: <53283913.1070003@linux.vnet.ibm.com>
Date: Tue, 18 Mar 2014 17:46:19 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrick Marlier <patrick.marlier@gmail.com>
Subject: Re: [PATCH 0/2] Add exit_prepare callback to the cpufreq_driver interface.
References: <1394732168-12638-1-git-send-email-dirk.j.brandewie@intel.com> <CAKohponGN4JNwLKLjvFOPkru0=6JajOKKH=oJneDkKp=PyAmRA@mail.gmail.com> <53234A70.70506@gmail.com> <53656551.Rzgh2mDLCG@vostro.rjw.lan>
In-Reply-To: <53656551.Rzgh2mDLCG@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031812-3864-0000-0000-00000D092215
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2014 07:29 AM, Rafael J. Wysocki wrote:
> On Friday, March 14, 2014 11:29:04 AM Dirk Brandewie wrote:
>> On 03/14/2014 10:07 AM, Viresh Kumar wrote:
>>> On 14 March 2014 20:40, Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
>>>> Are you proposing adding cpufreq_generic_suspend() to the core I can not
>>>> find
>>>> it in the mainline code.
>>>
>>> Its already there in linux-next. I am suggesting to reuse that
>>> infrastructure with
>>> some necessary modification to support both suspend and hotplug.
>>
>> Suspend and hotplug are two very different things and if we start
>> crossing those wires bad things are going to happen IMHO.
>>
>> In "normal" operation using the suspend path to do this work could
>> work in principal but doesn't handle the case where the user does
>>     echo 0 | sudo tee /sys/devices/system/cpu/cpuX/online
>>
>> Trying force hotplug and suspend into a common mechanism would
>> lead to a bunch of special case code or a significant rework of the
>> core code IMHO.
>>
>>
>>>
>>>>> Over that I don't think Dirk's solution is going to work if we twist
>>>>> the systems a bit.
>>>>
>>>> Could you explain what "twist the systems a bit" means?
>>>
>>> The one I explained in the below paragraph.
>>>
>>>>> For example, Dirk probably wanted to set P-STATE of every core to MIN
>>>>> when it goes down. But his solution probably doesn't do that right now.
>>>>>
>>>>
>>>> No, I wanted to set the core that was being off-lined to min P state.
>>>
>>> Sorry, probably my words were a bit confusing. I meant exactly what
>>> you just wrote. Core going down will set its freq to min.
>>>
>>>>> As exit() is called only when the policy expires or all the CPUs of that
>>>>> policy
>>>>> are down. Suppose only one CPU out of 4 goes down from a policy, then
>>>>> pstate driver would never know that happened. And that core wouldn't go
>>>>> to min state.
>>>>
>>>> My patch does not change the semantics of exit() or when it is called.  For
>>>> intel_pstate their is one cpu per policy so I moved all the cleanup to
>>>
>>> I didn't knew that its guaranteed by pstate driver. I thought it would still be
>>> hardware dependent as some cores might share clock line.
>>
>> This is guaranteed by the hardware.  Each core has its own MSR for P state
>> request.  Any coordination that is required between cores to select the
>> package P state is handled by the hardware.
>>
>>>
>>>> exit_prepare() if there were work I needed to do at CPU_POST_DEAD I would
>>>> have
>>>> continued to export the *optional* exit callback.
>>>>
>>>> The callback name exit_prepare() was probably unfortunate and might be
>>>> causing
>>>> some confusion.  I will be changing the name per Rafael's feedback.
>>>
>>> Don't know.. There is another problem here that exit_prepare() would be called
>>> for each CPU whereas exit() would be called for each policy.
>>
>> Granted but I don't see this as a problem in this case there is a 1:1
>> relationship.  If a driver chooses to use the *optional* exit_prepare() callback
>> and knows that there is a many:1 relationship between the policy and CPUs
>> then it would have to deal with it.
> 
> Actually, I think we should make it clear that the new callback is for
> ->setpolicy drivers only, which will make things a bit clearer.
>

Agreed. As far as I understand, for ->target drivers, today we use GOV_STOP
to stop managing the CPU going offline. And for ->setpolicy drivers, we will
use this new callback to achieve the same goal. 

Regards,
Srivatsa S. Bhat
 
> We seem to get caught by the difference between ->setpolicy and ->target
> drivers on a regular basis, so it might be a good idea to make the distinction
> more clear in the code.  I have an idea how to do that, but need some time
> to prototype it.
>  
>>> And I strongly feel that we shouldn't give another callback here but instead
>>> just set core to a specific freq as mentioned by driver with some other field.
>>>
>>>>> I think we have two solutions here:
>>>>> - If its just about setting core a particular freq when it goes down, I
>>>>> think it
>>>>> looks a generic enough problem and so better fix core for that. Probably
>>>>> with
>>>>> help of flags field/suspend-freq (maybe renamed) and without calling
>>>>> drivers
>>>>> exit() at all..
>>>>
>>>>
>>>> ATM the only thing that needs to be done in this case is to allow
>>>> intel_pstate
>>>> to set the P state on the core when it is going done.  My solution from the
>>>> cores point of view is more generic, it allows any driver that needs to do
>>>> work
>>>> during CPU_DOWN_PREPARE to do it without adding any new logic to the core.
>>>
>>> Yeah, do we really need to give that freedom right now? Would be better
>>> to get this into core as that would be more generic and people looking to set
>>> core to some freq at shutdown wouldn't be replicating that code.
> 
> Question is if it needs to be more generic.
> 
> I honestly don't think that ->target drivers will ever do anything like it,
> because they need the governor to "exit" before.  So we are talking about the
> only two ->setpolicy drivers in the tree here.
> 
>> IMHO yes and it would be hard to be more generic, if your platform needs to
>> do architecture specific during the PREPARE phase of cpu hotplug use this
>> callback or not.
>>
>> BTW now that you have added a path where the cpufreq_suspend() could fail
>> it return a value and be checked in dpm_suspend() instead of printing an
>> error and just continuing.
> 
> I'm not sure what you mean?  Are you saying that it might be a good idea
> to allow cpufreq_suspend() to return error codes on failure?
> 

