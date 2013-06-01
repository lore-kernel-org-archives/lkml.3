Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab3FAEPB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 00:15:01 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57990 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3FAEOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 00:14:53 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Fri, 31 May 2013 23:14:50 -0500
X-Originating-IP: 108.223.40.66
Date: Fri, 31 May 2013 21:15:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: wim@iguana.be, guenter@roeck-us.net, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] watchdog: New watchdog driver for MEN A21 watchdogs
Message-ID: <20130601041523.GB4081@roeck-us.net>
References: <20130531103654.GB5619@roeck-us.net>
 <20130531110846.GA15707@jtlinux>
 <20130531114037.GA13533@roeck-us.net>
 <20130531125519.GB8983@jtlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130531125519.GB8983@jtlinux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 02:55:19PM +0200, Johannes Thumshirn wrote:
> Hi Guenther,
> On Fri, May 31, 2013 at 04:40:37AM -0700, Guenter Roeck wrote:
> > > +#define GPIO_WD_ENAB	169
> > > +#define GPIO_WD_FAST	170
> > > +#define GPIO_WD_TRIG	171
> > > +
> > > +#define GPIO_RST_CAUSE_BASE 166
> > > +
> >
> > I think I asked that before ... as you are supporting devicetree, gpio pins
> > should really be provided through devicetree properties and not be hardcoded.
> >
> Yes you did and I didn't come up with a solution to this problem yet. I understand
> and agree to your concerns but I'm lacking example code/documentation for it, maybe
> you can point me to an example on that and then I'll update my code accordingly.
> 

Have a look at Documentation/devicetree/bindings/gpio/gpio-fan.txt and
drivers/hwmon/gpio-fan.c.

> > > +struct a21_wdt_drv {
> > > +	struct watchdog_device wdt;
> > > +	struct mutex lock;
> > > +	}
> > > +
> > > +	if (timeout == 30 && wdt->timeout == 1) {
> > > +		dev_err(wdt->dev,
> > > +			"Transition from fast to slow mode not allowed\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > I dislike that [2 .. 29] timeout values are not supported, and would rather have
> > you accept that range and set the timeout to 30. Also, it is somewhat undesirable
> > that the timeout can not be changed back to 30 after being set to 1.
> 
> The not changing back issue was a hardware design criterion and I have no
> influence on that one. I've already checked with the IC developer and he said,
> this is intended. I don't quite understand why I should accept the timeout and
> set it to 30? In my opinion this only introduces some magic the user won't
> understand. Instead failing and giving an error message is something a user can
> take as a hint for investigating.
> 
On the other side you expect the user to know about the 1 / 30 limitation, which
I think is worse. The value actually set is returned by the ioctl per API, so
the application can check the actually configured value. As such, it is not
entirely true that the behavior would be unexpected.

> > As Wim recommended, a softdog on top of the hardware watchdog would be the best
> > solution. I'll leave it up to him to decide if he wants to accept the code
> > as-is.
> 
> Yes let's see what he's saying.
> 
Agreed.

> >
> > > +	mutex_lock(&drv->lock);
> > > +
> > > +	ret = watchdog_register_device(&a21_wdt);
> > > +	if (ret) {
> > > +		dev_err(&pdev->dev, "Cannot register watchdog device\n");
> > > +		goto err_register_wd;
> > > +	}
> > > +
> > > +	ret = a21_wdt_get_bootstatus(&reset);
> > > +	if (ret)
> > > +		dev_warn(&pdev->dev, "Reset Cause contains invalid data\n");
> > > +	else {
> > > +		if (reset == 2)
> > > +			a21_wdt.bootstatus |= WDIOF_EXTERN1;
> > > +		else if (reset == 4)
> > > +			a21_wdt.bootstatus |= WDIOF_CARDRESET;
> > > +		else if (reset == 5)
> > > +			a21_wdt.bootstatus |= WDIOF_POWERUNDER;
> > > +		else if (reset == 7)
> > > +			a21_wdt.bootstatus |= WDIOF_EXTERN2;
> >
> > What about other causes ? No useful match ?
> >
> 
> None I could find. Actually WDIOF_EXTERN[12] already are a pretty creative
> mapping in my opinion. EXTERN1 is a "Push Button" event, EXTERN2 is a reset
> caused by a JTAG/BDM adapter...
> 
ok.

> > I think bootstatus should be set prior to registering the watchdog device
> > to avoid race conditions where an application reads it prior to being set.
> >
> Agreed, didn't see that one *doh*, must be fixed before inclusion.

Happens to me all the time :)

Guenter
