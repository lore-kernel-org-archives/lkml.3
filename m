Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaI1Wvd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 18:51:33 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:59031 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaI1Wva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 18:51:30 -0400
Date: Mon, 29 Sep 2014 00:50:16 +0200
From: Beniamino Galvani <b.galvani@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Carlo Caione <carlo@caione.org>
Subject: Re: [PATCH 3/4] watchdog: add driver for Ricoh RN5T618 watchdog
Message-ID: <20140928225016.GA30777@gmail.com>
References: <1409091237-16722-1-git-send-email-b.galvani@gmail.com>
 <1409091237-16722-4-git-send-email-b.galvani@gmail.com>
 <20140904091917.GA1397@lee--X1>
 <20140928203646.GB571@spo001.leaseweb.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140928203646.GB571@spo001.leaseweb.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 10:36:46PM +0200, Wim Van Sebroeck wrote:
> Hi Lee,
> 
> > Still waiting on a Watchdog Ack, so I can take this set in.
> > 
> > > This adds a driver for the watchdog timer available in Ricoh RN5T618
> > > PMIC. The device supports a programmable expiration time of 1, 8, 32
> > > or 128 seconds.
> > > 
> > > Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> > > ---
> > >  drivers/watchdog/Kconfig       |   11 +++
> > >  drivers/watchdog/Makefile      |    1 +
> > >  drivers/watchdog/rn5t618_wdt.c |  196 ++++++++++++++++++++++++++++++++++++++++
> > >  include/linux/mfd/rn5t618.h    |    4 +
> > >  4 files changed, 212 insertions(+)
> > >  create mode 100644 drivers/watchdog/rn5t618_wdt.c
> > > 
> > > diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> > > index f57312f..9eba6af 100644
> > > --- a/drivers/watchdog/Kconfig
> > > +++ b/drivers/watchdog/Kconfig
> > > @@ -309,6 +309,17 @@ config ORION_WATCHDOG
> > >  	  To compile this driver as a module, choose M here: the
> > >  	  module will be called orion_wdt.
> > >  
> > > +config RN5T618_WATCHDOG
> > > +	tristate "Ricoh RN5T618 watchdog"
> > > +	depends on MFD_RN5T618
> > > +	select WATCHDOG_CORE
> > > +	help
> > > +	  If you say yes here you get support for watchdog on the Ricoh
> > > +	  RN5T618 PMIC.
> > > +
> > > +	  This driver can also be built as a module.  If so, the module
> > > +	  will be called rn5t618_wdt.
> > > +
> > >  config SUNXI_WATCHDOG
> > >  	tristate "Allwinner SoCs watchdog support"
> > >  	depends on ARCH_SUNXI
> > > diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> > > index 468c320..0afa343 100644
> > > --- a/drivers/watchdog/Makefile
> > > +++ b/drivers/watchdog/Makefile
> > > @@ -47,6 +47,7 @@ obj-$(CONFIG_IOP_WATCHDOG) += iop_wdt.o
> > >  obj-$(CONFIG_DAVINCI_WATCHDOG) += davinci_wdt.o
> > >  obj-$(CONFIG_ORION_WATCHDOG) += orion_wdt.o
> > >  obj-$(CONFIG_SUNXI_WATCHDOG) += sunxi_wdt.o
> > > +obj-$(CONFIG_RN5T618_WATCHDOG) += rn5t618_wdt.o
> > >  obj-$(CONFIG_COH901327_WATCHDOG) += coh901327_wdt.o
> > >  obj-$(CONFIG_STMP3XXX_RTC_WATCHDOG) += stmp3xxx_rtc_wdt.o
> > >  obj-$(CONFIG_NUC900_WATCHDOG) += nuc900_wdt.o
> > > diff --git a/drivers/watchdog/rn5t618_wdt.c b/drivers/watchdog/rn5t618_wdt.c
> > > new file mode 100644
> > > index 0000000..3a76ad7
> > > --- /dev/null
> > > +++ b/drivers/watchdog/rn5t618_wdt.c
> > > @@ -0,0 +1,196 @@
> > > +/*
> > > + * Watchdog driver for Ricoh RN5T618 PMIC
> > > + *
> > > + * Copyright (C) 2014 Beniamino Galvani <b.galvani@gmail.com>
> > > + *
> > > + * This program is free software; you can redistribute it and/or
> > > + * modify it under the terms of the GNU General Public License
> > > + * version 2 as published by the Free Software Foundation.
> > > + *
> > > + * You should have received a copy of the GNU General Public License
> > > + * along with this program. If not, see <http://www.gnu.org/licenses/>.
> > > + */
> > > +
> > > +#include <linux/device.h>
> > > +#include <linux/mfd/rn5t618.h>
> > > +#include <linux/module.h>
> > > +#include <linux/platform_device.h>
> > > +#include <linux/watchdog.h>
> > > +
> > > +#define DRIVER_NAME "rn5t618-wdt"
> > > +
> > > +static bool nowayout = WATCHDOG_NOWAYOUT;
> > > +static unsigned int heartbeat = -1;
> > > +
> > > +module_param(heartbeat, int, 0);
> > > +MODULE_PARM_DESC(heartbeat, "Initial watchdog heartbeat in seconds");
> > > +
> 
> These are the comments I just mailed:
> 1) this is actually a timeout value and not the same as the heartbeat of the watchdog device.
> So I prefer this also to be called as timeout and not heartbeat.
> 2) this actually is an unsigned int.
> 
> For the rest OK by me.

Hi Wim,

there was a more recent version of the patch [1] , but your comments
were still valid. I addressed your suggestions in v3 of the patch [2].

Beniamino

[1] http://lwn.net/Articles/610000/
[2] https://lkml.org/lkml/2014/9/28/173
