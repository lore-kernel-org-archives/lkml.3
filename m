Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907AbaGUPjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:39:40 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:19617 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500AbaGUPji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:39:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 21 Jul 2014 08:27:57 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>, <devicetree@vger.kernel.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>, <broonie@kernel.org>
Subject: [PATCH v2 00/16] Tegra124 CL-DVFS / DFLL clocksource, plus cpufreq
Date: Mon, 21 Jul 2014 18:38:46 +0300
Message-ID: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2 changes:
- Add new helpers to the regulator framework to obtain the voltage
  register address etc., as suggested by Mark. Added in patches 1 & 2.
  They get used in patch 5.
- Use cpufreq-cpu0 in the cpufreq driver
- Fixed one bug in patch 8, where deferred probing would attempt to
  fill the OPP table multiple times and cause a bunch of warnings

Original cover letter:

This series implements the DFLL/CL-DVFS clock source for the fast CPU
cluster on Tegra124, and a cpufreq driver that uses the DFLL for
clocking the CPU. Most of this is based on Paul Walmsley's public patch
set from December 2013, which is available at
http://comments.gmane.org/gmane.linux.ports.tegra/15273

The DFLL clock hardware is a voltage-controlled oscillator plus
control logic that compares the generated output clock with a
51 MHz reference clock, and can make decisions to either lower
or raise the DFLL voltage to keep the output rate close to the
software-requested rate. The voltage changes are done by
communicating with an off-chip PMIC via either I2C or PWM.
As the DFLL oscillator is powered via the CPU rail, using
the DFLL as the CPU clocksource also gives us dynamic CPU
voltage scaling.

This series has been tested on the Jetson TK1 (Rev C). Porting this to
the Venice2 should be simple, though do note that it does not have
active cooling.

Thanks,
Tuomas

Paul Walmsley (1):
  clk: tegra: Add DFLL DVCO reset control for Tegra124

Tuomas Tynkkynen (15):
  regmap: Add regmap_get_device
  regulator: Add helpers for low-level register access
  clk: tegra: Add binding for the Tegra124 DFLL clocksource
  clk: tegra: Add library for the DFLL clock source (open-loop mode)
  clk: tegra: Add closed loop support for the DFLL
  clk: tegra: Add functions for parsing CVB tables
  clk: tegra: Add Tegra124 DFLL clocksource platform driver
  clk: tegra: Save/restore CCLKG_BURST_POLICY on suspend
  clk: tegra: Add the DFLL as a possible parent of the cclk_g clock
  ARM: tegra: Add the DFLL to Tegra124 device tree
  ARM: tegra: Enable the DFLL on the Jetson TK1
  cpufreq: tegra124: Add device tree bindings
  cpufreq: Add cpufreq driver for Tegra124
  ARM: tegra: Add entries for cpufreq on Tegra124
  ARM: tegra: Update defconfig for tegra124-cpufreq

 .../bindings/clock/nvidia,tegra124-dfll.txt        |   69 +
 .../bindings/cpufreq/tegra124-cpufreq.txt          |   42 +
 Documentation/power/regulator/consumer.txt         |   35 +
 arch/arm/boot/dts/tegra124-jetson-tk1.dts          |    8 +-
 arch/arm/boot/dts/tegra124.dtsi                    |   31 +
 arch/arm/configs/tegra_defconfig                   |    1 +
 arch/arm/mach-tegra/Kconfig                        |    1 +
 drivers/base/regmap/regmap.c                       |   12 +
 drivers/clk/tegra/Makefile                         |    3 +
 drivers/clk/tegra/clk-dfll.c                       | 1735 ++++++++++++++++++++
 drivers/clk/tegra/clk-dfll.h                       |   55 +
 drivers/clk/tegra/clk-tegra-super-gen4.c           |    4 +-
 drivers/clk/tegra/clk-tegra124-dfll-fcpu.c         |  165 ++
 drivers/clk/tegra/clk-tegra124.c                   |   61 +
 drivers/clk/tegra/clk.h                            |    3 +
 drivers/clk/tegra/cvb.c                            |  133 ++
 drivers/clk/tegra/cvb.h                            |   67 +
 drivers/cpufreq/Kconfig.arm                        |    1 +
 drivers/cpufreq/Makefile                           |    1 +
 drivers/cpufreq/tegra124-cpufreq.c                 |  169 ++
 drivers/regulator/core.c                           |   71 +
 include/linux/regmap.h                             |    7 +
 include/linux/regulator/consumer.h                 |   26 +
 23 files changed, 2698 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra124-dfll.txt
 create mode 100644 Documentation/devicetree/bindings/cpufreq/tegra124-cpufreq.txt
 create mode 100644 drivers/clk/tegra/clk-dfll.c
 create mode 100644 drivers/clk/tegra/clk-dfll.h
 create mode 100644 drivers/clk/tegra/clk-tegra124-dfll-fcpu.c
 create mode 100644 drivers/clk/tegra/cvb.c
 create mode 100644 drivers/clk/tegra/cvb.h
 create mode 100644 drivers/cpufreq/tegra124-cpufreq.c

-- 
1.8.1.5

