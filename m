Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbaFYAG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 20:06:29 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41325 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbaFYAG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 20:06:27 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [RFC/PATCH 00/12] Krait clocks + Krait CPUfreq
Date: Tue, 24 Jun 2014 17:06:11 -0700
Message-Id: <1403654783-7176-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches provide cpufreq scaling on devices with Krait CPUs.
For now I've only added support for 8960 and 8974. Adding more
chips should be fairly easy. There are still some big TODOs but
I'm posting these patches now to get any early feedback possible.

The first patch has been posted before. It's included here for
completeness. The second patch changes the way rates are changed
in the generic framework so that we can safely switch rates of clocks
while they're being used to clock the CPU. The third patch is 
temporary until I can properly use the CCF code for generic muxes
and dividers. The fourth, fifth and sixth patches are mostly ready to go,
they add HFPLL support. After that, the seventh patch adds support for the
Krait clock ops; basically muxes and dividers that are controlled by cp15
registers. The eighth patch adds a driver to control the muxes in KPSSv1
that provide the aux clock source for the Krait clocks. The ninth patch ties
all the Krait clocks together into a clock provider. The tenth and eleventh
patches are the cpufreq layer that look for a qcom,krait cpu and then register
a cpufreq driver that switches the rate of the CPU clocks between whatever OPP
tables say are available. The final patch ties it all together by adding
all the DTS necessary to get this stuff to probe.

I plan to submit the cpufreq patches directly to the cpufreq maintainers
and the DTS changes through arm-soc, but I've included everything here to
make it easier to pick things up for testing, etc.

TODO:
 * Get rid of clk-generic.c and use the CCF generic code
 * Make cpufreq-krait generic for any systems with one clock per CPU
 * Populate OPPs by reading the qfprom instead of relying on DT
 * Add Krait regulator voltage scaling (not strictly necessary)
 * Document lots of DT bindings

Stephen Boyd (12):
  ARM: Add Krait L2 register accessor functions
  clk: Add safe switch hook
  clk: qcom: Add support for muxes, dividers, and mux dividers
  clk: qcom: Add support for High-Frequency PLLs (HFPLLs)
  clk: qcom: Add HFPLL driver
  clk: qcom: Add MSM8960's HFPLLs
  clk: qcom: Add support for Krait clocks
  clk: qcom: Add KPSS ACC/GCC driver
  clk: qcom: Add Krait clock controller driver
  cpufreq: Add a cpufreq-krait based on cpufreq-cpu0
  cpufreq: Add module to register cpufreq-krait device
  ARM: dts: qcom: Add necessary DT data for Krait cpufreq

 arch/arm/boot/dts/qcom-msm8960.dtsi       |  49 ++++
 arch/arm/boot/dts/qcom-msm8974.dtsi       | 106 +++++++-
 arch/arm/common/Kconfig                   |   3 +
 arch/arm/common/Makefile                  |   1 +
 arch/arm/common/krait-l2-accessors.c      |  58 +++++
 arch/arm/include/asm/krait-l2-accessors.h |  20 ++
 drivers/clk/clk.c                         |  53 +++-
 drivers/clk/qcom/Kconfig                  |  25 ++
 drivers/clk/qcom/Makefile                 |   6 +
 drivers/clk/qcom/clk-generic.c            | 405 ++++++++++++++++++++++++++++++
 drivers/clk/qcom/clk-hfpll.c              | 260 +++++++++++++++++++
 drivers/clk/qcom/clk-hfpll.h              |  54 ++++
 drivers/clk/qcom/clk-krait.c              | 121 +++++++++
 drivers/clk/qcom/clk-krait.h              |  22 ++
 drivers/clk/qcom/gcc-msm8960.c            |  82 ++++++
 drivers/clk/qcom/hfpll.c                  | 110 ++++++++
 drivers/clk/qcom/kpss-xcc.c               | 115 +++++++++
 drivers/clk/qcom/krait-cc.c               | 366 +++++++++++++++++++++++++++
 drivers/cpufreq/Kconfig                   |  13 +
 drivers/cpufreq/Kconfig.arm               |   8 +
 drivers/cpufreq/Makefile                  |   2 +
 drivers/cpufreq/cpufreq-krait.c           | 190 ++++++++++++++
 drivers/cpufreq/qcom-cpufreq.c            |  48 ++++
 include/linux/clk-private.h               |   2 +
 include/linux/clk-provider.h              |   1 +
 include/linux/clk/msm-clk-generic.h       | 208 +++++++++++++++
 26 files changed, 2317 insertions(+), 11 deletions(-)
 create mode 100644 arch/arm/common/krait-l2-accessors.c
 create mode 100644 arch/arm/include/asm/krait-l2-accessors.h
 create mode 100644 drivers/clk/qcom/clk-generic.c
 create mode 100644 drivers/clk/qcom/clk-hfpll.c
 create mode 100644 drivers/clk/qcom/clk-hfpll.h
 create mode 100644 drivers/clk/qcom/clk-krait.c
 create mode 100644 drivers/clk/qcom/clk-krait.h
 create mode 100644 drivers/clk/qcom/hfpll.c
 create mode 100644 drivers/clk/qcom/kpss-xcc.c
 create mode 100644 drivers/clk/qcom/krait-cc.c
 create mode 100644 drivers/cpufreq/cpufreq-krait.c
 create mode 100644 drivers/cpufreq/qcom-cpufreq.c
 create mode 100644 include/linux/clk/msm-clk-generic.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

