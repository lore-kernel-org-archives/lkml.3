Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaDANHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:07:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35263 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbaDANHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:07:04 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <nsekhar@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joelf@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>
Subject: [PATCH v2 07/14] arm: common: edma: API to request non default queue for a channel
Date: Tue, 1 Apr 2014 16:06:08 +0300
Message-ID: <1396357575-30585-8-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using eDMA3 via dmaengine all dma channels will use the default queue.
Since during request time we do not have means to change this it need to be done
later, before the DMA has been started.
With the added function it is possible to move the channel to a non default
queue if it is possible, otherwise (when only one EQ/TC is available for the CC)
the default queue is going to be used.
For example: For optimal system performance the audio (cyclic) DMA should
be placed to a separate queue which is different than what the rest of the
system is using.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/common/edma.c             | 27 +++++++++++++++++++++++++++
 include/linux/platform_data/edma.h |  2 ++
 2 files changed, 29 insertions(+)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index be267b2080be..eaf6dd19f082 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -712,6 +712,33 @@ int edma_alloc_channel(int channel,
 }
 EXPORT_SYMBOL(edma_alloc_channel);
 
+/**
+ * edma_request_non_default_queue - try to map the channel to non default queue
+ * @channel: dma channel returned from edma_alloc_channel()
+ *
+ * For certain type of applications like audio it is preferred to not use the
+ * default event queue/tc to avoid eDMA caused latency.
+ *
+ * This function will iterate through the event queues available for the CC and
+ * picks the first EQ/TC which is not set as the default for the CC
+ */
+void edma_request_non_default_queue(int channel)
+{
+	unsigned ctlr = EDMA_CTLR(channel);
+	enum dma_event_q eventq_no = EVENTQ_DEFAULT;
+	int i;
+
+	for (i = 0; i < edma_cc[ctlr]->num_tc; i++) {
+		if (i != edma_cc[ctlr]->default_queue) {
+			eventq_no = i;
+			break;
+		}
+	}
+
+	channel = EDMA_CHAN_SLOT(channel);
+	map_dmach_queue(ctlr, channel, eventq_no);
+}
+EXPORT_SYMBOL(edma_request_non_default_queue);
 
 /**
  * edma_free_channel - deallocate DMA channel
diff --git a/include/linux/platform_data/edma.h b/include/linux/platform_data/edma.h
index 923f8a3e4ce0..5d0a1b98f205 100644
--- a/include/linux/platform_data/edma.h
+++ b/include/linux/platform_data/edma.h
@@ -117,6 +117,8 @@ int edma_alloc_channel(int channel,
 	void *data, enum dma_event_q);
 void edma_free_channel(unsigned channel);
 
+void edma_request_non_default_queue(int channel);
+
 /* alloc/free parameter RAM slots */
 int edma_alloc_slot(unsigned ctlr, int slot);
 void edma_free_slot(unsigned slot);
-- 
1.9.1

