Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbaK0LVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:21:16 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:21821 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbaK0LVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:21:13 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-0a-54770926a7a5
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 0/7] regulator: Parse ena_gpio in core, add GPIO to max77686
Date: Thu, 27 Nov 2014 12:20:46 +0100
Message-id: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJJMWRmVeSWpSXmKPExsVy+t/xK7pqnOUhBseviFhsnLGe1WLqwyds
	FvOPnGO1eP3C0KL/8Wtmi7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7vmsNmMeP8PiaLtUfusjvw
	eOycdZfdY9OqTjaPO9f2sHlsXlLv0bdlFaPH501yAWxRXDYpqTmZZalF+nYJXBmX+uawFOyW
	rbh88DtLA+MbsS5GTg4JAROJk8c3MUPYYhIX7q1n62Lk4hASWMoocattAZTTxyTxa89ZRpAq
	NgFjic3Ll7CB2CICKxgljt9QBLGZBdYzSTzY5tTFyMEhLOAv8eCzKEiYRUBVYsf1SWCtvALu
	Eps+HWCHWCYncfLYZNYJjNwLGBlWMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoQE15cdjIuP
	WR1iFOBgVOLhTXhcFiLEmlhWXJl7iFGCg1lJhJeLsTxEiDclsbIqtSg/vqg0J7X4ECMTB6dU
	A+O6YOn9FSUFsQ9XzLLbmhXseDn/l7sVh+t+9vBnF38sNk19pL77Js9Pj2ARyWO6b9WUGc+x
	3daxZ77CIBHMuyhNfIPO3q+qu8JmJplpm+9xe1uRn1M8c+HBP22vmG6ovX+/szRx5YPNZ2xt
	Ig+I7425oG+02ER1v9etfJekuS9PLg5r92NxlVdiKc5INNRiLipOBABLPSUeDAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


The patchset generalizes the ena_gpio bindings and finally adds GPIO
support to the max77686 driver. Adding GPIO to max77686 allows removal of
fixed regulators from DTS which duplicate the description of hardware.

Rationale behind adding ena-gpios to regulator core
===================================================
Drivers often add custom DTS properties for parsing the GPIO for
regulator enable control. Some of them don't have to do this in a
special custom way and would work with a generic approach (e.g. S5M8767,
S2MPS1x, MAX77686). As such drivers have to do this on their own,
multiple different bindings are added and each driver duplicates similar
code.

Add a generic binding so the regulator core will do this work for
drivers. This should offload some work from drivers and also limit
creation of new custom properties for GPIO control.

Changes since v3
================
1. Regulator cleanup patches were applied by Mark, drop them.
2. Re-work idea by adding generic ena-gpios binding.

Changes since v2
================
Re-work the board file support removal after Javier's comments: use
new DT style parsing. This imposes a lot of changes.
1. Add "of_compatible" for regulator drivers.
2. Provide backward compatibility if such "of_compatible" is not present.
   The driver will search for regulators node and use it as dev->of_node.
   Everything should be bisect-friendly.
3. New patches: 1, 2, 3, 5, 13 and 14.
4. Because of new style DT parsing it is much easier to put "gpio"
   properties in regulators top node (not in each regulator).
   This will be also new-gpio-lib friendly.

Changes since v1
================
1. Add patch: 1/8 "regulator: max77686: Consistently index opmode
   array by rdev id".
2. Remove patch "regulator: max77686: Make regulator_desc array
   const" (applied).
3. Re-work patches removing from regulators board file support (2/8
   and 3/8). Parse regulators with of_regulator_match() at once, remove
   num_regulators.
4. Patch 4/8: Add depends on OF to mfd/Kconfig. Add Javier's
   reviewed-by.
5. Patch 5/8: Add Javier's reviewed-by.
6. Patch 6/8: Add depends on GPIOLIB to regulator/Kconfig. Rename
   "external control" to "GPIO control" and "ext_control_gpios" to
   simpler "gpios".
   I tried to use new GPIO API but it ended with more problems
   https://lkml.org/lkml/2014/10/29/239


Patchset is rebased on next-20141114.

Best regards,
Krzysztof

Krzysztof Kozlowski (7):
  mfd: max77686/802: Remove support for board files
  regulator: dt-bindings: Document the ena-gpios property
  regulator: of: Parse ena-gpios property from DTS
  regulator: Use ena_gpio supplied with generic regulator bindings
  regulator: max77686: Add GPIO control
  mfd/regulator: dt-bindings: max77686: Document gpio properties
  ARM: dts: exynos4412-trats: Switch max77686 regulators to GPIO control

 Documentation/devicetree/bindings/mfd/max77686.txt | 14 +++-
 .../devicetree/bindings/regulator/regulator.txt    |  4 +
 arch/arm/boot/dts/exynos4412-trats2.dts            | 25 ++----
 drivers/mfd/Kconfig                                |  1 +
 drivers/mfd/max77686.c                             | 23 ------
 drivers/regulator/core.c                           | 96 ++++++++++++++++------
 drivers/regulator/max77686.c                       | 58 +++++++++++--
 drivers/regulator/of_regulator.c                   | 11 +++
 include/linux/mfd/max77686-private.h               |  1 -
 include/linux/mfd/max77686.h                       | 28 -------
 include/linux/regulator/driver.h                   |  5 ++
 include/linux/regulator/machine.h                  | 13 +++
 12 files changed, 178 insertions(+), 101 deletions(-)

-- 
1.9.1

