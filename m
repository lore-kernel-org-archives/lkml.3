Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197AbaJaNvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:51:15 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:57139 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758924AbaJaNvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:51:13 -0400
Message-ID: <545393CE.8070102@cogentembedded.com>
Date: Fri, 31 Oct 2014 16:51:10 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org
CC: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        kishon@ti.com, balbi@ti.com, stern@rowland.harvard.edu,
        kgene.kim@samsung.com, heikki.krogerus@linux.intel.com,
        mathias.nyman@intel.com, jwerner@google.com, jg1.han@samsung.com
Subject: Re: [PATCH v7 1/2] usb: host: xhci-plat: Get PHYs for xhci's hcds
References: <1414761989-21088-1-git-send-email-gautam.vivek@samsung.com> <1414761989-21088-2-git-send-email-gautam.vivek@samsung.com>
In-Reply-To: <1414761989-21088-2-git-send-email-gautam.vivek@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10/31/2014 4:26 PM, Vivek Gautam wrote:

> The host controller by itself may sometimes need to handle PHY
> and re-initialize it to re-configure some of the PHY parameters
> to get full support out of the PHY controller.
> Therefore, facilitate getting the two possible PHYs, viz.
> USB 2.0 type (UTMI+) and USB 3.0 type (PIPE3), and initialize them.

> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>   drivers/usb/host/xhci-plat.c |   74 ++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 74 insertions(+)

> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index 3d78b0c..5207d5b 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
[...]
> @@ -129,10 +130,41 @@ static int xhci_plat_probe(struct platform_device *pdev)
>   			goto put_hcd;
>   	}
>
> +	/* Get possile USB 2.0 type PHY (UTMI+) available with xhci */
> +	hcd->phy = devm_phy_get(&pdev->dev, "usb2-phy");
> +	if (IS_ERR(hcd->phy)) {
> +		ret = PTR_ERR(hcd->phy);
> +		if (ret == -EPROBE_DEFER) {
> +			goto disable_clk;
> +		} else if (ret != -ENOSYS && ret != -ENODEV) {

    Asking to be a *switch* statement instead...

> +			hcd->phy = NULL;
> +			dev_warn(&pdev->dev,
> +				 "Error retrieving usb2 phy: %d\n", ret);
> +		}
> +	}
> +
[...]
> @@ -158,12 +190,41 @@ static int xhci_plat_probe(struct platform_device *pdev)
>   	if (HCC_MAX_PSA(xhci->hcc_params) >= 4)
>   		xhci->shared_hcd->can_do_streams = 1;
>
> +	/* Get possile USB 3.0 type PHY (PIPE3) available with xhci */
> +	xhci->shared_hcd->phy = devm_phy_get(&pdev->dev, "usb3-phy");
> +	if (IS_ERR(xhci->shared_hcd->phy)) {
> +		ret = PTR_ERR(xhci->shared_hcd->phy);
> +		if (ret == -EPROBE_DEFER) {
> +			goto put_usb3_hcd;
> +		} else if (ret != -ENOSYS && ret != -ENODEV) {

    Likewise...

> +			xhci->shared_hcd->phy = NULL;
> +			dev_warn(&pdev->dev,
> +				 "Error retrieving usb3 phy: %d\n", ret);
> +		}
> +	}
> +
[...]
> @@ -204,6 +271,8 @@ static int xhci_plat_suspend(struct device *dev)
>   	struct usb_hcd	*hcd = dev_get_drvdata(dev);
>   	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
>
> +	phy_exit(hcd->phy);

    Hm, in the suspend() method?

> +
>   	return xhci_suspend(xhci);
>   }
>
[...]

WBR, Sergei

