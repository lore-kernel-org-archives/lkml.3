Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab3HDJt6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 05:49:58 -0400
Received: from up.free-electrons.com ([94.23.35.102]:36984 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753581Ab3HDJr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 05:47:57 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv3 04/10] ARM: sun6i: Add restart code for the A31
Date: Sun,  4 Aug 2013 11:47:31 +0200
Message-Id: <1375609657-15434-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375609657-15434-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1375609657-15434-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A31 has a different watchdog, with a slightly different
register layout, that requires a different restart code.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 .../devicetree/bindings/watchdog/sun4i-wdt.txt     | 13 -------
 .../devicetree/bindings/watchdog/sunxi-wdt.txt     | 14 +++++++
 arch/arm/mach-sunxi/sunxi.c                        | 43 ++++++++++++++++++++--
 3 files changed, 54 insertions(+), 16 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/watchdog/sun4i-wdt.txt
 create mode 100644 Documentation/devicetree/bindings/watchdog/sunxi-wdt.txt

diff --git a/Documentation/devicetree/bindings/watchdog/sun4i-wdt.txt b/Documentation/devicetree/bindings/watchdog/sun4i-wdt.txt
deleted file mode 100644
index ecd650a..0000000
--- a/Documentation/devicetree/bindings/watchdog/sun4i-wdt.txt
+++ /dev/null
@@ -1,13 +0,0 @@
-Allwinner sun4i Watchdog timer
-
-Required properties:
-
-- compatible : should be "allwinner,sun4i-wdt"
-- reg : Specifies base physical address and size of the registers.
-
-Example:
-
-wdt: watchdog@01c20c90 {
-	compatible = "allwinner,sun4i-wdt";
-	reg = <0x01c20c90 0x10>;
-};
diff --git a/Documentation/devicetree/bindings/watchdog/sunxi-wdt.txt b/Documentation/devicetree/bindings/watchdog/sunxi-wdt.txt
new file mode 100644
index 0000000..e39cb26
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/sunxi-wdt.txt
@@ -0,0 +1,14 @@
+Allwinner SoCs Watchdog timer
+
+Required properties:
+
+- compatible : should be "allwinner,<soc-family>-wdt", the currently supported
+  SoC families being sun4i and sun6i
+- reg : Specifies base physical address and size of the registers.
+
+Example:
+
+wdt: watchdog@01c20c90 {
+	compatible = "allwinner,sun4i-wdt";
+	reg = <0x01c20c90 0x10>;
+};
diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index 11326d9..19bcc96 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -27,10 +27,19 @@
 #include <asm/system_misc.h>
 
 #define SUN4I_WATCHDOG_CTRL_REG		0x00
-#define SUN4I_WATCHDOG_CTRL_RESTART		(1 << 0)
+#define SUN4I_WATCHDOG_CTRL_RESTART		BIT(0)
 #define SUN4I_WATCHDOG_MODE_REG		0x04
-#define SUN4I_WATCHDOG_MODE_ENABLE		(1 << 0)
-#define SUN4I_WATCHDOG_MODE_RESET_ENABLE	(1 << 1)
+#define SUN4I_WATCHDOG_MODE_ENABLE		BIT(0)
+#define SUN4I_WATCHDOG_MODE_RESET_ENABLE	BIT(1)
+
+#define SUN6I_WATCHDOG1_IRQ_REG		0x00
+#define SUN6I_WATCHDOG1_CTRL_REG	0x10
+#define SUN6I_WATCHDOG1_CTRL_RESTART		BIT(0)
+#define SUN6I_WATCHDOG1_CONFIG_REG	0x14
+#define SUN6I_WATCHDOG1_CONFIG_RESTART		BIT(0)
+#define SUN6I_WATCHDOG1_CONFIG_IRQ		BIT(1)
+#define SUN6I_WATCHDOG1_MODE_REG	0x18
+#define SUN6I_WATCHDOG1_MODE_ENABLE		BIT(0)
 
 static void __iomem *wdt_base;
 
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
1.8.3.4

