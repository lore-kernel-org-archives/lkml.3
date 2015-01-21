Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbbAUNiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 08:38:13 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:34264 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbbAUNiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 08:38:05 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH v11 0/4] Per-user clock constraints
Date: Wed, 21 Jan 2015 14:30:28 +0100
Message-Id: <1421847039-29544-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

in this v11 I have restored the possibility of orphaning a clock by passing NULL to clk_set_parent and have fixed the free sequence of per-user clk structs.

The first patch just removes some unneeded NULL checks.

The second patch actually moves the per-clock data that was stored in struct
clk to a new struct clk_core and adds references to it from both struct clk and
struct clk_hw. struct clk is now ready to contain information that is specific
to a given clk consumer.

The third patch adds API for setting floor and ceiling constraints and stores
that information on the per-user struct clk, which is iterable from struct
clk_core. The constraints are made available to clock implementations in the
determine_rate callback.

The fourth patch adds a module that can be used to unit-test the CCF. It's very rough right now, but I hope to have time soon to polish it a bit. It has been quite useful during development of this series though.

http://cgit.collabora.com/git/user/tomeu/linux.git/log/?h=per-user-clk-constraints-v11

Thanks,

Tomeu


Tomeu Vizoso (4):
  clk: Remove unneeded NULL checks
  clk: Make clk API return per-user struct clk instances
  clk: Add rate constraints to clocks
  clk: Add module for unit tests

 Documentation/clk.txt                   |   2 +
 arch/arm/mach-omap2/cclock3xxx_data.c   | 108 ++--
 arch/arm/mach-omap2/clock.h             |  11 +-
 arch/arm/mach-omap2/clock_common_data.c |   5 +-
 arch/arm/mach-omap2/dpll3xxx.c          |   2 +
 arch/arm/mach-omap2/dpll44xx.c          |   2 +
 arch/mips/alchemy/common/clock.c        |   8 +
 drivers/clk/Kconfig                     |   1 +
 drivers/clk/Kconfig.debug               |   6 +
 drivers/clk/Makefile                    |   1 +
 drivers/clk/at91/clk-programmable.c     |   2 +
 drivers/clk/bcm/clk-kona.c              |   2 +
 drivers/clk/clk-composite.c             |   9 +-
 drivers/clk/clk-test.c                  | 325 ++++++++++++
 drivers/clk/clk.c                       | 852 ++++++++++++++++++++++----------
 drivers/clk/clk.h                       |   5 +
 drivers/clk/clkdev.c                    |  80 ++-
 drivers/clk/hisilicon/clk-hi3620.c      |   2 +
 drivers/clk/mmp/clk-mix.c               |   2 +
 drivers/clk/qcom/clk-pll.c              |   1 +
 drivers/clk/qcom/clk-rcg.c              |  10 +-
 drivers/clk/qcom/clk-rcg2.c             |   6 +
 drivers/clk/sunxi/clk-factors.c         |   2 +
 drivers/clk/sunxi/clk-sun6i-ar100.c     |   2 +
 include/linux/clk-private.h             |  41 +-
 include/linux/clk-provider.h            |  27 +-
 include/linux/clk.h                     |  28 ++
 include/linux/clk/ti.h                  |   4 +
 28 files changed, 1206 insertions(+), 340 deletions(-)
 create mode 100644 drivers/clk/Kconfig.debug
 create mode 100644 drivers/clk/clk-test.c

-- 
1.9.3

