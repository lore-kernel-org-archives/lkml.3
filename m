Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbaIPTqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:46:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32846 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147AbaIPTq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:46:27 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH v3 2/2] dmaengine: omap-dma: Restore the CLINK_CTRL in resume path
Date: Tue, 16 Sep 2014 22:45:57 +0300
Message-ID: <1410896757-3848-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410896757-3848-1-git-send-email-peter.ujfalusi@ti.com>
References: <1410896757-3848-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the audio stream is paused or suspended we stop the sDMA and when it
is unpaused/resumed we start the channel without reconfiguring it.
The omap_dma_stop() clears the link configuration when we pause the dma, but
it is not setting it back on start. This will result only one audio buffer
to be played back and the DMA will stop, since the linking is disabled.
We need to restore the CLINK_CTRL register in case of resume.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/dma/omap-dma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
index c01ea505ee7c..bbea8243f9e8 100644
--- a/drivers/dma/omap-dma.c
+++ b/drivers/dma/omap-dma.c
@@ -1019,6 +1019,9 @@ static int omap_dma_resume(struct omap_chan *c)
 	if (c->paused) {
 		mb();
 
+		/* Restore channel link register */
+		omap_dma_chan_write(c, CLNK_CTRL, c->desc->clnk_ctrl);
+
 		omap_dma_start(c, c->desc);
 		c->paused = false;
 	}
-- 
2.1.0

