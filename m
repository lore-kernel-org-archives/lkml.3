Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbaGDJzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:55:37 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:37962 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbaGDJze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:55:34 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v6 00/23] Add Maxim 77802 PMIC support
Date: Fri,  4 Jul 2014 11:54:59 +0200
Message-Id: <1404467722-26687-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX77802 is a PMIC that contains 10 high efficiency Buck regulators,
32 Low-dropout (LDO) regulators, two 32kHz buffered clock outputs,
a Real-Time-Clock (RTC) and a I2C interface to program the individual
regulators, clocks and the RTC.

This series are based on drivers added by Simon Glass to the Chrome OS
kernel and adds support for the Maxim 77802 Power Management IC, their
regulators, clocks, RTC and I2C interface and depend on patch:

"[PATCH v3] ARM: dts: Add cros_ec to exynos5420-peach-pit and exynos5800-peach-pi"
https://patchwork.kernel.org/patch/4411351/

which adds tps65090 support to Peach boards since regulators from this
PMIC supply power to a set of MAX77802 regulators.

This is a sixth version of the patch-set that addresses several issues
pointed out in v5. Individual changes are added on each patch change log.

The biggest change is that now the MAX77686 mfd driver is extended to
also support the MAX77802 PMIC instead of having a separate mfd driver
as was suggested by Lee Jones.

Patches 1-16 are cleanups and improvements to the MAX77686 PMIC driver
as a preparation to also support the MAX77802 PMIC. Patch 17 adds support
for MAX77802 to the MAX77686 mfd driver and Patch 18 adds the DT binding
doc for this PMIC. Patch 19 adds support for the regulators in the PMIC,
Patch 20 adds support for the clocks in the PMIC and Patch 21 adds its DT
binding. Patch 22 adds support for the Real-Time-Clock found in the PMIC
and Patch 23 adds the needed device nodes for the max77802 to the Exynos5
base Peach Pit and Pi boards device tree source files.

The patch-set has been tested on both Daisy/Snow (max77686) and Peach
Pit (max77802) Chromebooks and it's composed of the following patches:

Doug Anderson (1):
  rtc: max77686: Allow the max77686 rtc to wakeup the system

Javier Martinez Canillas (22):
  mfd: max77686: Convert to use regmap_irq
  mfd: max77686: Add power management support
  mfd: max77686: don't define dummy function if OF isn't enabled
  mfd: max77686: make platform data over-rule DT
  mfd: max77686: Return correct error when pdata isn't found
  mfd: max77686: Make error checking consistent
  mfd: max77686: Remove unneeded OOM error message
  mfd: max77686: Add Dynamic Voltage Scaling (DVS) support
  clk: max77686: Add DT include for MAX77686 PMIC clock
  clk: Add generic driver for Maxim PMIC clocks
  clk: max77686: Convert to the generic max clock driver
  clk: max77686: Improve Maxim 77686 PMIC clocks binding
  regmap: Add regmap_reg_copy function
  regulator: max77686: Setup DVS-related GPIOs on probe
  mfd: max77686: Add documentation for DVS bindings
  mfd: max77686: Add Maxim 77802 PMIC support
  mfd: max77802: Add DT binding documentation
  regulator: Add driver for Maxim 77802 PMIC regulators
  clk: Add driver for Maxim 77802 PMIC clocks
  clk: max77802: Add DT binding documentation
  rtc: Add driver for Maxim 77802 PMIC Real-Time-Clock
  ARM: dts: Add max77802 to exynos5420-peach-pit and exynos5800-peach-pi

 .../devicetree/bindings/clock/maxim,max77686.txt   |  16 +-
 .../devicetree/bindings/clock/maxim,max77802.txt   |  44 ++
 Documentation/devicetree/bindings/mfd/max77686.txt |  34 ++
 Documentation/devicetree/bindings/mfd/max77802.txt |  95 +++
 arch/arm/boot/dts/exynos5420-peach-pit.dts         | 382 ++++++++++++
 arch/arm/boot/dts/exynos5800-peach-pi.dts          | 382 ++++++++++++
 drivers/base/regmap/regmap.c                       |  34 ++
 drivers/clk/Kconfig                                |  11 +
 drivers/clk/Makefile                               |   2 +
 drivers/clk/clk-max-gen.c                          | 192 +++++++
 drivers/clk/clk-max-gen.h                          |  32 ++
 drivers/clk/clk-max77686.c                         | 183 +-----
 drivers/clk/clk-max77802.c                         |  98 ++++
 drivers/mfd/Kconfig                                |   1 +
 drivers/mfd/Makefile                               |   2 +-
 drivers/mfd/max77686-irq.c                         | 319 -----------
 drivers/mfd/max77686.c                             | 435 ++++++++++++--
 drivers/regulator/Kconfig                          |   9 +
 drivers/regulator/Makefile                         |   1 +
 drivers/regulator/max77686.c                       |  34 ++
 drivers/regulator/max77802.c                       | 609 ++++++++++++++++++++
 drivers/rtc/Kconfig                                |  10 +
 drivers/rtc/Makefile                               |   1 +
 drivers/rtc/rtc-max77686.c                         |  55 +-
 drivers/rtc/rtc-max77802.c                         | 637 +++++++++++++++++++++
 include/dt-bindings/clock/maxim,max77686.h         |  23 +
 include/dt-bindings/clock/maxim,max77802.h         |  22 +
 include/linux/mfd/max77686-private.h               | 237 +++++++-
 include/linux/mfd/max77686.h                       |  78 ++-
 include/linux/regmap.h                             |   9 +
 30 files changed, 3414 insertions(+), 573 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/maxim,max77802.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/max77802.txt
 create mode 100644 drivers/clk/clk-max-gen.c
 create mode 100644 drivers/clk/clk-max-gen.h
 create mode 100644 drivers/clk/clk-max77802.c
 delete mode 100644 drivers/mfd/max77686-irq.c
 create mode 100644 drivers/regulator/max77802.c
 create mode 100644 drivers/rtc/rtc-max77802.c
 create mode 100644 include/dt-bindings/clock/maxim,max77686.h
 create mode 100644 include/dt-bindings/clock/maxim,max77802.h

-- 
2.0.0.rc2

