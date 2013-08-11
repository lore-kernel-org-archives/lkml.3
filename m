Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab3HKR7t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 13:59:49 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:58845 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab3HKR7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 13:59:44 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Dan Williams <djbw@fb.com>, Jaroslav Kysela <perex@perex.cz>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sangbeom Kim <sbkim73@samsung.com>, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vinod.koul@intel.com>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 00/18] ARM: s3c64xx: Let amba-pl08x driver handle DMA
Date: Sun, 11 Aug 2013 19:59:12 +0200
Message-Id: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is first non-RFC version of my patches extending support of
amba-pl08x DMA engine driver to PL080S DMA engine (PL080 modified by
Samsung) found in Samsung S3C64xx SoCs.

Due to changes scattered across different areas of kernel, patches are
based on merged 3 branches:
 - for-next of Kgene's Samsung tree,
 - clk-next of Mike's clock tree,
 - next of Vinod's slave DMA tree.

To ease testing I have prepared a branch in my private tree for anyone
willing to check the patches out:
	git://github.com/tom3q/linux.git v3.12-pl080

Dependencies (already applied in my branch):
 - for patches 14 and 16 - CCF-based clock driver for s3c64xx.
 
Some of the patches not related to the amba-pl08x driver itself
can be likely applied into appropriate trees separately, namely:
 - 09/18 - ASoC: Samsung: Do not queue cyclic buffers multiple times,
 - 14/18 - clk: samsung: s3c64xx: Add aliases for DMA clocks.
 
After patch 14/18, both old and new DMA drivers can be supported on
S3C64xx, depending on Kconfig options. Patches 15-18 remove the old driver
leaving support only for the generic pl08x driver. Feel free to drop those
patches for now if we want more testing, but I don't suspect any problems.

On S3C64xx-based Mini6410 and SMDK6410 boards, with I2S audio
playback and capture (including full duplex operation) and also SPI
using spidev:

Tested-by: Tomasz Figa <tomasz.figa@gmail.com>

Changes since RFC v2:
 - Added clkdev lookups to old clock driver.
 - Added patches removing the old DMA driver and any remaining code
   needed by it.
 - Fixed DMA support for SPI.
 - Added a word about PL080S to amba-pl08x.c file header.
 - Changed definition of LLI words from enums to macros.
 - Extended debugging messages to handle PL080S variant as well.
 - Little cleanup of LLI dumping code.
 - Added check for peripheral flow control, which is unsupported by
   PL080S to dma_set_runtime_config.
 - Corrected transfer size mask of PL080S.

Changes since RFC v1:
 - Returned to original way of storing quirks as booleans, as suggested
   by Russell, Linus and Arnd.
 - Added reg_config field to pl08x_phy_chan struct, which stores
   variant-specific address of channel config register, as suggested
   by Russell.
 - Simplified handling of extended maximum transfer size of PL080S
   (no more conditional passing of 0 as length to pl08x_cctl_bits()).
 - Reworked LLI handling in the driver to stop casting arbitrary memory
   to a struct and allow different word count of LLI entry, as suggested
   by Linus.
 - Removed AMBA ID override from S3C64xx PL080 initialization code.
 - Fixed brokenness of Samsung DMA wrapper API, which caused cyclic buffers
   to be queued multiple times when DMA engine is used.
 - Included patch adding clock aliases for DMA engines (depends on
   Common Clock Framework driver for S3C64xx).
 - Fixed several minor stylistic issues.
 
For reference, here is the original description of the series:

One of the biggest roadblocks on the way of S3C64xx to DeviceTree support
is its DMA driver, which is completely platform-specific and provides
private API (s3c-dma), not even saying that its design is completely
against multiplatform-awareness.

The DMA controller present on this SoC series is a custom variant
of ARM PrimeCell PL080 modified by Samsung to add some extra features.
It is mostly compatible with original PL080, except:
 - CH_CONTROL2 register is added between CH_CONTROL and CH_CONFIG,
 - offset of CH_CONFIG register is different,
 - transfer size field is moved from CH_CONTROL to CH_CONTROL2,
 - transfer size field is extended to 24 bits, allowing much bigger
     single transfer,
 - LLI consists of one more word, to account for CH_CONTROL2 register.

Since all the rest is fully compatible with standard PL080 there is no
point in having separate driver just for this single variant, so I decided
to look into adding support for it to the amba-pl08x driver.

There was already some attempt to achieve this before, but this was before
Russel's big rework of the driver to use virtual channels, making the old
patches being not much of use.

This RFC series is a proof of concept that I managed to make during last
days of hacking. Except one patch adding clkdev lookup to clock driver
(which is being replaced with a CCF-compliant driver ATM), this is enough
to get memcpy and slave transfers to work on S3C64xx.

I have tested this on Mini6410 and SMDK6410 boards using dmatest for
memcpy and Samsung I2S with madplay/aplay for slave transfers.
Unfortunately I do not have access to other platforms with PL08x so
I could not test for any regressions introduced on them.

Credits for two patches go to Alban Bedel, who made a series fixing this
driver to make it usable with audio drivers. I rebased his patches on top
of mine and corrected coding style a bit.

OK, that's all. Any comments are welcome. Feel free to start throwing eggs
and tomatoes if you find this awful, but I won't be upset if I get some
Tested-by or Acked-by as well. ;)

Alban Bedel (2):
  dmaengine: PL08x: Fix reading the byte count in cctl
  dmaengine: PL08x: Add cyclic transfer support

Tomasz Figa (16):
  dmaengine: PL08x: Refactor pl08x_getbytes_chan() to lower indentation
  dmaengine: PL08x: Add support for different offset of CONFIG register
  dmaengine: PL08x: Rework LLI handling to be less fragile
  dmaengine: PL08x: Move LLI dumping code into separate function
  dmaengine: PL08x: Add support for PL080S variant
  dmaengine: PL08x: Add support for different maximum transfer size
  ASoC: Samsung: Do not queue cyclic buffers multiple times
  spi: s3c64xx: Do not require legacy DMA API in case of S3C64XX
  ASoC: Samsung: Do not require legacy DMA API in case of S3C64XX
  ARM: s3c64xx: Add support for DMA using generic amba-pl08x driver
  ARM: s3c64xx: clock: Add clkdev lookup for DMA clocks
  clk: samsung: s3c64xx: Add aliases for DMA clocks
  ARM: s3c64xx: Remove legacy DMA driver
  clk: samsung: s3c64xx: Remove clock aliases of old DMA driver
  spi: s3c64xx: Always select S3C64XX_PL080 when ARCH_S3C64XX is enabled
  ASoC: Samsung: Always select S3C64XX_PL080 when ARCH_S3C64XX is
    enabled

 arch/arm/Kconfig                         |   1 +
 arch/arm/mach-s3c64xx/Kconfig            |   7 +-
 arch/arm/mach-s3c64xx/Makefile           |   2 +-
 arch/arm/mach-s3c64xx/clock.c            |  28 +-
 arch/arm/mach-s3c64xx/common.h           |   5 +
 arch/arm/mach-s3c64xx/dma.c              | 753 -------------------------------
 arch/arm/mach-s3c64xx/include/mach/dma.h | 144 ++----
 arch/arm/mach-s3c64xx/pl080.c            | 244 ++++++++++
 arch/arm/plat-samsung/devs.c             |   6 +-
 arch/arm/plat-samsung/s3c-dma-ops.c      |  13 +-
 drivers/clk/samsung/clk-s3c64xx.c        |   4 +-
 drivers/dma/amba-pl08x.c                 | 501 ++++++++++++++------
 drivers/spi/Kconfig                      |   2 +-
 include/linux/amba/pl080.h               |   1 +
 sound/soc/samsung/Kconfig                |   2 +-
 sound/soc/samsung/dma.c                  |   7 +
 16 files changed, 705 insertions(+), 1015 deletions(-)
 delete mode 100644 arch/arm/mach-s3c64xx/dma.c
 create mode 100644 arch/arm/mach-s3c64xx/pl080.c

-- 
1.8.3.2

