Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbaIXAzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 20:55:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:27794 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbaIXAz3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 20:55:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,584,1406617200"; 
   d="scan'208";a="595896959"
From: "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>
To: "'Mika Westerberg'" <mika.westerberg@linux.intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] gpio: sch: Consolidate similar algorithms
Thread-Topic: [PATCH 1/3] gpio: sch: Consolidate similar algorithms
Thread-Index: AQHP0zITy1c+9hxkcUuFzrdfTj4FxJwMpx4g//+6rACAAxnHUA==
Date: Wed, 24 Sep 2014 00:55:07 +0000
Message-ID: <50B33AC5ED75F74F991980326F1C438D0FBDBA92@PGSMSX108.gar.corp.intel.com>
References: <1410943745-9354-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <1410943745-9354-2-git-send-email-rebecca.swee.fun.chang@intel.com>
 <20140918111705.GM10854@lahna.fi.intel.com>
 <50B33AC5ED75F74F991980326F1C438D0FBDB28B@PGSMSX108.gar.corp.intel.com>
 <20140922092528.GM1786@lahna.fi.intel.com>
In-Reply-To: <20140922092528.GM1786@lahna.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: 'Mika Westerberg' [mailto:mika.westerberg@linux.intel.com]
> Sent: 22 September, 2014 5:25 PM
> To: Chang, Rebecca Swee Fun
> Cc: Linus Walleij; linux-gpio@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/3] gpio: sch: Consolidate similar algorithms
> 
> On Mon, Sep 22, 2014 at 05:43:36AM +0000, Chang, Rebecca Swee Fun wrote:
> > Replied inline. :)
> >
> > > -----Original Message-----
> > > From: Mika Westerberg [mailto:mika.westerberg@linux.intel.com]
> > > Sent: 18 September, 2014 7:17 PM
> > > To: Chang, Rebecca Swee Fun
> > > Cc: Linus Walleij; linux-gpio@vger.kernel.org;
> > > linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH 1/3] gpio: sch: Consolidate similar algorithms
> > >
> > > On Wed, Sep 17, 2014 at 04:49:03PM +0800, Chang Rebecca Swee Fun
> wrote:
> > > > Consolidating similar algorithms into common functions to make
> > > > GPIO SCH simpler and manageable.
> > > >
> > > > Signed-off-by: Chang Rebecca Swee Fun
> > > > <rebecca.swee.fun.chang@intel.com>
> > > > ---
> > > >  drivers/gpio/gpio-sch.c |   95 ++++++++++++++++++++++++++---------------
> -----
> > > -
> > > >  1 file changed, 53 insertions(+), 42 deletions(-)
> > > >
> > > > diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
> > > > index
> > > > 99720c8..2189c22 100644
> > > > --- a/drivers/gpio/gpio-sch.c
> > > > +++ b/drivers/gpio/gpio-sch.c
> > > > @@ -43,6 +43,8 @@ struct sch_gpio {
> > > >
> > > >  #define to_sch_gpio(c)	container_of(c, struct sch_gpio, chip)
> > > >
> > > > +static void sch_gpio_set(struct gpio_chip *gc, unsigned gpio_num,
> > > > +int val);
> > > > +
> > >
> > > Is it possible to move the sch_gpio_set() function here instead of
> > > forward declaring it?
> >
> > Yes, it is possible. There is a reason I submitted the code in this
> > structure. By putting the sch_gpio_set() function below will makes the
> > diff patch looks neat and easy for review.  If it doesn't make sense
> > to make the patch for easy reviewing, I can change by moving the
> > function above.
> 
> I think that we are interested in the end result (e.g) the driver and if we can
> avoid forward declarations the better.

Alright. I can move it up to avoid the forward declaration.

> 
> > >
> > > >  static unsigned sch_gpio_offset(struct sch_gpio *sch, unsigned gpio,
> > > >  				unsigned reg)
> > > >  {
> > > > @@ -63,94 +65,89 @@ static unsigned sch_gpio_bit(struct sch_gpio
> > > > *sch,
> > > unsigned gpio)
> > > >  	return gpio % 8;
> > > >  }
> > > >
> > > > -static void sch_gpio_enable(struct sch_gpio *sch, unsigned gpio)
> > > > +static void sch_gpio_enable(struct sch_gpio *sch, unsigned gpio,
> > > > +unsigned reg)
> > >
> > > I don't see much value in doing this.
> > >
> > > To me sch_gpio_enable(sch, gpio) is more intuitive than
> > > sch_gpio_enable(sch, gpio, GEN). Why do I need to pass register to enable
> function in the first place?
> > > It should know better how to enable the GPIO, right?
> > >
> > > Same goes for others.
> >
> > The register values are required when it comes to IRQ handling. By
> > passing in the registers values, we can make full use of the
> > algorithms without introducing extra/similar algorithms to compute
> > other register offset values.
> > For example, we have other offset values to handle such as:-
> > GTPE	0x0C
> > GTNE	0x10
> > GGPE	0x14
> > GSMI	0x18
> > GTS	0x1C
> > CGNMIEN	0x40
> > RGNMIEN	0x44
> 
> Well, can we at least call it something else than sch_gpio_enable()?
> Perhaps sch_gpio_set_value() or so?

sch_gpio_set_value() sounds good. After think twice, I intend to merge sch_gpio_enable() and sch_gpio_disable() into one functions. Using variable "enable" as an indicator, I can control whether to enable or disable when calling the function. Here is my draft:

static void sch_gpio_set_value(struct sch_gpio *sch, unsigned gpio, unsigned reg, unsigned int enable)
{
	unsigned long flags;
	unsigned short offset, bit;
	u8 set;

	spin_lock_irqsave(&sch->lock, flags);
	offset = sch_gpio_offset(sch, gpio, reg);
	bit = sch_gpio_bit(sch, gpio);

	set = inb(sch->iobase + offset); 
	if (enable)
		outb(set | BIT(bit), sch->iobase + offset);
	else
		outb(disable & ~BIT(bit), sch->iobase + offset);

	spin_unlock_irqrestore(&sch->lock, flags);
}

Do you think this make sense? I am in the progress of implementing and testing.

Rebecca
