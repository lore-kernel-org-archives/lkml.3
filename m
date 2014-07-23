Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbaGWJML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:12:11 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:35348
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757698AbaGWJME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:12:04 -0400
From: Yuan Yao <yao.yuan@freescale.com>
To: <wsa@the-dreams.de>, <marex@denx.de>
CC: <mark.rutland@arm.com>, <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-i2c@vger.kernel.org>
Subject: [PATCH v5 1/2] i2c: add DMA support for freescale i2c driver
Date: Wed, 23 Jul 2014 16:24:42 +0800
Message-ID: <1406103883-3572-2-git-send-email-yao.yuan@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1406103883-3572-1-git-send-email-yao.yuan@freescale.com>
References: <1406103883-3572-1-git-send-email-yao.yuan@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(97736001)(31966008)(93916002)(50466002)(50226001)(85852003)(64706001)(85306003)(4396001)(62966002)(87286001)(77982001)(83072002)(80022001)(79102001)(104166001)(69596002)(68736004)(50986999)(26826002)(88136002)(76176999)(102836001)(89996001)(76482001)(21056001)(104016003)(86362001)(83322001)(81542001)(6806004)(20776003)(36756003)(92566001)(99396002)(92726001)(107046002)(105606002)(84676001)(48376002)(74662001)(47776003)(19580395003)(46102001)(95666004)(87936001)(229853001)(19580405001)(106466001)(74502001)(77156001)(81342001)(33646002)(81156004)(44976005);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB569;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yao.yuan@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dma support for i2c. This function depend on DMA driver.
You can turn on it by write both the dmas and dma-name properties in dts node.

Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
---
 drivers/i2c/busses/i2c-imx.c | 377 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 324 insertions(+), 53 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 1d7efa3..a9893c3 100644
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
+	struct completion	cmd_complete;
+	dma_addr_t		dma_buf;
+	unsigned int		dma_len;
+	unsigned int		dma_transfer_dir;
+	unsigned int		dma_data_dir;
+};
+
 struct imx_i2c_struct {
 	struct i2c_adapter	adapter;
 	struct clk		*clk;
@@ -184,6 +205,8 @@ struct imx_i2c_struct {
 	int			stopped;
 	unsigned int		ifdr; /* IMX_I2C_IFDR */
 	const struct imx_i2c_hwdata	*hwdata;
+
+	struct imx_i2c_dma	*dma;
 };
 
 static const struct imx_i2c_hwdata imx1_i2c_hwdata  = {
@@ -254,6 +277,133 @@ static inline unsigned char imx_i2c_read_reg(struct imx_i2c_struct *i2c_imx,
 	return readb(i2c_imx->base + (reg << i2c_imx->hwdata->regshift));
 }
 
+/* Functions for DMA support */
+static int i2c_imx_dma_request(struct imx_i2c_struct *i2c_imx,
+						dma_addr_t phy_addr)
+{
+	struct imx_i2c_dma *dma;
+	struct dma_slave_config dma_sconfig;
+	struct device *dev = &i2c_imx->adapter.dev;
+	int ret;
+
+	dma = devm_kzalloc(dev, sizeof(struct imx_i2c_dma), GFP_KERNEL);
+	if (!dma) {
+		dev_info(dev, "can't allocate DMA struct\n");
+		return -ENOMEM;
+	}
+
+	dma->chan_tx = dma_request_slave_channel(dev, "tx");
+
+	if (!dma->chan_tx) {
+		dev_info(dev, "DMA tx channel request failed\n");
+		ret = -ENODEV;
+		goto fail_al;
+	}
+
+	dma_sconfig.dst_addr = phy_addr +
+				(IMX_I2C_I2DR << i2c_imx->hwdata->regshift);
+	dma_sconfig.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+	dma_sconfig.dst_maxburst = 1;
+	dma_sconfig.direction = DMA_MEM_TO_DEV;
+	ret = dmaengine_slave_config(dma->chan_tx, &dma_sconfig);
+	if (ret < 0) {
+		dev_info(dev, "DMA slave config failed, err = %d\n", ret);
+		goto fail_tx;
+	}
+
+	dma->chan_rx = dma_request_slave_channel(dev, "rx");
+	if (!dma->chan_rx) {
+		dev_info(dev, "DMA rx channel request failed\n");
+		ret = -ENODEV;
+		goto fail_tx;
+	}
+
+	dma_sconfig.src_addr = phy_addr +
+				(IMX_I2C_I2DR << i2c_imx->hwdata->regshift);
+	dma_sconfig.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+	dma_sconfig.src_maxburst = 1;
+	dma_sconfig.direction = DMA_DEV_TO_MEM;
+	ret = dmaengine_slave_config(dma->chan_rx, &dma_sconfig);
+	if (ret < 0) {
+		dev_info(dev, "DMA slave config failed, err = %d\n", ret);
+		goto fail_rx;
+	}
+
+	i2c_imx->dma = dma;
+
+	init_completion(&dma->cmd_complete);
+
+	return 0;
+
+fail_rx:
+	dma_release_channel(dma->chan_rx);
+fail_tx:
+	dma_release_channel(dma->chan_tx);
+fail_al:
+	devm_kfree(dev, dma);
+
+	return ret;
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
+					struct i2c_msg *msgs)
+{
+	struct imx_i2c_dma *dma = i2c_imx->dma;
+	struct dma_async_tx_descriptor *txdesc;
+	struct device *dev = &i2c_imx->adapter.dev;
+	struct device *chan_dev = dma->chan_using->device->dev;
+
+	dma->dma_buf = dma_map_single(chan_dev, msgs->buf,
+					dma->dma_len, dma->dma_data_dir);
+	if (dma_mapping_error(chan_dev, dma->dma_buf)) {
+		dev_err(dev, "DMA mapping failed\n");
+		return -EINVAL;
+	}
+
+	txdesc = dmaengine_prep_slave_single(dma->chan_using, dma->dma_buf,
+					dma->dma_len, dma->dma_transfer_dir,
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!txdesc) {
+		dev_err(dev, "Not able to get desc for DMA xfer\n");
+		dma_unmap_single(chan_dev, dma->dma_buf,
+					dma->dma_len, dma->dma_data_dir);
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
+
+	dma->dma_buf = 0;
+	dma->dma_len = 0;
+
+	dma_release_channel(dma->chan_tx);
+	dma->chan_tx = NULL;
+
+	dma_release_channel(dma->chan_rx);
+	dma->chan_rx = NULL;
+
+	dma->chan_using = NULL;
+}
+
 /** Functions for IMX I2C adapter driver ***************************************
 *******************************************************************************/
 
@@ -332,6 +482,11 @@ static int i2c_imx_start(struct imx_i2c_struct *i2c_imx)
 
 	temp |= I2CR_IIEN | I2CR_MTX | I2CR_TXAK;
 	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
+
+	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+	temp &= ~I2CR_DMAEN;
+	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
+
 	return result;
 }
 
@@ -425,44 +580,104 @@ static irqreturn_t i2c_imx_isr(int irq, void *dev_id)
 
 static int i2c_imx_write(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs)
 {
-	int i, result;
+	int i, result, timeout = IMX_I2C_DMA_TIMEOUT;
+	unsigned int temp = 0;
+	struct imx_i2c_dma *dma = i2c_imx->dma;
+	struct device *dev = &i2c_imx->adapter.dev;
 
-	dev_dbg(&i2c_imx->adapter.dev, "<%s> write slave address: addr=0x%x\n",
+	dev_dbg(dev, "<%s> write slave address: addr=0x%x\n",
 		__func__, msgs->addr << 1);
+	if (dma && msgs->len >= IMX_I2C_DMA_THRESHOLD) {
+		reinit_completion(&i2c_imx->dma->cmd_complete);
+		dma->chan_using = dma->chan_tx;
+		dma->dma_transfer_dir = DMA_MEM_TO_DEV;
+		dma->dma_data_dir = DMA_TO_DEVICE;
+		dma->dma_len = msgs->len - 1;
+		result = i2c_imx_dma_xfer(i2c_imx, msgs);
+		if (result)
+			return result;
 
-	/* write slave address */
-	imx_i2c_write_reg(msgs->addr << 1, i2c_imx, IMX_I2C_I2DR);
-	result = i2c_imx_trx_complete(i2c_imx);
-	if (result)
-		return result;
-	result = i2c_imx_acked(i2c_imx);
-	if (result)
-		return result;
-	dev_dbg(&i2c_imx->adapter.dev, "<%s> write data\n", __func__);
+		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+		temp |= I2CR_DMAEN;
+		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
 
-	/* write data */
-	for (i = 0; i < msgs->len; i++) {
-		dev_dbg(&i2c_imx->adapter.dev,
-			"<%s> write byte: B%d=0x%X\n",
-			__func__, i, msgs->buf[i]);
-		imx_i2c_write_reg(msgs->buf[i], i2c_imx, IMX_I2C_I2DR);
+		/*
+		 * Write slave address.
+		 * The first byte muse be transmitted by the CPU.
+		 */
+		imx_i2c_write_reg(msgs->addr << 1, i2c_imx, IMX_I2C_I2DR);
+		result = wait_for_completion_interruptible_timeout(
+					&i2c_imx->dma->cmd_complete,
+					msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT));
+		if (result <= 0) {
+			dmaengine_terminate_all(dma->chan_using);
+			if (result)
+				return result;
+			else
+				return -ETIMEDOUT;
+		}
+
+		/* Waiting for Transfer complete. */
+		while (timeout--) {
+			temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
+			if (temp & I2SR_ICF)
+				break;
+			udelay(10);
+		}
+
+		if (!timeout)
+			return -ETIMEDOUT;
+		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+		temp &= ~I2CR_DMAEN;
+		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
+
+		/* The last data byte must be transferred by the CPU. */
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
+		dev_dbg(dev, "<%s> write data\n", __func__);
+
+		/* write data */
+		for (i = 0; i < msgs->len; i++) {
+			dev_dbg(dev, "<%s> write byte: B%d=0x%X\n",
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
+	struct device *dev = &i2c_imx->adapter.dev;
 
-	dev_dbg(&i2c_imx->adapter.dev,
-		"<%s> write slave address: addr=0x%x\n",
+	dev_dbg(dev, "<%s> write slave address: addr=0x%x\n",
 		__func__, (msgs->addr << 1) | 0x01);
 
 	/* write slave address */
@@ -474,7 +689,7 @@ static int i2c_imx_read(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs)
 	if (result)
 		return result;
 
-	dev_dbg(&i2c_imx->adapter.dev, "<%s> setup bus\n", __func__);
+	dev_dbg(dev, "<%s> setup bus\n", __func__);
 
 	/* setup bus to read data */
 	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
@@ -484,35 +699,82 @@ static int i2c_imx_read(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs)
 	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
 	imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR); /* dummy read */
 
-	dev_dbg(&i2c_imx->adapter.dev, "<%s> read data\n", __func__);
+	dev_dbg(dev, "<%s> read data\n", __func__);
 
-	/* read data */
-	for (i = 0; i < msgs->len; i++) {
-		result = i2c_imx_trx_complete(i2c_imx);
+	if (dma && msgs->len >= IMX_I2C_DMA_THRESHOLD) {
+		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+		temp |= I2CR_DMAEN;
+		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
+
+		reinit_completion(&i2c_imx->dma->cmd_complete);
+		dma->chan_using = dma->chan_rx;
+		dma->dma_transfer_dir = DMA_DEV_TO_MEM;
+		dma->dma_data_dir = DMA_FROM_DEVICE;
+		/* The last two data bytes must be transferred by the CPU. */
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
-			dev_dbg(&i2c_imx->adapter.dev,
-				"<%s> set TXAK\n", __func__);
-			temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
-			temp |= I2CR_TXAK;
-			imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
+
+		result = wait_for_completion_interruptible_timeout(
+					&i2c_imx->dma->cmd_complete,
+					msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT));
+		if (result <= 0) {
+			dmaengine_terminate_all(dma->chan_using);
+			if (result)
+				return result;
+			else
+				return -ETIMEDOUT;
 		}
-		msgs->buf[i] = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
-		dev_dbg(&i2c_imx->adapter.dev,
-			"<%s> read byte: B%d=0x%X\n",
-			__func__, i, msgs->buf[i]);
+
+		/* waiting for Transfer complete. */
+		while (timeout--) {
+			temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
+			if (temp & I2SR_ICF)
+				break;
+			udelay(10);
+		}
+
+		if (!timeout)
+			return -ETIMEDOUT;
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
+			dev_dbg(dev, "<%s> read byte: B%d=0x%X\n",
+				__func__, i, msgs->buf[i]);
+		}
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
+	/*
+	 * It must generate STOP before read I2DR to prevent
+	 * controller from generating another clock cycle
+	 */
+	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+	temp &= ~(I2CR_MSTA | I2CR_MTX);
+	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
+	i2c_imx_bus_busy(i2c_imx, 0);
+	i2c_imx->stopped = 1;
+	msgs->buf[msgs->len-1] = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
+
 	return 0;
 }
 
@@ -599,6 +861,7 @@ static int i2c_imx_probe(struct platform_device *pdev)
 	void __iomem *base;
 	int irq, ret;
 	u32 bitrate;
+	u32 phy_addr;
 
 	dev_dbg(&pdev->dev, "<%s>\n", __func__);
 
@@ -609,6 +872,7 @@ static int i2c_imx_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	phy_addr = res->start;
 	base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
@@ -694,6 +958,10 @@ static int i2c_imx_probe(struct platform_device *pdev)
 		i2c_imx->adapter.name);
 	dev_info(&i2c_imx->adapter.dev, "IMX I2C adapter registered\n");
 
+	/* Init DMA config if support*/
+	if (i2c_imx_dma_request(i2c_imx, (dma_addr_t)phy_addr))
+		dev_warn(&pdev->dev, "can't request DMA\n");
+
 	return 0;   /* Return OK */
 }
 
@@ -705,6 +973,9 @@ static int i2c_imx_remove(struct platform_device *pdev)
 	dev_dbg(&i2c_imx->adapter.dev, "adapter removed\n");
 	i2c_del_adapter(&i2c_imx->adapter);
 
+	if (i2c_imx->dma)
+		i2c_imx_dma_free(i2c_imx);
+
 	/* setup chip registers to defaults */
 	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IADR);
 	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IFDR);
-- 
1.8.4

