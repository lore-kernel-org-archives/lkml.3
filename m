Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbaCEH7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 02:59:31 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:26382
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871AbaCEH70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 02:59:26 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h1155h)
From: Yuan Yao <yao.yuan@freescale.com>
To: <wsa@the-dreams.de>, <marex@denx.de>
CC: <mark.rutland@arm.com>, <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-i2c@vger.kernel.org>
Subject: [PATCH v2 1/2] i2c: add DMA support for freescale i2c driver
Date: Wed, 5 Mar 2014 14:52:31 +0800
Message-ID: <1394002352-8380-2-git-send-email-yao.yuan@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1394002352-8380-1-git-send-email-yao.yuan@freescale.com>
References: <1394002352-8380-1-git-send-email-yao.yuan@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dma support for i2c. This function depend on DMA driver.
You can turn on it by write both the dmas and dma-name properties in dts node.

Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
---
 drivers/i2c/busses/i2c-imx.c | 341 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 293 insertions(+), 48 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index db895fb..c8d5e04 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -37,22 +37,27 @@
 /** Includes *******************************************************************
 *******************************************************************************/
 
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
+#include <linux/clk.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmaengine.h>
+#include <linux/dmapool.h>
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
-#include <linux/delay.h>
 #include <linux/i2c.h>
+#include <linux/init.h>
 #include <linux/io.h>
-#include <linux/sched.h>
-#include <linux/platform_device.h>
-#include <linux/clk.h>
-#include <linux/slab.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/of_dma.h>
 #include <linux/platform_data/i2c-imx.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
 
 /** Defines ********************************************************************
 *******************************************************************************/
@@ -63,6 +68,10 @@
 /* Default value */
 #define IMX_I2C_BIT_RATE	100000	/* 100kHz */
 
+/* enable DMA if transfer byte size is bigger than this threshold */
+#define IMX_I2C_DMA_THRESHOLD	16
+#define IMX_I2C_DMA_TIMEOUT	1000
+
 /* IMX I2C registers:
  * the I2C register offset is different between SoCs,
  * to provid support for all these chips, split the
@@ -88,6 +97,7 @@
 #define I2SR_IBB	0x20
 #define I2SR_IAAS	0x40
 #define I2SR_ICF	0x80
+#define I2CR_DMAEN	0x02
 #define I2CR_RSTA	0x04
 #define I2CR_TXAK	0x08
 #define I2CR_MTX	0x10
@@ -174,6 +184,17 @@ struct imx_i2c_hwdata {
 	unsigned		i2cr_ien_opcode;
 };
 
+struct imx_i2c_dma {
+	struct dma_chan		*chan_tx;
+	struct dma_chan		*chan_rx;
+	struct dma_chan		*chan_using;
+	dma_addr_t		dma_buf;
+	unsigned int		dma_len;
+	unsigned int		dma_transfer_dir;
+	unsigned int		dma_data_dir;
+	struct completion	cmd_complete;
+};
+
 struct imx_i2c_struct {
 	struct i2c_adapter	adapter;
 	struct clk		*clk;
@@ -184,6 +205,9 @@ struct imx_i2c_struct {
 	int			stopped;
 	unsigned int		ifdr; /* IMX_I2C_IFDR */
 	const struct imx_i2c_hwdata	*hwdata;
+
+	bool			use_dma;
+	struct imx_i2c_dma	*dma;
 };
 
 static const struct imx_i2c_hwdata imx1_i2c_hwdata  = {
@@ -254,9 +278,120 @@ static inline unsigned char imx_i2c_read_reg(struct imx_i2c_struct *i2c_imx,
 	return readb(i2c_imx->base + (reg << i2c_imx->hwdata->regshift));
 }
 
+/** Functions for DMA support ************************************************
+******************************************************************************/
+static int i2c_imx_dma_request(struct imx_i2c_struct *i2c_imx, u32 phy_addr)
+{
+	struct imx_i2c_dma *dma = i2c_imx->dma;
+	struct dma_slave_config dma_sconfig;
+	int ret;
+
+	dma->chan_tx = dma_request_slave_channel(&i2c_imx->adapter.dev, "tx");
+	if (!dma->chan_tx) {
+		dev_err(&i2c_imx->adapter.dev,
+				"Dma tx channel request failed!\n");
+		return -ENODEV;
+	}
+
+	dma_sconfig.dst_addr = (dma_addr_t)phy_addr +
+				(IMX_I2C_I2DR << i2c_imx->hwdata->regshift);
+	dma_sconfig.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+	dma_sconfig.dst_maxburst = 1;
+	dma_sconfig.direction = DMA_MEM_TO_DEV;
+	ret = dmaengine_slave_config(dma->chan_tx, &dma_sconfig);
+	if (ret < 0) {
+		dev_err(&i2c_imx->adapter.dev,
+				"Dma slave config failed, err = %d\n", ret);
+		dma_release_channel(dma->chan_tx);
+		return ret;
+	}
+
+	dma->chan_rx = dma_request_slave_channel(&i2c_imx->adapter.dev, "rx");
+	if (!dma->chan_rx) {
+		dev_err(&i2c_imx->adapter.dev,
+				"Dma rx channel request failed!\n");
+		return -ENODEV;
+	}
+
+	dma_sconfig.src_addr = (dma_addr_t)phy_addr +
+				(IMX_I2C_I2DR << i2c_imx->hwdata->regshift);
+	dma_sconfig.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+	dma_sconfig.src_maxburst = 1;
+	dma_sconfig.direction = DMA_DEV_TO_MEM;
+	ret = dmaengine_slave_config(dma->chan_rx, &dma_sconfig);
+	if (ret < 0) {
+		dev_err(&i2c_imx->adapter.dev,
+				"Dma slave config failed, err = %d\n", ret);
+		dma_release_channel(dma->chan_rx);
+		return ret;
+	}
+
+	init_completion(&dma->cmd_complete);
+
+	return 0;
+}
+
+static void i2c_imx_dma_callback(void *arg)
+{
+	struct imx_i2c_struct *i2c_imx = (struct imx_i2c_struct *)arg;
+	struct imx_i2c_dma *dma = i2c_imx->dma;
+
+	dma_unmap_single(dma->chan_using->device->dev, dma->dma_buf,
+			dma->dma_len, dma->dma_data_dir);
+	complete(&dma->cmd_complete);
+}
+
+static int i2c_imx_dma_xfer(struct imx_i2c_struct *i2c_imx,
+				struct i2c_msg *msgs)
+{
+	struct imx_i2c_dma *dma = i2c_imx->dma;
+	struct dma_async_tx_descriptor *txdesc;
+
+	dma->dma_buf = dma_map_single(dma->chan_using->device->dev, msgs->buf,
+					dma->dma_len, dma->dma_data_dir);
+	if (dma_mapping_error(dma->chan_using->device->dev, dma->dma_buf)) {
+		dev_err(&i2c_imx->adapter.dev, "dma_map_single failed\n");
+		return -EINVAL;
+	}
+
+	txdesc = dmaengine_prep_slave_single(dma->chan_using, dma->dma_buf,
+					dma->dma_len, dma->dma_transfer_dir,
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!txdesc) {
+		dev_err(&i2c_imx->adapter.dev,
+				"Not able to get desc for dma xfer\n");
+		return -EINVAL;
+	}
+
+	txdesc->callback = i2c_imx_dma_callback;
+	txdesc->callback_param = i2c_imx;
+	dmaengine_submit(txdesc);
+	dma_async_issue_pending(dma->chan_using);
+
+	return 0;
+}
+
+static void i2c_imx_dma_free(struct imx_i2c_struct *i2c_imx)
+{
+	struct imx_i2c_dma *dma = i2c_imx->dma;
+	struct dma_chan *dma_chan;
+
+	dma->dma_buf = 0;
+	dma->dma_len = 0;
+
+	dma_chan = dma->chan_tx;
+	dma_release_channel(dma_chan);
+	dma->chan_tx = NULL;
+
+	dma_chan = dma->chan_rx;
+	dma_release_channel(dma_chan);
+	dma->chan_rx = NULL;
+
+	dma->chan_using = NULL;
+}
+
 /** Functions for IMX I2C adapter driver ***************************************
 *******************************************************************************/
-
 static int i2c_imx_bus_busy(struct imx_i2c_struct *i2c_imx, int for_busy)
 {
 	unsigned long orig_jiffies = jiffies;
@@ -427,46 +562,98 @@ static irqreturn_t i2c_imx_isr(int irq, void *dev_id)
 
 static int i2c_imx_write(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs)
 {
-	int i, result;
+	int i, result, timeout = IMX_I2C_DMA_TIMEOUT;
+	unsigned int temp = 0;
+	struct imx_i2c_dma *dma = i2c_imx->dma;
 
 	dev_dbg(&i2c_imx->adapter.dev, "<%s> write slave address: addr=0x%x\n",
 		__func__, msgs->addr << 1);
 
-	/* write slave address */
-	imx_i2c_write_reg(msgs->addr << 1, i2c_imx, IMX_I2C_I2DR);
-	result = i2c_imx_trx_complete(i2c_imx);
-	if (result)
-		return result;
-	result = i2c_imx_acked(i2c_imx);
-	if (result)
-		return result;
-	dev_dbg(&i2c_imx->adapter.dev, "<%s> write data\n", __func__);
+	if (i2c_imx->use_dma && msgs->len >= IMX_I2C_DMA_THRESHOLD) {
+		reinit_completion(&i2c_imx->dma->cmd_complete);
+		dma->chan_using = dma->chan_tx;
+		dma->dma_transfer_dir = DMA_MEM_TO_DEV;
+		dma->dma_data_dir = DMA_TO_DEVICE;
+		dma->dma_len = msgs->len - 1;
+		result = i2c_imx_dma_xfer(i2c_imx, msgs);
+		if (result)
+			return result;
 
-	/* write data */
-	for (i = 0; i < msgs->len; i++) {
-		dev_dbg(&i2c_imx->adapter.dev,
-			"<%s> write byte: B%d=0x%X\n",
-			__func__, i, msgs->buf[i]);
-		imx_i2c_write_reg(msgs->buf[i], i2c_imx, IMX_I2C_I2DR);
+		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+		temp |= I2CR_DMAEN;
+		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
+
+		/* write slave address */
+		imx_i2c_write_reg(msgs->addr << 1, i2c_imx, IMX_I2C_I2DR);
+		result = wait_for_completion_interruptible_timeout(
+					&i2c_imx->dma->cmd_complete,
+					msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT));
+		if (result == 0)
+			return  -ETIMEDOUT;
+
+		/* waiting for Transfer complete. */
+		while (timeout--) {
+			temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
+			if (temp & 0x80)
+				break;
+			udelay(10);
+		}
+
+		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+		temp &= ~I2CR_DMAEN;
+		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
+
+		/* write the last byte */
+		imx_i2c_write_reg(msgs->buf[msgs->len-1],
+					i2c_imx, IMX_I2C_I2DR);
 		result = i2c_imx_trx_complete(i2c_imx);
 		if (result)
 			return result;
+
 		result = i2c_imx_acked(i2c_imx);
 		if (result)
 			return result;
+	} else {
+		/* write slave address */
+		imx_i2c_write_reg(msgs->addr << 1, i2c_imx, IMX_I2C_I2DR);
+		result = i2c_imx_trx_complete(i2c_imx);
+		if (result)
+			return result;
+
+		result = i2c_imx_acked(i2c_imx);
+		if (result)
+			return result;
+
+		dev_dbg(&i2c_imx->adapter.dev, "<%s> write data\n", __func__);
+
+		/* write data */
+		for (i = 0; i < msgs->len; i++) {
+			dev_dbg(&i2c_imx->adapter.dev,
+				"<%s> write byte: B%d=0x%X\n",
+				__func__, i, msgs->buf[i]);
+			imx_i2c_write_reg(msgs->buf[i], i2c_imx, IMX_I2C_I2DR);
+			result = i2c_imx_trx_complete(i2c_imx);
+			if (result)
+				return result;
+			result = i2c_imx_acked(i2c_imx);
+			if (result)
+				return result;
+		}
 	}
 	return 0;
 }
 
 static int i2c_imx_read(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs)
 {
-	int i, result;
+	int i, result, timeout = IMX_I2C_DMA_TIMEOUT;
 	unsigned int temp;
+	struct imx_i2c_dma *dma = i2c_imx->dma;
 
 	dev_dbg(&i2c_imx->adapter.dev,
 		"<%s> write slave address: addr=0x%x\n",
 		__func__, (msgs->addr << 1) | 0x01);
 
+
 	/* write slave address */
 	imx_i2c_write_reg((msgs->addr << 1) | 0x01, i2c_imx, IMX_I2C_I2DR);
 	result = i2c_imx_trx_complete(i2c_imx);
@@ -488,33 +675,71 @@ static int i2c_imx_read(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs)
 
 	dev_dbg(&i2c_imx->adapter.dev, "<%s> read data\n", __func__);
 
-	/* read data */
-	for (i = 0; i < msgs->len; i++) {
-		result = i2c_imx_trx_complete(i2c_imx);
+	if (i2c_imx->use_dma && msgs->len >= IMX_I2C_DMA_THRESHOLD) {
+		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+		temp |= I2CR_DMAEN;
+		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
+
+		reinit_completion(&i2c_imx->dma->cmd_complete);
+		dma->chan_using = dma->chan_rx;
+		dma->dma_transfer_dir = DMA_DEV_TO_MEM;
+		dma->dma_data_dir = DMA_FROM_DEVICE;
+		dma->dma_len = msgs->len - 2;
+		result = i2c_imx_dma_xfer(i2c_imx, msgs);
 		if (result)
 			return result;
-		if (i == (msgs->len - 1)) {
-			/* It must generate STOP before read I2DR to prevent
-			   controller from generating another clock cycle */
-			dev_dbg(&i2c_imx->adapter.dev,
-				"<%s> clear MSTA\n", __func__);
-			temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
-			temp &= ~(I2CR_MSTA | I2CR_MTX);
-			imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
-			i2c_imx_bus_busy(i2c_imx, 0);
-			i2c_imx->stopped = 1;
-		} else if (i == (msgs->len - 2)) {
+
+		result = wait_for_completion_interruptible_timeout(
+					&i2c_imx->dma->cmd_complete,
+					msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT));
+		if (result == 0)
+			return  -ETIMEDOUT;
+
+		/* waiting for Transfer complete. */
+		while (timeout--) {
+			temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
+			if (temp & 0x80)
+				break;
+			udelay(10);
+		}
+
+		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+		temp &= ~I2CR_DMAEN;
+		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
+	} else {
+		/* read data */
+		for (i = 0; i < msgs->len - 2; i++) {
+			result = i2c_imx_trx_complete(i2c_imx);
+			if (result)
+				return result;
+			msgs->buf[i] = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
 			dev_dbg(&i2c_imx->adapter.dev,
-				"<%s> set TXAK\n", __func__);
-			temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
-			temp |= I2CR_TXAK;
-			imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
+				"<%s> read byte: B%d=0x%X\n",
+				__func__, i, msgs->buf[i]);
 		}
-		msgs->buf[i] = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
-		dev_dbg(&i2c_imx->adapter.dev,
-			"<%s> read byte: B%d=0x%X\n",
-			__func__, i, msgs->buf[i]);
+		result = i2c_imx_trx_complete(i2c_imx);
 	}
+
+	/* read n-1 byte data */
+	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+	temp |= I2CR_TXAK;
+	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
+
+	msgs->buf[msgs->len-2] = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
+	/* read n byte data */
+	result = i2c_imx_trx_complete(i2c_imx);
+	if (result)
+		return result;
+
+	/* It must generate STOP before read I2DR to prevent
+	   controller from generating another clock cycle */
+	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+	temp &= ~(I2CR_MSTA | I2CR_MTX);
+	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
+	i2c_imx_bus_busy(i2c_imx, 0);
+	i2c_imx->stopped = 1;
+	msgs->buf[msgs->len-1] = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
+
 	return 0;
 }
 
@@ -601,6 +826,7 @@ static int i2c_imx_probe(struct platform_device *pdev)
 	void __iomem *base;
 	int irq, ret;
 	u32 bitrate;
+	u32 phy_addr;
 
 	dev_dbg(&pdev->dev, "<%s>\n", __func__);
 
@@ -611,6 +837,7 @@ static int i2c_imx_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	phy_addr = res->start;
 	base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
@@ -696,6 +923,21 @@ static int i2c_imx_probe(struct platform_device *pdev)
 		i2c_imx->adapter.name);
 	dev_info(&i2c_imx->adapter.dev, "IMX I2C adapter registered\n");
 
+	/* Init DMA config if support*/
+	i2c_imx->dma = devm_kzalloc(&pdev->dev, sizeof(struct imx_i2c_dma),
+					GFP_KERNEL);
+	if (!i2c_imx->dma) {
+		dev_info(&pdev->dev,
+				"can't allocate dma struct faild use dma.\n");
+		i2c_imx->use_dma = false;
+	} else if (i2c_imx_dma_request(i2c_imx, phy_addr)) {
+		dev_info(&pdev->dev,
+				"can't request dma chan, faild use dma.\n");
+		i2c_imx->use_dma = false;
+	} else {
+		i2c_imx->use_dma = true;
+	}
+
 	return 0;   /* Return OK */
 }
 
@@ -707,6 +949,9 @@ static int i2c_imx_remove(struct platform_device *pdev)
 	dev_dbg(&i2c_imx->adapter.dev, "adapter removed\n");
 	i2c_del_adapter(&i2c_imx->adapter);
 
+	if (i2c_imx->use_dma)
+		i2c_imx_dma_free(i2c_imx);
+
 	/* setup chip registers to defaults */
 	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IADR);
 	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IFDR);
-- 
1.8.4


