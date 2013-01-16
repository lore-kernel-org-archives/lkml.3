Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab3APNtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:49:12 -0500
Received: from mga14.intel.com ([143.182.124.37]:5896 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab3APNtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:49:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,479,1355126400"; 
   d="scan'208";a="191781399"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3] dw_dmac: don't exceed AHB master number in dwc_get_data_width
Date: Wed, 16 Jan 2013 15:48:51 +0200
Message-Id: <1358344131-18097-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358344131-18097-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1358344131-18097-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver assumes that hardware has two AHB masters which might not be always
true. In such cases we must not exceed number of the AHB masters present in the
hardware. In the proposed scheme in this patch, we would choose the master with
highest possible number whenever we exceed max AHB masters.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Since v2:
 - update commit message accordingly to Viresh suggestion
Since v1:
 - use proper value of master in the CTL lo register as well

 drivers/dma/dw_dmac.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 30ff2a4..561bb9a 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -46,13 +46,29 @@ static inline unsigned int dwc_get_sms(struct dw_dma_slave *slave)
 	return slave ? slave->src_master : 1;
 }
 
+#define SRC_MASTER	0
+#define DST_MASTER	1
+
+static inline unsigned int dwc_get_master(struct dma_chan *chan, int master)
+{
+	struct dw_dma *dw = to_dw_dma(chan->device);
+	struct dw_dma_slave *dws = chan->private;
+	unsigned int m = 0;
+
+	if (master == SRC_MASTER)
+		m = dwc_get_sms(dws);
+	else if (master == DST_MASTER)
+		m = dwc_get_dms(dws);
+
+	return min_t(unsigned int, dw->nr_masters - 1, m);
+}
+
 #define DWC_DEFAULT_CTLLO(_chan) ({				\
-		struct dw_dma_slave *__slave = (_chan->private);	\
 		struct dw_dma_chan *_dwc = to_dw_dma_chan(_chan);	\
 		struct dma_slave_config	*_sconfig = &_dwc->dma_sconfig;	\
 		bool _is_slave = is_slave_direction(_dwc->direction);	\
-		int _dms = dwc_get_dms(__slave);		\
-		int _sms = dwc_get_sms(__slave);		\
+		int _dms = dwc_get_master(_chan, DST_MASTER);		\
+		int _sms = dwc_get_master(_chan, SRC_MASTER);		\
 		u8 _smsize = _is_slave ? _sconfig->src_maxburst :	\
 			DW_DMA_MSIZE_16;			\
 		u8 _dmsize = _is_slave ? _sconfig->dst_maxburst :	\
@@ -73,20 +89,11 @@ static inline unsigned int dwc_get_sms(struct dw_dma_slave *slave)
  */
 #define NR_DESCS_PER_CHANNEL	64
 
-#define SRC_MASTER	0
-#define DST_MASTER	1
-
 static inline unsigned int dwc_get_data_width(struct dma_chan *chan, int master)
 {
 	struct dw_dma *dw = to_dw_dma(chan->device);
-	struct dw_dma_slave *dws = chan->private;
 
-	if (master == SRC_MASTER)
-		return dw->data_width[dwc_get_sms(dws)];
-	else if (master == DST_MASTER)
-		return dw->data_width[dwc_get_dms(dws)];
-
-	return 0;
+	return dw->data_width[dwc_get_master(chan, master)];
 }
 
 /*----------------------------------------------------------------------*/
-- 
1.7.10.4

