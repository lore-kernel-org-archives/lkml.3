Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab3BKPom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:44:42 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41936 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab3BKPol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:44:41 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <b-cousson@ti.com>, <balbi@ti.com>, <rogerq@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>, Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 1/2] ARM: OMAP2+: Allow clock alias provision from device tree
Date: Mon, 11 Feb 2013 17:44:23 +0200
Message-ID: <1360597464-8491-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently on OMAP, it is not possible to specify a clock consumer
to any of the OMAP generated clocks using the device tree. This can pose
a problem for external devices that run off an OMAP clock as we
can't reliably provide a reference to the clock in the device tree.

This patch allows device trees to provide a node that contains the
clock identifier, clock alias and the device phandle. The board
initialization code then creates a clock alias to this clock id,
and associates it with the device whose phandle was supplied.

Discussion
http://www.spinics.net/lists/linux-omap/msg86241.html

CC: Russell King <linux@arm.linux.org.uk>
CC: Rajendra Nayak <rnayak@ti.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 .../devicetree/bindings/clock/ti-clock-alias.txt   |   26 ++++++++
 arch/arm/mach-omap2/board-generic.c                |   67 ++++++++++++++++++++
 2 files changed, 93 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/ti-clock-alias.txt

diff --git a/Documentation/devicetree/bindings/clock/ti-clock-alias.txt b/Documentation/devicetree/bindings/clock/ti-clock-alias.txt
new file mode 100644
index 0000000..87ef4c3
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/ti-clock-alias.txt
@@ -0,0 +1,26 @@
+* Clock alias provision for TI OMAP2+ boards
+
+This binding allows the board's device tree file to specify a clock name,
+device phandle and clock alias so that that clock can be associated
+to the device with the alias.
+
+This is required in cases where an external device is clocked by an
+OMAP generated clock and needs to be assocated to it.
+
+NOTE: The node's name should be clock_alias
+
+Required properties
+- clock-name: The clock identifier string. Should be one of the
+  clock ids defined in OMAP common clock data.
+- clock-alias: A string specifying the alias that must be created to the clock.
+- device: A phandle to the device this clock should be associated to.
+
+e.g. On the OMAP4 Panda board, the USB PHY device is clocked by the
+FREF_CLK3 (auxclk3_ck) from the OMAP. The PHY driver expexts the clock to
+be named "main_clk". This binding can be provided like so
+
+clock_alias {
+	clock-name = "auxclk3_ck";
+	clock-alias = "main_clk";
+	device = <&hsusb1_phy>;
+};
diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 53cb380b..a4b8813 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -15,6 +15,9 @@
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/irqdomain.h>
+#include <linux/clk.h>
+#include <linux/string.h>
+#include <linux/slab.h>
 
 #include <asm/hardware/gic.h>
 #include <asm/mach/arch.h>
@@ -36,12 +39,76 @@ static struct of_device_id omap_dt_match_table[] __initdata = {
 	{ }
 };
 
+static int __init omap_create_clk_alias(struct device_node *np)
+{
+	int ret = 0;
+	const char *s, *alias;
+	char *clk_id;
+	struct device_node *dev_np;
+	struct platform_device *pdev;
+
+	of_property_read_string(np, "clock-name", &s);
+	if (!s) {
+		pr_err("%s: couldn't find clock-name property in node %s\n",
+				__func__, np->name);
+		return -ENODEV;
+	}
+
+	clk_id = kstrdup(s, GFP_KERNEL);
+	if (!clk_id)
+		return -ENOMEM;
+
+	dev_np = of_parse_phandle(np, "device", 0);
+	if (!dev_np) {
+		pr_err("%s: couldn't find device phandle for \'%s\'\n",
+				__func__, clk_id);
+		ret = -ENODEV;
+		goto exit;
+	}
+
+	pdev = of_find_device_by_node(dev_np);
+	if (!pdev) {
+		pr_err("%s: couldn't find device for clock \'%s\'\n",
+				__func__, clk_id);
+		ret = -ENODEV;
+		goto exit;
+	}
+
+	ret = of_property_read_string(np, "clock-alias", &alias);
+	if (ret) {
+		pr_err("%s: couldn't find alias for clock \'%s\'\n",
+				__func__, clk_id);
+		ret = -ENODEV;
+		goto exit;
+	}
+
+	ret = clk_add_alias(alias, dev_name(&pdev->dev), clk_id, NULL);
+	if (ret) {
+		pr_err("%s: couldn't add alias \'%s\' to clock \'%s\'\n",
+				__func__, alias, clk_id);
+		ret = -ENODEV;
+		goto exit;
+	}
+
+exit:
+	kfree(clk_id);
+	return ret;
+}
+
 static void __init omap_generic_init(void)
 {
+	struct device_node *np;
+
 	omap_sdrc_init(NULL, NULL);
 
 	of_platform_populate(NULL, omap_dt_match_table, NULL, NULL);
 
+	/* create clock aliases based on 'clock_alias' nodes */
+	for_each_node_by_name(np, "clock_alias") {
+		omap_create_clk_alias(np);
+		of_node_put(np);
+	}
+
 	/*
 	 * HACK: call display setup code for selected boards to enable omapdss.
 	 * This will be removed when omapdss supports DT.
-- 
1.7.4.1

