Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaEWI2C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:28:02 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:39580 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaEWI15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:27:57 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: [PATCH 00/21] ARM: sunxi: Introduce Allwinner A23 (sun8i) support
Date: Fri, 23 May 2014 15:51:03 +0800
Message-Id: <1400831485-28576-1-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This patch series introduces basic kernel support for Allwinner's A23
SoC, which we will call the sun8i platform. This includes basic clocks,
timers, interrupts, pinctrl, and UARTs.

The series can also be found here:

    https://github.com/wens/linux/tree/sunxi-a23


The A23 is a mix of Allwinner's previous A20 (sun7i) and A31 (sun6i)
SoC's, but also a step forward. Most of the IP blocks are the same as
in the A31, with some features stripped out. However it has a Mali GPU,
Instead of a PowerVR.

The patches below are a result of comparing the current working sun6i
platform with the A23 user manual, and various kernel and u-boot sources
for A23 and A31 from Allwinner.

The series is based on sunxi-next (6c90cef), with the following patches
applied:

    pinctrl: sunxi: Fix multiple registration issue
    pinctrl: sunxi: Fix recursive dependency
    pinctrl: sunxi: fix pin numbers passed to register offset helpers

The first 12 patches are fixes, which will also be used by sun8i.
Hopefully these won't have any issues so we can get them in and fix
up some stuff queued up for 3.16.

Patch 1 adds optional support for reset controls to 8250_dw, which is
used on sun6i. The reset controls must be de-asserted for the UART to
function.

Patch 2 registers the sunxi clock gates with clkdev, so the "protect
important clock" code will work with them.

Patch 3 adds "pll6" to the list of protected clocks on sun6i. Some
unknown module, likely MBUS, uses pll6. Until we have a driver for
it, we should make sure pll6 is not disabled.

Patch 4 moves "ahb_sdram" clock protection into the protected clocks
list on sun4i, sun5i, and sun7i.

Patch 5 fixes gate indexing for sun6i PRCM APB0 gates introduced during
this cycle. The index mapping was incorrect when "clock-indicies" was
used and there were gaps between the used gates.

Patches 6~7 correct clock factor and clock rate calculations for PLL6 on
sun6i, which has a multiplier factor starting from 1, instead of 0 in
previous SoC's.

Patch 8~9 changes the sun6i PLL6 driver to a multiple divider output
clock, like the ones found on previous SoCs. This yields the properly
halved clock rate for normal users of PLL6, but also supports the full
rate for future clock modules to use.

Patch 10 adds support for the pre-divider on the PLL6 input to the AHB1
clock.

Patches 11~12 are the DT changes matching patches 6~10.


The remaining patches add new support for A23 related modules.

Patch 13 adds support for the basic clock modules found on the A23.

Patch 14 adds support for the PRCM clocks found on the A23, notably
the APB0 clock, which has a different divider table.

Patches 15 and 16 add the pin sets for the A23 PIO and A23 R_PIO
blocks, respectively.

Patch 17 adds A23 PRCM support to the sun6i-prcm mfd driver.
The A23 PRCM uses a slightly different subdevice list.

Patch 18 and 20 add machine and SMP support for the A23.

Patch 19 adds a Kconfig option to use R_UART as early console.

Patch 21 adds the DTSI for A23 (sun8i).

Patch 22 adds the DT for the Ippo-q8h (v5) tablet.
This tablet is one of the earliest available A23 devices.
So far we have seen 2 revisions of the mainboard inside the tablet.
The version I have is a v5, which has an unsupported SDIO WiFi chip.
The other known version uses a RTL8188 USB WiFi chip.


Greg, could you pick up the first patch?

Emilio, Mike, patches 2~5 fixes clock code queued up in Emilio's tree,
hopefully we can apply these fixes together. Patches 6~10 fix the sun6i
PLL6 implementation already in the kernel. I hope we can get them in
as well.

Maxime, if Emilio takes the fixes, could you take the corresponding DT
(patches 11~12) changes?

I've ordered the new A31 Hummingbird board, but it hasn't shipped yet,
so I don't have any actual A31 hardware to test these fixes on. I am
relying on the A23 CCU and PRCM units being essentially the same as
the A31 ones. So if anyone has A31 hardware and also some spare time,
please test them on your hardware.


As for the A23 patches, it seems a bit late to include them in 3.16,
assuming no changes are required. There might be a conflict with
Maxime's restart code patches. Any suggestions?


Cheers
ChenYu


Chen-Yu Tsai (22):
  serial: 8250_dw: Add optional reset control support
  clk: sunxi: register clock gates with clkdev
  clk: sunxi: add "pll6" to sun6i protected clock list
  clk: sunxi: move "ahb_sdram" to protected clock list
  clk: sunxi: Fix gate indexing for sun6i-a31-apb0-gates
  clk: sunxi: Support factor clocks with N multiplier factor starting
    from 1
  clk: sunxi: Fix PLL6 calculation on sun6i
  clk: sunxi: Specify number of child clocks for divs clocks
  clk: sunxi: Implement A31 PLL6 as a divs clock for 2x output
  clk: sunxi: Add support for PLL6 pre-divider on AHB1 clock
  ARM: sun6i: DT: Add PLL6 multiple outputs
  ARM: sun6i: DT: Add PLL6 pre-divider clock for AHB1 mux input
  clk: sunxi: Add A23 clocks support
  clk: sunxi: Add A23 APB0 support to sun6i-a31-apb0-clk
  pinctrl: sunxi: Add A23 PIO controller support
  pinctrl: sunxi: Add A23 R_PIO controller support
  mfd: sun6i-prcm: Add support for Allwinner A23 PRCM
  ARM: sunxi: Introduce Allwinner A23 support
  ARM: sunxi: Add earlyprintk support using R_UART (sun6i/sun8i)
  ARM: sun8i: Add SMP support for the Allwinner A23
  ARM: sunxi: Add Allwinner A23 dtsi
  ARM: sun8i: dt: Add Ippo-q8h v5 support

 Documentation/devicetree/bindings/clock/sunxi.txt  |   7 +
 .../devicetree/bindings/mfd/sun6i-prcm.txt         |   2 +-
 .../bindings/pinctrl/allwinner,sunxi-pinctrl.txt   |   2 +
 .../bindings/serial/snps-dw-apb-uart.txt           |   1 +
 arch/arm/Kconfig.debug                             |  10 +
 arch/arm/boot/dts/Makefile                         |   2 +
 arch/arm/boot/dts/sun6i-a31.dtsi                   |  34 +-
 arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts        |  51 ++
 arch/arm/boot/dts/sun8i-a23.dtsi                   | 524 +++++++++++++++++++
 arch/arm/mach-sunxi/Kconfig                        |   8 +
 arch/arm/mach-sunxi/platsmp.c                      |  69 +++
 arch/arm/mach-sunxi/sunxi.c                        |  12 +
 drivers/clk/sunxi/clk-factors.c                    |   5 +-
 drivers/clk/sunxi/clk-factors.h                    |   1 +
 drivers/clk/sunxi/clk-sun6i-apb0-gates.c           |   6 +-
 drivers/clk/sunxi/clk-sun6i-apb0.c                 |  28 +-
 drivers/clk/sunxi/clk-sunxi.c                      | 127 ++++-
 drivers/mfd/sun6i-prcm.c                           |  30 ++
 drivers/pinctrl/sunxi/Kconfig                      |   8 +
 drivers/pinctrl/sunxi/Makefile                     |   2 +
 drivers/pinctrl/sunxi/pinctrl-sun8i-a23-r.c        | 129 +++++
 drivers/pinctrl/sunxi/pinctrl-sun8i-a23.c          | 562 +++++++++++++++++++++
 drivers/tty/serial/8250/8250_dw.c                  |  10 +
 23 files changed, 1598 insertions(+), 32 deletions(-)
 create mode 100644 arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts
 create mode 100644 arch/arm/boot/dts/sun8i-a23.dtsi
 create mode 100644 drivers/pinctrl/sunxi/pinctrl-sun8i-a23-r.c
 create mode 100644 drivers/pinctrl/sunxi/pinctrl-sun8i-a23.c

-- 
2.0.0.rc2

