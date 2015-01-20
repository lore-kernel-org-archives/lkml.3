Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbbATNZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:25:23 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:49983 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbbATNZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:25:19 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH v10 0/3] Per-user clock constraints
Date: Tue, 20 Jan 2015 14:24:56 +0100
Message-Id: <1421760306-6301-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have addressed here the last comments from Stephen, most notably:

* Add more missing NULL checks

* Remove a few unused functions

* Call nolock variants from __clk_mux_determine_rate

* Refactor __clk_determine_rate to share code with clk_round_rate.

The second patch actually moves the per-clock data that was stored in struct
clk to a new struct clk_core and adds references to it from both struct clk and
struct clk_hw. struct clk is now ready to contain information that is specific
to a given clk consumer.

The third patch adds API for setting floor and ceiling constraints and stores
that information on the per-user struct clk, which is iterable from struct
clk_core. The constraints are made available to clock implementations in the
determine_rate callback.

A rough test module was used to test this:

http://cgit.collabora.com/git/user/tomeu/linux.git/tree/drivers/misc/clk-test.c?h=per-user-clk-constraints-v10

http://cgit.collabora.com/git/user/tomeu/linux.git/log/?h=per-user-clk-constraints-v10

Thanks,

Tomeu

Tomeu Vizoso (3):
  clk: Remove unneeded NULL checks
  clk: Make clk API return per-user struct clk instances
  clk: Add rate constraints to clocks

 Documentation/clk.txt                   |   2 +
 arch/arm/mach-omap2/cclock3xxx_data.c   | 108 ++--
 arch/arm/mach-omap2/clock.h             |  11 +-
 arch/arm/mach-omap2/clock_common_data.c |   5 +-
 arch/arm/mach-omap2/dpll3xxx.c          |   2 +
 arch/arm/mach-omap2/dpll44xx.c          |   2 +
 arch/mips/alchemy/common/clock.c        |   8 +
 drivers/clk/at91/clk-programmable.c     |   2 +
 drivers/clk/bcm/clk-kona.c              |   2 +
 drivers/clk/clk-composite.c             |   9 +-
 drivers/clk/clk.c                       | 844 ++++++++++++++++++++++----------
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
 24 files changed, 865 insertions(+), 340 deletions(-)

-- 
1.9.3

