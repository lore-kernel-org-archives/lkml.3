Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab3GATeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:34:50 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44578 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab3GATes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:34:48 -0400
From: Luciano Coelho <coelho@ti.com>
To: <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <--linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [RFC] wlcore: sdio: add wilink clock providers
Date: Mon, 1 Jul 2013 22:34:10 +0300
Message-ID: <1372707250-11998-1-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add refclock and tcxoclock as clock providers in WiLink.  These clocks
are not accesible outside the WiLink module, but they are registered
in the clock framework anyway.  Only the WiLink chip consumes these
clocks.

In theory, the WiLink chip could be connected to external clocks
instead of using these internal clocks, so make the clock consumer
code generic enough.  If external clocks are used, then the internal
clock device tree nodes are not necessary, but the external ones must
be specified.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---

Hi,

I came up with this code, trying to make the WiLink clocks definitions
as generic as possible and use existing fixed-clock bindings.  This
looks relatively clean to me, even though it adds some complexity.
But I think it's better than the original bindings I had defined.

I still need to take care of the XTAL/not-XTAl boolean, but I will do
that separately.

This patch will be split (to take away the Panda DTS part) and
squashed in other patches in my series.

Please let me know what you think.

--
Cheers,
Luca.

 arch/arm/boot/dts/omap4-panda-common.dtsi |   16 ++++++++---
 drivers/net/wireless/ti/wlcore/sdio.c     |   43 ++++++++++++++++++++++++++---
 2 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
index 670c3ce..7f061b8 100644
--- a/arch/arm/boot/dts/omap4-panda-common.dtsi
+++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
@@ -65,11 +65,19 @@
 		enable-active-high;
 	};
 
+
 	wlan {
-	     compatible = "ti,wilink6";
-	     interrupt-parent = <&gpio2>;
-	     interrupts = <21 0x4>;	/* gpio line 53, high level triggered */
-	     refclock = <2>;		/* 38.4 MHz */
+		compatible = "ti,wilink6";
+		interrupt-parent = <&gpio2>;
+		interrupts = <21 0x4>;	/* gpio line 53, high level triggered */
+		clocks = <&refclock>;
+		clock-names = "refclock";
+
+		refclock: refclock {
+			compatible = "ti,wilink-clock";
+			#clock-cells = <0>;
+			clock-frequency = <38400000>;
+		};
 	 };
 };
 
diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 5b08620..60fce49 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -34,6 +34,7 @@
 #include <linux/wl12xx.h>
 #include <linux/pm_runtime.h>
 #include <linux/printk.h>
+#include <linux/clk-provider.h>
 
 #include "wlcore.h"
 #include "wl12xx_80211.h"
@@ -52,6 +53,7 @@ static bool dump = false;
 struct wl12xx_sdio_glue {
 	struct device *dev;
 	struct platform_device *core;
+	struct clk *refclock, *tcxoclock;
 };
 
 static const struct sdio_device_id wl1271_devices[] = {
@@ -214,10 +216,16 @@ static struct wl1271_if_operations sdio_ops = {
 	.set_block_size = wl1271_sdio_set_block_size,
 };
 
+static const struct of_device_id wlcore_sdio_of_clk_match_table[] = {
+	{ .compatible = "ti,wilink-clock" },
+};
+
 static struct wl12xx_platform_data *wlcore_get_pdata_from_of(struct device *dev)
 {
 	struct wl12xx_platform_data *pdata;
 	struct device_node *np = dev->of_node;
+	struct device_node *clock_node;
+	struct wl12xx_sdio_glue *glue = sdio_get_drvdata(dev_to_sdio_func(dev));
 
 	if (!np) {
 		np = of_find_matching_node(NULL, dev->driver->of_match_table);
@@ -241,11 +249,28 @@ static struct wl12xx_platform_data *wlcore_get_pdata_from_of(struct device *dev)
 		goto out_free;
 	}
 
+	for_each_matching_node(clock_node, wlcore_sdio_of_clk_match_table)
+		of_fixed_clk_setup(clock_node);
+
 	/* TODO: make sure we have this when needed (ie. for WL6 and WL7) */
-	of_property_read_u32(np, "refclock", &pdata->ref_clock_freq);
+	glue->refclock = of_clk_get_by_name(np, "refclock");
+	if (IS_ERR(glue->refclock)) {
+		dev_err(dev, "couldn't find refclock on the device tree\n");
+		glue->refclock = NULL;
+	} else {
+		clk_prepare_enable(glue->refclock);
+		pdata->ref_clock_freq = clk_get_rate(glue->refclock);
+	}
 
 	/* TODO: make sure we have this when needed (ie. for WL7) */
-	of_property_read_u32(np, "tcxoclock", &pdata->tcxo_clock_freq);
+	glue->tcxoclock = of_clk_get_by_name(np, "tcxoclock");
+	if (IS_ERR(glue->tcxoclock)) {
+		dev_err(dev, "couldn't find tcxoclock on the device tree\n");
+		glue->tcxoclock = NULL;
+	} else {
+		clk_prepare_enable(glue->tcxoclock);
+		pdata->ref_clock_freq = clk_get_rate(glue->tcxoclock);
+	}
 
 	goto out;
 
@@ -291,6 +316,8 @@ static int wl1271_probe(struct sdio_func *func,
 	/* Use block mode for transferring over one block size of data */
 	func->card->quirks |= MMC_QUIRK_BLKSZ_FOR_BYTE_MODE;
 
+	sdio_set_drvdata(func, glue);
+
 	/* The pdata allocated here is freed when the device is freed,
 	 * so we don't need an additional out label to free it in case
 	 * of error further on.
@@ -316,8 +343,6 @@ static int wl1271_probe(struct sdio_func *func,
 	if (mmcflags & MMC_PM_KEEP_POWER)
 		pdev_data->pwr_in_suspend = true;
 
-	sdio_set_drvdata(func, glue);
-
 	/* Tell PM core that we don't need the card to be powered now */
 	pm_runtime_put_noidle(&func->dev);
 
@@ -384,6 +409,16 @@ static void wl1271_remove(struct sdio_func *func)
 {
 	struct wl12xx_sdio_glue *glue = sdio_get_drvdata(func);
 
+	if (glue->refclock) {
+		clk_disable_unprepare(glue->refclock);
+		clk_put(glue->refclock);
+	}
+
+	if (glue->tcxoclock) {
+		clk_disable_unprepare(glue->tcxoclock);
+		clk_put(glue->tcxoclock);
+	}
+
 	/* Undo decrement done above in wl1271_probe */
 	pm_runtime_get_noresume(&func->dev);
 
-- 
1.7.10.4

