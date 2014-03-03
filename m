Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaCCQCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:02:37 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:55219 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbaCCQCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:02:33 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Mark Brown <broonie@kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH v2 00/11] Generic Device Tree based power domain look-up
Date: Mon,  3 Mar 2014 17:02:05 +0100
Message-Id: <1393862536-9842-1-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up till now there was no single generic method to bind devices to their
power domains using Device Tree. Each platform has been doing this using
its own way, example of which are Exynos power domain bindings [1] and
look-up code [2].

This series is intended to change this and provide generic DT bindings for
power domain specification and generic code performing look-up of power
domains and binding them to devices.

First two patches are the most important part of this series, as they
introduce $subject. Patch 3 converts mach-exynos to use the new generic
method. Further patches are adding one more user of the new code,
mach-s3c64xx, with first 3 patches (4-6) required to clean-up its power
domain driver a bit and last 3 patches (9-11) adding display support for
Mini6410 board, including a node for display controller (FIMD) which is
a power domain consumer.

The design of DT bindings and provider code is heavily inspired by
implementation of clock providers in Common Clock Framework, while
the code binding devices to power domains by my Exynos power domain
implementation (now removed by this series ;)).

Successfully tested on S3C6410-based Mini6410 board.

[1] Documentation/devicetree/bindings/arm/exynos/power_domain.txt
[2] arch/arm/mach-exynos/pm_domains.c

Changes since v1 (RFC):
[https://lkml.org/lkml/2014/1/11/141]
 - rebased onto current Rafael's linux-pm bleeding-edge branch,
 - reordered the patches a bit (to have the generic ones first),
 - dropped renaming of S3C64xx power domains (as suggested by Mark Brown),
 - added support for deferred probing (as suggested by Stephen Boyd),
 - fixed several minor issues pointed by Stephen Boyd,
 - replaced notifiers with direct hooks in driver core to make power domain
   support independent from specific bus type and allow error handling.

Tomasz Figa (11):
  base: power: Add generic OF-based power domain look-up
  drivercore: Bind/unbind power domain on probe/remove
  ARM: exynos: Move to generic power domain bindings
  ARM: s3c64xx: pm: Use name field of generic_pm_domain
  ARM: s3c64xx: pm: Add always_on field to s3c64xx_pm_domain struct
  ARM: s3c64xx: pm: Add pwr_stat bit for domain G
  ARM: s3c64xx: pm: Add device tree based power domain instantiation
  ARM: s3c64xx: dt: Enable SoC-level power management
  ARM: dts: s3c64xx: Add nodes for power domains
  ARM: dts: s3c64xx: Add node for display controller
  ARM: dts: s3c6410-mini6410: Add support for LCD screen

 .../bindings/arm/exynos/power_domain.txt           |  12 +-
 .../devicetree/bindings/power/power_domain.txt     |  51 ++++
 arch/arm/boot/dts/s3c6400.dtsi                     |   1 +
 arch/arm/boot/dts/s3c6410-mini6410.dts             |  33 +++
 arch/arm/boot/dts/s3c6410.dtsi                     |   1 +
 arch/arm/boot/dts/s3c64xx.dtsi                     |  13 +
 arch/arm/mach-exynos/pm_domains.c                  |  80 +-----
 arch/arm/mach-s3c64xx/mach-s3c64xx-dt.c            |   8 +
 arch/arm/mach-s3c64xx/pm.c                         | 106 ++++++--
 drivers/base/dd.c                                  |   9 +-
 drivers/base/power/domain.c                        | 298 +++++++++++++++++++++
 include/dt-bindings/arm/s3c64xx-power-domains.h    |  26 ++
 include/linux/pm_domain.h                          |  46 ++++
 kernel/power/Kconfig                               |   4 +
 14 files changed, 576 insertions(+), 112 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/power_domain.txt
 create mode 100644 include/dt-bindings/arm/s3c64xx-power-domains.h

-- 
1.9.0

