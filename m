Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbaGSBWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 21:22:04 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:50124 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaGSBWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 21:22:02 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Lars-Peter Clausen <lars@metafoo.de>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 1/1] dmaengine: pl330: Check if the DMA descriptor is NULL
Date: Sat, 19 Jul 2014 03:21:47 +0200
Message-Id: <1405732907-30964-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6079d38 ("dmaengine: pl330: Remove useless xfer_cb indirection")
removed the __callback() function which created an unnecessary level of
indirection to execute the tranfer callback .xfer_cb

Unfortunately the commit also changed the semantics slightly since that
function used to check if the request was not NULL before attempting to
execute the callback function. Not checking this could lead to a kernel
NULL pointer dereference error.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/dma/pl330.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index bc5878a..a55d754 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1441,9 +1441,14 @@ xfer_exit:
 
 static void dma_pl330_rqcb(struct dma_pl330_desc *desc, enum pl330_op_err err)
 {
-	struct dma_pl330_chan *pch = desc->pchan;
+	struct dma_pl330_chan *pch;
 	unsigned long flags;
 
+	if (!desc)
+		return;
+
+	pch = desc->pchan;
+
 	/* If desc aborted */
 	if (!pch)
 		return;
-- 
2.0.0.rc2

