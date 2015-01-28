Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbbA1Dj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 22:39:26 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30231 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756573AbbA1DjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 22:39:24 -0500
Date: Wed, 28 Jan 2015 11:35:52 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] mtd: pxa3xx_nand: add a non mandatory ECC clock
Message-ID: <20150128113552.5dd3edc4@xhacker>
In-Reply-To: <1422367816-4257-3-git-send-email-antoine.tenart@free-electrons.com>
References: <1422367816-4257-1-git-send-email-antoine.tenart@free-electrons.com>
	<1422367816-4257-3-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-27_04:2015-01-27,2015-01-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1501280038
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Antoine,

On Tue, 27 Jan 2015 06:10:09 -0800
Antoine Tenart <antoine.tenart@free-electrons.com> wrote:

> Some controllers (as the coming Berlin nand controller) need to enable
> an ECC clock. Add support for this clock in the pxa3xx nand driver, and
> leave it as non mandatory.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> ---
>  drivers/mtd/nand/pxa3xx_nand.c | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
> index d00ac392d1c4..2681ec4abafa 100644
> --- a/drivers/mtd/nand/pxa3xx_nand.c
> +++ b/drivers/mtd/nand/pxa3xx_nand.c
> @@ -180,7 +180,7 @@ struct pxa3xx_nand_info {
>  	struct nand_hw_control	controller;
>  	struct platform_device	 *pdev;
>  
> -	struct clk		*clk;
> +	struct clk		*clk, *ecc_clk;
>  	void __iomem		*mmio_base;
>  	unsigned long		mmio_phys;
>  	struct completion	cmd_complete, dev_ready;
> @@ -1608,7 +1608,7 @@ static int alloc_nand_resource(struct platform_device
> *pdev) 
>  	spin_lock_init(&chip->controller->lock);
>  	init_waitqueue_head(&chip->controller->wq);
> -	info->clk = devm_clk_get(&pdev->dev, NULL);
> +	info->clk = devm_clk_get(&pdev->dev, "nfc");
>  	if (IS_ERR(info->clk)) {

Do we need to fall back to unnamed clock here? Otherwise I guess it will break
other platforms.

>  		dev_err(&pdev->dev, "failed to get nand clock\n");
>  		return PTR_ERR(info->clk);
> @@ -1617,6 +1617,13 @@ static int alloc_nand_resource(struct
> platform_device *pdev) if (ret < 0)
>  		return ret;
>  
> +	info->ecc_clk = devm_clk_get(&pdev->dev, "ecc");
> +	if (!IS_ERR(info->ecc_clk)) {
> +		ret = clk_prepare_enable(info->ecc_clk);
> +		if (ret < 0)
> +			goto fail_disable_clk;
> +	}
> +
>  	if (use_dma) {
>  		/*
>  		 * This is a dirty hack to make this driver work from
> @@ -1633,7 +1640,7 @@ static int alloc_nand_resource(struct platform_device
> *pdev) dev_err(&pdev->dev,
>  					"no resource defined for data
> DMA\n"); ret = -ENXIO;
> -				goto fail_disable_clk;
> +				goto fail_disable_ecc_clk;
>  			}
>  			info->drcmr_dat = r->start;
>  
> @@ -1642,7 +1649,7 @@ static int alloc_nand_resource(struct platform_device
> *pdev) dev_err(&pdev->dev,
>  					"no resource defined for cmd
> DMA\n"); ret = -ENXIO;
> -				goto fail_disable_clk;
> +				goto fail_disable_ecc_clk;
>  			}
>  			info->drcmr_cmd = r->start;
>  		}
> @@ -1652,14 +1659,14 @@ static int alloc_nand_resource(struct
> platform_device *pdev) if (irq < 0) {
>  		dev_err(&pdev->dev, "no IRQ resource defined\n");
>  		ret = -ENXIO;
> -		goto fail_disable_clk;
> +		goto fail_disable_ecc_clk;
>  	}
>  
>  	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	info->mmio_base = devm_ioremap_resource(&pdev->dev, r);
>  	if (IS_ERR(info->mmio_base)) {
>  		ret = PTR_ERR(info->mmio_base);
> -		goto fail_disable_clk;
> +		goto fail_disable_ecc_clk;
>  	}
>  	info->mmio_phys = r->start;
>  
> @@ -1668,7 +1675,7 @@ static int alloc_nand_resource(struct platform_device
> *pdev) info->data_buff = kmalloc(info->buf_size, GFP_KERNEL);
>  	if (info->data_buff == NULL) {
>  		ret = -ENOMEM;
> -		goto fail_disable_clk;
> +		goto fail_disable_ecc_clk;
>  	}
>  
>  	/* initialize all interrupts to be disabled */
> @@ -1687,6 +1694,9 @@ static int alloc_nand_resource(struct platform_device
> *pdev) fail_free_buf:
>  	free_irq(irq, info);
>  	kfree(info->data_buff);
> +fail_disable_ecc_clk:
> +	if (!IS_ERR(info->ecc_clk))
> +		clk_disable_unprepare(info->ecc_clk);

we can remove the IS_ERR check to simplify this error path since commit
63589e92c2d9("clk: Ignore error and NULL pointers passed to clk_{unprepare, disable}()")

>  fail_disable_clk:
>  	clk_disable_unprepare(info->clk);
>  	return ret;
> @@ -1709,6 +1719,8 @@ static int pxa3xx_nand_remove(struct platform_device
> *pdev) pxa3xx_nand_free_buff(info);
>  
>  	clk_disable_unprepare(info->clk);
> +	if (!IS_ERR(info->ecc_clk))
> +		clk_disable_unprepare(info->ecc_clk);

we can remove the IS_ERR check too.

>  
>  	for (cs = 0; cs < pdata->num_cs; cs++)
>  		nand_release(info->host[cs]->mtd);

