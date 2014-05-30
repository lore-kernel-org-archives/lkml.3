Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245AbaE3Og1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:36:27 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53145 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556AbaE3Og0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:36:26 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5388975A.7040109@roeck-us.net>
Date: Fri, 30 May 2014 07:36:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>, wim@iguana.be,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: imx2_wdt: adds big endianness support.
References: <1401430217-29543-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1401430217-29543-1-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 11:10 PM, Xiubo Li wrote:
> This watchdog driver will be working on IMX2+, Vybrid, LS1, LS2+
> platforms, and will be in different endianness mode in those SoCs:
>
> SoCs         CPU endian mode      WDT endian mode
> ------------------------------------------------
> IMX2+            LE                    LE
> Vybird           LE                    LE
> LS1              LE                    BE
> LS2              LE                    LE
>
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>   drivers/watchdog/imx2_wdt.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
> index 9d4874f..68c3d37 100644
> --- a/drivers/watchdog/imx2_wdt.c
> +++ b/drivers/watchdog/imx2_wdt.c
> @@ -28,6 +28,7 @@
>   #include <linux/kernel.h>
>   #include <linux/module.h>
>   #include <linux/moduleparam.h>
> +#include <linux/of_address.h>
>   #include <linux/platform_device.h>
>   #include <linux/regmap.h>
>   #include <linux/timer.h>
> @@ -190,10 +191,12 @@ static struct regmap_config imx2_wdt_regmap_config = {
>
>   static int __init imx2_wdt_probe(struct platform_device *pdev)
>   {
> +	struct device_node *np = pdev->dev.of_node;
>   	struct imx2_wdt_device *wdev;
>   	struct watchdog_device *wdog;
>   	struct resource *res;
>   	void __iomem *base;
> +	bool big_endian;
>   	int ret;
>   	u32 val;
>
> @@ -201,6 +204,10 @@ static int __init imx2_wdt_probe(struct platform_device *pdev)
>   	if (!wdev)
>   		return -ENOMEM;
>
> +	big_endian = of_property_read_bool(np, "big-endian");
> +	if (big_endian)
> +		imx2_wdt_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;
> +

You'll need to document the use of this property in
Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt.

Guenter

>   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>   	base = devm_ioremap_resource(&pdev->dev, res);
>   	if (IS_ERR(base))
>

