Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964915AbaESRg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:36:59 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:36015 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964853AbaESRgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:36:55 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/7] ARM: berlin: add pinctrl support
Date: Mon, 19 May 2014 19:36:28 +0200
Message-Id: <1400520995-27365-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

as mentioned earlier, I was reworking Berlin clock drivers and its DT
node representation on Mike's request [1]. I just posted a new patch set
using a single chip control register node [2] instead of chopping it into
tiny pieces inspired by Linux subsystem drivers. I completely forgot about
the already Acked pinctrl driver that you took in a few days ago.

I know it is my fault, but can you please drop the Berlin pinctrl patches
and reconsider taking the reworked driver instead? Besides the pinctrl
binding that is now part of the system and chip control node, there is no
functional change in the driver - except we use a regmap instead of
exclusively requesting the pinctrl register resource.

As there currently is no other driver for registering the regmap on Berlin,
I used the SoC-specific pinctrl probe for now. Later we are planing to move
it to a more suitable place. The changes I made with respect to Antoine's
original driver are noted in the individual patches.

We also dropped the "marvell," prefix from the pinmux-related properties
and plan to provide helpers for the pinctrl core next cycle.

If you are fine with the new binding, please drop the patches taken for
Berlin and pick up patches 1-4 of this patch set and I'll take 5-7 in
berlin branch.

Sorry for the inconvenience, but staring at the chip control registers
for days must have also removed my brain.

Sebastian

[1] https://lkml.kernel.org/r/20140515044106.19795.57249@quantum
[2] https://lkml.kernel.org/r/1400517811-24668-1-git-send-email-sebastian.hesselbarth@gmail.com

* Original v3 cover letter

This series adds support for the Marvell Berlin pin-controller, allowing
to configure the pin muxing from the device tree.

The Berlin pin-controller support is divided into 3 drivers, each
driving one Berlin SoC. These drivers use a Berlin common part.

This series applies on top of patches introducing the Marvell Berlin
BG2Q you can find on Sebastian's berlin/for-next branch[1] and the patch
allowing not to define the get_group_pins() function[2].

Tested on the Berlin BG2Q.

[1] https://github.com/shesselba/linux-berlin/commits/berlin/for-next
[2] https://patchwork.kernel.org/patch/3964491/

Changes since v2:
        - added the uart2 pin muxing node for BG2
        - cosmetic fixes

Changes since v1:
        - moved the driver to a specific berlin/ directory
        - divided the pin-controller driver into three (one per SoC) and
          reworked the driver dependencies accordingly
        - reworked the device tree bindings
        - removed the reg-names and reworked the driver to allow
          splitting the two pin-controllers into two separate nodes in
          the device tree
        - updated the documentation
        - removed unnecessary checks
        - added support to mux multiple groups with the same function
        - added BG2, BG2 and BG2CD function definitions

Antoine Tenart (7):
  pinctrl: berlin: add the core pinctrl driver for Marvell Berlin SoCs
  pinctrl: berlin: add the BG2Q pinctrl driver
  pinctrl: berlin: add the BG2 pinctrl driver
  pinctrl: berlin: add the BG2CD pinctrl driver
  ARM: berlin: add the pinctrl dependency for the Marvell Berlin SoCs
  dt-binding: ARM: add pinctrl binding docs for Marvell Berlin2 SoCs
  ARM: dts: berlin: add the pinctrl node and muxing setup for uarts

 .../devicetree/bindings/arm/marvell,berlin.txt     |  54 +++
 arch/arm/boot/dts/berlin2.dtsi                     |  26 ++
 arch/arm/boot/dts/berlin2cd.dtsi                   |  12 +
 arch/arm/boot/dts/berlin2q.dtsi                    |  19 +
 arch/arm/mach-berlin/Kconfig                       |   4 +
 drivers/pinctrl/Kconfig                            |   1 +
 drivers/pinctrl/Makefile                           |   1 +
 drivers/pinctrl/berlin/Kconfig                     |  20 +
 drivers/pinctrl/berlin/Makefile                    |   4 +
 drivers/pinctrl/berlin/berlin-bg2.c                | 274 +++++++++++++
 drivers/pinctrl/berlin/berlin-bg2cd.c              | 217 ++++++++++
 drivers/pinctrl/berlin/berlin-bg2q.c               | 436 +++++++++++++++++++++
 drivers/pinctrl/berlin/berlin.c                    | 348 ++++++++++++++++
 drivers/pinctrl/berlin/berlin.h                    |  61 +++
 14 files changed, 1477 insertions(+)
 create mode 100644 drivers/pinctrl/berlin/Kconfig
 create mode 100644 drivers/pinctrl/berlin/Makefile
 create mode 100644 drivers/pinctrl/berlin/berlin-bg2.c
 create mode 100644 drivers/pinctrl/berlin/berlin-bg2cd.c
 create mode 100644 drivers/pinctrl/berlin/berlin-bg2q.c
 create mode 100644 drivers/pinctrl/berlin/berlin.c
 create mode 100644 drivers/pinctrl/berlin/berlin.h

---
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: zmxu@marvell.com
Cc: jszhang@marvell.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.9.1

