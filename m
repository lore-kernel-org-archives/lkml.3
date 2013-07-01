Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3GAIkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:40:04 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46505 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab3GAIkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:40:01 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: devicetree-discuss@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [RFC PATCH 01/13] misc: atmel_ssc: add device tree DMA support
Date: Mon,  1 Jul 2013 10:39:26 +0200
Message-Id: <1372667978-4718-2-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
References: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ssc device has to fill the at_dma_slave structure with the
device tree informations.
Doing a of_dma_request_slave_channel()+dma_release_channel() for that
seems wrong (or at least not very clean).

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/misc/atmel-ssc.c                |   56 +++++++++++++++++++++++++++++++
 include/linux/atmel-ssc.h               |    2 ++
 include/linux/platform_data/dma-atmel.h |    2 ++
 3 files changed, 60 insertions(+)

diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
index f7b90661..3afbd82 100644
--- a/drivers/misc/atmel-ssc.c
+++ b/drivers/misc/atmel-ssc.c
@@ -19,7 +19,9 @@
 #include <linux/module.h>
 
 #include <linux/of.h>
+#include <linux/of_dma.h>
 #include <linux/pinctrl/consumer.h>
+#include <linux/platform_data/dma-atmel.h>
 
 /* Serialize access to ssc_list and user count */
 static DEFINE_SPINLOCK(user_lock);
@@ -127,12 +129,57 @@ static inline const struct atmel_ssc_platform_data * __init
 		platform_get_device_id(pdev)->driver_data;
 }
 
+static int atmel_ssc_get_dma_data(struct device_node *np,
+				  struct at_dma_slave *sdata)
+{
+	struct dma_chan *chan;
+	struct at_dma_slave *rx_data;
+	int err = -1;
+
+	/*
+	 * FIXME: this is clearly not the right way to do it.
+	 * In order to fill struct at_dma_slave with both rx and tx data,
+	 * we request and release both channels.
+	 * Et voila ! We've got all the whole structure !
+	 * upside: it works(R)
+	 * downside: feels wrong, dirty, not optimized...
+	 */
+	chan = of_dma_request_slave_channel(np, "tx");
+	if (!chan)
+		return err;
+
+	if (chan->private)
+		memcpy(sdata, chan->private, sizeof(*sdata));
+	else
+		goto out;
+
+	dma_release_channel(chan);
+
+	chan = of_dma_request_slave_channel(np, "rx");
+	if (!chan)
+		goto out;
+
+	if (chan->private) {
+		rx_data = chan->private;
+		sdata->cfg &= ~(ATC_SRC_PER_MSB(0xff) | ATC_SRC_PER(0xff));
+		sdata->cfg |= ATC_GET_SRC_ID(rx_data->cfg);
+		err = 0;
+	}
+
+out:
+	if (chan)
+		dma_release_channel(chan);
+
+	return err;
+}
+
 static int ssc_probe(struct platform_device *pdev)
 {
 	struct resource *regs;
 	struct ssc_device *ssc;
 	const struct atmel_ssc_platform_data *plat_dat;
 	struct pinctrl *pinctrl;
+	struct device_node *of = pdev->dev.of_node;
 
 	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
 	if (IS_ERR(pinctrl)) {
@@ -166,6 +213,15 @@ static int ssc_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
+	/* populate platform_data from device tree */
+	if (ssc->pdata && ssc->pdata->use_dma && of) {
+		if (atmel_ssc_get_dma_data(of, &ssc->pdata->dma_slave)) {
+			dev_err(&pdev->dev, "could not get DMA\n");
+			return -EINVAL;
+		}
+	}
+	ssc->pdev->dev.platform_data = &ssc->pdata->dma_slave;
+
 	/* disable all interrupts */
 	clk_prepare_enable(ssc->clk);
 	ssc_writel(ssc->regs, IDR, -1);
diff --git a/include/linux/atmel-ssc.h b/include/linux/atmel-ssc.h
index deb0ae5..80c83ee 100644
--- a/include/linux/atmel-ssc.h
+++ b/include/linux/atmel-ssc.h
@@ -1,12 +1,14 @@
 #ifndef __INCLUDE_ATMEL_SSC_H
 #define __INCLUDE_ATMEL_SSC_H
 
+#include <linux/platform_data/dma-atmel.h>
 #include <linux/platform_device.h>
 #include <linux/list.h>
 #include <linux/io.h>
 
 struct atmel_ssc_platform_data {
 	int			use_dma;
+	struct at_dma_slave	dma_slave;
 };
 
 struct ssc_device {
diff --git a/include/linux/platform_data/dma-atmel.h b/include/linux/platform_data/dma-atmel.h
index e95f19c..0d8b9d6 100644
--- a/include/linux/platform_data/dma-atmel.h
+++ b/include/linux/platform_data/dma-atmel.h
@@ -44,11 +44,13 @@ struct at_dma_slave {
 #define		ATC_SRC_H2SEL_SW	(0x0 <<  9)
 #define		ATC_SRC_H2SEL_HW	(0x1 <<  9)
 #define	ATC_SRC_PER_MSB(h)	(ATC_PER_MSB(h) << 10)	/* Channel src rq (most significant bits) */
+#define ATC_GET_SRC_ID(h) ((((h) >> 6) & 0x3U) | ((h) & 0xFU)) /* Retrieve channel src id */
 #define	ATC_DST_REP		(0x1 << 12)	/* Destination Replay Mod */
 #define	ATC_DST_H2SEL		(0x1 << 13)	/* Destination Handshaking Mod */
 #define		ATC_DST_H2SEL_SW	(0x0 << 13)
 #define		ATC_DST_H2SEL_HW	(0x1 << 13)
 #define	ATC_DST_PER_MSB(h)	(ATC_PER_MSB(h) << 14)	/* Channel dst rq (most significant bits) */
+#define ATC_GET_DST_ID(h) ((((h) >> 10) & 0x3U) | (((h) >> 4) & 0xFU)) /* Retrieve channel dst id */
 #define	ATC_SOD			(0x1 << 16)	/* Stop On Done */
 #define	ATC_LOCK_IF		(0x1 << 20)	/* Interface Lock */
 #define	ATC_LOCK_B		(0x1 << 21)	/* AHB Bus Lock */
-- 
1.7.10.4

