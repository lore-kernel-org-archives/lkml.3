Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab3H2XGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:06:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51663 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141Ab3H2XGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:06:34 -0400
From: Joel Fernandes <joelf@ti.com>
To: Sekhar Nori <nsekhar@ti.com>, Matt Porter <matt@ohporter.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sricharan R <r.sricharan@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Franklin Cooper <fcooper@ti.com>
Subject: [PATCH v4 0/6] dma: edma: Support scatter-lists of any length
Date: Thu, 29 Aug 2013 18:05:39 -0500
Message-ID: <1377817545-18015-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series adds support to EDMA driver to enable DMA of
scatter-gather lists of arbitrary length, but still make use of only
a certain MAX number of slots at a time for a given channel. Thus
free-ing up the rest of the slots to other slaves/channels.  With this
there is no need for slave drivers to query the EDMA driver about how
much is the MAX it can send at a time as done in [1]. Drivers can send
SG lists of any number of entries to DMA. Reference discussion at [2].

With this, all the patches for MMC and EDMA related to "sg limits" can be
dropped.

Tested omap-aes and omap_hsmmc drivers with different MAX number of slots,
even just 1. In the case where it is 1, only 1-slot is used to DMA an
entire scatter list of arbitrary length.
Since this series touches EDMA private API code also shared with davinci-pcm,
playback of a 16-bit 44.1KHz audio file with davinci-pcm has been tested.

Sample test run with 1 vs 16 (MAX number of slots/SG) in omap-aes driver:
MAX slots = 1:
 (128 bit key, 8192 byte blocks): 1266 operations in 1 seconds (10371072 bytes)
MAX slots = 16:
 (128 bit key, 8192 byte blocks): 1601 operations in 1 seconds (13115392 bytes)

Note: For the above test, 8K buffer is mapped into SG list of size 2 so
only 2 slots are required. So beyond size 2, there will not be any noticeable
performance improvement. But above experiment just shows as proof of concept
that even using 1 slot is managed by just DMA'ing 1 SG entry at a time.

Patch series history:
v1: The initial patch series
v2: Several style related cleanups.
v3: Rewrote major portions of the series to avoid usage of error interrupts.
v4: Go back to v1: After performing tests, it is determined that the v1
series is a good enough approach and that v3 triggers problems in certain cases.
Tests have shown that there is not any noticeable performance difference between
using vs not using error interrupts. v4 also squashes some patches in v1.
At this point, we are freezing the overall architecture of the patch series to v4.

[1] https://lkml.org/lkml/2013/7/18/432
[2] http://marc.info/?l=linux-omap&m=137416733628831&w=2

Joel Fernandes (6):
  dma: edma: Setup parameters to DMA MAX_NR_SG at a time
  dma: edma: Write out and handle MAX_NR_SG at a given time
  ARM: edma: Add function to manually trigger an EDMA channel
  dma: edma: Find missed events and issue them
  dma: edma: Leave linked to Null slot instead of DUMMY slot
  dma: edma: Remove limits on number of slots

 arch/arm/common/edma.c             |  17 ++++
 drivers/dma/edma.c                 | 164 ++++++++++++++++++++++++++++---------
 include/linux/platform_data/edma.h |   2 +
 3 files changed, 144 insertions(+), 39 deletions(-)

-- 
1.8.1.2

