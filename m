Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaIVJ1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:27:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:24929 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbaIVJ1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:27:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,571,1406617200"; 
   d="scan'208";a="479134893"
Date: Mon, 22 Sep 2014 12:25:28 +0300
From: "'Mika Westerberg'" <mika.westerberg@linux.intel.com>
To: "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] gpio: sch: Consolidate similar algorithms
Message-ID: <20140922092528.GM1786@lahna.fi.intel.com>
References: <1410943745-9354-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <1410943745-9354-2-git-send-email-rebecca.swee.fun.chang@intel.com>
 <20140918111705.GM10854@lahna.fi.intel.com>
 <50B33AC5ED75F74F991980326F1C438D0FBDB28B@PGSMSX108.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B33AC5ED75F74F991980326F1C438D0FBDB28B@PGSMSX108.gar.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 05:43:36AM +0000, Chang, Rebecca Swee Fun wrote:
> Replied inline. :)
> 
> > -----Original Message-----
> > From: Mika Westerberg [mailto:mika.westerberg@linux.intel.com]
> > Sent: 18 September, 2014 7:17 PM
> > To: Chang, Rebecca Swee Fun
> > Cc: Linus Walleij; linux-gpio@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH 1/3] gpio: sch: Consolidate similar algorithms
> > 
> > On Wed, Sep 17, 2014 at 04:49:03PM +0800, Chang Rebecca Swee Fun wrote:
> > > Consolidating similar algorithms into common functions to make GPIO
> > > SCH simpler and manageable.
> > >
> > > Signed-off-by: Chang Rebecca Swee Fun
> > > <rebecca.swee.fun.chang@intel.com>
> > > ---
> > >  drivers/gpio/gpio-sch.c |   95 ++++++++++++++++++++++++++--------------------
> > -
> > >  1 file changed, 53 insertions(+), 42 deletions(-)
> > >
> > > diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c index
> > > 99720c8..2189c22 100644
> > > --- a/drivers/gpio/gpio-sch.c
> > > +++ b/drivers/gpio/gpio-sch.c
> > > @@ -43,6 +43,8 @@ struct sch_gpio {
> > >
> > >  #define to_sch_gpio(c)	container_of(c, struct sch_gpio, chip)
> > >
> > > +static void sch_gpio_set(struct gpio_chip *gc, unsigned gpio_num, int
> > > +val);
> > > +
> > 
> > Is it possible to move the sch_gpio_set() function here instead of forward
> > declaring it?
> 
> Yes, it is possible. There is a reason I submitted the code in this
> structure. By putting the sch_gpio_set() function below will makes the
> diff patch looks neat and easy for review.  If it doesn't make sense
> to make the patch for easy reviewing, I can change by moving the
> function above.

I think that we are interested in the end result (e.g) the driver and if
we can avoid forward declarations the better.

> > 
> > >  static unsigned sch_gpio_offset(struct sch_gpio *sch, unsigned gpio,
> > >  				unsigned reg)
> > >  {
> > > @@ -63,94 +65,89 @@ static unsigned sch_gpio_bit(struct sch_gpio *sch,
> > unsigned gpio)
> > >  	return gpio % 8;
> > >  }
> > >
> > > -static void sch_gpio_enable(struct sch_gpio *sch, unsigned gpio)
> > > +static void sch_gpio_enable(struct sch_gpio *sch, unsigned gpio,
> > > +unsigned reg)
> > 
> > I don't see much value in doing this.
> > 
> > To me sch_gpio_enable(sch, gpio) is more intuitive than sch_gpio_enable(sch,
> > gpio, GEN). Why do I need to pass register to enable function in the first place?
> > It should know better how to enable the GPIO, right?
> > 
> > Same goes for others.
> 
> The register values are required when it comes to IRQ handling. By
> passing in the registers values, we can make full use of the
> algorithms without introducing extra/similar algorithms to compute
> other register offset values.
> For example, we have other offset values to handle such as:-
> GTPE	0x0C
> GTNE	0x10
> GGPE	0x14
> GSMI	0x18
> GTS	0x1C
> CGNMIEN	0x40
> RGNMIEN	0x44

Well, can we at least call it something else than sch_gpio_enable()?
Perhaps sch_gpio_set_value() or so?
