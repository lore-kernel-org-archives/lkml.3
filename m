Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaJUGHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 02:07:55 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:45242 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaJUGHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 02:07:53 -0400
Message-ID: <5445F781.7010804@gmail.com>
Date: Tue, 21 Oct 2014 11:34:49 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ankit Jindal <ankit.jindal@linaro.org>, linux-kernel@vger.kernel.org
CC: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@apm.com,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v3 4/6] uio: Add X-Gene QMTM UIO driver
References: <1413871011-4101-1-git-send-email-ankit.jindal@linaro.org> <1413871011-4101-5-git-send-email-ankit.jindal@linaro.org>
In-Reply-To: <1413871011-4101-5-git-send-email-ankit.jindal@linaro.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 11:26 AM, Ankit Jindal wrote:
> The Applied Micro X-Gene SOC has on-chip QMTM (Queue manager
> and Traffic manager) which is hardware based Queue or Ring
> manager. This QMTM device can be used in conjunction with
> other devices such as DMA Engine, Ethernet, Security Engine,
> etc to assign work based on queues or rings.
>
> This patch allows user space access to X-Gene QMTM device.
>
> Signed-off-by: Ankit Jindal <ankit.jindal@linaro.org>
> Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>

(...)

> +
> +static int qmtm_probe(struct platform_device *pdev)
> +{
> +	struct uio_info *info;
> +	struct uio_qmtm_dev *qmtm_dev;
> +	struct resource *csr;
> +	struct resource *fabric;
> +	struct resource qpool;
> +	unsigned int num_queues;
> +	unsigned int devid;
> +	phandle qpool_phandle;
> +	struct device_node *qpool_node;
> +	int ret;
> +
> +	qmtm_dev = devm_kzalloc(&pdev->dev, sizeof(struct uio_qmtm_dev),
> +				GFP_KERNEL);
> +	if (!qmtm_dev)
> +		return -ENOMEM;
> +
> +	qmtm_dev->info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
> +	if (!qmtm_dev->info)
> +		return -ENOMEM;
> +
> +	/* Power on qmtm in case its not done as part of boot-loader */
> +	qmtm_dev->qmtm_clk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(qmtm_dev->qmtm_clk)) {
> +		dev_err(&pdev->dev, "Failed to get clock\n");
> +		ret = PTR_ERR(qmtm_dev->qmtm_clk);
> +		return ret;
> +	}
> +
> +	csr = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!csr) {
> +		ret = -ENODEV;
> +		dev_err(&pdev->dev, "No QMTM CSR resource specified\n");
> +		goto out_err;
> +	}
> +

This error check is not required. *csr* is checked in devm_ioremap_resource().

> +	if (!csr->start) {
> +		ret = -EINVAL;
> +		dev_err(&pdev->dev, "Invalid CSR resource\n");
> +		goto out_err;
> +	}
> +
> +	fabric = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	if (!fabric) {
> +		ret = -ENODEV;
> +		dev_err(&pdev->dev, "No QMTM Fabric resource specified\n");
> +		goto out_err;
> +	}
> +

same

> +	if (!fabric->start) {
> +		ret = -EINVAL;
> +		dev_err(&pdev->dev, "Invalid Fabric resource\n");
> +		goto out_err;
> +	}
> +
> +	ret = of_property_read_u32(pdev->dev.of_node, "qpool", &qpool_phandle);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "No qpool resource specified\n");
> +		goto out_err;
> +	}
> +
> +	qpool_node = of_find_node_by_phandle(qpool_phandle);
> +	if (IS_ERR_OR_NULL(qpool_node)) {
> +		ret = PTR_ERR(qpool_node);
> +		dev_err(&pdev->dev, "Failed to get node by phandle\n");
> +		goto out_err;
> +	}
> +
> +	ret = of_address_to_resource(qpool_node, 0, &qpool);
> +
> +	of_node_put(qpool_node);
> +
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Failed to get qpool resource from node\n");
> +		goto out_err;
> +	}
> +
> +	if (!qpool.start) {
> +		ret = -EINVAL;
> +		dev_err(&pdev->dev, "Invalid qpool resource\n");
> +		goto out_err;
> +	}
> +
> +	ret = of_property_read_u32(pdev->dev.of_node, "num-queues",
> +			&num_queues);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "No num-queues resource specified\n");
> +		goto out_err;
> +	}
> +
> +	/* check whether sufficient memory is provided for the given queues */
> +	if (num_queues * QMTM_DEFAULT_QSIZE > resource_size(&qpool)) {
> +		ret = -ENOSPC;
> +		dev_err(&pdev->dev, "Insufficient Qpool for the given queues\n");
> +		goto out_err;
> +	}
> +
> +	ret = of_property_read_u32(pdev->dev.of_node, "devid", &devid);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "No devid resource specified\n");
> +		goto out_err;
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
> +		ret = PTR_ERR(info->mem[0].internal_addr);
> +		dev_err(&pdev->dev, "Failed to ioremap CSR region\n");
> +		goto out_err;
> +	}
> +
> +	info->mem[1].name = "fabric";
> +	info->mem[1].addr = fabric->start;
> +	info->mem[1].size = resource_size(fabric);
> +	info->mem[1].memtype = UIO_MEM_PHYS;
> +
> +	info->mem[2].name = "qpool";
> +	info->mem[2].addr = qpool.start;
> +	info->mem[2].size = resource_size(&qpool);
> +	info->mem[2].memtype = UIO_MEM_PHYS_CACHE;
> +
> +	info->name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "qmtm%d", devid);
> +	info->version = DRV_VERSION;
> +
> +	info->priv = qmtm_dev;
> +
> +	/* enable the clock */
> +	clk_prepare_enable(qmtm_dev->qmtm_clk);
> +
> +	/* get the qmtm out of reset */
> +	ret = qmtm_reset(qmtm_dev);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Failed to reset QMTM\n");
> +		goto out_clk;
> +	}
> +
> +	/* register with uio framework */
> +	ret = uio_register_device(&pdev->dev, info);
> +	if (ret < 0)
> +		goto out_clk;
> +
> +	platform_set_drvdata(pdev, qmtm_dev);
> +	return 0;
> +
> +out_clk:
> +	clk_disable_unprepare(qmtm_dev->qmtm_clk);
> +
> +out_err:
> +	return ret;
> +}
>


-- 
Regards,
Varka Bhadram.

