Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaKRKcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:32:48 -0500
Received: from mail-bn1on0141.outbound.protection.outlook.com ([157.56.110.141]:6404
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753683AbaKRKcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:32:41 -0500
From: Yuan Yao <yao.yuan@freescale.com>
To: <wsa@the-dreams.de>, <marex@denx.de>
CC: <LW@KARO-electronics.de>, <mark.rutland@arm.com>,
        <fugang.duan@freescale.com>, <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-i2c@vger.kernel.org>
Subject: [PATCH v11 3/3] i2c: imx: add DMA support for freescale i2c driver
Date: Tue, 18 Nov 2014 18:31:07 +0800
Message-ID: <1416306667-15673-4-git-send-email-yao.yuan@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1416306667-15673-1-git-send-email-yao.yuan@freescale.com>
References: <1416306667-15673-1-git-send-email-yao.yuan@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yao.yuan@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(48376002)(92726001)(104166001)(50986999)(84676001)(21056001)(86362001)(93916002)(92566001)(50226001)(102836001)(36756003)(4396001)(50466002)(31966008)(76176999)(105606002)(97736003)(19580405001)(68736004)(19580395003)(44976005)(120916001)(6806004)(99396003)(107046002)(229853001)(64706001)(106466001)(88136002)(89996001)(46102003)(95666004)(85426001)(20776003)(47776003)(87936001)(87286001)(62966003)(104016003)(77156002)(33646002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB376;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB376;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB376;
X-Forefront-PRVS: 039975700A
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB376;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB183;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dma support for i2c. This function depend on DMA driver.
You can turn on it by write both the dmas and dma-name properties in dts node.
DMA is optional, even DMA request unsuccessfully, i2c can also work well.

Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
---
 drivers/i2c/busses/i2c-imx.c | 335 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 333 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index d025c47..634ee62 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -33,7 +33,11 @@
 *******************************************************************************/
 
 #include <linux/clk.h>
+#include <linux/completion.h>
 #include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmaengine.h>
+#include <linux/dmapool.h>
 #include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/i2c.h>
@@ -44,6 +48,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/of_dma.h>
 #include <linux/platform_data/i2c-imx.h>
 #include <linux/platform_device.h>
 #include <linux/sched.h>
@@ -58,6 +63,15 @@
 /* Default value */
 #define IMX_I2C_BIT_RATE	100000	/* 100kHz */
 
+/*
+ * Enable DMA if transfer byte size is bigger than this threshold.
+ * As the hardware request, it must bigger than 4 bytes.\
+ * I have set '16' here, maybe it's not the best but I think it's
+ * the appropriate.
+ */
+#define DMA_THRESHOLD	16
+#define DMA_TIMEOUT	1000
+
 /* IMX I2C registers:
  * the I2C register offset is different between SoCs,
  * to provid support for all these chips, split the
@@ -83,6 +97,7 @@
 #define I2SR_IBB	0x20
 #define I2SR_IAAS	0x40
 #define I2SR_ICF	0x80
+#define I2CR_DMAEN	0x02
 #define I2CR_RSTA	0x04
 #define I2CR_TXAK	0x08
 #define I2CR_MTX	0x10
@@ -169,6 +184,17 @@ struct imx_i2c_hwdata {
 	unsigned		i2cr_ien_opcode;
 };
 
+struct imx_i2c_dma {
+	struct dma_chan		*chan_tx;
+	struct dma_chan		*chan_rx;
+	struct dma_chan		*chan_using;
+	struct completion	cmd_complete;
+	dma_addr_t		dma_buf;
+	unsigned int		dma_len;
+	enum dma_transfer_direction dma_transfer_dir;
+	enum dma_data_direction dma_data_dir;
+};
+
 struct imx_i2c_struct {
 	struct i2c_adapter	adapter;
 	struct clk		*clk;
@@ -181,6 +207,8 @@ struct imx_i2c_struct {
 	unsigned int		cur_clk;
 	unsigned int		bitrate;
 	const struct imx_i2c_hwdata	*hwdata;
+
+	struct imx_i2c_dma	*dma;
 };
 
 static const struct imx_i2c_hwdata imx1_i2c_hwdata  = {
@@ -251,6 +279,138 @@ static inline unsigned char imx_i2c_read_reg(struct imx_i2c_struct *i2c_imx,
 	return readb(i2c_imx->base + (reg << i2c_imx->hwdata->regshift));
 }
 
+/* Functions for DMA support */
+static void i2c_imx_dma_request(struct imx_i2c_struct *i2c_imx,
+						dma_addr_t phy_addr)
+{
+	struct imx_i2c_dma *dma;
+	struct dma_slave_config dma_sconfig;
+	struct device *dev = &i2c_imx->adapter.dev;
+	int ret;
+
+	dma = devm_kzalloc(dev, sizeof(*dma), GFP_KERNEL);
+	if (!dma)
+		return;
+
+	dma->chan_tx = dma_request_slave_channel(dev, "tx");
+	if (!dma->chan_tx) {
+		dev_dbg(dev, "can't request DMA tx channel\n");
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
+		dev_dbg(dev, "can't configure tx channel\n");
+		goto fail_tx;
+	}
+
+	dma->chan_rx = dma_request_slave_channel(dev, "rx");
+	if (!dma->chan_rx) {
+		dev_dbg(dev, "can't request DMA rx channel\n");
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
+		dev_dbg(dev, "can't configure rx channel\n");
+		goto fail_rx;
+	}
+
+	i2c_imx->dma = dma;
+	init_completion(&dma->cmd_complete);
+	dev_info(dev, "using %s (tx) and %s (rx) for DMA transfers\n",
+		dma_chan_name(dma->chan_tx), dma_chan_name(dma->chan_rx));
+
+	return;
+
+fail_rx:
+	dma_release_channel(dma->chan_rx);
+fail_tx:
+	dma_release_channel(dma->chan_tx);
+fail_al:
+	devm_kfree(dev, dma);
+	dev_info(dev, "can't use DMA\n");
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
+		goto err_map;
+	}
+
+	txdesc = dmaengine_prep_slave_single(dma->chan_using, dma->dma_buf,
+					dma->dma_len, dma->dma_transfer_dir,
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!txdesc) {
+		dev_err(dev, "Not able to get desc for DMA xfer\n");
+		goto err_desc;
+	}
+
+	txdesc->callback = i2c_imx_dma_callback;
+	txdesc->callback_param = i2c_imx;
+	if (dma_submit_error(dmaengine_submit(txdesc))) {
+		dev_err(dev, "DMA submit failed\n");
+		goto err_submit;
+	}
+
+	dma_async_issue_pending(dma->chan_using);
+	return 0;
+
+err_submit:
+err_desc:
+	dma_unmap_single(chan_dev, dma->dma_buf,
+			dma->dma_len, dma->dma_data_dir);
+err_map:
+	return -EINVAL;
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
 
@@ -382,6 +542,7 @@ static int i2c_imx_start(struct imx_i2c_struct *i2c_imx)
 	i2c_imx->stopped = 0;
 
 	temp |= I2CR_IIEN | I2CR_MTX | I2CR_TXAK;
+	temp &= ~I2CR_DMAEN;
 	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
 	return result;
 }
@@ -395,6 +556,8 @@ static void i2c_imx_stop(struct imx_i2c_struct *i2c_imx)
 		dev_dbg(&i2c_imx->adapter.dev, "<%s>\n", __func__);
 		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
 		temp &= ~(I2CR_MSTA | I2CR_MTX);
+		if (i2c_imx->dma)
+			temp &= ~I2CR_DMAEN;
 		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
 	}
 	if (is_imx1_i2c(i2c_imx)) {
@@ -435,6 +598,159 @@ static irqreturn_t i2c_imx_isr(int irq, void *dev_id)
 	return IRQ_NONE;
 }
 
+static int i2c_imx_dma_write(struct imx_i2c_struct *i2c_imx,
+					struct i2c_msg *msgs)
+{
+	int result;
+	unsigned int temp = 0;
+	unsigned long orig_jiffies = jiffies;
+	struct imx_i2c_dma *dma = i2c_imx->dma;
+	struct device *dev = &i2c_imx->adapter.dev;
+
+	dma->chan_using = dma->chan_tx;
+	dma->dma_transfer_dir = DMA_MEM_TO_DEV;
+	dma->dma_data_dir = DMA_TO_DEVICE;
+	dma->dma_len = msgs->len - 1;
+	result = i2c_imx_dma_xfer(i2c_imx, msgs);
+	if (result)
+		return result;
+
+	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+	temp |= I2CR_DMAEN;
+	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
+
+	/*
+	 * Write slave address.
+	 * The first byte must be transmitted by the CPU.
+	 */
+	imx_i2c_write_reg(msgs->addr << 1, i2c_imx, IMX_I2C_I2DR);
+	reinit_completion(&i2c_imx->dma->cmd_complete);
+	result = wait_for_completion_timeout(
+				&i2c_imx->dma->cmd_complete,
+				msecs_to_jiffies(DMA_TIMEOUT));
+	if (result <= 0) {
+		dmaengine_terminate_all(dma->chan_using);
+		return result ?: -ETIMEDOUT;
+	}
+
+	/* Waiting for transfer complete. */
+	while (1) {
+		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
+		if (temp & I2SR_ICF)
+			break;
+		if (time_after(jiffies, orig_jiffies +
+				msecs_to_jiffies(DMA_TIMEOUT))) {
+			dev_dbg(dev, "<%s> Timeout\n", __func__);
+			return -ETIMEDOUT;
+		}
+		schedule();
+	}
+
+	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+	temp &= ~I2CR_DMAEN;
+	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
+
+	/* The last data byte must be transferred by the CPU. */
+	imx_i2c_write_reg(msgs->buf[msgs->len-1],
+				i2c_imx, IMX_I2C_I2DR);
+	result = i2c_imx_trx_complete(i2c_imx);
+	if (result)
+		return result;
+
+	result = i2c_imx_acked(i2c_imx);
+	if (result)
+		return result;
+
+	return 0;
+}
+
+static int i2c_imx_dma_read(struct imx_i2c_struct *i2c_imx,
+			struct i2c_msg *msgs, bool is_lastmsg)
+{
+	int result;
+	unsigned int temp;
+	unsigned long orig_jiffies = jiffies;
+	struct imx_i2c_dma *dma = i2c_imx->dma;
+	struct device *dev = &i2c_imx->adapter.dev;
+
+	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+	temp |= I2CR_DMAEN;
+	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
+
+	dma->chan_using = dma->chan_rx;
+	dma->dma_transfer_dir = DMA_DEV_TO_MEM;
+	dma->dma_data_dir = DMA_FROM_DEVICE;
+	/* The last two data bytes must be transferred by the CPU. */
+	dma->dma_len = msgs->len - 2;
+	result = i2c_imx_dma_xfer(i2c_imx, msgs);
+	if (result)
+		return result;
+
+	reinit_completion(&i2c_imx->dma->cmd_complete);
+	result = wait_for_completion_timeout(
+				&i2c_imx->dma->cmd_complete,
+				msecs_to_jiffies(DMA_TIMEOUT));
+	if (result <= 0) {
+		dmaengine_terminate_all(dma->chan_using);
+		return result ?: -ETIMEDOUT;
+	}
+
+	/* waiting for transfer complete. */
+	while (1) {
+		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
+		if (temp & I2SR_ICF)
+			break;
+		if (time_after(jiffies, orig_jiffies +
+				msecs_to_jiffies(DMA_TIMEOUT))) {
+			dev_dbg(dev, "<%s> Timeout\n", __func__);
+			return -ETIMEDOUT;
+		}
+		schedule();
+	}
+
+	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+	temp &= ~I2CR_DMAEN;
+	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
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
+	if (is_lastmsg) {
+		/*
+		 * It must generate STOP before read I2DR to prevent
+		 * controller from generating another clock cycle
+		 */
+		dev_dbg(dev, "<%s> clear MSTA\n", __func__);
+		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+		temp &= ~(I2CR_MSTA | I2CR_MTX);
+		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
+		i2c_imx_bus_busy(i2c_imx, 0);
+		i2c_imx->stopped = 1;
+	} else {
+		/*
+		 * For i2c master receiver repeat restart operation like:
+		 * read -> repeat MSTA -> read/write
+		 * The controller must set MTX before read the last byte in
+		 * the first read operation, otherwise the first read cost
+		 * one extra clock cycle.
+		 */
+		temp = readb(i2c_imx->base + IMX_I2C_I2CR);
+		temp |= I2CR_MTX;
+		writeb(temp, i2c_imx->base + IMX_I2C_I2CR);
+	}
+	msgs->buf[msgs->len-1] = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
+
+	return 0;
+}
+
 static int i2c_imx_write(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs)
 {
 	int i, result;
@@ -504,6 +820,9 @@ static int i2c_imx_read(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs, bo
 
 	dev_dbg(&i2c_imx->adapter.dev, "<%s> read data\n", __func__);
 
+	if (i2c_imx->dma && msgs->len >= DMA_THRESHOLD && !block_data)
+		return i2c_imx_dma_read(i2c_imx, msgs, is_lastmsg);
+
 	/* read data */
 	for (i = 0; i < msgs->len; i++) {
 		u8 len = 0;
@@ -618,8 +937,12 @@ static int i2c_imx_xfer(struct i2c_adapter *adapter,
 #endif
 		if (msgs[i].flags & I2C_M_RD)
 			result = i2c_imx_read(i2c_imx, &msgs[i], is_lastmsg);
-		else
-			result = i2c_imx_write(i2c_imx, &msgs[i]);
+		else {
+			if (i2c_imx->dma && msgs[i].len >= DMA_THRESHOLD)
+				result = i2c_imx_dma_write(i2c_imx, &msgs[i]);
+			else
+				result = i2c_imx_write(i2c_imx, &msgs[i]);
+		}
 		if (result)
 			goto fail0;
 	}
@@ -654,6 +977,7 @@ static int i2c_imx_probe(struct platform_device *pdev)
 	struct imxi2c_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	void __iomem *base;
 	int irq, ret;
+	dma_addr_t phy_addr;
 
 	dev_dbg(&pdev->dev, "<%s>\n", __func__);
 
@@ -668,6 +992,7 @@ static int i2c_imx_probe(struct platform_device *pdev)
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
+	phy_addr = (dma_addr_t)res->start;
 	i2c_imx = devm_kzalloc(&pdev->dev, sizeof(*i2c_imx), GFP_KERNEL);
 	if (!i2c_imx)
 		return -ENOMEM;
@@ -742,6 +1067,9 @@ static int i2c_imx_probe(struct platform_device *pdev)
 		i2c_imx->adapter.name);
 	dev_info(&i2c_imx->adapter.dev, "IMX I2C adapter registered\n");
 
+	/* Init DMA config if support*/
+	i2c_imx_dma_request(i2c_imx, phy_addr);
+
 	return 0;   /* Return OK */
 
 clk_disable:
@@ -757,6 +1085,9 @@ static int i2c_imx_remove(struct platform_device *pdev)
 	dev_dbg(&i2c_imx->adapter.dev, "adapter removed\n");
 	i2c_del_adapter(&i2c_imx->adapter);
 
+	if (i2c_imx->dma)
+		i2c_imx_dma_free(i2c_imx);
+
 	/* setup chip registers to defaults */
 	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IADR);
 	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IFDR);
-- 
2.1.0.27.g96db324

