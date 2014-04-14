Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbaDNVxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:53:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54422 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbaDNVxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:53:33 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: devel@driverdev.osuosl.org, Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 3/8] imx-drm: ipu-dmfc: Wait for FIFOs to run empty before disabling
Date: Mon, 14 Apr 2014 23:53:18 +0200
Message-Id: <1397512403-19622-4-git-send-email-p.zabel@pengutronix.de>
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

Disabling the DMFC module while there is still data in the FIFOs could
cause the "new frame before end of frame" error state when the DMFC is
enabled again.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/imx-drm/ipu-v3/ipu-dmfc.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dmfc.c b/drivers/staging/imx-drm/ipu-v3/ipu-dmfc.c
index 4521301..59f182b 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-dmfc.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-dmfc.c
@@ -28,7 +28,12 @@
 #define DMFC_GENERAL1		0x0014
 #define DMFC_GENERAL2		0x0018
 #define DMFC_IC_CTRL		0x001c
-#define DMFC_STAT		0x0020
+#define DMFC_WR_CHAN_ALT	0x0020
+#define DMFC_WR_CHAN_DEF_ALT	0x0024
+#define DMFC_DP_CHAN_ALT	0x0028
+#define DMFC_DP_CHAN_DEF_ALT	0x002c
+#define DMFC_GENERAL1_ALT	0x0030
+#define DMFC_STAT		0x0034
 
 #define DMFC_WR_CHAN_1_28		0
 #define DMFC_WR_CHAN_2_41		8
@@ -133,6 +138,20 @@ int ipu_dmfc_enable_channel(struct dmfc_channel *dmfc)
 }
 EXPORT_SYMBOL_GPL(ipu_dmfc_enable_channel);
 
+static void ipu_dmfc_wait_fifos(struct ipu_dmfc_priv *priv)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
+
+	while ((readl(priv->base + DMFC_STAT) & 0x02fff000) != 0x02fff000) {
+		if (time_after(jiffies, timeout)) {
+			dev_warn(priv->dev,
+				 "Timeout waiting for DMFC FIFOs to clear\n");
+			break;
+		}
+		cpu_relax();
+	}
+}
+
 void ipu_dmfc_disable_channel(struct dmfc_channel *dmfc)
 {
 	struct ipu_dmfc_priv *priv = dmfc->priv;
@@ -141,8 +160,10 @@ void ipu_dmfc_disable_channel(struct dmfc_channel *dmfc)
 
 	priv->use_count--;
 
-	if (!priv->use_count)
+	if (!priv->use_count) {
+		ipu_dmfc_wait_fifos(priv);
 		ipu_module_disable(priv->ipu, IPU_CONF_DMFC_EN);
+	}
 
 	if (priv->use_count < 0)
 		priv->use_count = 0;
-- 
1.9.1

