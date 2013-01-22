Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab3AVORT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 09:17:19 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45340 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab3AVORR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 09:17:17 -0500
Message-ID: <50FE9F5C.2010501@ti.com>
Date: Tue, 22 Jan 2013 16:17:00 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <tony@atomide.com>, <balbi@ti.com>, <linux@arm.linux.org.uk>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v1 6/6] USB: MUSB: OMAP: get PHY by phandle for dt boot
References: <1358848694-20145-1-git-send-email-kishon@ti.com> <1358848694-20145-7-git-send-email-kishon@ti.com>
In-Reply-To: <1358848694-20145-7-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 11:58 AM, Kishon Vijay Abraham I wrote:
> The OMAP glue has been modified to get PHY by phandle for dt boot.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/usb/musb/omap2430.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
> index 1a8cf6d..e43faeb 100644
> --- a/drivers/usb/musb/omap2430.c
> +++ b/drivers/usb/musb/omap2430.c
> @@ -345,7 +345,12 @@ static int omap2430_musb_init(struct musb *musb)
>  	 * up through ULPI.  TWL4030-family PMICs include one,
>  	 * which needs a driver, drivers aren't always needed.
>  	 */
> -	musb->xceiv = devm_usb_get_phy_dev(dev, 0);
> +	if (dev->parent->of_node)
> +		musb->xceiv = devm_usb_get_phy_by_phandle(dev->parent,
> +		    "usb_phy", 0);
> +	else
> +		musb->xceiv = devm_usb_get_phy_dev(dev, 0);
> +
>  	if (IS_ERR_OR_NULL(musb->xceiv)) {
>  		pr_err("HS USB OTG: no transceiver configured\n");
>  		return -ENODEV;

This will not work with PHY driver as a module. You need to use deferred probing mechanism here
after you have addressed my comment in patch 2 and also devm_usb_get_phy_by_phandle()

e.g.

if (IS_ERR(musb->xceiv)) {
	int ret = PTR_ERR(musb->xveiv);

	if (ret == -ENODEV)
		pr_err("HS USB OTG: no transceiver configured\n");

	return ret;
}

--
cheers,
-roger
 

