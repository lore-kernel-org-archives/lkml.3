Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab3FBXjk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 19:39:40 -0400
Received: from gloria.sntech.de ([95.129.55.99]:40435 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181Ab3FBXjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 19:39:32 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: arm: add basic support for Rockchip Cortex-A9 SoCs
Date: Mon, 3 Jun 2013 00:55:15 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306030055.15413.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare your eggs and tomatoes please, I got myself a second playground ;-) .

As the title implies this series adds basic support for Rockchip's Cortex-A9
SoCs, like the RK3066 used in many cheaper tablets.

On the periphal side it's very lightweight, as it seems someone from Rockchip
was shopping in the DesignWare store.

This makes the pinctrl driver the biggest hunk in the series, but to get some
bonus points I used the generic_irq implementation for the interrupt handling,
based on Thomas' irqdomain support series.

Supported periphals are, the timers, uarts and mmc controllers, so interested
parties will need a serial console for now.

Hopefully I didn't mess up to much :-)


Dependencies:
 - the irqdomain support for the generic_irq from Thomas Gleixner is required
   by the pinctrl driver
 - "mmc: dw_mmc: Add support DW SD/MMC driver on SOCFPGA" moves the
   SDMMC_CMD_USE_HOLD_REG constant into the common header, which is required
   on these Rockchip SoCs 

Heiko Stuebner (10):
  clocksource: dw_apb_timer_of: use the clocksource as sched clock if
    necessary
  clocksource: dw_apb_timer_of: add clock-handling
  clk: flag to use upper half of the register as change indicator
  clk: divider: add flag to limit possible dividers to even numbers
  mmc: dw_mmc-pltfm: remove static from dw_mci_pltfm_remove
  mmc: dw_mmc-pltfm: add Rockchip variant
  pinctrl: add pinctrl driver for Rockchip SoCs
  clk: add basic Rockchip rk3066a clock support
  arm: add debug uarts for rockchip rk29xx and rk3xxx series
  arm: add basic support for Rockchip RK3066a boards

 .../bindings/pinctrl/rockchip-pinctrl.txt          |  100 ++
 Documentation/devicetree/bindings/rtc/dw-apb.txt   |   19 +
 arch/arm/Kconfig                                   |    2 +
 arch/arm/Kconfig.debug                             |   34 +
 arch/arm/Makefile                                  |    1 +
 arch/arm/boot/dts/rk3066a-clocks.dtsi              |  459 +++++++
 arch/arm/boot/dts/rk3066a.dtsi                     |  359 ++++++
 arch/arm/include/debug/rockchip.S                  |   42 +
 arch/arm/mach-rockchip/Kconfig                     |   17 +
 arch/arm/mach-rockchip/Makefile                    |    1 +
 arch/arm/mach-rockchip/Makefile.boot               |    3 +
 arch/arm/mach-rockchip/rockchip.c                  |   54 +
 drivers/clk/Makefile                               |    1 +
 drivers/clk/clk-divider.c                          |   29 +-
 drivers/clk/clk-gate.c                             |   24 +-
 drivers/clk/clk-mux.c                              |   15 +-
 drivers/clk/rockchip/Makefile                      |    6 +
 drivers/clk/rockchip/clk-rockchip-pll.c            |  131 ++
 drivers/clk/rockchip/clk-rockchip-pll.h            |   19 +
 drivers/clk/rockchip/clk-rockchip.c                |  315 +++++
 drivers/clocksource/dw_apb_timer_of.c              |   52 +-
 drivers/mmc/host/dw_mmc-pltfm.c                    |   48 +-
 drivers/pinctrl/Kconfig                            |    6 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinctrl-rockchip.c                 | 1319 ++++++++++++++++++++
 include/dt-bindings/pinctrl/rockchip.h             |   37 +
 include/linux/clk-provider.h                       |   18 +
 include/linux/clk/rockchip.h                       |   21 +
 28 files changed, 3097 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/rockchip-pinctrl.txt
 create mode 100644 arch/arm/boot/dts/rk3066a-clocks.dtsi
 create mode 100644 arch/arm/boot/dts/rk3066a.dtsi
 create mode 100644 arch/arm/include/debug/rockchip.S
 create mode 100644 arch/arm/mach-rockchip/Kconfig
 create mode 100644 arch/arm/mach-rockchip/Makefile
 create mode 100644 arch/arm/mach-rockchip/Makefile.boot
 create mode 100644 arch/arm/mach-rockchip/rockchip.c
 create mode 100644 drivers/clk/rockchip/Makefile
 create mode 100644 drivers/clk/rockchip/clk-rockchip-pll.c
 create mode 100644 drivers/clk/rockchip/clk-rockchip-pll.h
 create mode 100644 drivers/clk/rockchip/clk-rockchip.c
 create mode 100644 drivers/pinctrl/pinctrl-rockchip.c
 create mode 100644 include/dt-bindings/pinctrl/rockchip.h
 create mode 100644 include/linux/clk/rockchip.h

-- 
1.7.2.3

