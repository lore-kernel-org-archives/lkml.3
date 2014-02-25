Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaBYVLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 16:11:32 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:45939 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbaBYVLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 16:11:30 -0500
Message-ID: <530D06FF.201@codeaurora.org>
Date: Tue, 25 Feb 2014 13:11:27 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] cpufreq: Set policy to non-NULL only after all hotplug
 online work is done
References: <1393225072-3997-1-git-send-email-skannan@codeaurora.org> <530BAA31.4050701@codeaurora.org> <CAKohpo=0CgzjCgKnDxUMcN6-CgbQ2ML=Tx-K8fS7=VJJYOD0eg@mail.gmail.com> <15001517.xLHO8lGdWr@vostro.rjw.lan>
In-Reply-To: <15001517.xLHO8lGdWr@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 05:04 AM, Rafael J. Wysocki wrote:
> On Tuesday, February 25, 2014 02:20:57 PM Viresh Kumar wrote:
>> On 25 February 2014 01:53, Saravana Kannan <skannan@codeaurora.org> wrote:
>>> I was simplifying the scenario that causes it. We change the min/max using
>>> ADJUST notifiers for multiple reasons -- thermal being one of them.
>>>
>>> thermal/cpu_cooling is one example of it.
>>
>> Just to understand the clear picture, you are actually hitting this bug? Or
>> is this only a theoretical bug?
>>
This is a real bug. But the actual caller of cpufreq_update_policy() is 
a driver that's local to our tree. I'm just giving examples of upstream 
code that act in a similar way.

>>> So, cpufreq_update_policy() can be called on any CPU. If that races with
>>> someone offlining a CPU and onlining it, you'll get this crash.
>>
>> Then shouldn't that be fixed by locks? I think yes. That makes me agree with
>> Srivatsa more here.
>>
>> Though I would say that your argument was also valid that 'policy' shouldn't be
>> up for sale unless it is prepared to. And for that reason only I
>> floated that question
>> earlier: What exactly we need to make sure is initialized in policy? Because
>> policy might keep changing in future as well and that needs locks to protect
>> that stuff. Like min/max/governor/ etc..
>
> Well, that depends on what the current users expect it to look like initially.
> It should be initialized to the point in which all of them can handle it
> correctly.

Yes, so let's not make it available until all of it is initialized. I 
don't like the piece meal check. 6 months down the lane someone making 
changes might not remember this. The problem also applies for drivers 
that might not be upstreamed, etc.

>> So, probably a solution here might be a mix of both. Initialize policy to this
>> minimum level and then make sure locking is used correctly..
>
> Yes.

Rafael, It's not clear what you mean by the yes. Do you want to 
initialize it partly and make it available. I think that's always wrong.

>>> The idea would exist, but we can just call cpufreq_generic_get() and pass it
>>> policy->clk if it is not NULL. Does that work for you?
>>
>> No. Not all drivers implement clk interface. And so clk doesn't look to be the
>> right parameter. I thought maybe 'policy' can be the right parameter and
>> then people can get use policy->cpu to get cpu id out of it.
>>
>> But even that doesn't look to be a great idea. X86 drivers may share policy
>> structure for CPUs that don't actually share a clock line. And so they do need
>> right CPU number as parameter instead of policy. As they might be doing
>> some tricky stuff there. Also, we need to make sure that ->get() returns
>> the frequency at which CPU x is running.
>
> That's not going to work in at least some cases anyway, because for some types
> of HW we simply can't retrieve the current frequency in a non-racy way.

I think there's been a misunderstanding of what I'm proposing. The 
reference to policy->clk is only to get rid of the dependency that 
cpufreq_generic_get() has on the per cpu policy variable being filled. 
You can do that by just removing calls to get _IF_ clk is filled in.

Viresh,

I'll look at the patches later today and respond. Although, I would have 
been nice you had helped me fix any issues with my patch than coming up 
with new ones. Kinda removes to motivation for submitting patches upstream.

Regards,
Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
