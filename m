Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423697Ab3FUWO2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 18:14:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59309 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423527Ab3FUWO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 18:14:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Joel A Fernandes <agnel.joel@gmail.com>
Subject: Re: [PATCH v12 05/11] edma: config: Enable config options for EDMA
Date: Sat, 22 Jun 2013 00:14:16 +0200
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
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com> <201306212044.26677.arnd@arndb.de> <CAD=GYpY4koXd9f6_ijQfDHsiULD4d53cdu=9X421WXSAit_YQg@mail.gmail.com>
In-Reply-To: <CAD=GYpY4koXd9f6_ijQfDHsiULD4d53cdu=9X421WXSAit_YQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306220014.16427.arnd@arndb.de>
X-Provags-ID: V02:K0:F3FsD656AFCCB+Oc8yIrZIftyhUGeuhnceeQWZiFeqr
 7MZ9dAULQSzgGXQ9n/cupELX3B0Mz03/2JbEhMcJr0J2nnkAbu
 aP/n4D6o81TdnE8QDuekunfzL+MpRHelX1MfiLUFPfeF07L6Jz
 o9/wTW0nTbQ20FOkI0Q1KTQ1Q+SHsqe7sHrfO4Sh8SHdthi4JF
 SQj9nK+t3PamHiCGlIIwQDMkPUPHU7DC8U7MQsdXeWvjlC0zk6
 ykOavdRvUij3B8MOg+jf/Hcbi/KOUoK9GwDqrP4VXyFLo0I9VD
 9Al55ojHJJ+2JeMcGygHCLgB7X++lI/x+eUrTFts07IW8UGvi9
 w+/pWiXCDaEgKZuY4NFI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 June 2013, Joel A Fernandes wrote:
> Hi Arnd,
> 
> On Fri, Jun 21, 2013 at 1:44 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Friday 21 June 2013, Joel A Fernandes wrote:
> >> I think we are talking about different things, I agree the 'select
> >> DMADEVICES' can be dropped but lets please keep the default y option
> >> (not adding new select statements, just saying that if someone select
> >> DMADEVICES in menuconfig and if they're ARCH_OMAP=1 , then default to
> >> EDMA). This will simply allow people to have a default. Thanks.
> >
> > Yes, that's ok.
> 
> Ok, thanks. I will follow up with a patch in my next submissions that builds it.
> 
> Perhaps a:
> default y if 'ARCH_OMAP2PLUS'
> 
> and leave the existing as it is...
> default n if  'ARCH_DAVINCI || ARCH_OMAP1 || ARCH_OMAP2'
> 
> would make most sense to me. Basically EDMA is seen on current and all
> new OMAP2PLUS.

Ok

> > config TI_EDMA
> >         tristate "TI EDMA support"
> >         default m if 'ARCH_DAVINCI || ARCH_OMAP1 || ARCH_OMAP2
> >         select DMA_ENGINE
> >         select DMA_VIRTUAL_CHANNELS
> 
> 
> MMC depends on EDMA specially on AM33xx there's no PIO mode AFAIK. The
> 'm' option will require some initramfs to load the module when needing
> to MMC boot, I suggest lets leave it as y.
> 

Ah, right: you still export a filter function from the edma driver
and use it in slave drivers:

drivers/mmc/host/davinci_mmc.c:         dma_request_slave_channel_compat(mask, edma_filter_fn,
drivers/mmc/host/davinci_mmc.c:         dma_request_slave_channel_compat(mask, edma_filter_fn,
drivers/spi/spi-davinci.c:      dspi->dma_rx = dma_request_channel(mask, edma_filter_fn,
drivers/spi/spi-davinci.c:      dspi->dma_tx = dma_request_channel(mask, edma_filter_fn,

As long as this is the case, you have to be careful with the dependencies
to make sure that davinci_mmc and spi-davinci either depend on TI_EDMA, or
edma_filter_fn gets defined to NULL when you are building for a DT-only platform.

	Arnd
