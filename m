Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaINUXe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 16:23:34 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:56202 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752788AbaINUXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 16:23:33 -0400
Date: Sun, 14 Sep 2014 21:23:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ankit Jindal <ankit.jindal@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@apm.com,
        Rob Herring <robh+dt@kernel.org>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/5] drivers: uio: Add Xgene QMTM UIO driver
Message-ID: <20140914202323.GW12361@n2100.arm.linux.org.uk>
References: <1410256619-3213-1-git-send-email-ankit.jindal@linaro.org> <1410256619-3213-4-git-send-email-ankit.jindal@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410256619-3213-4-git-send-email-ankit.jindal@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 03:26:57PM +0530, Ankit Jindal wrote:
> diff --git a/drivers/uio/uio_xgene_qmtm.c b/drivers/uio/uio_xgene_qmtm.c
...
> +/* QMTM CSR read/write routine */
> +static inline void qmtm_csr_write(struct uio_qmtm_dev *qmtm_dev, u32 offset,
> +		u32 data)
> +{
> +	void __iomem *addr = (u8 *)qmtm_dev->info->mem[0].internal_addr +
> +		offset;
> +
> +	writel(data, addr);

Why not...
	void __iomem *base = qmtm_dev->info->mem[0].internal_addr;

	writel(data, addr + offset);

We permit void pointer arithmetic in the kernel.

> +static int qmtm_reset(struct uio_qmtm_dev *qmtm_dev)
> +{
...
> +	/* check whether device is out of reset or not */
> +	do {
> +		val = qmtm_csr_read(qmtm_dev, QMTM_CFG_MEM_RAM_SHUTDOWN);
> +
> +		if (!wait--)
> +			return -1;
> +		udelay(1);
> +	} while (val == 0xffffffff);

There's two points about the above:

1. The loop is buggy.  A correct implementation would:
	- test for the success condition
	- on success, break out of the loop
	- decrement the timeout, and break out of the loop if we have timed out
	- delay the required delay
	- repeat

   Note that this means that we will always check for success before
   deciding whether we've failed or not, /and/ without penalty of an
   unnecessary delay (as you have.)

2. returning -1 here is not on.  This value can (via your probe
   function) be propagated to userspace, where it will be interpreted
   as an -EPERM error.  Wouldn't a proper errno be better?

> +static void qmtm_cleanup(struct platform_device *pdev,
> +		struct uio_qmtm_dev *qmtm_dev)
> +{
> +	struct uio_info *info = qmtm_dev->info;
> +
> +	uio_unregister_device(info);
> +
> +	kfree(info->name);
> +
> +	if (!IS_ERR(info->mem[0].internal_addr))
> +		devm_iounmap(&pdev->dev, info->mem[0].internal_addr);

So what if we hit a failure at

	platform_get_resource(pdev, IORESOURCE_MEM, 0);

in the probe function below, and call this function.  The purpose of the
devm_* stuff is to avoid these kinds of error-cleanup errors by automating
that stuff.  devm_* APIs record the resource allocations against the
device, and when the probe function fails, or the driver is unbound, the
devm_* resources claimed in the probe function are freed.

> +
> +	kfree(info);
> +	clk_put(qmtm_dev->qmtm_clk);
> +	kfree(qmtm_dev);

All of the above, with the exception of uio_unregister_device() and the
missing clk_unprepare_disable() can be left to the devm_* stuff to deal
with, if you'd used the devm_* functions in the probe function.

> +}
> +
> +static int qmtm_probe(struct platform_device *pdev)
> +{
> +	struct uio_info *info;
> +	struct uio_qmtm_dev *qmtm_dev;
> +	struct resource *csr;
> +	struct resource *fabric;
> +	struct resource *qpool;
> +	unsigned int num_queues;
> +	unsigned int devid;
> +	int ret = -ENODEV;

Probably a bad idea to use a standard value.  You probably have some
error codes you've forgotten to propagate.

> +
> +	qmtm_dev = kzalloc(sizeof(struct uio_qmtm_dev), GFP_KERNEL);

devm_kzalloc

> +	if (!qmtm_dev)
> +		return -ENOMEM;
> +
> +	qmtm_dev->info = kzalloc(sizeof(*info), GFP_KERNEL);

devm_kzalloc

> +	if (!qmtm_dev->info) {
> +		kfree(qmtm_dev);

No need for this free.

> +		return -ENOMEM;
> +	}
> +
> +	/* Power on qmtm in case its not done as part of boot-loader */
> +	qmtm_dev->qmtm_clk = clk_get(&pdev->dev, NULL);

devm_clk_get

> +	if (IS_ERR(qmtm_dev->qmtm_clk)) {
> +		dev_err(&pdev->dev, "Failed to get clock\n");
> +		ret = PTR_ERR(qmtm_dev->qmtm_clk);
> +		kfree(qmtm_dev->info);
> +		kfree(qmtm_dev);

Both kfree's can be removed.

> +		return ret;
> +	} else {
> +		clk_prepare_enable(qmtm_dev->qmtm_clk);
> +	}
> +
> +	csr = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!csr) {
> +		dev_err(&pdev->dev, "No QMTM CSR resource specified\n");
> +		goto out_free;
> +	}
> +
> +	if (!csr->start) {
> +		dev_err(&pdev->dev, "Invalid CSR resource\n");
> +		goto out_free;
> +	}
> +
> +	fabric = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	if (!fabric) {
> +		dev_err(&pdev->dev, "No QMTM Fabric resource specified\n");
> +		goto out_free;
> +	}
> +
> +	if (!fabric->start) {
> +		dev_err(&pdev->dev, "Invalid Fabric resource\n");
> +		goto out_free;
> +	}
> +
> +	qpool = platform_get_resource(pdev, IORESOURCE_MEM, 2);
> +	if (!qpool) {
> +		dev_err(&pdev->dev, "No QMTM Qpool resource specified\n");
> +		goto out_free;
> +	}
> +
> +	if (!qpool->start) {
> +		dev_err(&pdev->dev, "Invalid Qpool resource\n");
> +		goto out_free;
> +	}
> +
> +	ret = of_property_read_u32(pdev->dev.of_node, "num_queues",
> +			&num_queues);

You may wish to consider checking that you have a pdev->dev.of_node and
cleanly error if you don't.

> +
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "No num_queues resource specified\n");
> +		goto out_free;
> +	}
> +
> +	/* check whether sufficient memory is provided for the given queues */
> +	if (!((num_queues * QMTM_DEFAULT_QSIZE) <= resource_size(qpool))) {
> +		dev_err(&pdev->dev, "Insufficient Qpool for the given queues\n");
> +		goto out_free;
> +	}
> +
> +	ret = of_property_read_u32(pdev->dev.of_node, "devid", &devid);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "No devid resource specified\n");
> +		goto out_free;
> +	}
> +
> +	info = qmtm_dev->info;
> +	info->mem[0].name = "csr";
> +	info->mem[0].addr = csr->start;
> +	info->mem[0].size = resource_size(csr);
> +	info->mem[0].memtype = UIO_MEM_PHYS;
> +	info->mem[0].internal_addr = devm_ioremap_resource(&pdev->dev, csr);
> +
> +	if (IS_ERR(info->mem[0].internal_addr)) {
> +		dev_err(&pdev->dev, "Failed to ioremap CSR region\n");

How about printing the error code, and propagating that error code to your
caller?

> +		goto out_free;
> +	}
> +
> +	info->mem[1].name = "fabric";
> +	info->mem[1].addr = fabric->start;
> +	info->mem[1].size = resource_size(fabric);
> +	info->mem[1].memtype = UIO_MEM_PHYS;
> +
> +	info->mem[2].name = "qpool";
> +	info->mem[2].addr = qpool->start;
> +	info->mem[2].size = resource_size(qpool);
> +	info->mem[2].memtype = UIO_MEM_PHYS_CACHE;
> +
> +	info->name = kasprintf(GFP_KERNEL, "qmtm%d", devid);

devm_kasprintf

> +	info->version = DRV_VERSION;
> +
> +	info->priv = qmtm_dev;
> +	info->open = qmtm_open;
> +	info->release = qmtm_release;
> +
> +	/* get the qmtm out of reset */
> +	ret = qmtm_reset(qmtm_dev);
> +	if (ret < 0)
> +		goto out_free;

Here you propagate that -1 value out of your probe function to userspace.
If you want to do this, please choose a reasonable error code, rather
than -EPERM.

> +
> +	/* register with uio framework */
> +	ret = uio_register_device(&pdev->dev, info);
> +	if (ret < 0)
> +		goto out_free;
> +
> +	dev_info(&pdev->dev, "%s registered as UIO device.\n", info->name);

Does this printk serve a useful purpose?  Most other UIO drivers don't
bother printing anything, though if you do print something, it may be
useful to mention which uio device it is associated with.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
