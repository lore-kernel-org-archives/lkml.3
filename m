Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab3HTMVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 08:21:48 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51359 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab3HTMVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 08:21:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        "R, Durgadoss" <durgadoss.r@intel.com>
Subject: Re: [PATCH v7 0/7] cpufreq:boost: CPU Boost mode support
Date: Tue, 20 Aug 2013 14:32:20 +0200
Message-ID: <30622208.1oE8UlHGCe@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130820101147.5a7c2efa@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com> <2325996.izOUC9kIz1@vostro.rjw.lan> <20130820101147.5a7c2efa@amdc308.digital.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 20, 2013 10:11:47 AM Lukasz Majewski wrote:
> On Tue, 20 Aug 2013 01:29:20 +0200 Rafael J. Wysocki rjw@sisk.pl wrote,
> > On Monday, August 19, 2013 08:50:37 AM Lukasz Majewski wrote:
> > > On Mon, 19 Aug 2013 12:08:26 +0530 Viresh Kumar
> > > viresh.kumar@linaro.org wrote,
> > > > On 13 August 2013 15:38, Lukasz Majewski <l.majewski@samsung.com>
> > > > wrote:
> > > > > This patch series introduces support for CPU overclocking
> > > > > technique called Boost.
> > > > >
> > > > > It is a follow up of a LAB governor proposal. Boost is a LAB
> > > > > component:
> > > > > http://thread.gmane.org/gmane.linux.kernel/1484746/match=cpufreq
> > > > >
> > > > > Boost unifies hardware based solution (e.g. Intel Nehalem) with
> > > > > software oriented one (like the one done at Exynos).
> > > > > For this reason cpufreq/freq_table code has been reorganized to
> > > > > include common code.
> > > > >
> > > > > Important design decisions:
> > > > > - Boost related code is compiled-in unconditionally to cpufreq
> > > > > core and disabled by default. The cpufreq_driver is
> > > > > responsibile for setting boost_supported flag and providing
> > > > > set_boost callback(if HW support is needed). For software
> > > > > managed boost, special Kconfig flag - CONFIG_CPU_FREQ_BOOST_SW
> > > > > has been defined. It will be selected only when a target
> > > > > platform has thermal framework properly configured.
> > > > >
> > > > > - struct cpufreq_driver has been extended with boost related
> > > > > fields: -- boost_supported - when driver supports boosting
> > > > >         -- boost_enabled - boost state
> > > > >         -- set_boost - callback to function, which is necessary
> > > > > to enable/disable boost
> > > > >
> > > > > - Boost sysfs attribute (/sys/devices/system/cpu/cpufreq/boost)
> > > > > is visible _only_ when cpufreq driver supports Boost.
> > > > >
> > > > > - No special spin_lock for Boost was created. The one from
> > > > > cpufreq core was reused.
> > > > >
> > > > > - The Boost code doesn't rely on any policy. When boost state is
> > > > > changed, then the policy list is iterated and proper
> > > > > adjustements are done.
> > > > >
> > > > > - To improve safety level, the thermal framework is also
> > > > > extended to disable software boosting, when thermal trip point
> > > > > is reached. Then it starts monitoring target temperature to
> > > > > evaluate if boost can be enabled again. This emulates behaviour
> > > > > similar to HW managed boost (like x86)
> > > > >
> > > > > Tested at HW:
> > > > >        Exynos 4412 3.11-rc4 Linux
> > > > >        Intel Core i7-3770 3.11-rc4 Linux
> > > > >
> > > > > Above patches were posted on top of linux_pm/linux-next with
> > > > > following patches applied:
> > > > >
> > > > > cpufreq: exynos5440: Fix to skip when new frequency same as
> > > > > current cpufreq: fix EXYNOS drivers selection
> > > > >
> > > > > Lukasz Majewski (7):
> > > > >   cpufreq: Add boost frequency support in core
> > > > >   cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to work with
> > > > > common boost solution
> > > > >   thermal:boost: Automatic enable/disable of BOOST feature
> > > > >   cpufreq:boost:Kconfig: Provide support for software managed
> > > > > BOOST cpufreq:exynos:Extend Exynos cpufreq driver to support
> > > > > boost framework
> > > > >   Documentation:cpufreq:boost: Update BOOST documentation
> > > > >   cpufreq:exynos4x12: Change L0 driver data to
> > > > > CPUFREQ_BOOST_FREQ
> > > > 
> > > > Hi Lukasz,
> > > > 
> > > 
> > > Hi Viresh,
> > > 
> > > > I haven't found time yet to go through this series.. 
> > > 
> > > I've just started wondering if I had send those patches
> > > correctly :-).
> > > 
> > > > I want to do a
> > > > deep/careful review this time as these are almost the final
> > > > patches.
> > > 
> > > Ok.
> > > 
> > > > 
> > > > Will try to get over them by the end of this week..
> > > 
> > > Ok, I understand.
> > 
> > Do I assume correctly that this stuff has been tested on
> > ACPI-compatible x86 with acpi-cpufreq and everything has worked
> > correctly there?
> > 
> > Rafael
> > 
> 
> Hi Rafael,
> 
> Following test configuration/test case (x86):
> 
> - DELL OptiPlex 9010 Intel Core i7-3770
> - Linux repo: [kernel_pm_http/bleeding-edge] [kernel_pm_http/linux-next]
> 	SHA1: a238ea5e20be7bea2b1fc951a024ecce770306b5 
> 	with v7 applied on top
> 
> - Linux version: 3.11-rc4 (patches v7) and 3.11-rc1 (v6)
> 
> - Ubuntu 11.10 (make bzImage + make all when module was needed)
> - config_ubuntu_3_11 (the default one for ubuntu)
> - KConfig:
> 	1. Disabled intel_pstate driver
> 	2. Enabled ACPI-Prosessor P state driver
> 	3. Legacy cpb sysfs knob support for AMD CPUs ON/OFF (which is a
> 	part of acpi-cpufreq.c driver).
> 	
> - acpi-cpufreq driver was build as a module or was embedded in kernel
>   (tested with modprobe -i / -r => no dmesg error|warning output)
> 
> - I was able to read/write (echo 0/1
>   > /sys/devices/system/cpu/cpufreq/boost) => no output at dmesg -
>   system was working stable.
> 
> Toolchain: gcc version 4.6.1 (Ubuntu/Linaro 4.6.1-9ubuntu3)
> 
> Since I'm mostly working with ARM (exynos4412) and major work was done
> with cpufreq core (and x86 related work was to move common code to
> cpufreq core) tests mostly have been performed on ARM.
> 
> Tests on ARM:
> - Stress tests with up to 4 scripts running to enable/disable boost
>   sysfs attribute with random time interval (gzip < /dev/urandom
>   > /dev/null). 
> - Test to overheat the ARM target and look if boost+thermal cools down
>   the device and enables boost again.
> - LAB governor (which was already posted to ML) to boost when power
>   envelope allows it.

Great, thanks a lot for the info!

Rafael

