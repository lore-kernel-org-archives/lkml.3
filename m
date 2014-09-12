Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbaILJWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:22:00 -0400
Received: from nasmtp02.atmel.com ([204.2.163.16]:32502 "EHLO
	SJOEDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750908AbaILJV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:21:58 -0400
Message-ID: <5412BB01.6070401@atmel.com>
Date: Fri, 12 Sep 2014 17:21:05 +0800
From: Josh Wu <josh.wu@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Brian Norris <computersforpeace@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3] mtd: nand: atmel_nand: retrieve NFC clock
References: <1410512866-24546-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1410512866-24546-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alexandre

On 9/12/2014 5:07 PM, Alexandre Belloni wrote:
> From: Boris BREZILLON <boris.brezillon@free-electrons.com>
>
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>
> Changes in v3:
>   - changed the warning message to ask to update the DT
>   - made the clocks property mandatory in the documentation
>   - Stop claiming the NFC is probed if there is an issue when enabling the clock
>
>   .../devicetree/bindings/mtd/atmel-nand.txt         |  2 ++
>   drivers/mtd/nand/atmel_nand.c                      | 25 ++++++++++++++++++++++
>   2 files changed, 27 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/mtd/atmel-nand.txt b/Documentation/devicetree/bindings/mtd/atmel-nand.txt
> index c4728839d0c1..cb6cd4f8ae7a 100644
> --- a/Documentation/devicetree/bindings/mtd/atmel-nand.txt
> +++ b/Documentation/devicetree/bindings/mtd/atmel-nand.txt
> @@ -36,6 +36,7 @@ Optional properties:
>       - reg : should specify the address and size used for NFC command registers,
>               NFC registers and NFC Sram. NFC Sram address and size can be absent
>               if don't want to use it.
> +    - clocks: phandle to the peripheral clock
>     - Optional properties:
>       - atmel,write-by-sram: boolean to enable NFC write by sram.
>   
> @@ -98,6 +99,7 @@ nand0: nand@40000000 {
>   		compatible = "atmel,sama5d3-nfc";
>   		#address-cells = <1>;
>   		#size-cells = <1>;
> +		clocks = <&&hsmc_clk>

Is it a typo here? Do you mean

     clocks = <&hsmc_clk>


Best Regards,
Josh Wu

>   		reg = <
>   			0x70000000 0x10000000	/* NFC Command Registers */
>   			0xffffc000 0x00000070	/* NFC HSMC regs */
> diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
> index 9c5f717bda54..d1e502f8dbd0 100644
> --- a/drivers/mtd/nand/atmel_nand.c
> +++ b/drivers/mtd/nand/atmel_nand.c
> @@ -27,6 +27,7 @@
>    *
>    */
>   
> +#include <linux/clk.h>
>   #include <linux/dma-mapping.h>
>   #include <linux/slab.h>
>   #include <linux/module.h>
> @@ -96,6 +97,8 @@ struct atmel_nfc {
>   	bool			use_nfc_sram;
>   	bool			write_by_sram;
>   
> +	struct clk		*clk;
> +
>   	bool			is_initialized;
>   	struct completion	comp_ready;
>   	struct completion	comp_cmd_done;
> @@ -2248,6 +2251,7 @@ static int atmel_nand_nfc_probe(struct platform_device *pdev)
>   {
>   	struct atmel_nfc *nfc = &nand_nfc;
>   	struct resource *nfc_cmd_regs, *nfc_hsmc_regs, *nfc_sram;
> +	int ret;
>   
>   	nfc_cmd_regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>   	nfc->base_cmd_regs = devm_ioremap_resource(&pdev->dev, nfc_cmd_regs);
> @@ -2279,8 +2283,28 @@ static int atmel_nand_nfc_probe(struct platform_device *pdev)
>   	nfc_writel(nfc->hsmc_regs, IDR, 0xffffffff);
>   	nfc_readl(nfc->hsmc_regs, SR);	/* clear the NFC_SR */
>   
> +	nfc->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (!IS_ERR(nfc->clk)) {
> +		ret = clk_prepare_enable(nfc->clk);
> +		if (ret)
> +			return ret;
> +	} else {
> +		dev_warn(&pdev->dev, "NFC clock missing, update your Device Tree");
> +	}
> +
>   	nfc->is_initialized = true;
>   	dev_info(&pdev->dev, "NFC is probed.\n");
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
>   	return 0;
>   }
>   
> @@ -2297,6 +2321,7 @@ static struct platform_driver atmel_nand_nfc_driver = {
>   		.of_match_table = of_match_ptr(atmel_nand_nfc_match),
>   	},
>   	.probe = atmel_nand_nfc_probe,
> +	.remove = atmel_nand_nfc_remove,
>   };
>   
>   static struct platform_driver atmel_nand_driver = {

