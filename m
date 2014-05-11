Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964824AbaEKTh5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:37:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933815AbaEKTZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:25:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joel Fernandes <joelf@ti.com>, Jon Ringle <jringle@gridpoint.com>,
        Alexander Holler <holler@ahsoftware.de>, Sekhar Nori <nsekhar@ti.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 3.14 69/83] dma: edma: fix incorrect SG list handling
Date: Sun, 11 May 2014 21:20:10 +0200
Message-Id: <20140511191915.911605573@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sekhar Nori <nsekhar@ti.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/edma.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -182,11 +182,13 @@ static void edma_execute(struct edma_cha
 				  echan->ecc->dummy_slot);
 	}
 
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


