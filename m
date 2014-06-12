Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501AbaFLOSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 10:18:06 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55951 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752900AbaFLOSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 10:18:02 -0400
Date: Thu, 12 Jun 2014 15:17:51 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Mark Brown <broonie@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Kconfig fails: big select-based circular dependency
Message-ID: <20140612141751.GH23430@n2100.arm.linux.org.uk>
References: <20140607090944.GL23430@n2100.arm.linux.org.uk> <10376496.xoRI3F9EzH@wuerfel> <20140612130330.GG23430@n2100.arm.linux.org.uk> <6046244.oz0lY2JOaZ@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6046244.oz0lY2JOaZ@wuerfel>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 03:37:18PM +0200, Arnd Bergmann wrote:
> I didn't say we should not fix it, I just meant we don't need to spend
> too much time on a perfect solution for code that is going away and that
> is already not used anywhere.
> 
> I've just replied to an older thread "Re: [PATCH 1/2] [RFC] ASoC: samsung:
> move s3c24xx over to dmaengine" with a patch that would let us kill off
> the code right away, or at least disable it in Kconfig.
> 
> For some reason, I can't reproduce the failure you see in your build system,
> I tried torvalds/master and next/master today and I have also done
> allmodconfig and randconfig builds in the past few days on slightly
> older versions.

That's because you don't have this commit:

Author: Philipp Zabel <p.zabel@pengutronix.de>
Date:   Thu Mar 6 14:54:39 2014 +0100

    imx-drm: imx-ldb: add drm_panel support
    
    This patch allows to optionally attach the lvds-channel to a panel
    supported by a drm_panel driver instead of supplying the modes via
    device tree.

    Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
    [Fixed build error due to missing select on DRM_PANEL --rmk]
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

diff --git a/drivers/staging/imx-drm/Kconfig b/drivers/staging/imx-drm/Kconfig
index c6e8ba7b3e4e..92fb52cbd3a2 100644
--- a/drivers/staging/imx-drm/Kconfig
+++ b/drivers/staging/imx-drm/Kconfig
@@ -35,6 +35,7 @@ config DRM_IMX_TVE
 config DRM_IMX_LDB
        tristate "Support for LVDS displays"
        depends on DRM_IMX && MFD_SYSCON
+       select DRM_PANEL
        help
          Choose this to enable the internal LVDS Display Bridge (LDB)
          found on i.MX53 and i.MX6 processors.

which introduces the final nail in the loop - and as imx-ldb really
does require DRM_PANEL support, and DRM_PANEL is not a user selectable
symbol, the above addition is an entirely reasonable thing to do.

The above commit /was/ going to go in during this merge window (along with
three others) had I not been soo hacked off with the crap change handling
and the general dysfunctional ARM community that we seem to have in the
kernel community now, and ended up walking totally away from kernel
maintanence for much of the last cycle... we're only /just/ starting to
find out all the problems that my MMC patch series caused... and there's
/still/ outstanding issues with the L2C patch series which /still/ have
not been resolved - both of which are now part of mainline so people will
now be forced to deal with these issues.  That's not the right way, but
it seems to be the /only/ way to get things done in todays dysfunctional
environment.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
