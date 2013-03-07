Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab3CGJLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:11:12 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42887 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab3CGJLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:11:08 -0500
Date: Thu, 7 Mar 2013 17:10:57 +0800
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 3/5] usb: musb: ux500: add otg notifier support
Message-ID: <20130307091057.GB7422@balto.lan>
References: <20130306085446.GI28587@arwen.pp.htv.fi>
 <1362646660-22688-1-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362646660-22688-1-git-send-email-fabio.baltieri@linaro.org>
X-Operating-System: Linux balto 3.8.0-09633-g2a7d2b9 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 04:57:40PM +0800, Fabio Baltieri wrote:
> Add transceiver notifier event handling to the ux500 driver to set vbus
> on specific transceiver events.
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---

Sorry, I forgot about:

v2:
- turn off vbus on USB_EVENT_VBUS event

Note that this causes a trivial context conflict with patch 5, let me
know if you want me to resend the whole set.

Thanks,
Fabio

>  drivers/usb/musb/ux500.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
> index 5b742ba..55f24c6 100644
> --- a/drivers/usb/musb/ux500.c
> +++ b/drivers/usb/musb/ux500.c
> @@ -98,6 +98,37 @@ static void ux500_musb_set_vbus(struct musb *musb, int is_on)
>  		musb_readb(musb->mregs, MUSB_DEVCTL));
>  }
>  
> +static int musb_otg_notifications(struct notifier_block *nb,
> +		unsigned long event, void *unused)
> +{
> +	struct musb *musb = container_of(nb, struct musb, nb);
> +
> +	dev_dbg(musb->controller, "musb_otg_notifications %ld %s\n",
> +			event, otg_state_string(musb->xceiv->state));
> +
> +	switch (event) {
> +	case USB_EVENT_ID:
> +		dev_dbg(musb->controller, "ID GND\n");
> +		ux500_musb_set_vbus(musb, 1);
> +		break;
> +	case USB_EVENT_VBUS:
> +		dev_dbg(musb->controller, "VBUS Connect\n");
> +		ux500_musb_set_vbus(musb, 0);
> +		break;
> +	case USB_EVENT_NONE:
> +		dev_dbg(musb->controller, "VBUS Disconnect\n");
> +		if (is_host_active(musb))
> +			ux500_musb_set_vbus(musb, 0);
> +		else
> +			musb->xceiv->state = OTG_STATE_B_IDLE;
> +		break;
> +	default:
> +		dev_dbg(musb->controller, "ID float\n");
> +		return NOTIFY_DONE;
> +	}
> +	return NOTIFY_OK;
> +}
> +
>  static irqreturn_t ux500_musb_interrupt(int irq, void *__hci)
>  {
>  	unsigned long   flags;
> @@ -120,12 +151,21 @@ static irqreturn_t ux500_musb_interrupt(int irq, void *__hci)
>  
>  static int ux500_musb_init(struct musb *musb)
>  {
> +	int status;
> +
>  	musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
>  	if (IS_ERR_OR_NULL(musb->xceiv)) {
>  		pr_err("HS USB OTG: no transceiver configured\n");
>  		return -EPROBE_DEFER;
>  	}
>  
> +	musb->nb.notifier_call = musb_otg_notifications;
> +	status = usb_register_notifier(musb->xceiv, &musb->nb);
> +	if (status < 0) {
> +		dev_dbg(musb->controller, "notification register failed\n");
> +		return status;
> +	}
> +
>  	musb->isr = ux500_musb_interrupt;
>  
>  	return 0;
> @@ -133,6 +173,8 @@ static int ux500_musb_init(struct musb *musb)
>  
>  static int ux500_musb_exit(struct musb *musb)
>  {
> +	usb_unregister_notifier(musb->xceiv, &musb->nb);
> +
>  	usb_put_phy(musb->xceiv);
>  
>  	return 0;
> -- 
> 1.8.1.3
> 

-- 
Fabio Baltieri
