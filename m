Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbaKYM0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:26:10 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:61198 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbaKYM0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:26:07 -0500
X-AuditID: cbfee61a-f79c06d000004e71-dc-5474755d61a0
From: Robert Baldyga <r.baldyga@samsung.com>
To: vinod.koul@intel.com
Cc: dan.j.williams@intel.com, ars@metafoo.de, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        l.czerwinski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 2/2] dma: pl330: add DMA_PAUSE feature
Date: Tue, 25 Nov 2014 13:25:46 +0100
Message-id: <1416918346-2442-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1416918346-2442-1-git-send-email-r.baldyga@samsung.com>
References: <1416918346-2442-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t9jQd3Y0pIQg56lRhYXDnQyWkyfeoHR
	YvXUv6wWv6ZNYrO4vGsOm8XaI3fZLR4c3slu8bJvP4sDh8fiPS+ZPJa8OcTq0bdlFaPH501y
	ASxRXDYpqTmZZalF+nYJXBlzdxxjLbjNWzG/+S9jA+My7i5GTg4JAROJS9OPskLYYhIX7q1n
	A7GFBKYzSkzcWN3FyAVktzNJ7Pp1iBEkwSagI7Hl+wQwW0RAQmL7sz52kCJmgaOMEtPnXgDr
	FhYwk/j8YA8ziM0ioCqx9O5JsDivgIvExq2zoLbJSZw8NhnM5hRwlehd9JARYrOLxLQjR5km
	MPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcVs+kdjCubLA4xCjAwajEw9txtjhE
	iDWxrLgy9xCjBAezkgjvk+SSECHelMTKqtSi/Pii0pzU4kOM0hwsSuK8N27mhggJpCeWpGan
	phakFsFkmTg4pRoYZ2V3xW3kPeEixVvwV2gpy4NaP7fEsgeTLH5yyiRMEX8tx1NepfPMzfrd
	744c/R384pNFNe4dfhcrdC/f2eO57gtJs9TiNdxBlb5Jq3WMti0svK7x/7F06fcZtbKdO9/y
	7L9jeezm9VOqC/2zhT4kh30RPKhz4WrKxOwrK/pdeIS2l9gLOn9WYinOSDTUYi4qTgQAruAb
	MCcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA_PAUSE command is used for halting DMA transfer on chosen channel.
It can be useful when we want to safely read residue before terminating
all requests on channel. Otherwise there can be situation when some data
is transferred before channel termination but after reading residue,
which obviously results with data loss. To avoid this situation we can
pause channel, read residue and then terminate all requests.
This scenario is common, for example, in serial port drivers.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/dma/pl330.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index c32806d..9c64421 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2115,6 +2115,26 @@ static int pl330_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd, unsigned
 		list_splice_tail_init(&pch->completed_list, &pl330->desc_pool);
 		spin_unlock_irqrestore(&pch->lock, flags);
 		break;
+	case DMA_PAUSE:
+		/*
+		 * We don't support DMA_RESUME command because of hardware
+		 * limitations, so after pausing the channel we cannot restore
+		 * it to active state. We have to terminate channel and setup
+		 * DMA transfer again. This pause feature was implemented to
+		 * allow safely read residue before channel termination.
+		 */
+		spin_lock_irqsave(&pch->lock, flags);
+
+		spin_lock(&pl330->lock);
+		_stop(pch->thread);
+		spin_unlock(&pl330->lock);
+
+		pch->thread->req[0].desc = NULL;
+		pch->thread->req[1].desc = NULL;
+		pch->thread->req_running = -1;
+
+		spin_unlock_irqrestore(&pch->lock, flags);
+		break;
 	case DMA_SLAVE_CONFIG:
 		slave_config = (struct dma_slave_config *)arg;
 
-- 
1.9.1

