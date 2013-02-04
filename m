Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab3BDPhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:37:17 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:39709 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962Ab3BDPhO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:37:14 -0500
MIME-Version: 1.0
In-Reply-To: <20130204150511.GF13909@pd.tnic>
References: <5808458.pvV2iHpBWm@vostro.rjw.lan>
	<CAKohpok7RiJ_HKGi3r0vU26kNEtFKq==pMMoshT6Z2yy9ghemA@mail.gmail.com>
	<20130204123221.GA22340@pd.tnic>
	<CAKohpomcrtV3i9fL4zV6Mt0uDza-9pHTOsqTe2=C1t6mE6cpCQ@mail.gmail.com>
	<20130204130403.GD13909@pd.tnic>
	<CAKohpokuFC5gnTFcD3+RH3p5XaW8vBtyfq+Kej=d2J8tERdmoQ@mail.gmail.com>
	<20130204133648.GE13909@pd.tnic>
	<CAKohpo=aLnhM0Op_32ohWZK5eG5nT7iK0OktBe+8ygOQW7zUqQ@mail.gmail.com>
	<20130204140908.GC15452@pd.tnic>
	<CAKohpokowK6ybYd8aDUdfFYsnzoc5VAKsuPSkfxoDqJ3k+FwGA@mail.gmail.com>
	<20130204150511.GF13909@pd.tnic>
Date: Mon, 4 Feb 2013 21:07:11 +0530
Message-ID: <CAKohpokt0xtsj1eQDMw6JgvQVp4rgFyU-vUrtuuF+0jjOVNHRQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 February 2013 20:35, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Feb 04, 2013 at 07:51:33PM +0530, Viresh Kumar wrote:
>> We correlate things with cpus rather than policies and so the current
>> directory structure of cpu/cpu*/cpufreq/*** is the best suited ones.
>
> Ok, show me the details of that layout. How is that going to look?

I don't have board right now to take the snapshot, but it would be
like:

$ tree /sys/devices/system/cpu/cpu0/cpufreq/
/sys/devices/system/cpu/cpu0/cpufreq/
├── affected_cpus
├── bios_limit
├── cpb
├── cpuinfo_cur_freq
├── cpuinfo_max_freq
├── cpuinfo_min_freq
├── cpuinfo_transition_latency
├── related_cpus
├── scaling_available_frequencies
├── scaling_available_governors
├── scaling_cur_freq
├── scaling_driver
├── scaling_governor
├── scaling_max_freq
├── scaling_min_freq
├── scaling_setspeed
└── stats
    ├── time_in_state
    ├── total_trans
    └── trans_table
└── ondemand
    ├── sampling_rate
    ├── up_threshold
    └── ignore_nice
etc..

> One thing I've come to realize with the current interface is that if
> you want to change stuff, you need to iterate over all cpus instead of
> writing to a system-wide node.

Not really. Following is the way by which cpu/cpu*/cpufreq directories
are created:

For policy->cpu:
	ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq,
				   &dev->kobj, "cpufreq");

This creates cpufreq directory for policy in policy->cpu...

For all other cpus in policy->cpus, we do:
		ret = sysfs_create_link(&cpu_dev->kobj, &policy->kobj,
					"cpufreq");

And so whatever gets added in cpu/cpu0/cpufreq directory is reflected in
all other policy->cpus.

> And, in this case, if you can and need to change the policy per
> clock-domain, I wouldn't make it needlessly too-granulary per-cpu.
>
> That's why I'm advocating the cpu/cpufreq/ path.

Its already like this, i.e. per policy or clock-domain. Other cpus just have a
link. And that's why in my code, i just add governor directory in policy->cpu's
cpufreq directory and it gets reflected in other cpus of policy->cpus.

That's why i said P-states as policy tunables.

>> Hmm.. confused..
>> Consider two systems:
>> - A dual core system, with cores sharing clocks.
>> - A dual cluster system (dual core per cluster), with separate clocks
>> per cluster.
>>
>> Where will you keep governor directories for both of these configurations?
>
> Easy: as said above, make the policy granularity per clock-domain. On
> systems which have only one set of P-states - like it is the case with
> the overwhelming majority of systems running linux now - nothing should
> change.

Currently its not per policy, but single instance of any governor is supported.
And it is present in cpu/cpufreq . That's why i said earlier, it isn't the right
place for governor's directory. It is very much related to a policy or
clock-domain.

>> We need to select only one... cpu/cpufreq doesn't suit the second case
>> at all as we need to use ondemand governor for both the clusters but
>> with separate tunables. And so a single cpu/cpufreq/ondemand directory
>> wouldn't solve the issue.
>
> Think of it this way: what is the highest granularity you need per
> clock-domain? If you want to control the policy per clock-domain, then
> cpu/cpufreq/ is what you want. If you want finer-grained control -
> and you need to think hard of what use cases are sensible for that
> finer-grained solution - then you're better off with cpu/cpu*/ layout.

I want to control it over clock-domain, but can't get that in cpu/cpufreq/.
Policies don't have numbers assigned to them.

> In both cases though, having clear examples of why you've come up with
> the layout you're advocating would help reviewers a lot. If you simply
> come and say we need this because there might be systems out there who
> could use it, then that probably is not going to get you that far.

So, i am working on ARM's big.LITTLE system where we have two clusters.
One of A15s and other of A7s. Because of their different power ratings or
performance figures, we need to have separate set of ondemand tunables
for them. And hence this patch. Though this patch is required for any
multi-cluster system.

--
viresh
