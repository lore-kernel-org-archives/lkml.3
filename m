Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab3BPWXZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 17:23:25 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:57956 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab3BPWXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 17:23:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Shevchenko <andy.shevchenko@gmail.com>, linux-kernel@vger.kernel.org
Subject: [BONUS PATCH] dmaengine: dw_dmac: simplify master selection
Date: Sat, 16 Feb 2013 22:23:12 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@linux.intel.com>
References: <1360952512-971558-1-git-send-email-arnd@arndb.de> <201302161400.29064.arnd@arndb.de> <CAHp75VfL0cQJenHB7A_A1d2eam2dj3k+4yWRE8pC+_gP2j_k2Q@mail.gmail.com>
In-Reply-To: <CAHp75VfL0cQJenHB7A_A1d2eam2dj3k+4yWRE8pC+_gP2j_k2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302162223.12805.arnd@arndb.de>
X-Provags-ID: V02:K0:MDdgBJPgnpv0Q/SXW8pd4afCP98ph4hm8Wi5EVrxV7b
 476qXUkACFF+ymzKS8e8mZYRx3YETljm1YNzWyD1pLm0yGjVfJ
 2E63Kk6XeQ2SmmgLE3ie3JHzDJTC15N0SFjhLsLvYDMQcrmJxK
 TT5PMdASziC/wvjz4zt3CZux/qV5zrtTZx2lluCH8au+4Ae+mx
 5rQP4X1kqUxHg11iq76YJFvItJO2ETAn71khl1Gyl0zBu2cTyv
 quHfreSFYkH/B1Lx6eZTXRKY42dLxgsOk1hSyo4GLrlbUoWcId
 RpeDeJHy0HpZQp6HaTK+fOm474bIob4cGHUWMZMJ2v76lY5p/o
 jp585VC8ysvJnmtain2Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch to add the common DMA binding added a dummy dw_dma_slave
structure into the dw_dma_chan structure in order to configure the
masters correctly. It turns out that this can be simplified if we
pick the DMA masters in the dwc_alloc_chan_resources function instead
and save them in the dw_dma_chan structure directly.

This could be simplified further once all users that today use
dw_dma_slave for configuration get converted to device tree based
setup instead.

This is just a proof of concept patch and should not get merged in
3.9, but I hope that Andy and Viresh find it useful and submit it
for 3.10 after testing and refining it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org
---
 drivers/dma/dw_dmac.c      | 96 ++++++++++++++++------------------------------
 drivers/dma/dw_dmac_regs.h |  4 +-
 2 files changed, 36 insertions(+), 64 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 72d6abf..72c6f6d 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -37,40 +37,10 @@
  * The driver has currently been tested only with the Atmel AT32AP7000,
  * which does not support descriptor writeback.
  */
-
-static inline unsigned int dwc_get_dms(struct dw_dma_slave *slave)
-{
-	return slave ? slave->dst_master : 0;
-}
-
-static inline unsigned int dwc_get_sms(struct dw_dma_slave *slave)
-{
-	return slave ? slave->src_master : 1;
-}
-
-#define SRC_MASTER	0
-#define DST_MASTER	1
-
-static inline unsigned int dwc_get_master(struct dma_chan *chan, int master)
-{
-	struct dw_dma *dw = to_dw_dma(chan->device);
-	struct dw_dma_slave *dws = chan->private;
-	unsigned int m;
-
-	if (master == SRC_MASTER)
-		m = dwc_get_sms(dws);
-	else
-		m = dwc_get_dms(dws);
-
-	return min_t(unsigned int, dw->nr_masters - 1, m);
-}
-
 #define DWC_DEFAULT_CTLLO(_chan) ({				\
 		struct dw_dma_chan *_dwc = to_dw_dma_chan(_chan);	\
 		struct dma_slave_config	*_sconfig = &_dwc->dma_sconfig;	\
 		bool _is_slave = is_slave_direction(_dwc->direction);	\
-		int _dms = dwc_get_master(_chan, DST_MASTER);		\
-		int _sms = dwc_get_master(_chan, SRC_MASTER);		\
 		u8 _smsize = _is_slave ? _sconfig->src_maxburst :	\
 			DW_DMA_MSIZE_16;			\
 		u8 _dmsize = _is_slave ? _sconfig->dst_maxburst :	\
@@ -80,8 +50,8 @@ static inline unsigned int dwc_get_master(struct dma_chan *chan, int master)
 		 | DWC_CTLL_SRC_MSIZE(_smsize)			\
 		 | DWC_CTLL_LLP_D_EN				\
 		 | DWC_CTLL_LLP_S_EN				\
-		 | DWC_CTLL_DMS(_dms)				\
-		 | DWC_CTLL_SMS(_sms));				\
+		 | DWC_CTLL_DMS(_dwc->dst_master)			\
+		 | DWC_CTLL_SMS(_dwc->src_master));			\
 	})
 
 /*
@@ -91,13 +61,6 @@ static inline unsigned int dwc_get_master(struct dma_chan *chan, int master)
  */
 #define NR_DESCS_PER_CHANNEL	64
 
-static inline unsigned int dwc_get_data_width(struct dma_chan *chan, int master)
-{
-	struct dw_dma *dw = to_dw_dma(chan->device);
-
-	return dw->data_width[dwc_get_master(chan, master)];
-}
-
 /*----------------------------------------------------------------------*/
 
 static struct device *chan2dev(struct dma_chan *chan)
@@ -171,13 +134,7 @@ static void dwc_initialize(struct dw_dma_chan *dwc)
 	if (dwc->initialized == true)
 		return;
 
-	if (dws && dws->cfg_hi == ~0 && dws->cfg_lo == ~0) {
-		/* autoconfigure based on request line from DT */
-		if (dwc->direction == DMA_MEM_TO_DEV)
-			cfghi = DWC_CFGH_DST_PER(dwc->request_line);
-		else if (dwc->direction == DMA_DEV_TO_MEM)
-			cfghi = DWC_CFGH_SRC_PER(dwc->request_line);
-	} else if (dws) {
+	if (dws) {
 		/*
 		 * We need controller-specific data to set up slave
 		 * transfers.
@@ -187,10 +144,12 @@ static void dwc_initialize(struct dw_dma_chan *dwc)
 		cfghi = dws->cfg_hi;
 		cfglo |= dws->cfg_lo & ~DWC_CFGL_CH_PRIOR_MASK;
 	} else {
+		unsigned int request_line = (dwc->request_line != ~0) ?
+			    dwc->request_line : dwc->dma_sconfig.slave_id;
 		if (dwc->direction == DMA_MEM_TO_DEV)
-			cfghi = DWC_CFGH_DST_PER(dwc->dma_sconfig.slave_id);
+			cfghi = DWC_CFGH_DST_PER(request_line);
 		else if (dwc->direction == DMA_DEV_TO_MEM)
-			cfghi = DWC_CFGH_SRC_PER(dwc->dma_sconfig.slave_id);
+			cfghi = DWC_CFGH_SRC_PER(request_line);
 	}
 
 	channel_writel(dwc, CFG_LO, cfglo);
@@ -743,6 +702,7 @@ static struct dma_async_tx_descriptor *
 dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 		size_t len, unsigned long flags)
 {
+	struct dw_dma		*dw = to_dw_dma(chan->device);
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
 	struct dw_desc		*desc;
 	struct dw_desc		*first;
@@ -766,8 +726,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 
 	dwc->direction = DMA_MEM_TO_MEM;
 
-	data_width = min_t(unsigned int, dwc_get_data_width(chan, SRC_MASTER),
-			   dwc_get_data_width(chan, DST_MASTER));
+	data_width = min(dw->data_width[dwc->src_master], dw->data_width[dwc->dst_master]);
 
 	src_width = dst_width = min_t(unsigned int, data_width,
 				      dwc_fast_fls(src | dest | len));
@@ -824,6 +783,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		unsigned int sg_len, enum dma_transfer_direction direction,
 		unsigned long flags, void *context)
 {
+	struct dw_dma		*dw = to_dw_dma(chan->device);
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
 	struct dma_slave_config	*sconfig = &dwc->dma_sconfig;
 	struct dw_desc		*prev;
@@ -858,7 +818,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		ctllo |= sconfig->device_fc ? DWC_CTLL_FC(DW_DMA_FC_P_M2P) :
 			DWC_CTLL_FC(DW_DMA_FC_D_M2P);
 
-		data_width = dwc_get_data_width(chan, SRC_MASTER);
+		data_width = dw->data_width[dwc->src_master];
 
 		for_each_sg(sgl, sg, sg_len, i) {
 			struct dw_desc	*desc;
@@ -918,7 +878,7 @@ slave_sg_todev_fill_desc:
 		ctllo |= sconfig->device_fc ? DWC_CTLL_FC(DW_DMA_FC_P_P2M) :
 			DWC_CTLL_FC(DW_DMA_FC_D_P2M);
 
-		data_width = dwc_get_data_width(chan, DST_MASTER);
+		data_width = dw->data_width[dwc->dst_master];
 
 		for_each_sg(sgl, sg, sg_len, i) {
 			struct dw_desc	*desc;
@@ -1139,6 +1099,7 @@ static void dwc_issue_pending(struct dma_chan *chan)
 static int dwc_alloc_chan_resources(struct dma_chan *chan)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	struct dw_dma_slave	*dws = chan->private;
 	struct dw_dma		*dw = to_dw_dma(chan->device);
 	struct dw_desc		*desc;
 	int			i;
@@ -1153,6 +1114,17 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 	}
 
 	dma_cookie_init(chan);
+	/* masters may be set up from dws, from DT or autoconfigured here */
+	if (dws) {
+		dwc->src_master = dws->src_master;
+		dwc->dst_master = dws->dst_master;
+	}
+	/* if unconfigured, default to source 1 dest 0 */
+	if (dwc->src_master == ~0)
+		dwc->src_master = 1;
+	if (dwc->dst_master == ~0)
+		dwc->dst_master = 0;
+
 
 	/*
 	 * NOTE: some controllers may have additional features that we
@@ -1218,6 +1190,10 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 	dwc->descs_allocated = 0;
 	dwc->initialized = false;
 
+	/* invalidate slave configuration */
+	dwc->request_line = ~0;
+	dwc->src_master = dwc->dst_master = ~0; 
+
 	/* Disable interrupts */
 	channel_clear_bit(dw, MASK.XFER, dwc->mask);
 	channel_clear_bit(dw, MASK.ERROR, dwc->mask);
@@ -1242,23 +1218,15 @@ struct dw_dma_filter_args {
 static bool dw_dma_generic_filter(struct dma_chan *chan, void *param)
 {
 	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
-	struct dw_dma *dw = to_dw_dma(chan->device);
 	struct dw_dma_filter_args *fargs = param;
-	struct dw_dma_slave *dws = &dwc->slave;
 
 	/* ensure the device matches our channel */
         if (chan->device != &fargs->dw->dma)
                 return false;
 
-	dws->dma_dev	= dw->dma.dev;
-	dws->cfg_hi	= ~0;
-	dws->cfg_lo	= ~0;
-	dws->src_master	= fargs->src;
-	dws->dst_master	= fargs->dst;
-
 	dwc->request_line = fargs->req;
-
-	chan->private = dws;
+	dwc->src_master = fargs->src;
+	dwc->dst_master = fargs->dst;
 
 	return true;
 }
@@ -1767,6 +1735,10 @@ static int dw_probe(struct platform_device *pdev)
 
 		dwc->direction = DMA_TRANS_NONE;
 
+		/* invalidate slave configuration */
+		dwc->request_line = ~0;
+		dwc->src_master = dwc->dst_master = ~0; 
+
 		/* hardware configuration */
 		if (autocfg) {
 			unsigned int dwc_params;
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index b632082..fa4e5f7 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -213,8 +213,8 @@ struct dw_dma_chan {
 	unsigned int		block_size;
 	bool			nollp;
 	unsigned int		request_line;
-	struct dw_dma_slave	slave;
-
+	unsigned char		src_master;
+	unsigned char		dst_master;
 
 	/* configuration passed via DMA_SLAVE_CONFIG */
 	struct dma_slave_config dma_sconfig;
-- 
1.8.1.2

