Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbaHTLro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:47:44 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59053 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752639AbaHTLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Andre van Herk <andre.van.herk@prodrive-technologies.com>,
        Stef van Os <stef.van.os@prodrive-technologies.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 006/104] rapidio/tsi721_dma: fix failure to obtain transaction descriptor
Date: Wed, 20 Aug 2014 13:42:29 +0200
Message-Id: <55415f0d061cde055304bbd70332830a45a3b222.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Bounine <alexandre.bounine@idt.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.0.4

