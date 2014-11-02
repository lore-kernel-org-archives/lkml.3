Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaKBN5e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 08:57:34 -0500
Received: from sauhun.de ([89.238.76.85]:35858 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbaKBN53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 08:57:29 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Balbir Singh <bsingharora@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [RFC 0/2] drivers: spi/i2c: account completions as iowait
Date: Sun,  2 Nov 2014 14:58:07 +0100
Message-Id: <1414936689-2707-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, I recently learned that there is wait_for_completion_io_* because one I2C
driver uses it instead of wait_for_completion_*. I want consistency, so
technically the io-versions seem to be the correct ones to me, because, well,
we are waiting for IO.

However, researching the net, users currently interpret iowait entirely as
blkio wait. Furthermore, io_schedule() calls delayacct_blkio_{start|end}() which
worked fine for my tests with I2C but might show that iowait was really meant as
blkiowait? So, should other subsystems use it?

To make it more confusing, some people (like Peter Zijlstra [1]) seem to like
iowait gone, so maybe it is all not worth it?

I'd be grateful for a rule-of-thumb here. And because people like to discuss
code, I created patches to convert I2C and SPI to be accounted as iowait ;)

Thanks,

   Wolfram


[1] http://www.spinics.net/lists/kernel/msg1778892.html

Wolfram Sang (2):
  i2c: account completions as iowait
  spi: account completions as iowait

 drivers/i2c/busses/i2c-axxia.c           |  4 ++--
 drivers/i2c/busses/i2c-bcm-kona.c        |  8 ++++----
 drivers/i2c/busses/i2c-bcm2835.c         |  2 +-
 drivers/i2c/busses/i2c-bfin-twi.c        |  4 ++--
 drivers/i2c/busses/i2c-cadence.c         |  2 +-
 drivers/i2c/busses/i2c-davinci.c         |  2 +-
 drivers/i2c/busses/i2c-designware-core.c |  2 +-
 drivers/i2c/busses/i2c-efm32.c           |  2 +-
 drivers/i2c/busses/i2c-exynos5.c         |  2 +-
 drivers/i2c/busses/i2c-highlander.c      |  2 +-
 drivers/i2c/busses/i2c-hix5hd2.c         |  2 +-
 drivers/i2c/busses/i2c-ismt.c            |  2 +-
 drivers/i2c/busses/i2c-mxs.c             |  2 +-
 drivers/i2c/busses/i2c-nomadik.c         |  4 ++--
 drivers/i2c/busses/i2c-omap.c            |  2 +-
 drivers/i2c/busses/i2c-pmcmsp.c          |  2 +-
 drivers/i2c/busses/i2c-pnx.c             |  2 +-
 drivers/i2c/busses/i2c-qup.c             |  4 ++--
 drivers/i2c/busses/i2c-riic.c            |  2 +-
 drivers/i2c/busses/i2c-sh7760.c          |  2 +-
 drivers/i2c/busses/i2c-sirf.c            |  2 +-
 drivers/i2c/busses/i2c-st.c              |  2 +-
 drivers/i2c/busses/i2c-sun6i-p2wi.c      |  2 +-
 drivers/i2c/busses/i2c-tegra.c           |  2 +-
 drivers/i2c/busses/i2c-wmt.c             |  4 ++--
 drivers/spi/spi-altera.c                 |  2 +-
 drivers/spi/spi-atmel.c                  |  2 +-
 drivers/spi/spi-au1550.c                 |  4 ++--
 drivers/spi/spi-bcm2835.c                |  2 +-
 drivers/spi/spi-bcm63xx-hsspi.c          |  2 +-
 drivers/spi/spi-bcm63xx.c                |  2 +-
 drivers/spi/spi-efm32.c                  |  2 +-
 drivers/spi/spi-ep93xx.c                 |  4 ++--
 drivers/spi/spi-fsl-espi.c               |  2 +-
 drivers/spi/spi-fsl-spi.c                |  2 +-
 drivers/spi/spi-imx.c                    |  6 +++---
 drivers/spi/spi-mpc512x-psc.c            |  2 +-
 drivers/spi/spi-mpc52xx-psc.c            |  2 +-
 drivers/spi/spi-mxs.c                    |  2 +-
 drivers/spi/spi-nuc900.c                 |  2 +-
 drivers/spi/spi-oc-tiny.c                |  2 +-
 drivers/spi/spi-omap2-mcspi.c            |  4 ++--
 drivers/spi/spi-ppc4xx.c                 |  2 +-
 drivers/spi/spi-qup.c                    |  2 +-
 drivers/spi/spi-s3c24xx.c                |  2 +-
 drivers/spi/spi-s3c64xx.c                |  2 +-
 drivers/spi/spi-sh-msiof.c               |  4 ++--
 drivers/spi/spi-sirf.c                   | 10 +++++-----
 drivers/spi/spi-sun4i.c                  |  2 +-
 drivers/spi/spi-sun6i.c                  |  2 +-
 drivers/spi/spi-tegra114.c               |  2 +-
 drivers/spi/spi-tegra20-sflash.c         |  2 +-
 drivers/spi/spi-tegra20-slink.c          |  2 +-
 drivers/spi/spi-ti-qspi.c                |  4 ++--
 drivers/spi/spi-xilinx.c                 |  2 +-
 drivers/spi/spi.c                        |  4 ++--
 drivers/spi/spidev.c                     |  2 +-
 57 files changed, 77 insertions(+), 77 deletions(-)

-- 
2.1.1

