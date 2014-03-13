Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaCMJT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:19:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57391 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbaCMJTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:19:23 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <dmaengine@vger.kernel.org>
CC: <davinci-linux-open-source@linux.davincidsp.com>, <joelf@ti.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Tony Lindgren <tony@atomide.com>, <nsekhar@ti.com>,
        Jyri Sarha <jsarha@ti.com>, <mporter@linaro.org>,
        <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Subject: [PATCH 02/18] dma: edma: Add support for DMA_PAUSE/RESUME operation
Date: Thu, 13 Mar 2014 11:18:24 +0200
Message-ID: <1394702320-21743-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
References: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pause/Resume can be used by the audio stack when the stream is paused/resumed
The edma platform code has support for this and the legacy audio stack used
this.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/dma/edma.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index cd04eb7b182e..b54cd2dedde0 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -240,6 +240,26 @@ static int edma_slave_config(struct edma_chan *echan,
 	return 0;
 }
 
+static int edma_dma_pause(struct edma_chan *echan)
+{
+	/* Pause/Resume only allowed with cyclic mode */
+	if (!echan->edesc->cyclic)
+		return -EINVAL;
+
+	edma_pause(echan->ch_num);
+	return 0;
+}
+
+static int edma_dma_resume(struct edma_chan *echan)
+{
+	/* Pause/Resume only allowed with cyclic mode */
+	if (!echan->edesc->cyclic)
+		return -EINVAL;
+
+	edma_resume(echan->ch_num);
+	return 0;
+}
+
 static int edma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 			unsigned long arg)
 {
@@ -255,6 +275,14 @@ static int edma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		config = (struct dma_slave_config *)arg;
 		ret = edma_slave_config(echan, config);
 		break;
+	case DMA_PAUSE:
+		ret = edma_dma_pause(echan);
+		break;
+
+	case DMA_RESUME:
+		ret = edma_dma_resume(echan);
+		break;
+
 	default:
 		ret = -ENOSYS;
 	}
-- 
1.9.0

