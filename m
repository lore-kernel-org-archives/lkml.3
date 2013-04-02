Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708Ab3DBMtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 08:49:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50435 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759896Ab3DBMtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 08:49:43 -0400
Date: Tue, 2 Apr 2013 14:49:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Renninger <trenn@suse.de>
Cc: Jacob Shin <jacob.shin@amd.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH V2 2/2] cpufreq: AMD "frequency sensitivity feedback"
 powersave bias for ondemand governor
Message-ID: <20130402124940.GB5488@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Thomas Renninger <trenn@suse.de>, Jacob Shin <jacob.shin@amd.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Viresh Kumar <viresh.kumar@linaro.org>
References: <1364495057-14939-1-git-send-email-jacob.shin@amd.com>
 <1364495057-14939-3-git-send-email-jacob.shin@amd.com>
 <4985234.c9GFoGKqo8@skinner.arch.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4985234.c9GFoGKqo8@skinner.arch.suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
> 
> I wonder who should modify:
> /sys/devices/system/cpu/cpufreq/ondemand/powersave_bias
> Even cpupower is not aware of this very specific tunable.
> 
> Also, are you sure cpufreq subsystem will be the only user
> of this one?
> Or could cpuidle or others also make use of this somewhen in the future?

Yeah, I don't think this is supposed to work like that - more likely,
you want to use the freq sensitivity thing by default if the hardware
supports it.

So I think the od_tuners->powersave_bias check needs to be augmented
with a freq_sensitivity cpuid bit check...

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

I actually wonder whether this should be a separate module but I
guess this is maybe the most agreeable way for adding vendor-specific
functionality to cpufreq.

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
> 
> Then you can also autoload this driver similar to how it's done in acpi-
> cpufreq:
> static const struct x86_cpu_id acpi_cpufreq_ids[] = {
>         X86_FEATURE_MATCH(X86_FEATURE_ACPI),
>         X86_FEATURE_MATCH(X86_FEATURE_HW_PSTATE),
>         {}
> };
> MODULE_DEVICE_TABLE(x86cpu, acpi_cpufreq_ids);

Yes, this needs to be a cpu feature bit in cpufeature.h and be loaded
automatically.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
