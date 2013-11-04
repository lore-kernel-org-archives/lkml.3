Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab3KDNyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 08:54:14 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:1184 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab3KDNyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 08:54:12 -0500
Message-ID: <5277A6FF.5050404@atmel.com>
Date: Mon, 4 Nov 2013 14:54:07 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] USB: ehci-atmel: add usb_clk for transition to CCF
References: <1382124411-29023-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1382124411-29023-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/10/2013 21:26, Boris BREZILLON :
> The AT91 PMC (Power Management Controller) provides a USB clock used by
> the different USB controllers (ehci, ohci and udc).
> The atmel-ehci driver must configure the usb clock rate to 48Mhz in order
> to get a fully functionnal USB host controller.
> This configuration was formely done in mach-at91/clock.c, but will be
> bypassed when moving to common clk framework.
>
> This patch adds support for usb clock retrieval and configuration only if
> CCF is enabled (CONFIG_COMMON_CLK).
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Greg, as this patch is already in your tree, it is only for the record. 
I have tested it and it works now.

Thanks Boris, bye.


> ---
>   drivers/usb/host/ehci-atmel.c |   16 +++++++++++++++-
>   1 file changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/usb/host/ehci-atmel.c b/drivers/usb/host/ehci-atmel.c
> index 3b645ff..f417526 100644
> --- a/drivers/usb/host/ehci-atmel.c
> +++ b/drivers/usb/host/ehci-atmel.c
> @@ -30,13 +30,17 @@ static const char hcd_name[] = "ehci-atmel";
>   static struct hc_driver __read_mostly ehci_atmel_hc_driver;
>
>   /* interface and function clocks */
> -static struct clk *iclk, *fclk;
> +static struct clk *iclk, *fclk, *uclk;
>   static int clocked;
>
>   /*-------------------------------------------------------------------------*/
>
>   static void atmel_start_clock(void)
>   {
> +	if (IS_ENABLED(CONFIG_COMMON_CLK)) {
> +		clk_set_rate(uclk, 48000000);
> +		clk_prepare_enable(uclk);
> +	}
>   	clk_prepare_enable(iclk);
>   	clk_prepare_enable(fclk);
>   	clocked = 1;
> @@ -46,6 +50,8 @@ static void atmel_stop_clock(void)
>   {
>   	clk_disable_unprepare(fclk);
>   	clk_disable_unprepare(iclk);
> +	if (IS_ENABLED(CONFIG_COMMON_CLK))
> +		clk_disable_unprepare(uclk);
>   	clocked = 0;
>   }
>
> @@ -130,6 +136,14 @@ static int ehci_atmel_drv_probe(struct platform_device *pdev)
>   		retval = -ENOENT;
>   		goto fail_request_resource;
>   	}
> +	if (IS_ENABLED(CONFIG_COMMON_CLK)) {
> +		uclk = devm_clk_get(&pdev->dev, "usb_clk");
> +		if (IS_ERR(uclk)) {
> +			dev_err(&pdev->dev, "failed to get uclk\n");
> +			retval = PTR_ERR(uclk);
> +			goto fail_request_resource;
> +		}
> +	}
>
>   	ehci = hcd_to_ehci(hcd);
>   	/* registers start at offset 0x0 */
>


-- 
Nicolas Ferre
