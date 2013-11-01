Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab3KALgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:36:24 -0400
Received: from mail-db8lp0186.outbound.messaging.microsoft.com ([213.199.154.186]:34846
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751833Ab3KALgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:36:22 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kz70kzz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
From: Nicolin Chen <b42378@freescale.com>
To: <akpm@linux-foundation.org>, <joe@perches.com>, <nsekhar@ti.com>,
        <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <dan.j.williams@intel.com>, <vinod.koul@intel.com>,
        <m.chehab@samsung.com>, <hjk@hansjkoch.de>,
        <gregkh@linuxfoundation.org>, <perex@perex.cz>, <tiwai@suse.de>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <rmk+kernel@arm.linux.org.uk>, <eric.y.miao@gmail.com>,
        <haojian.zhuang@gmail.com>
CC: <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <dmaengine@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <alsa-devel@alsa-project.org>
Subject: [PATCH 0/8] Add and implement gen_pool_dma_alloc()
Date: Fri, 1 Nov 2013 19:35:58 +0800
Message-ID: <cover.1383303752.git.b42378@freescale.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, we don't have a specific gen_pool_alloc() for DMA usage;
Instead, we need to use gen_pool_virt_to_phys() to convert the addr
returned from gen_pool_alloc(). So each implementation of this has
duplicated code. Thus add new helper function -- gen_pool_dma_alloc().

After gen_pool_dma_alloc() is introduced, we can replace the original
combination of gen_pool_alloc()+gen_pool_virt_to_phys() with this new
helper function. Thus this patch implement the helper function to all
the current drivers which use gen_pool_virt_to_phys().

!!-------------------important------------------!!

The later 7 patches need all related driver owner to test. We can
here define a simple rule:
1, If one driver owner or maintainer doesn't like the mofication
   to his/her driver, just let me know. I would drop that patch.
2, If there's a bug and issue found after patch-testing, please
   reply the mail so that I can fix and refine the patch.
3, If one driver owner or maintainer is too busy and doesn't have
   bandwidth to test the patch, I would drop that patch from this
   series. We can reimplement it till there's someone test it.

!!-------------------current progress-----------!!

  lib/genalloc: [Okay]
  ARM: davinci: [Untested]
  dma: mmp_tdma: [Untested]
  [media] coda: [Untested]
  uio: uio_pruss: [Untested]
  ALSA: memalloc: [Tested] by Nicolin Chen with i.MX6Q SabreSD
  ASoC: davinci: [Untested]
  ASoC: pxa: use [Untested]


Nicolin Chen (8):
  lib/genalloc: add a helper function for DMA buffer allocation
  ARM: davinci: use gen_pool_dma_alloc() to sram.c
  dma: mmp_tdma: use gen_pool_dma_alloc() to allocate descriptor
  [media] coda: use gen_pool_dma_alloc() to allocate iram buffer
  uio: uio_pruss: use gen_pool_dma_alloc() to allocate sram memory
  ALSA: memalloc: use gen_pool_dma_alloc() to allocate iram buffer
  ASoC: davinci: use gen_pool_dma_alloc() in davinci-pcm.c
  ASoC: pxa: use gen_pool_dma_alloc() to allocate dma buffer

 arch/arm/mach-davinci/sram.c    |  9 +--------
 drivers/dma/mmp_tdma.c          |  7 +------
 drivers/media/platform/coda.c   |  5 ++---
 drivers/uio/uio_pruss.c         |  6 ++----
 include/linux/genalloc.h        |  2 ++
 lib/genalloc.c                  | 28 ++++++++++++++++++++++++++++
 sound/core/memalloc.c           |  6 +-----
 sound/soc/davinci/davinci-pcm.c |  3 +--
 sound/soc/pxa/mmp-pcm.c         |  3 +--
 9 files changed, 39 insertions(+), 30 deletions(-)

-- 
1.8.4


