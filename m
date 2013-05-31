Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab3EaMxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:53:22 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.149]:48079 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758Ab3EaMxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:53:14 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-6.tower-180.messagelabs.com!1370004791!28164465!1
X-Originating-IP: [83.171.138.125]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Fri, 31 May 2013 14:53:11 +0200
Date: Fri, 31 May 2013 14:55:19 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Guenter Roeck <linux@roeck-us.net>
CC: <wim@iguana.be>, <guenter@roeck-us.net>, <linux-watchdog@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <johannes.thumshirn@men.de>
Subject: Re: [PATCH v6] watchdog: New watchdog driver for MEN A21 watchdogs
Message-ID: <20130531125519.GB8983@jtlinux>
References: <20130531103654.GB5619@roeck-us.net>
 <20130531110846.GA15707@jtlinux>
 <20130531114037.GA13533@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130531114037.GA13533@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 31 May 2013 12:53:11.0070 (UTC) FILETIME=[CE5E03E0:01CE5DFD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenther,
On Fri, May 31, 2013 at 04:40:37AM -0700, Guenter Roeck wrote:
> > +#define GPIO_WD_ENAB	169
> > +#define GPIO_WD_FAST	170
> > +#define GPIO_WD_TRIG	171
> > +
> > +#define GPIO_RST_CAUSE_BASE 166
> > +
>
> I think I asked that before ... as you are supporting devicetree, gpio pins
> should really be provided through devicetree properties and not be hardcoded.
>
Yes you did and I didn't come up with a solution to this problem yet. I understand
and agree to your concerns but I'm lacking example code/documentation for it, maybe
you can point me to an example on that and then I'll update my code accordingly.

> > +struct a21_wdt_drv {
> > +	struct watchdog_device wdt;
> > +	struct mutex lock;
> > +	}
> > +
> > +	if (timeout == 30 && wdt->timeout == 1) {
> > +		dev_err(wdt->dev,
> > +			"Transition from fast to slow mode not allowed\n");
> > +		return -EINVAL;
> > +	}
> > +
> I dislike that [2 .. 29] timeout values are not supported, and would rather have
> you accept that range and set the timeout to 30. Also, it is somewhat undesirable
> that the timeout can not be changed back to 30 after being set to 1.

The not changing back issue was a hardware design criterion and I have no
influence on that one. I've already checked with the IC developer and he said,
this is intended. I don't quite understand why I should accept the timeout and
set it to 30? In my opinion this only introduces some magic the user won't
understand. Instead failing and giving an error message is something a user can
take as a hint for investigating.

> As Wim recommended, a softdog on top of the hardware watchdog would be the best
> solution. I'll leave it up to him to decide if he wants to accept the code
> as-is.

Yes let's see what he's saying.

>
> > +	mutex_lock(&drv->lock);
> > +
> > +	ret = watchdog_register_device(&a21_wdt);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Cannot register watchdog device\n");
> > +		goto err_register_wd;
> > +	}
> > +
> > +	ret = a21_wdt_get_bootstatus(&reset);
> > +	if (ret)
> > +		dev_warn(&pdev->dev, "Reset Cause contains invalid data\n");
> > +	else {
> > +		if (reset == 2)
> > +			a21_wdt.bootstatus |= WDIOF_EXTERN1;
> > +		else if (reset == 4)
> > +			a21_wdt.bootstatus |= WDIOF_CARDRESET;
> > +		else if (reset == 5)
> > +			a21_wdt.bootstatus |= WDIOF_POWERUNDER;
> > +		else if (reset == 7)
> > +			a21_wdt.bootstatus |= WDIOF_EXTERN2;
>
> What about other causes ? No useful match ?
>

None I could find. Actually WDIOF_EXTERN[12] already are a pretty creative
mapping in my opinion. EXTERN1 is a "Push Button" event, EXTERN2 is a reset
caused by a JTAG/BDM adapter...

> I think bootstatus should be set prior to registering the watchdog device
> to avoid race conditions where an application reads it prior to being set.
>
Agreed, didn't see that one *doh*, must be fixed before inclusion.
> > +	}
