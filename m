Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab3CXOHD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 10:07:03 -0400
Received: from norkia.v3.sk ([91.210.183.14]:46838 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845Ab3CXOHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 10:07:01 -0400
Subject: Re: watchdog: Add Broadcom BCM2708 watchdog timer driver
From: Lubomir Rintel <lkundrak@v3.sk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-rpi-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org
In-Reply-To: <20130322135601.GA11264@roeck-us.net>
References: <1363956907-5644-1-git-send-email-lkundrak@v3.sk>
	 <20130322135601.GA11264@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Mar 2013 15:06:59 +0100
Message-ID: <1364134019.2906.2.camel@hobbes.kokotovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-22 at 06:56 -0700, Guenter Roeck wrote:

Thank you for your response!

On Fri Mar 22 09:56:01 EDT 2013, Guenter Roeck wrote:
> On Fri, Mar 22, 2013 at 12:55:07PM -0000, Lubomir Rintel wrote:
...
> > +	writel_relaxed(PM_PASSWORD | (cur & PM_RSTC_WRCFG_CLR) |
> > +		  PM_RSTC_WRCFG_FULL_RESET, wdt_regs + PM_RSTC);
> > +
> Nitpick - I prefer people to use the recommended continuation line style,
> but that is really up to the maintainer to decide.

Well, I intended to comply with Documentation/CodingStyle, are you referring to 
it? I fail to understand what to do to be more compliant and could not really 
identify a style that would be consistently used across the kernel source. 
Should I cut then second line into two smaller parts that would be aligned with 
right line end?

...
> > +static int bcm2835_wdt_set_timeout(struct watchdog_device *wdog, unsigned int t)
> > +{
> > +	wdog->timeout = t;
> 
> No need to update the actual chip timeout ?

No need to, watchdog core applies the new timeout by pinging the device (see 
below for what happens when this driver is pinged).

See: WDIOC_SETTIMEOUT in drivers/watchdog/watchdog_dev.c

...
> > +static struct watchdog_ops bcm2835_wdt_ops = {
> > +	.owner =	THIS_MODULE,
> > +	.start =	bcm2835_wdt_start,
> > +	.stop =		bcm2835_wdt_stop,
> > +	.set_timeout =	bcm2835_wdt_set_timeout,
> > +	.get_timeleft =	bcm2835_wdt_get_timeleft,
> 
> No separate ping function ?

The watchdog documentation core states:

  "Most hardware that does not support this as a separate function uses the
  start function to restart the watchdog timer hardware. And that's also what
  the watchdog timer driver core does."

This indeed applies to this driver.

...
> > +	if (WARN(!wdt_regs, "failed to remap watchdog regs"))
> > +		return -ENODEV;
> 
> WARN seems to be a bit extreme. Is this necessary ?

Probably not. I'll replace it with dev_err() instead.

> > +	dev_info(dev, "Broadcom BCM2835 watchdog timer");
> > +
> > +	watchdog_init_timeout(&bcm2835_wdt_wdd, heartbeat, dev);
> 
> Since heartbeat is by default set to -1, which is interpreted as unsigned
> int, I would expect this call to return -EINVAL, leaving the default timeout
> undefined. Is this really what you want ?

Well, I looked into orion-wdt for an example how to initialize the default 
timeout, but failed to understand it correctly. I thought that watchdog core 
picks a sensible value upon getting -1, which is incorrect. They in fact use 
initialize timeout with maximal value, and use a fall-through vi EINVAL to leave 
it untouched if it was not overridden. I'll do the same thing now.

> > +	watchdog_set_nowayout(&bcm2835_wdt_wdd, nowayout);
> > +	return watchdog_register_device(&bcm2835_wdt_wdd);
> 
> Leaking iomap if this fails.

Oops. Fixing.

> Would be nice to have something like devm_of_iomap ...

That sounds sound to me. Sent out a separate patch implementing it, and I'll 
modify this if it gets merged.

-- 
Lubomir Rintel <lkundrak@v3.sk>

