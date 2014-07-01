Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbaGAQd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:33:26 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:65313 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758139AbaGAQdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:33:24 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net, shawn.guo@linaro.org
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        sboyd@codeaurora.org, linux-arm-msm@vger.kernel.org,
        spk.linux@gmail.com, thomas.ab@samsung.com, nm@ti.com,
        t.figa@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>,
        devicetree@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>,
        Rob Herring <rob.herring@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Simon Horman <horms@verge.net.au>
Subject: [PATCH 00/14] cpufreq: cpu0: Extend support beyond CPU0, V2
Date: Tue,  1 Jul 2014 22:02:29 +0530
Message-Id: <cover.1404231535.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V1: https://lkml.org/lkml/2014/6/25/152

Stephen Boyd sent few patches some time back around a new cpufreq driver for
Qualcomm's Krait SoC: https://lkml.org/lkml/2014/6/24/918.

Krait couldn't use existing cpufreq-cpu0 driver as it doesn't have support for
SoC's with multiple clusters or SoC's which don't share clock line across all
CPUs.

This patchset is all about extending support beyond CPU0. It can be used for
platforms like Krait or ARM big LITTLE architecture now.

First two patches add helper routine for of and clk layer, which would be used
by later patches.

Third one adds space for driver specific data in 'struct cpufreq_policy' and
later ones migrate cpufreq-cpu0 to cpufreq-generic, i.e. can be used for SoCs
which don't share clock lines across all CPUs.

@Stephen: I haven't added your Tested-by as there were few modifications since
the time you tested it last.

Pushed here:
Rebased over v3.16-rc3:
git://git.linaro.org/people/viresh.kumar/linux.git cpufreq/cpu0-krait-v2

For guys looking to test on exynos, rebased over linux-next + some patches from
Thomas Abraham to use cpufreq-cpu0 for exynos:
git://git.linaro.org/people/viresh.kumar/linux.git cpufreq/cpu0-exynos-v2

Cc: devicetree@vger.kernel.org
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Rob Herring <rob.herring@linaro.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Simon Horman <horms@verge.net.au>

Viresh Kumar (14):
  of: Create of_property_match()
  clk: Create of_clk_shared_by_cpus()
  cpufreq: Add support for per-policy driver data
  cpufreq: cpu0: Add Module Author
  cpufreq: cpu0: don't validate clock on clk_put()
  cpufreq: cpu0: defer probe if clock isn't registered yet
  cpufreq: cpu0: OPPs can be populated at runtime
  cpufreq: cpu0: use dev_{err|warn|dbg} instead of pr_{err|warn|debug}
  cpufreq: cpu0: Move per-cluster initialization code to ->init()
  cpufreq: cpu0: try regulators with name "cpu-supply"
  cpufreq: cpu0: Make allocate_resources() work for any CPU
  cpufreq: cpu0: Extend support beyond CPU0
  cpufreq: cpu0: rename driver and internals to 'cpufreq_generic'
  cpufreq: generic: set platform_{driver|device} '.name' to
    'cpufreq-generic'

 .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt   |  62 ----
 .../bindings/cpufreq/cpufreq-generic.txt           | 126 +++++++
 arch/arm/mach-imx/imx27-dt.c                       |   2 +-
 arch/arm/mach-imx/imx51-dt.c                       |   2 +-
 arch/arm/mach-omap2/pm.c                           |   2 +-
 arch/arm/mach-shmobile/board-ape6evm-reference.c   |   2 +-
 arch/arm/mach-shmobile/setup-sh73a0.c              |   4 +-
 arch/arm/mach-zynq/common.c                        |   2 +-
 drivers/clk/clk.c                                  |  56 +++
 drivers/cpufreq/Kconfig                            |  10 +-
 drivers/cpufreq/Kconfig.arm                        |   2 +-
 drivers/cpufreq/Makefile                           |   2 +-
 drivers/cpufreq/cpufreq-cpu0.c                     | 251 -------------
 drivers/cpufreq/cpufreq-generic.c                  | 394 +++++++++++++++++++++
 drivers/cpufreq/exynos4x12-cpufreq.c               |   2 +-
 drivers/cpufreq/highbank-cpufreq.c                 |   6 +-
 drivers/of/base.c                                  |  29 ++
 include/linux/clk.h                                |   6 +
 include/linux/cpufreq.h                            |   3 +
 include/linux/of.h                                 |  10 +
 20 files changed, 642 insertions(+), 331 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
 create mode 100644 Documentation/devicetree/bindings/cpufreq/cpufreq-generic.txt
 delete mode 100644 drivers/cpufreq/cpufreq-cpu0.c
 create mode 100644 drivers/cpufreq/cpufreq-generic.c

-- 
2.0.0.rc2

