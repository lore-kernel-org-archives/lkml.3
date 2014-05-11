Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbaEKUY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 16:24:56 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:35891 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757727AbaEKUYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 16:24:51 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] Marvell Berlin full clock support
Date: Sun, 11 May 2014 22:24:33 +0200
Message-Id: <1399839881-29895-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch set combining initial effort from Alexandre Belloni [1][2]
and a bad one from me [3] to bring proper DT based clocks to Marvell Berlin
SoCs. As I was unsure, how Alexandre's initial patch sets fit in the whole
picture, I had to look at it myself. It took me a while to sort out the messy
clk related registers of Berlin, but finally IMHO I found a good compromise
between DT and driver registered clocks.

As I don't have any access to BG2Q code/documentation, it needs some
additional patches from Alexandre. This is basically berlin2q.dtsi changes
and a core clock driver for BG2Q. Anyway, this is nothing that should stall
a proper driver-/DT-related review.

Apoloigies for the noise the three approaches may have caused, but anybody
who takes a closer look at either this patches or the corresponding GPL'd
Chromecast SDK [4][5] will quickly see that Marvell HW engineers really hate
those who have to write the drivers for their register sets. It is full of
"similar" registers for the same IP that received some TLC, like one register
is shifted by 4 bits with respect to the other registers dealing with the
same functionalities. *sigh*

The patches are based on v3.15-rc1 and I have compared the resulting clock
frequencies with u-boot's reported frequencies where possible on Chromecast
(BG2CD) and NSZ-GS7 (BG2).

I'd love to see them in for v3.16 as it will allow us to proceed with working
on drivers that actually need those clocks. Current support for Marvell Berlin
SoCs is almost limited to serial console, so there is absolutely nothing to
break. To make sure it will not break others, I prepared a topic branch and
added it to berlin's linux-next branch.

The topic branch can be found at
https://github.com/shesselba/linux-berlin.git topic/clk

Patch 1 first adds a helper function to derive a unique clock name out of
the DT nodes name and either the reg property or a magic number. This is
taken from DT's platform code, that derives similar unique names for proper
platform devices.

Patch 2 adds the whole binding documentation for all clock related IP.

Patches 3, 4, and 5 then add clock drivers for the Audio/Video PLL, simple
PLLs, and complex clock divider cells found on Berlin SoCs. Where required,
currently known differences between BG2/BG2CD and BG2Q are taken care of.

Patch 6 adds a clock driver for the remaining core clocks of BG2/BG2CD. The
register set dealing with it, is shared among input and bypass muxes, clock
dividers and clock gates.

Patches 7 and 8 finally convert the DT SoC include for BG2 and BG2CD to make
use of the new clock related DT nodes.

[1] https://lkml.org/lkml/2014/4/23/831
[2] https://lkml.org/lkml/2014/4/24/624
[3] https://lkml.org/lkml/2014/5/8/592
[4] https://code.google.com/p/chromecast-mirrored-source/source/browse/bootloader/berlin_tools/bootloader/clock/galois_speed.c?repo=sdk
[5] https://code.google.com/p/chromecast-mirrored-source/source/browse/bootloader/berlin_tools/bootloader/include/Firmware_Berlin_BG2CD_A0/global.h?repo=sdk

Alexandre Belloni (2):
  clk: berlin: add driver for BG2x simple PLLs
  clk: berlin: add driver for BG2x complex divider cells

Sebastian Hesselbarth (6):
  clk: add helper for unique DT clock names
  clk: berlin: add clock binding docs for Marvell Berlin2 SoCs
  clk: berlin: add driver for BG2x audio/video PLL
  clk: berlin: add core clock driver for BG2/BG2CD
  ARM: dts: berlin: convert BG2CD to DT clock nodes
  ARM: dts: berlin: convert BG2 to DT clock nodes

 .../devicetree/bindings/clock/berlin2-clock.txt    | 169 +++++++
 arch/arm/boot/dts/berlin2.dtsi                     | 200 ++++++--
 arch/arm/boot/dts/berlin2cd.dtsi                   | 198 ++++++--
 drivers/clk/Makefile                               |   1 +
 drivers/clk/berlin/Makefile                        |   3 +
 drivers/clk/berlin/berlin2-avpll.c                 | 373 +++++++++++++++
 drivers/clk/berlin/berlin2-div.c                   | 326 +++++++++++++
 drivers/clk/berlin/berlin2-div.h                   |  80 ++++
 drivers/clk/berlin/berlin2-pll.c                   | 171 +++++++
 drivers/clk/berlin/bg2.c                           | 509 +++++++++++++++++++++
 drivers/clk/clk.c                                  |  29 ++
 include/dt-bindings/clock/berlin2.h                |  35 ++
 include/linux/clk-provider.h                       |   5 +
 13 files changed, 2042 insertions(+), 57 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/berlin2-clock.txt
 create mode 100644 drivers/clk/berlin/Makefile
 create mode 100644 drivers/clk/berlin/berlin2-avpll.c
 create mode 100644 drivers/clk/berlin/berlin2-div.c
 create mode 100644 drivers/clk/berlin/berlin2-div.h
 create mode 100644 drivers/clk/berlin/berlin2-pll.c
 create mode 100644 drivers/clk/berlin/bg2.c
 create mode 100644 include/dt-bindings/clock/berlin2.h

---
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.9.1

