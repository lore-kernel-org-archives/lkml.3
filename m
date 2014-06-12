Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbaFLMT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:19:59 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:55877 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbaFLMTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:19:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Mark Brown <broonie@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Kconfig fails: big select-based circular dependency
Date: Thu, 12 Jun 2014 14:19:45 +0200
Message-ID: <10376496.xoRI3F9EzH@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140612113445.GF23430@n2100.arm.linux.org.uk>
References: <20140607090944.GL23430@n2100.arm.linux.org.uk> <6077426.uLBS643pC0@wuerfel> <20140612113445.GF23430@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:6GMrs1/lg3xlv2cgcJdfgYgpJZbKDorTKHRokQMgiwx
 3BQy6ZDiOekxHt5xLfZpyMUctJ5Dcg1iVK8t1IhVqnXOj1bqrc
 DgA0Hva7GcLjIqpbvsa0TCZ6k2h2iNcfdDwXd4fJg6g0d8l6th
 1+UjeWTmyvkRedPrhMxPnSQXcltDbui89SMSrIkGOcl985rsva
 vOt2KS9ZKD7IJTDHI1pt0MCY0/bXGvtvYmmWyalWB8D7C9p0t0
 bi/Vq8kwt2QG+9WbdD6+k4gATJ2MGaVOp08m6Q7BODVotU6R6l
 xJI4Okt3246qOp4nKMY6JqNY4VzWxCVRzuRVVtNGLPa6khbOlD
 29SB8x66tcL7sQdZUf4E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2014 12:34:45 Russell King - ARM Linux wrote:
> On Thu, Jun 12, 2014 at 12:31:19PM +0200, Arnd Bergmann wrote:
> > On Thursday 12 June 2014 10:47:45 Russell King - ARM Linux wrote:
> > > If no one responds, I'll assume that no one is interested, and I'll
> > > just create a pile of patches removing a bunch of these idiotic select
> > > statements at random to break this loop.
> > 
> > I missed the original mail, and I don't remember seeing this particular
> > dependency chain.
> > 
> > > On Sat, Jun 07, 2014 at 10:09:44AM +0100, Russell King - ARM Linux wrote:
> > > > This is getting silly:
> > > > 
> > > > scripts/kconfig/conf --silentoldconfig Kconfig
> > > > drivers/dma/Kconfig:5:error: recursive dependency detected!
> > > > drivers/dma/Kconfig:5:  symbol DMADEVICES is selected by SAMSUNG_DMADEV
> > 
> > The 'select DMADEVICES' from plat-samsung/Kconfig is certainly wrong,
> > we shouldn't do that, but I'd do some extended build regression tests
> > to ensure that it doesn't cause other problems.
> > 
> > I'll have a look.
> 
> Yes, SAMSUNG_DMADEV looks like it's a shim layer between DMA engine and
> the old Samsung platform private DMA API.  I suspect SAMSUNG_DMADEV should
> be selected by the drivers which make use of this shim iff DMADEVICES is
> enabled.

FWIW, SAMSUNG_DMADEV should get removed in 3.17. At the moment
there is only one user (sound/soc/samsung/ac97.c), and that is
broken because it calls a NULL function pointer returned from
samsung_dma_get_ops().

> > > > arch/arm/plat-samsung/Kconfig:412:      symbol SAMSUNG_DMADEV is selected by S3C64XX_PL080
> 
> I think killing the select statement against S3C64XX_PL080 of this shim is
> also a correct move - I suspect that's just there to make Kconfig life
> easier (which is not really a valid reason for adding a select statement
> to a major subsystem.)
> 
> > > > arch/arm/mach-s3c64xx/Kconfig:20:       symbol S3C64XX_PL080 is selected by SPI_S3C64XX
> 
> As I said in my reply to Paul, this select should also be killed.  At
> the very least, it should be turned into "depends on S3C64XX_PL080 if
> ARCH_S3C64XX".
> 
> Since the comments in the driver say that the driver depends on having a
> DMA engine, I'd suggest also adding a dependency on DMADEVICES as well,
> to encode that explicit requirement in the Kconfig language:
> 
> config SPI_S3C64XX
> 	tristate "Samsung S3C64XX series type SPI"
> 	depends on PLAT_SAMSUNG && DMADEVICES
> 	depends on S3C64XX_PL080 if ARCH_S3C64XX
> 
> The driver will cleanly fail if it can't get the DMA channels that it
> requires to operate, so we don't need to do anything more than this here.

I have struggled with this dependency a few times before, the conversion
from the samsung specific DMA driver to dmaengine did not go well, and we
still see the fallout from that here.

It seems this particular case was just a mistake that Tomasz made in
3faecea70b0 "spi: s3c64xx: Always select S3C64XX_PL080 when ARCH_S3C64XX
is enabled" when the correct conversion would have been to drop the
dependency.

However, the arch/arm/plat-samsung/dma-ops.c code relies on either
S3C64XX_PL080 or PL330_DMA (but not both!) to be enabled, and the
dependency in the SPI driver happens to ensure that at the moment.

When we remove it here, we have to change the plat-samsung code to
either do the select there or fix it properly. I'm inclined to go
for a hack here, because this code is going away anyway.

diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index 8a22df5..704dbc6 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -416,6 +416,7 @@ config SAMSUNG_DMADEV
 	select DMADEVICES
 	select PL330_DMA if (ARCH_EXYNOS5 || ARCH_EXYNOS4 || CPU_S5PV210 || CPU_S5PC100 || \
 					CPU_S5P6450 || CPU_S5P6440)
+	select S3C64XX_PL080 if ARCH_S3C64XX
 	help
 	  Use DMA device engine for PL330 DMAC.
 
diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 213b5cb..33d935c 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -422,7 +422,6 @@ config SPI_S3C24XX_FIQ
 config SPI_S3C64XX
 	tristate "Samsung S3C64XX series type SPI"
 	depends on PLAT_SAMSUNG
-	select S3C64XX_PL080 if ARCH_S3C64XX
 	help
 	  SPI driver for Samsung S3C64XX and newer SoCs.
 
diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
index d863722..8c1fe01 100644
--- a/arch/arm/mach-s3c64xx/Kconfig
+++ b/arch/arm/mach-s3c64xx/Kconfig
@@ -20,7 +20,6 @@ config CPU_S3C6410
 config S3C64XX_PL080
 	bool "S3C64XX DMA using generic PL08x driver"
 	select AMBA_PL08X
-	select SAMSUNG_DMADEV
 
 config S3C64XX_SETUP_SDHCI
 	bool

This would also avoid changing the defconfigs.

> > > > drivers/gpu/drm/panel/Kconfig:19:       symbol DRM_PANEL_LD9040 depends on DRM_PANEL
> > > > drivers/gpu/drm/panel/Kconfig:1:        symbol DRM_PANEL is selected by DRM_IMX_LDB
> > > > drivers/staging/imx-drm/Kconfig:35:     symbol DRM_IMX_LDB depends on MFD_SYSCON
> > > > drivers/mfd/Kconfig:722:        symbol MFD_SYSCON is selected by POWER_RESET_KEYSTONE
> > 
> > We have 10 drivers doing 'select MFD_SYSCON' and 9 drivers doing
> > 'depends on MFD_SYSCON'. Either one would work if we did those
> > consistently, here the problem is really mixing the two.
> 
> Indeed - we need clear policies on this stuff, because as we get different
> platforms doing different things (as is the case in this scenario), we are
> only going to see an increase in this problem.
> 
> Also, I don't think we should do just one change to break this loop - this
> is a sign of a much bigger disease.  We are heading towards the situation
> where adding just one 'select' or 'depends on' statement between two symbols,
> thereby adding just one more dependency to an already tightly linked graph
> can cause a circular dependency.
> 
> We need to stop this behaviour ASAP, and kill off as many of these
> ill-considered or wrong dependencies as possible, otherwise we're risking
> Kconfig becoming unmaintainable.
> 
> Whenever we see a new 'select' statment appearing in a patch for something
> which is not a utility symbol, we need to ask what the justification is
> for it being there, and evaluate whether it's reasonable (ideally, this
> should be detailed in the commit log.)
> 
> (I define a utility symbol as one whose primary purpose is to be selected.)

Agreed. Ideally a symbol that gets selected by another one would always
be a 'silent' one, i.e. not also be user selectable, but we can't really
enforce that with thousands of symbols not following that.

One common scenario seems valid, too: A platform selects a driver or
subsystem, and the platform specific driver has a dependency on that.
Things just get this messy if the driver itself does the select.

	Arnd
