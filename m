Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaIEThr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 15:37:47 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59467 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750776AbaIEThp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 15:37:45 -0400
Date: Fri, 5 Sep 2014 21:37:36 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Weike Chen <alvin.chen@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, atull <atull@opensource.altera.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Boon Leong Ong <boon.leong.ong@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Andriy Shevchenko <andriy.shevchenko@intel.com>
Subject: Re: [PATCH 1/3 v2] GPIO: gpio-dwapb: Enable platform driver binding
 to MFD driver
Message-ID: <20140905193736.GA7981@breakpoint.cc>
References: <1409928798-31895-1-git-send-email-alvin.chen@intel.com>
 <1409928798-31895-2-git-send-email-alvin.chen@intel.com>
 <3465722.Gc9y01nQRe@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3465722.Gc9y01nQRe@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-05 13:50:06 [+0200], Arnd Bergmann wrote:
> On Friday 05 September 2014 07:53:16 Weike Chen wrote:
> >  
> > -	irq_set_chained_handler(irq, dwapb_irq_handler);
> > -	irq_set_handler_data(irq, gpio);
> > +	if (!pp->irq_shared) {
> > +		irq_set_chained_handler(pp->irq, dwapb_irq_handler);
> > +		irq_set_handler_data(pp->irq, gpio);
> > +	} else {
> > +		/*
> > +		 * Request a shared IRQ since where MFD would have devices
> > +		 * using the same irq pin
> > +		 */
> > +		err = devm_request_irq(gpio->dev, pp->irq,
> > +				       dwapb_irq_handler_mfd,
> > +				       IRQF_SHARED, "gpio-dwapb-mfd", gpio);
> > +		if (err) {
> > +			dev_err(gpio->dev, "error requesting IRQ\n");
> > +			irq_domain_remove(gpio->domain);
> > +			gpio->domain = NULL;
> > +			return;
> > +		}
> > +	}
> >
> 
> I think this need some better documentation. Why is it safe to use
> devm_request_irq rather than irq_set_chained_handler here?

Usually it is preferred to use irq_set_chained_handler() for the chained
handler so the handler does not show up in /proc/interrupts.
This requires an exclusive non-shared handler which is not the case on
the intel platform. So they have to use devm_request_irq() instead.

Sebastian
