Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab3AWVAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 16:00:14 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:59365 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3AWVAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 16:00:08 -0500
Date: Wed, 23 Jan 2013 16:00:10 -0500
From: Matt Porter <mporter@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v3 02/16] ARM: davinci: move private EDMA API to
 arm/common
Message-ID: <20130123210010.GB5256@beef>
References: <1350566815-409-1-git-send-email-mporter@ti.com>
 <1350566815-409-3-git-send-email-mporter@ti.com>
 <508CEA05.8060200@ti.com>
 <20130110235157.GU14660@beef>
 <d631bf39a8b8474bae448d089497fe0e@DLEE74.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d631bf39a8b8474bae448d089497fe0e@DLEE74.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 03:40:06PM +0000, Sekhar Nori wrote:
> Matt,
> 
> Sorry about the late reply. I noticed this mail only after I started to
> look at v5 of your series :(

Any time is fine! :)
 
> On 1/11/2013 5:21 AM, Matt Porter wrote:
> > On Sun, Oct 28, 2012 at 01:47:09PM +0530, Sekhar Nori wrote:
> >> On 10/18/2012 6:56 PM, Matt Porter wrote:
> >>> Move mach-davinci/dma.c to common/edma.c so it can be used
> >>> by OMAP (specifically AM33xx) as well. This just moves the
> >>> private EDMA API but does not support OMAP.
> >>>
> >>> Signed-off-by: Matt Porter <mporter@ti.com>
> >>> ---
> >>
> >>> diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
> >>> index 4c48a36..f45d591 100644
> >>> --- a/arch/arm/mach-davinci/devices.c
> >>> +++ b/arch/arm/mach-davinci/devices.c
> >>> @@ -19,9 +19,10 @@
> >>>  #include <mach/irqs.h>
> >>>  #include <mach/cputype.h>
> >>>  #include <mach/mux.h>
> >>> -#include <mach/edma.h>
> >>>  #include <linux/platform_data/mmc-davinci.h>
> >>>  #include <mach/time.h>
> >>> +#include <linux/platform_data/edma.h>
> >>
> >> Can you please introduce a patch to clean this mixture of linux/ and
> >> mach/ includes?
> > 
> > Yeah, are you ok with a follow on series to clean all these files? I
> > don't want to make this series longer with something not dma related
> > that's purely cleanup from the great header reorg of 2012.
> 
> Okay. I agree doing this sort of change now will cause merge issues.

Ok.

> 
> > 
> >>> +
> >>>  
> >>>  #include "davinci.h"
> >>>  #include "clock.h"
> >>> @@ -141,10 +142,10 @@ static struct resource mmcsd0_resources[] = {
> >>>  	},
> >>>  	/* DMA channels: RX, then TX */
> >>>  	{
> >>> -		.start = EDMA_CTLR_CHAN(0, DAVINCI_DMA_MMCRXEVT),
> >>> +		.start = EDMA_CTLR_CHAN(0, 26),
> >>
> >> Instead of just replacing the event #defines with plain numbers, can you
> >> introduce a mach-davinci local edma.h which can then be included in the
> >> davinci platform files which refer to edma channel numbers?
> > 
> > Ok, so when I removed the old edma.h it was full of unused defines and
> > we are left with just this one. If I introduced something like that it
> > would be used in just one place here. and only for these two values.
> > How about we just add a comment?
> 
> I prefer adding a local #define in this file. This will keep it
> consistent with what is done in arch/arm/mach-davinci/dm365.c for
> example. Same for the change in sound/soc/davinci/davinci-sffsdr.c

Ok, will do.

> > 
> >>
> >>> diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
> >>> index 7cd56ed..153fab8 100644
> >>> --- a/arch/arm/plat-omap/Kconfig
> >>> +++ b/arch/arm/plat-omap/Kconfig
> >>> @@ -28,6 +28,7 @@ config ARCH_OMAP2PLUS
> >>>  	select OMAP_DM_TIMER
> >>>  	select PROC_DEVICETREE if PROC_FS
> >>>  	select SPARSE_IRQ
> >>> +	select TI_PRIV_EDMA
> >>
> >> This hunk does not seem to belong to subject of this patch.
> > 
> > Let me reword the subject/description. The idea of this logical
> > chunk was to put everything in place to make it build on OMAP,
> > with the expectation that the build fails without the next patch
> > in the series.
> 
> But this will break bisect. With just this patch applied, omap build
> breaks. Looks like it will be more logical to merge this hunk with 3/14
> since that's when you really start using the private DMA support on OMAP
> platforms.

Ahh, yes,. thanks for pointing that out. I will address it and add your
ack. Thanks.

> This issue is a must fix IMO.
 
Ok.

> I am ok with the patch otherwise. With these changes done, you can add:
> 
> Acked-by: Sekhar Nori <nsekhar@ti.com>
> 
> Thanks,
> Sekhar
