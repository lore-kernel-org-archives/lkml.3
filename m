Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab3FPUya (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 16:54:30 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:58300 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3FPUy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 16:54:28 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, alsa-devel@alsa-project.org,
        Kukjin Kim <kgene.kim@samsung.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Padmavathi Venna <padma.v@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alban Bedel <alban.bedel@avionic-design.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [RFC PATCH 00/11] ARM: s3c64xx: Let amba-pl08x driver handle DMA
Date: Sun, 16 Jun 2013 22:54:07 +0200
Message-Id: <1371416058-22047-1-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Tomasz Figa (9):
  dma: amba-pl08x: Use bitmap to pass variant specific quirks
  dma: amba-pl08x: Refactor pl08x_getbytes_chan() to lower indentation
  dma: amba-pl08x: Add support for different offset of CONFIG register
  dma: amba-pl08x: Add support for PL080S variant
  dma: amba-pl08x: Add support for different maximum transfer size
  dma: amba-pl08x: Keep LLIs aligned to 4-word boundary
  spi: s3c64xx: Do not require legacy DMA API in case of S3C64XX
  ASoC: samsung: Do not require legacy DMA API in case of S3C64XX
  ARM: s3c64xx: Add support for DMA using generic amba-pl08x driver

 arch/arm/Kconfig                         |   1 +
 arch/arm/mach-s3c64xx/Kconfig            |   8 +-
 arch/arm/mach-s3c64xx/Makefile           |   1 +
 arch/arm/mach-s3c64xx/common.h           |   5 +
 arch/arm/mach-s3c64xx/include/mach/dma.h |  65 +++++
 arch/arm/mach-s3c64xx/pl080.c            | 244 +++++++++++++++++++
 drivers/dma/amba-pl08x.c                 | 399 ++++++++++++++++++++++---------
 drivers/spi/Kconfig                      |   2 +-
 include/linux/amba/pl080.h               |   1 +
 sound/soc/samsung/Kconfig                |   2 +-
 10 files changed, 613 insertions(+), 115 deletions(-)
 create mode 100644 arch/arm/mach-s3c64xx/pl080.c

-- 
1.8.2.1

