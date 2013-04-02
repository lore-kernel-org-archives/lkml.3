Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116Ab3DBEkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 00:40:51 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:59382 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab3DBEjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 00:39:10 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: linux.walleij@linaro.org
Cc: swarren@wwwdotorg.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-kernel@vger.kernel.org, Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCHv4 0/6] arm: vt8500: Add support for pinctrl/gpio module
Date: Tue,  2 Apr 2013 17:39:04 +1300
Message-Id: <1364877550-25921-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v4 changes:
Changed as requested by Stephen Warren:
Corrected the range checking in of_property_read_u32_index().
Fix configs[0] assignment in wmt_pctl_dt_node_to_map_pull().
Remove the kfree(maps) call, and use devm_kzalloc to simplify the fail path.
Drop the custom .of_xlate function and use the default of_gpio_simple_xlate.
Move the platform memory mapping from per-soc to common init.

v3 changes:
Rebased onto v3.9-rc4
Added the missing interrupt-controller info to the relevant dtsi files.
Removed the gpio-vt8500.txt binding along with the gpio driver.

Changes made as requested by Linux Walleij:
Removed the wm,pinmux property which has caused too much confusion, and left the
	open-coded version in arm/arch-vt8500/vt8500.c until a proper solution
	is sorted out.

Changes made as requested by Stephen Warren:
Defined an active-low flag for gpio since its useful and we will have a use-case
	for it with our LCD power-on/off.

v2 changes:
Rebased onto v3.9-rc2

Changes made as requested by Linus Walleij:
Moved the files into drivers/pinctrl/vt8500/ to keep them tidy.
Changed readl/writel to *_relaxed variants.
Comment indentation corrected and remove additional whitespace.
Changed wmt_pctl_find_group_by_pin() error code from -1 to -EINVAL.
Removed OF read indexed-u32 function to OF subsystem.
General code tidy up as requested.

Changes made as requested by Stephen Warren:
Add binding information for interrupt generation.
Move optional properties to correct location in document.


This patch series removes the existing GPIO driver and replaces it with
a combined pinctrl+gpio driver.

Patch 1 - Add an OF function to read the nth u32 value from a property
  listing multiple values.

Patch 2 - Increase the available GPIO space for the newly added gpios.
  Because there is no hardware documentation from Wondermedia we don't know
  how many GPIO's there actually are. New gpio pins have been located since
  the original GPIO driver was written, hence the increase.

Patch 3 - The main pinctrl/gpio driver and the data for the 5 supported SoCs.
  Each SoC is different, and therefore has its own data. This design was
  borrowed from the Tegra pinctrl driver. The pin numbering is based on a
  bank+pin encoding so that when other pin functions are found later on we can
  add them without having to renumber existing pins.

Patch 4 - Update the SoC dts(i) files to support the new pinctrl driver.

Patch 5 - Remove the existing GPIO driver nodes from the dtsi's.

Patch 6 - Remove the existing GPIO driver.

I suspect this series may need to be broken up since there are two arm-soc
patches, and 4 pinctrl/gpio patches.

Patch 1 is required for the new driver to function properly.
Patch 2 is independant, but required for the driver to function properly.
Patches 3-4 are pinctrl/gpio patches.
Patch 5-6 remove the old gpio code which is no longer required.


Patch 2 could go via arm-soc if necessary.

Regards
Tony Prisk

Tony Prisk (6):
  of: Add support for reading a u32 from a multi-value property.
  arm: vt8500: Increase available GPIOs on arch-vt8500
  pinctrl: gpio: vt8500: Add pincontrol driver for arch-vt8500
  arm: dts: vt8500: Update Wondermedia SoC dtsi files for pinctrl
    driver
  arm: vt8500: Remove gpio devicetree nodes
  gpio: vt8500: Remove arch-vt8500 gpio driver

 .../devicetree/bindings/gpio/gpio-vt8500.txt       |   24 -
 .../devicetree/bindings/pinctrl/pinctrl-vt8500.txt |   57 ++
 arch/arm/Kconfig                                   |    3 +-
 arch/arm/boot/dts/vt8500.dtsi                      |   10 +-
 arch/arm/boot/dts/wm8505.dtsi                      |   10 +-
 arch/arm/boot/dts/wm8650.dtsi                      |   10 +-
 arch/arm/boot/dts/wm8850.dtsi                      |   10 +-
 arch/arm/mach-vt8500/Kconfig                       |    1 +
 drivers/gpio/Kconfig                               |    6 -
 drivers/gpio/Makefile                              |    1 -
 drivers/gpio/gpio-vt8500.c                         |  355 -----------
 drivers/of/base.c                                  |   33 ++
 drivers/pinctrl/Kconfig                            |    1 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/vt8500/Kconfig                     |   52 ++
 drivers/pinctrl/vt8500/Makefile                    |    8 +
 drivers/pinctrl/vt8500/pinctrl-vt8500.c            |  501 ++++++++++++++++
 drivers/pinctrl/vt8500/pinctrl-wm8505.c            |  532 +++++++++++++++++
 drivers/pinctrl/vt8500/pinctrl-wm8650.c            |  370 ++++++++++++
 drivers/pinctrl/vt8500/pinctrl-wm8750.c            |  409 +++++++++++++
 drivers/pinctrl/vt8500/pinctrl-wm8850.c            |  388 ++++++++++++
 drivers/pinctrl/vt8500/pinctrl-wmt.c               |  620 ++++++++++++++++++++
 drivers/pinctrl/vt8500/pinctrl-wmt.h               |   79 +++
 include/linux/of.h                                 |    9 +
 24 files changed, 3087 insertions(+), 403 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/gpio/gpio-vt8500.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl-vt8500.txt
 delete mode 100644 drivers/gpio/gpio-vt8500.c
 create mode 100644 drivers/pinctrl/vt8500/Kconfig
 create mode 100644 drivers/pinctrl/vt8500/Makefile
 create mode 100644 drivers/pinctrl/vt8500/pinctrl-vt8500.c
 create mode 100644 drivers/pinctrl/vt8500/pinctrl-wm8505.c
 create mode 100644 drivers/pinctrl/vt8500/pinctrl-wm8650.c
 create mode 100644 drivers/pinctrl/vt8500/pinctrl-wm8750.c
 create mode 100644 drivers/pinctrl/vt8500/pinctrl-wm8850.c
 create mode 100644 drivers/pinctrl/vt8500/pinctrl-wmt.c
 create mode 100644 drivers/pinctrl/vt8500/pinctrl-wmt.h

-- 
1.7.9.5

