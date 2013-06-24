Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab3FXLyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:54:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37584 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab3FXLyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:54:38 -0400
Message-ID: <51C83348.6040905@ti.com>
Date: Mon, 24 Jun 2013 17:23:44 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joel A Fernandes <agnel.joel@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, Joel A Fernandes <joelagnel@ti.com>,
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
Subject: Re: [PATCH v12 05/11] edma: config: Enable config options for EDMA
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com> <201306212044.26677.arnd@arndb.de> <CAD=GYpY4koXd9f6_ijQfDHsiULD4d53cdu=9X421WXSAit_YQg@mail.gmail.com> <201306220014.16427.arnd@arndb.de> <CAD=GYpabakChmN-TEJbLn6p=BwX2wsK5KWsc5gH9-cAA+yWcEA@mail.gmail.com>
In-Reply-To: <CAD=GYpabakChmN-TEJbLn6p=BwX2wsK5KWsc5gH9-cAA+yWcEA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/22/2013 8:23 AM, Joel A Fernandes wrote:
>>>> config TI_EDMA
>>>>         tristate "TI EDMA support"
>>>>         default m if 'ARCH_DAVINCI || ARCH_OMAP1 || ARCH_OMAP2
>>>>         select DMA_ENGINE
>>>>         select DMA_VIRTUAL_CHANNELS
>>>
>>>
>>> MMC depends on EDMA specially on AM33xx there's no PIO mode AFAIK. The
>>> 'm' option will require some initramfs to load the module when needing
>>> to MMC boot, I suggest lets leave it as y.
>>>
>>
>> Ah, right: you still export a filter function from the edma driver
>> and use it in slave drivers:
>>
>> drivers/mmc/host/davinci_mmc.c:         dma_request_slave_channel_compat(mask, edma_filter_fn,
>> drivers/mmc/host/davinci_mmc.c:         dma_request_slave_channel_compat(mask, edma_filter_fn,
>> drivers/spi/spi-davinci.c:      dspi->dma_rx = dma_request_channel(mask, edma_filter_fn,
>> drivers/spi/spi-davinci.c:      dspi->dma_tx = dma_request_channel(mask, edma_filter_fn,
>>
>> As long as this is the case, you have to be careful with the dependencies
>> to make sure that davinci_mmc and spi-davinci either depend on TI_EDMA, or
>> edma_filter_fn gets defined to NULL when you are building for a DT-only platform.
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
> 
> This also has the side effect of causing DMA requests to fail if
> TI_EDMA is not built, causing frustration for a lot of people some of
> whom don't want to deal with DMA so I think it is OK to build the
> driver in by default as it is (and will be) used by a lot of
> OMAP2PLUS.

Solution for this is to enable TI_EDMA in relevant defconfigs. Most
folks who would get frustrated by such issues would be using defconfigs
and for those who are building their configuration from scratch this
will be pretty low in their list of worries.

Thanks,
Sekhar
