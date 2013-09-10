Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab3IJQQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:16:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47803 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab3IJQQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:16:50 -0400
Message-ID: <522F45D0.5050605@ti.com>
Date: Tue, 10 Sep 2013 11:16:16 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rajendra Nayak <rnayak@ti.com>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Greer <mgreer@animalcreek.com>, Tony Lindgren <tony@atomide.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/3] crypto: omap-des: Add omap-des driver for OMAP4/AM43xx
References: <1377818873-21174-1-git-send-email-joelf@ti.com> <1377818873-21174-2-git-send-email-joelf@ti.com> <522063AB.2030907@ti.com>
In-Reply-To: <522063AB.2030907@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 04:19 AM, Rajendra Nayak wrote:
> []..
> 
>> +
>> +#define pr_fmt(fmt) "%s: " fmt, __func__
>> +
>> +#ifdef DEBUG
>> +#define prn(num) printk(#num "=%d\n", num)
>> +#define prx(num) printk(#num "=%x\n", num)
>> +#else
>> +#define prn(num) do { } while (0)
>> +#define prx(num)  do { } while (0)
>> +#endif
>> +
>> +#include <linux/err.h>
>> +#include <linux/module.h>
>> +#include <linux/init.h>
>> +#include <linux/errno.h>
>> +#include <linux/kernel.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/scatterlist.h>
>> +#include <linux/dma-mapping.h>
>> +#include <linux/dmaengine.h>
>> +#include <linux/omap-dma.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/of.h>
>> +#include <linux/of_device.h>
>> +#include <linux/of_address.h>
>> +#include <linux/io.h>
>> +#include <linux/crypto.h>
>> +#include <linux/interrupt.h>
>> +#include <crypto/scatterwalk.h>
>> +#include <crypto/des.h>
>> +
>> +#define DST_MAXBURST			2
>> +
>> +#define DES_BLOCK_WORDS		(DES_BLOCK_SIZE >> 2)
>> +
>> +#define _calc_walked(inout) (dd->inout##_walk.offset - dd->inout##_sg->offset)
>> +
>> +#define DES_REG_KEY(dd, x)		((dd)->pdata->key_ofs - \
>> +						((x ^ 0x01) * 0x04))
>> +
>> +#define DES_REG_IV(dd, x)		((dd)->pdata->iv_ofs + ((x) * 0x04))
>> +
>> +#define DES_REG_CTRL(dd)		((dd)->pdata->ctrl_ofs)
>> +#define DES_REG_CTRL_CBC		(1 << 4)
>> +#define DES_REG_CTRL_TDES		(1 << 3)
>> +#define DES_REG_CTRL_DIRECTION		(1 << 2)
>> +#define DES_REG_CTRL_INPUT_READY	(1 << 1)
>> +#define DES_REG_CTRL_OUTPUT_READY	(1 << 0)
> 
> Why not use bitops like you have done below.

Ok, will do that.

> 
>> +
>> +#define DES_REG_DATA_N(dd, x)		((dd)->pdata->data_ofs + ((x) * 0x04))
>> +
>> +#define DES_REG_REV(dd)			((dd)->pdata->rev_ofs)
>> +
>> +#define DES_REG_MASK(dd)		((dd)->pdata->mask_ofs)
>> +
>> +#define DES_REG_LENGTH_N(x)		(0x24 + ((x) * 0x04))
>> +
>> +#define DES_REG_IRQ_STATUS(dd)         ((dd)->pdata->irq_status_ofs)
>> +#define DES_REG_IRQ_ENABLE(dd)         ((dd)->pdata->irq_enable_ofs)
>> +#define DES_REG_IRQ_DATA_IN            BIT(1)
>> +#define DES_REG_IRQ_DATA_OUT           BIT(2)
>> +
>> +#define FLAGS_MODE_MASK		0x000f
>> +#define FLAGS_ENCRYPT		BIT(0)
>> +#define FLAGS_CBC		BIT(1)
>> +#define FLAGS_INIT		BIT(4)
>> +#define FLAGS_BUSY		BIT(6)
>> +
> 
> []..
> 
>> +struct omap_des_pdata {
>> +	struct omap_des_algs_info	*algs_info;
>> +	unsigned int	algs_info_size;
>> +
>> +	void		(*trigger)(struct omap_des_dev *dd, int length);
> 
> Is this really used? How does a DT platform pass function pointers?

This is hard coded in the pdata structures for each platform and provided once
the DT matches. Different platforms may have different pdata.

>> +
>> +	u32		key_ofs;
>> +	u32		iv_ofs;
>> +	u32		ctrl_ofs;
>> +	u32		data_ofs;
>> +	u32		rev_ofs;
>> +	u32		mask_ofs;
>> +	u32             irq_enable_ofs;
>> +	u32             irq_status_ofs;
>> +
>> +	u32		dma_enable_in;
>> +	u32		dma_enable_out;
>> +	u32		dma_start;
>> +
>> +	u32		major_mask;
>> +	u32		major_shift;
>> +	u32		minor_mask;
>> +	u32		minor_shift;
>> +};
>> +
>> +struct omap_des_dev {
>> +	struct list_head	list;
>> +	unsigned long		phys_base;
>> +	void __iomem		*io_base;
>> +	struct omap_des_ctx	*ctx;
>> +	struct device		*dev;
>> +	unsigned long		flags;
>> +	int			err;
>> +
>> +	/* spinlock used for queues */
>> +	spinlock_t		lock;
>> +	struct crypto_queue	queue;
>> +
>> +	struct tasklet_struct	done_task;
>> +	struct tasklet_struct	queue_task;
>> +
>> +	struct ablkcipher_request	*req;
>> +	/*
>> +	 * total is used by PIO mode for book keeping so introduce
>> +	 * variable total_save as need it to calc page_order
>> +	 */
>> +	size_t                          total;
>> +	size_t                          total_save;
>> +
>> +	struct scatterlist		*in_sg;
>> +	struct scatterlist		*out_sg;
>> +
>> +	/* Buffers for copying for unaligned cases */
>> +	struct scatterlist		in_sgl;
>> +	struct scatterlist		out_sgl;
>> +	struct scatterlist		*orig_out;
>> +	int				sgs_copied;
>> +
>> +	struct scatter_walk		in_walk;
>> +	struct scatter_walk		out_walk;
>> +	int			dma_in;
>> +	struct dma_chan		*dma_lch_in;
>> +	int			dma_out;
>> +	struct dma_chan		*dma_lch_out;
>> +	int			in_sg_len;
>> +	int			out_sg_len;
>> +	int			pio_only;
>> +	const struct omap_des_pdata	*pdata;
>> +};
>> +
>> +/* keep registered devices data here */
>> +static LIST_HEAD(dev_list);
>> +static DEFINE_SPINLOCK(list_lock);
>> +
> 
> []..
> 
>> +
>> +static int omap_des_crypt_dma_start(struct omap_des_dev *dd)
>> +{
>> +	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(
>> +					crypto_ablkcipher_reqtfm(dd->req));
>> +	int err;
>> +
>> +	pr_debug("total: %d\n", dd->total);
>> +
>> +	if (!dd->pio_only) {
>> +		err = dma_map_sg(dd->dev, dd->in_sg, dd->in_sg_len,
>> +				 DMA_TO_DEVICE);
>> +		if (!err) {
>> +			dev_err(dd->dev, "dma_map_sg() error\n");
>> +			return -EINVAL;
>> +		}
>> +
>> +		err = dma_map_sg(dd->dev, dd->out_sg, dd->out_sg_len,
>> +				 DMA_FROM_DEVICE);
>> +		if (!err) {
>> +			dev_err(dd->dev, "dma_map_sg() error\n");
>> +			return -EINVAL;
>> +		}
>> +	}
>> +
>> +	err = omap_des_crypt_dma(tfm, dd->in_sg, dd->out_sg, dd->in_sg_len,
>> +				 dd->out_sg_len);
>> +	if (err && !dd->pio_only) {
>> +		dma_unmap_sg(dd->dev, dd->in_sg, dd->in_sg_len, DMA_TO_DEVICE);
>> +		dma_unmap_sg(dd->dev, dd->out_sg, dd->out_sg_len,
>> +			     DMA_FROM_DEVICE);
>> +	}
>> +
>> +	return err;
>> +}
>> +
>> +static void omap_des_finish_req(struct omap_des_dev *dd, int err)
>> +{
>> +	struct ablkcipher_request *req = dd->req;
>> +
>> +	pr_debug("err: %d\n", err);
>> +
>> +	pm_runtime_put(dd->dev);
> 
> You seem to do a pm_runtime_get_sync() in omap_des_write_ctrl() and a
> pm_runtime_put() here and not a pm_runtime_put_sync()?

Yes, that's on purpose :) I had submitted a fix earlier to do that.
http://www.spinics.net/lists/linux-crypto/msg08482.html

> 
>> +
>> +#ifdef CONFIG_OF
>> +static const struct omap_des_pdata omap_des_pdata_omap4 = {
>> +	.algs_info	= omap_des_algs_info_ecb_cbc,
>> +	.algs_info_size	= ARRAY_SIZE(omap_des_algs_info_ecb_cbc),
>> +	.trigger	= omap_des_dma_trigger_omap4,
>> +	.key_ofs	= 0x14,
>> +	.iv_ofs		= 0x18,
>> +	.ctrl_ofs	= 0x20,
>> +	.data_ofs	= 0x28,
>> +	.rev_ofs	= 0x30,
>> +	.mask_ofs	= 0x34,
>> +	.irq_status_ofs = 0x3c,
>> +	.irq_enable_ofs = 0x40,
>> +	.dma_enable_in	= BIT(5),
>> +	.dma_enable_out	= BIT(6),
>> +	.major_mask	= 0x0700,
>> +	.major_shift	= 8,
>> +	.minor_mask	= 0x003f,
>> +	.minor_shift	= 0,
>> +};
>> +
>> +static irqreturn_t omap_des_irq(int irq, void *dev_id)
>> +{
>> +	struct omap_des_dev *dd = dev_id;
>> +	u32 status, i;
>> +	u32 *src, *dst;
>> +
>> +	status = omap_des_read(dd, DES_REG_IRQ_STATUS(dd));
>> +	if (status & DES_REG_IRQ_DATA_IN) {
>> +		omap_des_write(dd, DES_REG_IRQ_ENABLE(dd), 0x0);
>> +
>> +		BUG_ON(!dd->in_sg);
>> +
>> +		BUG_ON(_calc_walked(in) > dd->in_sg->length);
>> +
>> +		src = sg_virt(dd->in_sg) + _calc_walked(in);
>> +
>> +		for (i = 0; i < DES_BLOCK_WORDS; i++) {
>> +			omap_des_write(dd, DES_REG_DATA_N(dd, i), *src);
>> +
>> +			scatterwalk_advance(&dd->in_walk, 4);
>> +			if (dd->in_sg->length == _calc_walked(in)) {
>> +				dd->in_sg = scatterwalk_sg_next(dd->in_sg);
>> +				if (dd->in_sg) {
>> +					scatterwalk_start(&dd->in_walk,
>> +							  dd->in_sg);
>> +					src = sg_virt(dd->in_sg) +
>> +					      _calc_walked(in);
>> +				}
>> +			} else {
>> +				src++;
>> +			}
>> +		}
>> +
>> +		/* Clear IRQ status */
>> +		status &= ~DES_REG_IRQ_DATA_IN;
>> +		omap_des_write(dd, DES_REG_IRQ_STATUS(dd), status);
>> +
>> +		/* Enable DATA_OUT interrupt */
>> +		omap_des_write(dd, DES_REG_IRQ_ENABLE(dd), 0x4);
>> +
>> +	} else if (status & DES_REG_IRQ_DATA_OUT) {
>> +		omap_des_write(dd, DES_REG_IRQ_ENABLE(dd), 0x0);
>> +
>> +		BUG_ON(!dd->out_sg);
>> +
>> +		BUG_ON(_calc_walked(out) > dd->out_sg->length);
>> +
>> +		dst = sg_virt(dd->out_sg) + _calc_walked(out);
>> +
>> +		for (i = 0; i < DES_BLOCK_WORDS; i++) {
>> +			*dst = omap_des_read(dd, DES_REG_DATA_N(dd, i));
>> +			scatterwalk_advance(&dd->out_walk, 4);
>> +			if (dd->out_sg->length == _calc_walked(out)) {
>> +				dd->out_sg = scatterwalk_sg_next(dd->out_sg);
>> +				if (dd->out_sg) {
>> +					scatterwalk_start(&dd->out_walk,
>> +							  dd->out_sg);
>> +					dst = sg_virt(dd->out_sg) +
>> +					      _calc_walked(out);
>> +				}
>> +			} else {
>> +				dst++;
>> +			}
>> +		}
>> +
>> +		dd->total -= DES_BLOCK_SIZE;
>> +
>> +		BUG_ON(dd->total < 0);
>> +
>> +		/* Clear IRQ status */
>> +		status &= ~DES_REG_IRQ_DATA_OUT;
>> +		omap_des_write(dd, DES_REG_IRQ_STATUS(dd), status);
>> +
>> +		if (!dd->total)
>> +			/* All bytes read! */
>> +			tasklet_schedule(&dd->done_task);
>> +		else
>> +			/* Enable DATA_IN interrupt for next block */
>> +			omap_des_write(dd, DES_REG_IRQ_ENABLE(dd), 0x2);
>> +	}
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static const struct of_device_id omap_des_of_match[] = {
>> +	{
>> +		.compatible	= "ti,omap4-des",
>> +		.data		= &omap_des_pdata_omap4,
>> +	},
>> +	{},
>> +};
>> +MODULE_DEVICE_TABLE(of, omap_des_of_match);
>> +
>> +static int omap_des_get_res_of(struct omap_des_dev *dd,
>> +		struct device *dev, struct resource *res)
>> +{
>> +	struct device_node *node = dev->of_node;
>> +	const struct of_device_id *match;
>> +	int err = 0;
>> +
>> +	match = of_match_device(of_match_ptr(omap_des_of_match), dev);
>> +	if (!match) {
>> +		dev_err(dev, "no compatible OF match\n");
>> +		err = -EINVAL;
>> +		goto err;
>> +	}
>> +
>> +	err = of_address_to_resource(node, 0, res);
> 
> Do you really need to do this? DT should have already populated
> a resource for you based on the 'reg' property.

Ok, thanks. Now will do:
        *res = platform_get_resource(pdev, IORESOURCE_MEM);

>> +	if (err < 0) {
>> +		dev_err(dev, "can't translate OF node address\n");
>> +		err = -EINVAL;
>> +		goto err;
>> +	}
>> +
>> +	dd->dma_out = -1; /* Dummy value that's unused */
>> +	dd->dma_in = -1; /* Dummy value that's unused */
>> +
>> +	dd->pdata = match->data;
>> +
>> +err:
>> +	return err;
>> +}
>> +#else
>> +static const struct of_device_id omap_des_of_match[] = {
>> +	{},
>> +};
> 
> you don't need this if you use of_match_ptr()

Ok I changed it to:
+               .of_match_table = of_match_ptr(omap_des_of_match),

and removed empty definition for !CONFIG_OF.

>> +
>> +static int omap_des_get_res_of(struct omap_des_dev *dd,
>> +		struct device *dev, struct resource *res)
>> +{
>> +	return -EINVAL;
>> +}
>> +#endif
>> +
>> +static int omap_des_get_res_pdev(struct omap_des_dev *dd,
>> +		struct platform_device *pdev, struct resource *res)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct resource *r;
>> +	int err = 0;
>> +
>> +	/* Get the base address */
>> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (!r) {
>> +		dev_err(dev, "no MEM resource info\n");
>> +		err = -ENODEV;
>> +		goto err;
>> +	}
>> +	memcpy(res, r, sizeof(*res));
> 
> I don't think you need any of this. Regardless of a DT or a
> non-DT platform, you should be able to do a platform_get_resource()
> for mem resources.

Yes ok, I removed all this and am directly using the res pointer now instead of
pre-filling a structure. Also both DT/non-DT paths now use platform_get_resource.

[..]
>> +	tasklet_kill(&dd->done_task);
>> +	tasklet_kill(&dd->queue_task);
>> +	omap_des_dma_cleanup(dd);
>> +	pm_runtime_disable(dd->dev);
>> +	dd = NULL;
>> +
>> +	return 0;
>> +}
>> +
>> +#ifdef CONFIG_PM_SLEEP
>> +static int omap_des_suspend(struct device *dev)
>> +{
>> +	pm_runtime_put_sync(dev);
> 
> I know you seemed to have taken this from the omap-aes driver, but this
> does not seem correct. Your system suspend callbacks shouldn't
> really be using pm_runtime apis.
> On OMAPs this is handled by the pm_domain level callbacks, in case
> your device is not runtime suspended during system suspend.

Can you suggest how else to handle this?

>> +	return 0;
>> +}
>> +
>> +static int omap_des_resume(struct device *dev)
>> +{
>> +	pm_runtime_get_sync(dev);
> 
> Same here.
> Btw, has the omap-aes or this driver been tested with system
> suspend on any platfoms?

Yes, omap-aes has been successfully tested with Suspend/Resume on AM335x platforms.

>> +	return 0;
>> +}
>> +#endif
>> +
>> +static const struct dev_pm_ops omap_des_pm_ops = {
>> +	SET_SYSTEM_SLEEP_PM_OPS(omap_des_suspend, omap_des_resume)
>> +};
>> +
>> +static struct platform_driver omap_des_driver = {
>> +	.probe	= omap_des_probe,
>> +	.remove	= omap_des_remove,
>> +	.driver	= {
>> +		.name	= "omap-des",
>> +		.owner	= THIS_MODULE,
>> +		.pm	= &omap_des_pm_ops,
>> +		.of_match_table	= omap_des_of_match,
> 
> You could use of_match_ptr() here and avoid having the empty
> omap_des_of_match defined.

Done, thanks.

Regards,

-Joel

>> +	},
>> +};
>> +
>> +module_platform_driver(omap_des_driver);
>> +
>> +MODULE_DESCRIPTION("OMAP DES hw acceleration support.");
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_AUTHOR("Joel Fernandes <joelf@ti.com>");
>>
> 

