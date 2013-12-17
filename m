Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab3LQTiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:38:06 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:43029 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab3LQTiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:38:03 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Daniel Mack <zonque@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH v3 00/21] ARM: support for ICP DAS LP-8x4x (with dts)
Date: Tue, 17 Dec 2013 23:37:30 +0400
Message-Id: <1387309071-22382-1-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
References: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two review comments are not finally settled:

1. Use of new DMA
My  best guess is to split the patch in two, so that Daniel could easily
revert the workaround, once a solution is ready.

2. Device tree representation
I've put extbus into platform include file, since the bus is platform-
specific, not board-specific.

Frame support is now close to 95%, pluggable module support is
at around 20%. Most modules should be possible to handele by already
working get_DI/DO/AO set_DO/AO functions. I am not including support,
since I didn't actually tested the hardware. The same about RS232/485
pluggable port.

ICP DAS calls LP-8x4x 'programmable automation controller'. It is
an industrial computer based on PXA270 SoC. They ship it with a 2.6.19
kernel and proprietary kernel module and userspace library to access
its industrial IO.

This patch allows to boot the device with a modern kernel with device
tree. It adds support for:
* MMC card interface on PXA270
* USB 1.1 port on PXA270
* 2 NOR flash devices
* 2 onboard ethernet Davicom DM9000 devices
* 3 serial UART ports on PXA270
* front panel red LED
* 64bit 1-wire system ID chip
* 16 kiB EEPROM (reading)

Support for these devices will be added in separate patches, since
they are not currently supported by the kernel:
* DS1302 RTC
* 512kiB SRAM
* FPGA irq chip
* 3 built-in 16550A serial UART ports
* industrial IO parallel bus
* 10 position rotary switch
* 8 pin DIP switch
* 16 kiB EEPROM (writing)
* serial interface for digital and analog industrial IO modules on
  parallel bus (all I-87... modules)
* digital and analog industrial IO modules for parallel bus:
  ** I-8024 4 port analog output
  ** I-8041 32 port digital output
  ** I-8042 16 port digital output/16 port digital input

Not supported for now:
* VGA interface on PXA270 for lack of dts binding
* the rest of parallel bus (I-8...) modules for lack of hardware
* GPIO reset for lack of relevance (watchdog reset is working)

NOTE: USB support requires U-Boot patch series which setups GPIO.

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
CC: Daniel Mack <zonque@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Haojian Zhuang <haojian.zhuang@gmail.com>

Sergei Ianovich (21):
  serial: rewrite pxa2xx-uart to use 8250_core
  ARM: dts: pxa2xx fix compatible strings
  ARM: dts: fix pxa27x-gpio interrupts
  ARM: dts: pxa3xx: move declaration to header
  ARM: dts: pxa27x: irq init using device tree
  ARM: dts: provide DMA config to pxamci on PXA27x
  ARM: dts: parse DMA config in pxamci
  ARM: pxa27x: device tree support ICP DAS LP-8x4x
  rtc: support DS1302 RTC on ICP DAS LP-8x4x
  mtd: support BB SRAM on ICP DAS LP-8x4x
  ARM: pxa: support ICP DAS LP-8x4x FPGA irq
  serial: support for 16550A serial ports on LP-8x4x
  misc: support for LP-8x4x custom parallel bus
  misc: support for LP-8x4x rotary switch
  misc: support for LP-8x4x DIP switch
  misc: support for writing to LP-8x4x EEPROM
  misc: support for serial slots in LP-8x4x
  misc: support for parallel slots in LP-8x4x
  misc: support for I-8041 in LP-8x4x
  misc: support for I-8042 in LP-8x4x
  misc: support for I-8024 in LP-8x4x

 .../bindings/interrupt-controller/irq-lp8x4x.txt   |  49 ++
 .../devicetree/bindings/misc/lp8x4x-bus.txt        |  34 +
 Documentation/devicetree/bindings/mmc/pxa-mmc.txt  |   5 +
 .../devicetree/bindings/rtc/rtc-ds1302.txt         |  14 +
 .../devicetree/bindings/serial/lp8x4x-serial.txt   |  35 +
 Documentation/misc-devices/lp8x4x_bus.txt          |  83 ++
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/pxa27x-lp8x4x.dts                | 224 +++++
 arch/arm/boot/dts/pxa27x.dtsi                      |  37 +
 arch/arm/boot/dts/pxa2xx.dtsi                      |   5 +-
 arch/arm/configs/am200epdkit_defconfig             |   3 +-
 arch/arm/configs/cm_x2xx_defconfig                 |   3 +-
 arch/arm/configs/cm_x300_defconfig                 |   3 +-
 arch/arm/configs/colibri_pxa270_defconfig          |   3 +-
 arch/arm/configs/colibri_pxa300_defconfig          |   3 +-
 arch/arm/configs/corgi_defconfig                   |   4 +-
 arch/arm/configs/em_x270_defconfig                 |   3 +-
 arch/arm/configs/ezx_defconfig                     |   3 +-
 arch/arm/configs/h5000_defconfig                   |   3 +-
 arch/arm/configs/imote2_defconfig                  |   3 +-
 arch/arm/configs/lp8x4x_defconfig                  | 172 ++++
 arch/arm/configs/lpd270_defconfig                  |   3 +-
 arch/arm/configs/lubbock_defconfig                 |   3 +-
 arch/arm/configs/mainstone_defconfig               |   3 +-
 arch/arm/configs/mmp2_defconfig                    |   3 +-
 arch/arm/configs/pcm027_defconfig                  |   3 +-
 arch/arm/configs/pxa168_defconfig                  |   3 +-
 arch/arm/configs/pxa255-idp_defconfig              |   3 +-
 arch/arm/configs/pxa3xx_defconfig                  |   3 +-
 arch/arm/configs/pxa910_defconfig                  |   3 +-
 arch/arm/configs/raumfeld_defconfig                |   3 +-
 arch/arm/configs/spitz_defconfig                   |   4 +-
 arch/arm/configs/trizeps4_defconfig                |   3 +-
 arch/arm/configs/viper_defconfig                   |   4 +-
 arch/arm/configs/xcep_defconfig                    |   3 +-
 arch/arm/mach-pxa/Kconfig                          |  15 +
 arch/arm/mach-pxa/Makefile                         |   1 +
 arch/arm/mach-pxa/include/mach/irqs.h              |   2 +
 arch/arm/mach-pxa/include/mach/pxa27x.h            |   1 +
 arch/arm/mach-pxa/pxa27x-dt.c                      |  64 ++
 arch/arm/mach-pxa/pxa27x.c                         |  10 +
 arch/arm/mach-pxa/pxa3xx.c                         |   2 -
 drivers/irqchip/Kconfig                            |   5 +
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-lp8x4x.c                       | 205 +++++
 drivers/misc/Kconfig                               |  13 +
 drivers/misc/Makefile                              |   1 +
 drivers/misc/lp8x4x_bus.c                          | 665 ++++++++++++++
 drivers/mmc/host/pxamci.c                          |  59 +-
 drivers/mtd/devices/Kconfig                        |  14 +
 drivers/mtd/devices/Makefile                       |   1 +
 drivers/mtd/devices/sram_lp8x4x.c                  | 227 +++++
 drivers/rtc/Kconfig                                |   2 +-
 drivers/rtc/rtc-ds1302.c                           | 100 ++-
 drivers/tty/serial/8250/8250_lp8x4x.c              | 162 ++++
 drivers/tty/serial/8250/8250_pxa.c                 | 178 ++++
 drivers/tty/serial/8250/Kconfig                    |  21 +
 drivers/tty/serial/8250/Makefile                   |   2 +
 drivers/tty/serial/Kconfig                         |  23 -
 drivers/tty/serial/Makefile                        |   1 -
 drivers/tty/serial/pxa.c                           | 971 ---------------------
 61 files changed, 2439 insertions(+), 1041 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/irq-lp8x4x.txt
 create mode 100644 Documentation/devicetree/bindings/misc/lp8x4x-bus.txt
 create mode 100644 Documentation/devicetree/bindings/rtc/rtc-ds1302.txt
 create mode 100644 Documentation/devicetree/bindings/serial/lp8x4x-serial.txt
 create mode 100644 Documentation/misc-devices/lp8x4x_bus.txt
 create mode 100644 arch/arm/boot/dts/pxa27x-lp8x4x.dts
 create mode 100644 arch/arm/configs/lp8x4x_defconfig
 create mode 100644 arch/arm/mach-pxa/pxa27x-dt.c
 create mode 100644 drivers/irqchip/irq-lp8x4x.c
 create mode 100644 drivers/misc/lp8x4x_bus.c
 create mode 100644 drivers/mtd/devices/sram_lp8x4x.c
 create mode 100644 drivers/tty/serial/8250/8250_lp8x4x.c
 create mode 100644 drivers/tty/serial/8250/8250_pxa.c
 delete mode 100644 drivers/tty/serial/pxa.c

-- 
1.8.4.2

