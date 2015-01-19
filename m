Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbbASLq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 06:46:26 -0500
Received: from www.osadl.org ([62.245.132.105]:44324 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbbASLqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 06:46:25 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Lucas Stach <l.stach@pengutronix.de>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Antoine Schweitzer-Chaput <antoine@schweitzer-chaput.fr>,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH v2] gpu: ipu-v3: wait_for_completion_timeout does not return negative status
Date: Mon, 19 Jan 2015 12:38:11 +0100
Message-Id: <1421667491-8935-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

This fixes up the return value handling and the return type

Patch is against 3.19.0-rc3 -next-20150109                                    
                                                                               
This patch was compiletested with imx_v6_v7_defconfig +                       
CONFIG_RESET_CONTROLLER=y, CONFIG_IMX_IPUV3_CORE=m                            

Incorrect return type reported by Philipp Zabel <p.zabel@pengutronix.de>

 drivers/gpu/ipu-v3/ipu-dc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-dc.c b/drivers/gpu/ipu-v3/ipu-dc.c
index 2326c75..508c81d 100644
--- a/drivers/gpu/ipu-v3/ipu-dc.c
+++ b/drivers/gpu/ipu-v3/ipu-dc.c
@@ -267,7 +267,8 @@ static irqreturn_t dc_irq_handler(int irq, void *dev_id)
 void ipu_dc_disable_channel(struct ipu_dc *dc)
 {
 	struct ipu_dc_priv *priv = dc->priv;
-	int irq, ret;
+	int irq;
+	unsigned long ret;
 	u32 val;
 
 	/* TODO: Handle MEM_FG_SYNC differently from MEM_BG_SYNC */
@@ -282,7 +283,7 @@ void ipu_dc_disable_channel(struct ipu_dc *dc)
 	enable_irq(irq);
 	ret = wait_for_completion_timeout(&priv->comp, msecs_to_jiffies(50));
 	disable_irq(irq);
-	if (ret <= 0) {
+	if (ret == 0) {
 		dev_warn(priv->dev, "DC stop timeout after 50 ms\n");
 
 		val = readl(dc->base + DC_WR_CH_CONF);
-- 
1.7.10.4

