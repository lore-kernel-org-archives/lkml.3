Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab3KNC62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 21:58:28 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:55001 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3KNC6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 21:58:22 -0500
Date: Thu, 14 Nov 2013 11:58:19 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca
Subject: Re: [PATCH] gpio: Renesas RZ GPIO driver
Message-ID: <20131114025818.GA22870@verge.net.au>
References: <20131106234737.8971.37405.sendpatchset@w520>
 <1777251.JReTVdX0Pd@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1777251.JReTVdX0Pd@avalon>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 01:03:35PM +0100, Laurent Pinchart wrote:
> Hi Magnus,
> 
> Thank you for the patch.
> 
> Please read below for a couple of comments in addition to Linus' review.
> 
> On Thursday 07 November 2013 08:47:37 Magnus Damm wrote:
> > From: Magnus Damm <damm@opensource.se>
> > 
> > This patch adds a GPIO driver for the RZ series of SoCs from
> > Renesas. The driver can be used as platform device with dynamic
> > or static GPIO assignment or via DT using dynamic GPIOs.
> > 
> > The hardware allows control of GPIOs in blocks of up to 16 pins,
> > and once device may span multiple blocks. Interrupts are not
> > included in this hardware block, if interrupts are needed then
> > the PFC needs to be configured to a IRQ pin function which is
> > handled by the GIC hardware.
> > 
> > Tested with yet-to-be-posted platform device and DT devices on
> > r7s72100 and Genmai using LEDs, DIP switches and I2C bitbang.
> > 
> > Signed-off-by: Magnus Damm <damm@opensource.se>
> > ---
> > 
> >  drivers/gpio/Kconfig                  |    6
> >  drivers/gpio/Makefile                 |    1
> >  drivers/gpio/gpio-rz.c                |  241 ++++++++++++++++++++++++++++++
> >  include/linux/platform_data/gpio-rz.h |   13 +
> >  4 files changed, 261 insertions(+)
> > 
> > --- 0001/drivers/gpio/Kconfig
> > +++ work/drivers/gpio/Kconfig	2013-11-06 12:07:13.000000000 +0900
> > @@ -230,6 +230,12 @@ config GPIO_RCAR
> >  	help
> >  	  Say yes here to support GPIO on Renesas R-Car SoCs.
> > 
> > +config GPIO_RZ
> > +	tristate "Renesas RZ GPIO"
> > +	depends on ARM
> > +	help
> > +	  Say yes here to support GPIO on Renesas RZ SoCs.
> > +
> >  config GPIO_SAMSUNG
> >  	bool
> >  	depends on PLAT_SAMSUNG
> > --- 0001/drivers/gpio/Makefile
> > +++ work/drivers/gpio/Makefile	2013-11-06 12:07:13.000000000 +0900
> > @@ -62,6 +62,7 @@ obj-$(CONFIG_GPIO_PXA)		+= gpio-pxa.o
> >  obj-$(CONFIG_GPIO_RC5T583)	+= gpio-rc5t583.o
> >  obj-$(CONFIG_GPIO_RDC321X)	+= gpio-rdc321x.o
> >  obj-$(CONFIG_GPIO_RCAR)		+= gpio-rcar.o
> > +obj-$(CONFIG_GPIO_RZ)		+= gpio-rz.o
> >  obj-$(CONFIG_GPIO_SAMSUNG)	+= gpio-samsung.o
> >  obj-$(CONFIG_ARCH_SA1100)	+= gpio-sa1100.o
> >  obj-$(CONFIG_GPIO_SCH)		+= gpio-sch.o
> > --- /dev/null
> > +++ work/drivers/gpio/gpio-rz.c	2013-11-06 14:20:02.000000000 +0900
> > @@ -0,0 +1,241 @@
> > +/*
> > + * RZ GPIO Support - Ports
> > + *
> > + *  Copyright (C) 2013 Magnus Damm
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License

Is there a trailing portion of this paragraph that is missing?

> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 
> > USA
> > + */
> 
> You can ditch the last two paragraphs.
> 
> > +
> > +#include <linux/init.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/spinlock.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/ioport.h>
> > +#include <linux/io.h>
> > +#include <linux/bitops.h>
> > +#include <linux/err.h>
> > +#include <linux/gpio.h>
> > +#include <linux/slab.h>
> > +#include <linux/module.h>
> > +#include <linux/pinctrl/consumer.h>
> > +#include <linux/platform_data/gpio-rz.h>
> 
> Could you please sort the headers alphabetically ?

As its slightly relevant: I recently discovered that vim has a sort command.

:-13,. sort

[snip]
