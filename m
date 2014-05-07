Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679AbaEGPum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:50:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59971 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625AbaEGPuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:50:39 -0400
Message-ID: <1399477754.4536.13.camel@weser.hi.pengutronix.de>
Subject: Re: [RFC PATCH 1/5] watchdog: Add API to trigger reboots
From: Lucas Stach <l.stach@pengutronix.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Russell King <linux@arm.linux.org.uk>, linux-watchdog@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Wim Van Sebroeck <wim@iguana.be>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Date: Wed, 07 May 2014 17:49:14 +0200
In-Reply-To: <536A2EAB.4000605@roeck-us.net>
References: <1398958893-30049-1-git-send-email-linux@roeck-us.net>
		 <1398958893-30049-2-git-send-email-linux@roeck-us.net>
		 <20140503012243.GG4090@lukather> <20140503042925.GB5882@roeck-us.net>
	 <1399463549.4536.10.camel@weser.hi.pengutronix.de>
	 <536A2EAB.4000605@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 07.05.2014, 06:01 -0700 schrieb Guenter Roeck:
> On 05/07/2014 04:52 AM, Lucas Stach wrote:
> > Hi Guenter,
> >
> > Am Freitag, den 02.05.2014, 21:29 -0700 schrieb Guenter Roeck:
> >> On Fri, May 02, 2014 at 06:22:43PM -0700, Maxime Ripard wrote:
> >>> Hi Guenter,
> >>>
> >>> On Thu, May 01, 2014 at 08:41:29AM -0700, Guenter Roeck wrote:
> >>>> Some hardware implements reboot through its watchdog hardware,
> >>>> for example by triggering a watchdog timeout. Platform specific
> >>>> code starts to spread into watchdog drivers, typically by setting
> >>>> pointers to a callback functions which is then called from the
> >>>> platform reset handler.
> >>>>
> >>>> To simplify code and provide a unified API to trigger reboots by
> >>>> watchdog drivers, provide a single API to trigger such reboots
> >>>> through the watchdog subsystem.
> >>>>
> >>>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> >>>> ---
> >>>>   drivers/watchdog/watchdog_core.c |   17 +++++++++++++++++
> >>>>   include/linux/watchdog.h         |   11 +++++++++++
> >>>>   2 files changed, 28 insertions(+)
> >>>>
> >>>> diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
> >>>> index cec9b55..4ec6e2f 100644
> >>>> --- a/drivers/watchdog/watchdog_core.c
> >>>> +++ b/drivers/watchdog/watchdog_core.c
> >>>> @@ -43,6 +43,17 @@
> >>>>   static DEFINE_IDA(watchdog_ida);
> >>>>   static struct class *watchdog_class;
> >>>>
> >>>> +static struct watchdog_device *wdd_reboot_dev;
> >>>> +
> >>>> +void watchdog_do_reboot(enum reboot_mode mode, const char *cmd)
> >>>> +{
> >>>> +	if (wdd_reboot_dev) {
> >>>> +		if (wdd_reboot_dev->ops->reboot)
> >>>> +			wdd_reboot_dev->ops->reboot(wdd_reboot_dev, mode, cmd);
> >>>> +	}
> >>>> +}
> >>>> +EXPORT_SYMBOL(watchdog_do_reboot);
> >>>> +
> >>>>   static void watchdog_check_min_max_timeout(struct watchdog_device *wdd)
> >>>>   {
> >>>>   	/*
> >>>> @@ -162,6 +173,9 @@ int watchdog_register_device(struct watchdog_device *wdd)
> >>>>   		return ret;
> >>>>   	}
> >>>>
> >>>> +	if (wdd->ops->reboot)
> >>>> +		wdd_reboot_dev = wdd;
> >>>> +
> >>>
> >>> Overall, it looks really great, but I guess we can make it a
> >>> list. Otherwise, we might end up in a situation where we could not
> >>> reboot anymore, like this one for example:
> >>>    - a first watchdog is probed, registers a reboot function
> >>>    - a second watchdog is probed, registers a reboot function that
> >>>      overwrites the first one.
> >>>    - then, the second watchdog disappears for some reason, and the
> >>>      reboot is set to NULL
> >>>
> >> I thought about that, but how likely (or unlikely) is that to ever happen ?
> >> So I figured it is not worth the effort, and would just add complexity without
> >> real gain. We could always add the list later if we ever encounter a situation
> >> where two watchdogs in the same system provide a reboot callback.
> >>
> >
> > While this is not directly related to the issue you are fixing with this
> > series, I would like to have it considered when talking about a watchdog
> > system reboot API.
> >
> > On i.MX we have the same situation where we have to reboot through the
> > SoC watchdog. This works, but may leave the external components of the
> > system (those not integrated in the SoC) in an undefined state. So if we
> > have a PMIC with integrated watchdog we would rather like to this one to
> > reboot the system, as it the reset is then much more closer to a
> > power-on-reset.
> >
> > This means we could have multiple watchdogs in the system, where we
> > really want a specific one (maybe designated through a DT property) to
> > do the reset. This isn't compatible with the "last watchdog that
> > registers a handler wins the system reset" logic in your patch.
> >
> 
> Wouldn't the order in which watchdogs are configured in dt define that ?
> The last one wins.

That sounds rather fragile to me. I would like to have a more explicit
property to control this behavior.

Regards,
Lucas
-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

