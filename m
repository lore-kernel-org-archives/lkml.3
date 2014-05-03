Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750962AbaECE3e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 00:29:34 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38048 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaECE3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 00:29:32 -0400
Date: Fri, 2 May 2014 21:29:25 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] watchdog: Add API to trigger reboots
Message-ID: <20140503042925.GB5882@roeck-us.net>
References: <1398958893-30049-1-git-send-email-linux@roeck-us.net>
 <1398958893-30049-2-git-send-email-linux@roeck-us.net>
 <20140503012243.GG4090@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140503012243.GG4090@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 06:22:43PM -0700, Maxime Ripard wrote:
> Hi Guenter,
> 
> On Thu, May 01, 2014 at 08:41:29AM -0700, Guenter Roeck wrote:
> > Some hardware implements reboot through its watchdog hardware,
> > for example by triggering a watchdog timeout. Platform specific
> > code starts to spread into watchdog drivers, typically by setting
> > pointers to a callback functions which is then called from the
> > platform reset handler.
> > 
> > To simplify code and provide a unified API to trigger reboots by
> > watchdog drivers, provide a single API to trigger such reboots
> > through the watchdog subsystem.
> > 
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> >  drivers/watchdog/watchdog_core.c |   17 +++++++++++++++++
> >  include/linux/watchdog.h         |   11 +++++++++++
> >  2 files changed, 28 insertions(+)
> > 
> > diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
> > index cec9b55..4ec6e2f 100644
> > --- a/drivers/watchdog/watchdog_core.c
> > +++ b/drivers/watchdog/watchdog_core.c
> > @@ -43,6 +43,17 @@
> >  static DEFINE_IDA(watchdog_ida);
> >  static struct class *watchdog_class;
> >  
> > +static struct watchdog_device *wdd_reboot_dev;
> > +
> > +void watchdog_do_reboot(enum reboot_mode mode, const char *cmd)
> > +{
> > +	if (wdd_reboot_dev) {
> > +		if (wdd_reboot_dev->ops->reboot)
> > +			wdd_reboot_dev->ops->reboot(wdd_reboot_dev, mode, cmd);
> > +	}
> > +}
> > +EXPORT_SYMBOL(watchdog_do_reboot);
> > +
> >  static void watchdog_check_min_max_timeout(struct watchdog_device *wdd)
> >  {
> >  	/*
> > @@ -162,6 +173,9 @@ int watchdog_register_device(struct watchdog_device *wdd)
> >  		return ret;
> >  	}
> >  
> > +	if (wdd->ops->reboot)
> > +		wdd_reboot_dev = wdd;
> > +
> 
> Overall, it looks really great, but I guess we can make it a
> list. Otherwise, we might end up in a situation where we could not
> reboot anymore, like this one for example:
>   - a first watchdog is probed, registers a reboot function
>   - a second watchdog is probed, registers a reboot function that
>     overwrites the first one.
>   - then, the second watchdog disappears for some reason, and the
>     reboot is set to NULL
> 
I thought about that, but how likely (or unlikely) is that to ever happen ?
So I figured it is not worth the effort, and would just add complexity without
real gain. We could always add the list later if we ever encounter a situation
where two watchdogs in the same system provide a reboot callback.

> Or maybe we can just use the start callback, with the min timeout already
> registered, and prevent the user to kick the watchdog.
> 
Doesn't always work, unfortunately, even now. The moxart driver causes 
an explicit and immediate reset. Also, some watchdogs don't reset the system
directly but get an interrupt, which then calls the reset handler. Which,
in our case, would call the start callback again, and you would have an endless
loop.

Guenter
