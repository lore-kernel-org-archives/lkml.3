Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaKOLp3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 06:45:29 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:50648 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbaKOLp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 06:45:27 -0500
From: Chris Zhong <zyw@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org
Cc: mturquette@linaro.org, Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>, khilman@kernel.org,
        linux-rockchip@lists.infradead.org, Chris Zhong <zyw@rock-chips.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>, Tony Xie <xxx@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v8 0/4] This is the 1st version of suspend for RK3288.
Date: Sat, 15 Nov 2014 19:45:06 +0800
Message-Id: <1416051910-16730-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This suspend patch is only support cut off the power of cpu and some external
devices, since we still lack power_domain driver, so the other power rail
of rk3288 need keep power on.
I have tested it on rk3288-evb board, atop next-20141112. goto suspend by type
"echo mem > /sys/power/state", vdd_cpu is about 0mv by measuring, so it can be
determined in sleep mode, then press power button to wakeup it.

Based on:
[v5,1/6] ARM: rockchip: convert to regmap and use pmu syscon if available
https://patchwork.kernel.org/patch/5086341/
[v5,2/6] ARM: rockchip: add option to access the pmu via a phandle in smp_operations
https://patchwork.kernel.org/patch/5086441/
[v5,3/6] ARM: dts: rockchip: add pmu references to cpus nodes
https://patchwork.kernel.org/patch/5086351/
[v5,4/6] ARM: rockchip: add basic smp support for rk3288
https://patchwork.kernel.org/patch/5086371/
[v5,5/6] ARM: dts: rockchip: add intmem node for rk3288 smp support
https://patchwork.kernel.org/patch/5086361/
[v5,6/6] ARM: dts: rockchip: add reset for CPU nodes
https://patchwork.kernel.org/patch/5086381/
[v3] usb: dwc2: add bus suspend/resume for dwc2
https://patchwork.kernel.org/patch/5266281/

Changes in v8:
- use enum for define sleep mode
- move rk3288_config_bootdata to the front of sram memcpy
- add ddr pinctrl for suspend
- keep all except cpu&tp power rail on during suspend
- add regulator-on-in-suspend before set suspend voltage
- add a reference of ddrio_pwroff and ddr0_retention

Changes in v7:
- get rid all of unused code
- add regulator-state-mem sub node for suspend

Changes in v6:
- get rid of the save/restore of SRAM
- doing the copy of resume code once at init time
- remove ROCKCHIP_ARM_OFF_LOGIC_DEEP from rk3288_fill_in_bootram
- add of_platform_populate in rockchip_dt_init
- change pmu_intmem@ff720000 to sram@ff720000
- change pmu_intmem@ff720000 to sram@ff720000

Changes in v5:
- use rk3288_bootram_sz for memcpy size
- fixed error of sram save and restore
- change the size of sram in example
- change size to 4k

Changes in v4:
- remove grf regmap

Changes in v3:
- move the pinmux of gpio6_c6 save and restore to pinctrl-rockchip

Changes in v2:
- add the regulator calls in prepare and finish.
- add the pinmux of gpio6_c6 save and restore
- put "rockchip,rk3288-pmu-sram" to first

Chris Zhong (4):
  ARM: rockchip: add suspend and resume for RK3288
  ARM: rockchip: Add pmu-sram binding
  ARM: dts: add RK3288 suspend support
  ARM: dts: add suspend voltage setting for RK808

 .../devicetree/bindings/arm/rockchip/pmu-sram.txt  |  16 ++
 arch/arm/boot/dts/rk3288-evb-rk808.dts             |  55 ++++-
 arch/arm/boot/dts/rk3288-evb.dtsi                  |  12 +
 arch/arm/boot/dts/rk3288.dtsi                      |  23 ++
 arch/arm/mach-rockchip/Makefile                    |   1 +
 arch/arm/mach-rockchip/pm.c                        | 264 +++++++++++++++++++++
 arch/arm/mach-rockchip/pm.h                        |  99 ++++++++
 arch/arm/mach-rockchip/rockchip.c                  |   2 +
 arch/arm/mach-rockchip/sleep.S                     |  73 ++++++
 9 files changed, 544 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/pmu-sram.txt
 create mode 100644 arch/arm/mach-rockchip/pm.c
 create mode 100644 arch/arm/mach-rockchip/pm.h
 create mode 100644 arch/arm/mach-rockchip/sleep.S

-- 
1.9.1

