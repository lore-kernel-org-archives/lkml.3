Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab3BEHUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 02:20:36 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:41053 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3BEHUe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 02:20:34 -0500
MIME-Version: 1.0
In-Reply-To: <20130204165057.GH13909@pd.tnic>
References: <20130204123221.GA22340@pd.tnic>
	<CAKohpomcrtV3i9fL4zV6Mt0uDza-9pHTOsqTe2=C1t6mE6cpCQ@mail.gmail.com>
	<20130204130403.GD13909@pd.tnic>
	<CAKohpokuFC5gnTFcD3+RH3p5XaW8vBtyfq+Kej=d2J8tERdmoQ@mail.gmail.com>
	<20130204133648.GE13909@pd.tnic>
	<CAKohpo=aLnhM0Op_32ohWZK5eG5nT7iK0OktBe+8ygOQW7zUqQ@mail.gmail.com>
	<20130204140908.GC15452@pd.tnic>
	<CAKohpokowK6ybYd8aDUdfFYsnzoc5VAKsuPSkfxoDqJ3k+FwGA@mail.gmail.com>
	<20130204150511.GF13909@pd.tnic>
	<CAKohpokt0xtsj1eQDMw6JgvQVp4rgFyU-vUrtuuF+0jjOVNHRQ@mail.gmail.com>
	<20130204165057.GH13909@pd.tnic>
Date: Tue, 5 Feb 2013 12:50:31 +0530
X-Google-Sender-Auth: wQQgrUZpddPUt4HFz5tsWu2OhME
Message-ID: <CAOh2x==fyfYwz+eXmPhBJTE+_q_fHyx2drXrM789XvCfEqPBUQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Borislav Petkov <bp@alien8.de>, Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 4, 2013 at 10:20 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Feb 04, 2013 at 09:07:11PM +0530, Viresh Kumar wrote:
>> └── ondemand
>>     ├── sampling_rate
>>     ├── up_threshold
>>     └── ignore_nice
>
> So this is adding the current governor as a per-cpu thing.

Its per policy, but yes it is replicated into all cpus as all policy->cpus
share the same directory.

>> > One thing I've come to realize with the current interface is that if
>> > you want to change stuff, you need to iterate over all cpus instead of
>> > writing to a system-wide node.
>>
>> Not really. Following is the way by which cpu/cpu*/cpufreq directories
>> are created:
>
> That's not what I meant - I meant from userspace:
>
> for $i in $(grep processor /proc/cpuinfo | awk '{ print $3 }');
> do
>         echo "performance" > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor;
> done
>
> Instead of
>
> echo "performance" > /sys/devices/system/cpu/cpufreq/scaling_governor
>
> which is hypothetical but sets it for the whole system without fuss.

We actually need to do this only for policy->cpu, but yes the user might not
be well aware of policy cpu-groups and may do what you wrote.

But that is true even today, when we need to change any policy tunables or
P-states.

>> I want to control it over clock-domain, but can't get that in cpu/cpufreq/.
>> Policies don't have numbers assigned to them.
>
> So, give them names.

IMHO, names doesn't suit policies.

>> So, i am working on ARM's big.LITTLE system where we have two
>> clusters. One of A15s and other of A7s. Because of their different
>> power ratings or performance figures, we need to have separate set of
>> ondemand tunables for them. And hence this patch. Though this patch is
>> required for any multi-cluster system.
>
> So you want this (values after "="):
>
> cpu/cpufreq/
> |-> policy0
>     |-> name            = A15
>     |-> min_freq        = ...
>     |-> max_freq        = ...
>     |-> affected_cpus   = 0,1,2,...
>     |-> ondemand
>         |-> sampling_rate
>         |-> up_threshold
>         |-> ignore_nice
>     ...
> |-> policy1
>     |-> name            = A7
>     |-> min_freq        = ...
>     |-> max_freq        = ...
>     |-> affected_cpus   = n,n+1,n+2,...
>     |-> performance
>         |-> sampling_rate
>         |-> up_threshold
>         |-> ignore_nice
>     ...

We may have two clusters of A7's also, in a non-big little arch. Then
these names become very confusing.

> Other arches create other policies and that's it. If you need another
> policy added to the set, you simply add 'policyN++' and that's it.

For me, adding policy->names per arch is increasing complexity without
much gain. We already have an existing infrastructure where this info
is present inside cpus and that looks good to me.

> I think this is cleaner but whatever - I don't care that much. My
> only strong concern is that this thing should be a Kconfig option and
> optional for arches where it doesn't apply.

Your concern is: we don't want to fix userspace for existing platforms
where we have just a single cluster and so struct policy in the system.

so, a good solution instead of Kconfig stuff is, add another field in policy
structure that would be filled by platform specific cpufreq drivers init()
routine. Based on which we can decide to put governor directory in
cpu/cpufreq/gov-name or cpu/cpu*/cpufreq/gov-name.

But i am not sure if keeping both kind of directory locations for separate
platforms is a good idea. Userspace needs to adapt to these changes as
well for multi-cluster platforms.

@Rafael: you know about any other multi-cluster/multi-clock-domain
platform leaving big.LITTLE, where we have multiple structs policy?
