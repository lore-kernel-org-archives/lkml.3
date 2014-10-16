Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaJPQt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:49:57 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:34955 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaJPQtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:49:53 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v2 0/7] Add max77802 regulator operating mode support
Date: Thu, 16 Oct 2014 18:48:46 +0200
Message-Id: <1413478133-2577-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

This is the second version of the series that adds operating modes
support for the regulators in the max77802 PMIC. It address issues
pointed out in "regulator: max77802: Add .{get,set}_mode callbacks"
and also removes the patches you already picked on the topic branch.
The first version of the series was [0].

The series adds a "maxim,regulator-initial-mode" property to configure
at startup the operating mode for the regulators that support changing
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

This series depend on [1] and also v2 of patch:
"ARM: EXYNOS: Call regulator core suspend prepare and finish functions" [2].

NOTE: Patch #4 touches a header in include/linux/mfd so some coordination
with the mfd maintainer (added as cc) will be needed.

Javier Martinez Canillas (7):
  regulator: max77802: Add .{get,set}_mode callbacks
  regulator: max77802: Add set suspend mode for BUCKs and simplify code
  regulator: max77802: Don't treat OFF as an operating mode
  regulator: max77802: Add header for operating modes
  regulator: max77802: Document regulator opmode DT properties
  regulator: max77802: Parse regulator operating mode properties
  ARM: dts: Configure regulators for suspend on exynos Peach boards

 .../devicetree/bindings/regulator/max77802.txt     |  45 ++++++++
 arch/arm/boot/dts/exynos5420-peach-pit.dts         |  81 ++++++++++++++
 arch/arm/boot/dts/exynos5800-peach-pi.dts          |  81 ++++++++++++++
 drivers/regulator/max77802.c                       | 122 ++++++++++++++++-----
 include/dt-bindings/regulator/maxim,max77802.h     |  18 +++
 include/linux/mfd/max77686.h                       |   7 --
 6 files changed, 319 insertions(+), 35 deletions(-)
 create mode 100644 include/dt-bindings/regulator/maxim,max77802.h

Patch #1 adds a get and set mode function handlers for the regulators whose
operating mode can be changed at runtime.

Patch #2 adds support for changing the operating mode for all regulators
that support setting a different opmode during suspend.

Patch #3 is a cleanup to not call OFF an operating mode.

Patch #4 adds a header file with the valid operating modes so it can be used
by Device Tree source files.

Patch #5 extend the max77802 DT binding to include the properties used to
setup the regulators modes.

Patch #6 adds the support to parse these from the driver.

Patch #7 configures the modes for the max77802 regulators in the Device Tree
source file of the Peach Chromebooks.

Best regards,
Javier

[0]: https://lkml.org/lkml/2014/10/8/331
[1]: https://lkml.org/lkml/2014/10/10/161
[2]: http://www.spinics.net/lists/arm-kernel/msg369923.html
