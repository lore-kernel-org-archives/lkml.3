Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbaGORfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:35:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52150 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780AbaGORf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:35:28 -0400
Message-ID: <03e76981eb3d84e8397a39616ac0cfa1.squirrel@www.codeaurora.org>
In-Reply-To: <53C4D12E.3040807@mit.edu>
References: <1404959850-11617-1-git-send-email-skannan@codeaurora.org>
    <1405052287-4744-1-git-send-email-skannan@codeaurora.org>
    <CAKohponB9feyh50p+dL5hyU1ffHAzHU59G-sYCrCm1AbHQe9hw@mail.gmail.com>
    <2f549e6e4871ccf2a94dd4c8872c7a0b.squirrel@www.codeaurora.org>
    <CAKohpokhmj1OkCRj=X+Q7eYiun8fsqD2dpEt66VKYnqo3dENVA@mail.gmail.com>
    <53C0A12A.2060204@codeaurora.org>
    <CAKohpon9en_VnSx+CVydPsWBHtArvmazn0hrodrRJt9jgOa0-g@mail.gmail.com>
    <53C42AA8.8010107@codeaurora.org>
    <CAKohpomkqbHZo9KrJMSwsEKGt6+Ac2Fg2X0+S7ZAo=OzhAc45g@mail.gmail.com>
    <53C4BDFB.70707@codeaurora.org> <53C4D12E.3040807@mit.edu>
Date: Tue, 15 Jul 2014 17:35:27 -0000
Subject: Re: [PATCH v2] cpufreq: Don't destroy/realloc policy/sysfs on
 hotplug/suspend
From: skannan@codeaurora.org
To: "Srivatsa S. Bhat" <srivatsa@MIT.EDU>
Cc: "Saravana Kannan" <skannan@codeaurora.org>,
        "Viresh Kumar" <viresh.kumar@linaro.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        "Todd Poynor" <toddpoynor@google.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Stephen Boyd" <sboyd@codeaurora.org>
User-Agent: SquirrelMail/1.4.22-4.el6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Srivatsa S. Bhat wrote:
> On 07/15/2014 11:06 AM, Saravana Kannan wrote:
>> On 07/14/2014 09:35 PM, Viresh Kumar wrote:
>>> On 15 July 2014 00:38, Saravana Kannan <skannan@codeaurora.org> wrote:
>>>> Yeah, it definitely crashes if policy->cpu if an offline cpu. Because
>>>> the
>>>> mutex would be uninitialized if it's stopped after boot or it would
>>>> never
>>>> have been initialized (depending on how you fix policy->cpu at boot).
>>>>
>>>> Look at this snippet on the actual tree and it should be pretty
>>>> evident.
>>>
>>> Yeah, I missed it. So the problem is we initialize timer_mutex's for
>>> policy->cpus. So we need to do that just for policy->cpu and also we
>>> don't
>>> need a per-cpu timer_mutex anymore.
>>>
>>
>> Btw, I tried to take a stab at removing any assumption in cpufreq code
>> about policy->cpu being ONLINE.
>
> Wait, allowing an offline CPU to be the policy->cpu (i.e., the CPU which
> is
> considered as the master of the policy/group) is just absurd. If there is
> no leader, there is no army. We should NOT sacrifice sane semantics for
> the
> sake of simplifying the code.
>
>> There are 160 instances of those of with
>> 23 are in cpufreq.c
>>
>
> And that explains why. It is just *natural* to assume that the CPUs
> governed
> by a policy are online. Especially so for the CPU which is supposed to be
> the policy leader. Let us please not change that - it will become
> counter-intuitive if we do so. [ The other reason is that physical hotplug
> is also possible on some systems... in that case your code might make a
> CPU
> which is not even present (but possible) as the policy->cpu.. and great
> 'fun'
> will ensue after that ;-( ]
>
> The goal of this patchset should be to just de-couple the sysfs
> files/ownership
> from the policy->cpu to an extent where it doesn't matter who owns those
> files, and probably make it easier to do CPU hotplug without having to
> destroy and recreate the files on every hotplug operation.
>
> This is exactly why the _implementation_ matters in this particular case -
> if we can't achieve the simplification by keeping sane semantics, then we
> shouldn't do the simplification!
>
> That said, I think we should keep trying - we haven't exhausted all ideas
> yet :-)
>

I don't think we disagree. To summarize this topic: I tried to keep the
policy->cpu an actual online CPU so as to not break existing semantics in
this patch. Viresh asked "why not fix it at boot?". My response was to
keep it an online CPU and give it a shot in a separate patch if we really
want that. It's too risky to do that in this patch and also not a
mandatory change for this patch.

I think we can work out the details on the need to fixing policy->cpu at
boot and whether there's even a need for policy->cpu (when we already have
policy->cpus) in a separate thread after the dust settles on this one?

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

