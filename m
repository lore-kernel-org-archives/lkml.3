Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936022AbaH0WMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 18:12:53 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:61534 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246AbaH0WMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 18:12:51 -0400
Date: Thu, 28 Aug 2014 00:12:10 +0200
From: Beniamino Galvani <b.galvani@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Carlo Caione <carlo@caione.org>
Subject: Re: [PATCH 3/4] watchdog: add driver for Ricoh RN5T618 watchdog
Message-ID: <20140827221209.GA24987@gmail.com>
References: <1409091237-16722-1-git-send-email-b.galvani@gmail.com>
 <1409091237-16722-4-git-send-email-b.galvani@gmail.com>
 <20140827190135.GA18849@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140827190135.GA18849@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 12:01:35PM -0700, Guenter Roeck wrote:
[...]
> > +#include <linux/device.h>
> > +#include <linux/mfd/rn5t618.h>
> > +#include <linux/module.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/watchdog.h>
> > +
> > +#define DRIVER_NAME "rn5t618-wdt"
> > +
> > +static bool nowayout = WATCHDOG_NOWAYOUT;
> > +static unsigned int heartbeat = -1;
> 
> I'd be surprised if this doesn't cause a compiler warning.
> Why not just initialize the variable with 0 ?

The idea was to initialize the variable with an invalid value that has
no effect when watchdog_init_timeout() is called during probe, thus
leaving the watchdog timeout to the maximum value.

You are right, the same effect can be achieved in a cleaner way
leaving the variable to zero (by the way, the above assignment doesn't
seem to generate warnings).

> 
> > +
> > +module_param(heartbeat, int, 0);
> > +MODULE_PARM_DESC(heartbeat, "Initial watchdog heartbeat in seconds");
> > +
> > +module_param(nowayout, bool, 0);
> > +MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
> > +		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
> > +
> > +struct rn5t618_wdt {
> > +	struct watchdog_device wdt_dev;
> > +	struct rn5t618 *rn5t618;
> > +};

[..]

> > +static int rn5t618_wdt_set_timeout(struct watchdog_device *wdt_dev,
> > +				   unsigned int timeout)
> > +{
> > +	struct rn5t618_wdt *wdt = watchdog_get_drvdata(wdt_dev);
> > +	int ret, i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(rn5t618_wdt_map); i++) {
> > +		if (rn5t618_wdt_map[i].time + 1 >= timeout)
> > +			break;
> > +	}
> > +
> > +	if (i == ARRAY_SIZE(rn5t618_wdt_map))
> > +		ret = -EINVAL;
> 
> Can you simplify this a bit ? If you use
> 
> 	if (i == ARRAY_SIZE(rn5t618_wdt_map))
> 		return -EINVAL;
> 
> > +	else
> 
> You can drop this else statement.

Will do, thanks.

Beniamino
