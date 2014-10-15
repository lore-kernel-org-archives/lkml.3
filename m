Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaJOQVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 12:21:00 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33518 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaJOQUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 12:20:53 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 0/9] Add max77802 regulator operating mode support
Date: Wed, 15 Oct 2014 18:20:30 +0200
Message-Id: <1413390039-19364-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

This is the second attempt to add operating modes support for the
regulators in the max77802 PMIC. Instead of trying to come up with
a generic solution like in the previous attempt [0], I added DT
properties that are specific to the max77802 PMIC so is documented
clearly what are the operating modes that each regulator support. The
series version is not v2 because it's a completely different approach.

There is a "maxim,regulator-initial-mode" property to configure at
startup the operating mode for the regulators that support changing
its mode during normal operation and "maxim,regulator-{disk,mem}-mode"
properties for the regulators that only support changing its operating
mode when the system enters in a suspend state.

The regulators can be enabled or disabled during suspend by using the
standard "regulator-{on,off}-in-suspend" properties from Chanwoo Choi's
regulator suspend state series [1].

I tried to use as much as possible the infrastructure that is already
provided in the regulator framework by adding the needed handlers for
the set_suspend_* operations.

Also, the driver still had some assumptions and didn't clearly made a
distinction between the valid modes (normal and low power) and off which
is not an operating mode as you explained. So I reworked a bit to better
treat them separately as is expected by the regulator API.

This series depend on [1] and also patch:
"ARM: EXYNOS: Call regulator core suspend prepare and finish functions" [2].

Javier Martinez Canillas (9):
  regulator: max77802: Add .set_suspend_{enable,disable} callbacks
  regulator: max77802: Add .{get,set}_mode callbacks
  regulator: max77802: Split regulator operations for BUCKs
  regulator: max77802: Add set suspend mode for BUCKs and simplify code
  regulator: max77802: Don't treat OFF as an operating mode
  regulator: max77802: Add header for operating modes
  regulator: max77802: Document regulator opmode DT properties
  regulator: max77802: Parse regulator operating mode properties
  ARM: dts: Configure regulators for suspend on exynos Peach boards

 .../devicetree/bindings/regulator/max77802.txt     |  45 ++++++
 arch/arm/boot/dts/exynos5420-peach-pit.dts         |  81 ++++++++++
 arch/arm/boot/dts/exynos5800-peach-pi.dts          |  81 ++++++++++
 drivers/regulator/max77802.c                       | 168 ++++++++++++++++-----
 include/dt-bindings/regulator/maxim,max77802.h     |  18 +++
 include/linux/mfd/max77686.h                       |   7 -
 6 files changed, 353 insertions(+), 47 deletions(-)
 create mode 100644 include/dt-bindings/regulator/maxim,max77802.h

Patch #1 adds handlers for all regulators that can be enabled and disabled
during suspend

Patch #2 adds a get and set mode function handlers for the regulators whose
operating mode can be changed at runtime.

Patch #3 split the regulator operations for the BUCK regulators since don't
have the exact functionality.

Patch #4 add support for changing the operating mode for all regulators that
support setting a different opmode during suspend.

Patch #5 is a cleanup to not call OFF an operating mode.

Patch #6 adds a header file with the valid operating modes so it can be used
by Device Tree source files.

Patch #7 extend the max77802 DT binding to include the properties used to
setup the regulators modes.

Patch #8 adds the support to parse these from the driver.

Patch #9 configures the modes for the max77802 regulators in the Device Tree
source file of the Peach Chromebooks.

Best regards,
Javier

[0]: https://lkml.org/lkml/2014/10/8/331
[1]: https://lkml.org/lkml/2014/10/10/161
[2]: https://lkml.org/lkml/2014/10/15/228
