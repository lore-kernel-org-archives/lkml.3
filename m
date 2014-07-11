Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbaGKOTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:19:07 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13596 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaGKOTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:19:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 11 Jul 2014 07:11:54 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <pdeschrijver@nvidia.com>, <pgaikwad@nvidia.com>, <mturquette@linaro.org>,
        <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH 0/8] Tegra124 EMC (external memory controller) support
Date: Fri, 11 Jul 2014 17:18:25 +0300
Message-ID: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

this series adds support for the EMC (external memory controller) clock
in the Tegra124 system-on-chip. The series has been tested on Jetson TK1.

The first two patches remove the old "emc_mux" and "emc" clocks from the
clock tree and the device tree bindings. This is, of course, not backwards
compatible, but as these clocks have never been useful for anything
(apart from maybe reading the boot rate of the EMC clock). If this is still
not acceptable, the second patch can be dropped.

The second two patches add two clocks, PLL_M_UD and PLL_C_UD, that are
low jitter variants derived from PLL_M and PLL_C respectively. They are used
by some higher EMC clock rates as clock parents.

Patch 5 adds device tree binding documentation for the EMC clock node. It is
a whole separate block on the chip, so it does not go under CAR, as previous
clocks have done.

Patches 6 and 7 enable the EMC clock on Tegra124 and Jetson TK-1. The driver
is enabled always, but can only provide read-only access without EMC tables
that contain hardware characterization data for each operating point of the
clock.

Patch 8 adds the actual driver. The driver needs to write to both CAR and MC
registers in addition to EMC registers. These register accesses are either
shadowed or control a hardware state machine, so delegating them to other
drivers can be dangerous.

Patch 1 must go before patch 2 and patch 4 needs to go after patch 3
but otherwise there shouldn't be any compile-time dependencies. 
Patch 7 has a DTC dependency on patch 3.

Also available from git in
  git://github.com/cyndis/linux.git, branch emc-v1

Mikko Perttunen (8):
  clk: tegra124: Remove old emc_mux and emc clocks
  ARM: tegra: Remove TEGRA124_CLK_EMC from tegra124-car.h
  ARM: tegra: Add PLL_M_UD and PLL_C_UD to tegra124-car binding header
  clk: tegra124: Add PLL_M_UD and PLL_C_UD clocks
  of: Add Tegra124 EMC bindings
  ARM: tegra: Add EMC to Tegra124 device tree
  ARM: tegra: Add EMC timings to Jetson TK1 device tree
  clk: tegra: Add EMC clock driver

 .../bindings/memory-controllers/tegra-emc.txt      |   42 +
 arch/arm/boot/dts/tegra124-jetson-tk1-emc.dtsi     | 2323 ++++++++++++++++++++
 arch/arm/boot/dts/tegra124-jetson-tk1.dts          |    2 +
 arch/arm/boot/dts/tegra124.dtsi                    |    6 +
 drivers/clk/tegra/Makefile                         |    2 +-
 drivers/clk/tegra/clk-emc.c                        | 1508 +++++++++++++
 drivers/clk/tegra/clk-tegra124.c                   |   21 +-
 include/dt-bindings/clock/tegra124-car.h           |    8 +-
 8 files changed, 3896 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt
 create mode 100644 arch/arm/boot/dts/tegra124-jetson-tk1-emc.dtsi
 create mode 100644 drivers/clk/tegra/clk-emc.c

-- 
1.8.1.5

