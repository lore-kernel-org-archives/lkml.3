Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3H0Vcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 17:32:41 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:38645 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3H0V2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 17:28:22 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-tegra@vger.kernel.org, kernel@stlinux.com,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v2 00/16] ARM: provide common arch init for DT clocks
Date: Tue, 27 Aug 2013 23:27:54 +0200
Message-Id: <1377638890-371-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This RFC converts arch/arm to provide a common arch init for DT clock
providers. Currently, the call to of_clk_init(NULL) to initialize DT
clock providers is spread among several mach-dirs. Since most machs
require DT clocks initialized before timers, no initcall can be used.

By adding of_clk_init(NULL) to ARM time_init(), we can remove all
mach-specific .init_time hooks that basically called of_clk_init before
starting timers.

Based on the previous version, this one now includes patches provided by
Stephen Warren for mach-tegra and Soren Brinkmann for mach-zynq.

With mach-tegra now requiring clocks as late as the other machs, the
patch to protect of_clk_init() from being called twice, has been dropped.

The RFCv2 is based on next-20130827 and has been compile tested for
multi_v7_defconfig and mach-dove. All single patches have also been sent
to the respective maintainers and corresponding mailing lists.

Before going for a real patch set after v3.11 drops, I prefer to have
Tested-by or Acked-by for at least mach-imx, mach-mxs, mach-sti, and
mach-vexpress. Others are trivial, prepared by maintainers (mach-tegra
and mach-zynq), or have already been Acked-by (mach-highbank).

Also, I'd like to know if the patches should be grouped by mach- or
rather been split into mach- preparation and .init_time removal.

Sebastian Hesselbarth (14):
  ARM: call clk_of_init from time_init
  ARM: dove: remove custom .init_time hook
  ARM: exynos: remove custom .init_time hook
  ARM: highbank: remove custom .init_time hook
  ARM: imx: remove custom .init_time hook
  ARM: kirkwood: remove custom .init_time hook
  ARM: mvebu: remove custom .init_time hook
  ARM: mxs: remove custom .init_time hook
  ARM: nspire: remove custom .init_time hook
  ARM: rockchip: remove custom .init_time hook
  ARM: socfpga: remove call to of_clk_init
  ARM: sti: remove custom .init_time hook
  ARM: vexpress: remove custom .init_time hook
  clk: vt8500: remove call to of_clk_init

Soren Brinkmann (1):
  ARM: zynq: Don't call of_clk_init()

Stephen Warren (1):
  ARM: tegra: split tegra_pmc_init() in two

 arch/arm/kernel/time.c                 |   24 +++++++++++-------
 arch/arm/mach-dove/board-dt.c          |   17 +------------
 arch/arm/mach-exynos/common.c          |    7 -----
 arch/arm/mach-exynos/common.h          |    1 -
 arch/arm/mach-exynos/mach-exynos4-dt.c |    1 -
 arch/arm/mach-exynos/mach-exynos5-dt.c |    1 -
 arch/arm/mach-highbank/highbank.c      |   23 +++++------------
 arch/arm/mach-imx/clk-imx51-imx53.c    |   29 +++++++--------------
 arch/arm/mach-imx/common.h             |    4 ---
 arch/arm/mach-imx/imx51-dt.c           |    6 ----
 arch/arm/mach-imx/mach-imx53.c         |    6 ----
 arch/arm/mach-imx/mach-imx6q.c         |   14 ++--------
 arch/arm/mach-imx/mach-imx6sl.c        |    7 -----
 arch/arm/mach-imx/mach-vf610.c         |    9 -------
 arch/arm/mach-kirkwood/board-dt.c      |    8 ------
 arch/arm/mach-mvebu/armada-370-xp.c    |    2 -
 arch/arm/mach-mxs/mach-mxs.c           |   13 ----------
 arch/arm/mach-nspire/nspire.c          |    9 -------
 arch/arm/mach-rockchip/rockchip.c      |    9 -------
 arch/arm/mach-socfpga/socfpga.c        |    2 -
 arch/arm/mach-sti/board-dt.c           |   10 +++----
 arch/arm/mach-tegra/common.c           |    4 +--
 arch/arm/mach-tegra/pmc.c              |   41 +++++++++++++++++--------------
 arch/arm/mach-tegra/pmc.h              |    1 +
 arch/arm/mach-tegra/tegra.c            |    5 ++-
 arch/arm/mach-vexpress/v2m.c           |   14 +----------
 arch/arm/mach-zynq/common.c            |    9 +++----
 drivers/clk/clk-highbank.c             |   10 +++++--
 drivers/clk/clk-vt8500.c               |    2 -
 drivers/clk/mxs/clk-imx23.c            |   16 +++++-------
 drivers/clk/mxs/clk-imx28.c            |   16 +++++-------
 drivers/clk/zynq/clkc.c                |    4 ++-
 include/linux/clk/mxs.h                |    2 -
 33 files changed, 95 insertions(+), 231 deletions(-)

---
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-tegra@vger.kernel.org
Cc: kernel@stlinux.com
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.7.2.5

