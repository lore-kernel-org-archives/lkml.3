Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbbAWLD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 06:03:59 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:38892 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbbAWLDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 06:03:55 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH v13 0/6] Per-user clock constraints
Date: Fri, 23 Jan 2015 12:03:27 +0100
Message-Id: <1422011024-32283-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

in this v13 I have:

* added the latest R-b tags from Stephen,

* split some lines that went over the 80-char limit,

* made explicit in the docs that the range limits are inclusive, and

* removed an ifdef in clkdev.c by adding a dev_id param to __of_clk_get_by_name.

The first patch just removes some unneeded NULL checks.

The second removes __clk_register.

The third patch actually moves the per-clock data that was stored in struct
clk to a new struct clk_core and adds references to it from both struct clk and
struct clk_hw. struct clk is now ready to contain information that is specific
to a given clk consumer.

The fourth patch adds API for setting floor and ceiling constraints and stores
that information on the per-user struct clk, which is iterable from struct
clk_core. The constraints are made available to clock implementations in the
determine_rate callback.

The fifth patch exports clk_register_clkdev so that clk-test.ko can be built as a module.

The sixth patch adds a module that can be used to unit-test the CCF. It's very rough right now, but I hope to have time soon to polish it a bit. It has been quite useful during development of this series though.

http://cgit.collabora.com/git/user/tomeu/linux.git/log/?h=per-user-clk-constraints-v13

Thanks,

Tomeu

Tomeu Vizoso (6):
  clk: Remove unneeded NULL checks
  clk: Remove __clk_register
  clk: Make clk API return per-user struct clk instances
  clk: Add rate constraints to clocks
  clkdev: Export clk_register_clkdev
  clk: Add module for unit tests

 Documentation/clk.txt                   |   2 +
 arch/arm/mach-omap2/cclock3xxx_data.c   | 111 +++--
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
 drivers/clk/clk-test.c                  | 326 ++++++++++++
 drivers/clk/clk.c                       | 851 +++++++++++++++++++++-----------
 drivers/clk/clk.h                       |   5 +
 drivers/clk/clkdev.c                    |  85 +++-
 drivers/clk/hisilicon/clk-hi3620.c      |   2 +
 drivers/clk/mmp/clk-mix.c               |   2 +
 drivers/clk/qcom/clk-pll.c              |   1 +
 drivers/clk/qcom/clk-rcg.c              |  10 +-
 drivers/clk/qcom/clk-rcg2.c             |   6 +
 drivers/clk/sunxi/clk-factors.c         |   2 +
 drivers/clk/sunxi/clk-sun6i-ar100.c     |   2 +
 include/linux/clk-private.h             |  43 +-
 include/linux/clk-provider.h            |  27 +-
 include/linux/clk.h                     |  28 ++
 include/linux/clk/ti.h                  |   4 +
 28 files changed, 1187 insertions(+), 369 deletions(-)
 create mode 100644 drivers/clk/Kconfig.debug
 create mode 100644 drivers/clk/clk-test.c

-- 
1.9.3

