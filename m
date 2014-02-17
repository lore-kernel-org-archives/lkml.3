Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaBQONW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 09:13:22 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35006 "EHLO
	alan.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751086AbaBQONV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 09:13:21 -0500
Subject: [PATCH] et131x: fix allocation failures
To: devel@driverdev.osuosl.org, mark.einon@gmail.com, gamerh2o@gmail.com,
        linux-kernel@vger.kernel.org, greg@kroah.com
From: Alan <gnomes@lxorguk.ukuu.org.uk>
Date: Mon, 17 Feb 2014 14:13:08 +0000
Message-ID: <20140217141252.26738.33549.stgit@alan.etchedpixels.co.uk>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should check the ring allocations don't fail.
If we get a fail we need to clean up properly. The allocator assumes the
deallocator will be used on failure, but it isn't. Make sure the
right deallocator is always called and add a missing check against
fbr allocation failure.

[v2]: Correct check logic

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/staging/et131x/et131x.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 6413500..cc600df 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -2124,7 +2124,11 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 
 	/* Alloc memory for the lookup table */
 	rx_ring->fbr[0] = kmalloc(sizeof(struct fbr_lookup), GFP_KERNEL);
+	if (rx_ring->fbr[0] == NULL)
+		return -ENOMEM;
 	rx_ring->fbr[1] = kmalloc(sizeof(struct fbr_lookup), GFP_KERNEL);
+	if (rx_ring->fbr[1] == NULL)
+		return -ENOMEM;
 
 	/* The first thing we will do is configure the sizes of the buffer
 	 * rings. These will change based on jumbo packet support.  Larger
@@ -2289,7 +2293,7 @@ static void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 	for (id = 0; id < NUM_FBRS; id++) {
 		fbr = rx_ring->fbr[id];
 
-		if (!fbr->ring_virtaddr)
+		if (!fbr || !fbr->ring_virtaddr)
 			continue;
 
 		/* First the packet memory */
@@ -3591,6 +3595,7 @@ static int et131x_adapter_memory_alloc(struct et131x_adapter *adapter)
 	if (status) {
 		dev_err(&adapter->pdev->dev,
 			  "et131x_tx_dma_memory_alloc FAILED\n");
+		et131x_tx_dma_memory_free(adapter);
 		return status;
 	}
 	/* Receive buffer memory allocation */
@@ -3598,7 +3603,7 @@ static int et131x_adapter_memory_alloc(struct et131x_adapter *adapter)
 	if (status) {
 		dev_err(&adapter->pdev->dev,
 			  "et131x_rx_dma_memory_alloc FAILED\n");
-		et131x_tx_dma_memory_free(adapter);
+		et131x_adapter_memory_free(adapter);
 		return status;
 	}
 

