Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab3GOMFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 08:05:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:27427 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777Ab3GOMFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 08:05:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,668,1367996400"; 
   d="scan'208";a="365382273"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 3/6] dma: dw: improve comparison with ~0
Date: Mon, 15 Jul 2013 15:04:38 +0300
Message-Id: <1373889881-21075-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373889881-21075-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1373889881-21075-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In general ~0 does not fit some integer types. Let's do a helper to make a
comparison with that constant properly.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw/core.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index bd6b0de..a0aa6f9 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -37,16 +37,22 @@
  * which does not support descriptor writeback.
  */
 
+static inline bool is_request_line_unset(struct dw_dma_chan *dwc)
+{
+	return dwc->request_line == (typeof(dwc->request_line))~0;
+}
+
 static inline void dwc_set_masters(struct dw_dma_chan *dwc)
 {
 	struct dw_dma *dw = to_dw_dma(dwc->chan.device);
 	struct dw_dma_slave *dws = dwc->chan.private;
 	unsigned char mmax = dw->nr_masters - 1;
 
-	if (dwc->request_line == ~0) {
-		dwc->src_master = min_t(unsigned char, mmax, dwc_get_sms(dws));
-		dwc->dst_master = min_t(unsigned char, mmax, dwc_get_dms(dws));
-	}
+	if (!is_request_line_unset(dwc))
+		return;
+
+	dwc->src_master = min_t(unsigned char, mmax, dwc_get_sms(dws));
+	dwc->dst_master = min_t(unsigned char, mmax, dwc_get_dms(dws));
 }
 
 #define DWC_DEFAULT_CTLLO(_chan) ({				\
@@ -984,7 +990,7 @@ set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
 	dwc->direction = sconfig->direction;
 
 	/* Take the request line from slave_id member */
-	if (dwc->request_line == ~0)
+	if (is_request_line_unset(dwc))
 		dwc->request_line = sconfig->slave_id;
 
 	convert_burst(&dwc->dma_sconfig.src_maxburst);
-- 
1.8.3.2

