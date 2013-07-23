Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934473Ab3GWXAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 19:00:41 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51683 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934190Ab3GWWZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:25:27 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, albert.u.boot@aribaud.net,
        Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 04/10] ARM: sun6i: Add restart code for the A31
Date: Wed, 24 Jul 2013 00:25:06 +0200
Message-Id: <1374618312-19001-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A31 has a sligthly different watchdog that requires a
different restart code.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-sunxi/sunxi.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index 11326d9..c18ef3a 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -32,6 +32,15 @@
 #define SUN4I_WATCHDOG_MODE_ENABLE		(1 << 0)
 #define SUN4I_WATCHDOG_MODE_RESET_ENABLE	(1 << 1)
 
+#define SUN6I_WATCHDOG1_IRQ_REG		0x00
+#define SUN6I_WATCHDOG1_CTRL_REG	0x10
+#define SUN6I_WATCHDOG1_CTRL_RESTART		(1 << 0)
+#define SUN6I_WATCHDOG1_CONFIG_REG	0x14
+#define SUN6I_WATCHDOG1_CONFIG_RESTART		(1 << 0)
+#define SUN6I_WATCHDOG1_CONFIG_IRQ		(1 << 1)
+#define SUN6I_WATCHDOG1_MODE_REG	0x18
+#define SUN6I_WATCHDOG1_MODE_ENABLE		(1 << 0)
+
 static void __iomem *wdt_base;
 
 static void sun4i_restart(enum reboot_mode mode, const char *cmd)
@@ -56,8 +65,36 @@ static void sun4i_restart(enum reboot_mode mode, const char *cmd)
 	}
 }
 
+static void sun6i_restart(char mode, const char *cmd)
+{
+	if (!wdt_base)
+		return;
+
+	/* Disable interrupts */
+	writel(0, wdt_base + SUN6I_WATCHDOG1_IRQ_REG);
+
+	/* We want to disable the IRQ and just reset the whole system */
+	writel(SUN6I_WATCHDOG1_CONFIG_RESTART,
+		wdt_base + SUN6I_WATCHDOG1_CONFIG_REG);
+
+	/* Enable timer. The default and lowest interval value is 0.5s */
+	writel(SUN6I_WATCHDOG1_MODE_ENABLE,
+		wdt_base + SUN6I_WATCHDOG1_MODE_REG);
+
+	/* Restart the watchdog. */
+	writel(SUN6I_WATCHDOG1_CTRL_RESTART,
+		wdt_base + SUN6I_WATCHDOG1_CTRL_REG);
+
+	while (1) {
+		mdelay(5);
+		writel(SUN6I_WATCHDOG1_MODE_ENABLE,
+			wdt_base + SUN6I_WATCHDOG1_MODE_REG);
+	}
+}
+
 static struct of_device_id sunxi_restart_ids[] = {
 	{ .compatible = "allwinner,sun4i-wdt", .data = sun4i_restart },
+	{ .compatible = "allwinner,sun6i-wdt", .data = sun6i_restart },
 	{ /*sentinel*/ }
 };
 
-- 
1.8.3.2

