Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3IRTSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 15:18:24 -0400
Received: from gloria.sntech.de ([95.129.55.99]:58026 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab3IRTSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 15:18:23 -0400
To: kgene.kim@samsung.com
Subject: [PATCH v5 0/4] ARM: S3C24XX: add dmaengine based dma-driver
Cc: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        linus.walleij@linaro.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
Date: Wed, 18 Sep 2013 21:18:27 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201309182118.28391.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series tries to provide a basic dmaengine driver for the s3c24xx
SoCs to subsequently retire the old one with custom API.

Since v4 an unnecessary second call to retrieve the dma cookie status was
removed.

Since v3 more smaller fixes were added, and memcpy operations now have a very
simple mechanism to try to use higher transfer widths.

Since v2 only some small fixes to the dma driver itself were added.

Since v1 three big changes happened (appart from fixing received comments):

For one the limitation of sg-lists to 1 element is gone.Secondly the
specifics of the virtual channels (target bus, handshake, etc) are not
encoded with channel ids but in the platformdata - making a later dt
binding easier, as these informations can there be gathered by the xlate
function. And lastly I also added a preliminary mechanism to handle the
specific needs for the earlier variants of the driver.

While s3c2443 and later can use any channel for any peripheral with just
marking the target-peripheral-id in a register, earlier SoCs can only use
specific channels and the target-ids also vary depending on the channel.

Therefore on newer SoCs the chansel element only needs to contain the
requested target-id, while on the older variants use it to encode both
the valid channels and the channel-specific peripheral-id.

On affected SoCs the target-id is always 3 bit wide, so we use these and
an additional 4th bit to hold the valid state. As the older SoCs all have
4 dma channels this can live happily in an u16 element.

The s3c24xx series will most likely not see any new offspring, but even
if it happens any new model will probably use the newer more flexible
variant of the dma controller, so this should not restrict anything
in the future.

Example:
SDI is valid on channels 0, 2 and 3 - with varying hw request sources.
For it the chansel field would look like

 ((BIT(3) | 1) << 3 * 4) | // channel 3, with request source 1
 ((BIT(3) | 2) << 2 * 4) | // channel 2, with request source 2
 ((BIT(3) | 2) << 0 * 4)   // channel 0, with request source 2

Heiko Stuebner (4):
  ARM: S3C24XX: number the dma clocks
  dmaengine: add driver for Samsung s3c24xx SoCs
  ARM: S3C24XX: add platform-devices for new dma driver for s3c2412 and s3c2443
  ARM: SAMSUNG: set s3c24xx_dma_filter for s3c64xx-spi0 device

 arch/arm/mach-s3c24xx/clock-s3c2412.c     |    8 +-
 arch/arm/mach-s3c24xx/common-s3c2443.c    |   12 +-
 arch/arm/mach-s3c24xx/common.c            |  106 +++
 arch/arm/mach-s3c24xx/common.h            |    3 +
 arch/arm/mach-s3c24xx/mach-jive.c         |    1 +
 arch/arm/mach-s3c24xx/mach-smdk2413.c     |    1 +
 arch/arm/mach-s3c24xx/mach-smdk2416.c     |    1 +
 arch/arm/mach-s3c24xx/mach-smdk2443.c     |    1 +
 arch/arm/mach-s3c24xx/mach-vstms.c        |    1 +
 arch/arm/plat-samsung/devs.c              |    5 +-
 drivers/dma/Kconfig                       |   12 +
 drivers/dma/Makefile                      |    1 +
 drivers/dma/s3c24xx-dma.c                 | 1340 +++++++++++++++++++++++++++++
 include/linux/platform_data/dma-s3c24xx.h |   43 +
 14 files changed, 1524 insertions(+), 11 deletions(-)
 create mode 100644 drivers/dma/s3c24xx-dma.c
 create mode 100644 include/linux/platform_data/dma-s3c24xx.h

-- 
1.7.10.4

