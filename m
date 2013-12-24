Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab3LXBMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 20:12:46 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49648 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757421Ab3LXBMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 20:12:42 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH v4 00/15] Add support for MSM's mmio clock/reset controller
Date: Mon, 23 Dec 2013 17:12:24 -0800
Message-Id: <1387847559-18330-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first breaks a reset-controller include ordering requirement. I hope it can
go through the clock tree.

The next 3 patches are generic clock framework patches. They add support for
regmap and for setting the rate and the parent at the same time based on
patches from James Hogan's remuxing set_rate series.

After that we add MSM clock hardware support and SoC specific drivers. The DT
node additions will be sent through the MSM maintainers once these patches are
accepted.

Changes since v3:
 * Moved binding include to clock/
 * New patch for 8660 GCC driver
 * Renamed directory to qcom to match vendor prefix
 * Added some missing clocks in 8974 GCC driver
 * New patch for 8974 MMCC driver

Changes since v2:

 * Completed 8960 and 8974 GCC data & dt-bindings
 * Added support for reset controllers
 * Squashed some bugs in 8974 gcc clocks
 * New patch to fix clk NULL pointer deref
 * New patch to fix #include requirement for reset-controller.h

Changes since v1:

 * Rewrote binding to use #clock-cells=1
 * Reworked library components (pll, rcg, branch) to use regmap
 * Dropped common clock framework patches that did DT parsing
 * New patches for regmap support in common clock framework

Stephen Boyd (15):
  reset: Silence warning in reset-controller.h
  clk: Allow drivers to pass in a regmap
  clk: Add regmap core helpers for enable/disable/is_enabled
  clk: Add set_rate_and_parent() op
  clk: qcom: Add support for phase locked loops (PLLs)
  clk: qcom: Add support for root clock generators (RCGs)
  clk: qcom: Add support for branches/gate clocks
  clk: qcom: Add reset controller support
  clk: qcom: Add support for MSM8960's global clock controller (GCC)
  clk: qcom: Add support for MSM8960's multimedia clock controller
    (MMCC)
  clk: qcom: Add support for MSM8974's global clock controller (GCC)
  clk: qcom: Add support for MSM8974's multimedia clock controller
    (MMCC)
  clk: qcom: Add support for MSM8660's global clock controller (GCC)
  devicetree: bindings: Document qcom,gcc
  devicetree: bindings: Document qcom,mmcc

 Documentation/clk.txt                              |    3 +
 .../devicetree/bindings/clock/qcom,gcc.txt         |   21 +
 .../devicetree/bindings/clock/qcom,mmcc.txt        |   21 +
 drivers/clk/Kconfig                                |    2 +
 drivers/clk/Makefile                               |    1 +
 drivers/clk/clk.c                                  |  156 +-
 drivers/clk/qcom/Kconfig                           |   47 +
 drivers/clk/qcom/Makefile                          |   13 +
 drivers/clk/qcom/clk-branch.c                      |  159 ++
 drivers/clk/qcom/clk-branch.h                      |   53 +
 drivers/clk/qcom/clk-pll.c                         |  222 ++
 drivers/clk/qcom/clk-pll.h                         |   65 +
 drivers/clk/qcom/clk-rcg.c                         |  517 ++++
 drivers/clk/qcom/clk-rcg.h                         |  157 +
 drivers/clk/qcom/clk-rcg2.c                        |  291 ++
 drivers/clk/qcom/gcc-msm8660.c                     | 2818 ++++++++++++++++++
 drivers/clk/qcom/gcc-msm8960.c                     | 2992 ++++++++++++++++++++
 drivers/clk/qcom/gcc-msm8974.c                     | 2693 ++++++++++++++++++
 drivers/clk/qcom/mmcc-msm8960.c                    | 2320 +++++++++++++++
 drivers/clk/qcom/mmcc-msm8974.c                    | 2624 +++++++++++++++++
 drivers/clk/qcom/reset.c                           |   63 +
 drivers/clk/qcom/reset.h                           |   37 +
 include/dt-bindings/clock/qcom,gcc-msm8660.h       |  276 ++
 include/dt-bindings/clock/qcom,gcc-msm8960.h       |  313 ++
 include/dt-bindings/clock/qcom,gcc-msm8974.h       |  320 +++
 include/dt-bindings/clock/qcom,mmcc-msm8960.h      |  137 +
 include/dt-bindings/clock/qcom,mmcc-msm8974.h      |  161 ++
 include/dt-bindings/reset/qcom,gcc-msm8660.h       |  134 +
 include/dt-bindings/reset/qcom,gcc-msm8960.h       |  118 +
 include/dt-bindings/reset/qcom,gcc-msm8974.h       |   96 +
 include/dt-bindings/reset/qcom,mmcc-msm8960.h      |   93 +
 include/dt-bindings/reset/qcom,mmcc-msm8974.h      |   62 +
 include/linux/clk-provider.h                       |   35 +
 include/linux/reset-controller.h                   |    1 +
 34 files changed, 17002 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/qcom,gcc.txt
 create mode 100644 Documentation/devicetree/bindings/clock/qcom,mmcc.txt
 create mode 100644 drivers/clk/qcom/Kconfig
 create mode 100644 drivers/clk/qcom/Makefile
 create mode 100644 drivers/clk/qcom/clk-branch.c
 create mode 100644 drivers/clk/qcom/clk-branch.h
 create mode 100644 drivers/clk/qcom/clk-pll.c
 create mode 100644 drivers/clk/qcom/clk-pll.h
 create mode 100644 drivers/clk/qcom/clk-rcg.c
 create mode 100644 drivers/clk/qcom/clk-rcg.h
 create mode 100644 drivers/clk/qcom/clk-rcg2.c
 create mode 100644 drivers/clk/qcom/gcc-msm8660.c
 create mode 100644 drivers/clk/qcom/gcc-msm8960.c
 create mode 100644 drivers/clk/qcom/gcc-msm8974.c
 create mode 100644 drivers/clk/qcom/mmcc-msm8960.c
 create mode 100644 drivers/clk/qcom/mmcc-msm8974.c
 create mode 100644 drivers/clk/qcom/reset.c
 create mode 100644 drivers/clk/qcom/reset.h
 create mode 100644 include/dt-bindings/clock/qcom,gcc-msm8660.h
 create mode 100644 include/dt-bindings/clock/qcom,gcc-msm8960.h
 create mode 100644 include/dt-bindings/clock/qcom,gcc-msm8974.h
 create mode 100644 include/dt-bindings/clock/qcom,mmcc-msm8960.h
 create mode 100644 include/dt-bindings/clock/qcom,mmcc-msm8974.h
 create mode 100644 include/dt-bindings/reset/qcom,gcc-msm8660.h
 create mode 100644 include/dt-bindings/reset/qcom,gcc-msm8960.h
 create mode 100644 include/dt-bindings/reset/qcom,gcc-msm8974.h
 create mode 100644 include/dt-bindings/reset/qcom,mmcc-msm8960.h
 create mode 100644 include/dt-bindings/reset/qcom,mmcc-msm8974.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

