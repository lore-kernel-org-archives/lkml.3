Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602Ab3GWQoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:44:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34532 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932705Ab3GWQoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:44:13 -0400
From: Joel Fernandes <joelf@ti.com>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
CC: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>,
        Balaji TK <balajitk@ti.com>, Matt Porter <matt@ohporter.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH] dma: edma: add device_slave_caps() support
Date: Tue, 23 Jul 2013 11:43:24 -0500
Message-ID: <1374597804-3961-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement device_slave_caps(). EDMA has a limited number of slots.
Slave drivers such as omap_hsmmc will query the driver to make
sure they don't pass in more than these many scatter segments.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
Vinod, or Dan- If this patch looks ok, can you please merge in for
-rc cycle? This patch is required to fix MMC support on AM33xx. This
patch is blocking 3 other patches which fix various MMC things. Thanks!

Notes:
(1) this approach is temporary and only for -rc cycle to fix MMC on
AM335x. It will be replace by the RFC series in future kernels:
http://www.spinics.net/lists/arm-kernel/msg260094.html

(2) Patch depends Vinod's patch at:
http://permalink.gmane.org/gmane.linux.kernel/1525112

 drivers/dma/edma.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 7222cbe..81d5429 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -517,6 +517,14 @@ static void edma_issue_pending(struct dma_chan *chan)
 	spin_unlock_irqrestore(&echan->vchan.lock, flags);
 }
 
+static inline int edma_slave_caps(struct dma_chan *chan,
+	struct dma_slave_caps *caps)
+{
+	caps->max_sg_nr = MAX_NR_SG;
+
+	return 0;
+}
+
 static size_t edma_desc_size(struct edma_desc *edesc)
 {
 	int i;
@@ -594,6 +602,7 @@ static void edma_dma_init(struct edma_cc *ecc, struct dma_device *dma,
 	dma->device_issue_pending = edma_issue_pending;
 	dma->device_tx_status = edma_tx_status;
 	dma->device_control = edma_control;
+	dma->device_slave_caps = edma_slave_caps;
 	dma->dev = dev;
 
 	INIT_LIST_HEAD(&dma->channels);
-- 
1.7.9.5

