Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab3HLNzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:55:17 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:20971 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab3HLNzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:55:09 -0400
Message-ID: <5208E950.3050205@atmel.com>
Date: Mon, 12 Aug 2013 15:55:28 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] USB: ohci-at91: add usb_clk for transition to common
 clk framework
References: <1375376953-22823-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1375376953-22823-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 19:09, Boris BREZILLON :
> The AT91 PMC (Power Management Controller) provides an USB clock used by
> USB Full Speed host (ohci) and USB Full Speed device (udc).
> The usb drivers (ohci and udc) must configure this clock to 48Mhz.
> This configuration was formely done in mach-at91/clock.c, but this
> implementation will be removed when moving to common clk framework.
>
> This patch adds support for usb clock retrieval and configuration, and is
> backward compatible with the current at91 clk implementation (if usb clk
> is not found, it does not configure/enable it).
>
> Changes since v1:
>   - use IS_ENABLED(CONFIG_COMMON_CLK) to isolate new at91 clk support
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Well, for this v2 as well:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

(even if it is too late)

Bye,


> ---
>   drivers/usb/host/ohci-at91.c |   23 +++++++++++++++++++++--
>   1 file changed, 21 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
> index 9677f68..db60048 100644
> --- a/drivers/usb/host/ohci-at91.c
> +++ b/drivers/usb/host/ohci-at91.c
> @@ -31,8 +31,8 @@
>   #define at91_for_each_port(index)	\
>   		for ((index) = 0; (index) < AT91_MAX_USBH_PORTS; (index)++)
>
> -/* interface and function clocks; sometimes also an AHB clock */
> -static struct clk *iclk, *fclk, *hclk;
> +/* interface, function and usb clocks; sometimes also an AHB clock */
> +static struct clk *iclk, *fclk, *uclk, *hclk;
>   static int clocked;
>
>   extern int usb_disabled(void);
> @@ -41,6 +41,10 @@ extern int usb_disabled(void);
>
>   static void at91_start_clock(void)
>   {
> +	if (IS_ENABLED(CONFIG_COMMON_CLK)) {
> +		clk_set_rate(uclk, 48000000);
> +		clk_prepare_enable(uclk);
> +	}
>   	clk_prepare_enable(hclk);
>   	clk_prepare_enable(iclk);
>   	clk_prepare_enable(fclk);
> @@ -52,6 +56,8 @@ static void at91_stop_clock(void)
>   	clk_disable_unprepare(fclk);
>   	clk_disable_unprepare(iclk);
>   	clk_disable_unprepare(hclk);
> +	if (IS_ENABLED(CONFIG_COMMON_CLK))
> +		clk_disable_unprepare(uclk);
>   	clocked = 0;
>   }
>
> @@ -162,6 +168,14 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
>   		retval = PTR_ERR(hclk);
>   		goto err5;
>   	}
> +	if (IS_ENABLED(CONFIG_COMMON_CLK)) {
> +		uclk = clk_get(&pdev->dev, "usb_clk");
> +		if (IS_ERR(uclk)) {
> +			dev_err(&pdev->dev, "failed to get uclk\n");
> +			retval = PTR_ERR(uclk);
> +			goto err6;
> +		}
> +	}
>
>   	at91_start_hc(pdev);
>   	ohci_hcd_init(hcd_to_ohci(hcd));
> @@ -173,6 +187,9 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
>   	/* Error handling */
>   	at91_stop_hc(pdev);
>
> +	if (IS_ENABLED(CONFIG_COMMON_CLK))
> +		clk_put(uclk);
> + err6:
>   	clk_put(hclk);
>    err5:
>   	clk_put(fclk);
> @@ -212,6 +229,8 @@ static void usb_hcd_at91_remove(struct usb_hcd *hcd,
>   	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
>   	usb_put_hcd(hcd);
>
> +	if (IS_ENABLED(CONFIG_COMMON_CLK))
> +		clk_put(uclk);
>   	clk_put(hclk);
>   	clk_put(fclk);
>   	clk_put(iclk);
>


-- 
Nicolas Ferre
