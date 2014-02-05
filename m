Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaBERak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:30:40 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:61433 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbaBERag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:30:36 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:8040:1a03:b733:50ff]
In-Reply-To: <054501cf228a$f45c61c0$dd152540$%debski@samsung.com>
References: <1391016574-25237-1-git-send-email-k.debski@samsung.com>
	<1391016574-25237-9-git-send-email-k.debski@samsung.com>
	<CAOesGMgKQrW=Rb6ZtpOVKAZ6dDzy82CzbmOJtKRb8x6JaS1QLg@mail.gmail.com>
	<054501cf228a$f45c61c0$dd152540$%debski@samsung.com>
Date: Wed, 5 Feb 2014 09:30:35 -0800
Message-ID: <CAOesGMgKVe=zBGeZnTh3jY41KS88gVVDSLFZcRPS88F3-kEMBQ@mail.gmail.com>
Subject: Re: [PATCH v6 8/8] usb: ehci-exynos: Change to use phy provided by
 the generic phy framework
From: Olof Johansson <olof@lixom.net>
To: Kamil Debski <k.debski@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Mateusz Krawczuk <mat.krawczuk@gmail.com>, yulgon.kim@samsung.com,
        Praveen Paneri <p.paneri@samsung.com>, av.tikhomirov@samsung.com,
        Jingoo Han <jg1.han@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Matt Porter <matt.porter@linaro.org>, tjakobi@math.uni-bielefeld.de,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 5, 2014 at 7:57 AM, Kamil Debski <k.debski@samsung.com> wrote:
> Hi Olof,
>
> Thank you for your review.
>
>> From: Olof Johansson [mailto:olof@lixom.net]
>> Sent: Wednesday, January 29, 2014 9:55 PM
>>
>> Hi,
>>
>> On Wed, Jan 29, 2014 at 9:29 AM, Kamil Debski <k.debski@samsung.com>
>> wrote:
>> > Change the phy provider used from the old one using the USB phy
>> > framework to a new one using the Generic phy framework.
>> >
>> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
>> > ---
>> >  .../devicetree/bindings/usb/exynos-usb.txt         |   13 +++
>> >  drivers/usb/host/ehci-exynos.c                     |   97
>> +++++++++++++-------
>> >  2 files changed, 76 insertions(+), 34 deletions(-)
>> >
>> > diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt
>> > b/Documentation/devicetree/bindings/usb/exynos-usb.txt
>> > index d967ba1..25e199a 100644
>> > --- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
>> > +++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
>> > @@ -12,6 +12,10 @@ Required properties:
>> >   - interrupts: interrupt number to the cpu.
>> >   - clocks: from common clock binding: handle to usb clock.
>> >   - clock-names: from common clock binding: Shall be "usbhost".
>> > +  - port: if in the SoC there are EHCI phys, they should be listed
>> here.
>> > +One phy per port. Each port should have its reg entry with a
>> > +consecutive number. Also it should contain phys and phy-names
>> entries
>> > +specifying the phy used by the port.
>> >
>> >  Optional properties:
>> >   - samsung,vbus-gpio:  if present, specifies the GPIO that @@ -27,6
>> > +31,15 @@ Example:
>> >
>> >                 clocks = <&clock 285>;
>> >                 clock-names = "usbhost";
>> > +
>> > +               #address-cells = <1>;
>> > +               #size-cells = <0>;
>> > +               port@0 {
>> > +                   reg = <0>;
>> > +                   phys = <&usb2phy 1>;
>> > +                   phy-names = "host";
>> > +                   status = "disabled";
>> > +               };
>> >         };
>> >
>> >  OHCI
>>
>> [...]
>>
>> > @@ -102,14 +132,26 @@ static int exynos_ehci_probe(struct
>> platform_device *pdev)
>> >                                         "samsung,exynos5440-ehci"))
>> >                 goto skip_phy;
>> >
>> > -       phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
>> > -       if (IS_ERR(phy)) {
>> > -               usb_put_hcd(hcd);
>> > -               dev_warn(&pdev->dev, "no platform data or transceiver
>> defined\n");
>> > -               return -EPROBE_DEFER;
>> > -       } else {
>> > -               exynos_ehci->phy = phy;
>> > -               exynos_ehci->otg = phy->otg;
>> > +       for_each_available_child_of_node(pdev->dev.of_node, child) {
>> > +               err = of_property_read_u32(child, "reg",
>> &phy_number);
>> > +               if (err) {
>> > +                       dev_err(&pdev->dev, "Failed to parse device
>> tree\n");
>> > +                       of_node_put(child);
>> > +                       return err;
>> > +               }
>> > +               if (phy_number >= PHY_NUMBER) {
>> > +                       dev_err(&pdev->dev, "Failed to parse device
>> tree - number out of range\n");
>> > +                       of_node_put(child);
>> > +                       return -EINVAL;
>> > +               }
>> > +               phy = devm_of_phy_get(&pdev->dev, child, 0);
>> > +               of_node_put(child);
>> > +               if (IS_ERR(phy)) {
>> > +                       dev_err(&pdev->dev, "Failed to get phy number
>> %d",
>> > +
>> phy_number);
>> > +                       return PTR_ERR(phy);
>> > +               }
>> > +               exynos_ehci->phy[phy_number] = phy;
>>
>> this looks like it is now breaking older device trees, where ports
>> might not be described. Since device tree interfaces need to be
>> backwards compatible, you still need to handle the old case of not
>> having ports described.
>>
>> There are two ways of doing this:
>>
>> 1. Fall back to the old behavior if there are no ports 2. Use a new
>> compatible value for the new model with port subnodes, and if the old
>> compatible value is used, then fall back to the old behavior.
>>
>> I'm guessing (1) might be easiest since you can check for the presence
>> of #address-cells to tell if this is just an old style node, or if it's
>> a new-style node without any ports below it.
>
> The ultimate goal is to remove the old phy driver. Unfortunately
> this has to be synced with the new USB3 phy driver by Vivek Gautam. I think
> he
> is also close to completion. What about this case? In the end the old driver
> will be removed and no longer be supported. Having backward compatibility in
> mind, it is possible to have the old and the new phy driver together in one
> kernel release. But do we want to have two drivers doing the same thing at
> the same time?

It is mostly irrelevant if there is a new driver or not -- the old
device tree has to keep working. In this case it would mean that the
new driver needs to work with older device trees as well, or people
will see functionality regressing.

The device tree is a description of the hardware, not an extension of
the driver.


-Olof
