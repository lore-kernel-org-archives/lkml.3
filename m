Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab3G2Nau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 09:30:50 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33935 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab3G2Nar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 09:30:47 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Mark Brown <broonie@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Balaji TK <balajitk@ti.com>,
        Gururaja Hebbar <gururaja.hebbar@ti.com>, Chris Ball <cjb@laptop.org>,
        Jason Kridner <jkridner@beagleboard.org>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: [PATCH 0/9] dma: edma: Support scatter-lists of any length
Date: Mon, 29 Jul 2013 08:29:46 -0500
Message-ID: <1375104595-16018-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
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
performance improvement. But using 1 slot is even managed by just DMA'ing 1 SG
entry at a time.

[1] https://lkml.org/lkml/2013/7/18/432
[2] http://marc.info/?l=linux-omap&m=137416733628831&w=2

Joel Fernandes (9):
  dma: edma: Setup parameters to DMA MAX_NR_SG at a time
  dma: edma: Write out and handle MAX_NR_SG at a given time
  ARM: edma: Add function to manually trigger an EDMA channel
  dma: edma: Find missed events and issue them
  dma: edma: Leave linked to Null slot instead of DUMMY slot
  dma: edma: Detect null slot errors and handle them correctly
  ARM: edma: Don't clear EMR of channel in edma_stop
  dma: edma: Link to dummy slot only for last SG list split
  dma: edma: remove limits on number of slots

 arch/arm/common/edma.c             |   22 ++++-
 drivers/dma/edma.c                 |  157 +++++++++++++++++++++++++++---------
 include/linux/platform_data/edma.h |    2 +
 3 files changed, 142 insertions(+), 39 deletions(-)

-- 
1.7.9.5

