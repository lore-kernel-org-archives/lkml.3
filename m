Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab3HTCEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:04:38 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:33332 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab3HTCEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:04:35 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC 00/17] ARM: provide common arch init for DT clocks
Date: Tue, 20 Aug 2013 04:04:14 +0200
Message-Id: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This RFC converts arch/arm to provide a common arch init for DT clock
providers. Currently, the call to of_clk_init(NULL) to initialize DT
clock providers is spread among several mach-dirs. Since most machs
require DT clocks initialized before timers, no initcall can be used.

By adding of_clk_init(NULL) to ARM time_init(), we can remove all
mach-specific .init_time hooks that basically called of_clk_init before
starting timers. Some machs use the hook for more initialization, that
has been moved to other hooks where required.

The only exception is mach-tegra which requires clocks even earlier in
.init_irq. To allow machs to call clk_of_init at any time earlier than
time_init(), we first need to ensure drivers in __clk_of_table are only
initialized once.

The RFC is based on next-20130819 to catch up with future clock related
changes. It has been tested on mach-mvebu and compile tested for all the
other machs modified. All single patches have also been sent to the
respective maintainers.

Although some patches also modify files in mach-foo and drivers/clk, I
decided to keep them in a single patch to also show what would be
required for a common arch clock init.

Sebastian Hesselbarth (17):
  clk: ensure __clk_of_table is only initialized once
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
  ARM: socfpga: remove custom .init_time hook
  ARM: sti: remove custom .init_time hook
  ARM: tegra: remove .init_time hook to clocksource_of_init
  ARM: vexpress: remove custom .init_time hook
  clk: vt8500: remove call to of_clk_init
  clk: zynq: remove call to of_clk_init

 arch/arm/kernel/time.c                   |    4 ++++
 arch/arm/mach-dove/board-dt.c            |   16 +---------------
 arch/arm/mach-exynos/common.c            |    7 -------
 arch/arm/mach-exynos/common.h            |    1 -
 arch/arm/mach-exynos/mach-exynos4-dt.c   |    1 -
 arch/arm/mach-exynos/mach-exynos5-dt.c   |    1 -
 arch/arm/mach-highbank/highbank.c        |   23 +++++++----------------
 arch/arm/mach-imx/clk-imx51-imx53.c      |   12 ------------
 arch/arm/mach-imx/common.h               |    2 --
 arch/arm/mach-imx/imx51-dt.c             |    6 ------
 arch/arm/mach-imx/mach-imx53.c           |    6 ------
 arch/arm/mach-imx/mach-imx6q.c           |   14 +++-----------
 arch/arm/mach-imx/mach-imx6sl.c          |    7 -------
 arch/arm/mach-imx/mach-vf610.c           |    9 ---------
 arch/arm/mach-kirkwood/board-dt.c        |    8 --------
 arch/arm/mach-mvebu/armada-370-xp.c      |   11 +----------
 arch/arm/mach-mxs/mach-mxs.c             |   13 -------------
 arch/arm/mach-nspire/nspire.c            |    9 ---------
 arch/arm/mach-rockchip/rockchip.c        |    9 ---------
 arch/arm/mach-socfpga/socfpga.c          |    2 --
 arch/arm/mach-sti/board-dt.c             |   10 ++++------
 arch/arm/mach-tegra/tegra.c              |    2 --
 arch/arm/mach-vexpress/v2m.c             |   14 +-------------
 drivers/clk/clk-highbank.c               |   10 +++++++---
 drivers/clk/clk-vt8500.c                 |    2 --
 drivers/clk/clk.c                        |    8 +++++++-
 drivers/clk/mxs/clk-imx23.c              |   16 +++++++---------
 drivers/clk/mxs/clk-imx28.c              |   16 ++++++++--------
 drivers/clk/zynq/clkc.c                  |    1 -
 drivers/clocksource/time-armada-370-xp.c |    7 +++----
 include/linux/clk/mxs.h                  |    2 --
 include/linux/time-armada-370-xp.h       |   16 ----------------
 32 files changed, 53 insertions(+), 212 deletions(-)
 delete mode 100644 include/linux/time-armada-370-xp.h

---
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.7.10.4

