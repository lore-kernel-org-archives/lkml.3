Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300AbaEMJae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:30:34 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33217 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760155AbaEMJ3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:29:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Joel Fernandes <joelf@ti.com>, Vinod Koul <vinod.koul@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 175/182] dma: edma: fix incorrect SG list handling
Date: Tue, 13 May 2014 11:28:47 +0200
Message-Id: <b1f0ee0b88a86d2bd6ca659763307465d40b21af.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sekhar Nori <nsekhar@ti.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5fc68a6cad658e45dca3e0a6607df3a8e5df4ef9 upstream.

The code to handle any length SG lists calls edma_resume()
even before edma_start() is called. This is incorrect
because edma_resume() enables edma events on the channel
after which CPU (in edma_start) cannot clear posted
events by writing to ECR (per the EDMA user's guide).

Because of this EDMA transfers fail to start if due
to some reason there is a pending EDMA event registered
even before EDMA transfers are started. This can happen if
an EDMA event is a byproduct of device initialization.

Fix this by calling edma_resume() only if it is not the
first batch of MAX_NR_SG elements.

Without this patch, MMC/SD fails to function on DA850 EVM
with DMA. The behaviour is triggered by specific IP and
this can explain why the issue was not reported before
(example with MMC/SD on AM335x).

Tested on DA850 EVM and AM335x EVM-SK using MMC/SD card.

Cc: Joel Fernandes <joelf@ti.com>
Acked-by: Joel Fernandes <joelf@ti.com>
Tested-by: Jon Ringle <jringle@gridpoint.com>
Tested-by: Alexander Holler <holler@ahsoftware.de>
Reported-by: Jon Ringle <jringle@gridpoint.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/dma/edma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 10b577fcf48d..0ad40e4a7ae0 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -170,11 +170,13 @@ static void edma_execute(struct edma_chan *echan)
 	if (edesc->processed == edesc->pset_nr)
 		edma_link(echan->slot[nslots-1], echan->ecc->dummy_slot);
 
-	edma_resume(echan->ch_num);
-
 	if (edesc->processed <= MAX_NR_SG) {
 		dev_dbg(dev, "first transfer starting %d\n", echan->ch_num);
 		edma_start(echan->ch_num);
+	} else {
+		dev_dbg(dev, "chan: %d: completed %d elements, resuming\n",
+			echan->ch_num, edesc->processed);
+		edma_resume(echan->ch_num);
 	}
 
 	/*
-- 
1.9.3

