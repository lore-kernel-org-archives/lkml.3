Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaBNBA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 20:00:28 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37462 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaBNA7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:59:18 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 23/27] clocksource: sh_cmt: Add DT support
Date: Fri, 14 Feb 2014 02:00:01 +0100
Message-Id: <1392339605-20691-24-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: devicetree@vger.kernel.org
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 .../devicetree/bindings/timer/renesas,cmt.txt      |  75 +++++++++++++++
 drivers/clocksource/sh_cmt.c                       | 104 +++++++++++++++++----
 2 files changed, 160 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/timer/renesas,cmt.txt

diff --git a/Documentation/devicetree/bindings/timer/renesas,cmt.txt b/Documentation/devicetree/bindings/timer/renesas,cmt.txt
new file mode 100644
index 0000000..28d4ab5
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/renesas,cmt.txt
@@ -0,0 +1,75 @@
+* Renesas R-Car Compare Match Timer (CMT)
+
+The CMT is a multi-channel 16/32/48-bit timer/counter with configurable clock
+inputs and programmable compare match.
+
+Channels share hadware resources but their counter and compare match value are
+independent. A particular CMT instance can implement only a subset of the
+channels supported by the CMT model. Channels indices start from 0 and are
+consecutive.
+
+Required Properties:
+
+  - compatible: must contain one of the following.
+    - "renesas,cmt-32" for the 32-bit CMT
+		(CMT0 on sh7372, sh73a0 and r8a7740)
+    - "renesas,cmt-32-fast" for the 32-bit CMT with fast clock support
+		(CMT[234] on sh7372, sh73a0 and r8a7740)
+    - "renasas,cmt-48" for the 48-bit CMT
+		(CMT1 on sh7372, sh73a0 and r8a7740)
+    - "renesas,cmt-48-gen2" for the second generation 48-bit CMT
+    		(CMT[01] on r8a73a4, r8a7790 and r8a7791)
+
+  - reg: base address and length of the registers block for the timer module.
+  - interrupt-parent, interrupts: interrupt-specifier for the timer, one per
+    channel.
+  - clocks: phandle and clock-specifier pair for the functional clock.
+  - clock-names: must be "fck".
+
+  - #address-cells: must be 1
+  - #size-cells: must be 0
+
+  - renesas,channels-mask: integer bitmask of the channels implemented by the
+    timer instance.
+
+
+Each channel is described by a sub-node named "channel@<idx>", where <idx> is
+the channel index.
+
+Channels Required Properties:
+
+  - reg: the channel index.
+
+Channels Optional Properties:
+
+  - clock-source-rating: rating of the timer as a clock source device.
+  - clock-event-rating: rating of the timer as a clock event device.
+
+
+Example: R8A7790 (R-Car H2) CMT0 node
+
+	CMT0 on R8A7790 implements hardware channels 5 and 6 only and names
+	them channels 0 and 1 in the documentation.
+
+	cmt0: timer@ffca0000 {
+		compatible = "renesas,cmt-48-gen2";
+		reg = <0 0xffca0000 0 0x1004>;
+		interrupt-parent = <&gic>;
+		interrupts = <0 142 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 142 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp1_clks R8A7790_CLK_CMT0>;
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		renesas,channels-mask = <0x60>;
+
+		channel@0 {
+			reg = <0>;
+			clock-event-rating = <80>;
+		};
+		channel@0 {
+			reg = <0>;
+			clock-source-rating = <80>;
+		};
+	};
diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index fe9694b..8e46c40 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -24,6 +24,7 @@
 #include <linux/ioport.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
@@ -918,10 +919,72 @@ static int sh_cmt_map_memory(struct sh_cmt_device *cmt)
 	return 0;
 }
 
+static const struct platform_device_id sh_cmt_id_table[] = {
+	{ "sh-cmt-16", (kernel_ulong_t)&sh_cmt_info[SH_CMT_16BIT] },
+	{ "sh-cmt-32", (kernel_ulong_t)&sh_cmt_info[SH_CMT_32BIT] },
+	{ "sh-cmt-32-fast", (kernel_ulong_t)&sh_cmt_info[SH_CMT_32BIT_FAST] },
+	{ "sh-cmt-48", (kernel_ulong_t)&sh_cmt_info[SH_CMT_48BIT] },
+	{ "sh-cmt-48-gen2", (kernel_ulong_t)&sh_cmt_info[SH_CMT_48BIT_GEN2] },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, sh_cmt_id_table);
+
+static const struct of_device_id sh_cmt_of_table[] = {
+	{ .compatible = "renesas,cmt-32", .data = &sh_cmt_info[SH_CMT_32BIT] },
+	{ .compatible = "renesas,cmt-32-fast", .data = &sh_cmt_info[SH_CMT_32BIT_FAST] },
+	{ .compatible = "renasas,cmt-48", .data = &sh_cmt_info[SH_CMT_48BIT] },
+	{ .compatible = "renesas,cmt-48-gen2", .data = &sh_cmt_info[SH_CMT_48BIT_GEN2] },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, sh_cmt_of_table);
+
+static struct sh_timer_channel_config *
+sh_cmt_parse_dt(struct sh_cmt_device *cmt)
+{
+	struct sh_timer_channel_config *channels;
+	struct sh_timer_channel_config *channel;
+	struct device_node *np = cmt->pdev->dev.of_node;
+	struct device_node *child;
+	int ret;
+
+	cmt->num_channels = of_get_child_count(np);
+	if (cmt->num_channels == 0)
+		return ERR_PTR(-EINVAL);
+
+	ret = of_property_read_u32(np, "renesas,channels-mask",
+				   &cmt->hw_channels);
+	if (ret < 0)
+		return ERR_PTR(-EINVAL);
+
+	channels = devm_kzalloc(&cmt->pdev->dev, sizeof(*channels), GFP_KERNEL);
+	if (channels == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	channel = channels;
+
+	for_each_child_of_node(np, child) {
+		u32 val;
+
+		ret = of_property_read_u32(child, "reg", &channel->index);
+		if (ret < 0)
+			return ERR_PTR(-EINVAL);
+
+		ret = of_property_read_u32(child, "clock-source-rating", &val);
+		if (ret == 0)
+			channel->clocksource_rating = val;
+		ret = of_property_read_u32(child, "clock-event-rating", &val);
+		if (ret == 0)
+			channel->clockevent_rating = val;
+
+		channel++;
+	}
+
+	return channels;
+}
+
 static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 {
-	struct sh_timer_config *cfg = pdev->dev.platform_data;
-	const struct platform_device_id *id = pdev->id_entry;
+	const struct sh_timer_channel_config *ch_cfg;
 	unsigned int mask;
 	unsigned int i;
 	int ret;
@@ -929,13 +992,28 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 	memset(cmt, 0, sizeof(*cmt));
 	cmt->pdev = pdev;
 
-	if (!cfg) {
+	if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node) {
+		const struct of_device_id *id;
+
+		id = of_match_node(sh_cmt_of_table, pdev->dev.of_node);
+		cmt->info = id->data;
+
+		ch_cfg = sh_cmt_parse_dt(cmt);
+		if (IS_ERR(ch_cfg))
+			return PTR_ERR(ch_cfg);
+	} else if (pdev->dev.platform_data) {
+		struct sh_timer_config *cfg = pdev->dev.platform_data;
+		const struct platform_device_id *id = pdev->id_entry;
+
+		cmt->info = (const struct sh_cmt_info *)id->driver_data;
+		cmt->num_channels = cfg->num_channels;
+		cmt->hw_channels = ~cfg->channels_mask;
+		ch_cfg = cfg->channels;
+	} else {
 		dev_err(&cmt->pdev->dev, "missing platform data\n");
 		return -ENXIO;
 	}
 
-	cmt->info = (const struct sh_cmt_info *)id->driver_data;
-
 	/* Get hold of clock. */
 	cmt->clk = clk_get(&cmt->pdev->dev, NULL);
 	if (IS_ERR(cmt->clk)) {
@@ -953,9 +1031,6 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 		goto err_clk_unprepare;
 
 	/* Allocate and setup the channels. */
-	cmt->num_channels = cfg->num_channels;
-	cmt->hw_channels = ~cfg->channels_mask;
-
 	cmt->channels = kzalloc(cmt->num_channels * sizeof(*cmt->channels),
 				GFP_KERNEL);
 	if (cmt->channels == NULL) {
@@ -966,7 +1041,7 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 	for (i = 0, mask = cmt->hw_channels; i < cmt->num_channels; ++i) {
 		unsigned int hwidx = ffs(mask) - 1;
 
-		ret = sh_cmt_setup_channel(&cmt->channels[i], &cfg->channels[i],
+		ret = sh_cmt_setup_channel(&cmt->channels[i], &ch_cfg[i],
 					   hwidx, cmt);
 		if (ret < 0)
 			goto err_unmap;
@@ -1032,21 +1107,12 @@ static int sh_cmt_remove(struct platform_device *pdev)
 	return -EBUSY; /* cannot unregister clockevent and clocksource */
 }
 
-static const struct platform_device_id sh_cmt_id_table[] = {
-	{ "sh-cmt-16", (kernel_ulong_t)&sh_cmt_info[SH_CMT_16BIT] },
-	{ "sh-cmt-32", (kernel_ulong_t)&sh_cmt_info[SH_CMT_32BIT] },
-	{ "sh-cmt-32-fast", (kernel_ulong_t)&sh_cmt_info[SH_CMT_32BIT_FAST] },
-	{ "sh-cmt-48", (kernel_ulong_t)&sh_cmt_info[SH_CMT_48BIT] },
-	{ "sh-cmt-48-gen2", (kernel_ulong_t)&sh_cmt_info[SH_CMT_48BIT_GEN2] },
-	{ }
-};
-MODULE_DEVICE_TABLE(platform, sh_cmt_id_table);
-
 static struct platform_driver sh_cmt_device_driver = {
 	.probe		= sh_cmt_probe,
 	.remove		= sh_cmt_remove,
 	.driver		= {
 		.name	= "sh_cmt",
+		.of_match_table = of_match_ptr(sh_cmt_of_table),
 	},
 	.id_table	= sh_cmt_id_table,
 };
-- 
1.8.3.2

