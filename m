Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbaFLLe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:34:56 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55727 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755851AbaFLLez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:34:55 -0400
Date: Thu, 12 Jun 2014 12:34:45 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>, Tomasz Figa <tomasz.figa@gmail.com>,
        Mark Brown <broonie@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Kconfig fails: big select-based circular dependency
Message-ID: <20140612113445.GF23430@n2100.arm.linux.org.uk>
References: <20140607090944.GL23430@n2100.arm.linux.org.uk> <20140612094745.GD23430@n2100.arm.linux.org.uk> <6077426.uLBS643pC0@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6077426.uLBS643pC0@wuerfel>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 12:31:19PM +0200, Arnd Bergmann wrote:
> On Thursday 12 June 2014 10:47:45 Russell King - ARM Linux wrote:
> > If no one responds, I'll assume that no one is interested, and I'll
> > just create a pile of patches removing a bunch of these idiotic select
> > statements at random to break this loop.
> 
> I missed the original mail, and I don't remember seeing this particular
> dependency chain.
> 
> > On Sat, Jun 07, 2014 at 10:09:44AM +0100, Russell King - ARM Linux wrote:
> > > This is getting silly:
> > > 
> > > scripts/kconfig/conf --silentoldconfig Kconfig
> > > drivers/dma/Kconfig:5:error: recursive dependency detected!
> > > drivers/dma/Kconfig:5:  symbol DMADEVICES is selected by SAMSUNG_DMADEV
> 
> The 'select DMADEVICES' from plat-samsung/Kconfig is certainly wrong,
> we shouldn't do that, but I'd do some extended build regression tests
> to ensure that it doesn't cause other problems.
> 
> I'll have a look.

Yes, SAMSUNG_DMADEV looks like it's a shim layer between DMA engine and
the old Samsung platform private DMA API.  I suspect SAMSUNG_DMADEV should
be selected by the drivers which make use of this shim iff DMADEVICES is
enabled.

> > > arch/arm/plat-samsung/Kconfig:412:      symbol SAMSUNG_DMADEV is selected by S3C64XX_PL080

I think killing the select statement against S3C64XX_PL080 of this shim is
also a correct move - I suspect that's just there to make Kconfig life
easier (which is not really a valid reason for adding a select statement
to a major subsystem.)

> > > arch/arm/mach-s3c64xx/Kconfig:20:       symbol S3C64XX_PL080 is selected by SPI_S3C64XX

As I said in my reply to Paul, this select should also be killed.  At
the very least, it should be turned into "depends on S3C64XX_PL080 if
ARCH_S3C64XX".

Since the comments in the driver say that the driver depends on having a
DMA engine, I'd suggest also adding a dependency on DMADEVICES as well,
to encode that explicit requirement in the Kconfig language:

config SPI_S3C64XX
	tristate "Samsung S3C64XX series type SPI"
	depends on PLAT_SAMSUNG && DMADEVICES
	depends on S3C64XX_PL080 if ARCH_S3C64XX

The driver will cleanly fail if it can't get the DMA channels that it
requires to operate, so we don't need to do anything more than this here.

> > > drivers/spi/Kconfig:429:        symbol SPI_S3C64XX depends on SPI
> > > drivers/spi/Kconfig:8:  symbol SPI is selected by DRM_PANEL_LD9040
> 
> 'select SPI' is also really bad. This seems trivial to replace with
> 'depends on SPI'. This is the only driver that uses select here.

Definitely.

> > > drivers/gpu/drm/panel/Kconfig:19:       symbol DRM_PANEL_LD9040 depends on DRM_PANEL
> > > drivers/gpu/drm/panel/Kconfig:1:        symbol DRM_PANEL is selected by DRM_IMX_LDB
> > > drivers/staging/imx-drm/Kconfig:35:     symbol DRM_IMX_LDB depends on MFD_SYSCON
> > > drivers/mfd/Kconfig:722:        symbol MFD_SYSCON is selected by POWER_RESET_KEYSTONE
> 
> We have 10 drivers doing 'select MFD_SYSCON' and 9 drivers doing
> 'depends on MFD_SYSCON'. Either one would work if we did those
> consistently, here the problem is really mixing the two.

Indeed - we need clear policies on this stuff, because as we get different
platforms doing different things (as is the case in this scenario), we are
only going to see an increase in this problem.

Also, I don't think we should do just one change to break this loop - this
is a sign of a much bigger disease.  We are heading towards the situation
where adding just one 'select' or 'depends on' statement between two symbols,
thereby adding just one more dependency to an already tightly linked graph
can cause a circular dependency.

We need to stop this behaviour ASAP, and kill off as many of these
ill-considered or wrong dependencies as possible, otherwise we're risking
Kconfig becoming unmaintainable.

Whenever we see a new 'select' statment appearing in a patch for something
which is not a utility symbol, we need to ask what the justification is
for it being there, and evaluate whether it's reasonable (ideally, this
should be detailed in the commit log.)

(I define a utility symbol as one whose primary purpose is to be selected.)

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
