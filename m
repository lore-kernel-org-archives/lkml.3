Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbaIDHai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 03:30:38 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54746 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754277AbaIDHaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 03:30:35 -0400
Date: Thu, 4 Sep 2014 09:30:27 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: "Chen, Alvin" <alvin.chen@intel.com>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: Re: [PATCH 1/3] GPIO: gpio-dwapb: Enable platform driver binding to
 MFD driver
Message-ID: <20140904073027.GA3336@breakpoint.cc>
References: <1409161588-19417-1-git-send-email-alvin.chen@intel.com>
 <1409161588-19417-2-git-send-email-alvin.chen@intel.com>
 <20140903200302.GA7673@breakpoint.cc>
 <4656BEB6164FC34F8171C6538F1A595B2E982384@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4656BEB6164FC34F8171C6538F1A595B2E982384@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-04 02:00:03 [+0000], Chen, Alvin wrote:
> > 
> > > --- a/drivers/gpio/Kconfig
> > > +++ b/drivers/gpio/Kconfig
> > > @@ -136,7 +136,6 @@ config GPIO_DWAPB
> > >  	tristate "Synopsys DesignWare APB GPIO driver"
> > >  	select GPIO_GENERIC
> > >  	select GENERIC_IRQ_CHIP
> > > -	depends on OF_GPIO
> > you need either OF_GPIO or PCI
> Since we enable this module not only support OF devices, but also support MFD devices, so we remove OF_GPIO dependency.
> For 'PCI', the original code is also not depended on PCI, and this patch also not, do you think it is necessary?

if not PCI then you should add something likwe 
	"depends on OF_GPIO || MFD"

looking further, you need also HAS_IOMEM for things like
devm_ioremap_resource(). Linus, wouldn't it make sense to group this
driver and make the block depend on it?

> > >  struct dwapb_gpio {
> > >  	struct	device		*dev;
> > >  	void __iomem		*regs;
> > >  	struct dwapb_gpio_port	*ports;
> > > -	unsigned int		nr_ports;
> > you could keep this the way it is
> It has been moved to 'pdata'.

I saw that. But there is no need keep a pointer to pdata across the
whole driver since only need nr_ports in the driver removal part of the
whole driver.

> > >  	struct irq_domain	*domain;
> > > +	const struct dwapb_gpio_platform_data	*pdata;
> > 
> > and not making this a member of this struct. I've been going up and down the
> > source and I don't see the need to marry dwapb_gpio to
> > dwapb_gpio_platform_data.
> > That dwapb_gpio_port_property thing has a long name. Could you just set it up,
> > pass it for registration and the free it? You can't free the pdata for the non-OF
> > tree but for the OF case you keep that struct around for no reason.
> > You could safe some memory and use pdata directly for setup.
> Here, 'pdata' is used for both OF and MFD. For MFD, 'pdata' is passed from MFD.
> For OF, 'pdata' is getting from device nodes properties. Why do we have such design? Because it can make the handling
> more easy for flowing routine. All necessary properties get from 'pdata', never care it is from OF or MFD. And someone
> are working on replacing OF interface with a firmware agnostic device_property* interface which will work with both OF and ACPI.
> More information for this design, please contact Darren Hart <dvhart@linux.intel.com>. Darren Hart wrote to me:
> "Generally speaking, rather than if/else blocks throughout the code checking if it is enumerated via open firmware or as a platform device,
> a cleaner approach is to check if the pdata is null, and if so, populate the pdata from the open firmware description if present.
> Then use the pdata throughout the driver.

But isn't it enough to hold on to this pdata thing through the probe
function only? After probe is done you could drop that memory in the
OF-case, right?
 
> > > +	irq_set_handler_data(port->pp->irq, gpio);
> > 
> > This does not look like it belongs here. It should only be used together with
> > irq_set_chained_handler() or am I missing here something?
> This patch reused ' dwapb_irq_handler', it needs the irq handler data. For ' irq_set_handler_data', it just sets the irq data.
> Why do you think it must be used together with ' irq_set_chained_handler'?

because you do request_irq(…, driver_data). If you you look close to
irq_set_chained_handler() it does not have such a member. Thus it uses
irq_set_handler_data() for that same purpose.

Sebastian
