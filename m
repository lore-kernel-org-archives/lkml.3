Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaENUPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 16:15:36 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:37327 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaENUPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 16:15:33 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jisheng Zhang <jszhang@marvell.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/10] Marvell Berlin full clock support
Date: Wed, 14 May 2014 22:15:11 +0200
Message-Id: <1400098522-14770-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1399839881-29895-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1399839881-29895-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version 2 of a patch set to bring proper DT based clocks to
Marvell Berlin SoCs.

The overall changes are:

* Dropped of_clk_create_name() helper
Booting into an initramfs rootfs revealed that the unique clock names
created with that helper clash with the way of_clk_get_parent_name()
resolves the clock specifier to get the correct clock name. Anyway,
I still consider the helper a good idea and postpone it to the next
cycle when I have more time to look at the details.

* Added BG2Q core clock driver and dtsi changes
Alexandre just provided them, so I added them to this patch set.

The single patch overview now is:

Patch 1 adds the whole binding documentation for all clock related IP
found on BG2, BG2CD, and BG2Q.

Patch 2 adds corresponding dt-binding includes for the core clock
indices to be used in both DT and the driver.

Patches 3, 4, and 5 add clock drivers for the Audio/Video PLL, simple
PLLs, and complex clock divider cells found on Berlin SoCs. Where
required, currently known differences between BG2/BG2CD and BG2Q are
taken care of.

Patches 6 and 7 add core clock drivers for the remaining clocks of
BG2/BG2CD and BG2Q. The register set dealing with it, is shared among
input and bypass muxes, clock dividers and clock gates.

Patches 8, 9, and 10 finally convert the DT SoC includes for BG2,
BG2CD, and BG2Q to make use of the new clock related DT nodes.

Alexandre Belloni (4):
  clk: berlin: add driver for BG2x simple PLLs
  clk: berlin: add driver for BG2x complex divider cells
  clk: berlin: add core clock driver for BG2Q
  ARM: dts: berlin: convert BG2Q to DT clock nodes

Sebastian Hesselbarth (6):
  dt-binding: clk: add clock binding docs for Marvell Berlin2 SoCs
  clk: berlin: add binding include for BG2/BG2CD clock ids
  clk: berlin: add driver for BG2x audio/video PLL
  clk: berlin: add core clock driver for BG2/BG2CD
  ARM: dts: berlin: convert BG2CD to DT clock nodes
  ARM: dts: berlin: convert BG2 to DT clock nodes

 .../devicetree/bindings/clock/berlin2-clock.txt    | 195 ++++++++
 arch/arm/boot/dts/berlin2.dtsi                     | 207 +++++++--
 arch/arm/boot/dts/berlin2cd.dtsi                   | 205 +++++++--
 arch/arm/boot/dts/berlin2q.dtsi                    |  80 +++-
 drivers/clk/Makefile                               |   1 +
 drivers/clk/berlin/Makefile                        |   4 +
 drivers/clk/berlin/berlin2-avpll.c                 | 368 +++++++++++++++
 drivers/clk/berlin/berlin2-div.c                   | 324 +++++++++++++
 drivers/clk/berlin/berlin2-div.h                   |  80 ++++
 drivers/clk/berlin/berlin2-pll.c                   | 168 +++++++
 drivers/clk/berlin/bg2.c                           | 502 +++++++++++++++++++++
 drivers/clk/berlin/bg2q.c                          | 269 +++++++++++
 include/dt-bindings/clock/berlin2.h                |  35 ++
 include/dt-bindings/clock/berlin2q.h               |  28 ++
 14 files changed, 2385 insertions(+), 81 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/berlin2-clock.txt
 create mode 100644 drivers/clk/berlin/Makefile
 create mode 100644 drivers/clk/berlin/berlin2-avpll.c
 create mode 100644 drivers/clk/berlin/berlin2-div.c
 create mode 100644 drivers/clk/berlin/berlin2-div.h
 create mode 100644 drivers/clk/berlin/berlin2-pll.c
 create mode 100644 drivers/clk/berlin/bg2.c
 create mode 100644 drivers/clk/berlin/bg2q.c
 create mode 100644 include/dt-bindings/clock/berlin2.h
 create mode 100644 include/dt-bindings/clock/berlin2q.h

---
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Jisheng Zhang <jszhang@marvell.com>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.9.1

