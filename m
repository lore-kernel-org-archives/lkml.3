Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbaJVPpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:45:25 -0400
Received: from down.free-electrons.com ([37.187.137.238]:54002 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754467AbaJVPpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:23 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 05/59] dmaengine: Make channel allocation callbacks optional
Date: Wed, 22 Oct 2014 17:43:19 +0200
Message-Id: <1413992653-21963-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nowadays, some drivers don't have anything in there channel allocation
callbacks anymore.

Remove the BUG_ON if those callbacks aren't implemented, in order to allow
drivers to not implement them.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/dmaengine.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 72f10e2f5c32..9b2cd74b8f2e 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -235,9 +235,11 @@ static int dma_chan_get(struct dma_chan *chan)
 		return -ENODEV;
 
 	/* allocate upon first client reference */
-	ret = chan->device->device_alloc_chan_resources(chan);
-	if (ret < 0)
-		goto err_out;
+	if (chan->device->device_alloc_chan_resources) {
+		ret = chan->device->device_alloc_chan_resources(chan);
+		if (ret < 0)
+			goto err_out;
+	}
 
 	if (!dma_has_cap(DMA_PRIVATE, chan->device->cap_mask))
 		balance_ref_count(chan);
@@ -259,11 +261,15 @@ err_out:
  */
 static void dma_chan_put(struct dma_chan *chan)
 {
+	/* This channel is not in use, bail out */
 	if (!chan->client_count)
-		return; /* this channel failed alloc_chan_resources */
+		return;
+
 	chan->client_count--;
 	module_put(dma_chan_to_owner(chan));
-	if (chan->client_count == 0)
+
+	/* This channel is not in use anymore, free it */
+	if (!chan->client_count && chan->device->device_free_chan_resources)
 		chan->device->device_free_chan_resources(chan);
 }
 
@@ -819,8 +825,6 @@ int dma_async_device_register(struct dma_device *device)
 	BUG_ON(dma_has_cap(DMA_INTERLEAVE, device->cap_mask) &&
 		!device->device_prep_interleaved_dma);
 
-	BUG_ON(!device->device_alloc_chan_resources);
-	BUG_ON(!device->device_free_chan_resources);
 	BUG_ON(!device->device_tx_status);
 	BUG_ON(!device->device_issue_pending);
 	BUG_ON(!device->dev);
-- 
2.1.1

