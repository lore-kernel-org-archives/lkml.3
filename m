Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbaBYIvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 03:51:01 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:38609 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaBYIu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 03:50:58 -0500
MIME-Version: 1.0
In-Reply-To: <530BAA31.4050701@codeaurora.org>
References: <1393225072-3997-1-git-send-email-skannan@codeaurora.org>
	<530AF7E4.5080806@linux.vnet.ibm.com>
	<1f7bd419ce78af0137c0d63189c6ad35.squirrel@www.codeaurora.org>
	<CAKohponY-OXwAEZT0WRjxpHmvi78Ne9kv6LOHXvLOFG-KjU1FQ@mail.gmail.com>
	<530BAA31.4050701@codeaurora.org>
Date: Tue, 25 Feb 2014 14:20:57 +0530
Message-ID: <CAKohpo=0CgzjCgKnDxUMcN6-CgbQ2ML=Tx-K8fS7=VJJYOD0eg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Set policy to non-NULL only after all hotplug
 online work is done
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 February 2014 01:53, Saravana Kannan <skannan@codeaurora.org> wrote:
> I was simplifying the scenario that causes it. We change the min/max using
> ADJUST notifiers for multiple reasons -- thermal being one of them.
>
> thermal/cpu_cooling is one example of it.

Just to understand the clear picture, you are actually hitting this bug? Or
is this only a theoretical bug?

> So, cpufreq_update_policy() can be called on any CPU. If that races with
> someone offlining a CPU and onlining it, you'll get this crash.

Then shouldn't that be fixed by locks? I think yes. That makes me agree with
Srivatsa more here.

Though I would say that your argument was also valid that 'policy' shouldn't be
up for sale unless it is prepared to. And for that reason only I
floated that question
earlier: What exactly we need to make sure is initialized in policy? Because
policy might keep changing in future as well and that needs locks to protect
that stuff. Like min/max/governor/ etc..

So, probably a solution here might be a mix of both. Initialize policy to this
minimum level and then make sure locking is used correctly..

> The idea would exist, but we can just call cpufreq_generic_get() and pass it
> policy->clk if it is not NULL. Does that work for you?

No. Not all drivers implement clk interface. And so clk doesn't look to be the
right parameter. I thought maybe 'policy' can be the right parameter and
then people can get use policy->cpu to get cpu id out of it.

But even that doesn't look to be a great idea. X86 drivers may share policy
structure for CPUs that don't actually share a clock line. And so they do need
right CPU number as parameter instead of policy. As they might be doing
some tricky stuff there. Also, we need to make sure that ->get() returns
the frequency at which CPU x is running.

>> So the real question here is: What fields of 'policy' do we need to
>> guarantee
>> to be initialized before policy is made available for others? And probably
>> that is what we need to fix.
>
> That's going to be hard to define since future uses could be looking at
> different fields. What is the API semantics of cpufreq_cpu_get(). I can't
> ever imagine it being correct for any API to return a partially initialized
> data structure.

I do agree that we can't broadcast 'policy' before it is usable. And that's
why I am asking about the right place where we are sure that it is ready..

>> Even your current solution would break things. For example, below will
>> happen
>> before policy is set in per-cpu variable:
>> - CPUFREQ_CREATE_POLICY notifier will be fired and calls to do
>> cpufreq_cpu_get()
>> there will fail. And hence cpufreq-stats sysfs will break.
>
> I did this on 3.12. I'll fix it up to handle this one.

This can be moved down without much issues I believe.

>> - Governors also use cpufreq_cpu_get() and so those would also fail as
>> they
>> are started from cpufreq_init_policy()..
>
> The only use of this in governors is in update_sampling_rate() and the
> behavior after this fix would be correct in that case. If the policy is not
> fully initialized -- that update doesn't get to go through.

hmm.. but even that looks odd. We have reached upto governors but
policy isn't available to be used? It should have been ready by now?

> All other uses of this API fall under one of these categories:
> * CPUs are already fully offline whenever it's called.
> * Already get the real policy as part of the notifier so don't need to
>   call cpufreq_cpu_get
>
> If I find any that doesn't fit the above, I would be glad to fix that if
> it's pointed out.

I have just sent out a patchset to you and others, would be great if
you can give it a review/test ..
