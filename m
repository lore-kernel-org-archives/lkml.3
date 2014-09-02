Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaIBAks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 20:40:48 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:41747 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbaIBAkq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 20:40:46 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1408568684-11016-1-git-send-email-ttynkkynen@nvidia.com>
Cc: "Stephen Warren" <swarren@wwwdotorg.org>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        "Peter De Schrijver" <pdeschrijver@nvidia.com>,
        "Prashant Gaikwad" <pgaikwad@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Viresh Kumar" <viresh.kumar@linaro.org>,
        "Paul Walmsley" <pwalmsley@nvidia.com>,
        "Vince Hsu" <vinceh@nvidia.com>, devicetree@vger.kernel.org,
        "Tuomas Tynkkynen" <ttynkkynen@nvidia.com>
References: <1408568684-11016-1-git-send-email-ttynkkynen@nvidia.com>
Message-ID: <20140902004034.5251.35559@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v4 00/16] Tegra124 CL-DVFS / DFLL clocksource, plus cpufreq
Date: Mon, 01 Sep 2014 17:40:34 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tuomas Tynkkynen (2014-08-20 14:04:28)
> v4 changes:
> DFLL:
>     - fix wrong register accessors used for the DFLL_OUTPUT_CFG register
>         - I decided to leave the dfll_i2c_{readl,writel} separate since the
>           correct barrier function still needs to be called
>     - fix PMIC I2C voltage register address being uninitialized
> cpufreq:
>     - back to 'depends on GENERIC_CPUFREQ_CPU0' from 'select GENERIC_CPUFREQ_CPU0'
>         - leads to new patch to update the defconfigs
>     - check for get_cpu_device() return value
>     - add comment why an extra platform driver+device is required
> 
> v3 changes:
> - Fix incorrect order of arguments to dfll_scale_dvco_rate
> - Fix accidental commas at end-of-statement to semicolons
> - Some cpufreq changes:
>     - rename cpufreq-tegra to cpufreq-tegra20
>     - have separate Kconfig entries for Tegra20/Tegra124 support
>     - use 'select GENERIC_CPUFREQ_CPU0', not depends
>     - support unbinding of the platform device
>         - requires adding the vdd_cpu regulator to the DT so
>           the old voltage can be restored when switching to PLLX
>     - allocate a state structure instead of globals
>     - use of_match_machine()
>     - various style nits fixed
> 
> The cpufreq part is dependant on the of_match_machine() series.
> 
> Original cover letter:
> 
> This series implements the DFLL/CL-DVFS clock source for the fast CPU
> cluster on Tegra124, and a cpufreq driver that uses the DFLL for
> clocking the CPU. Most of this is based on Paul Walmsley's public patch
> set from December 2013, which is available at
> http://comments.gmane.org/gmane.linux.ports.tegra/15273
> 
> The DFLL clock hardware is a voltage-controlled oscillator plus
> control logic that compares the generated output clock with a
> 51 MHz reference clock, and can make decisions to either lower
> or raise the DFLL voltage to keep the output rate close to the
> software-requested rate. The voltage changes are done by
> communicating with an off-chip PMIC via either I2C or PWM.
> As the DFLL oscillator is powered via the CPU rail, using
> the DFLL as the CPU clocksource also gives us dynamic CPU
> voltage scaling.
> 
> This series has been tested on the Jetson TK1 (Rev C). Porting this to
> the Venice2 should be simple, though do note that it does not have
> active cooling.

At a quick glance, the clock driver changes look good to me.

Regards,
Mike

> 
> Thanks,
> Tuomas
> 
> Paul Walmsley (1):
>   clk: tegra: Add DFLL DVCO reset control for Tegra124
> 
> Tuomas Tynkkynen (15):
>   clk: tegra: Add binding for the Tegra124 DFLL clocksource
>   clk: tegra: Add library for the DFLL clock source (open-loop mode)
>   clk: tegra: Add closed loop support for the DFLL
>   clk: tegra: Add functions for parsing CVB tables
>   clk: tegra: Add Tegra124 DFLL clocksource platform driver
>   clk: tegra: Save/restore CCLKG_BURST_POLICY on suspend
>   clk: tegra: Add the DFLL as a possible parent of the cclk_g clock
>   ARM: tegra: Add the DFLL to Tegra124 device tree
>   ARM: tegra: Enable the DFLL on the Jetson TK1
>   cpufreq: tegra124: Add device tree bindings
>   cpufreq: tegra: Rename tegra-cpufreq to tegra20-cpufreq
>   cpufreq: Add cpufreq driver for Tegra124
>   ARM: tegra: Add entries for cpufreq on Tegra124
>   ARM: tegra: Add CPU regulator to the Jetson TK1 device tree
>   ARM: tegra: enable Tegra124 cpufreq driver by default
> 
>  .../bindings/clock/nvidia,tegra124-dfll.txt        |   69 +
>  .../bindings/cpufreq/tegra124-cpufreq.txt          |   44 +
>  arch/arm/boot/dts/tegra124-jetson-tk1.dts          |   12 +-
>  arch/arm/boot/dts/tegra124.dtsi                    |   33 +-
>  arch/arm/configs/tegra_defconfig                   |    1 +
>  arch/arm/mach-tegra/Kconfig                        |    1 +
>  drivers/clk/tegra/Makefile                         |    3 +
>  drivers/clk/tegra/clk-dfll.c                       | 1741 ++++++++++++++++++++
>  drivers/clk/tegra/clk-dfll.h                       |   55 +
>  drivers/clk/tegra/clk-tegra-super-gen4.c           |    4 +-
>  drivers/clk/tegra/clk-tegra124-dfll-fcpu.c         |  165 ++
>  drivers/clk/tegra/clk-tegra124.c                   |   61 +
>  drivers/clk/tegra/clk.h                            |    3 +
>  drivers/clk/tegra/cvb.c                            |  133 ++
>  drivers/clk/tegra/cvb.h                            |   67 +
>  drivers/cpufreq/Kconfig.arm                        |   13 +-
>  drivers/cpufreq/Makefile                           |    3 +-
>  drivers/cpufreq/tegra124-cpufreq.c                 |  215 +++
>  .../cpufreq/{tegra-cpufreq.c => tegra20-cpufreq.c} |    0
>  19 files changed, 2616 insertions(+), 7 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra124-dfll.txt
>  create mode 100644 Documentation/devicetree/bindings/cpufreq/tegra124-cpufreq.txt
>  create mode 100644 drivers/clk/tegra/clk-dfll.c
>  create mode 100644 drivers/clk/tegra/clk-dfll.h
>  create mode 100644 drivers/clk/tegra/clk-tegra124-dfll-fcpu.c
>  create mode 100644 drivers/clk/tegra/cvb.c
>  create mode 100644 drivers/clk/tegra/cvb.h
>  create mode 100644 drivers/cpufreq/tegra124-cpufreq.c
>  rename drivers/cpufreq/{tegra-cpufreq.c => tegra20-cpufreq.c} (100%)
> 
> -- 
> 1.8.1.5
> 
