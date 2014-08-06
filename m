Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbaHFCdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 22:33:47 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:20988
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755184AbaHFCdp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 22:33:45 -0400
From: "fugang.duan@freescale.com" <fugang.duan@freescale.com>
To: Yao Yuan <yao.yuan@freescale.com>, "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "marex@denx.de" <marex@denx.de>
CC: "LW@KARO-electronics.de" <LW@KARO-electronics.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "Frank.Li@freescale.com" <Frank.Li@freescale.com>
Subject: RE: [PATCH v6 1/2] i2c: imx: add DMA support for freescale i2c driver
Thread-Topic: [PATCH v6 1/2] i2c: imx: add DMA support for freescale i2c
 driver
Thread-Index: AQHPsJp6xKTt7EIbSUuPcoEni/e+fJvC0RvQ
Date: Wed, 6 Aug 2014 02:33:17 +0000
Message-ID: <41705e1e4c604240ba96333a03d5c544@BLUPR03MB373.namprd03.prod.outlook.com>
References: <1407232563-10856-1-git-send-email-yao.yuan@freescale.com>
 <1407232563-10856-2-git-send-email-yao.yuan@freescale.com>
In-Reply-To: <1407232563-10856-2-git-send-email-yao.yuan@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(51704005)(189002)(199002)(33646002)(74316001)(99396002)(4396001)(46102001)(76482001)(50986999)(54356999)(76176999)(77982001)(79102001)(66066001)(76576001)(80022001)(81542001)(83072002)(85852003)(2201001)(92566001)(87936001)(2656002)(85306004)(107046002)(86362001)(74502001)(74662001)(21056001)(31966008)(101416001)(19580405001)(19580395003)(20776003)(64706001)(95666004)(105586002)(106356001)(99286002)(83322001)(81342001)(106116001)(24736002)(108616003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB485;H:BLUPR03MB373.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:  Yuan Yao<yao.yuan@freescale.com> Data: Tuesday, August 05, 2014 5:56 PM
>To: wsa@the-dreams.de; marex@denx.de
>Cc: LW@KARO-electronics.de; mark.rutland@arm.com; shawn.guo@linaro.org;
>linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
>i2c@vger.kernel.org
>Subject: [PATCH v6 1/2] i2c: imx: add DMA support for freescale i2c driver
>
>Add dma support for i2c. This function depend on DMA driver.
>You can turn on it by write both the dmas and dma-name properties in dts
>node.
>DMA is optional, even DMA request unsuccessfully, i2c can also work well.
>
>Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
>---
> drivers/i2c/busses/i2c-imx.c | 341
>+++++++++++++++++++++++++++++++++++++++++--
> 1 file changed, 331 insertions(+), 10 deletions(-)
>
>diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
>index aa8bc14..60ea946 100644
>--- a/drivers/i2c/busses/i2c-imx.c
>+++ b/drivers/i2c/busses/i2c-imx.c
>@@ -37,22 +37,27 @@
> /** Includes
>*******************************************************************
>
>**************************************************************************
>*****/
[...]

>+/* Functions for DMA support */
>+static int i2c_imx_dma_request(struct imx_i2c_struct *i2c_imx,
>+						dma_addr_t phy_addr)
>+{
>+	struct imx_i2c_dma *dma;
>+	struct dma_slave_config dma_sconfig;
>+	struct device *dev = &i2c_imx->adapter.dev;
>+	int ret;
>+
>+	dma = devm_kzalloc(dev, sizeof(struct imx_i2c_dma), GFP_KERNEL);
>+	if (!dma)
>+		return -ENOMEM;
>+
>+	dma->chan_tx = dma_request_slave_channel(dev, "tx");
>+	if (!dma->chan_tx) {
>+		dev_dbg(dev, "can't request DMA tx channel\n");
>+		ret = -ENODEV;
>+		goto fail_al;
>+	}
>+
>+	dma_sconfig.dst_addr = phy_addr +
>+				(IMX_I2C_I2DR << i2c_imx->hwdata->regshift);
>+	dma_sconfig.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
>+	dma_sconfig.dst_maxburst = 1;
The maxburst is 1 cause very slow efficiency for DMA copy, which system performance even is slower
Than cpu mode.

>+	dma_sconfig.direction = DMA_MEM_TO_DEV;
>+	ret = dmaengine_slave_config(dma->chan_tx, &dma_sconfig);
>+	if (ret < 0) {
>+		dev_dbg(dev, "can't configure tx channel\n");
>+		goto fail_tx;
>+	}
>+
>+	dma->chan_rx = dma_request_slave_channel(dev, "rx");
>+	if (!dma->chan_rx) {
>+		dev_dbg(dev, "can't request DMA rx channel\n");
>+		ret = -ENODEV;
>+		goto fail_tx;
>+	}
>+
>+	dma_sconfig.src_addr = phy_addr +
>+				(IMX_I2C_I2DR << i2c_imx->hwdata->regshift);
>+	dma_sconfig.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
>+	dma_sconfig.src_maxburst = 1;
As above.

>+	dma_sconfig.direction = DMA_DEV_TO_MEM;
>+	ret = dmaengine_slave_config(dma->chan_rx, &dma_sconfig);
>+	if (ret < 0) {
>+		dev_dbg(dev, "can't configure rx channel\n");
>+		goto fail_rx;
>+	}
>+
>+	i2c_imx->dma = dma;
>+	init_completion(&dma->cmd_complete);
>+	dev_info(dev, "using %s (tx) and %s (rx) for DMA transfers\n",
>+		dma_chan_name(dma->chan_tx), dma_chan_name(dma->chan_rx));
>+
>+	return 0;
>+
>+fail_rx:
>+	dma_release_channel(dma->chan_rx);
>+fail_tx:
>+	dma_release_channel(dma->chan_tx);
>+fail_al:
>+	devm_kfree(dev, dma);
>+	dev_info(dev, "can't use DMA\n");
>+
>+	return ret;
>+}
>+
>+static void i2c_imx_dma_callback(void *arg) {
>+	struct imx_i2c_struct *i2c_imx = (struct imx_i2c_struct *)arg;
>+	struct imx_i2c_dma *dma = i2c_imx->dma;
>+
>+	dma_unmap_single(dma->chan_using->device->dev, dma->dma_buf,
>+			dma->dma_len, dma->dma_data_dir);
>+	complete(&dma->cmd_complete);
>+}
>+
>+static int i2c_imx_dma_xfer(struct imx_i2c_struct *i2c_imx,
>+					struct i2c_msg *msgs)
>+{
>+	struct imx_i2c_dma *dma = i2c_imx->dma;
>+	struct dma_async_tx_descriptor *txdesc;
>+	struct device *dev = &i2c_imx->adapter.dev;
>+	struct device *chan_dev = dma->chan_using->device->dev;
>+
>+	dma->dma_buf = dma_map_single(chan_dev, msgs->buf,
>+					dma->dma_len, dma->dma_data_dir);
>+	if (dma_mapping_error(chan_dev, dma->dma_buf)) {
>+		dev_err(dev, "DMA mapping failed\n");
>+		return -EINVAL;
>+	}
>+
>+	txdesc = dmaengine_prep_slave_single(dma->chan_using, dma->dma_buf,
>+					dma->dma_len, dma->dma_transfer_dir,
>+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>+	if (!txdesc) {
>+		dev_err(dev, "Not able to get desc for DMA xfer\n");
>+		dma_unmap_single(chan_dev, dma->dma_buf,
>+					dma->dma_len, dma->dma_data_dir);
>+		return -EINVAL;
>+	}
>+
>+	txdesc->callback = i2c_imx_dma_callback;
>+	txdesc->callback_param = i2c_imx;
>+	dmaengine_submit(txdesc);
>+	dma_async_issue_pending(dma->chan_using);
>+
>+	return 0;
>+}
>+
>+static void i2c_imx_dma_free(struct imx_i2c_struct *i2c_imx) {
>+	struct imx_i2c_dma *dma = i2c_imx->dma;
>+
>+	dma->dma_buf = 0;
>+	dma->dma_len = 0;
>+
>+	dma_release_channel(dma->chan_tx);
>+	dma->chan_tx = NULL;
>+
>+	dma_release_channel(dma->chan_rx);
>+	dma->chan_rx = NULL;
>+
>+	dma->chan_using = NULL;
>+}
>+
> /** Functions for IMX I2C adapter driver
>***************************************
>
>**************************************************************************
>*****/
>
>@@ -379,6 +530,7 @@ static int i2c_imx_start(struct imx_i2c_struct
>*i2c_imx)
> 	i2c_imx->stopped = 0;
>
> 	temp |= I2CR_IIEN | I2CR_MTX | I2CR_TXAK;
>+	temp &= ~I2CR_DMAEN;
> 	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> 	return result;
> }
>@@ -432,6 +584,160 @@ static irqreturn_t i2c_imx_isr(int irq, void *dev_id)
> 	return IRQ_NONE;
> }
>
>+static int i2c_imx_dma_write(struct imx_i2c_struct *i2c_imx,
>+					struct i2c_msg *msgs)
>+{
>+	int result, timeout = IMX_I2C_DMA_TIMEOUT;
>+	unsigned int temp = 0;
>+	struct imx_i2c_dma *dma = i2c_imx->dma;
>+	struct device *dev = &i2c_imx->adapter.dev;
>+
>+	dev_dbg(dev, "<%s> write slave address: addr=0x%x\n",
>+		__func__, msgs->addr << 1);
>+
>+	reinit_completion(&i2c_imx->dma->cmd_complete);
>+	dma->chan_using = dma->chan_tx;
>+	dma->dma_transfer_dir = DMA_MEM_TO_DEV;
>+	dma->dma_data_dir = DMA_TO_DEVICE;
>+	dma->dma_len = msgs->len - 1;
>+	result = i2c_imx_dma_xfer(i2c_imx, msgs);
>+	if (result)
>+		return result;
>+
>+	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
>+	temp |= I2CR_DMAEN;
>+	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
>+
First enable DMA, and then submit BD like as i2c read function operation.

>+	/*
>+	 * Write slave address.
>+	 * The first byte muse be transmitted by the CPU.
>+	 */
>+	imx_i2c_write_reg(msgs->addr << 1, i2c_imx, IMX_I2C_I2DR);
>+	result = wait_for_completion_interruptible_timeout(
>+				&i2c_imx->dma->cmd_complete,
>+				msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT));
>+	if (result <= 0) {
>+		dmaengine_terminate_all(dma->chan_using);
>+		if (result)
>+			return result;
>+		else
>+			return -ETIMEDOUT;
>+	}
>+
>+	/* Waiting for Transfer complete. */
>+	while (timeout--) {
>+		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
>+		if (temp & I2SR_ICF)
>+			break;
>+		udelay(10);
>+	}
Whether there have better method like interrupt to avoid dead wait here until timeout ?

>+
>+	if (!timeout)
>+		return -ETIMEDOUT;
>+	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
>+	temp &= ~I2CR_DMAEN;
>+	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
>+
>+	/* The last data byte must be transferred by the CPU. */
>+	imx_i2c_write_reg(msgs->buf[msgs->len-1],
>+				i2c_imx, IMX_I2C_I2DR);
>+	result = i2c_imx_trx_complete(i2c_imx);
>+	if (result)
>+		return result;
I don't understand why the last data need to be transmited by cpu. I guess you want to get IIF interrupt ?	

>+
>+	result = i2c_imx_acked(i2c_imx);
>+	if (result)
>+		return result;
>+
>+	return 0;
>+}
>+
>+static int i2c_imx_dma_read(struct imx_i2c_struct *i2c_imx,
>+			struct i2c_msg *msgs, bool is_lastmsg) {
>+	int result, timeout = IMX_I2C_DMA_TIMEOUT;
>+	unsigned int temp;
>+	struct imx_i2c_dma *dma = i2c_imx->dma;
>+	struct device *dev = &i2c_imx->adapter.dev;
>+
>+	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
>+	temp |= I2CR_DMAEN;
>+	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
>+
>+	reinit_completion(&i2c_imx->dma->cmd_complete);
>+	dma->chan_using = dma->chan_rx;
>+	dma->dma_transfer_dir = DMA_DEV_TO_MEM;
>+	dma->dma_data_dir = DMA_FROM_DEVICE;
>+	/* The last two data bytes must be transferred by the CPU. */
>+	dma->dma_len = msgs->len - 2;
>+	result = i2c_imx_dma_xfer(i2c_imx, msgs);
>+	if (result)
>+		return result;
>+
>+	result = wait_for_completion_interruptible_timeout(
>+				&i2c_imx->dma->cmd_complete,
>+				msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT));
>+	if (result <= 0) {
>+		dmaengine_terminate_all(dma->chan_using);
>+		if (result)
>+			return result;
>+		else
>+			return -ETIMEDOUT;
>+	}
>+
>+	/* waiting for Transfer complete. */
>+	while (timeout--) {
>+		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
>+		if (temp & I2SR_ICF)
>+			break;
>+		udelay(10);	
>+	}
>+
>+	if (!timeout)
>+		return -ETIMEDOUT;
>+	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
>+	temp &= ~I2CR_DMAEN;
>+	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
>+
>+	/* read n-1 byte data */
>+	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
>+	temp |= I2CR_TXAK;
>+	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
>+
>+	msgs->buf[msgs->len-2] = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
>+	/* read n byte data */
>+	result = i2c_imx_trx_complete(i2c_imx);
>+	if (result)
>+		return result;
>+
>+	if (is_lastmsg) {
>+		/*
>+		 * It must generate STOP before read I2DR to prevent
>+		 * controller from generating another clock cycle
>+		 */
>+		dev_dbg(dev, "<%s> clear MSTA\n", __func__);
>+		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
>+		temp &= ~(I2CR_MSTA | I2CR_MTX);
>+		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
>+		i2c_imx_bus_busy(i2c_imx, 0);
>+		i2c_imx->stopped = 1;
>+	} else {
>+		/*
>+		 * For i2c master receiver repeat restart operation like:
>+		 * read -> repeat MSTA -> read/write
>+		 * The controller must set MTX before read the last byte in
>+		 * the first read operation, otherwise the first read cost
>+		 * one extra clock cycle.
>+		 */
>+		temp = readb(i2c_imx->base + IMX_I2C_I2CR);
>+		temp |= I2CR_MTX;
>+		writeb(temp, i2c_imx->base + IMX_I2C_I2CR);
>+	}
>+	msgs->buf[msgs->len-1] = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
>+
>+	return 0;
>+}
>+
> static int i2c_imx_write(struct imx_i2c_struct *i2c_imx, struct i2c_msg
>*msgs)  {
> 	int i, result;
>@@ -501,6 +807,9 @@ static int i2c_imx_read(struct imx_i2c_struct *i2c_imx,
>struct i2c_msg *msgs, bo
>
> 	dev_dbg(&i2c_imx->adapter.dev, "<%s> read data\n", __func__);
>
>+	if (i2c_imx->dma && msgs->len >= IMX_I2C_DMA_THRESHOLD
>&& !block_data)
>+		return i2c_imx_dma_read(i2c_imx, msgs, is_lastmsg);
>+
> 	/* read data */
> 	for (i = 0; i < msgs->len; i++) {
> 		u8 len = 0;
>@@ -615,8 +924,12 @@ static int i2c_imx_xfer(struct i2c_adapter *adapter,
>#endif
> 		if (msgs[i].flags & I2C_M_RD)
> 			result = i2c_imx_read(i2c_imx, &msgs[i], is_lastmsg);
>-		else
>-			result = i2c_imx_write(i2c_imx, &msgs[i]);
>+		else {
>+			if (i2c_imx->dma && msgs[i].len >= IMX_I2C_DMA_THRESHOLD)
>+				result = i2c_imx_dma_write(i2c_imx, &msgs[i]);
>+			else
>+				result = i2c_imx_write(i2c_imx, &msgs[i]);
>+		}
> 		if (result)
> 			goto fail0;
> 	}
>@@ -651,6 +964,7 @@ static int i2c_imx_probe(struct platform_device *pdev)
> 	struct imxi2c_platform_data *pdata = dev_get_platdata(&pdev->dev);
> 	void __iomem *base;
> 	int irq, ret;
>+	dma_addr_t phy_addr;
>
> 	dev_dbg(&pdev->dev, "<%s>\n", __func__);
>
>@@ -661,6 +975,7 @@ static int i2c_imx_probe(struct platform_device *pdev)
> 	}
>
> 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>+	phy_addr = (dma_addr_t)res->start;
> 	base = devm_ioremap_resource(&pdev->dev, res);
> 	if (IS_ERR(base))
> 		return PTR_ERR(base);
>@@ -743,6 +1058,9 @@ static int i2c_imx_probe(struct platform_device *pdev)
> 		i2c_imx->adapter.name);
> 	dev_info(&i2c_imx->adapter.dev, "IMX I2C adapter registered\n");
>
>+	/* Init DMA config if support*/
>+	i2c_imx_dma_request(i2c_imx, phy_addr);
>+
> 	return 0;   /* Return OK */
> }
>
>@@ -754,6 +1072,9 @@ static int i2c_imx_remove(struct platform_device
>*pdev)
> 	dev_dbg(&i2c_imx->adapter.dev, "adapter removed\n");
> 	i2c_del_adapter(&i2c_imx->adapter);
>
>+	if (i2c_imx->dma)
>+		i2c_imx_dma_free(i2c_imx);
>+
> 	/* setup chip registers to defaults */
> 	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IADR);
> 	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IFDR);
>--
