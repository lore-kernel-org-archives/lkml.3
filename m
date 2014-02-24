Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaBXI5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:57:19 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:48115 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaBXI5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:57:17 -0500
MIME-Version: 1.0
In-Reply-To: <530B02DD.6070600@cogentembedded.com>
References: <1393178459-14637-1-git-send-email-vladimir.barinov@cogentembedded.com>
	<1393178459-14637-4-git-send-email-vladimir.barinov@cogentembedded.com>
	<CANqRtoSKckgZBSaHDYYjfbTECJfB1Nn57suYspT0FR97P8SZFg@mail.gmail.com>
	<530AF5F1.5030209@cogentembedded.com>
	<CANqRtoQjFMezrw0oEYCE97+sWu2mNZnHz0nher8oKxzx7FH5_w@mail.gmail.com>
	<530B02DD.6070600@cogentembedded.com>
Date: Mon, 24 Feb 2014 17:57:13 +0900
Message-ID: <CANqRtoSzn3_jfd2hWGar51sGUg7nb=SP+uo9zrYJyV1Nq8=a2A@mail.gmail.com>
Subject: Re: [PATCH V4 3/4] ARM: shmobile: koelsch: Add USBHS and internal PCI
 USB support
From: Magnus Damm <magnus.damm@gmail.com>
To: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Cc: SH-Linux <linux-sh@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Alexandre Courbot <gnurou@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Valentine Barshak <valentine.barshak@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vladimir,

On Mon, Feb 24, 2014 at 5:29 PM, Vladimir Barinov
<vladimir.barinov@cogentembedded.com> wrote:
> Hi Magnus,
>
>
> On 02/24/2014 12:05 PM, Magnus Damm wrote:
>>
>> Hi Vladimir,
>>
>> On Mon, Feb 24, 2014 at 4:34 PM, Vladimir Barinov
>> <vladimir.barinov@cogentembedded.com>  wrote:
>>>
>>> Hello Magnus,
>>>
>>> Thank you for the quick response.
>>>
>>>
>>> On 02/24/2014 07:52 AM, Magnus Damm wrote:
>>>>
>>>> +static int usbhs_hardware_init(struct platform_device *pdev)
>>>> +{
>>>> +       struct usbhs_private *priv = usbhs_get_priv(pdev);
>>>> +       struct usb_phy *phy;
>>>> +
>>>> +       phy = usb_get_phy_dev(&pdev->dev, 0);
>>>> +       if (IS_ERR(phy))
>>>> +               return PTR_ERR(phy);
>>>> +
>>>> +       priv->phy = phy;
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static int usbhs_hardware_exit(struct platform_device *pdev)
>>>> +{
>>>> +       struct usbhs_private *priv = usbhs_get_priv(pdev);
>>>> +
>>>> +       if (!priv->phy)
>>>> +               return 0;
>>>> +
>>>> +       usb_put_phy(priv->phy);
>>>> +       priv->phy = NULL;
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static int usbhs_get_id(struct platform_device *pdev)
>>>> +{
>>>> +       return USBHS_GADGET;
>>>> +}
>>>> Uhm, I sort of expected this place to be where you read out the ID pin
>>>> state from the MAX device.
>>>
>>> Yes, I've seen your work for lager board.
>>> I did differently then you beacause of problem in USBHS Host driver,
>>> hence
>>> the need of setup PHY at initial stage to PCI USB and not to USBHS.
>>
>> Yeah, I understand. But with the current patches I wonder, isn't there
>> risk for short circuit ? Say that a USB host cable is connected during
>> boot and the PCI USB host controller is hooked up, what is stopping us
>> from switching the cable and driving VBUS from two sides using a USB
>> function cable? So the current patches seem a bit unsafe to me.
>
> Yes.
> In case of such condition, when the usb cable changed after host device
> probe the
> risk of VBUS collision is obvious.
> The interrupt driven ID pin monitoring in board file could help?

Well, it the board code may be one place to workaround things, but we
probably want to reuse this code somehow. And we already have some
kind of handling in the USBHS code.

When I grep in the directory drivers/usb/phy I can see those drivers
requesting IRQs. Perhaps this IRQ is for hotplug purpose? Maybe we can
have reusable GPIO interrupt driven hotplug detection in some generic
place?

The question is just how to let the OHCI/EHCI code coexist together
with the PHY IRQ code.

> Probably the separate driver for the MAX3355 should not be added since this
> provides
> poor information, most significant is cable ID.

Eventually we may end up with a separate driver, but to begin with it
is probably fine just to monitor GPIO pin states.

>>>>> +static u32 koelsch_usbhs_pipe_type[] = {
>>>>> +
>>>>> +/* Add all available USB devices */
>>>>> +static void __init koelsch_add_usb_devices(void)
>>>>> +{
>>>>> +       /* MAX3355E ID pin */
>>>>> +       gpio_request_one(RCAR_GP_PIN(5, 31), GPIOF_IN, NULL);
>>>>> +       if (!gpio_get_value(RCAR_GP_PIN(5, 31))) {
>>>>> +               usbhs_phy_pdata.chan0_pci = 1; /* Channel 0 is PCI USB
>>>>> host */
>>>>> +               koelsch_add_usb0_host();
>>>>> +       } else {
>>>>> +               usbhs_phy_pdata.chan0_pci = 0; /* Channel 0 is USBHS */
>>>>> +               koelsch_add_usb0_gadget();
>>>>> +       }
>>>>
>>>> I don't think we should perform this kind of check at boot-up. This
>>>> goes without saying, but normal USB supports hot-plug so we should
>>>> check the cable type when the cable insertion event happens. Please
>>>> see my comment above for USBHS-specific location.
>>>>
>>>> I do however understand that according to your investigation you
>>>> cannot use USBHS in host mode. I believe further investigation is
>>>> needed in that area to determine what is the best way forward.
>>>> Regarding VBUS control, I believe it should be possible to drive the
>>>> USB0_VBUS as GPIO and manually control the power.
>>>
>>> I see.
>>
>> To control USB0_VBUS as GPIO you may need to adjust the PFC tables for
>> pinctrl. At some point, would it be possible for you to cook up some
>> prototype code to try to control the USB0_VBUS signal via GPIO? This
>> may be pointless if the USBHS hardware cannot operate in Host mode
>> though.
>
> No need, there is a set_vbus callback in HSBHS platform code for this
> purpose.

I guess that callback is coming handy now. But I wonder how to control
the VBUS signal? You may now this already, but in some cases the PFC
tables need to be adjusted to allow GPIO control of a certain
function. Please see this patch for r8a7790, maybe something similar
is needed for r8a7791?

http://www.spinics.net/lists/linux-sh/msg28034.html

>>>> Would it be possible for you to break out USB PCI support for USB1 and
>>>> resend that so we can begin by merging that?
>>>
>>> Wouldn't you like me also add USBHS in gadget mode for USB0 with the
>>> similar
>>> check like you did on lager (with ID pin),
>>> since it does not need the gpio-rcar changes too.
>>
>> Thanks for your offer. Yes, that would be nice. May I suggest doing it
>> on two levels:
>> 1) Gadget-only support (is it possible to perform runtime check of ID
>> pin value at insert event and give error in case of Host?)
>> 2) Incremental USBHS host patch
>>
>> Using two incremental patches like above we can begin by merging 1)
>> and keep on working on 2).
>>
>>> Also if you'd like I can add the USBHS in Host mode with the ID pin check
>>> like you suggested, but the usb0 host will not be stable.
>>> Probably this could speed up the USBHS Host development/fixing.
>>
>> Please add it as a separate incremental patch if possible. I'd like to
>> have some kind of stable level of support without any funky
>> dependencies as a first goal, then keep on trying to get USBHS
>> working.
>>
>> I think PCI USB for the micro USB port can simply be dropped now and
>> only use USBHS.
>
> Sure, will do.

Great, thanks for your help!

/ magnus
