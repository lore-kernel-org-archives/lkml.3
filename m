Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404Ab3CYPcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 11:32:17 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:64345 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757434Ab3CYPcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 11:32:15 -0400
Date: Mon, 25 Mar 2013 15:32:10 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 2/3] mfd: db8500-prcmu: Fetch the PRCMU TCDM base address
 from Device Tree
Message-ID: <20130325153210.GE3568@gmail.com>
References: <1364223758-17621-1-git-send-email-lee.jones@linaro.org>
 <1364223758-17621-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1364223758-17621-2-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam, and this one, sorry.

> A recent move to send the base addresses though the PRCMU platform
> device resource instead of defines found in <mach/*>, means that dbx500
> devices can no longer boot successfully when booting with Device Tree
> enabled. This patch ensures the addresses are obtained correctly from
> DT.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/db8500-prcmu.c |   28 ++++++++++++++++++++--------
>  1 file changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
> index 21f261b..8602bf8 100644
> --- a/drivers/mfd/db8500-prcmu.c
> +++ b/drivers/mfd/db8500-prcmu.c
> @@ -17,6 +17,8 @@
>  #include <linux/err.h>
>  #include <linux/spinlock.h>
>  #include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
>  #include <linux/slab.h>
>  #include <linux/mutex.h>
>  #include <linux/completion.h>
> @@ -2790,19 +2792,29 @@ static int db8500_irq_init(struct device_node *np)
>  }
>  
>  static void dbx500_fw_version_init(struct platform_device *pdev,
> -			    u32 version_offset)
> +				   u32 version_offset,
> +				   struct device_node *np)
>  {
> +	struct device_node *tcpm_np;
>  	struct resource *res;
> -	void __iomem *tcpm_base;
> +	void __iomem *tcpm_base = NULL;
>  
>  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
>  					   "prcmu-tcpm");
>  	if (!res) {
> -		dev_err(&pdev->dev,
> -			"Error: no prcmu tcpm memory region provided\n");
> -		return;
> -	}
> -	tcpm_base = ioremap(res->start, resource_size(res));
> +		if (np) {
> +			tcpm_np = of_find_node_by_name(np->parent,
> +						       "prcmu-tcpm-per4");
> +			if (!tcpm_np) {
> +				dev_err(&pdev->dev,
> +					"no prcmu tcpm mem region provided\n");
> +				return;
> +			}
> +			tcpm_base = of_iomap(tcpm_np, 0);
> +		}
> +	} else
> +		tcpm_base = ioremap(res->start, resource_size(res));
> +
>  	if (tcpm_base != NULL) {
>  		u32 version;
>  
> @@ -3154,7 +3166,7 @@ static int db8500_prcmu_probe(struct platform_device *pdev)
>  
>  	init_prcm_registers();
>  
> -	dbx500_fw_version_init(pdev, pdata->version_offset);
> +	dbx500_fw_version_init(pdev, pdata->version_offset, np);
>  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "prcmu-tcdm");
>  	if (!res) {
>  		dev_err(&pdev->dev, "no prcmu tcdm region provided\n");

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
