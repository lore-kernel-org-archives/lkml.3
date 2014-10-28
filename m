Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbaJ1VmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:42:18 -0400
Received: from down.free-electrons.com ([37.187.137.238]:37096 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932101AbaJ1Vai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:30:38 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v4 04/58] dmaengine: Rework dma_chan_get
Date: Tue, 28 Oct 2014 22:25:19 +0100
Message-Id: <1414531573-18807-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414531573-18807-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1414531573-18807-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_chan_get uses a rather interesting error handling and code path.

Change it to something more usual in the kernel.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/dma/dmaengine.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 24bfaf0b92ba..72f10e2f5c32 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -222,31 +222,33 @@ static void balance_ref_count(struct dma_chan *chan)
  */
 static int dma_chan_get(struct dma_chan *chan)
 {
-	int err = -ENODEV;
 	struct module *owner = dma_chan_to_owner(chan);
+	int ret;
 
+	/* The channel is already in use, update client count */
 	if (chan->client_count) {
 		__module_get(owner);
-		err = 0;
-	} else if (try_module_get(owner))
-		err = 0;
+		goto out;
+	}
 
-	if (err == 0)
-		chan->client_count++;
+	if (!try_module_get(owner))
+		return -ENODEV;
 
 	/* allocate upon first client reference */
-	if (chan->client_count == 1 && err == 0) {
-		int desc_cnt = chan->device->device_alloc_chan_resources(chan);
-
-		if (desc_cnt < 0) {
-			err = desc_cnt;
-			chan->client_count = 0;
-			module_put(owner);
-		} else if (!dma_has_cap(DMA_PRIVATE, chan->device->cap_mask))
-			balance_ref_count(chan);
-	}
+	ret = chan->device->device_alloc_chan_resources(chan);
+	if (ret < 0)
+		goto err_out;
 
-	return err;
+	if (!dma_has_cap(DMA_PRIVATE, chan->device->cap_mask))
+		balance_ref_count(chan);
+
+out:
+	chan->client_count++;
+	return 0;
+
+err_out:
+	module_put(owner);
+	return ret;
 }
 
 /**
-- 
2.1.1

