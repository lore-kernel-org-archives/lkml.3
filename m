Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbaDNVyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:54:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54457 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbaDNVxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:53:40 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: devel@driverdev.osuosl.org, Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 1/8] imx-drm: ipu-common: add ipu_map_irq to request non-IDMAC interrupts
Date: Mon, 14 Apr 2014 23:53:16 +0200
Message-Id: <1397512403-19622-2-git-send-email-p.zabel@pengutronix.de>
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

This allows to request the DC related interrupts.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h |  1 +
 drivers/staging/imx-drm/ipu-v3/ipu-common.c | 19 +++++++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h b/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
index c4d14ea..2966e42 100644
--- a/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
+++ b/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
@@ -76,6 +76,7 @@ enum ipu_channel_irq {
 	IPU_IRQ_EOS = 192,
 };
 
+int ipu_map_irq(struct ipu_soc *ipu, int irq);
 int ipu_idmac_channel_irq(struct ipu_soc *ipu, struct ipuv3_channel *channel,
 		enum ipu_channel_irq irq);
 
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index ca85d3d..0585517 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -933,15 +933,22 @@ static void ipu_err_irq_handler(unsigned int irq, struct irq_desc *desc)
 	chained_irq_exit(chip, desc);
 }
 
-int ipu_idmac_channel_irq(struct ipu_soc *ipu, struct ipuv3_channel *channel,
-		enum ipu_channel_irq irq_type)
+int ipu_map_irq(struct ipu_soc *ipu, int irq)
 {
-	int irq = irq_linear_revmap(ipu->domain, irq_type + channel->num);
+	int virq;
 
-	if (!irq)
-		irq = irq_create_mapping(ipu->domain, irq_type + channel->num);
+	virq = irq_linear_revmap(ipu->domain, irq);
+	if (!virq)
+		virq = irq_create_mapping(ipu->domain, irq);
+
+	return virq;
+}
+EXPORT_SYMBOL_GPL(ipu_map_irq);
 
-	return irq;
+int ipu_idmac_channel_irq(struct ipu_soc *ipu, struct ipuv3_channel *channel,
+		enum ipu_channel_irq irq_type)
+{
+	return ipu_map_irq(ipu, irq_type + channel->num);
 }
 EXPORT_SYMBOL_GPL(ipu_idmac_channel_irq);
 
-- 
1.9.1

