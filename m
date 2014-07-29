Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbaG2Q3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:29:21 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:58412 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaG2Q3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:29:18 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [RFC 0/5] Get voltage from parent if not available on child
Date: Tue, 29 Jul 2014 18:28:54 +0200
Message-Id: <1406651339-28901-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The motivation for this series is that some regulators are
really just switches that provide as output voltage what is
supplied to them as input voltage. These components can be
only switched on and off so the drivers usually implements
a subset of the possible regulator operations. That is only
.enable, .disable and .is_enabled but no .{get,list}_voltage

But there is code that assume all regulators can provide
their output voltage so if one of these load switches are
used as an input supply a call to regulator_get_voltage() or
regulator_list_voltage() will fail.

As an example in [0] mmc_regulator_get_supply() is used to
obtain the vmmc supply but on Peach Pit and Pi boards this
is tps65090 fet4 which is a load switch so the call to
mmc_regulator_get_ocrmask() fails since it tries to obtain
the regulator voltage count and list.

mmc_regulator_set_ocr() function fails as well since it calls
regulator_get_voltage() which the driver does not implement.

Since this seems to be a general issue we can pass through
and query the parent supply voltage when a child regulator
does not implement the handlers to obtain its output voltage.

The series have been tested on a Exynos 5420 Peach Pit board
and is composed of the following patches: 

Javier Martinez Canillas (5):
  regulator: core: Get voltage from parent if not available
  regulator: core: Allow to get voltage count and list from parent
  regulator: core: Only apply constraints if available on list voltage
  regulator: tps65090: Set voltage for fixed regulators
  ARM: dts: Improve Peach Pit and Pi power scheme model

 arch/arm/boot/dts/exynos5420-peach-pit.dts | 12 +++++------
 arch/arm/boot/dts/exynos5800-peach-pi.dts  | 12 +++++------
 drivers/regulator/core.c                   | 31 ++++++++++++++++++++-------
 drivers/regulator/tps65090-regulator.c     | 34 ++++++++++++++++++------------
 4 files changed, 56 insertions(+), 33 deletions(-)

Patch 1 adds support to get the voltage of the parent supply
while patch 2 does the same for selector count and selector.
Patch 3 only applies the constraints when querying a selector
if there were constraints defined for this regulator. Otherwise
the constraints of the parent supply will be applied when
calling regulator_list_voltage() for the parent supply. Patch
4 adds information about the voltage output for the fixed
regulators found on the tps65090 since these are parent supply
of the fets load switches. Finally patch 5 models the real
relation between regulators in the Peach Pit and Pi boards
instead of the simplistic model that is implemented now.
This last patch should not be merged with the series but since
is a RFC I included so it can be tested on Peach boards and
to provide the complete picture.

Best regards,
Javier

[0]: https://patchwork.kernel.org/patch/4401231/
[1]: http://lxr.free-electrons.com/source/drivers/mmc/core/core.c#L1253
