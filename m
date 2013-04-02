Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761016Ab3DBLkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:40:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37815 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759896Ab3DBLkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:40:15 -0400
From: Thomas Renninger <trenn@suse.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH V2 2/2] cpufreq: AMD "frequency sensitivity feedback" powersave bias for ondemand governor
Date: Tue, 02 Apr 2013 13:40:13 +0200
Message-ID: <4985234.c9GFoGKqo8@skinner.arch.suse.de>
Organization: SUSE Products GmbH
User-Agent: KMail/4.10 (Linux/3.7.10-1.1-desktop; KDE/4.10.0; x86_64; ; )
In-Reply-To: <1364495057-14939-3-git-send-email-jacob.shin@amd.com>
References: <1364495057-14939-1-git-send-email-jacob.shin@amd.com> <1364495057-14939-3-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 28, 2013 01:24:17 PM Jacob Shin wrote:
> Future AMD processors, starting with Family 16h, can provide software
> with feedback on how the workload may respond to frequency change --
> memory-bound workloads will not benefit from higher frequency, where
> as compute-bound workloads will. This patch enables this "frequency
> sensitivity feedback" to aid the ondemand governor to make better
> frequency change decisions by hooking into the powersave bias.
If I read this correctly, nothing changes even if the driver is loaded,
unless user modifies:
/sys/devices/system/cpu/cpufreq/ondemand/powersave_bias
is this correct?

I wonder who should modify:
/sys/devices/system/cpu/cpufreq/ondemand/powersave_bias
Even cpupower is not aware of this very specific tunable.

Also, are you sure cpufreq subsystem will be the only user
of this one?
Or could cpuidle or others also make use of this somewhen in the future?

Then this could more be done like:
drivers/cpufreq/mperf.c
And scheduler, cpuidle, cpufreq or whatever could use this as well.

Just some thinking:
I wonder how one could check/verify that the right thing is done
(by CPU and kernel). Ideally it would be nice to have the CPU register
appended to a cpufreq or cpuidle event trace.
But this very (AMD or X86 only?) specific data would not look nice there.
An arch placeholder value would be needed or similar?

...
> +}
> +
> +static int __init amd_freq_sensitivity_init(void)
> +{
> +	int i;
> +	u32 eax, edx, dummy;
> +
> +	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
> +		return -ENODEV;
> +
> +	cpuid(0x80000007, &eax, &dummy, &dummy, &edx);
If this really should be a separate module:
Does/will Intel have the same (feature/cpuid bit)?
Anyway, this should get a general AMD or X86 CPU capability flag.

Then you can also autoload this driver similar to how it's done in acpi-
cpufreq:
static const struct x86_cpu_id acpi_cpufreq_ids[] = {
        X86_FEATURE_MATCH(X86_FEATURE_ACPI),
        X86_FEATURE_MATCH(X86_FEATURE_HW_PSTATE),
        {}
};
MODULE_DEVICE_TABLE(x86cpu, acpi_cpufreq_ids);

       Thomas
