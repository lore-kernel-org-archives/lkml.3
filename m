Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab3ANOVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 09:21:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:20247 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756869Ab3ANOVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 09:21:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,468,1355126400"; 
   d="scan'208";a="246379028"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] dw_dmac: don't exceed AHB master number in dwc_get_data_width
Date: Mon, 14 Jan 2013 16:20:53 +0200
Message-Id: <1358173253-680-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver's default assumes that hardware has two AHB masters which might be
not true. In such rare cases we have not to exceed a number of the AHB masters
present in the hardware. Thus, the AHB master with highest possible number will
be used to retrieve the data witdh value.

The patch also changes the logic a bit when the master parameter of the
dwc_get_data_width() is out of range. Now the function will return a value
related to the first AHB master.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 30ff2a4..b2d564a 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -80,13 +80,14 @@ static inline unsigned int dwc_get_data_width(struct dma_chan *chan, int master)
 {
 	struct dw_dma *dw = to_dw_dma(chan->device);
 	struct dw_dma_slave *dws = chan->private;
+	unsigned int m = 0;
 
 	if (master == SRC_MASTER)
-		return dw->data_width[dwc_get_sms(dws)];
+		m = dwc_get_sms(dws);
 	else if (master == DST_MASTER)
-		return dw->data_width[dwc_get_dms(dws)];
+		m = dwc_get_dms(dws);
 
-	return 0;
+	return dw->data_width[min_t(unsigned int, dw->nr_masters - 1, m)];
 }
 
 /*----------------------------------------------------------------------*/
-- 
1.7.10.4

