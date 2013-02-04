Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab3BDOVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 09:21:36 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:65037 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab3BDOVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 09:21:34 -0500
MIME-Version: 1.0
In-Reply-To: <20130204140908.GC15452@pd.tnic>
References: <cover.1359976493.git.viresh.kumar@linaro.org>
	<5808458.pvV2iHpBWm@vostro.rjw.lan>
	<CAKohpok7RiJ_HKGi3r0vU26kNEtFKq==pMMoshT6Z2yy9ghemA@mail.gmail.com>
	<20130204123221.GA22340@pd.tnic>
	<CAKohpomcrtV3i9fL4zV6Mt0uDza-9pHTOsqTe2=C1t6mE6cpCQ@mail.gmail.com>
	<20130204130403.GD13909@pd.tnic>
	<CAKohpokuFC5gnTFcD3+RH3p5XaW8vBtyfq+Kej=d2J8tERdmoQ@mail.gmail.com>
	<20130204133648.GE13909@pd.tnic>
	<CAKohpo=aLnhM0Op_32ohWZK5eG5nT7iK0OktBe+8ygOQW7zUqQ@mail.gmail.com>
	<20130204140908.GC15452@pd.tnic>
Date: Mon, 4 Feb 2013 19:51:33 +0530
Message-ID: <CAKohpokowK6ybYd8aDUdfFYsnzoc5VAKsuPSkfxoDqJ3k+FwGA@mail.gmail.com>
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 February 2013 19:39, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Feb 04, 2013 at 07:28:16PM +0530, Viresh Kumar wrote:
>> All files which are directly present in cpu/cpu*/cpufreq/ folder. I am
>> not talking about governor tunables but policy tunables. Things like
>> scaling_[min]max_freq are policy tunables.
>
> No, on x86 those are the P-states frequencies. They're defined by the
> hardware.

A question we need to answer: What is "policy"?

For me, "policy" is the hardware policy for a group of cpus, defined by the
hardware. We call them P-states. But these are strictly per policy (i.e. per
cpu group sharing clock line).

So, if we have two packages with two cpus each, we will have two copies
of these P-states and every other file/directory in cpu/cpu*/cpufreq.
One common copy would be shared between cpu/cpu[0-1]/cpufreq
directory and other one between cpu/cpu[2-3]/cpufreq.

>> Policies don't have a name associated with them and so
>> cpu/cpufreq/policies doesn't make any sense. Rather one policy is
>> related to multiple cpus and its tunables are linked in all the cpus
>> that belong to it, like scaling_[min]max_freq.
>
> Then do the following:
>
> cpu/cpufreq/policies/
> |-> policy0
>     |-> min_freq
>     |-> max_freq
>     |-> affected_cpus
>     ...

We correlate things with cpus rather than policies and so the current directory
structure of cpu/cpu*/cpufreq/*** is the best suited ones.

> or whatever needs to be a flexible interface for multi-policy cpufreq
> support.

The multi policy part is already well implemented, we are talking about governor
per policy here.

> Remember: once you do those, they're more or less cast in stone so take
> your time and do the design right, do not hurry those.

Yes, and that's why cpu/cpu*/cpufreq/ondemand/*** suits the best, with exactly
the same logic that went for P-states or cpufreq-stats.

>> But then we will get governors tunables in cpu/cpu*/cpufreq/ instead
>> of cpu/cpufreq/ . Will that not break userspace for other systems?
>
> What's wrong with having both? The cpu/cpufreq/ governor will set the
> system-wide governor and the cpu/cpu*/cpufreq/ will add the different
> policies.

Hmm.. confused..
Consider two systems:
- A dual core system, with cores sharing clocks.
- A dual cluster system (dual core per cluster), with separate clocks
per cluster.

Where will you keep governor directories for both of these configurations?

We need to select only one... cpu/cpufreq doesn't suit the second case at all
as we need to use ondemand governor for both the clusters but with separate
tunables. And so a single cpu/cpufreq/ondemand directory wouldn't solve the
issue.

--
viresh
