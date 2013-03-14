Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab3CNPgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 11:36:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47243 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab3CNPgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:36:14 -0400
Subject: Re: [PATCH v2] USB: ehci-s5p: Fix phy reset
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=US-ASCII
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <CAJuYYwQgXx67rSNeBFBJQfkbaf17vP6XXhFZ2Zc5hRqxshUFbw@mail.gmail.com>
Date: Thu, 14 Mar 2013 16:36:07 +0100
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, dmueller@suse.de,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Doug Anderson <dianders@chromium.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <A092CD36-1BE0-4070-81DF-3254D225F0F6@suse.de>
References: <1363219179-14900-1-git-send-email-agraf@suse.de> <CAJuYYwRYp0dvf=veg1UVAj8rJ2CdpFy32LUE6zeq1sH9FbZ=KQ@mail.gmail.com> <6F88F86A-8C8E-4C2E-BD15-14C788FC6E48@suse.de> <CAJuYYwQgXx67rSNeBFBJQfkbaf17vP6XXhFZ2Zc5hRqxshUFbw@mail.gmail.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 14.03.2013, at 15:58, Thomas Abraham wrote:

> On 14 March 2013 17:31, Alexander Graf <agraf@suse.de> wrote:
>> 
>> On 14.03.2013, at 05:19, Thomas Abraham wrote:
>> 
>>> On 14 March 2013 05:29, Alexander Graf <agraf@suse.de> wrote:
>>>> On my Exynos 5 based Arndale system, I need to pull the reset line down
>>>> and then let it go up again to actually perform a reset. Without that
>>>> reset, I can't find any USB hubs on my bus, rendering the USB controller
>>>> useless.
>>>> 
>>>> We also only need to reset the line after the phy node has been found.
>>>> This way we don't accidently reserve the vbus GPIO pin, but later on
>>>> defer the creation of our controller, because the phy device tree node
>>>> hasn't been probed yet.
>>>> 
>>>> This patch implements the above logic, making EHCI and OHCI work on
>>>> Arndale systems for me.
>>>> 
>>>> Signed-off-by: Alexander Graf <agraf@suse.de>
>>>> CC: Vivek Gautam <gautam.vivek@samsung.com>
>>>> CC: Jingoo Han <jg1.han@samsung.com>
>>>> CC: Alan Stern <stern@rowland.harvard.edu>
>>>> CC: Kukjin Kim <kgene.kim@samsung.com>
>>>> CC: Felipe Balbi <balbi@ti.com>
>>>> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>> CC: Doug Anderson <dianders@chromium.org>
>>>> 
>>>> ---
>>>> 
>>>> v1 -> v2:
>>>> 
>>>> - remove gpio_free call
>>>> - move reset logic after phy node search
>>>> 
>>>> diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
>>>> index 20ebf6a..b29b2b8 100644
>>>> --- a/drivers/usb/host/ehci-s5p.c
>>>> +++ b/drivers/usb/host/ehci-s5p.c
>>>> @@ -103,9 +103,14 @@ static void s5p_setup_vbus_gpio(struct platform_device *pdev)
>>>>       if (!gpio_is_valid(gpio))
>>>>               return;
>>>> 
>>>> -       err = gpio_request_one(gpio, GPIOF_OUT_INIT_HIGH, "ehci_vbus_gpio");
>>>> -       if (err)
>>>> +       /* reset pulls the line down, then up again */
>>>> +       err = gpio_request_one(gpio, GPIOF_OUT_INIT_LOW, "ehci_vbus_gpio");
>>>> +       if (err) {
>>>>               dev_err(&pdev->dev, "can't request ehci vbus gpio %d", gpio);
>>>> +               return;
>>>> +       }
>>>> +       mdelay(1);
>>>> +       __gpio_set_value(gpio, 1);
>>>> }
>>>> 
>>>> static u64 ehci_s5p_dma_mask = DMA_BIT_MASK(32);
>>>> @@ -131,8 +136,6 @@ static int s5p_ehci_probe(struct platform_device *pdev)
>>>>       if (!pdev->dev.coherent_dma_mask)
>>>>               pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
>>>> 
>>>> -       s5p_setup_vbus_gpio(pdev);
>>>> -
>>>>       s5p_ehci = devm_kzalloc(&pdev->dev, sizeof(struct s5p_ehci_hcd),
>>>>                               GFP_KERNEL);
>>>>       if (!s5p_ehci)
>>>> @@ -152,6 +155,8 @@ static int s5p_ehci_probe(struct platform_device *pdev)
>>>>               s5p_ehci->otg = phy->otg;
>>>>       }
>>>> 
>>>> +       s5p_setup_vbus_gpio(pdev);
>>>> +
>>>>       s5p_ehci->dev = &pdev->dev;
>>>> 
>>>>       hcd = usb_create_hcd(&s5p_ehci_hc_driver, &pdev->dev,
>>> 
>>> Hi Alexander,
>>> 
>>> This change, though it works for Exynos5250 based Arndale board, does
>>> not actually seem correct. On Arndale board, the on-board 4-port usb
>>> hub is self powered and hence the vbus 'enable' gpio line from
>>> Exynos5250 SoC is instead used as a "reset" signal for the on-board
>>> usb hub (and not as the vbus enable signal).
>>> 
>>> Whereas, the driver uses the gpio used in 's5p_setup_vbus_gpio'
>>> function as just a mechanism to enable vbus for downstream devices. So
>>> the driver should not be modified as above to handle the board
>>> specific behavior.
>>> 
>>> Instead, what needs to be done is, remove the "samsung,vbus-gpio"
>>> property from the usb2.0 node in dts files (this property is optional)
>>> for Arndale board. Then, during the machine_init, perform the reset
>>> sequencing as required.
>>> 
>>> Ideally, the reset sequencing for the on-board AX88760 usb hub should
>>> have been handled in the driver for this device. I have not checked if
>>> there is a driver for this in the kernel.
>> 
>> I can see your point, but as I mentioned earlier there seems to be some timing issue here. By simply doing the reset a few ms earlier (in the first probe, before the driver detects that it needs to defer probing), I already can't find the hub on the bus later.
>> 
>> So I'm assuming that the same thing would also happen if I put it even earlier in machine init.
> 
> True, I missed that point. The usb hub connected over hsic interface,
> after power-on-reset, might have initiated the 'connect' state on
> seeing the idle condition on the bus and since the host/phy controller
> is not ready yet, the connect might have failed.
> 
> So the correct sequence would be, after the usb host controller and
> the phy controllers are initialized, the 'reset' pin on the on-board
> usb hub should be asserted. Upon releasing that reset, the usb hub
> would initiate the 'connect' state on the HSIC bus.

So we can just add another property to the dt - let's call it "reset-hsic-gpio" - which then would get pulled down and up again after the phy has been initialized? The vbus property would be completely unaffected from this and indeed, we wouldn't have a vbus property on Arndale dts's then.


Alex

> 
>> 
>> The change in this patch actually does a reset even on non-Arndale boards. By taking away power and returning power to the line, the chip will most likely have reset :). So even on non-Arndale boards, this should get the USB phy into a clean state regardless of where the bootloader left it, right?
>> 
> 
> No, the toggling of the vbus cannot ensure hardware-reset on self
> powered devices. On Arndale board, since the usb hub is self powered
> and being on HSIC interface, the dedicated vbus control gpio line is
> instead used to assert the 'reset' pin of the on-board usb hub.
> 
> Using the dedicated vbus control line of Exynos5250 (XuhostPWREN) for
> hardware resetting the usb hub is a board specific design of Arndale
> board. The function ''s5p_setup_vbus_gpio' is meant to turn on the
> vbus for downstream ports. Utilizing this function to hardware-reset
> the usb hub is not right.
> 
> In fact, for Arndale board, there should not be a 'samsung,vbus-gpio'
> property for usb2.0 host controller node. Because, there is no such
> vbus control line on Arndale board which is using HSIC interface to
> connect to USB devices. So this change is not correct. The assertion
> of the hardware-reset for the on board usb hub should be handled
> elsewhere.
> 
> Thanks,
> Thomas.
> 
>> 
>> Alex
>> 

