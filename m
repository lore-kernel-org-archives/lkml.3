Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbaIFKrP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 06:47:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:8565 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbaIFKrM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 06:47:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,479,1406617200"; 
   d="scan'208";a="587179231"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Arnd Bergmann <arnd@arndb.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, atull <atull@opensource.altera.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Subject: RE: [PATCH 1/3 v2] GPIO: gpio-dwapb: Enable platform driver binding
 to MFD driver
Thread-Topic: [PATCH 1/3 v2] GPIO: gpio-dwapb: Enable platform driver
 binding to MFD driver
Thread-Index: AQHPyP+JkBMLSfD+Nk6gyOY6CiHQz5vyaZUAgAGDTeA=
Date: Sat, 6 Sep 2014 10:47:01 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E982BFA@SHSMSX101.ccr.corp.intel.com>
References: <1409928798-31895-1-git-send-email-alvin.chen@intel.com>
 <1409928798-31895-2-git-send-email-alvin.chen@intel.com>
 <3465722.Gc9y01nQRe@wuerfel> <20140905193736.GA7981@breakpoint.cc>
In-Reply-To: <20140905193736.GA7981@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >
> > > -	irq_set_chained_handler(irq, dwapb_irq_handler);
> > > -	irq_set_handler_data(irq, gpio);
> > > +	if (!pp->irq_shared) {
> > > +		irq_set_chained_handler(pp->irq, dwapb_irq_handler);
> > > +		irq_set_handler_data(pp->irq, gpio);
> > > +	} else {
> > > +		/*
> > > +		 * Request a shared IRQ since where MFD would have devices
> > > +		 * using the same irq pin
> > > +		 */
> > > +		err = devm_request_irq(gpio->dev, pp->irq,
> > > +				       dwapb_irq_handler_mfd,
> > > +				       IRQF_SHARED, "gpio-dwapb-mfd", gpio);
> > > +		if (err) {
> > > +			dev_err(gpio->dev, "error requesting IRQ\n");
> > > +			irq_domain_remove(gpio->domain);
> > > +			gpio->domain = NULL;
> > > +			return;
> > > +		}
> > > +	}
> > >
> >
> > I think this need some better documentation. Why is it safe to use
> > devm_request_irq rather than irq_set_chained_handler here?
> 
> Usually it is preferred to use irq_set_chained_handler() for the chained handler
> so the handler does not show up in /proc/interrupts.
> This requires an exclusive non-shared handler which is not the case on the intel
> platform. So they have to use devm_request_irq() instead.
> 
Yes, for Intel Quark, it has a single PCI function exporting a GPIO and I2C controller, and
the irq is shared by GPIO and I2C, so we need shared irq as the comments said.



