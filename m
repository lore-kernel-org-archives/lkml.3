Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab3LCRBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:01:43 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:37763 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab3LCRBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:01:39 -0500
Message-ID: <529E1C82.8070501@cogentembedded.com>
Date: Tue, 03 Dec 2013 21:01:38 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Grant Likely <grant.likely@linaro.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] usb: ohci-at91: use device managed clk retrieval
References: <1386079669-3995-1-git-send-email-b.brezillon@overkiz.com> <1386079669-3995-4-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1386079669-3995-4-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/03/2013 05:07 PM, Boris BREZILLON wrote:

> Replace clk_get calls by devm_clk_get calls.

> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> Tested-by: Robert Nelson <robertcnelson@gmail.com>
> ---
>   drivers/usb/host/ohci-at91.c |   32 ++++++++------------------------
>   1 file changed, 8 insertions(+), 24 deletions(-)

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

    You changed this call...

>   		retval = PTR_ERR(iclk);
>   		goto err;
>   	}
> -	fclk = clk_get(&pdev->dev, "uhpck");
> +	fclk = devm_clk_get(dev, "uhpck");
>   	if (IS_ERR(fclk)) {
>   		dev_err(&pdev->dev, "failed to get uhpck\n");

    ... but not this one.

>   		retval = PTR_ERR(fclk);
> -		goto err4;
> +		goto err;
>   	}
> -	hclk = clk_get(&pdev->dev, "hclk");
> +	hclk = devm_clk_get(dev, "hclk");
>   	if (IS_ERR(hclk)) {
>   		dev_err(&pdev->dev, "failed to get hclk\n");

    ... or this one. Actually, I think cganging these calls would be out of 
scope for this patch.

>   		retval = PTR_ERR(hclk);
> -		goto err5;
> +		goto err;
>   	}
>   	if (IS_ENABLED(CONFIG_COMMON_CLK)) {
> -		uclk = clk_get(&pdev->dev, "usb_clk");
> +		uclk = devm_clk_get(&pdev->dev, "usb_clk");

    Hm, why not 'dev' like in all of the above?

>   		if (IS_ERR(uclk)) {
>   			dev_err(&pdev->dev, "failed to get uclk\n");
>   			retval = PTR_ERR(uclk);
> -			goto err6;
> +			goto err;
>   		}
>   	}
>

WBR, Sergei


