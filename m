Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbaLDMXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:23:11 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:58537 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbaLDMXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:23:09 -0500
Message-ID: <5480522A.5010900@cogentembedded.com>
Date: Thu, 04 Dec 2014 15:23:06 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>, Felipe Balbi <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: phy: Restore deferred probing path
References: <1417694767-18848-1-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1417694767-18848-1-git-send-email-thierry.reding@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/4/2014 3:06 PM, Thierry Reding wrote:

> From: Thierry Reding <treding@nvidia.com>

> Commit 1290a958d48e ("usb: phy: propagate __of_usb_find_phy()'s error on
> failure") broke platforms that rely on deferred probing to order probing
> of PHY and host controller drivers. The reason is that the commit simply
> propagates errors from __of_usb_find_phy(), which returns -ENODEV if no
> PHY has been registered yet for a given device tree node. The only case
> in which -EPROBE_DEFER would now be returned is if try_module_get() did
> fail, which does not make sense.

> The correct thing to do is to return -EPROBE_DEFER if a PHY hasn't been
> registered yet. The only condition under which it makes sense to return
> -ENODEV is if the device tree node representing the PHY has been
> disabled (via the status property) because in that case the PHY will
> never be registered.

> This patch addresses the problem by making __of_usb_find_phy() return an
> appropriate error code while keeping in line with the above-mentioned
> commit to propagate error codes rather than overwriting them. At the
> same time the check for a valid PHY is decoupled from the check for the
> try_module_get() call and a separate error code is returned if the
> latter fails.

> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>   drivers/usb/phy/phy.c | 14 ++++++++++----
>   1 file changed, 10 insertions(+), 4 deletions(-)

> diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
> index b4066a001ba0..2f9735b35338 100644
> --- a/drivers/usb/phy/phy.c
> +++ b/drivers/usb/phy/phy.c
[...]
> @@ -190,10 +193,13 @@ struct usb_phy *devm_usb_get_phy_by_phandle(struct device *dev,
>   	spin_lock_irqsave(&phy_lock, flags);
>
>   	phy = __of_usb_find_phy(node);
> -	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
> -		if (!IS_ERR(phy))
> -			phy = ERR_PTR(-EPROBE_DEFER);
> +	if (IS_ERR(phy)) {
> +		devres_free(ptr);
> +		goto err1;
> +	}
>
> +	if (!try_module_get(phy->dev->driver->owner)) {
> +		phy = ERR_PTR(-ENODEV);
>   		devres_free(ptr);
>   		goto err1;
>   	}

    I think devres_free() should now be called in one place, under the new 
'err2' label.

WBR, Sergei

