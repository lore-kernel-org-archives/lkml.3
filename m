Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab3BDQvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:51:11 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40912 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755613Ab3BDQvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:51:08 -0500
Date: Mon, 4 Feb 2013 17:50:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
Message-ID: <20130204165057.GH13909@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
	Steve.Bannister@arm.com, Liviu.Dudau@arm.com
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKohpokt0xtsj1eQDMw6JgvQVp4rgFyU-vUrtuuF+0jjOVNHRQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 09:07:11PM +0530, Viresh Kumar wrote:
> I don't have board right now to take the snapshot, but it would be
> like:
> 
> $ tree /sys/devices/system/cpu/cpu0/cpufreq/
> /sys/devices/system/cpu/cpu0/cpufreq/
> ├── affected_cpus
> ├── bios_limit
> ├── cpb
> ├── cpuinfo_cur_freq
> ├── cpuinfo_max_freq
> ├── cpuinfo_min_freq
> ├── cpuinfo_transition_latency
> ├── related_cpus
> ├── scaling_available_frequencies
> ├── scaling_available_governors
> ├── scaling_cur_freq
> ├── scaling_driver
> ├── scaling_governor
> ├── scaling_max_freq
> ├── scaling_min_freq
> ├── scaling_setspeed
> └── stats
>     ├── time_in_state
>     ├── total_trans
>     └── trans_table
> └── ondemand
>     ├── sampling_rate
>     ├── up_threshold
>     └── ignore_nice

So this is adding the current governor as a per-cpu thing.

> > One thing I've come to realize with the current interface is that if
> > you want to change stuff, you need to iterate over all cpus instead of
> > writing to a system-wide node.
> 
> Not really. Following is the way by which cpu/cpu*/cpufreq directories
> are created:

That's not what I meant - I meant from userspace:

for $i in $(grep processor /proc/cpuinfo | awk '{ print $3 }');
do
	echo "performance" > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor;
done

Instead of

echo "performance" > /sys/devices/system/cpu/cpufreq/scaling_governor

which is hypothetical but sets it for the whole system without fuss.

[ … ]

> I want to control it over clock-domain, but can't get that in cpu/cpufreq/.
> Policies don't have numbers assigned to them.

So, give them names.

> So, i am working on ARM's big.LITTLE system where we have two
> clusters. One of A15s and other of A7s. Because of their different
> power ratings or performance figures, we need to have separate set of
> ondemand tunables for them. And hence this patch. Though this patch is
> required for any multi-cluster system.

So you want this (values after "="):

cpu/cpufreq/
|-> policy0
    |-> name		= A15
    |-> min_freq	= ...
    |-> max_freq	= ...
    |-> affected_cpus	= 0,1,2,...
    |-> ondemand
        |-> sampling_rate
	|-> up_threshold
	|-> ignore_nice
    ...
|-> policy1
    |-> name		= A7
    |-> min_freq	= ...
    |-> max_freq	= ...
    |-> affected_cpus	= n,n+1,n+2,...
    |-> performance
        |-> sampling_rate
	|-> up_threshold
	|-> ignore_nice
    ...

Other arches create other policies and that's it. If you need another
policy added to the set, you simply add 'policyN++' and that's it.

I think this is cleaner but whatever - I don't care that much. My
only strong concern is that this thing should be a Kconfig option and
optional for arches where it doesn't apply.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
