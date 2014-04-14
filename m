Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbaDNVyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:54:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54454 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515AbaDNVxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:53:40 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: devel@driverdev.osuosl.org, Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 2/8] imx-drm: ipu-common: Add helpers to check for a busy IDMAC channel and to busywait for an interrupt
Date: Mon, 14 Apr 2014 23:53:17 +0200
Message-Id: <1397512403-19622-3-git-send-email-p.zabel@pengutronix.de>
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

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/imx-drm/ipu-v3/ipu-common.c | 22 ++++++++++++++++++++++
 drivers/staging/imx-drm/ipu-v3/ipu-prv.h    |  3 +++
 2 files changed, 25 insertions(+)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index 0585517..8fb4c20 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -697,6 +697,12 @@ int ipu_idmac_enable_channel(struct ipuv3_channel *channel)
 }
 EXPORT_SYMBOL_GPL(ipu_idmac_enable_channel);
 
+bool ipu_idmac_channel_busy(struct ipu_soc *ipu, unsigned int chno)
+{
+	return (ipu_idmac_read(ipu, IDMAC_CHA_BUSY(chno)) & idma_mask(chno));
+}
+EXPORT_SYMBOL_GPL(ipu_idmac_channel_busy);
+
 int ipu_idmac_wait_busy(struct ipuv3_channel *channel, int ms)
 {
 	struct ipu_soc *ipu = channel->ipu;
@@ -714,6 +720,22 @@ int ipu_idmac_wait_busy(struct ipuv3_channel *channel, int ms)
 }
 EXPORT_SYMBOL_GPL(ipu_idmac_wait_busy);
 
+int ipu_wait_interrupt(struct ipu_soc *ipu, int irq, int ms)
+{
+	unsigned long timeout;
+
+	timeout = jiffies + msecs_to_jiffies(ms);
+	ipu_cm_write(ipu, BIT(irq % 32), IPU_INT_STAT(irq / 32));
+	while (!(ipu_cm_read(ipu, IPU_INT_STAT(irq / 32) & BIT(irq % 32)))) {
+		if (time_after(jiffies, timeout))
+			return -ETIMEDOUT;
+		cpu_relax();
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_wait_interrupt);
+
 int ipu_idmac_disable_channel(struct ipuv3_channel *channel)
 {
 	struct ipu_soc *ipu = channel->ipu;
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-prv.h b/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
index 4df0050..bfc1b33 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
@@ -185,6 +185,9 @@ void ipu_srm_dp_sync_update(struct ipu_soc *ipu);
 int ipu_module_enable(struct ipu_soc *ipu, u32 mask);
 int ipu_module_disable(struct ipu_soc *ipu, u32 mask);
 
+bool ipu_idmac_channel_busy(struct ipu_soc *ipu, unsigned int chno);
+int ipu_wait_interrupt(struct ipu_soc *ipu, int irq, int ms);
+
 int ipu_di_init(struct ipu_soc *ipu, struct device *dev, int id,
 		unsigned long base, u32 module, struct clk *ipu_clk);
 void ipu_di_exit(struct ipu_soc *ipu, int id);
-- 
1.9.1

