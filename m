Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbaJGQit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:38:49 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:59715 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaJGQis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:38:48 -0400
Date: Tue, 7 Oct 2014 11:38:44 -0500
From: Michael Welling <mwelling@emacinc.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: GPIO registration for external Ethernet PHY oscillator
 enable/disable
Message-ID: <20141007163844.GB6123@sysresccd>
References: <20140925191722.GA2481@sysresccd>
 <54247372.40803@gmail.com>
 <20140926165919.GA3518@sysresccd>
 <54259F83.5020006@gmail.com>
 <20140926200408.GA32264@sysresccd>
 <CACRpkdarM1Ae1Xa7kLC-+4A8i4JcU+c4YazppgA1YHvVRtdeQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdarM1Ae1Xa7kLC-+4A8i4JcU+c4YazppgA1YHvVRtdeQw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 04:09:45PM +0200, Linus Walleij wrote:
> On Fri, Sep 26, 2014 at 10:04 PM, Michael Welling <mwelling@emacinc.com> wrote:
> > On Fri, Sep 26, 2014 at 10:16:51AM -0700, Florian Fainelli wrote:
> >>
> >> Yes and no, this might feel like the wrong place, but ultimately, the
> >> Ethernet MAC is a consumer of the PHY device, and is in control, through
> >> the PHY library of how and when the PHY gets to be powered off.
> >>
> >
> > So here is the patch that I made that hooks into the macb driver.
> >
> > Please look it over and tell me if we are on the same page.
> >
> > The thing that bothers me about this solution is that it will only work with the macb driver.
> > So everytime I use the same PHY/OSC combo with a different SoC I will have to do another patch.
> >
> > diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
> > index e4e34b6..8cd363f 100644
> > --- a/drivers/net/ethernet/cadence/macb.c
> > +++ b/drivers/net/ethernet/cadence/macb.c
> > @@ -28,6 +28,7 @@
> >  #include <linux/of.h>
> >  #include <linux/of_device.h>
> >  #include <linux/of_net.h>
> > +#include <linux/of_gpio.h>
> 
> No please,
> #include <linux/gpio/consumer.h>
> 
> > @@ -1833,6 +1834,16 @@ static int __init macb_probe(struct platform_device *pdev)
> >                 bp->phy_interface = err;
> >         }
> >
> > +       bp->phy_osc_gpio = of_get_named_gpio(pdev->dev.of_node, "osc-gpio", 0);
> > +
> > +       if (gpio_is_valid(bp->phy_osc_gpio))
> > +       {
> > +               if (gpio_request(bp->phy_osc_gpio, "osc-gpio") != 0) {
> > +                       pr_info("Oscillator GPIO not available.\n");
> > +                       bp->phy_osc_gpio = 0;
> > +               }
> > +       }
> 
> 
> No,
> bp->phy_osc_gpiod = devm_gpiod_get(&pdev->dev, "osc-gpio", 0);
> 
> And error handling.
> 
> > +       if (gpio_is_valid(bp->phy_osc_gpio))
> > +               gpio_set_value_cansleep(bp->phy_osc_gpio, 0);
> > +
> 
> if (bp->phy_osc_gpiod)
>   gpiod_set_...
> 
> > +       if (gpio_is_valid(bp->phy_osc_gpio))
> > +               gpio_set_value_cansleep(bp->phy_osc_gpio, 1);
> 
> Dito.
> 
> >         phy_interface_t         phy_interface;
> > +       int                     phy_osc_gpio;
> 
> struct gpio_desc *phy_osc_gpiod;

Thank you for clearifying the preferred/correct interface.

This version was not even functional and I had to update it 
such that it was.

I will, of course, follow the above suggestions if/when I submit an
actual patch.

I am still not sure the MAC driver is the best place for this
registration.

> 
> Yours,
> Linus Walleij
