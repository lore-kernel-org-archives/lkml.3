Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbaGHKr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 06:47:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58061 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243AbaGHKrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 06:47:24 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>, <vinod.koul@intel.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <dmaengine@vger.kernel.org>
Subject: [PATCH 2/3] ARM: edma: Add edma_assign_channel_eventq() to move channel to a give queue
Date: Tue, 8 Jul 2014 13:46:37 +0300
Message-ID: <1404816398-12338-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404816398-12338-1-git-send-email-peter.ujfalusi@ti.com>
References: <1404816398-12338-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases it is desired to move a channel to a specific event queue.
Such a use case is audio, where it is preferred that it is served with
highest priority compared to other DMA clients.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/common/edma.c             | 28 ++++++++++++++++++++++++++++
 include/linux/platform_data/edma.h |  2 ++
 2 files changed, 30 insertions(+)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index f834aae7720f..88099175fc56 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -1414,6 +1414,34 @@ void edma_clear_event(unsigned channel)
 }
 EXPORT_SYMBOL(edma_clear_event);
 
+/*
+ * edma_assign_channel_eventq - move given channel to desired eventq
+ * Arguments:
+ *	channel - channel number
+ *	eventq_no - queue to move the channel
+ *
+ * Can be used to move a channel to a selected event queue.
+ */
+void edma_assign_channel_eventq(unsigned channel, enum dma_event_q eventq_no)
+{
+	unsigned ctlr;
+
+	ctlr = EDMA_CTLR(channel);
+	channel = EDMA_CHAN_SLOT(channel);
+
+	if (channel >= edma_cc[ctlr]->num_channels)
+		return;
+
+	/* default to low priority queue */
+	if (eventq_no == EVENTQ_DEFAULT)
+		eventq_no = edma_cc[ctlr]->default_queue;
+	if (eventq_no >= edma_cc[ctlr]->num_tc)
+		return;
+
+	map_dmach_queue(ctlr, channel, eventq_no);
+}
+EXPORT_SYMBOL(edma_assign_channel_eventq);
+
 static int edma_setup_from_hw(struct device *dev, struct edma_soc_info *pdata,
 			      struct edma *edma_cc)
 {
diff --git a/include/linux/platform_data/edma.h b/include/linux/platform_data/edma.h
index eb8d5627d080..bdb2710e2aab 100644
--- a/include/linux/platform_data/edma.h
+++ b/include/linux/platform_data/edma.h
@@ -150,6 +150,8 @@ void edma_clear_event(unsigned channel);
 void edma_pause(unsigned channel);
 void edma_resume(unsigned channel);
 
+void edma_assign_channel_eventq(unsigned channel, enum dma_event_q eventq_no);
+
 struct edma_rsv_info {
 
 	const s16	(*rsv_chans)[2];
-- 
2.0.0

