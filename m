Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaIVRJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:09:40 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:58100 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbaIVRJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:09:38 -0400
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, kernel@pengutronix.de, linus.walleij@linaro.org,
        gnurou@gmail.com
Cc: linux@arm.linux.org.uk, jingchang.lu@freescale.com, b20788@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, stefan@agner.ch
Subject: [PATCH 0/9] ARM: vf610: Suspend/resume support
Date: Mon, 22 Sep 2014 19:09:21 +0200
Message-Id: <cover.1411404079.git.stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset provides suspend/resume support for Freescale Vybrid
SoC (vf610). The code is generally aligned to the implementation
for i.MX6. The subsystems SRC and GPC need some changes to support
the Vybrid specific implementation.

This patchset relies on GPIO driver to be present (in order to
provide a wakeup source) as well as using the ARM Global Timer
clock source (the Vybrid specifc PIT clock source, vf_pit_timer.c
does not support shutdown).

The implemented sleep states (LP-RUN and STOP), are not the most
power saving functions available on Vybrid. Especially for
suspend-to-memory one of the LPSTOP modes looks more appropriate.
However, the complexity is somewhat higher (we would need to move
execution path to SRAM and store IOMUX and DDRMC configuration).
Currently, I have not the resources to look into that so I hope
that this initial code qualifies as power saving functions to be
applied.

Suspend-to-memory as well as standby mode is tested on Colibri
VF61.

Power measurement (Colibri VF61, whole module):
- Idle: 540mW
- LP-RUN: 220mW (standby)
- STOP: 200mW (mem)

Stefan Agner (9):
  ARM: dts: vf610: Add system reset controller (SRC)
  ARM: dts: vf610: add global power controller (GPC)
  ARM: dts: vf610: add on-chip SRAM
  ARM: dts: vf610-colibri: GPIO power key
  gpio: vf610: Extend with wakeup support
  ARM: imx: gpc: Support vf610 global power controller
  ARM: imx: src: Support vf610 system reset controller
  ARM: imx: clk-gate2: allow custom gate configuration
  ARM: vf610: initial suspend/resume support

 arch/arm/boot/dts/vf610-colibri-eval-v3.dts |  26 ++
 arch/arm/boot/dts/vf610.dtsi                |  33 +++
 arch/arm/mach-imx/Kconfig                   |   2 +
 arch/arm/mach-imx/Makefile                  |   1 +
 arch/arm/mach-imx/clk-gate2.c               |   7 +-
 arch/arm/mach-imx/clk-vf610.c               |   6 +
 arch/arm/mach-imx/clk.h                     |  13 +-
 arch/arm/mach-imx/common.h                  |  14 +-
 arch/arm/mach-imx/gpc.c                     |  61 ++--
 arch/arm/mach-imx/mach-imx6q.c              |   2 +-
 arch/arm/mach-imx/mach-imx6sl.c             |   2 +-
 arch/arm/mach-imx/mach-vf610.c              |   9 +
 arch/arm/mach-imx/pm-vf610.c                | 428 ++++++++++++++++++++++++++++
 arch/arm/mach-imx/src.c                     |  11 +
 drivers/gpio/gpio-vf610.c                   |  16 ++
 include/dt-bindings/clock/vf610-clock.h     |   3 +-
 16 files changed, 605 insertions(+), 29 deletions(-)
 create mode 100644 arch/arm/mach-imx/pm-vf610.c

-- 
2.1.0

