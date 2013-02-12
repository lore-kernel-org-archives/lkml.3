Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab3BLC0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 21:26:30 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36828 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3BLC03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 21:26:29 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH] pch_dma: Use GFP_ATOMIC because called from interrupt context
Date: Tue, 12 Feb 2013 11:25:33 +0900
Message-Id: <1360635933-5818-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pdc_desc_get() is called from pd_prep_slave_sg, and the function is
called from interrupt context(e.g. Uart driver "pch_uart.c").
In fact, I saw kernel error message.
So, GFP_ATOMIC must be used not GFP_NOIO.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/dma/pch_dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 987ab5c..d5cbd44 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -476,7 +476,7 @@ static struct pch_dma_desc *pdc_desc_get(struct pch_dma_chan *pd_chan)
 	dev_dbg(chan2dev(&pd_chan->chan), "scanned %d descriptors\n", i);
 
 	if (!ret) {
-		ret = pdc_alloc_desc(&pd_chan->chan, GFP_NOIO);
+		ret = pdc_alloc_desc(&pd_chan->chan, GFP_ATOMIC);
 		if (ret) {
 			spin_lock(&pd_chan->lock);
 			pd_chan->descs_allocated++;
-- 
1.7.4.4

