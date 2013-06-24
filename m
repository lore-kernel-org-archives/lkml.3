Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131Ab3FXU3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 16:29:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:65112 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3FXU3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 16:29:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Joel A Fernandes <agnel.joel@gmail.com>
Subject: Re: [PATCH v12 05/11] edma: config: Enable config options for EDMA
Date: Mon, 24 Jun 2013 22:28:23 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sekhar Nori <nsekhar@ti.com>, Joel A Fernandes <joelagnel@ti.com>,
        Tony Lindgren <tony@atomide.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com> <201306220014.16427.arnd@arndb.de> <CAD=GYpabakChmN-TEJbLn6p=BwX2wsK5KWsc5gH9-cAA+yWcEA@mail.gmail.com>
In-Reply-To: <CAD=GYpabakChmN-TEJbLn6p=BwX2wsK5KWsc5gH9-cAA+yWcEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306242228.23297.arnd@arndb.de>
X-Provags-ID: V02:K0:wmwptYJKPuXHNVVclQkC6GBlQADRGkgxLgY/uiSu7Wy
 CZlwl3zVinVRKbocgKKNXdRpkE1wBEsZrB0/tnc55dk3jpGHM/
 7tCvidoZ07PC6J0DbzqRH1w1eANOwh8NPyxuiv2pnISU1uRQjs
 8u5Ik0l6d4ScYh0fCOTqkB40OPjlQHKDZEm63D5QPjrgLzGi+P
 rR0BU8T9SzgIek0AQMgPQ2QJr3hvf4ZmB18DBG11jkhljyxW89
 uoCe8CK227nWMmIhXUJtXxe+tb+IefX31DjQMJsHzioblzDo3D
 qyFTBajvIFcddyvjiZ37S+s4EmFpBZ+HTkz+zXFuy7cBpsJRHJ
 yvsljn5Wsk7WOmZLGANc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 June 2013, Joel A Fernandes wrote:
> 
> >> > config TI_EDMA
> >> >         tristate "TI EDMA support"
> >> >         default m if 'ARCH_DAVINCI || ARCH_OMAP1 || ARCH_OMAP2
> >> >         select DMA_ENGINE
> >> >         select DMA_VIRTUAL_CHANNELS
> >>
> >>
> >> MMC depends on EDMA specially on AM33xx there's no PIO mode AFAIK. The
> >> 'm' option will require some initramfs to load the module when needing
> >> to MMC boot, I suggest lets leave it as y.
> >>
> >
> > Ah, right: you still export a filter function from the edma driver
> > and use it in slave drivers:
> >
> > drivers/mmc/host/davinci_mmc.c:         dma_request_slave_channel_compat(mask, edma_filter_fn,
> > drivers/mmc/host/davinci_mmc.c:         dma_request_slave_channel_compat(mask, edma_filter_fn,
> > drivers/spi/spi-davinci.c:      dspi->dma_rx = dma_request_channel(mask, edma_filter_fn,
> > drivers/spi/spi-davinci.c:      dspi->dma_tx = dma_request_channel(mask, edma_filter_fn,
> >
> > As long as this is the case, you have to be careful with the dependencies
> > to make sure that davinci_mmc and spi-davinci either depend on TI_EDMA, or
> > edma_filter_fn gets defined to NULL when you are building for a DT-only platform.
> 
> Yes sure, right now they are defined  as follows in include/linux/edma.h:
> 
> #if defined(CONFIG_TI_EDMA) || defined(CONFIG_TI_EDMA_MODULE)
> bool edma_filter_fn(struct dma_chan *, void *);
> #else
> static inline bool edma_filter_fn(struct dma_chan *chan, void *param)
> {
> return false;
> }
> #endif

It's best to just define the filter function in the platform
code and pass a pointer to it through platform data. The way you do
it above makes the slave drivers inherently nonportable.

	Arnd
