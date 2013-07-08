Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab3GHMIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 08:08:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38965 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab3GHMIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 08:08:19 -0400
Message-ID: <51DAABA6.9050106@ti.com>
Date: Mon, 8 Jul 2013 17:38:06 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <bigeasy@linutronix.de>
Subject: Re: [PATCH 5/5] usb: musb: dsps: Remove the phy control from glue
 and add phy driver APIs
References: <1373280201-31785-1-git-send-email-george.cherian@ti.com> <1373280201-31785-6-git-send-email-george.cherian@ti.com>
In-Reply-To: <1373280201-31785-6-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 08 July 2013 04:13 PM, George Cherian wrote:
> Remove usb phy control module access from platform glue.
> The same is now done using amxxxx phy driver and phy-omap-control.
>
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>   drivers/usb/musb/musb_dsps.c | 105 +++++++++++++++----------------------------
>   1 file changed, 36 insertions(+), 69 deletions(-)
>
> diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
> index 41f135a..8f4e04a 100644
> --- a/drivers/usb/musb/musb_dsps.c
> +++ b/drivers/usb/musb/musb_dsps.c
> @@ -123,49 +123,11 @@ struct dsps_glue {
>   	const struct dsps_musb_wrapper *wrp; /* wrapper register offsets */
>   	struct timer_list timer[2];	/* otg_workaround timer */
>   	unsigned long last_timer[2];    /* last timer data for each instance */
> -	u32 __iomem *usb_ctrl[2];
>   };
>
> -#define	DSPS_AM33XX_CONTROL_MODULE_PHYS_0	0x44e10620
> -#define	DSPS_AM33XX_CONTROL_MODULE_PHYS_1	0x44e10628
> +#define glue_to_musb(g, i)		platform_get_drvdata(g->musb[i])
>
> -static const resource_size_t dsps_control_module_phys[] = {
> -	DSPS_AM33XX_CONTROL_MODULE_PHYS_0,
> -	DSPS_AM33XX_CONTROL_MODULE_PHYS_1,
> -};
> -
> -#define USBPHY_CM_PWRDN		(1 << 0)
> -#define USBPHY_OTG_PWRDN	(1 << 1)
> -#define USBPHY_OTGVDET_EN	(1 << 19)
> -#define USBPHY_OTGSESSEND_EN	(1 << 20)
> -
> -/**
> - * musb_dsps_phy_control - phy on/off
> - * @glue: struct dsps_glue *
> - * @id: musb instance
> - * @on: flag for phy to be switched on or off
> - *
> - * This is to enable the PHY using usb_ctrl register in system control
> - * module space.
> - *
> - * XXX: This function will be removed once we have a seperate driver for
> - * control module
> - */
> -static void musb_dsps_phy_control(struct dsps_glue *glue, u8 id, u8 on)
> -{
> -	u32 usbphycfg;
>
> -	usbphycfg = readl(glue->usb_ctrl[id]);
> -
> -	if (on) {
> -		usbphycfg &= ~(USBPHY_CM_PWRDN | USBPHY_OTG_PWRDN);
> -		usbphycfg |= USBPHY_OTGVDET_EN | USBPHY_OTGSESSEND_EN;
> -	} else {
> -		usbphycfg |= USBPHY_CM_PWRDN | USBPHY_OTG_PWRDN;
> -	}
> -
> -	writel(usbphycfg, glue->usb_ctrl[id]);
> -}
>   /**
>    * dsps_musb_enable - enable interrupts
>    */
> @@ -411,16 +373,31 @@ static int dsps_musb_init(struct musb *musb)
>   	void __iomem *reg_base = musb->ctrl_base;
>   	u32 rev, val;
>   	int status;
> +	char phyname[12];
>
>   	/* mentor core register starts at offset of 0x400 from musb base */
>   	musb->mregs += wrp->musb_core_offset;
>
> -	/* NOP driver needs change if supporting dual instance */
> -	usb_nop_xceiv_register();
> -	musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
> +	if (dev->parent->of_node) {
> +		snprintf(phyname , 12, "am335x-usb%d", pdev->id);
> +		musb->phy = devm_phy_get(dev->parent, phyname);
> +		musb->xceiv = devm_usb_get_phy_by_phandle(dev->parent,
> +							"phys", pdev->id);
> +	} else {
> +		snprintf(phyname , 12, "am335x-usb%d", pdev->id);

Both these snprintf can be moved out of the *if*.
> +		musb->phy = devm_phy_get(dev, musb->phy_label);
> +		musb->xceiv = devm_usb_get_phy_dev(dev, pdev->id);
> +	}
> +
>   	if (IS_ERR_OR_NULL(musb->xceiv))
>   		return -EPROBE_DEFER;
>
> +	if (IS_ERR_OR_NULL(musb->phy)) {

The framework should never return NULL.

Thanks
Kishon
