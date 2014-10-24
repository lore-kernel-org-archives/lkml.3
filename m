Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbaJXOlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:41:08 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:60805 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756547AbaJXOlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:41:01 -0400
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com, gnurou@gmail.com,
        pdeschrijver@nvidia.com, rjw@rjwysocki.net, viresh.kumar@linaro.org
Cc: mturquette@linaro.org, pwalmsley@nvidia.com, vinceh@nvidia.com,
        pgaikwad@nvidia.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tuomas.tynkkynen@iki.fi,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>
Subject: [PATCH v5 00/16] Tegra124 CL-DVFS / DFLL clocksource + cpufreq
Date: Fri, 24 Oct 2014 17:39:07 +0300
Message-Id: <1414161563-16812-1-git-send-email-mikko.perttunen@kapsi.fi>
X-Mailer: git-send-email 2.1.0
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Tuomas has been busy so I decided to pick up this series and clean it
up. To the best of my knowledge I've fixed all issues commented on
v4. I've also updated this to cpufreq-dt (from cpufreq-cpu0) and done some
other cosmetic changes. I've also removed usage of the proposed of_match_machine
and reverted to of_is_machine_compatible since at this time there is no
benefit to having match data and wanting to get this merged :)

The series is available in a git repository at
  git://github.com/cyndis/linux.git cldvfs-v5-out

Tested on Jetson-TK1 (rev. D)

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

Mikko Perttunen (1):
  ARM: tegra: Add CPU regulator to the Jetson TK1 device tree

Paul Walmsley (1):
  clk: tegra: Add DFLL DVCO reset control for Tegra124

Tuomas Tynkkynen (14):
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
  cpufreq: tegra: Rename tegra-cpufreq to tegra20-cpufreq
  cpufreq: Add cpufreq driver for Tegra124
  ARM: tegra: Add entries for cpufreq on Tegra124
  ARM: tegra: enable Tegra124 cpufreq driver by default

 .../bindings/clock/nvidia,tegra124-dfll.txt        |   69 +
 .../bindings/cpufreq/tegra124-cpufreq.txt          |   44 +
 arch/arm/boot/dts/tegra124-jetson-tk1.dts          |   14 +-
 arch/arm/boot/dts/tegra124.dtsi                    |   31 +
 arch/arm/configs/tegra_defconfig                   |    1 +
 arch/arm/mach-tegra/Kconfig                        |    1 +
 drivers/clk/tegra/Makefile                         |    3 +
 drivers/clk/tegra/clk-dfll.c                       | 1741 ++++++++++++++++++++
 drivers/clk/tegra/clk-dfll.h                       |   55 +
 drivers/clk/tegra/clk-tegra-super-gen4.c           |    4 +-
 drivers/clk/tegra/clk-tegra124-dfll-fcpu.c         |  165 ++
 drivers/clk/tegra/clk-tegra124.c                   |   61 +
 drivers/clk/tegra/clk.h                            |    3 +
 drivers/clk/tegra/cvb.c                            |  133 ++
 drivers/clk/tegra/cvb.h                            |   67 +
 drivers/cpufreq/Kconfig.arm                        |   13 +-
 drivers/cpufreq/Makefile                           |    3 +-
 drivers/cpufreq/tegra-cpufreq.c                    |  218 ---
 drivers/cpufreq/tegra124-cpufreq.c                 |  217 +++
 drivers/cpufreq/tegra20-cpufreq.c                  |  218 +++
 20 files changed, 2837 insertions(+), 224 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra124-dfll.txt
 create mode 100644 Documentation/devicetree/bindings/cpufreq/tegra124-cpufreq.txt
 create mode 100644 drivers/clk/tegra/clk-dfll.c
 create mode 100644 drivers/clk/tegra/clk-dfll.h
 create mode 100644 drivers/clk/tegra/clk-tegra124-dfll-fcpu.c
 create mode 100644 drivers/clk/tegra/cvb.c
 create mode 100644 drivers/clk/tegra/cvb.h
 delete mode 100644 drivers/cpufreq/tegra-cpufreq.c
 create mode 100644 drivers/cpufreq/tegra124-cpufreq.c
 create mode 100644 drivers/cpufreq/tegra20-cpufreq.c

-- 
2.1.0

