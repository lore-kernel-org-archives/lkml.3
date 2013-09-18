Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab3IRRyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:54:14 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:51192 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab3IRRyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:54:11 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/26] clk: nomadik: move src init out of nomadik_clk_init
Date: Wed, 18 Sep 2013 19:53:35 +0200
Message-Id: <1379526839-14798-3-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nomadik_clk_init currently also maps system reset controller base address
used by clocks and registers a reboot notifier. To allow further cleanup of
nomadik clk setup, this moves system reset controller setup from
nomadik_clk_init to its own function.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Alessandro Rubini <rubini@unipv.it>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: STEricsson <STEricsson_nomadik_linux@list.st.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/clk/clk-nomadik.c |  117 +++++++++++++++++++++++----------------------
 1 file changed, 61 insertions(+), 56 deletions(-)

diff --git a/drivers/clk/clk-nomadik.c b/drivers/clk/clk-nomadik.c
index 51410c2..7849086 100644
--- a/drivers/clk/clk-nomadik.c
+++ b/drivers/clk/clk-nomadik.c
@@ -54,6 +54,66 @@ static DEFINE_SPINLOCK(src_lock);
 /* Base address of the SRC */
 static void __iomem *src_base;
 
+static int nomadik_clk_reboot_handler(struct notifier_block *this,
+				unsigned long code,
+				void *unused)
+{
+	u32 val;
+
+	/* The main chrystal need to be enabled for reboot to work */
+	val = readl(src_base + SRC_XTALCR);
+	val &= ~SRC_XTALCR_MXTALOVER;
+	val |= SRC_XTALCR_MXTALEN;
+	pr_crit("force-enabling MXTALO\n");
+	writel(val, src_base + SRC_XTALCR);
+	return NOTIFY_OK;
+}
+
+static struct notifier_block nomadik_clk_reboot_notifier = {
+	.notifier_call = nomadik_clk_reboot_handler,
+};
+
+static const struct of_device_id nomadik_src_match[] __initconst = {
+	{ .compatible = "stericsson,nomadik-src" },
+	{ /* sentinel */ }
+};
+
+static void __init nomadik_src_init(void)
+{
+	struct device_node *np;
+	u32 val;
+
+	np = of_find_matching_node(NULL, nomadik_src_match);
+	if (!np) {
+		pr_crit("no matching node for SRC, aborting clock init\n");
+		return;
+	}
+	src_base = of_iomap(np, 0);
+	if (!src_base) {
+		pr_err("%s: must have src parent node with REGS (%s)\n",
+		       __func__, np->name);
+		return;
+	}
+	val = readl(src_base + SRC_XTALCR);
+	pr_info("SXTALO is %s\n",
+		(val & SRC_XTALCR_SXTALDIS) ? "disabled" : "enabled");
+	pr_info("MXTAL is %s\n",
+		(val & SRC_XTALCR_MXTALSTAT) ? "enabled" : "disabled");
+	if (of_property_read_bool(np, "disable-sxtalo")) {
+		/* The machine uses an external oscillator circuit */
+		val |= SRC_XTALCR_SXTALDIS;
+		pr_info("disabling SXTALO\n");
+	}
+	if (of_property_read_bool(np, "disable-mxtalo")) {
+		/* Disable this too: also run by external oscillator */
+		val |= SRC_XTALCR_MXTALOVER;
+		val &= ~SRC_XTALCR_MXTALEN;
+		pr_info("disabling MXTALO\n");
+	}
+	writel(val, src_base + SRC_XTALCR);
+	register_reboot_notifier(&nomadik_clk_reboot_notifier);
+}
+
 /**
  * struct clk_pll1 - Nomadik PLL1 clock
  * @hw: corresponding clock hardware entry
@@ -479,11 +539,6 @@ static void __init of_nomadik_src_clk_setup(struct device_node *np)
 		of_clk_add_provider(np, of_clk_src_simple_get, clk);
 }
 
-static const struct of_device_id nomadik_src_match[] __initconst = {
-	{ .compatible = "stericsson,nomadik-src" },
-	{ /* sentinel */ }
-};
-
 static const struct of_device_id nomadik_src_clk_match[] __initconst = {
 	{
 		.compatible = "fixed-clock",
@@ -508,59 +563,9 @@ static const struct of_device_id nomadik_src_clk_match[] __initconst = {
 	{ /* sentinel */ }
 };
 
-static int nomadik_clk_reboot_handler(struct notifier_block *this,
-				unsigned long code,
-				void *unused)
-{
-	u32 val;
-
-	/* The main chrystal need to be enabled for reboot to work */
-	val = readl(src_base + SRC_XTALCR);
-	val &= ~SRC_XTALCR_MXTALOVER;
-	val |= SRC_XTALCR_MXTALEN;
-	pr_crit("force-enabling MXTALO\n");
-	writel(val, src_base + SRC_XTALCR);
-	return NOTIFY_OK;
-}
-
-static struct notifier_block nomadik_clk_reboot_notifier = {
-	.notifier_call = nomadik_clk_reboot_handler,
-};
 
 void __init nomadik_clk_init(void)
 {
-	struct device_node *np;
-	u32 val;
-
-	np = of_find_matching_node(NULL, nomadik_src_match);
-	if (!np) {
-		pr_crit("no matching node for SRC, aborting clock init\n");
-		return;
-	}
-	src_base = of_iomap(np, 0);
-	if (!src_base) {
-		pr_err("%s: must have src parent node with REGS (%s)\n",
-		       __func__, np->name);
-		return;
-	}
-	val = readl(src_base + SRC_XTALCR);
-	pr_info("SXTALO is %s\n",
-		(val & SRC_XTALCR_SXTALDIS) ? "disabled" : "enabled");
-	pr_info("MXTAL is %s\n",
-		(val & SRC_XTALCR_MXTALSTAT) ? "enabled" : "disabled");
-	if (of_property_read_bool(np, "disable-sxtalo")) {
-		/* The machine uses an external oscillator circuit */
-		val |= SRC_XTALCR_SXTALDIS;
-		pr_info("disabling SXTALO\n");
-	}
-	if (of_property_read_bool(np, "disable-mxtalo")) {
-		/* Disable this too: also run by external oscillator */
-		val |= SRC_XTALCR_MXTALOVER;
-		val &= ~SRC_XTALCR_MXTALEN;
-		pr_info("disabling MXTALO\n");
-	}
-	writel(val, src_base + SRC_XTALCR);
-	register_reboot_notifier(&nomadik_clk_reboot_notifier);
-
+	nomadik_src_init();
 	of_clk_init(nomadik_src_clk_match);
 }
-- 
1.7.10.4

