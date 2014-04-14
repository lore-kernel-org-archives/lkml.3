Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbaDNVyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:54:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54452 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbaDNVxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:53:39 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: devel@driverdev.osuosl.org, Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 4/8] imx-drm: ipu-dc: Wait for DC_FC_1 / DP_SF_END interrupt
Date: Mon, 14 Apr 2014 23:53:19 +0200
Message-Id: <1397512403-19622-5-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397512403-19622-1-git-send-email-p.zabel@pengutronix.de>
References: <1397512403-19622-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wait for the DC Frame Complete or DP Sync Flow End interrupts
before disabling DC channels.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Moved disable_irq() out of dc_irq_handler()
---
 drivers/staging/imx-drm/ipu-v3/ipu-dc.c | 71 +++++++++++++++++++++++----------
 1 file changed, 50 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dc.c b/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
index d5de8bb..280e494 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
@@ -18,6 +18,7 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
+#include <linux/interrupt.h>
 #include <linux/io.h>
 
 #include "../imx-drm.h"
@@ -110,6 +111,9 @@ struct ipu_dc_priv {
 	struct device		*dev;
 	struct ipu_dc		channels[IPU_DC_NUM_CHANNELS];
 	struct mutex		mutex;
+	struct completion	comp;
+	int			dc_irq;
+	int			dp_irq;
 };
 
 static void dc_link_event(struct ipu_dc *dc, int event, int addr, int priority)
@@ -239,38 +243,46 @@ void ipu_dc_enable_channel(struct ipu_dc *dc)
 }
 EXPORT_SYMBOL_GPL(ipu_dc_enable_channel);
 
+static irqreturn_t dc_irq_handler(int irq, void *dev_id)
+{
+	struct ipu_dc *dc = dev_id;
+	u32 reg;
+
+	reg = readl(dc->base + DC_WR_CH_CONF);
+	reg &= ~DC_WR_CH_CONF_PROG_TYPE_MASK;
+	writel(reg, dc->base + DC_WR_CH_CONF);
+
+	/* The Freescale BSP kernel clears DIx_COUNTER_RELEASE here */
+
+	complete(&dc->priv->comp);
+	return IRQ_HANDLED;
+}
+
 void ipu_dc_disable_channel(struct ipu_dc *dc)
 {
 	struct ipu_dc_priv *priv = dc->priv;
+	int irq, ret;
 	u32 val;
-	int irq = 0, timeout = 50;
 
+	/* TODO: Handle MEM_FG_SYNC differently from MEM_BG_SYNC */
 	if (dc->chno == 1)
-		irq = IPU_IRQ_DC_FC_1;
+		irq = priv->dc_irq;
 	else if (dc->chno == 5)
-		irq = IPU_IRQ_DP_SF_END;
+		irq = priv->dp_irq;
 	else
 		return;
 
-	/* should wait for the interrupt here */
-	mdelay(50);
+	init_completion(&priv->comp);
+	enable_irq(irq);
+	ret = wait_for_completion_timeout(&priv->comp, msecs_to_jiffies(50));
+	disable_irq(irq);
+	if (ret <= 0) {
+		dev_warn(priv->dev, "DC stop timeout after 50 ms\n");
 
-	if (dc->di == 0)
-		val = 0x00000002;
-	else
-		val = 0x00000020;
-
-	/* Wait for DC triple buffer to empty */
-	while ((readl(priv->dc_reg + DC_STAT) & val) != val) {
-		usleep_range(2000, 20000);
-		timeout -= 2;
-		if (timeout <= 0)
-			break;
+		val = readl(dc->base + DC_WR_CH_CONF);
+		val &= ~DC_WR_CH_CONF_PROG_TYPE_MASK;
+		writel(val, dc->base + DC_WR_CH_CONF);
 	}
-
-	val = readl(dc->base + DC_WR_CH_CONF);
-	val &= ~DC_WR_CH_CONF_PROG_TYPE_MASK;
-	writel(val, dc->base + DC_WR_CH_CONF);
 }
 EXPORT_SYMBOL_GPL(ipu_dc_disable_channel);
 
@@ -340,7 +352,7 @@ int ipu_dc_init(struct ipu_soc *ipu, struct device *dev,
 	struct ipu_dc_priv *priv;
 	static int channel_offsets[] = { 0, 0x1c, 0x38, 0x54, 0x58, 0x5c,
 		0x78, 0, 0x94, 0xb4};
-	int i;
+	int i, ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -361,6 +373,23 @@ int ipu_dc_init(struct ipu_soc *ipu, struct device *dev,
 		priv->channels[i].base = priv->dc_reg + channel_offsets[i];
 	}
 
+	priv->dc_irq = ipu_map_irq(ipu, IPU_IRQ_DC_FC_1);
+	if (!priv->dc_irq)
+		return -EINVAL;
+	ret = devm_request_irq(dev, priv->dc_irq, dc_irq_handler, 0, NULL,
+			       &priv->channels[1]);
+	if (ret < 0)
+		return ret;
+	disable_irq(priv->dc_irq);
+	priv->dp_irq = ipu_map_irq(ipu, IPU_IRQ_DP_SF_END);
+	if (!priv->dp_irq)
+		return -EINVAL;
+	ret = devm_request_irq(dev, priv->dp_irq, dc_irq_handler, 0, NULL,
+			       &priv->channels[5]);
+	if (ret < 0)
+		return ret;
+	disable_irq(priv->dp_irq);
+
 	writel(DC_WR_CH_CONF_WORD_SIZE_24 | DC_WR_CH_CONF_DISP_ID_PARALLEL(1) |
 			DC_WR_CH_CONF_PROG_DI_ID,
 			priv->channels[1].base + DC_WR_CH_CONF);
-- 
1.9.1

