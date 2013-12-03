Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab3LCOQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:16:00 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:45150 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab3LCOP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:15:56 -0500
Message-ID: <529DE791.6080007@atmel.com>
Date: Tue, 3 Dec 2013 15:15:45 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Grant Likely <grant.likely@linaro.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] usb: ohci-at91: use device managed clk retrieval
References: <1386079669-3995-1-git-send-email-b.brezillon@overkiz.com> <1386079669-3995-4-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1386079669-3995-4-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2013 15:07, Boris BREZILLON :
> Replace clk_get calls by devm_clk_get calls.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> Tested-by: Robert Nelson <robertcnelson@gmail.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks Boris for these fixes.

Alan, Greg, can you take the whole series as fixes for 3.13?

Thanks, best regards,

> ---
>   drivers/usb/host/ohci-at91.c |   32 ++++++++------------------------
>   1 file changed, 8 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
> index c406f1e..3652962 100644
> --- a/drivers/usb/host/ohci-at91.c
> +++ b/drivers/usb/host/ohci-at91.c
> @@ -164,30 +164,30 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
>   		goto err;
>   	}
>
> -	iclk = clk_get(&pdev->dev, "ohci_clk");
> +	iclk = devm_clk_get(dev, "ohci_clk");
>   	if (IS_ERR(iclk)) {
> -		dev_err(&pdev->dev, "failed to get ohci_clk\n");
> +		dev_err(dev, "failed to get ohci_clk\n");
>   		retval = PTR_ERR(iclk);
>   		goto err;
>   	}
> -	fclk = clk_get(&pdev->dev, "uhpck");
> +	fclk = devm_clk_get(dev, "uhpck");
>   	if (IS_ERR(fclk)) {
>   		dev_err(&pdev->dev, "failed to get uhpck\n");
>   		retval = PTR_ERR(fclk);
> -		goto err4;
> +		goto err;
>   	}
> -	hclk = clk_get(&pdev->dev, "hclk");
> +	hclk = devm_clk_get(dev, "hclk");
>   	if (IS_ERR(hclk)) {
>   		dev_err(&pdev->dev, "failed to get hclk\n");
>   		retval = PTR_ERR(hclk);
> -		goto err5;
> +		goto err;
>   	}
>   	if (IS_ENABLED(CONFIG_COMMON_CLK)) {
> -		uclk = clk_get(&pdev->dev, "usb_clk");
> +		uclk = devm_clk_get(&pdev->dev, "usb_clk");
>   		if (IS_ERR(uclk)) {
>   			dev_err(&pdev->dev, "failed to get uclk\n");
>   			retval = PTR_ERR(uclk);
> -			goto err6;
> +			goto err;
>   		}
>   	}
>
> @@ -203,15 +203,6 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
>   	/* Error handling */
>   	at91_stop_hc(pdev);
>
> -	if (IS_ENABLED(CONFIG_COMMON_CLK))
> -		clk_put(uclk);
> - err6:
> -	clk_put(hclk);
> - err5:
> -	clk_put(fclk);
> - err4:
> -	clk_put(iclk);
> -
>    err:
>   	usb_put_hcd(hcd);
>   	return retval;
> @@ -236,13 +227,6 @@ static void usb_hcd_at91_remove(struct usb_hcd *hcd,
>   	usb_remove_hcd(hcd);
>   	at91_stop_hc(pdev);
>   	usb_put_hcd(hcd);
> -
> -	if (IS_ENABLED(CONFIG_COMMON_CLK))
> -		clk_put(uclk);
> -	clk_put(hclk);
> -	clk_put(fclk);
> -	clk_put(iclk);
> -	fclk = iclk = hclk = NULL;
>   }
>
>   /*-------------------------------------------------------------------------*/
>


-- 
Nicolas Ferre
