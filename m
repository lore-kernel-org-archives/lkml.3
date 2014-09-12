Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbaILNP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:15:29 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:35295 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbaILNPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:15:24 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 0/4] ARM: shmobile: r8a7740: Handle implicitly enabled clocks
Date: Fri, 12 Sep 2014 15:15:16 +0200
Message-Id: <1410527720-18061-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi all,

This patch series fixes an issue with the INTCA module clock, which we
currently assume enabled by the bootloader or reset state.
If this clock was not enabled before booting Linux, the intc-irqpin driver
and all devices connected to it (buttons, RTC on i2c-gpio) don't work.

To fix this, the clock is added to the system, and is managed in the driver
through runtime PM, taking into account wake-up sources (gpio-keys, RTC alarm).

There's one remaining issue for armadillo-legacy, which has support for the LCD
controller. Although the shmobile_lcd_fb driver doesn't use MERAM on r8a7740
(unlike on sh7372), the MERAM (Media RAM) and ICB (MERAM Interconnect Buffer)
clocks must be enabled to show a picture on the display. However, the MERAM
doesn't have any device associated with it, so it's non-trivial to hook it up.

This patch series is based on renesas-devel-20140911-v3.17-rc4 and
irqchip/for-next.

Geert Uytterhoeven (4):
  irqchip: renesas-intc-irqpin: Add helper variable dev = &pdev->dev
  irqchip: renesas-intc-irqpin: Add minimal runtime PM support
  ARM: shmobile: r8a7740 legacy: Add missing INTCA clock for irqpin
    module
  ARM: shmobile: r8a7740 dtsi: Add missing INTCA clock for irqpin module

 arch/arm/boot/dts/r8a7740.dtsi            | 14 ++++--
 arch/arm/mach-shmobile/clock-r8a7740.c    |  7 ++-
 drivers/irqchip/irq-renesas-intc-irqpin.c | 83 +++++++++++++++++++++----------
 include/dt-bindings/clock/r8a7740-clock.h |  1 +
 4 files changed, 73 insertions(+), 32 deletions(-)

-- 
1.9.1

Thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
