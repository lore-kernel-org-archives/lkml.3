Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab3E0MPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:15:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:61119 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932141Ab3E0MOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:14:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,750,1363158000"; 
   d="scan'208";a="247199736"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 12/12] txx9dmac: return DMA_SUCCESS immediately from device_tx_status()
Date: Mon, 27 May 2013 15:14:42 +0300
Message-Id: <1369656882-25241-13-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point to go throught the rest of the function if first call to
dma_cookie_status() returned DMA_SUCCESS.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/txx9dmac.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
index a59fb48..59357db 100644
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -962,15 +962,14 @@ txx9dmac_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
 	enum dma_status ret;
 
 	ret = dma_cookie_status(chan, cookie, txstate);
-	if (ret != DMA_SUCCESS) {
-		spin_lock_bh(&dc->lock);
-		txx9dmac_scan_descriptors(dc);
-		spin_unlock_bh(&dc->lock);
+	if (ret == DMA_SUCCESS)
+		return DMA_SUCCESS;
 
-		ret = dma_cookie_status(chan, cookie, txstate);
-	}
+	spin_lock_bh(&dc->lock);
+	txx9dmac_scan_descriptors(dc);
+	spin_unlock_bh(&dc->lock);
 
-	return ret;
+	return dma_cookie_status(chan, cookie, txstate);
 }
 
 static void txx9dmac_chain_dynamic(struct txx9dmac_chan *dc,
-- 
1.8.2.rc0.22.gb3600c3

