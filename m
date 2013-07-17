Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab3GQLnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:43:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42712 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984Ab3GQLni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:43:38 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 0/3] ARM: OMAP2+: omap_device: add dynamic pinctrl handling
Date: Wed, 17 Jul 2013 14:41:49 +0300
Message-ID: <1374061312-25469-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony, Kevin

This patch series introduces dynamic pinctrl handling in OMAP device framework
in the same way as it was before switching to DT. 
This allow OMAP devices driver's developers to simply add dynamic pinctrl
handling for "default", "active", "idle", "sleep" PIN states in their drivers
by modifying DT definitions only - no modifications in drivers code are not needed.

Tested on OMAP4 SDP(Tablet2) board using omap4-sdp.dts
- UART3/4 autoidle
- suspend, by adding some fake "sleep" pin state
- wake up (PRCM) IRQ generation by ading call to omap44xx_prm_reconfigure_io_chain()
  right after each call to pinctrl_pm_select_xx() API.

UART3(console) reg dumps:
- active 
 0x4A100140(RTS/CTS) - 0x00000118
 0x4A100140(TX/RX) - 0x00000100
- idle
 0x4A100140(RTS/CTS) - 0x00000118
 0x4A100144(TX/RX) - 0x00004100

UART4 reg dumps:
- active 
 0x4A10015C(TX/RX) - 0x00000100
- idle
 0x4A10015C(TX/RX) - 0x00004100

Debugfs:
# cat sys/kernel/debug/pinctrl/4a100040.pinmux/pinmux-pins
[snip]
pin 128 (4a100140.0): 48020000.serial (GPIO UNCLAIMED) function pinmux_uart3_pins group pinmux_uart3_pins
pin 129 (4a100142.0): 48020000.serial (GPIO UNCLAIMED) function pinmux_uart3_pins group pinmux_uart3_pins
pin 130 (4a100144.0): 48020000.serial (GPIO UNCLAIMED) function pinmux_uart3_pins_active group pinmux_uart3_pins_active
pin 131 (4a100146.0): 48020000.serial (GPIO UNCLAIMED) function pinmux_uart3_pins group pinmux_uart3_pins
[snip]
pin 142 (4a10015c.0): 4806e000.serial (GPIO UNCLAIMED) function pinmux_uart4_pins_idle group pinmux_uart4_pins_idle
pin 143 (4a10015e.0): 4806e000.serial (GPIO UNCLAIMED) function pinmux_uart4_pins group pinmux_uart4_pins

Changes since RFC:
- _od_resume_noirq() fixed - "idle" state was not selected on resume
- description updated

RFC: https://lkml.org/lkml/2013/6/21/309

Based on v3.11-rc1 plus patch series from Tony Lindgren
"[PATCH 0/4] improved support for runtime muxing for pinctrl"
http://www.spinics.net/lists/arm-kernel/msg258827.html:

fd7937b drivers: Add pinctrl handling for dynamic pin states
479246b pinctrl: Add support for additional dynamic states
c9f37e8 pinctrl: Allow pinctrl to have multiple active states
756f10b pinctrl: Remove duplicate code in pinctrl_pm_select_state functions
ad81f05 Linux 3.11-rc1

Related discussions:
- drivers: pinctrl sleep and idle states in the core
 http://lists.infradead.org/pipermail/linux-arm-kernel/2013-June/173514.html
- [PATCH] drivers: pinctrl: add active state to core
 http://marc.info/?l=linux-kernel&m=137094012703340&w=2
- [PATCH] pinctrl: document the pinctrl PM states
 https://lkml.org/lkml/2013/6/11/501
- [3/3] i2c: nomadik: use pinctrl PM helpers
 https://patchwork.kernel.org/patch/2670291/
- mmc: omap_hsmmc: Remux pins to support SDIO interrupt and PM runtime
 https://patchwork.kernel.org/patch/2690191/
- [PATCH 00/11] drivers: Add Pinctrl PM support
 https://lkml.org/lkml/2013/5/31/210


Grygorii Strashko (3):
  pinctrl: rollback check for !dev->pins in pinctrl_pm_select*() APIs
  ARM: OMAP2+: omap_device: add pinctrl handling
  ARM: dts: omap4-sdp: add dynamic pin states for uart3/4

 arch/arm/boot/dts/omap4-sdp.dts   |   34 +++++++++++++++++++++++++++----
 arch/arm/mach-omap2/omap_device.c |   40 +++++++++++++++++++++++++++++++------
 drivers/pinctrl/core.c            |   12 +++++++++++
 3 files changed, 76 insertions(+), 10 deletions(-)

Regards,
-grygorii

CC: Linus Walleij <linus.walleij@linaro.org>
CC: Stephen Warren <swarren@wwwdotorg.org>
CC: Roger Quadros <rogerq@ti.com>
-- 
1.7.9.5

