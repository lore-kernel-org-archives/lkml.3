Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbaHRJrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:47:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42950 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbaHRJfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:35:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Andre van Herk <andre.van.herk@prodrive-technologies.com>,
        Stef van Os <stef.van.os@prodrive-technologies.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 090/137] rapidio/tsi721_dma: fix failure to obtain transaction descriptor
Date: Mon, 18 Aug 2014 10:32:31 +0100
Message-Id: <1408354398-10226-91-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Bounine <alexandre.bounine@idt.com>

commit 0193ed8225e1a79ed64632106ec3cc81798cb13c upstream.

This is a bug fix for the situation when function tsi721_desc_get() fails
to obtain a free transaction descriptor.

The bug usually results in a memory access crash dump when data transfer
scatter-gather list has more entries than size of hardware buffer
descriptors ring.  This fix ensures that error is properly returned to a
caller instead of an invalid entry.

This patch is applicable to kernel versions starting from v3.5.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Stef van Os <stef.van.os@prodrive-technologies.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/rapidio/devices/tsi721_dma.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/rapidio/devices/tsi721_dma.c b/drivers/rapidio/devices/tsi721_dma.c
index 91245f5dbe81..47257b6eea84 100644
--- a/drivers/rapidio/devices/tsi721_dma.c
+++ b/drivers/rapidio/devices/tsi721_dma.c
@@ -287,6 +287,12 @@ struct tsi721_tx_desc *tsi721_desc_get(struct tsi721_bdma_chan *bdma_chan)
 			"desc %p not ACKed\n", tx_desc);
 	}
 
+	if (ret == NULL) {
+		dev_dbg(bdma_chan->dchan.device->dev,
+			"%s: unable to obtain tx descriptor\n", __func__);
+		goto err_out;
+	}
+
 	i = bdma_chan->wr_count_next % bdma_chan->bd_num;
 	if (i == bdma_chan->bd_num - 1) {
 		i = 0;
@@ -297,7 +303,7 @@ struct tsi721_tx_desc *tsi721_desc_get(struct tsi721_bdma_chan *bdma_chan)
 	tx_desc->txd.phys = bdma_chan->bd_phys +
 				i * sizeof(struct tsi721_dma_desc);
 	tx_desc->hw_desc = &((struct tsi721_dma_desc *)bdma_chan->bd_base)[i];
-
+err_out:
 	spin_unlock_bh(&bdma_chan->lock);
 
 	return ret;
-- 
1.9.1

