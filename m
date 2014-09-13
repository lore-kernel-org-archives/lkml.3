Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaIMJ0V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 05:26:21 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:48681 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaIMJ0T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 05:26:19 -0400
MIME-Version: 1.0
X-Originating-IP: [88.96.238.14]
In-Reply-To: <1410564239-8411-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1410564239-8411-1-git-send-email-alexandre.belloni@free-electrons.com>
Date: Sat, 13 Sep 2014 10:26:18 +0100
Message-ID: <CAAEAJfD_Kujcf7m9RAbRrjA82A08N81rVwy6sXY_PORdrH0VkA@mail.gmail.com>
Subject: Re: [PATCHv5] mtd: nand: atmel_nand: retrieve NFC clock
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Josh Wu <josh.wu@atmel.com>, Brian Norris <computersforpeace@gmail.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 September 2014 00:23, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:
> From: Boris BREZILLON <boris.brezillon@free-electrons.com>
>
> Retrieve the NFC clock to make sure it is enabled. Make that optional to ensure
> compatibility with previous device trees but document it as mandatory so newer
> device trees will include it.
>
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Acked-by: Josh Wu <josh.wu@atmel.com>
> ---
> Changes in v5:
>  - Added a proper commit log
>
>  .../devicetree/bindings/mtd/atmel-nand.txt         |  2 ++
>  drivers/mtd/nand/atmel_nand.c                      | 25 ++++++++++++++++++++++
>  2 files changed, 27 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/mtd/atmel-nand.txt b/Documentation/devicetree/bindings/mtd/atmel-nand.txt
> index c4728839d0c1..6edc3b616e98 100644
> --- a/Documentation/devicetree/bindings/mtd/atmel-nand.txt
> +++ b/Documentation/devicetree/bindings/mtd/atmel-nand.txt
> @@ -36,6 +36,7 @@ Optional properties:
>      - reg : should specify the address and size used for NFC command registers,
>              NFC registers and NFC Sram. NFC Sram address and size can be absent
>              if don't want to use it.
> +    - clocks: phandle to the peripheral clock
>    - Optional properties:
>      - atmel,write-by-sram: boolean to enable NFC write by sram.
>
> @@ -98,6 +99,7 @@ nand0: nand@40000000 {
>                 compatible = "atmel,sama5d3-nfc";
>                 #address-cells = <1>;
>                 #size-cells = <1>;
> +               clocks = <&hsmc_clk>
>                 reg = <
>                         0x70000000 0x10000000   /* NFC Command Registers */
>                         0xffffc000 0x00000070   /* NFC HSMC regs */
> diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
> index 9c5f717bda54..d1e502f8dbd0 100644
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
>         bool                    use_nfc_sram;
>         bool                    write_by_sram;
>
> +       struct clk              *clk;
> +
>         bool                    is_initialized;
>         struct completion       comp_ready;
>         struct completion       comp_cmd_done;
> @@ -2248,6 +2251,7 @@ static int atmel_nand_nfc_probe(struct platform_device *pdev)
>  {
>         struct atmel_nfc *nfc = &nand_nfc;
>         struct resource *nfc_cmd_regs, *nfc_hsmc_regs, *nfc_sram;
> +       int ret;
>
>         nfc_cmd_regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         nfc->base_cmd_regs = devm_ioremap_resource(&pdev->dev, nfc_cmd_regs);
> @@ -2279,8 +2283,28 @@ static int atmel_nand_nfc_probe(struct platform_device *pdev)
>         nfc_writel(nfc->hsmc_regs, IDR, 0xffffffff);
>         nfc_readl(nfc->hsmc_regs, SR);  /* clear the NFC_SR */
>
> +       nfc->clk = devm_clk_get(&pdev->dev, NULL);
> +       if (!IS_ERR(nfc->clk)) {
> +               ret = clk_prepare_enable(nfc->clk);
> +               if (ret)
> +                       return ret;
> +       } else {
> +               dev_warn(&pdev->dev, "NFC clock missing, update your Device Tree");

Looks much better now thanks. If the clock is not really optional, you
can consider this a firmware bug. We've used FW_BUG messages for these
cases
(see vim drivers/watchdog/orion_wdt.c), so you could write something like:

dev_warn(..., FW_BUG "devicetree clock missing");

Just a suggestion.
-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
