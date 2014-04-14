Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbaDNVxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:53:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54423 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbaDNVxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:53:33 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: devel@driverdev.osuosl.org, Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 6/8] imx-drm: imx-dp: When disabling the DP foreground channel, wait until the DP background channel is finished before disabling the IDMAC channel
Date: Mon, 14 Apr 2014 23:53:21 +0200
Message-Id: <1397512403-19622-7-git-send-email-p.zabel@pengutronix.de>
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
 drivers/staging/imx-drm/ipu-v3/ipu-dp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dp.c b/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
index 6980fa1..d90f82a 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
@@ -277,6 +277,9 @@ void ipu_dp_disable_channel(struct ipu_dp *dp)
 	writel(0, flow->base + DP_FG_POS);
 	ipu_srm_dp_sync_update(priv->ipu);
 
+	if (ipu_idmac_channel_busy(priv->ipu, IPUV3_CHANNEL_MEM_BG_SYNC))
+		ipu_wait_interrupt(priv->ipu, IPU_IRQ_DP_SF_END, 50);
+
 	mutex_unlock(&priv->mutex);
 }
 EXPORT_SYMBOL_GPL(ipu_dp_disable_channel);
-- 
1.9.1

