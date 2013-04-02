Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab3DBOfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:35:04 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:9009
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761234Ab3DBOfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:35:00 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -10
X-BigFish: VPS-10(zz98dI9371I146fI1432I179dNzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKMTU6-01-FRG-02
X-M-MSG: 
Date: Tue, 2 Apr 2013 09:34:53 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Thomas Renninger <trenn@suse.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH V2 2/2] cpufreq: AMD "frequency sensitivity feedback"
 powersave bias for ondemand governor
Message-ID: <20130402143453.GA19613@jshin-Toonie>
References: <1364495057-14939-1-git-send-email-jacob.shin@amd.com>
 <1364495057-14939-3-git-send-email-jacob.shin@amd.com>
 <4985234.c9GFoGKqo8@skinner.arch.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4985234.c9GFoGKqo8@skinner.arch.suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 01:40:13PM +0200, Thomas Renninger wrote:
> On Thursday, March 28, 2013 01:24:17 PM Jacob Shin wrote:
> > Future AMD processors, starting with Family 16h, can provide software
> > with feedback on how the workload may respond to frequency change --
> > memory-bound workloads will not benefit from higher frequency, where
> > as compute-bound workloads will. This patch enables this "frequency
> > sensitivity feedback" to aid the ondemand governor to make better
> > frequency change decisions by hooking into the powersave bias.
> If I read this correctly, nothing changes even if the driver is loaded,
> unless user modifies:
> /sys/devices/system/cpu/cpufreq/ondemand/powersave_bias
> is this correct?

Hi, yes that is correct.

> 
> I wonder who should modify:
> /sys/devices/system/cpu/cpufreq/ondemand/powersave_bias
> Even cpupower is not aware of this very specific tunable.

Hmm .. I had thought that end user or distros would already know about
it/use it since the powersave_bias tunable sysfs already exists.

I guess not?

> 
> Also, are you sure cpufreq subsystem will be the only user
> of this one?
> Or could cpuidle or others also make use of this somewhen in the future?

I think so, since this register deals with how the workload is
affected by frequency changes -- cpufreq.

> 
> Then this could more be done like:
> drivers/cpufreq/mperf.c
> And scheduler, cpuidle, cpufreq or whatever could use this as well.
> 
> Just some thinking:
> I wonder how one could check/verify that the right thing is done
> (by CPU and kernel). Ideally it would be nice to have the CPU register
> appended to a cpufreq or cpuidle event trace.
> But this very (AMD or X86 only?) specific data would not look nice there.
> An arch placeholder value would be needed or similar?
> 
> ...
> > +}
> > +
> > +static int __init amd_freq_sensitivity_init(void)
> > +{
> > +	int i;
> > +	u32 eax, edx, dummy;
> > +
> > +	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
> > +		return -ENODEV;
> > +
> > +	cpuid(0x80000007, &eax, &dummy, &dummy, &edx);
> If this really should be a separate module:
> Does/will Intel have the same (feature/cpuid bit)?
> Anyway, this should get a general AMD or X86 CPU capability flag.

As far as I know, this is AMD specific, yes I'll add the AMD vendor
check.

> 
> Then you can also autoload this driver similar to how it's done in acpi-
> cpufreq:
> static const struct x86_cpu_id acpi_cpufreq_ids[] = {
>         X86_FEATURE_MATCH(X86_FEATURE_ACPI),
>         X86_FEATURE_MATCH(X86_FEATURE_HW_PSTATE),
>         {}
> };
> MODULE_DEVICE_TABLE(x86cpu, acpi_cpufreq_ids);

Okay.

Thanks.

> 
>        Thomas
> 

