Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaF0H6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 03:58:24 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:62326 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbaF0H6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 03:58:22 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [RFC 0/5] Per-user clock constraints
Date: Fri, 27 Jun 2014 09:57:47 +0200
Message-Id: <1403855872-14749-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm retaking Rabin's patches [0] for splitting the clk API in two: one API for
clk consumers and another for providers. The consumer API uses a clk structure
that just keeps track of the consumer and has a reference to the actual
clk_core struct, which is used internally.

I have kept a patch from Rabin that aims to aid in debugging nested
enable/disable calls, though my personal aim is to allow more than one consumer
to influence the final, effective rate. For now this is limited to setting
floor and ceiling constraints.

For those functions in the consumer clk API that were called from providers, I
have added variants to clk-provider.h that are the same only that accept a
clk_core instead. In this first version of the patchset, these functions are
prepended with two underscores and have the _internal suffix at the end. Mike
has stated his preference of not prefixing with underscores any public API and
I agree with him, but we still need a way to distinguish e.g. clk_set_parent()
in the provider API from that in the consumer API (and from the lock-less
variant in clk-provider.h!).

Something else I have inconclusively wondered about are the clk_register_*()
functions, that are defined as part of the provider API but that are called
everywhere in arch/ and its returned clk is passed to all kinds of consumer
API.

I'm afraid this is still very preliminar, and the only platform that I have
checked that builds is Tegra. There will be a fair amount of changes needed in
arch/, but that depends on the outcome of this discussion.

[0] http://thread.gmane.org/gmane.linux.kernel/1402006

Thanks,

Tomeu

Rabin Vincent (2):
  clk: use struct clk only for external API
  clk: per-user clock accounting for debug

Tomeu Vizoso (3):
  clk: Add temporary mapping to the existing API
  clk: Move all drivers to use internal API
  clk: Add floor and ceiling constraints to clock rates

 drivers/clk/at91/clk-main.c               |  24 +-
 drivers/clk/at91/clk-master.c             |   6 +-
 drivers/clk/at91/clk-peripheral.c         |  12 +-
 drivers/clk/at91/clk-pll.c                |   6 +-
 drivers/clk/at91/clk-plldiv.c             |   6 +-
 drivers/clk/at91/clk-programmable.c       |  10 +-
 drivers/clk/at91/clk-slow.c               |  24 +-
 drivers/clk/at91/clk-smd.c                |   6 +-
 drivers/clk/at91/clk-system.c             |   6 +-
 drivers/clk/at91/clk-usb.c                |  18 +-
 drivers/clk/at91/clk-utmi.c               |   6 +-
 drivers/clk/bcm/clk-kona-setup.c          |   6 +-
 drivers/clk/bcm/clk-kona.c                |  12 +-
 drivers/clk/bcm/clk-kona.h                |   2 +-
 drivers/clk/berlin/berlin2-avpll.c        |   4 +-
 drivers/clk/berlin/berlin2-avpll.h        |   4 +-
 drivers/clk/berlin/berlin2-div.c          |   2 +-
 drivers/clk/berlin/berlin2-div.h          |   2 +-
 drivers/clk/berlin/berlin2-pll.c          |   2 +-
 drivers/clk/berlin/berlin2-pll.h          |   2 +-
 drivers/clk/berlin/bg2.c                  |  13 +-
 drivers/clk/berlin/bg2q.c                 |   9 +-
 drivers/clk/clk-axi-clkgen.c              |   2 +-
 drivers/clk/clk-axm5516.c                 |   4 +-
 drivers/clk/clk-bcm2835.c                 |   2 +-
 drivers/clk/clk-composite.c               |   6 +-
 drivers/clk/clk-devres.c                  |  14 +-
 drivers/clk/clk-divider.c                 |   8 +-
 drivers/clk/clk-efm32gg.c                 |   2 +-
 drivers/clk/clk-fixed-factor.c            |   6 +-
 drivers/clk/clk-fixed-rate.c              |   8 +-
 drivers/clk/clk-fractional-divider.c      |   4 +-
 drivers/clk/clk-gate.c                    |   4 +-
 drivers/clk/clk-highbank.c                |   8 +-
 drivers/clk/clk-ls1x.c                    |  16 +-
 drivers/clk/clk-max77686.c                |  10 +-
 drivers/clk/clk-moxart.c                  |   8 +-
 drivers/clk/clk-mux.c                     |   6 +-
 drivers/clk/clk-nomadik.c                 |  14 +-
 drivers/clk/clk-nspire.c                  |   4 +-
 drivers/clk/clk-ppc-corenet.c             |   8 +-
 drivers/clk/clk-s2mps11.c                 |   6 +-
 drivers/clk/clk-si5351.c                  |  17 +-
 drivers/clk/clk-si570.c                   |   4 +-
 drivers/clk/clk-twl6040.c                 |   2 +-
 drivers/clk/clk-u300.c                    |  12 +-
 drivers/clk/clk-vt8500.c                  |   4 +-
 drivers/clk/clk-wm831x.c                  |   6 +-
 drivers/clk/clk-xgene.c                   |  12 +-
 drivers/clk/clk.c                         | 666 ++++++++++++++++++++----------
 drivers/clk/clk.h                         |   9 +-
 drivers/clk/clkdev.c                      | 102 +++--
 drivers/clk/hisilicon/clk-hi3620.c        |   8 +-
 drivers/clk/hisilicon/clk.c               |  16 +-
 drivers/clk/hisilicon/clk.h               |   2 +-
 drivers/clk/hisilicon/clkgate-separated.c |   4 +-
 drivers/clk/keystone/gate.c               |   6 +-
 drivers/clk/keystone/pll.c                |  10 +-
 drivers/clk/mmp/clk-apbc.c                |   4 +-
 drivers/clk/mmp/clk-apmu.c                |   4 +-
 drivers/clk/mmp/clk-frac.c                |   4 +-
 drivers/clk/mmp/clk-mmp2.c                |  14 +-
 drivers/clk/mmp/clk-pxa168.c              |  12 +-
 drivers/clk/mmp/clk-pxa910.c              |  12 +-
 drivers/clk/mmp/clk.h                     |   8 +-
 drivers/clk/mvebu/clk-corediv.c           |   4 +-
 drivers/clk/mvebu/clk-cpu.c               |   8 +-
 drivers/clk/mvebu/common.c                |  14 +-
 drivers/clk/mxs/clk-div.c                 |   4 +-
 drivers/clk/mxs/clk-frac.c                |   4 +-
 drivers/clk/mxs/clk-imx23.c               |   4 +-
 drivers/clk/mxs/clk-imx28.c               |   4 +-
 drivers/clk/mxs/clk-pll.c                 |   4 +-
 drivers/clk/mxs/clk-ref.c                 |   4 +-
 drivers/clk/mxs/clk-ssp.c                 |   2 +-
 drivers/clk/mxs/clk.h                     |  16 +-
 drivers/clk/qcom/clk-rcg.c                |   6 +-
 drivers/clk/qcom/clk-rcg2.c               |  14 +-
 drivers/clk/qcom/clk-regmap.c             |   2 +-
 drivers/clk/qcom/clk-regmap.h             |   2 +-
 drivers/clk/qcom/common.c                 |   6 +-
 drivers/clk/qcom/gcc-msm8660.c            |   2 +-
 drivers/clk/qcom/gcc-msm8960.c            |   2 +-
 drivers/clk/qcom/gcc-msm8974.c            |   2 +-
 drivers/clk/qcom/mmcc-msm8960.c           |  11 +-
 drivers/clk/rockchip/clk-rockchip.c       |   2 +-
 drivers/clk/samsung/clk-exynos-audss.c    |  16 +-
 drivers/clk/samsung/clk-exynos4.c         |   6 +-
 drivers/clk/samsung/clk-pll.c             |   6 +-
 drivers/clk/samsung/clk-pll.h             |   2 +-
 drivers/clk/samsung/clk-s3c2410-dclk.c    |  10 +-
 drivers/clk/samsung/clk.c                 |  22 +-
 drivers/clk/samsung/clk.h                 |   2 +-
 drivers/clk/shmobile/clk-div6.c           |   2 +-
 drivers/clk/shmobile/clk-emev2.c          |   4 +-
 drivers/clk/shmobile/clk-mstp.c           |   6 +-
 drivers/clk/shmobile/clk-r8a7740.c        |   6 +-
 drivers/clk/shmobile/clk-r8a7779.c        |   6 +-
 drivers/clk/shmobile/clk-rcar-gen2.c      |  10 +-
 drivers/clk/shmobile/clk-rz.c             |   6 +-
 drivers/clk/sirf/clk-atlas6.c             |   2 +-
 drivers/clk/sirf/clk-common.c             |  30 +-
 drivers/clk/sirf/clk-prima2.c             |   2 +-
 drivers/clk/socfpga/clk-gate.c            |   2 +-
 drivers/clk/socfpga/clk-periph.c          |   2 +-
 drivers/clk/socfpga/clk-pll.c             |   4 +-
 drivers/clk/spear/clk-aux-synth.c         |   8 +-
 drivers/clk/spear/clk-frac-synth.c        |   4 +-
 drivers/clk/spear/clk-gpt-synth.c         |   4 +-
 drivers/clk/spear/clk-vco-pll.c           |   8 +-
 drivers/clk/spear/clk.h                   |  14 +-
 drivers/clk/spear/spear1310_clock.c       |   2 +-
 drivers/clk/spear/spear1340_clock.c       |   2 +-
 drivers/clk/spear/spear3xx_clock.c        |   8 +-
 drivers/clk/spear/spear6xx_clock.c        |   2 +-
 drivers/clk/st/clkgen-fsyn.c              |  22 +-
 drivers/clk/st/clkgen-mux.c               |  32 +-
 drivers/clk/st/clkgen-pll.c               |  34 +-
 drivers/clk/sunxi/clk-a10-hosc.c          |   2 +-
 drivers/clk/sunxi/clk-a20-gmac.c          |   2 +-
 drivers/clk/sunxi/clk-factors.c           |   4 +-
 drivers/clk/sunxi/clk-sun6i-apb0-gates.c  |   2 +-
 drivers/clk/sunxi/clk-sun6i-apb0.c        |   2 +-
 drivers/clk/sunxi/clk-sun6i-ar100.c       |   6 +-
 drivers/clk/sunxi/clk-sunxi.c             |  18 +-
 drivers/clk/tegra/clk-audio-sync.c        |   4 +-
 drivers/clk/tegra/clk-divider.c           |   4 +-
 drivers/clk/tegra/clk-periph-gate.c       |   4 +-
 drivers/clk/tegra/clk-periph.c            |   8 +-
 drivers/clk/tegra/clk-pll-out.c           |   4 +-
 drivers/clk/tegra/clk-pll.c               |  40 +-
 drivers/clk/tegra/clk-super.c             |   4 +-
 drivers/clk/tegra/clk-tegra-audio.c       |   4 +-
 drivers/clk/tegra/clk-tegra-fixed.c       |   8 +-
 drivers/clk/tegra/clk-tegra-periph.c      |  12 +-
 drivers/clk/tegra/clk-tegra-pmc.c         |   4 +-
 drivers/clk/tegra/clk-tegra-super-gen4.c  |   8 +-
 drivers/clk/tegra/clk-tegra114.c          |  10 +-
 drivers/clk/tegra/clk-tegra124.c          |   6 +-
 drivers/clk/tegra/clk-tegra20.c           |  12 +-
 drivers/clk/tegra/clk-tegra30.c           |   8 +-
 drivers/clk/tegra/clk.c                   |  24 +-
 drivers/clk/tegra/clk.h                   |  38 +-
 drivers/clk/ti/apll.c                     |   8 +-
 drivers/clk/ti/clk-2xxx.c                 |   8 +-
 drivers/clk/ti/clk-33xx.c                 |  18 +-
 drivers/clk/ti/clk-3xxx.c                 |   8 +-
 drivers/clk/ti/clk-43xx.c                 |   8 +-
 drivers/clk/ti/clk-44xx.c                 |  16 +-
 drivers/clk/ti/clk-54xx.c                 |  25 +-
 drivers/clk/ti/clk-7xx.c                  |  16 +-
 drivers/clk/ti/clk-dra7-atl.c             |   6 +-
 drivers/clk/ti/clk.c                      |   2 +-
 drivers/clk/ti/clockdomain.c              |   4 +-
 drivers/clk/ti/composite.c                |   2 +-
 drivers/clk/ti/divider.c                  |   6 +-
 drivers/clk/ti/dpll.c                     |   8 +-
 drivers/clk/ti/fixed-factor.c             |   2 +-
 drivers/clk/ti/gate.c                     |   2 +-
 drivers/clk/ti/interface.c                |   2 +-
 drivers/clk/ti/mux.c                      |   6 +-
 drivers/clk/ux500/abx500-clk.c            |   2 +-
 drivers/clk/ux500/clk-prcc.c              |   8 +-
 drivers/clk/ux500/clk-prcmu.c             |  16 +-
 drivers/clk/ux500/clk-sysctrl.c           |  10 +-
 drivers/clk/ux500/clk.h                   |  22 +-
 drivers/clk/ux500/u8500_clk.c             |   2 +-
 drivers/clk/ux500/u8500_of_clk.c          |  12 +-
 drivers/clk/ux500/u8540_clk.c             |   2 +-
 drivers/clk/versatile/clk-icst.c          |   4 +-
 drivers/clk/versatile/clk-icst.h          |   2 +-
 drivers/clk/versatile/clk-impd1.c         |  18 +-
 drivers/clk/versatile/clk-integrator.c    |   2 +-
 drivers/clk/versatile/clk-realview.c      |   2 +-
 drivers/clk/versatile/clk-sp810.c         |  30 +-
 drivers/clk/versatile/clk-vexpress-osc.c  |   2 +-
 drivers/clk/versatile/clk-vexpress.c      |   6 +-
 drivers/clk/x86/clk-lpt.c                 |   2 +-
 drivers/clk/zynq/clkc.c                   |  22 +-
 drivers/clk/zynq/pll.c                    |   4 +-
 include/linux/clk-private.h               |  43 +-
 include/linux/clk-provider.h              | 110 ++---
 include/linux/clk.h                       |  39 +-
 include/linux/clk/ti.h                    |  10 +-
 include/linux/clk/zynq.h                  |   3 +-
 include/linux/clkdev.h                    |  24 +-
 include/linux/platform_data/si5351.h      |   4 +-
 187 files changed, 1399 insertions(+), 1050 deletions(-)

-- 
1.9.3

