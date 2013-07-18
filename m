Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab3GRQsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:48:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50540 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759120Ab3GRQsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:48:08 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Balaji TK <balajitk@ti.com>,
        Gururaja Hebbar <gururaja.hebbar@ti.com>, Chris Ball <cjb@laptop.org>
CC: Jason Kridner <jkridner@beagleboard.org>,
        Mark Jackson <mpfj-list@newflow.co.uk>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH 3/3] dma: edma: add device_slave_sg_limits() support
Date: Thu, 18 Jul 2013 11:46:41 -0500
Message-ID: <1374166001-31340-4-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374166001-31340-1-git-send-email-joelf@ti.com>
References: <1374166001-31340-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Porter <mporter@ti.com>

Implement device_slave_sg_limits().

EDMA has a finite set of PaRAM slots available for linking a
multi-segment SG transfer. In order to prevent any one channel
from consuming all PaRAM slots to fulfill a large SG transfer,
the driver reports a static per-channel max number of SG segments
it will handle.

The maximum size of an SG segment is limited by the addr_width
and maxburst of a given transfer request. These values are
provided by the client driver and used to calculate and return
the maximum segment length.

[Joel Fernandes <joelf@ti.com>: Changes for filling sg_limits
by DMAEngine implementation and allocating in client, channel
parameter is unused in this implementation as all channels
have the same capability]
Signed-off-by: Matt Porter <mporter@ti.com>
Signed-off-by: Joel Fernandes <joelf@ti.com>
Cc: Mark Jackson <mpfj-list@newflow.co.uk>
---
 drivers/dma/edma.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 5f3e532..964de26 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -462,6 +462,19 @@ static void edma_issue_pending(struct dma_chan *chan)
 	spin_unlock_irqrestore(&echan->vchan.lock, flags);
 }
 
+static inline int edma_get_slave_sg_limits(struct dma_chan *chan,
+		       enum dma_slave_buswidth addr_width,
+		       u32 maxburst,
+		       struct dma_slave_sg_limits *sg_limits)
+{
+	if (!sg_limits)
+		return -EINVAL;
+	sg_limits->max_seg_nr = MAX_NR_SG;
+	sg_limits->max_seg_len =
+		(SZ_64K - 1) * addr_width * maxburst;
+	return 0;
+}
+
 static size_t edma_desc_size(struct edma_desc *edesc)
 {
 	int i;
@@ -537,6 +550,7 @@ static void edma_dma_init(struct edma_cc *ecc, struct dma_device *dma,
 	dma->device_alloc_chan_resources = edma_alloc_chan_resources;
 	dma->device_free_chan_resources = edma_free_chan_resources;
 	dma->device_issue_pending = edma_issue_pending;
+	dma->device_slave_sg_limits = edma_get_slave_sg_limits;
 	dma->device_tx_status = edma_tx_status;
 	dma->device_control = edma_control;
 	dma->dev = dev;
-- 
1.7.9.5

