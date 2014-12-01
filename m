Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaLAJZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 04:25:34 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35564 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaLAJZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 04:25:33 -0500
Date: Mon, 1 Dec 2014 01:25:29 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Zhou Wang <wangzhou.bry@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
        galak@codeaurora.org, caizhiyong@huawei.com, haojian.zhuang@gmail.com,
        xuwei5@hisilicon.com, wangzhou1@hisilicon.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] mtd: hisilicon: add a new NAND controller driver
 for hisilicon hip04 Soc
Message-ID: <20141201092529.GM29070@brian-ubuntu>
References: <1415105221-7732-1-git-send-email-wangzhou.bry@gmail.com>
 <1415105221-7732-2-git-send-email-wangzhou.bry@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415105221-7732-2-git-send-email-wangzhou.bry@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to mention these comments:

On Tue, Nov 04, 2014 at 08:47:00PM +0800, Zhou Wang wrote:
> +static int hisi_nfc_remove(struct platform_device *pdev)
> +{
> +	struct hinfc_host *host = platform_get_drvdata(pdev);
> +	struct mtd_info *mtd = &host->mtd;
> +
> +	nand_release(mtd);
> +	dma_free_coherent(&pdev->dev, mtd->writesize + mtd->oobsize,
> +			  host->buffer, host->dma_buffer);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int hisi_nfc_suspend(struct platform_device *pdev,
> +			       pm_message_t state)

This is the wrong prototype. See struct dev_pm_ops.

> +{
> +	struct hinfc_host *host = platform_get_drvdata(pdev);
> +
> +	while ((hinfc_read(host, HINFC504_STATUS) & 0x1) == 0x0)
> +		;
> +
> +	while ((hinfc_read(host, HINFC504_DMA_CTRL))
> +		& HINFC504_DMA_CTRL_DMA_START)
> +		_cond_resched();
> +
> +	return 0;
> +}
> +
> +static int hisi_nfc_resume(struct platform_device *pdev)

Same here.

> +{
> +	int cs;
> +	struct hinfc_host *host = platform_get_drvdata(pdev);
> +	struct nand_chip *chip = &host->chip;
> +
> +	for (cs = 0; cs < chip->numchips; cs++)
> +		hisi_nfc_send_cmd_reset(host, cs);
> +	hinfc_write(host, SET_HINFC504_PWIDTH(HINFC504_W_LATCH,
> +		    HINFC504_R_LATCH, HINFC504_RW_LATCH), HINFC504_PWIDTH);
> +
> +	return 0;
> +}
> +#endif
> +static SIMPLE_DEV_PM_OPS(hisi_nfc_pm_ops, hisi_nfc_suspend, hisi_nfc_resume);

Brian
