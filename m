Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbbAUDNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 22:13:39 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:51313 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751894AbbAUDNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 22:13:37 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v4 2/2] I2C: mediatek: Add driver for MediaTek I2C
 controller
From: Eddie Huang <eddie.huang@mediatek.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Wolfram Sang <wsa@the-dreams.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <srv_heupstream@mediatek.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Doug Anderson <dianders@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Max Schwarz <max.schwarz@online.de>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Anders Berg <anders.berg@avagotech.com>,
        Neelesh Gupta <neelegup@linux.vnet.ibm.com>,
        Wei Yan <sledge.yanwei@huawei.com>, Lee Jones <lee.jones@linaro.org>,
        Simon Glass <sjg@chromium.org>, Jim Cromie <jim.cromie@gmail.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Xudong Chen <xudong.chen@mediatek.com>, <linux-i2c@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <yingjoe.chen@mediatek.com>,
        <yh.chen@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>
In-Reply-To: <20150118101816.GF22880@pengutronix.de>
References: <1421404418-50718-1-git-send-email-eddie.huang@mediatek.com>
	 <1421404418-50718-3-git-send-email-eddie.huang@mediatek.com>
	 <20150118101816.GF22880@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Jan 2015 11:13:24 +0800
Message-ID: <1421810004.15468.825.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Sun, 2015-01-18 at 11:18 +0100, Uwe Kleine-König wrote:
> Hello,
> 
> On Fri, Jan 16, 2015 at 06:33:38PM +0800, Eddie Huang wrote:
> > +config I2C_MT65XX
> > +	tristate "MediaTek I2C adapter"
> > +	depends on ARCH_MEDIATEK
> depends on ARCH_MEDIATEK || COMPILE_TEST
> default ARCH_MEDIATEK
> 
> would be nice to have to get better compile coverage.
OK

> 
> > +struct mtk_i2c {
> > +	struct i2c_adapter adap;	/* i2c host adapter */
> > +	struct device *dev;
> > +	wait_queue_head_t wait;		/* i2c transfer wait queue */
> > +	/* set in i2c probe */
> > +	void __iomem *base;		/* i2c base addr */
> > +	void __iomem *pdmabase;		/* dma base address*/
> > +	int irqnr;			/* i2c interrupt number */
> irqs are unsigned quantities
OK

> 
> > +	struct i2c_dma_buf dma_buf;	/* memory alloc for DMA mode */
> > +	struct clk *clk_main;		/* main clock for i2c bus */
> > +	struct clk *clk_dma;		/* DMA clock for i2c via DMA */
> > +	struct clk *clk_pmic;		/* PMIC clock for i2c from PMIC */
> > +	bool have_pmic;			/* can use i2c pins from PMIC */
> > +	bool use_push_pull;		/* IO config push-pull mode */
> > +	u32 platform_compat;		/* platform compatible data */
> > +	/* set when doing the transfer */
> > +	u16 irq_stat;			/* interrupt status */
> > +	unsigned int speed_hz;		/* The speed in transfer */
> > +	bool trans_stop;		/* i2c transfer stop */
> > +	enum mtk_trans_op op;
> > +	u16 msg_len;
> > +	u8 *msg_buf;			/* pointer to msg data */
> > +	u16 msg_aux_len;		/* WRRD mode to set AUX_LEN register*/
> > +	u16 addr;	/* 7bit slave address, without read/write bit */
> Wouldn't it be easier to maintain a pointer to the message to be
> transferred?
I think use mtk_i2c pointer is more flexible than maintain a pointer to
message.

> 
> > +	u16 timing_reg;
> > +	u16 high_speed_reg;
> > +};
> > +
> > +static const struct of_device_id mtk_i2c_of_match[] = {
> > +	{ .compatible = "mediatek,mt6577-i2c", .data = (void *)COMPAT_MT6577 },
> > +	{ .compatible = "mediatek,mt6589-i2c", .data = (void *)COMPAT_MT6589 },
> > +	{},
> There is usually no , after the sentinel entry.
OK

> 
> > +};
> > +MODULE_DEVICE_TABLE(of, mtk_i2c_match);
> > +
> > +static inline void i2c_writew(u16 value, struct mtk_i2c *i2c, u8 offset)
> > +{
> > +	writew(value, i2c->base + offset);
> > +}
> hmm, these simple wrappers are fine in general for me because they might
> ease debugging or changing the accessor-function. Still "i2c_writew"
> sounds too generic. IMHO you should spend the few chars to make this
> mtk_i2c_writew. And to match my taste completely, move the driver data
> parameter to the front. (But there are too much different tastes out
> there to really request a certain style here.) Same for the other
> wrappers of course.
Sure, I will add mtk_ prefix.

> 
> > +	/* Prepare buffer data to start transfer */
> > +	if (i2c->op == I2C_MASTER_RD) {
> > +		i2c_writel_dma(I2C_DMA_INT_FLAG_NONE, i2c, OFFSET_INT_FLAG);
> > +		i2c_writel_dma(I2C_DMA_CON_RX, i2c, OFFSET_CON);
> > +		i2c_writel_dma((u32)i2c->msg_buf, i2c, OFFSET_RX_MEM_ADDR);
> > +		i2c_writel_dma(i2c->msg_len, i2c, OFFSET_RX_LEN);
> > +	} else if (i2c->op == I2C_MASTER_WR) {
> > +		i2c_writel_dma(I2C_DMA_INT_FLAG_NONE, i2c, OFFSET_INT_FLAG);
> > +		i2c_writel_dma(I2C_DMA_CON_TX, i2c, OFFSET_CON);
> > +		i2c_writel_dma((u32)i2c->msg_buf, i2c, OFFSET_TX_MEM_ADDR);
> > +		i2c_writel_dma(i2c->msg_len, i2c, OFFSET_TX_LEN);
> > +	} else {
> 		/* i2c->op == I2C_MASTER_WRRD */
> 
> > +		i2c_writel_dma(I2C_DMA_CLR_FLAG, i2c, OFFSET_INT_FLAG);
> > +		i2c_writel_dma(I2C_DMA_CLR_FLAG, i2c, OFFSET_CON);
> > +		i2c_writel_dma((u32)i2c->msg_buf, i2c, OFFSET_TX_MEM_ADDR);
> > +		i2c_writel_dma((u32)i2c->dma_buf.paddr, i2c,
> > +			OFFSET_RX_MEM_ADDR);
> > +		i2c_writel_dma(i2c->msg_len, i2c, OFFSET_TX_LEN);
> > +		i2c_writel_dma(i2c->msg_aux_len, i2c, OFFSET_RX_LEN);
> > +	}
> > +
> > +	/* flush before sending start */
> > +	mb();
> > +	i2c_writel_dma(I2C_DMA_START_EN, i2c, OFFSET_EN);
> > +	i2c_writew(I2C_TRANSAC_START, i2c, OFFSET_START);
> > +
> > +	tmo = wait_event_timeout(i2c->wait, i2c->trans_stop, tmo);
> If the request completes just when wait_event_timeout returned 0 you
> shouldn't throw it away.
OK, add check transfer complete in tmo == 0 case.

> > +	if (tmo == 0) {
> > +		dev_dbg(i2c->dev, "addr: %x, transfer timeout\n", i2c->addr);
> > +		mtk_i2c_init_hw(i2c);
> > +		return -ETIMEDOUT;
> > +	}
> > [...]
> > +	if (msgs->addr == 0) {
> > +		dev_dbg(i2c->dev, " addr is invalid.\n");
> Is this a hardware limitation?
No. addr 0 should be reserved for special purpose. No client should use
addr 0. I think driver should not block transfer addr 0, I will remove
this.

> 
> I'd remove the leading space in the message. (Applies also to other
> places.)
Of course

> 
> > +		ret = -EINVAL;
> > +		goto err_exit;
> > +	}
> > +
> > +	if (msgs->buf == NULL) {
> > +		dev_dbg(i2c->dev, " data buffer is NULL.\n");
> > +		ret = -EINVAL;
> > +		goto err_exit;
> > +	}
> > +
> > +	i2c->addr = msgs->addr;
> > +	i2c->msg_len = msgs->len;
> > +	i2c->msg_buf = msgs->buf;
> > +
> > +	if (msgs->flags & I2C_M_RD)
> > +		i2c->op = I2C_MASTER_RD;
> > +	else
> > +		i2c->op = I2C_MASTER_WR;
> > +
> > +	/* combined two messages into one transaction */
> > +	if (num > 1) {
> > +		i2c->msg_aux_len = (msgs + 1)->len;
> > +		i2c->op = I2C_MASTER_WRRD;
> > +	}
> This means "write then read", right? You should check here that the
> first message is really a write and the 2nd a read then.
> Can this happen at all with the quirks defined below (.max_num_msgs =
> 1)?
Yes, mean write then read. Indeed, add check is better.
If msg number is 1, means normal write or read, not "write then read".

> > +	/*
> > +	 * always use DMA mode.
> Out of interest: Did you benchmark DMA vs manual mode for a typical
> (what ever that means) scenario?
I think performance don't go to far, but always use DMA make driver
simplified.

> 
> > +	 * 1st when write need copy the data of message to dma memory
> > +	 * 2nd when read need copy the DMA data to the message buffer.
> > +	 */
> > +	mtk_i2c_copy_to_dma(i2c, msgs);
> > +	i2c->msg_buf = (u8 *)i2c->dma_buf.paddr;
> > +	ret = mtk_i2c_do_transfer(i2c);
> > +	if (ret < 0)
> > +		goto err_exit;
> > +
> > +	if (i2c->op == I2C_MASTER_WRRD)
> > +		mtk_i2c_copy_from_dma(i2c, msgs + 1);
> > +	else
> > +		mtk_i2c_copy_from_dma(i2c, msgs);
> > +
> > +	/* the return value is number of executed messages */
> > +	ret = num;
> > +
> > +err_exit:
> > +	mtk_i2c_clock_disable(i2c);
> > +	return ret;
> > +}
> > +
> > +static irqreturn_t mtk_i2c_irq(int irqno, void *dev_id)
> > +{
> > +	struct mtk_i2c *i2c = dev_id;
> > +
> > +	/* Clear interrupt mask */
> > +	i2c_writew(~(I2C_HS_NACKERR | I2C_ACKERR | I2C_TRANSAC_COMP),
> > +		i2c, OFFSET_INTR_MASK);
> What is the effect of this. Does it disable further irqs?
Yes. interrupt enable in mtk_i2c_do_transfer, disable in mtk_i2c_irq.

> 
> > +	i2c->irq_stat = i2c_readw(i2c, OFFSET_INTR_STAT);
> Maybe you need locking here to modify your driver data in the irq?
OK
> 
> > +	i2c_writew(I2C_HS_NACKERR | I2C_ACKERR | I2C_TRANSAC_COMP,
> > +		i2c, OFFSET_INTR_STAT);
> This is the ack? Then this is racy; I guess you want
Clear interrupt

> 
> 	i2c_writew(i2c->irq_stat & (I2C_HS_NACKERR | I2C_ACKERR ...),
> 		   i2c, OFFSET_INTR_STAT);
> 
Yes. you are right. This can avoid unnecessary write 1 bit.

> then.
> 
> > +	i2c->trans_stop = true;
> > +	wake_up(&i2c->wait);
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static u32 mtk_i2c_functionality(struct i2c_adapter *adap)
> > +{
> > +	return I2C_FUNC_I2C | I2C_FUNC_10BIT_ADDR | I2C_FUNC_SMBUS_EMUL;
> Does your hardware handle 10bit addresses that nice that there is
> nothing visible in the driver apart from this functionality
> announcement?
Our hardware has this capability, but not implement in this driver.
Remove I2C_FUNC_10BIT_ADDR in next round.

> 
> > +}
> > +
> > +static const struct i2c_algorithm mtk_i2c_algorithm = {
> > +	.master_xfer = mtk_i2c_transfer,
> > +	.functionality = mtk_i2c_functionality,
> > +};
> > +
> > +static inline u32 mtk_get_device_prop(struct platform_device *pdev)
> > +{
> > +	const struct of_device_id *match;
> > +
> > +	match = of_match_node(mtk_i2c_of_match, pdev->dev.of_node);
> > +	return (u32)match->data;
> > +}
> > +
> > +static int mtk_i2c_parse_dt(struct device_node *np, struct mtk_i2c *i2c,
> > +	unsigned int *clk_src_div)
> > +{
> > +	i2c->speed_hz = I2C_DEFAUT_SPEED;
> > +	of_property_read_u32(np, "clock-frequency", &i2c->speed_hz);
> > +	of_property_read_u32(np, "clock-div", clk_src_div);
> You should check the return value of of_property_read_u32.
OK
> 
> > [...]
> > +	ret = devm_request_irq(&pdev->dev, i2c->irqnr, mtk_i2c_irq,
> > +		IRQF_TRIGGER_NONE, I2C_DRV_NAME, i2c);
> > +	if (ret < 0) {
> > +		dev_err(&pdev->dev,
> > +			"Request I2C IRQ %d fail\n", i2c->irqnr);
> > +		return ret;
> > +	}
> I think the devm_request_irq should go near the end of probing.
> Otherwise the irq might fire before the used resources are ready.
OK

> 
> > +
> > +	i2c->adap.dev.of_node = pdev->dev.of_node;
> > +	i2c->dev = &i2c->adap.dev;
> > +	i2c->adap.dev.parent = &pdev->dev;
> > +	i2c->adap.owner = THIS_MODULE;
> > +	i2c->adap.algo = &mtk_i2c_algorithm;
> > +	i2c->adap.quirks = &mt6577_i2c_quirks;
> > +	i2c->adap.algo_data = NULL;
> No need to initialize this to NULL as the struct was allocated using
> kzalloc.
OK

> 
> > +	i2c->adap.timeout = 2 * HZ;
> > +	i2c->adap.retries = 1;
> > +
> > +	i2c->clk_main = devm_clk_get(&pdev->dev, "main");
> > +	if (IS_ERR(i2c->clk_main)) {
> > +		dev_err(&pdev->dev, "cannot get main clock\n");
> > +		return PTR_ERR(i2c->clk_main);
> > +	}
> > +
> > +	i2c->clk_dma = devm_clk_get(&pdev->dev, "dma");
> > +	if (IS_ERR(i2c->clk_dma)) {
> > +		dev_err(&pdev->dev, "cannot get dma clock\n");
> > +		return PTR_ERR(i2c->clk_dma);
> > +	}
> > +
> > +	if (i2c->have_pmic) {
> > +		i2c->clk_pmic = devm_clk_get(&pdev->dev, "pmic");
> > +		if (IS_ERR(i2c->clk_pmic)) {
> > +			dev_err(&pdev->dev, "cannot get pmic clock\n");
> > +			return PTR_ERR(i2c->clk_pmic);
> > +		}
> > +		clk_src_in_hz = clk_get_rate(i2c->clk_pmic) / clk_src_div;
> > +	} else {
> > +		clk_src_in_hz = clk_get_rate(i2c->clk_main) / clk_src_div;
> > +	}
> This can be simplified, i.e. the common line can go after the if block
> and then the else branch can be dropped.
One is clk_pmic, the other is clk_main, one way to reduce else branch is
use variable to store clk and set to i2c->clk_main by default. Then call
clk_get_rate at last. I don't know whether this is a better way.

> 
> > +	dev_dbg(&pdev->dev, "clock source %p,clock src frequency %d\n",
> > +		i2c->clk_main, clk_src_in_hz);
> > +	strlcpy(i2c->adap.name, I2C_DRV_NAME, sizeof(i2c->adap.name));
> > +	init_waitqueue_head(&i2c->wait);
> > +
> > +	ret = i2c_set_speed(i2c, clk_src_in_hz);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Failed to set the speed.\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	ret = mtk_i2c_clock_enable(i2c);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "clock enable failed!\n");
> > +		return ret;
> > +	}
> > +	mtk_i2c_init_hw(i2c);
> > +	mtk_i2c_clock_disable(i2c);
> > +
> > +	i2c->dma_buf.vaddr = dma_alloc_coherent(&pdev->dev,
> > +		PAGE_SIZE, &i2c->dma_buf.paddr, GFP_KERNEL);
> > +	if (i2c->dma_buf.vaddr == NULL) {
> > +		dev_err(&pdev->dev, "dma_alloc_coherent fail\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	i2c_set_adapdata(&i2c->adap, i2c);
> > +	ret = i2c_add_adapter(&i2c->adap);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Failed to add i2c bus to i2c core\n");
> > +		free_i2c_dma_bufs(i2c);
> > +		return ret;
> > +	}
> > +
> > +	platform_set_drvdata(pdev, i2c);
> > +
> > +	return 0;
> > +}
> > +
> > +static int mtk_i2c_remove(struct platform_device *pdev)
> > +{
> > +	struct mtk_i2c *i2c = platform_get_drvdata(pdev);
> > +
> > +	i2c_del_adapter(&i2c->adap);
> > +	free_i2c_dma_bufs(i2c);
> > +	platform_set_drvdata(pdev, NULL);
> > +
> Here you need to make sure that no irq is running when i2c_del_adapter
> is called.
OK, add check here

> 
> > +	return 0;
> > +}
> > +
> > +static struct platform_driver mtk_i2c_driver = {
> > +	.probe = mtk_i2c_probe,
> > +	.remove = mtk_i2c_remove,
> > +	.driver = {
> > +		.name = I2C_DRV_NAME,
> > +		.owner = THIS_MODULE,
> You don't need to set .owner any more. That's included in
> module_platform_driver since some time.
OK
> 
> > +		.of_match_table = of_match_ptr(mtk_i2c_of_match),
> > +	},
> > +};
> > +
> > +module_platform_driver(mtk_i2c_driver);
> > +
> > +MODULE_LICENSE("GPL");
> MODULE_LICENSE("GPL v2");
> > +MODULE_DESCRIPTION("MediaTek I2C Bus Driver");
> > +MODULE_AUTHOR("Xudong Chen <xudong.chen@mediatek.com>");
> 
> Best regards
> Uwe
> 


