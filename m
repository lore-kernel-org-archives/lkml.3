Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab3HLR1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:27:10 -0400
Received: from p3plsmtpa11-04.prod.phx3.secureserver.net ([68.178.252.105]:48715
	"EHLO p3plsmtpa11-04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757196Ab3HLR1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:27:06 -0400
Date: Mon, 12 Aug 2013 10:27:03 -0700
From: "Mark A. Greer" <mgreer@animalcreek.com>
To: Anton Vorontsov <anton@enomsg.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bq24190_charger: Add support for TI BQ24190 Battery
 Charger
Message-ID: <20130812172703.GA11863@animalcreek.com>
References: <1375912608-17312-1-git-send-email-mgreer@animalcreek.com>
 <20130809192111.GD979@lizard.mcd26095.sjc.wayport.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809192111.GD979@lizard.mcd26095.sjc.wayport.net>
Organization: Animal Creek Technologies, Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 12:21:11PM -0700, Anton Vorontsov wrote:
> On Wed, Aug 07, 2013 at 02:56:48PM -0700, Mark A. Greer wrote:

> ...
> > +static irqreturn_t bq24190_irq_handler_thread(int irq, void *data)
> > +{
> > +	struct bq24190_dev_info *bdi = data;
> > +	bool alert_userspace = false;
> > +	u8 ss_reg, f_reg;
> > +	int ret;
> > +	static bool first_time = true;
> ...
> > +	/*
> > +	 * Sometimes bq24190 gives a steady trickle of interrupts even
> > +	 * though the watchdog timer is turned off and neither the STATUS
> > +	 * nor FAULT registers have changed.  Weed out these sprurious
> > +	 * interrupts so userspace isn't alerted for no reason.
> > +	 * In addition, the chip always generates an interrupt after
> > +	 * register reset so we should ignore that one (the very first
> > +	 * interrupt received).
> > +	 */
> > +	if (alert_userspace && !first_time) {
> 
> Hm, global static... I would guess that per-device flag would be more
> appropriate, just in case if there are multiple chargers?

Oops.

> ...
> > +	do {
> > +		ret = bq24190_read_mask(bdi, BQ24190_REG_POC,
> > +				BQ24190_REG_POC_RESET_MASK,
> > +				BQ24190_REG_POC_RESET_SHIFT,
> > +				&v);
> > +		if ((ret <= 0) || !v)
> > +			break;
> > +
> > +		udelay(10);
> > +	} while (--limit);
> > +
> > +	if (!ret && limit)
> > +		ret = bq24190_set_mode_host(bdi);
> > +out:
> > +	pm_runtime_put_sync(bdi->dev);
> > +	return ret;
> > +}
> > +
> > +#define irq_to_gpio(irq)	((irq) - gpio_to_irq(0))
> 
> Ugh... this does not seem right. On a particular platform it might work,
> but not in general...

Umm, yeah.  Plain laziness on my part.

> p.s. I am also not a big fan of unnecessary 'out:' goto labels... most of
> them might be changed to just 'return ...;'

OK.

Mark
--
