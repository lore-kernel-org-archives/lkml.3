Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbaDNLmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:42:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57734 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbaDNLmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:42:46 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <nsekhar@ti.com>,
        <joelf@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: [PATCH v3 04/10] dmaengine: edma: Add support for DMA_PAUSE/RESUME operation
Date: Mon, 14 Apr 2014 14:41:59 +0300
Message-ID: <1397475725-5036-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397475725-5036-1-git-send-email-peter.ujfalusi@ti.com>
References: <1397475725-5036-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pause/Resume can be used by the audio stack when the stream is paused/resumed
The edma platform code has support for this and the legacy audio stack used
this.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 2742867fd1e6..7891378a03f0 100644
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
1.9.2

