Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaK1OFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 09:05:00 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:52633 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaK1OEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 09:04:55 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        sboyd@codeaurora.org, Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Alex Elder <elder@linaro.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-omap@vger.kernel.org, Manuel Lauss <manuel.lauss@gmail.com>,
        Matt Porter <mporter@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Ralf Baechle <ralf@linux-mips.org>, Tim Kryger <tim.kryger@linaro.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 0/7] Per-user clock constraints
Date: Fri, 28 Nov 2014 15:03:21 +0100
Message-Id: <1417183461-8210-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this sixth version of the series has a small fix in the per-user clks commit
and the following changes in the clk constraints patch:

* Take the prepare lock before removing a per-user clk
* Init per-user clks list before adding the first clk
* Pass the constraints to determine_rate and let clk implementations deal
with constraints
* Add clk_set_rate_range

A rough test module was used to test this:

http://cgit.collabora.com/git/user/tomeu/linux.git/commit/?h=per-user-clk-constraints-v6&id=1bada453ab690a1c5be28667d94a4861bc84f8ef

The first five patches are just cleanups that should be desirable on their own,
and that should make easier to review the actual per-user clock patch.

The sixth patch actually moves the per-clock data that was stored in struct
clk to a new struct clk_core and adds references to it from both struct clk and
struct clk_hw. struct clk is now ready to contain information that is specific
to a given clk consumer.

The seventh patch adds API for setting floor and ceiling constraints and stores
that information on the per-user struct clk, which is iterable from struct
clk_core.

They are based on top of linux-next 20141128.

http://cgit.collabora.com/git/user/tomeu/linux.git/log/?h=per-user-clk-constraints-v6

Thanks,

Tomeu

Tomeu Vizoso (7):
  clk: Remove unused function __clk_get_prepare_count
  clk: Don't try to use a struct clk* after it could have been freed
  clk: Don't expose __clk_get_accuracy
  clk: change clk_debugfs_add_file to take a struct clk_hw
  clk: Change clk_ops->determine_rate to return a clk_hw as the best
    parent
  clk: Make clk API return per-user struct clk instances
  clk: Add floor and ceiling constraints to clock rates

 Documentation/clk.txt                   |   4 +-
 arch/arm/mach-omap2/cclock3xxx_data.c   | 108 +++--
 arch/arm/mach-omap2/clock.h             |  11 +-
 arch/arm/mach-omap2/clock_common_data.c |   5 +-
 arch/arm/mach-omap2/dpll3xxx.c          |   2 +
 arch/arm/mach-omap2/dpll44xx.c          |   2 +
 arch/mips/alchemy/common/clock.c        |  18 +-
 drivers/clk/at91/clk-programmable.c     |   6 +-
 drivers/clk/bcm/clk-kona.c              |   6 +-
 drivers/clk/clk-composite.c             |  18 +-
 drivers/clk/clk.c                       | 807 +++++++++++++++++++++-----------
 drivers/clk/clk.h                       |   5 +
 drivers/clk/clkdev.c                    |  73 ++-
 drivers/clk/hisilicon/clk-hi3620.c      |   4 +-
 drivers/clk/qcom/clk-pll.c              |   1 +
 drivers/clk/qcom/clk-rcg.c              |  24 +-
 drivers/clk/qcom/clk-rcg2.c             |  34 +-
 drivers/clk/sunxi/clk-factors.c         |   6 +-
 drivers/clk/sunxi/clk-sun6i-ar100.c     |   6 +-
 include/linux/clk-private.h             |  41 +-
 include/linux/clk-provider.h            |  26 +-
 include/linux/clk.h                     |  28 ++
 include/linux/clk/ti.h                  |   4 +
 23 files changed, 849 insertions(+), 390 deletions(-)

-- 
1.9.3

