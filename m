Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324AbaLKO7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 09:59:09 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:48271 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbaLKO7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 09:59:07 -0500
Date: Thu, 11 Dec 2014 14:58:49 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Will Deacon <Will.Deacon@arm.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, "heiko@sntech.de" <heiko@sntech.de>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "shc_work@mail.ru" <shc_work@mail.ru>,
        "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "padma.v@samsung.com" <padma.v@samsung.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "shawn.guo@freescale.com" <shawn.guo@freescale.com>,
        "bcousson@baylibre.com" <bcousson@baylibre.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "kgene@kernel.org" <kgene@kernel.org>,
        "kesavan.abhilash@gmail.com" <kesavan.abhilash@gmail.com>,
        Pawel Moll <Pawel.Moll@arm.com>
Subject: Re: [PATCH 2/2] misc: sram: switch to ioremap_wc from ioremap
Message-ID: <20141211145849.GH31456@e104818-lin.cambridge.arm.com>
References: <1418266726-12004-1-git-send-email-a.kesavan@samsung.com>
 <1418266726-12004-2-git-send-email-a.kesavan@samsung.com>
 <1418292513.3188.4.camel@pengutronix.de>
 <20141211103919.GA6067@arm.com>
 <1418298046.3188.10.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418298046.3188.10.camel@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 11:40:46AM +0000, Philipp Zabel wrote:
> Hi Will,
> 
> Am Donnerstag, den 11.12.2014, 10:39 +0000 schrieb Will Deacon:
> > On Thu, Dec 11, 2014 at 10:08:33AM +0000, Philipp Zabel wrote:
> > > Hi Abhilash,
> > > 
> > > Am Donnerstag, den 11.12.2014, 08:28 +0530 schrieb Abhilash Kesavan:
> > > > Currently, the SRAM allocator returns device memory via ioremap.
> > > > This causes issues on ARM64 when the internal SoC SRAM allocated by
> > > > the generic sram driver is used for audio playback. The destination
> > > > buffer address (which is ioremapped SRAM) is not 64-bit aligned for
> > > > certain streams (e.g. 44.1k sampling rate). In such cases we get
> > > > unhandled alignment faults. Use ioremap_wc in place of ioremap which
> > > > gives us normal non-cacheable memory instead of device memory.
> > > 
> > > Could this break the omap_bus_sync() implementation in
> > > arch/arm/mach-omap2/omap4-common.c?
> > > 
> > >     void omap_bus_sync(void)
> > >     {
> > >             if (dram_sync && sram_sync) {
> > >                     writel_relaxed(readl_relaxed(dram_sync), dram_sync);
> > >                     writel_relaxed(readl_relaxed(sram_sync), sram_sync);
> > >                     isb();
> > >             }
> > >     }
> > > 
> > > It is used in wmb() and omap_do_wfi() to drain interconnect write
> > > buffers on omap4/5. If sram_sync is mapped with write-combining, could
> > > the last write to sram_sync stay stuck in the write-combining buffer
> > > until after the function returns?
> > 
> > I think you have that issue anyway, since you can get an early write
> > response even if you use ioremap. Does the write to sram_sync have
> > side-effects that we need to wait for?
> 
> [Added Tony Lindgren and Santosh Shilimkar to Cc:]
> I don't know.

In addition to Will's question, do you care about the access size?
ioremap() returns Device memory which is bufferable (early
acknowledgement) but it guarantees the access size. With write
combining, you may get a different access size than requested.

-- 
Catalin
