Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382Ab3CYPbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 11:31:49 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:32774 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479Ab3CYPbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 11:31:48 -0400
Date: Mon, 25 Mar 2013 15:31:42 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 3/3] mfd: db8500-prcmu: Fetch the PRCMU TCPM base address
 from Device Tree
Message-ID: <20130325153142.GD3568@gmail.com>
References: <1364223758-17621-1-git-send-email-lee.jones@linaro.org>
 <1364223758-17621-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1364223758-17621-3-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry Sam, looks like I missed you on this one.

> A recent move to send the base addresses though the PRCMU platform
> device resource instead of defines found in <mach/*>, means that dbx500
> devices can no longer boot successfully when booting with Device Tree
> enabled. This patch ensures the addresses are obtained correctly from
> DT instead.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/db8500-prcmu.c |   21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
> index 8602bf8..a998edc 100644
> --- a/drivers/mfd/db8500-prcmu.c
> +++ b/drivers/mfd/db8500-prcmu.c
> @@ -3159,8 +3159,9 @@ static void db8500_prcmu_update_cpufreq(void)
>   */
>  static int db8500_prcmu_probe(struct platform_device *pdev)
>  {
> -	struct device_node *np = pdev->dev.of_node;
>  	struct prcmu_pdata *pdata = dev_get_platdata(&pdev->dev);
> +	struct device_node *np = pdev->dev.of_node;
> +	struct device_node *tcdm_np;
>  	int irq = 0, err = 0, i;
>  	struct resource *res;
>  
> @@ -3169,11 +3170,19 @@ static int db8500_prcmu_probe(struct platform_device *pdev)
>  	dbx500_fw_version_init(pdev, pdata->version_offset, np);
>  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "prcmu-tcdm");
>  	if (!res) {
> -		dev_err(&pdev->dev, "no prcmu tcdm region provided\n");
> -		return -ENOENT;
> -	}
> -	tcdm_base = devm_ioremap(&pdev->dev, res->start,
> -			resource_size(res));
> +		if (np) {
> +			tcdm_np = of_find_node_by_name(np->parent,
> +						       "prcmu-tcdm-per4");
> +			if (!tcdm_np) {
> +				dev_err(&pdev->dev,
> +					"no prcmu tcdm region provided\n");
> +				return -ENOENT;
> +			}
> +			tcdm_base = of_iomap(tcdm_np, 0);
> +		}
> +	} else
> +		tcdm_base = devm_ioremap(&pdev->dev, res->start,
> +					 resource_size(res));
>  
>  	/* Clean up the mailbox interrupts after pre-kernel code. */
>  	writel(ALL_MBOX_BITS, PRCM_ARM_IT1_CLR);

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
