Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbaBNXcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 18:32:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:17695 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbaBNXcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 18:32:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,848,1384329600"; 
   d="scan'208";a="483734891"
From: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, Sudeep Dutt <sudeep.dutt@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>
Subject: [PATCH dmaengine-fixes 1/1] dmaengine: read completed cookie before used cookie
Date: Fri, 14 Feb 2014 15:32:57 -0800
Message-Id: <d0106d723f7455208f83e50522007fee7887e67e.1392419479.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running dmatest with my yet-to-be submitted driver for the Intel MIC DMA
engine, dmatest detected "dma0chan3-copy5: result #8096161:completion busy
status with src_off=0x0 dst_off=0x0 len=0x40 (0)". This is caused by reading
the used cookie before the completed cookie in dma_cookie_status(),  if a DMA
request is submitted in between the two reads, and completes,  the completed
cookie will be newer than the used cookie value read previously.  Reversing
the order of reads ensures that the completed cookie is for a DMA request
older than the used cookie.

Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Sudeep Dutt <sudeep.dutt@intel.com>
Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>
---
 drivers/dma/dmaengine.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/dmaengine.h b/drivers/dma/dmaengine.h
index 17f983a..4c96892 100644
--- a/drivers/dma/dmaengine.h
+++ b/drivers/dma/dmaengine.h
@@ -7,6 +7,7 @@
 
 #include <linux/bug.h>
 #include <linux/dmaengine.h>
+#include <asm/barrier.h>
 
 /**
  * dma_cookie_init - initialize the cookies for a DMA channel
@@ -69,8 +70,13 @@ static inline enum dma_status dma_cookie_status(struct dma_chan *chan,
 {
 	dma_cookie_t used, complete;
 
-	used = chan->cookie;
 	complete = chan->completed_cookie;
+	/*
+	 * If this order is not maintained, used can end up being older than
+	 * complete
+	 */
+	smp_rmb();
+	used = chan->cookie;
 	barrier();
 	if (state) {
 		state->last = complete;
-- 
1.8.2.2

