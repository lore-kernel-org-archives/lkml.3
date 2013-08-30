Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab3H3JUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 05:20:20 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34626 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab3H3JUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 05:20:17 -0400
Message-ID: <522063AB.2030907@ti.com>
Date: Fri, 30 Aug 2013 14:49:39 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Greer <mgreer@animalcreek.com>, Tony Lindgren <tony@atomide.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/3] crypto: omap-des: Add omap-des driver for OMAP4/AM43xx
References: <1377818873-21174-1-git-send-email-joelf@ti.com> <1377818873-21174-2-git-send-email-joelf@ti.com>
In-Reply-To: <1377818873-21174-2-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[]..

> +
> +#define pr_fmt(fmt) "%s: " fmt, __func__
> +
> +#ifdef DEBUG
> +#define prn(num) printk(#num "=%d\n", num)
> +#define prx(num) printk(#num "=%x\n", num)
> +#else
> +#define prn(num) do { } while (0)
> +#define prx(num)  do { } while (0)
> +#endif
> +
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/errno.h>
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/scatterlist.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/dmaengine.h>
> +#include <linux/omap-dma.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/of_address.h>
> +#include <linux/io.h>
> +#include <linux/crypto.h>
> +#include <linux/interrupt.h>
> +#include <crypto/scatterwalk.h>
> +#include <crypto/des.h>
> +
> +#define DST_MAXBURST			2
> +
> +#define DES_BLOCK_WORDS		(DES_BLOCK_SIZE >> 2)
> +
> +#define _calc_walked(inout) (dd->inout##_walk.offset - dd->inout##_sg->offset)
> +
> +#define DES_REG_KEY(dd, x)		((dd)->pdata->key_ofs - \
> +						((x ^ 0x01) * 0x04))
> +
> +#define DES_REG_IV(dd, x)		((dd)->pdata->iv_ofs + ((x) * 0x04))
> +
> +#define DES_REG_CTRL(dd)		((dd)->pdata->ctrl_ofs)
> +#define DES_REG_CTRL_CBC		(1 << 4)
> +#define DES_REG_CTRL_TDES		(1 << 3)
> +#define DES_REG_CTRL_DIRECTION		(1 << 2)
> +#define DES_REG_CTRL_INPUT_READY	(1 << 1)
> +#define DES_REG_CTRL_OUTPUT_READY	(1 << 0)

Why not use bitops like you have done below.

> +
> +#define DES_REG_DATA_N(dd, x)		((dd)->pdata->data_ofs + ((x) * 0x04))
> +
> +#define DES_REG_REV(dd)			((dd)->pdata->rev_ofs)
> +
> +#define DES_REG_MASK(dd)		((dd)->pdata->mask_ofs)
> +
> +#define DES_REG_LENGTH_N(x)		(0x24 + ((x) * 0x04))
> +
> +#define DES_REG_IRQ_STATUS(dd)         ((dd)->pdata->irq_status_ofs)
> +#define DES_REG_IRQ_ENABLE(dd)         ((dd)->pdata->irq_enable_ofs)
> +#define DES_REG_IRQ_DATA_IN            BIT(1)
> +#define DES_REG_IRQ_DATA_OUT           BIT(2)
> +
> +#define FLAGS_MODE_MASK		0x000f
> +#define FLAGS_ENCRYPT		BIT(0)
> +#define FLAGS_CBC		BIT(1)
> +#define FLAGS_INIT		BIT(4)
> +#define FLAGS_BUSY		BIT(6)
> +

[]..

> +struct omap_des_pdata {
> +	struct omap_des_algs_info	*algs_info;
> +	unsigned int	algs_info_size;
> +
> +	void		(*trigger)(struct omap_des_dev *dd, int length);

Is this really used? How does a DT platform pass function pointers?

> +
> +	u32		key_ofs;
> +	u32		iv_ofs;
> +	u32		ctrl_ofs;
> +	u32		data_ofs;
> +	u32		rev_ofs;
> +	u32		mask_ofs;
> +	u32             irq_enable_ofs;
> +	u32             irq_status_ofs;
> +
> +	u32		dma_enable_in;
> +	u32		dma_enable_out;
> +	u32		dma_start;
> +
> +	u32		major_mask;
> +	u32		major_shift;
> +	u32		minor_mask;
> +	u32		minor_shift;
> +};
> +
> +struct omap_des_dev {
> +	struct list_head	list;
> +	unsigned long		phys_base;
> +	void __iomem		*io_base;
> +	struct omap_des_ctx	*ctx;
> +	struct device		*dev;
> +	unsigned long		flags;
> +	int			err;
> +
> +	/* spinlock used for queues */
> +	spinlock_t		lock;
> +	struct crypto_queue	queue;
> +
> +	struct tasklet_struct	done_task;
> +	struct tasklet_struct	queue_task;
> +
> +	struct ablkcipher_request	*req;
> +	/*
> +	 * total is used by PIO mode for book keeping so introduce
> +	 * variable total_save as need it to calc page_order
> +	 */
> +	size_t                          total;
> +	size_t                          total_save;
> +
> +	struct scatterlist		*in_sg;
> +	struct scatterlist		*out_sg;
> +
> +	/* Buffers for copying for unaligned cases */
> +	struct scatterlist		in_sgl;
> +	struct scatterlist		out_sgl;
> +	struct scatterlist		*orig_out;
> +	int				sgs_copied;
> +
> +	struct scatter_walk		in_walk;
> +	struct scatter_walk		out_walk;
> +	int			dma_in;
> +	struct dma_chan		*dma_lch_in;
> +	int			dma_out;
> +	struct dma_chan		*dma_lch_out;
> +	int			in_sg_len;
> +	int			out_sg_len;
> +	int			pio_only;
> +	const struct omap_des_pdata	*pdata;
> +};
> +
> +/* keep registered devices data here */
> +static LIST_HEAD(dev_list);
> +static DEFINE_SPINLOCK(list_lock);
> +

[]..

> +
> +static int omap_des_crypt_dma_start(struct omap_des_dev *dd)
> +{
> +	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(
> +					crypto_ablkcipher_reqtfm(dd->req));
> +	int err;
> +
> +	pr_debug("total: %d\n", dd->total);
> +
> +	if (!dd->pio_only) {
> +		err = dma_map_sg(dd->dev, dd->in_sg, dd->in_sg_len,
> +				 DMA_TO_DEVICE);
> +		if (!err) {
> +			dev_err(dd->dev, "dma_map_sg() error\n");
> +			return -EINVAL;
> +		}
> +
> +		err = dma_map_sg(dd->dev, dd->out_sg, dd->out_sg_len,
> +				 DMA_FROM_DEVICE);
> +		if (!err) {
> +			dev_err(dd->dev, "dma_map_sg() error\n");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	err = omap_des_crypt_dma(tfm, dd->in_sg, dd->out_sg, dd->in_sg_len,
> +				 dd->out_sg_len);
> +	if (err && !dd->pio_only) {
> +		dma_unmap_sg(dd->dev, dd->in_sg, dd->in_sg_len, DMA_TO_DEVICE);
> +		dma_unmap_sg(dd->dev, dd->out_sg, dd->out_sg_len,
> +			     DMA_FROM_DEVICE);
> +	}
> +
> +	return err;
> +}
> +
> +static void omap_des_finish_req(struct omap_des_dev *dd, int err)
> +{
> +	struct ablkcipher_request *req = dd->req;
> +
> +	pr_debug("err: %d\n", err);
> +
> +	pm_runtime_put(dd->dev);

You seem to do a pm_runtime_get_sync() in omap_des_write_ctrl() and a
pm_runtime_put() here and not a pm_runtime_put_sync()?

> +	dd->flags &= ~FLAGS_BUSY;
> +
> +	req->base.complete(&req->base, err);
> +}
> +
> +static int omap_des_crypt_dma_stop(struct omap_des_dev *dd)
> +{
> +	int err = 0;
> +
> +	pr_debug("total: %d\n", dd->total);
> +
> +	omap_des_dma_stop(dd);
> +
> +	dmaengine_terminate_all(dd->dma_lch_in);
> +	dmaengine_terminate_all(dd->dma_lch_out);
> +
> +	dma_unmap_sg(dd->dev, dd->in_sg, dd->in_sg_len, DMA_TO_DEVICE);
> +	dma_unmap_sg(dd->dev, dd->out_sg, dd->out_sg_len, DMA_FROM_DEVICE);
> +
> +	return err;
> +}
> +
> +int omap_des_copy_needed(struct scatterlist *sg)
> +{
> +	while (sg) {
> +		if (!IS_ALIGNED(sg->offset, 4))
> +			return -1;
> +		if (!IS_ALIGNED(sg->length, DES_BLOCK_SIZE))
> +			return -1;
> +		sg = sg_next(sg);
> +	}
> +	return 0;
> +}
> +
> +int omap_des_copy_sgs(struct omap_des_dev *dd)
> +{
> +	void *buf_in, *buf_out;
> +	int pages;
> +
> +	pages = dd->total >> PAGE_SHIFT;
> +
> +	if (dd->total & (PAGE_SIZE-1))
> +		pages++;
> +
> +	BUG_ON(!pages);
> +
> +	buf_in = (void *)__get_free_pages(GFP_ATOMIC, pages);
> +	buf_out = (void *)__get_free_pages(GFP_ATOMIC, pages);
> +
> +	if (!buf_in || !buf_out) {
> +		pr_err("Couldn't allocated pages for unaligned cases.\n");
> +		return -1;
> +	}
> +
> +	dd->orig_out = dd->out_sg;
> +
> +	sg_copy_buf(buf_in, dd->in_sg, 0, dd->total, 0);
> +
> +	sg_init_table(&dd->in_sgl, 1);
> +	sg_set_buf(&dd->in_sgl, buf_in, dd->total);
> +	dd->in_sg = &dd->in_sgl;
> +
> +	sg_init_table(&dd->out_sgl, 1);
> +	sg_set_buf(&dd->out_sgl, buf_out, dd->total);
> +	dd->out_sg = &dd->out_sgl;
> +
> +	return 0;
> +}
> +

[]..

> +
> +#ifdef CONFIG_OF
> +static const struct omap_des_pdata omap_des_pdata_omap4 = {
> +	.algs_info	= omap_des_algs_info_ecb_cbc,
> +	.algs_info_size	= ARRAY_SIZE(omap_des_algs_info_ecb_cbc),
> +	.trigger	= omap_des_dma_trigger_omap4,
> +	.key_ofs	= 0x14,
> +	.iv_ofs		= 0x18,
> +	.ctrl_ofs	= 0x20,
> +	.data_ofs	= 0x28,
> +	.rev_ofs	= 0x30,
> +	.mask_ofs	= 0x34,
> +	.irq_status_ofs = 0x3c,
> +	.irq_enable_ofs = 0x40,
> +	.dma_enable_in	= BIT(5),
> +	.dma_enable_out	= BIT(6),
> +	.major_mask	= 0x0700,
> +	.major_shift	= 8,
> +	.minor_mask	= 0x003f,
> +	.minor_shift	= 0,
> +};
> +
> +static irqreturn_t omap_des_irq(int irq, void *dev_id)
> +{
> +	struct omap_des_dev *dd = dev_id;
> +	u32 status, i;
> +	u32 *src, *dst;
> +
> +	status = omap_des_read(dd, DES_REG_IRQ_STATUS(dd));
> +	if (status & DES_REG_IRQ_DATA_IN) {
> +		omap_des_write(dd, DES_REG_IRQ_ENABLE(dd), 0x0);
> +
> +		BUG_ON(!dd->in_sg);
> +
> +		BUG_ON(_calc_walked(in) > dd->in_sg->length);
> +
> +		src = sg_virt(dd->in_sg) + _calc_walked(in);
> +
> +		for (i = 0; i < DES_BLOCK_WORDS; i++) {
> +			omap_des_write(dd, DES_REG_DATA_N(dd, i), *src);
> +
> +			scatterwalk_advance(&dd->in_walk, 4);
> +			if (dd->in_sg->length == _calc_walked(in)) {
> +				dd->in_sg = scatterwalk_sg_next(dd->in_sg);
> +				if (dd->in_sg) {
> +					scatterwalk_start(&dd->in_walk,
> +							  dd->in_sg);
> +					src = sg_virt(dd->in_sg) +
> +					      _calc_walked(in);
> +				}
> +			} else {
> +				src++;
> +			}
> +		}
> +
> +		/* Clear IRQ status */
> +		status &= ~DES_REG_IRQ_DATA_IN;
> +		omap_des_write(dd, DES_REG_IRQ_STATUS(dd), status);
> +
> +		/* Enable DATA_OUT interrupt */
> +		omap_des_write(dd, DES_REG_IRQ_ENABLE(dd), 0x4);
> +
> +	} else if (status & DES_REG_IRQ_DATA_OUT) {
> +		omap_des_write(dd, DES_REG_IRQ_ENABLE(dd), 0x0);
> +
> +		BUG_ON(!dd->out_sg);
> +
> +		BUG_ON(_calc_walked(out) > dd->out_sg->length);
> +
> +		dst = sg_virt(dd->out_sg) + _calc_walked(out);
> +
> +		for (i = 0; i < DES_BLOCK_WORDS; i++) {
> +			*dst = omap_des_read(dd, DES_REG_DATA_N(dd, i));
> +			scatterwalk_advance(&dd->out_walk, 4);
> +			if (dd->out_sg->length == _calc_walked(out)) {
> +				dd->out_sg = scatterwalk_sg_next(dd->out_sg);
> +				if (dd->out_sg) {
> +					scatterwalk_start(&dd->out_walk,
> +							  dd->out_sg);
> +					dst = sg_virt(dd->out_sg) +
> +					      _calc_walked(out);
> +				}
> +			} else {
> +				dst++;
> +			}
> +		}
> +
> +		dd->total -= DES_BLOCK_SIZE;
> +
> +		BUG_ON(dd->total < 0);
> +
> +		/* Clear IRQ status */
> +		status &= ~DES_REG_IRQ_DATA_OUT;
> +		omap_des_write(dd, DES_REG_IRQ_STATUS(dd), status);
> +
> +		if (!dd->total)
> +			/* All bytes read! */
> +			tasklet_schedule(&dd->done_task);
> +		else
> +			/* Enable DATA_IN interrupt for next block */
> +			omap_des_write(dd, DES_REG_IRQ_ENABLE(dd), 0x2);
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static const struct of_device_id omap_des_of_match[] = {
> +	{
> +		.compatible	= "ti,omap4-des",
> +		.data		= &omap_des_pdata_omap4,
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, omap_des_of_match);
> +
> +static int omap_des_get_res_of(struct omap_des_dev *dd,
> +		struct device *dev, struct resource *res)
> +{
> +	struct device_node *node = dev->of_node;
> +	const struct of_device_id *match;
> +	int err = 0;
> +
> +	match = of_match_device(of_match_ptr(omap_des_of_match), dev);
> +	if (!match) {
> +		dev_err(dev, "no compatible OF match\n");
> +		err = -EINVAL;
> +		goto err;
> +	}
> +
> +	err = of_address_to_resource(node, 0, res);

Do you really need to do this? DT should have already populated
a resource for you based on the 'reg' property.

> +	if (err < 0) {
> +		dev_err(dev, "can't translate OF node address\n");
> +		err = -EINVAL;
> +		goto err;
> +	}
> +
> +	dd->dma_out = -1; /* Dummy value that's unused */
> +	dd->dma_in = -1; /* Dummy value that's unused */
> +
> +	dd->pdata = match->data;
> +
> +err:
> +	return err;
> +}
> +#else
> +static const struct of_device_id omap_des_of_match[] = {
> +	{},
> +};

you don't need this if you use of_match_ptr()

> +
> +static int omap_des_get_res_of(struct omap_des_dev *dd,
> +		struct device *dev, struct resource *res)
> +{
> +	return -EINVAL;
> +}
> +#endif
> +
> +static int omap_des_get_res_pdev(struct omap_des_dev *dd,
> +		struct platform_device *pdev, struct resource *res)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct resource *r;
> +	int err = 0;
> +
> +	/* Get the base address */
> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!r) {
> +		dev_err(dev, "no MEM resource info\n");
> +		err = -ENODEV;
> +		goto err;
> +	}
> +	memcpy(res, r, sizeof(*res));

I don't think you need any of this. Regardless of a DT or a
non-DT platform, you should be able to do a platform_get_resource()
for mem resources.

> +
> +	/* Get the DMA out channel */
> +	r = platform_get_resource(pdev, IORESOURCE_DMA, 0);
> +	if (!r) {
> +		dev_err(dev, "no DMA out resource info\n");
> +		err = -ENODEV;
> +		goto err;
> +	}
> +	dd->dma_out = r->start;
> +
> +	/* Get the DMA in channel */
> +	r = platform_get_resource(pdev, IORESOURCE_DMA, 1);
> +	if (!r) {
> +		dev_err(dev, "no DMA in resource info\n");
> +		err = -ENODEV;
> +		goto err;
> +	}
> +	dd->dma_in = r->start;
> +
> +	/* non-DT devices get pdata from pdev */
> +	dd->pdata = pdev->dev.platform_data;
> +
> +err:
> +	return err;
> +}
> +
> +static int omap_des_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct omap_des_dev *dd;
> +	struct crypto_alg *algp;
> +	struct resource res;
> +	int err = -ENOMEM, i, j, irq = -1;
> +	u32 reg;
> +
> +	dd = devm_kzalloc(dev, sizeof(struct omap_des_dev), GFP_KERNEL);
> +	if (dd == NULL) {
> +		dev_err(dev, "unable to alloc data struct.\n");
> +		goto err_data;
> +	}
> +	dd->dev = dev;
> +	platform_set_drvdata(pdev, dd);
> +
> +	spin_lock_init(&dd->lock);
> +	crypto_init_queue(&dd->queue, OMAP_DES_QUEUE_LENGTH);
> +
> +	err = (dev->of_node) ? omap_des_get_res_of(dd, dev, &res) :
> +			       omap_des_get_res_pdev(dd, pdev, &res);
> +	if (err)
> +		goto err_res;
> +
> +	dd->io_base = devm_request_and_ioremap(dev, &res);
> +	if (!dd->io_base) {
> +		dev_err(dev, "can't ioremap\n");
> +		err = -ENOMEM;
> +		goto err_res;
> +	}
> +	dd->phys_base = res.start;
> +
> +	pm_runtime_enable(dev);
> +	pm_runtime_get_sync(dev);
> +
> +	omap_des_dma_stop(dd);
> +
> +	reg = omap_des_read(dd, DES_REG_REV(dd));
> +
> +	pm_runtime_put_sync(dev);
> +
> +	dev_info(dev, "OMAP DES hw accel rev: %u.%u\n",
> +		 (reg & dd->pdata->major_mask) >> dd->pdata->major_shift,
> +		 (reg & dd->pdata->minor_mask) >> dd->pdata->minor_shift);
> +
> +	tasklet_init(&dd->done_task, omap_des_done_task, (unsigned long)dd);
> +	tasklet_init(&dd->queue_task, omap_des_queue_task, (unsigned long)dd);
> +
> +	err = omap_des_dma_init(dd);
> +	if (err && DES_REG_IRQ_STATUS(dd) && DES_REG_IRQ_ENABLE(dd)) {
> +		dd->pio_only = 1;
> +
> +		irq = platform_get_irq(pdev, 0);
> +		if (irq < 0) {
> +			dev_err(dev, "can't get IRQ resource\n");
> +			goto err_irq;
> +		}
> +
> +		err = devm_request_irq(dev, irq, omap_des_irq, 0,
> +				dev_name(dev), dd);
> +		if (err) {
> +			dev_err(dev, "Unable to grab omap-des IRQ\n");
> +			goto err_irq;
> +		}
> +	}
> +
> +
> +	INIT_LIST_HEAD(&dd->list);
> +	spin_lock(&list_lock);
> +	list_add_tail(&dd->list, &dev_list);
> +	spin_unlock(&list_lock);
> +
> +	for (i = 0; i < dd->pdata->algs_info_size; i++) {
> +		for (j = 0; j < dd->pdata->algs_info[i].size; j++) {
> +			algp = &dd->pdata->algs_info[i].algs_list[j];
> +
> +			pr_debug("reg alg: %s\n", algp->cra_name);
> +			INIT_LIST_HEAD(&algp->cra_list);
> +
> +			err = crypto_register_alg(algp);
> +			if (err)
> +				goto err_algs;
> +
> +			dd->pdata->algs_info[i].registered++;
> +		}
> +	}
> +
> +	return 0;
> +err_algs:
> +	for (i = dd->pdata->algs_info_size - 1; i >= 0; i--)
> +		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--)
> +			crypto_unregister_alg(
> +					&dd->pdata->algs_info[i].algs_list[j]);
> +	if (!dd->pio_only)
> +		omap_des_dma_cleanup(dd);
> +err_irq:
> +	tasklet_kill(&dd->done_task);
> +	tasklet_kill(&dd->queue_task);
> +	pm_runtime_disable(dev);
> +err_res:
> +	dd = NULL;
> +err_data:
> +	dev_err(dev, "initialization failed.\n");
> +	return err;
> +}
> +
> +static int omap_des_remove(struct platform_device *pdev)
> +{
> +	struct omap_des_dev *dd = platform_get_drvdata(pdev);
> +	int i, j;
> +
> +	if (!dd)
> +		return -ENODEV;
> +
> +	spin_lock(&list_lock);
> +	list_del(&dd->list);
> +	spin_unlock(&list_lock);
> +
> +	for (i = dd->pdata->algs_info_size - 1; i >= 0; i--)
> +		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--)
> +			crypto_unregister_alg(
> +					&dd->pdata->algs_info[i].algs_list[j]);
> +
> +	tasklet_kill(&dd->done_task);
> +	tasklet_kill(&dd->queue_task);
> +	omap_des_dma_cleanup(dd);
> +	pm_runtime_disable(dd->dev);
> +	dd = NULL;
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int omap_des_suspend(struct device *dev)
> +{
> +	pm_runtime_put_sync(dev);

I know you seemed to have taken this from the omap-aes driver, but this
does not seem correct. Your system suspend callbacks shouldn't
really be using pm_runtime apis.
On OMAPs this is handled by the pm_domain level callbacks, in case
your device is not runtime suspended during system suspend.

> +	return 0;
> +}
> +
> +static int omap_des_resume(struct device *dev)
> +{
> +	pm_runtime_get_sync(dev);

Same here.
Btw, has the omap-aes or this driver been tested with system
suspend on any platfoms?

> +	return 0;
> +}
> +#endif
> +
> +static const struct dev_pm_ops omap_des_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(omap_des_suspend, omap_des_resume)
> +};
> +
> +static struct platform_driver omap_des_driver = {
> +	.probe	= omap_des_probe,
> +	.remove	= omap_des_remove,
> +	.driver	= {
> +		.name	= "omap-des",
> +		.owner	= THIS_MODULE,
> +		.pm	= &omap_des_pm_ops,
> +		.of_match_table	= omap_des_of_match,

You could use of_match_ptr() here and avoid having the empty
omap_des_of_match defined.

> +	},
> +};
> +
> +module_platform_driver(omap_des_driver);
> +
> +MODULE_DESCRIPTION("OMAP DES hw acceleration support.");
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Joel Fernandes <joelf@ti.com>");
> 

