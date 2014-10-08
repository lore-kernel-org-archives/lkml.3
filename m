Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbaJHNpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:45:52 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:52414 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbaJHNpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:45:51 -0400
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
Subject: [PATCH 0/5] regulator: Add support for initial operating modes
Date: Wed,  8 Oct 2014 15:44:02 +0200
Message-Id: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

This series add support to setup an initial operating mode for regulators.

There were previous attempts to solve the same issue by adding DT bindings
that were driver-specific like Abhilash Kesavan's "Add MAX77686 Operating
mode support" [0] or Krzysztof Kozlowski's "regulator: s2mps11: Add opmode
for S2MPS14 regulators" [1] series.

But there are many IC with regulators that can be configured with different
operating modes so this is a problem that has to be solved generically and
in fact the regulator core already has a .initial_mode field in the struct
regulation_constraints that is used to call the regulator driver .set_mode
function handler with an initial mode, when regulator constraints are set.

So with the old days of platform data, board files could fill this but with
Device Trees is not possible. The same issue happens with suspend states
since there isn't currently a way to fill this information on DT booting.
That's why there were also different attempts to solve the suspend states
issue like [2] and [3]. Chanwoo's series [4] seems to be close to finally
fix the suspend states issue by filling this data from DT but it does not
support the initial regulator operating mode so this series do that on top
of Chanwoo's work.

Possible use cases for default operating mode support in DT are:

a) Boards wants to set different operating modes for regulators in order to
   lower power at suspend time. For example some SoCs have a dedicated pin
   that is pulled high during normal operation and is pulled down when the
   system enters in sleep mode. A PMIC may support automatically disabling
   a regulator, put it in low power mode or changing the voltage when is
   signalled by the SoC that has entered in sleep mode. Each regulator could
   have different constraints so being able to choose the mode is useful.

b) Regulator drivers that read the operating mode from a HW register may be
   reading OFF if the regulator was disabled and the PMIC is not reset on
   warm reboot. In this case the .enable function may set OFF as the default
   mode thus the regulator failing to be enabled. This can be worked around
   by setting the mode to NORMAL if OFF is read from a hardware register but
   is more robust to explicitly configure that from the DT.

These patches do not really depend on Chanwoo's series but are based on top
since both series are complementary to solve the same general issue and to
avoid merge conflicts. But I can resend to just base on top of the regulator
for-next branch if that is easier for you.

The series is composed of the following patches:

Javier Martinez Canillas (5):
  regulator: of: Add regulator-initial-mode parse support
  regulator: dt-bindings: Add DT include for constants
  regulator: dt-bindings: Add regulator-initial-mode support
  regulator: max77802: Add regulator operating mode set support
  ARM: dts: Add initial regulator mode on exynos Peach boards

 .../devicetree/bindings/regulator/regulator.txt    |  8 ++++++
 arch/arm/boot/dts/exynos5420-peach-pit.dts         | 26 ++++++++++++++++++
 arch/arm/boot/dts/exynos5800-peach-pi.dts          | 26 ++++++++++++++++++
 drivers/regulator/max77802.c                       | 32 ++++++++++++++++++++++
 drivers/regulator/of_regulator.c                   |  3 ++
 include/dt-bindings/regulator/regulator.h          | 16 +++++++++++
 6 files changed, 111 insertions(+)
 create mode 100644 include/dt-bindings/regulator/regulator.h

Patch #1 adds support to set the .initial_mode from DT, patch #2 adds a
include header to avoid DTS using magic numbers for the regulator modes,
patch #3 describes the new "regulator-initial-mode" property in the DT
binding doc, patch #4 adds supports to the max77802 for setting modes
and finally patch #5 adds the initial regulator modes for the regulators
in the max77802 PMIC of the Exynos Peach Chromebooks.

Thanks a lot and best regards,
Javier

[0]: https://lkml.org/lkml/2012/12/10/18
[1]: https://lkml.org/lkml/2014/2/13/82
[2]: https://lkml.org/lkml/2012/12/10/434
[3]: https://lkml.org/lkml/2013/7/25/592
[4]: https://lkml.org/lkml/2014/7/9/16
