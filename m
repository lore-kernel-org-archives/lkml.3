Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968047Ab3DSJnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:43:14 -0400
Received: from smtp-out-134.synserver.de ([212.40.185.134]:1115 "EHLO
	smtp-out-130.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758408Ab3DSJnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:43:12 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 7393
From: Lars-Peter Clausen <lars@metafoo.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jon Hunter <jon-hunter@ti.com>,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/2] dma: of: Fix of_node reference leak
Date: Fri, 19 Apr 2013 11:42:13 +0200
Message-Id: <1366364534-3298-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_dma_request_slave_channel() currently does not drop the reference to the
dma_spec of_node if no DMA controller matching the of_node could be found. This
patch fixes it by always calling of_node_put().

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/dma/of-dma.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
index 8266893..2882403 100644
--- a/drivers/dma/of-dma.c
+++ b/drivers/dma/of-dma.c
@@ -221,12 +221,13 @@ struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
 
 		ofdma = of_dma_get_controller(&dma_spec);
 
-		if (!ofdma)
-			continue;
-
-		chan = ofdma->of_dma_xlate(&dma_spec, ofdma);
+		if (ofdma) {
+			chan = ofdma->of_dma_xlate(&dma_spec, ofdma);
 
-		of_dma_put_controller(ofdma);
+			of_dma_put_controller(ofdma);
+		} else {
+			chan = NULL;
+		}
 
 		of_node_put(dma_spec.np);
 
-- 
1.8.0

