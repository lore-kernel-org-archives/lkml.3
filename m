Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455AbaFQPAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:00:17 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:41372 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932999AbaFQOxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:53:25 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: [PATCH v2 00/20] ARM: sunxi: Introduce Allwinner A23 (sun8i) support
Date: Tue, 17 Jun 2014 22:52:37 +0800
Message-Id: <1403016777-15121-1-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This is v2 of the patch series that introduces basic kernel support for
Allwinner's A23 SoC, which we will call the sun8i platform. This includes
basic clocks, timers, interrupts, pinctrl, and UARTs.

The series can also be found here:

    https://github.com/wens/linux/tree/sunxi-a23-v2


The A23 is a mix of Allwinner's previous A20 (sun7i) and A31 (sun6i)
SoC's, but also a step forward. Most of the IP blocks are the same as
in the A31, with some features stripped out. However it has a Mali GPU,
Instead of a PowerVR.

The patches are a result of comparing the current working sun6i platform
with the A23 user manual, and various kernel and u-boot sources for A23
and A31 from Allwinner.

The series is based on v3.16-rc1, with linux-pinctrl/devel merged in for
Maxime's pinctrl external interrupts patches.

The first 12 patches are fixes, which will also be used by sun8i.
Hopefully these won't have any issues so we can get them in and fix
up some stuff queued up for 3.16.

Patch 1 adds optional support for reset controls to 8250_dw, which is
used on sun6i. The reset controls must be de-asserted for the UART to
function.

Patch 2 registers the sunxi clock gates with clkdev, so the "protect
important clock" code will work with them.

Patch 3 moves "ahb_sdram" clock protection into the protected clocks
list on sun4i, sun5i, and sun7i.

Patch 4 fixes gate indexing for sun6i PRCM APB0 gates introduced during
this cycle. The index mapping was incorrect when "clock-indicies" was
used and there were gaps between the used gates.

Patches 5~7 correct clock factor and clock rate calculations for PLL1
and PLL6 on sun6i, which have a multiplier factor starting from 1,
instead of 0 in previous SoC's.

Patch 8 renames PLL6 on sun6i to PLL6x2, to match the rate calculation
fixes in the previous patch. This patch also adds a fixed-factor clock
for PLL6, which is PLL6x2 divided by 2.

Patch 9 adds a clock driver for sun6i/sun8i MBUS clock. This clock must
be protected on sun8i or the system will hang. This series does not add
this clock to the sun6i DT.

Patch 10 adds divider table support to sunxi divider clocks. This is
used to support the AXI clock on sun8i.

The remaining patches add new support for A23 related modules.

Patch 11 adds support for the basic clock modules found on the A23.

Patches 12 and 13 add support for the PRCM clocks found on the A23,
notably the APB0 clock, which has a different divider table.

Patches 14 and 15 add the pin sets for the A23 PIO and A23 R_PIO
blocks, respectively.

Patch 16 adds A23 PRCM support to the sun6i-prcm mfd driver.
The A23 PRCM uses a slightly different subdevice list.

Patch 17 add machine support for the A23.

Patch 18 adds a Kconfig option to use R_UART as early console.

Patch 19 adds the DTSI for A23 (sun8i).

Patch 20 adds the DT for the Ippo-q8h (v5) tablet.
This tablet is one of the earliest available A23 devices.
So far we have seen 2 revisions of the mainboard inside the tablet.
The version I have is a v5, which has an unsupported SDIO WiFi chip.
The other known version uses a RTL8188 USB WiFi chip.


Greg, could you pick up the first patch? This patch is independent of
the rest. It was mostly useful to get the second UART on my tablet
working.

Emilio, Mike, patches 2~8 are fixes for existing clock drivers, 9~13
are new stuff for the A23. Please have a look.

Linus, the pinctrl patches (14 and 15) should go through your tree?

Lee, could you take patch 16, the sun6i-prcm mfd patch?

Maxime, I guess the remaining patches are for you.


Changes since v1:

  - Rebased on to v3.16-rc1 with Maxime's pinctrl external interrupt
    patch series

  - Move devm_get_reset_control to 8250_dw main probe function and
    use IF_ERR to check return values (patch 1)

  - Move incorrectly squashed fixups from patch
      clk: sunxi: move "ahb_sdram" to protected clock list (patch 3)
    to patch
      clk: sunxi: register clock gates with clkdev (patch 2)

  - Add "clk: sunxi: Fix rate_recalc for sun6i PLL1" (patch 6)
    (sun6i-a31-pll1 is used to support PLL5 on sun8i)

  - Drop "clk: sunxi: Implement A31 PLL6 as a divs clock for 2x output"
    and related DT patches;
    use fixed-factor clock for PLL6 normal output, and pll6x2 as name of
    the current pll6 clock. (patch 8)

  - drop patches for PLL6 pre-divider for AHB1
      clk: sunxi: Add support for PLL6 pre-divider on AHB1 clock
      ARM: sun6i: DT: Add PLL6 pre-divider clock for AHB1 mux input

  - Add support for sun6i MBUS clocks (patch 9), which is sourced from
    PLL6 on sun8i by default and must be protected.

  - Add support for table based divider clocks (patch 10)

  - Add separate protected clock list for sun8i, and drop
      clk: sunxi: add "pll6" to sun6i protected clock list (patch 11)

  - Add table based sun8i-a23-axi divider clock (patch 11)

  - Add A23 compatible for sun6i-a31-apb0-gates-clk (patch 13)

  - Change sun8i CSI pin comments D8/D9 to SDA/SCK (patch 14)

  - Document "allwinner,sun8i-a23-r-pinctrl" in
      pinctrl: sunxi: Add A23 R_PIO controller support (patch 15)

  - Fixed depends on for pinctrl drivers (patches 14/15)

  - Add external interrupt support to pinctrl drivers patches 14/15)

  - Change depends on for DEBUG_SUNXI_R_UART (patch 18)

  - Dropped SMP support. I will try to work out PSCI support in u-boot

  - Sort clocks by address (patch 19)

  - Add PLL5 and MBUS clocks to A23 DTSI (patch 19)

  - Added memory node to sun8i DTSI (patch 19)

  - Added i2c2 to sun8i DTSI and DTS (patch 19)

There are a lot of changes. Hopefully I didn't miss any.

Thanks
ChenYu


Chen-Yu Tsai (20):
  serial: 8250_dw: Add optional reset control support
  clk: sunxi: register clock gates with clkdev
  clk: sunxi: move "ahb_sdram" to protected clock list
  clk: sunxi: Fix gate indexing for sun6i-a31-apb0-gates
  clk: sunxi: Support factor clocks with N multiplier factor starting
    from 1
  clk: sunxi: Fix rate_recalc for sun6i PLL1
  clk: sunxi: Fix PLL6 calculation on sun6i
  ARM: sun6i: DT: Rename PLL6 to PLL6x2 and add fixed-factor-clock for
    PLL6
  clk: sunxi: Add sun6i MBUS clock support
  clk: sunxi: Add support for table-based divider clocks
  clk: sunxi: Add A23 clocks support
  clk: sunxi: Add A23 APB0 support to sun6i-a31-apb0-clk
  clk: sunxi: Add A23 specific compatible to sun6i-a31-apb0-gates-clk
  pinctrl: sunxi: Add A23 PIO controller support
  pinctrl: sunxi: Add A23 R_PIO controller support
  mfd: sun6i-prcm: Add support for Allwinner A23 PRCM
  ARM: sunxi: Introduce Allwinner A23 support
  ARM: sunxi: Add earlyprintk support using R_UART (sun6i/sun8i)
  ARM: sunxi: Add Allwinner A23 dtsi
  ARM: sun8i: dt: Add Ippo-q8h v5 support

 Documentation/devicetree/bindings/clock/sunxi.txt  |   8 +
 .../devicetree/bindings/mfd/sun6i-prcm.txt         |   2 +-
 .../bindings/pinctrl/allwinner,sunxi-pinctrl.txt   |   2 +
 .../bindings/serial/snps-dw-apb-uart.txt           |   1 +
 arch/arm/Kconfig.debug                             |  10 +
 arch/arm/boot/dts/Makefile                         |   2 +
 arch/arm/boot/dts/sun6i-a31.dtsi                   |  11 +-
 arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts        |  57 ++
 arch/arm/boot/dts/sun8i-a23.dtsi                   | 536 +++++++++++++++++++
 arch/arm/mach-sunxi/Kconfig                        |   8 +
 arch/arm/mach-sunxi/sunxi.c                        |  10 +
 drivers/clk/sunxi/clk-factors.c                    |   5 +-
 drivers/clk/sunxi/clk-factors.h                    |   1 +
 drivers/clk/sunxi/clk-sun6i-apb0-gates.c           |   7 +-
 drivers/clk/sunxi/clk-sun6i-apb0.c                 |  28 +-
 drivers/clk/sunxi/clk-sunxi.c                      | 195 ++++++-
 drivers/mfd/sun6i-prcm.c                           |  30 ++
 drivers/pinctrl/sunxi/Kconfig                      |   9 +
 drivers/pinctrl/sunxi/Makefile                     |   2 +
 drivers/pinctrl/sunxi/pinctrl-sun8i-a23-r.c        | 142 +++++
 drivers/pinctrl/sunxi/pinctrl-sun8i-a23.c          | 593 +++++++++++++++++++++
 drivers/tty/serial/8250/8250_dw.c                  |   9 +
 22 files changed, 1638 insertions(+), 30 deletions(-)
 create mode 100644 arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts
 create mode 100644 arch/arm/boot/dts/sun8i-a23.dtsi
 create mode 100644 drivers/pinctrl/sunxi/pinctrl-sun8i-a23-r.c
 create mode 100644 drivers/pinctrl/sunxi/pinctrl-sun8i-a23.c

-- 
2.0.0

