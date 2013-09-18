Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab3IRSAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 14:00:33 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:55930 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3IRRyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:54:11 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        linux-tegra@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kernel@stlinux.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/26] ARM: provide common arch init for DT clocks
Date: Wed, 18 Sep 2013 19:53:33 +0200
Message-Id: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch set based on an RFC [1][2] sent earlier to provide a common
arch/arm init for DT clock providers. Currently, the call to of_clk_init(NULL)
to initialize DT clock providers is spread among several mach-dirs. Since most
machs require DT clocks initialized before timers, no initcall can be used.

By adding of_clk_init(NULL) to arch/arm time_init(), we can remove all
mach-specific .init_time hooks that basically called of_clk_init and
clocksource_of_init.

In contrast to the RFC version, of_clk_init(NULL) is now only called if no
custom .init_time callback is set. This allows some machs to still call clock
init themselves, as not all can be converted now. Therefore, this patch sets
drops conversion of mach-mvebu and mach-zynq. New machs that were introduced
with v3.12-rc1 are also converted, except mach-u300 that requires clocks
before irqs.

The patch set is based on v3.12-rc1 and further depends on a topic branch
created by Stephen Warren for mach-tegra [3]. It is now split into preparation
and removal patches to not break bisectability. I added all Acked-by/Tested-by's
where applicable or dropped them, if the patch was separated into two.
It has been compile tested for all machs involved with the following defconfigs
(multi_v7, bcm2835, dove, exynos, kirkwood, mxs, nhk8815) and nspire selected
on multi_v4_v5.

Patches 1-8 comprise preparation patches that convert machs nomadik, prima2,
socfpga, sunxi, tegra, and vt8500 to usual .init_time callbacks calling only
of_clk_init and clocksource_of_init.

Patch 9 then introduces of_clk_init(NULL) to the arch-wide default .init_time
callback.

Patches 10-26 finally remove custom .init_time callbacks from the machs involved.

The patches have been pushed to a topic branch based on v3.12-rc1 with tegra's
tegra-for-3.13-deps-for-arm-init-time-cleanup branch merged in to

https://github.com/shesselba/linux-dove.git clk-of-init-v1_for-3.13

[1] http://www.spinics.net/lists/arm-kernel/msg268260.html
[2] http://www.spinics.net/lists/arm-kernel/msg270173.html
[3] http://www.spinics.net/lists/arm-kernel/msg273957.html
    git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git tegra-for-3.13-deps-for-arm-init-time-cleanup

Sebastian Hesselbarth (26):
  ARM: nomadik: move mtu setup to clocksource init
  clk: nomadik: move src init out of nomadik_clk_init
  clk: nomadik: declare OF clock provider
  clk: prima2: declare OF clock provider
  ARM: socfgpa: prepare for arch-wide .init_time callback
  clk: sunxi: declare OF clock provider
  clk: vt8500: parse pmc_base from clock driver
  ARM: vt8500: prepare for arch-wide .init_time callback
  ARM: call of_clk_init from default time_init handler
  ARM: bcm2835: remove custom .init_time hook
  ARM: dove: remove custom .init_time hook
  ARM: exynos: remove custom .init_time hook
  ARM: highbank: remove custom .init_time hook
  ARM: imx: remove custom .init_time hook
  ARM: kirkwood: remove custom .init_time hook
  ARM: mxs: remove custom .init_time hook
  ARM: nomadik: remove custom .init_time hook
  ARM: nspire: remove custom .init_time hook
  ARM: prima2: remove custom .init_time hook
  ARM: rockchip: remove custom .init_time hook
  ARM: socfpga: remove custom .init_time hook
  ARM: sti: remove custom .init_time hook
  ARM: sunxi: remove custom .init_time hook
  ARM: tegra: remove custom .init_time hook
  ARM: vexpress: remove custom .init_time hook
  ARM: vt8500: remove custom .init_time hook

 arch/arm/kernel/time.c                    |   27 ++---
 arch/arm/mach-bcm2835/bcm2835.c           |    2 -
 arch/arm/mach-dove/board-dt.c             |   11 --
 arch/arm/mach-exynos/common.c             |    8 --
 arch/arm/mach-exynos/common.h             |    1 -
 arch/arm/mach-exynos/mach-exynos4-dt.c    |    2 -
 arch/arm/mach-exynos/mach-exynos5-dt.c    |    2 -
 arch/arm/mach-highbank/highbank.c         |   23 ++---
 arch/arm/mach-imx/clk-imx51-imx53.c       |   29 ++----
 arch/arm/mach-imx/common.h                |    4 -
 arch/arm/mach-imx/imx51-dt.c              |    6 --
 arch/arm/mach-imx/mach-imx53.c            |    6 --
 arch/arm/mach-imx/mach-imx6q.c            |   14 +--
 arch/arm/mach-imx/mach-imx6sl.c           |    7 --
 arch/arm/mach-imx/mach-vf610.c            |    9 --
 arch/arm/mach-kirkwood/board-dt.c         |    8 --
 arch/arm/mach-mxs/mach-mxs.c              |   13 ---
 arch/arm/mach-nomadik/cpu-8815.c          |   36 -------
 arch/arm/mach-nspire/nspire.c             |    9 --
 arch/arm/mach-prima2/common.c             |   11 --
 arch/arm/mach-prima2/common.h             |    1 -
 arch/arm/mach-rockchip/rockchip.c         |    9 --
 arch/arm/mach-socfpga/socfpga.c           |    2 -
 arch/arm/mach-sti/board-dt.c              |   10 +-
 arch/arm/mach-sunxi/sunxi.c               |   10 --
 arch/arm/mach-tegra/tegra.c               |    9 --
 arch/arm/mach-vexpress/v2m.c              |   14 +--
 arch/arm/mach-vt8500/common.h             |   24 -----
 arch/arm/mach-vt8500/vt8500.c             |    6 --
 drivers/clk/clk-bcm2835.c                 |    8 --
 drivers/clk/clk-highbank.c                |   10 +-
 drivers/clk/clk-nomadik.c                 |  161 ++++++++++++++---------------
 drivers/clk/clk-prima2.c                  |   29 ++----
 drivers/clk/clk-vt8500.c                  |   31 ++++--
 drivers/clk/mxs/clk-imx23.c               |   15 +--
 drivers/clk/mxs/clk-imx28.c               |   16 +--
 drivers/clk/sunxi/clk-sunxi.c             |   11 +-
 drivers/clocksource/nomadik-mtu.c         |   11 ++
 include/linux/clk/mxs.h                   |    2 -
 include/linux/clk/sunxi.h                 |   22 ----
 include/linux/platform_data/clk-nomadik.h |    2 -
 41 files changed, 182 insertions(+), 449 deletions(-)
 delete mode 100644 arch/arm/mach-vt8500/common.h
 delete mode 100644 include/linux/clk/sunxi.h
 delete mode 100644 include/linux/platform_data/clk-nomadik.h

---
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: STEricsson <STEricsson_nomadik_linux@list.st.com>
Cc: linux-tegra@vger.kernel.org
Cc: linux-rpi-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: kernel@stlinux.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.7.10.4

