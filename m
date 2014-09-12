Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaILHxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 03:53:01 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:52851 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbaILHxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 03:53:00 -0400
Message-ID: <5412A650.60102@atmel.com>
Date: Fri, 12 Sep 2014 09:52:48 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Brian Norris <computersforpeace@gmail.com>,
        "Wu, Josh" <Josh.wu@atmel.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] mtd: nand: atmel_nand: retrieve NFC clock
References: <1410457937-14575-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1410457937-14575-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2014 19:52, Alexandre Belloni :
> From: Boris BREZILLON <boris.brezillon@free-electrons.com>
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

You may need to add Josh Wu to the list because he is the "de-facto"
Maintainer of this driver.

Bye,

> ---
> 
> Changes in v2:
>  - reworked the error path to really make the clock optional
>  - Documented the new optional property
> 
>  .../devicetree/bindings/mtd/atmel-nand.txt         |  1 +
>  drivers/mtd/nand/atmel_nand.c                      | 25 ++++++++++++++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/mtd/atmel-nand.txt b/Documentation/devicetree/bindings/mtd/atmel-nand.txt
> index c4728839d0c1..f71e2ebab15b 100644
> --- a/Documentation/devicetree/bindings/mtd/atmel-nand.txt
> +++ b/Documentation/devicetree/bindings/mtd/atmel-nand.txt
> @@ -38,6 +38,7 @@ Optional properties:
>              if don't want to use it.
>    - Optional properties:
>      - atmel,write-by-sram: boolean to enable NFC write by sram.
> +    - clocks: phandle to the peripheral clock if it exists
>  
>  Examples:
>  nand0: nand@40000000,0 {
> diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
> index 9c5f717bda54..69e0eb1ace54 100644
> --- a/drivers/mtd/nand/atmel_nand.c
> +++ b/drivers/mtd/nand/atmel_nand.c
> @@ -27,6 +27,7 @@
>   *
>   */
>  
> +#include <linux/clk.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/slab.h>
>  #include <linux/module.h>
> @@ -96,6 +97,8 @@ struct atmel_nfc {
>  	bool			use_nfc_sram;
>  	bool			write_by_sram;
>  
> +	struct clk		*clk;
> +
>  	bool			is_initialized;
>  	struct completion	comp_ready;
>  	struct completion	comp_cmd_done;
> @@ -2248,6 +2251,7 @@ static int atmel_nand_nfc_probe(struct platform_device *pdev)
>  {
>  	struct atmel_nfc *nfc = &nand_nfc;
>  	struct resource *nfc_cmd_regs, *nfc_hsmc_regs, *nfc_sram;
> +	int ret;
>  
>  	nfc_cmd_regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	nfc->base_cmd_regs = devm_ioremap_resource(&pdev->dev, nfc_cmd_regs);
> @@ -2281,6 +2285,26 @@ static int atmel_nand_nfc_probe(struct platform_device *pdev)
>  
>  	nfc->is_initialized = true;
>  	dev_info(&pdev->dev, "NFC is probed.\n");
> +
> +	nfc->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (!IS_ERR(nfc->clk)) {
> +		ret = clk_prepare_enable(nfc->clk);
> +		if (ret)
> +			return ret;
> +	} else {
> +		dev_warn(&pdev->dev, "NFC clock is missing");
> +	}
> +
> +	return 0;
> +}
> +
> +static int atmel_nand_nfc_remove(struct platform_device *pdev)
> +{
> +	struct atmel_nfc *nfc = &nand_nfc;
> +
> +	if (!IS_ERR(nfc->clk))
> +		clk_disable_unprepare(nfc->clk);
> +
>  	return 0;
>  }
>  
> @@ -2297,6 +2321,7 @@ static struct platform_driver atmel_nand_nfc_driver = {
>  		.of_match_table = of_match_ptr(atmel_nand_nfc_match),
>  	},
>  	.probe = atmel_nand_nfc_probe,
> +	.remove = atmel_nand_nfc_remove,
>  };
>  
>  static struct platform_driver atmel_nand_driver = {
> 


-- 
Nicolas Ferre
