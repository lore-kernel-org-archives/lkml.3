Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbaKSJC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 04:02:28 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44690 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbaKSJC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 04:02:26 -0500
Date: Wed, 19 Nov 2014 10:02:22 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 2/4] gpiolib: use const parameters when possible
Message-ID: <20141119090222.GU27002@pengutronix.de>
References: <1360738983-22436-1-git-send-email-gnurou@gmail.com>
 <1360738983-22436-3-git-send-email-gnurou@gmail.com>
 <20141117090915.GE27002@pengutronix.de>
 <CAAVeFuKzP0ADix8TxC31ohb3ZmnEVmNcO5kgzhZ3DcwAhTq=-Q@mail.gmail.com>
 <20141119084432.GT27002@pengutronix.de>
 <CAAVeFuLtQoxt_D_TaRQc49Sh0FZTg=q4y5QorZ7OUK+qPE0CbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVeFuLtQoxt_D_TaRQc49Sh0FZTg=q4y5QorZ7OUK+qPE0CbQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alexandre,

On Wed, Nov 19, 2014 at 05:57:46PM +0900, Alexandre Courbot wrote:
> On Wed, Nov 19, 2014 at 5:44 PM, Uwe Kleine-König
> <u.kleine-koenig@pengutronix.de> wrote:
> > Hello Alexandre,
> >
> > On Wed, Nov 19, 2014 at 05:33:42PM +0900, Alexandre Courbot wrote:
> >> On Mon, Nov 17, 2014 at 6:09 PM, Uwe Kleine-König
> >> <u.kleine-koenig@pengutronix.de> wrote:
> >> > Hello,
> >> >
> >> > On Wed, Feb 13, 2013 at 04:03:00PM +0900, Alexandre Courbot wrote:
> >> >> From: Alexandre Courbot <acourbot@nvidia.com>
> >> >>
> >> >> Constify descriptor parameter of gpiod_* functions for those that
> >> >> should obviously not modify it. This includes value or direction get,
> >> >> cansleep, and IRQ number query.
> >> >>
> >> >> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> >> > This patch is applied as def634338d3ffb32fbe9b0a2d70cc24ef909cd4f since
> >> > v3.9-rc2.
> >> >
> >> >>  drivers/gpio/gpiolib.c | 29 ++++++++++++++++-------------
> >> >>  1 file changed, 16 insertions(+), 13 deletions(-)
> >> >>
> >> >> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> >> >> index 8a2cf9c..ad6df6b 100644
> >> >> --- a/drivers/gpio/gpiolib.c
> >> >> +++ b/drivers/gpio/gpiolib.c
> >> >> @@ -207,7 +208,7 @@ static int gpiochip_find_base(int ngpio)
> >> >>  }
> >> >>
> >> >>  /* caller ensures gpio is valid and requested, chip->get_direction may sleep  */
> >> >> -static int gpiod_get_direction(struct gpio_desc *desc)
> >> >> +static int gpiod_get_direction(const struct gpio_desc *desc)
> >> >>  {
> >> >>       struct gpio_chip        *chip;
> >> >>       unsigned                offset;
> >> >> @@ -223,11 +224,13 @@ static int gpiod_get_direction(struct gpio_desc *desc)
> >> >>       if (status > 0) {
> >> >>               /* GPIOF_DIR_IN, or other positive */
> >> >>               status = 1;
> >> >> -             clear_bit(FLAG_IS_OUT, &desc->flags);
> >> >> +             /* FLAG_IS_OUT is just a cache of the result of get_direction(),
> >> >> +              * so it does not affect constness per se */
> >> >> +             clear_bit(FLAG_IS_OUT, &((struct gpio_desc *)desc)->flags);
> >> > I think this is worse than not having gpiod_get_direction take a const
> >> > descriptor.
> >>
> >> Yeah, this kind of sucks but ultimately gpiod_get_direction() is
> >> without side-effect to the caller and the const parameter helps
> >> highlighting that fact.
> > Does that mean you want to keep the const and take the risk that it
> > might introduce some hard to debug problem when the compiler changes its
> > optimisation strategies? I hope you don't.
> 
> Nope, I would like to keep that const but correctness is more
> important than prototype aesthetics. I will fix that.
Fine.

> 
> >> > I don't know an example for this particular case where this could break,
> >> > but usually casting away a const is bad and can break in various ways.
> >> >
> >> > Maybe even drop the public function gpiod_get_direction completely.
> >> > As of next-20141114 there are only two users of this function (apart
> >> > from drivers/gpio/gpiolib*) and both are wrong (as discussed in
> >> > http://thread.gmane.org/gmane.linux.serial/16808/focus=4783).
> >>
> >> Or maybe gpiod_direction_*() should register the last set direction to
> >> be used by gpiod_get_direction() if the controller does not implement
> >> the get_direction op? On the other hand callers can also track the
> >> direction themselves (since they presumably set it), so this function
> >> is really only useful for users who want to read the *hardware* state
> >> of a GPIO. Which might still be a useful feature?
> > I think it's useful to be able to check how a given gpio is configured
> > in hardware. So you really want to look into the register and not cache
> > the direction in gpiod_direction_*.
> > And I'd say having /sys/kernel/debug/gpio is good enough. So IMHO there
> > is no reason to hide gpiod_get_direction from general misuse.
> 
> Mmm so are you suggesting that we should keep gpiod_get_direction() in the end?
I'd make gpiod_get_direction static and only use it to fill in
/sys/kernel/debug/gpio.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
