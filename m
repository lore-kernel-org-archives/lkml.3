Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaBXHeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 02:34:15 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:64075 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBXHeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 02:34:13 -0500
Message-ID: <530AF5F1.5030209@cogentembedded.com>
Date: Mon, 24 Feb 2014 11:34:09 +0400
From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: SH-Linux <linux-sh@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Alexandre Courbot <gnurou@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Valentine Barshak <valentine.barshak@cogentembedded.com>
Subject: Re: [PATCH V4 3/4] ARM: shmobile: koelsch: Add USBHS and internal
 PCI USB support
References: <1393178459-14637-1-git-send-email-vladimir.barinov@cogentembedded.com> <1393178459-14637-4-git-send-email-vladimir.barinov@cogentembedded.com> <CANqRtoSKckgZBSaHDYYjfbTECJfB1Nn57suYspT0FR97P8SZFg@mail.gmail.com>
In-Reply-To: <CANqRtoSKckgZBSaHDYYjfbTECJfB1Nn57suYspT0FR97P8SZFg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Magnus,

Thank you for the quick response.

On 02/24/2014 07:52 AM, Magnus Damm wrote:
> +static int usbhs_hardware_init(struct platform_device *pdev)
> +{
> +       struct usbhs_private *priv = usbhs_get_priv(pdev);
> +       struct usb_phy *phy;
> +
> +       phy = usb_get_phy_dev(&pdev->dev, 0);
> +       if (IS_ERR(phy))
> +               return PTR_ERR(phy);
> +
> +       priv->phy = phy;
> +       return 0;
> +}
> +
> +static int usbhs_hardware_exit(struct platform_device *pdev)
> +{
> +       struct usbhs_private *priv = usbhs_get_priv(pdev);
> +
> +       if (!priv->phy)
> +               return 0;
> +
> +       usb_put_phy(priv->phy);
> +       priv->phy = NULL;
> +       return 0;
> +}
> +
> +static int usbhs_get_id(struct platform_device *pdev)
> +{
> +       return USBHS_GADGET;
> +}
> Uhm, I sort of expected this place to be where you read out the ID pin
> state from the MAX device.
Yes, I've seen your work for lager board.
I did differently then you beacause of problem in USBHS Host driver, 
hence the need of setup PHY at initial stage to PCI USB and not to USBHS.
>
>> +static u32 koelsch_usbhs_pipe_type[] = {
>> +
>> +/* Add all available USB devices */
>> +static void __init koelsch_add_usb_devices(void)
>> +{
>> +       /* MAX3355E ID pin */
>> +       gpio_request_one(RCAR_GP_PIN(5, 31), GPIOF_IN, NULL);
>> +       if (!gpio_get_value(RCAR_GP_PIN(5, 31))) {
>> +               usbhs_phy_pdata.chan0_pci = 1; /* Channel 0 is PCI USB host */
>> +               koelsch_add_usb0_host();
>> +       } else {
>> +               usbhs_phy_pdata.chan0_pci = 0; /* Channel 0 is USBHS */
>> +               koelsch_add_usb0_gadget();
>> +       }
> I don't think we should perform this kind of check at boot-up. This
> goes without saying, but normal USB supports hot-plug so we should
> check the cable type when the cable insertion event happens. Please
> see my comment above for USBHS-specific location.
>
> I do however understand that according to your investigation you
> cannot use USBHS in host mode. I believe further investigation is
> needed in that area to determine what is the best way forward.
> Regarding VBUS control, I believe it should be possible to drive the
> USB0_VBUS as GPIO and manually control the power.
I see.
>
> Would it be possible for you to break out USB PCI support for USB1 and
> resend that so we can begin by merging that?
Wouldn't you like me also add USBHS in gadget mode for USB0 with the 
similar check like you did on lager (with ID pin),
since it does not need the gpio-rcar changes too.

Also if you'd like I can add the USBHS in Host mode with the ID pin 
check like you suggested, but the usb0 host will not be stable.
Probably this could speed up the USBHS Host development/fixing.

Regards,
Vladimir
