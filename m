Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760928Ab3DCPZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 11:25:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43371 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759449Ab3DCPZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 11:25:24 -0400
Date: Wed, 3 Apr 2013 17:09:52 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-i2c@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] watchdog: Add Congatec CGEB watchdog driver
Message-ID: <20130403150952.GX1906@pengutronix.de>
References: <1360663374-30951-1-git-send-email-s.hauer@pengutronix.de>
 <1360663374-30951-4-git-send-email-s.hauer@pengutronix.de>
 <CAH9NwWd7YdtK0urutisVgKoE7NmPFLpG3wFG5W6P7o45vUqAng@mail.gmail.com>
 <20130326143331.GA5529@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326143331.GA5529@roeck-us.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:04:42 up 284 days,  6:16, 114 users,  load average: 2.91, 5.34,
 6.70
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 07:33:31AM -0700, Guenter Roeck wrote:
> On Tue, Mar 26, 2013 at 11:16:35AM +0100, Christian Gmeiner wrote:
> > 2013/2/12 Sascha Hauer <s.hauer@pengutronix.de>:
> > > This driver provides support for the CGEB watchdog found on some
> > > Congatec x86 modules.
> > >
> > > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > > ---
> > >  drivers/watchdog/Kconfig                  |   10 ++
> > >  drivers/watchdog/Makefile                 |    1 +
> > >  drivers/watchdog/congatec_cgeb_watchdog.c |  161 +++++++++++++++++++++++++++++
> > >  3 files changed, 172 insertions(+)
> > >  create mode 100644 drivers/watchdog/congatec_cgeb_watchdog.c
> > >
> > > diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> > > index 7f809fd..47138fb 100644
> > > --- a/drivers/watchdog/Kconfig
> > > +++ b/drivers/watchdog/Kconfig
> > > @@ -934,6 +934,16 @@ config SBC_EPX_C3_WATCHDOG
> > >           To compile this driver as a module, choose M here: the
> > >           module will be called sbc_epx_c3.
> > >
> > > +config CONGATEC_CGEB_WATCHDOG
> > > +       depends on CONGATEC_CGEB
> > > +       tristate "Congatec CGEB watchdog"
> > > +       ---help---
> > > +         This driver provides support for the watchdogs found on Congatec
> > > +         modules with the CGEB BIOS interface.
> > > +
> > > +         To compile this driver as a module, choose M here: the
> > > +         module will be called congatec_cgeb_wdt.
> > > +
> > >  # M32R Architecture
> > >
> > >  # M68K Architecture
> > > diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> > > index 97bbdb3a..e67eee5 100644
> > > --- a/drivers/watchdog/Makefile
> > > +++ b/drivers/watchdog/Makefile
> > > @@ -108,6 +108,7 @@ obj-$(CONFIG_W83977F_WDT) += w83977f_wdt.o
> > >  obj-$(CONFIG_MACHZ_WDT) += machzwd.o
> > >  obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
> > >  obj-$(CONFIG_INTEL_SCU_WATCHDOG) += intel_scu_watchdog.o
> > > +obj-$(CONFIG_CONGATEC_CGEB_WATCHDOG) += congatec_cgeb_watchdog.o
> > >
> > >  # M32R Architecture
> > >
> > > diff --git a/drivers/watchdog/congatec_cgeb_watchdog.c b/drivers/watchdog/congatec_cgeb_watchdog.c
> > > new file mode 100644
> > > index 0000000..b7b6cf5
> > > --- /dev/null
> > > +++ b/drivers/watchdog/congatec_cgeb_watchdog.c
> > > @@ -0,0 +1,161 @@
> > > +/*
> > > + * CGEB watchdog driver
> > > + *
> > > + * (c) 2011 Sascha Hauer, Pengutronix
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License as published by
> > > + * the Free Software Foundation; version 2 of the License.
> > > + *
> > > + * This program is distributed in the hope that it will be useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + * GNU General Public License for more details.
> > > + */
> > > +#include <linux/module.h>
> > > +#include <linux/platform_device.h>
> > > +#include <linux/watchdog.h>
> > > +#include <asm/congatec-cgeb.h>
> > > +
> > > +#define CGOS_WDOG_MODE_REBOOT_PC    0
> > > +#define CGOS_WDOG_MODE_RESTART_OS   1
> > > +#define CGOS_WDOG_MODE_STAGED    0x80
> > > +
> > > +#define CGOS_WDOG_OPMODE_DISABLED      0
> > > +#define CGOS_WDOG_OPMODE_ONETIME_TRIG  1
> > > +#define CGOS_WDOG_OPMODE_SINGLE_EVENT  2
> > > +#define CGOS_WDOG_OPMODE_EVENT_REPEAT  3
> > > +
> > > +#define CGOS_WDOG_EVENT_INT 0  /* NMI/IRQ */
> > > +#define CGOS_WDOG_EVENT_SCI 1  /* SMI/SCI */
> > > +#define CGOS_WDOG_EVENT_RST 2  /* system reset */
> > > +#define CGOS_WDOG_EVENT_BTN 3  /* power button */
> > > +
> > > +#define CGOS_WDOG_EVENT_MAX_STAGES 3
> > > +
> > > +struct cgeb_watchdog_stage {
> > > +       unsigned long timeout;
> > > +       unsigned long event;
> > > +};
> > > +
> > > +struct cgeb_watchdog_config {
> > > +       unsigned long size;
> > > +       unsigned long timeout; /* not used in staged mode */
> > > +       unsigned long delay;
> > > +       unsigned long mode;
> > > +       /* optional parameters for staged watchdog */
> > > +       unsigned long op_mode;
> > > +       unsigned long stage_count;
> > > +       struct cgeb_watchdog_stage stages[CGOS_WDOG_EVENT_MAX_STAGES];
> > > +};
> 
> Presumably that is a data structure sent to the board. Just wondering - can the
> driver ever be build as 64 bit driver ? If so, you might want to use u32 instead
> of unsigned long.

I don't think that this is used on any 64bit capable hardware. Anyway,
explicitly using u32 here sounds very good. I'll change it.

> > > +static int cgeb_watchdog_start(struct watchdog_device *wdd)
> > > +{
> > > +       struct cgeb_watchdog_priv *priv = watchdog_get_drvdata(wdd);
> > > +
> > > +       return watchdog_set_config(priv, wdd->timeout);
> > > +}
> > > +
> > > +static int cgeb_watchdog_stop(struct watchdog_device *wdd)
> > > +{
> > > +       struct cgeb_watchdog_priv *priv = watchdog_get_drvdata(wdd);
> > > +
> > > +       return watchdog_set_config(priv, 0);
> > > +}
> > > +
> > > +static int cgeb_watchdog_set_timeout(struct watchdog_device *wdd,
> > > +               unsigned int timeout_s)
> > > +{
> > > +       return 0;
> > > +}
> 
> That doesn't make any sense - it means wdd->timeout is never set. That also
> means it is never started.

Yeah, I just realized that since v3.4 the watchdog core no longer sets
wdd->timeout, the drivers have to do it themselves. Will fix.

> > > +       priv->wdd.ops = &cgeb_watchdog_ops;
> > > +       priv->wdd.info = &cgeb_wdd_info;
> > > +       priv->wdd.min_timeout = 1;
> > > +       priv->wdd.max_timeout = 3600;
> 
> Might make sense to also set wdd.timeout to a default value, especially since
> watchdog_init_timeout is not called.

Ok, will do.

> 
> On a side note, if the driver supports devicetree, it might make sense to call
> watchdog_init_timeout, since it initializes the timeout from devicetree data.

The driver does not support devicetree.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
