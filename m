Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035Ab3JPHkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 03:40:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43952 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab3JPHkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 03:40:18 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH v3 00/12] Add support for MSM's mmio clock/reset controller 
Date: Wed, 16 Oct 2013 00:40:02 -0700
Message-Id: <1381909214-12693-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.1.503.g2b7ca91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first two patches fix a clock framework bug and break a reset-controller
include ordering requirement.

The next 3 patches are generic clock framework patches. They add support for
regmap and for setting the rate and the parent at the same time based on
patches from James Hogan's remuxing set_rate series.

After that we add MSM clock hardware support and SoC specific drivers. The DT
node additions will be sent through the MSM maintainers once these patches are
accepted.

Some questions:

 1) The clock controller is also a power domain controller.
    Should we put that code in the drivers under drivers/clk/msm?

 2) Should the directory be renamed to qcom to match the binding?
    (I will probably do this for the next spin)

 3) What is the right place for clock dt binding #defines? clk/ or clock/?

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


Stephen Boyd (12):
  clk: Fix debugfs reparenting NULL pointer dereference
  reset: Silence warning in reset-controller.h
  clk: Allow drivers to pass in a regmap
  clk: Add regmap core helpers for enable/disable/is_enabled
  clk: Add set_rate_and_parent() op
  clk: msm: Add support for phase locked loops (PLLs)
  clk: msm: Add support for root clock generators (RCGs)
  clk: msm: Add support for branches/gate clocks
  clk: msm: Add reset controller support
  clk: msm: Add support for MSM8960's global clock controller (GCC)
  clk: msm: Add support for MSM8960's multimedia clock controller (MMCC)
  clk: msm: Add support for MSM8974's global clock controller (GCC)

 Documentation/clk.txt                              |    3 +
 .../devicetree/bindings/clock/qcom,gcc.txt         |   22 +
 .../devicetree/bindings/clock/qcom,mmcc.txt        |   21 +
 drivers/clk/Kconfig                                |    2 +
 drivers/clk/Makefile                               |    1 +
 drivers/clk/clk.c                                  |  159 +-
 drivers/clk/msm/Kconfig                            |   30 +
 drivers/clk/msm/Makefile                           |   11 +
 drivers/clk/msm/clk-branch.c                       |  152 +
 drivers/clk/msm/clk-branch.h                       |   52 +
 drivers/clk/msm/clk-pll.c                          |  145 +
 drivers/clk/msm/clk-pll.h                          |   47 +
 drivers/clk/msm/clk-rcg.c                          |  517 ++++
 drivers/clk/msm/clk-rcg.h                          |  157 ++
 drivers/clk/msm/clk-rcg2.c                         |  270 ++
 drivers/clk/msm/gcc-8960.c                         | 2929 ++++++++++++++++++++
 drivers/clk/msm/gcc-8974.c                         | 2453 ++++++++++++++++
 drivers/clk/msm/mmcc-8960.c                        | 2129 ++++++++++++++
 drivers/clk/msm/reset.c                            |   63 +
 drivers/clk/msm/reset.h                            |   37 +
 include/dt-bindings/clk/msm-gcc-8960.h             |  313 +++
 include/dt-bindings/clk/msm-gcc-8974.h             |  320 +++
 include/dt-bindings/clk/msm-mmcc-8960.h            |  137 +
 include/dt-bindings/reset/msm-gcc-8960.h           |   63 +
 include/dt-bindings/reset/msm-gcc-8974.h           |   96 +
 include/dt-bindings/reset/msm-mmcc-8960.h          |   93 +
 include/linux/clk-provider.h                       |   35 +
 include/linux/reset-controller.h                   |    1 +
 28 files changed, 10237 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/qcom,gcc.txt
 create mode 100644 Documentation/devicetree/bindings/clock/qcom,mmcc.txt
 create mode 100644 drivers/clk/msm/Kconfig
 create mode 100644 drivers/clk/msm/Makefile
 create mode 100644 drivers/clk/msm/clk-branch.c
 create mode 100644 drivers/clk/msm/clk-branch.h
 create mode 100644 drivers/clk/msm/clk-pll.c
 create mode 100644 drivers/clk/msm/clk-pll.h
 create mode 100644 drivers/clk/msm/clk-rcg.c
 create mode 100644 drivers/clk/msm/clk-rcg.h
 create mode 100644 drivers/clk/msm/clk-rcg2.c
 create mode 100644 drivers/clk/msm/gcc-8960.c
 create mode 100644 drivers/clk/msm/gcc-8974.c
 create mode 100644 drivers/clk/msm/mmcc-8960.c
 create mode 100644 drivers/clk/msm/reset.c
 create mode 100644 drivers/clk/msm/reset.h
 create mode 100644 include/dt-bindings/clk/msm-gcc-8960.h
 create mode 100644 include/dt-bindings/clk/msm-gcc-8974.h
 create mode 100644 include/dt-bindings/clk/msm-mmcc-8960.h
 create mode 100644 include/dt-bindings/reset/msm-gcc-8960.h
 create mode 100644 include/dt-bindings/reset/msm-gcc-8974.h
 create mode 100644 include/dt-bindings/reset/msm-mmcc-8960.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

