Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3HEQUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:20:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39210 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172Ab3HEQPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:15:52 -0400
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
Subject: [PATCH v3 00/12] edma: Add support for SG lists of any length
Date: Mon, 5 Aug 2013 11:14:45 -0500
Message-ID: <1375719297-12871-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a more improved approach for DMA support of SG lists of any length
in the EDMA DMA Engine driver.

In the previous approach [1] we depended on error interrupts to detect
missed events and manually retrigger them, however as discussed in [2],
there are concerns this can be trouble some for high speed peripherals
which may need a more real-time response from the DMA controller.

In this approach, we divide the total no of MAX slots per channel, into
2 linked sets which are cyclically linked to each other (the cyclic
link between the 2 sets make sure that the DMA is continuous till the whole
SG list has exhausted). We then enable completion interrupts on both linked
sets which results in recyling/preparing respective linked set with the
next set of SG entries. The interrupt handler executes in parallel while
the EDMA controller DMA's the next list. This results in no interruption.

Special handling is done for first linked set (as we set up both linked
sets initially before starting with the DMA), and last one where the cyclic
link has to be broken and a link to the Dummy slot has to be created.
Also we keep track of whether all pending DMA operations have completed
before we can mark it as complete.

[1] https://lkml.org/lkml/2013/7/29/312
[2] https://lkml.org/lkml/2013/7/30/54

Joel Fernandes (12):
  dma: edma: Setup parameters to DMA MAX_NR_SG at a time
  ARM: edma: Don't clear EMR of channel in edma_stop
  dma: edma: remove limits on number of slots
  dma: edma: Write out and handle MAX_NR_SG at a given time
  ARM: edma: Add function to enable interrupt for a PaRAM slot
  ARM: edma: Add pr_debug in edma_link
  dma: edma: Add function to dump a PaRAM set from PaRAM
  dma: edma: Add one more required slot to MAX slots
  dma: edma: Implement multiple linked sets for continuity
  dma: edma: Check if MAX_NR_SG is even in prep function
  dma: edma: Keep tracking of Pending interrupts (pending_acks)
  dma: edma: Return if nothing left todo in edma_execute

 arch/arm/common/edma.c             |   18 ++-
 drivers/dma/edma.c                 |  279 +++++++++++++++++++++++++++++-------
 include/linux/platform_data/edma.h |    1 +
 3 files changed, 243 insertions(+), 55 deletions(-)

-- 
1.7.9.5

