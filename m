Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934592AbaKMV6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:58:40 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:48297 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934261AbaKMV6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:58:38 -0500
Message-ID: <5465298C.4090400@codeaurora.org>
Date: Thu, 13 Nov 2014 13:58:36 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?Um9iZXJ0IFNjaMO2bmU=?= <robert.schoene@tu-dresden.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 2/5] cpufreq, fix locking around CPUFREQ_GOV_POLICY_EXIT
 calls
References: <1415199239-19019-1-git-send-email-prarit@redhat.com> <1415199239-19019-3-git-send-email-prarit@redhat.com> <CAKohpomZNwZWjmi8hkZ6QXUeDTaXTwzx_fPz1_byh3xmmkPNrQ@mail.gmail.com> <5460AF02.9010907@redhat.com> <CAKohpomeRivb3TwkeWALL_xsf4gOBPYOnfCNdz2oVvZSAGBP4g@mail.gmail.com> <5461FDE1.2080302@redhat.com> <CAKohponGMGzYnDEjto2tP1_kXNRQOgxqDW__s3kNOJWhFas8sw@mail.gmail.com>
In-Reply-To: <CAKohponGMGzYnDEjto2tP1_kXNRQOgxqDW__s3kNOJWhFas8sw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2014 05:07 AM, Viresh Kumar wrote:
> On 11 November 2014 17:45, Prarit Bhargava <prarit@redhat.com> wrote:
>> the deadlock in commit 955ef4833574636819cd269cfbae12f79cbde63a
>>
>> [   75.471265]        CPU0                    CPU1
>> [   75.476327]        ----                    ----
>> [   75.481385]   lock(&policy->rwsem);
>> [   75.485307]                                lock(s_active#219);
>> [   75.491857]                                lock(&policy->rwsem);
>> [   75.498592]   lock(s_active#219);
>> [   75.502331]
>> [   75.502331]  *** DEADLOCK ***
>
> I wanted to understand how this deadlock is prevented by a simple change
> to trylock..
>
>>> And also your changelog talks about accessing invalid pointers
>>> without the trylock change, how can that be possible? After the read
>>> lock is taken,
>>> all the pointers should be valid.
>>
>> consider the following very simple case:
>>
>> the governor is ondemand.  cpu 0 reads cpuinfo_cur_freq. cpu0 expects to get the
>> current cpu freq for the ondemand governor.
>
> Name it A.
>
>>
>> simultaneously, cpu1 changes the governor from ondemand to userspace.
>
> Name it B.
>
>>
>> the two threads will race for the policy->mutex
>>
>> suppose cpu0 gets it first.  then there is no problem.  the userspace program
>> for cpu0 gets exactly the data it is expecting.
>>
>> Now suppose cpu1 gets the lock and starts to write ... cpu0 is blocked.
>>
>> cpu1 completes the governor change, and cpu0 gets the mutex ... and returns
>> bogus data at this point.
>
> What do you mean by bogus here? That userspace wouldn't be able to know if
> the value is for which governor?
>
> If that's the case than it can still happen. Issue both above commands at almost
> the same time. You will never be able to differentiate if the sequence is:
>
> - A followed by B
> - B followed by A
> - A waited for B and so returned -EBUSY (Only this will be clear)
>
> And the value read can still be bogus. So, we haven't solved the problem at all.

Ah, we are on this topic again I see. I didn't read the patch/thread 
fully, but I can guess where this is going by reading the partial set of 
patches.

Prarit,

You can't just try lock to avoid the deadlock. If you do, then the 
userspace API becomes a mess. Writes to scaling_governor (or anything 
else) will no longer by guaranteed to work. Userspace will have to read 
back, check and retry. That would break a ton of existing userpace scripts.

Viresh,

The deadlock scenario is read. That's why the code is what it is today.

All,

IMO, the right way to fix this is to have the governor have over it's 
list of attributes it want to expose thru sysfs to the cpufreq 
framework. Then the framework can add/remove this in the right order 
when the governors are changed. The framework can do this outside of the 
policy lock being held when the governors are switched. This would allow 
avoid the original deadlock between sysfs locks and the policy lock 
without just ever having to fail userspace writes to scaling_governor.

-Saravana


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
