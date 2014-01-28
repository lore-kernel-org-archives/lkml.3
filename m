Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaA1B43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 20:56:29 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:34204 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbaA1B4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 20:56:15 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/21] pinctrl: mvebu: restructure and remove hardcoded addresses from Dove pinctrl
Date: Tue, 28 Jan 2014 01:39:12 +0100
Message-Id: <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is one required step for Dove to hop into mach-mvebu.
Until now, pinctrl-dove was hardcoding some registers that do not
directly belong to MPP core registers. This is not compatible with
what we want for mach-mvebu.

Unfortunately, the common pinctrl driver part has a design flaw,
that requires some restructuring. As Thomas pointed out, the redesign
taken in v1 [1] is not sufficient for possible future Orion5x SoC pinctrl.

The "common" part of the patch set therefore, overhawls MVEBU pinctrl
to remove any register mangling from the common pinctrl driver and
moves it into SoC specific drivers instead.

The "Dove" part of the patch set removes all hardcoded addresses
from pinctrl-dove by either requesting additional resources or a
syscon provided regmap for global config registers. As this changes
existing driver to DT binding relationship, all additional resources
are probed in a backward compatible way. If the corresponding resource
cannot be found, we derive it from the existing pinctrl resource and
warn about the old DTB firmware.

Patches 1 to 4 remain unchanged:

Patch 1 and 2 add or update binding documentation for dove, global
config syscon, and pinctrl-dove. The latter also documents missing reg
property requirement for other mvebu pinctrl nodes.

Patch 3 and 4 add the new pinctrl reg property values and global config
register syscon to exisiting dove.dtsi.

Patches 5-8 now prepare to fix the misdesign of common mvebu pinctrl
driver, that requested the resource instead of getting it from the SoC
specific driver stub:

Patch 5 temporarily adds passing the base address the common driver
and moves resource requests to the SoC specific drivers. Patch 6 adds
some useful mask/shift defines. Patches 7 and 8 allow to identify
mpp pin ranges by NULL mpp name instead of special get/set callbacks.

Patches 9-12 provide SoC specific callbacks for mpp ctrl registers
even if they match the standard layout. This then allows patches 13
and 14 to get rid of base addresses and the temporary address passing.

Patches 15-20 comprise the rebased hardcoded address removal for
Dove from v1. Patch 21 finally consolidates Dove pmu mpp definition
by exploiting auto-numbering of mpp names.

The patch set is still based on pre-v3.14-rc1 mainline.  It has been
boot tested on Dove and compile tested only for Kirkwood, Armada 370
and XP.

[1] https://lkml.org/lkml/2014/1/25/131

Sebastian Hesselbarth (21):
  devicetree: bindings: add missing Marvell Dove SoC documentation
  devicetree: bindings: update MVEBU pinctrl binding documentation
  ARM: dove: add additional pinctrl registers
  ARM: dove: add global-config register node
  pinctrl: mvebu: prepare to fix misdesigned resource allocation
  pinctrl: mvebu: add common mpp reg defines to mvebu pinctrl include
  pinctrl: mvebu: move generic group name generation
  pinctrl: mvebu: remove checks for mpp_get/set
  pinctrl: mvebu: dove: provide generic mpp callbacks
  pinctrl: mvebu: kirkwood: provide generic mpp callbacks
  pinctrl: mvebu: armada-370: provide generic mpp callbacks
  pinctrl: mvebu: armada-xp: provide generic mpp callbacks
  pinctrl: mvebu: remove unused macros and functions
  pinctrl: mvebu: remove base address from common driver
  pinctrl: mvebu: dove: request additional resources
  pinctrl: mvebu: dove: request syscon regmap for global registers
  pinctrl: mvebu: dove: use remapped mpp base registers
  pinctrl: mvebu: dove: use remapped mpp4 register
  pinctrl: mvebu: dove: use remapped pmu_mpp registers
  pinctrl: mvebu: dove: use global register regmap
  pinctrl: mvebu: dove: consolidate auto-numbered pmu mpp ranges

 .../devicetree/bindings/arm/marvell,dove.txt       |  22 ++
 .../pinctrl/marvell,armada-370-pinctrl.txt         |   1 +
 .../bindings/pinctrl/marvell,armada-xp-pinctrl.txt |   1 +
 .../bindings/pinctrl/marvell,dove-pinctrl.txt      |   1 +
 .../bindings/pinctrl/marvell,kirkwood-pinctrl.txt  |   1 +
 .../bindings/pinctrl/marvell,mvebu-pinctrl.txt     |   2 +-
 arch/arm/boot/dts/dove.dtsi                        |  10 +-
 drivers/pinctrl/mvebu/Kconfig                      |   1 +
 drivers/pinctrl/mvebu/pinctrl-armada-370.c         |  34 +-
 drivers/pinctrl/mvebu/pinctrl-armada-xp.c          |  38 ++-
 drivers/pinctrl/mvebu/pinctrl-dove.c               | 374 +++++++++++++--------
 drivers/pinctrl/mvebu/pinctrl-kirkwood.c           |  39 ++-
 drivers/pinctrl/mvebu/pinctrl-mvebu.c              |  94 +-----
 drivers/pinctrl/mvebu/pinctrl-mvebu.h              |  16 +-
 14 files changed, 388 insertions(+), 246 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/marvell,dove.txt

---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.8.5.2

