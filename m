Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaIADVb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 23:21:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:48140 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbaIADV3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 23:21:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,439,1406617200"; 
   d="scan'208";a="592641953"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: atull <atull@opensource.altera.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: RE: [PATCH 3/3] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Thread-Topic: [PATCH 3/3] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Thread-Index: AQHPxZOdFKnKqUJESkW9jjZvXiQLDg==
Date: Mon, 1 Sep 2014 03:20:00 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E981942@SHSMSX101.ccr.corp.intel.com>
References: <1409161588-19417-1-git-send-email-alvin.chen@intel.com>
 <1409161588-19417-4-git-send-email-alvin.chen@intel.com>
 <alpine.DEB.2.02.1408280955560.26299@atx-linux-37>
In-Reply-To: <alpine.DEB.2.02.1408280955560.26299@atx-linux-37>
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

> > +/* Store GPIO context across system-wide suspend/resume transitions
> > +*/ static struct gpio_saved_regs {
> > +	unsigned long data;
> > +	unsigned long dir;
> > +	unsigned long int_en;
> > +	unsigned long int_mask;
> > +	unsigned long int_type;
> > +	unsigned long int_pol;
> > +	unsigned long int_deb;
> > +} saved_regs;
> > +
> > +static int dwapb_gpio_suspend(struct device *dev) {
> > +	struct platform_device *pdev = to_platform_device(dev);
> > +	struct dwapb_gpio *gpio = platform_get_drvdata(pdev);
> > +	struct bgpio_chip *bgc	= &gpio->ports[0].bgc;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&bgc->lock, flags);
> > +
> > +	saved_regs.int_mask	= dwapb_read(gpio, GPIO_INTMASK);
> > +	saved_regs.int_en	= dwapb_read(gpio, GPIO_INTEN);
> > +	saved_regs.int_deb	= dwapb_read(gpio, GPIO_PORTA_DEBOUNCE);
> > +	saved_regs.int_pol	= dwapb_read(gpio, GPIO_INT_POLARITY);
> > +	saved_regs.int_type	= dwapb_read(gpio, GPIO_INTTYPE_LEVEL);
> > +	saved_regs.dir		= dwapb_read(gpio, GPIO_SWPORTA_DDR);
> > +	saved_regs.data		= dwapb_read(gpio, GPIO_SWPORTA_DR);
> 
> Hello,
> 
> The DesignWare GPIO IP can be configured to have ports a, b, c, and d. So you
> will need to save and restore any ports that are present.  I think that *some*
> configurations of the IP include a register that can tell us how it was configured,
> but that register is also optional :)  I don't have confidence that we can
> read/write the registers blindly whether they are known to be there or not.
> So you may be stuck with looking at the device tree or platform data to know
> whether banks b, c, or d exist.
>
>From the code, the device node has one property for port index. If the index is '0', then it is port A.
So I think we can store the status according to the port index.

