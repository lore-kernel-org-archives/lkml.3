Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbbAELux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:50:53 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42803 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbbAELuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:50:50 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-70-54aa7a973029
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 0/5] regulator: Allow parsing custom DT properties with
 simplified DT parse
Date: Mon, 05 Jan 2015 12:48:40 +0100
Message-id: <1420458525-22576-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDJMWRmVeSWpSXmKPExsVy+t/xy7rTq1aFGNyfrGixccZ6VoupD5+w
	Wcw/co7V4vULQ4v+x6+ZLc42vWG3+Halg8li0+NrrBaXd81hs5hxfh+TA5fHzll32T02repk
	89i8pN6jb8sqRo/Pm+QCWKO4bFJSczLLUov07RK4Mv5tO8Jc0C1dcXvmDdYGxjmiXYwcHBIC
	JhK/bod3MXICmWISF+6tZ+ti5OIQEljKKNFyfws7hNPHJPF73ns2kCo2AWOJzcuXgFWJCHxg
	lFg16QcriMMsMI1R4sKp78wgVcICCRLXD69lB7FZBFQljt/aDmbzCrhLrL66hQVin5zEyWOT
	WScwci9gZFjFKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERJCX3YwLj5mdYhRgINRiYfX48TK
	ECHWxLLiytxDjBIczEoivK/SV4UI8aYkVlalFuXHF5XmpBYfYmTi4JRqYEzTfzP1+9TkRj97
	vvUcb6+9dv/zrv/HgRdS0cL6Kw6zsh5y1H1Z19KdVL7AwMQ5Ok5KPvnJy+RLd5l99XQNL6l4
	Su+IfWPN0HBj4bd90xS1Yjsn6E/SqFGdHnhOqui6YFxtmb3p2tYNXgmGV1juJ3DsElwqw5Sy
	3mvmcx9dtdnfdZYcPRE9X4mlOCPRUIu5qDgRAD1/s6X/AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


The patchset adds:
1. a way of parsing custom DT properties by the driver when simplified
   DT parsing method is used,
2. GPIO enable control to the max77686 driver.


Rationale
=========
After converting drivers to simplified DT parsing method, the parsing
is done by regulator core. The driver cannot longer parse any custom
properties from Device Tree. Example of such special property is
GPIO for enable control.

Driver may want to rely on regulator core to parse most of the bindings
but still need to parse one custom stuff. Additionally driver may need
to perform some special activities depending on Device Tree.

This is solved by adding a callback called from the core when regulator
is matched from DT. The max77686 driver uses it for:
1. parsing "maxim,ena-gpios" property from regulator OF node,
2. enabling GPIO control for such regulator.


Changes since v4
================
1. Re-work idea. Give up generic ena-gpios binding and let driver
   parse any custom property.

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


Best regards,
Krzysztof


Krzysztof Kozlowski (5):
  regulator: Copy config passed during registration
  regulator: Allow parsing custom properties when using simplified DT
    parsing
  regulator: max77686: Add GPIO control
  mfd/regulator: dt-bindings: max77686: Document gpio properties
  ARM: dts: exynos4412-trats: Switch max77686 regulators to GPIO control

 Documentation/devicetree/bindings/mfd/max77686.txt | 14 +++++
 arch/arm/boot/dts/exynos4412-trats2.dts            | 25 ++------
 drivers/regulator/core.c                           | 20 +++++--
 drivers/regulator/internal.h                       |  2 +
 drivers/regulator/max77686.c                       | 70 ++++++++++++++++++++--
 drivers/regulator/of_regulator.c                   | 11 ++++
 include/linux/regulator/driver.h                   | 13 ++++
 7 files changed, 126 insertions(+), 29 deletions(-)

-- 
1.9.1

