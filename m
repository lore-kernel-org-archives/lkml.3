Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaJTNlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:41:16 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:48545 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaJTNlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:41:13 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Alex Elder <elder@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-omap@vger.kernel.org, Manuel Lauss <manuel.lauss@gmail.com>,
        Matt Porter <mporter@linaro.org>, Ralf Baechle <ralf@linux-mips.org>,
        Tim Kryger <tim.kryger@linaro.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v4 0/8] Per-user clock constraints
Date: Mon, 20 Oct 2014 15:40:00 +0200
Message-Id: <1413812442-24956-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this fourth version of the series is mainly intended to address many good
comments from Stephen Boyd, most notably:

* Make sure that best_parent_p is populated with the current parent before
calling clk_ops.determine_rate()

* Make sure we don't lose information about the caller in of_clk_get_*

* Refresh the effective rate after a per-user clk is removed

* Store requested rate and re-apply it when constraints are updated

The first six patches are just cleanups that should be desirable on their own,
and that should make easier to review the actual per-user clock patch.

The seventh patch actually moves the per-clock data that was stored in struct
clk to a new struct clk_core and adds references to it from both struct clk and
struct clk_hw. struct clk is now ready to contain information that is specific
to a given clk consumer.

The eighth patch adds API for setting floor and ceiling constraints and stores
that information on the per-user struct clk, which is iterable from struct
clk_core.

They are based on top of 3.18-rc1.

http://cgit.collabora.com/git/user/tomeu/linux.git/log/?h=per-user-clk-constraints-v4

Thanks,

Tomeu

Tomeu Vizoso (8):
  MIPS: Alchemy: Remove direct access to prepare_count field of struct
    clk
  clk: Remove unused function __clk_get_prepare_count
  clk: Don't try to use a struct clk* after it could have been freed
  clk: Don't expose __clk_get_accuracy
  clk: change clk_debugfs_add_file to take a struct clk_hw
  clk: Change clk_ops->determine_rate to return a clk_hw as the best
    parent
  clk: Make clk API return per-user struct clk instances
  clk: Add floor and ceiling constraints to clock rates

 Documentation/clk.txt                   |   2 +-
 arch/arm/mach-omap2/cclock3xxx_data.c   | 108 +++--
 arch/arm/mach-omap2/clock.h             |  11 +-
 arch/arm/mach-omap2/clock_common_data.c |   5 +-
 arch/mips/alchemy/common/clock.c        |  17 +-
 drivers/clk/at91/clk-programmable.c     |   4 +-
 drivers/clk/bcm/clk-kona.c              |   4 +-
 drivers/clk/clk-composite.c             |   9 +-
 drivers/clk/clk.c                       | 788 +++++++++++++++++++++-----------
 drivers/clk/clk.h                       |   5 +
 drivers/clk/clkdev.c                    |  73 ++-
 drivers/clk/hisilicon/clk-hi3620.c      |   2 +-
 drivers/clk/qcom/clk-rcg.c              |  20 +-
 drivers/clk/qcom/clk-rcg2.c             |  28 +-
 drivers/clk/sunxi/clk-factors.c         |   4 +-
 drivers/clk/sunxi/clk-sun6i-ar100.c     |   4 +-
 include/linux/clk-private.h             |  41 +-
 include/linux/clk-provider.h            |  17 +-
 include/linux/clk.h                     |  18 +
 19 files changed, 771 insertions(+), 389 deletions(-)

-- 
1.9.3

