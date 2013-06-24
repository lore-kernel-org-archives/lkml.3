Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab3FXUcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 16:32:14 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:36414 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab3FXUcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 16:32:12 -0400
MIME-Version: 1.0
In-Reply-To: <201306242228.23297.arnd@arndb.de>
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
	<201306220014.16427.arnd@arndb.de>
	<CAD=GYpabakChmN-TEJbLn6p=BwX2wsK5KWsc5gH9-cAA+yWcEA@mail.gmail.com>
	<201306242228.23297.arnd@arndb.de>
Date: Mon, 24 Jun 2013 15:32:11 -0500
Message-ID: <CAD=GYpYwswOYGHRzZ6SeKD+sEfi-7s3HuqKr7G0OXQWFCA_EtQ@mail.gmail.com>
Subject: Re: [PATCH v12 05/11] edma: config: Enable config options for EDMA
From: Joel A Fernandes <agnel.joel@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 3:28 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 22 June 2013, Joel A Fernandes wrote:
>>
>> >> > config TI_EDMA
>> >> >         tristate "TI EDMA support"
>> >> >         default m if 'ARCH_DAVINCI || ARCH_OMAP1 || ARCH_OMAP2
>> >> >         select DMA_ENGINE
>> >> >         select DMA_VIRTUAL_CHANNELS
>> >>
>> >>
>> >> MMC depends on EDMA specially on AM33xx there's no PIO mode AFAIK. The
>> >> 'm' option will require some initramfs to load the module when needing
>> >> to MMC boot, I suggest lets leave it as y.
>> >>
>> >
>> > Ah, right: you still export a filter function from the edma driver
>> > and use it in slave drivers:
>> >
>> > drivers/mmc/host/davinci_mmc.c:         dma_request_slave_channel_compat(mask, edma_filter_fn,
>> > drivers/mmc/host/davinci_mmc.c:         dma_request_slave_channel_compat(mask, edma_filter_fn,
>> > drivers/spi/spi-davinci.c:      dspi->dma_rx = dma_request_channel(mask, edma_filter_fn,
>> > drivers/spi/spi-davinci.c:      dspi->dma_tx = dma_request_channel(mask, edma_filter_fn,
>> >
>> > As long as this is the case, you have to be careful with the dependencies
>> > to make sure that davinci_mmc and spi-davinci either depend on TI_EDMA, or
>> > edma_filter_fn gets defined to NULL when you are building for a DT-only platform.
>>
>> Yes sure, right now they are defined  as follows in include/linux/edma.h:
>>
>> #if defined(CONFIG_TI_EDMA) || defined(CONFIG_TI_EDMA_MODULE)
>> bool edma_filter_fn(struct dma_chan *, void *);
>> #else
>> static inline bool edma_filter_fn(struct dma_chan *chan, void *param)
>> {
>> return false;
>> }
>> #endif
>
> It's best to just define the filter function in the platform
> code and pass a pointer to it through platform data. The way you do
> it above makes the slave drivers inherently nonportable.

But with DT-only platforms, can you really do that?

Thanks,
Joel
