Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab3BASb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 13:31:58 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:34960 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab3BASb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 13:31:56 -0500
Date: Fri, 1 Feb 2013 13:32:31 -0500
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>
Cc: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v7 00/10] DMA Engine support for AM33XX
Message-ID: <20130201183231.GO2244@beef>
References: <1359742975-10421-1-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359742975-10421-1-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 01:22:45PM -0500, Matt Porter wrote:

<snip>

> This series adds DMA Engine support for AM33xx, which uses
> an EDMA DMAC. The EDMA DMAC has been previously supported by only
> a private API implementation (much like the situation with OMAP
> DMA) found on the DaVinci family of SoCs.

Tony,

Will you be able to take this series in through your tree? It appears we
just need acks on the new bindings and the compat api change. I haven't
heard from you or Benoit on the dts patches so it seems those are ready
as well.

Thanks,
Matt

> 
> The series applies on top of 3.8-rc5 and the following patches:
> 
> 	- dmaengine DT support and edma dmaengine driver fix from 
> 	  the git://git.infradead.org/users/vkoul/slave-dma.git next
> 	  branch
> 
> The approach taken is similar to how OMAP DMA is being converted to
> DMA Engine support. With the functional EDMA private API already
> existing in mach-davinci/dma.c, we first move that to an ARM common
> area so it can be shared. Adding DT and runtime PM support to the
> private EDMA API implementation allows it to run on AM33xx. AM33xx
> *only* boots using DT so we leverage Jon's generic DT DMA helpers to
> register EDMA DMAC with the of_dma framework and then add support
> for calling the dma_request_slave_channel() API to both the mmc
> and spi drivers.
> 
> With this series both BeagleBone and the AM335x EVM have working
> SPI DMA support (and MMC support with the separate MMC series).
> 
> This is tested on BeagleBone with a SPI framebuffer driver and MMC
> rootfs. A trivial gpio DMA event misc driver was used to test the
> crossbar DMA event support. It is also tested on the AM335x EVM
> with the onboard SPI flash and MMC rootfs. The branch at
> https://github.com/ohporter/linux/tree/edma-dmaengine-am33xx-v7
> has the complete series, dependencies, and some test
> drivers/defconfigs. Note that MMC can only be tested with a
> separate MMC dmaengine/DT series applied.
> 
> Regression testing was done on AM180x-EVM (which also makes use
> of the EDMA dmaengine driver and the EDMA private API) using SD,
> SPI flash, and the onboard audio supported by the ASoC Davinci
> driver. Regression testing was also done on a BeagleBoard xM
> booting from the legacy board file using MMC rootfs.
> 
> 
> Matt Porter (10):
>   ARM: davinci: move private EDMA API to arm/common
>   ARM: edma: remove unused transfer controller handlers
>   ARM: edma: add AM33XX support to the private EDMA API
>   dmaengine: edma: enable build for AM33XX
>   dmaengine: edma: Add TI EDMA device tree binding
>   ARM: dts: add AM33XX EDMA support
>   dmaengine: add dma_request_slave_channel_compat()
>   spi: omap2-mcspi: convert to dma_request_slave_channel_compat()
>   spi: omap2-mcspi: add generic DMA request support to the DT binding
>   ARM: dts: add AM33XX SPI DMA support
> 
>  Documentation/devicetree/bindings/dma/ti-edma.txt  |   49 +++
>  Documentation/devicetree/bindings/spi/omap-spi.txt |   27 +-
>  arch/arm/Kconfig                                   |    1 +
>  arch/arm/boot/dts/am33xx.dtsi                      |   30 ++
>  arch/arm/common/Kconfig                            |    3 +
>  arch/arm/common/Makefile                           |    1 +
>  arch/arm/{mach-davinci/dma.c => common/edma.c}     |  342 +++++++++++++++++---
>  arch/arm/mach-davinci/Makefile                     |    2 +-
>  arch/arm/mach-davinci/board-tnetv107x-evm.c        |    2 +-
>  arch/arm/mach-davinci/davinci.h                    |    2 +-
>  arch/arm/mach-davinci/devices-tnetv107x.c          |    2 +-
>  arch/arm/mach-davinci/devices.c                    |    6 +-
>  arch/arm/mach-davinci/dm355.c                      |    2 +-
>  arch/arm/mach-davinci/dm365.c                      |    2 +-
>  arch/arm/mach-davinci/dm644x.c                     |    2 +-
>  arch/arm/mach-davinci/dm646x.c                     |    2 +-
>  arch/arm/mach-davinci/include/mach/da8xx.h         |    2 +-
>  arch/arm/plat-omap/Kconfig                         |    1 +
>  drivers/dma/Kconfig                                |    2 +-
>  drivers/dma/edma.c                                 |    2 +-
>  drivers/mmc/host/davinci_mmc.c                     |    1 +
>  drivers/spi/spi-omap2-mcspi.c                      |   65 ++--
>  include/linux/dmaengine.h                          |   16 +
>  include/linux/mfd/davinci_voicecodec.h             |    3 +-
>  .../mach => include/linux/platform_data}/edma.h    |   90 +-----
>  include/linux/platform_data/spi-davinci.h          |    2 +-
>  sound/soc/davinci/davinci-evm.c                    |    1 +
>  sound/soc/davinci/davinci-pcm.c                    |    1 +
>  sound/soc/davinci/davinci-pcm.h                    |    2 +-
>  sound/soc/davinci/davinci-sffsdr.c                 |    7 +-
>  30 files changed, 496 insertions(+), 174 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/dma/ti-edma.txt
>  rename arch/arm/{mach-davinci/dma.c => common/edma.c} (86%)
>  rename {arch/arm/mach-davinci/include/mach => include/linux/platform_data}/edma.h (59%)
> 
> -- 
> 1.7.9.5
> 
