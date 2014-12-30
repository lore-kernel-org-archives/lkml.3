Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaL3Jho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 04:37:44 -0500
Received: from mail-bl2on0145.outbound.protection.outlook.com ([65.55.169.145]:23860
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751756AbaL3Jhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 04:37:42 -0500
From: Jingchang Lu <jingchang.lu@freescale.com>
To: <vinod.koul@intel.com>
CC: <dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: [PATCH 1/2] dmaengine: fsl-edma: add dma memcpy support
Date: Tue, 30 Dec 2014 16:41:46 +0800
Message-ID: <1419928907-18053-2-git-send-email-jingchang.lu@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1419928907-18053-1-git-send-email-jingchang.lu@freescale.com>
References: <1419928907-18053-1-git-send-email-jingchang.lu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=jingchang.lu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(199003)(77096005)(87936001)(2950100001)(33646002)(50226001)(575784001)(19580395003)(50466002)(21056001)(89996001)(6806004)(97736003)(92566001)(36756003)(31966008)(84676001)(85426001)(120916001)(48376002)(68736005)(110136001)(76176999)(105606002)(64706001)(20776003)(2351001)(4396001)(229853001)(107046002)(50986999)(86362001)(19580405001)(106466001)(104016003)(47776003)(77156002)(46102003)(62966003)(99396003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1236;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN3PR0301MB1236;
X-Forefront-PRVS: 04410E544A
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2014 09:37:38.6025
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0301MB1236
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the memory copy capability support, the memcpy
functionality needs to configure the DMAMUX of the channel
with the always on slave id.

Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
---
 drivers/dma/fsl-edma.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 61 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/fsl-edma.c b/drivers/dma/fsl-edma.c
index 09e2842..e0bd517 100644
--- a/drivers/dma/fsl-edma.c
+++ b/drivers/dma/fsl-edma.c
@@ -110,6 +110,8 @@
 #define EDMAMUX_CHCFG_ENBL		0x80
 #define EDMAMUX_CHCFG_SOURCE(n)		((n) & 0x3F)
 
+#define SLAVE_ID_ALWAYSON	63 /* the always on slave id */
+
 #define DMAMUX_NR	2
 
 #define FSL_EDMA_BUSWIDTHS	BIT(DMA_SLAVE_BUSWIDTH_1_BYTE) | \
@@ -147,6 +149,7 @@ struct fsl_edma_slave_config {
 struct fsl_edma_chan {
 	struct virt_dma_chan		vchan;
 	enum dma_status			status;
+	u32				slave_id;
 	struct fsl_edma_engine		*edma;
 	struct fsl_edma_desc		*edesc;
 	struct fsl_edma_slave_config	fsc;
@@ -637,6 +640,45 @@ static struct dma_async_tx_descriptor *fsl_edma_prep_slave_sg(
 	return vchan_tx_prep(&fsl_chan->vchan, &fsl_desc->vdesc, flags);
 }
 
+static struct dma_async_tx_descriptor *
+fsl_edma_prep_memcpy(struct dma_chan *chan, dma_addr_t dst,
+			dma_addr_t src, size_t len, unsigned long tx_flags)
+{
+	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
+	struct fsl_edma_desc *fsl_desc;
+	u16 soff, doff, attr;
+
+	/*
+	 * use 4-bytes data transfer size if all is 4-bytes aligned,
+	 * else 2-bytes data transfer size of all is 2-bytes aligned,
+	 * otherwise 1-byte tranfer size.
+	 */
+	if (src & 0x1 || dst & 0x1 || len & 0x1) {
+		attr = EDMA_TCD_ATTR_SSIZE_8BIT | EDMA_TCD_ATTR_DSIZE_8BIT;
+		soff = 0x1;
+		doff = 0x1;
+	} else if (src & 0x2 || dst & 0x2 || len & 0x2) {
+		attr = EDMA_TCD_ATTR_SSIZE_16BIT | EDMA_TCD_ATTR_DSIZE_16BIT;
+		soff = 0x2;
+		doff = 0x2;
+	} else {
+		attr = EDMA_TCD_ATTR_SSIZE_32BIT | EDMA_TCD_ATTR_DSIZE_32BIT;
+		soff = 0x4;
+		doff = 0x4;
+	}
+
+	fsl_desc = fsl_edma_alloc_desc(fsl_chan, 1);
+	if (!fsl_desc)
+		return NULL;
+	fsl_desc->iscyclic = false;
+
+	fsl_edma_fill_tcd(fsl_desc->tcd[0].vtcd, src, dst, attr, soff, len,
+			  0, 1, 1, doff, 0, true, true, false);
+
+	return vchan_tx_prep(&fsl_chan->vchan, &fsl_desc->vdesc, tx_flags);
+
+}
+
 static void fsl_edma_xfer_desc(struct fsl_edma_chan *fsl_chan)
 {
 	struct virt_dma_desc *vdesc;
@@ -735,6 +777,7 @@ static struct dma_chan *fsl_edma_xlate(struct of_phandle_args *dma_spec,
 {
 	struct fsl_edma_engine *fsl_edma = ofdma->of_dma_data;
 	struct dma_chan *chan, *_chan;
+	struct fsl_edma_chan *fsl_chan;
 	unsigned long chans_per_mux = fsl_edma->n_chans / DMAMUX_NR;
 
 	if (dma_spec->args_count != 2)
@@ -748,8 +791,10 @@ static struct dma_chan *fsl_edma_xlate(struct of_phandle_args *dma_spec,
 			chan = dma_get_slave_channel(chan);
 			if (chan) {
 				chan->device->privatecnt++;
-				fsl_edma_chan_mux(to_fsl_edma_chan(chan),
-					dma_spec->args[1], true);
+				fsl_chan = to_fsl_edma_chan(chan);
+				fsl_chan->slave_id = dma_spec->args[1];
+				fsl_edma_chan_mux(fsl_chan, fsl_chan->slave_id,
+						  true);
 				mutex_unlock(&fsl_edma->fsl_edma_mutex);
 				return chan;
 			}
@@ -763,6 +808,17 @@ static int fsl_edma_alloc_chan_resources(struct dma_chan *chan)
 {
 	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
 
+	/*
+	 * If the slave id of the channel DMAMUX is not set yet,
+	 * this could happy when the channel is requested by the
+	 * dma_request_channel() for memory copy purpose instead
+	 * of by dts binding, then configure the DMAMUX with the
+	 * always on slave id.
+	 */
+	if (fsl_chan->slave_id == 0) {
+		fsl_chan->slave_id = SLAVE_ID_ALWAYSON;
+		fsl_edma_chan_mux(fsl_chan, fsl_chan->slave_id, true);
+	}
 	fsl_chan->tcd_pool = dma_pool_create("tcd_pool", chan->device->dev,
 				sizeof(struct fsl_edma_hw_tcd),
 				32, 0);
@@ -778,6 +834,7 @@ static void fsl_edma_free_chan_resources(struct dma_chan *chan)
 	spin_lock_irqsave(&fsl_chan->vchan.lock, flags);
 	fsl_edma_disable_request(fsl_chan);
 	fsl_edma_chan_mux(fsl_chan, 0, false);
+	fsl_chan->slave_id = 0;
 	fsl_chan->edesc = NULL;
 	vchan_get_all_descriptors(&fsl_chan->vchan, &head);
 	spin_unlock_irqrestore(&fsl_chan->vchan.lock, flags);
@@ -903,6 +960,7 @@ static int fsl_edma_probe(struct platform_device *pdev)
 	dma_cap_set(DMA_PRIVATE, fsl_edma->dma_dev.cap_mask);
 	dma_cap_set(DMA_SLAVE, fsl_edma->dma_dev.cap_mask);
 	dma_cap_set(DMA_CYCLIC, fsl_edma->dma_dev.cap_mask);
+	dma_cap_set(DMA_MEMCPY, fsl_edma->dma_dev.cap_mask);
 
 	fsl_edma->dma_dev.dev = &pdev->dev;
 	fsl_edma->dma_dev.device_alloc_chan_resources
@@ -912,6 +970,7 @@ static int fsl_edma_probe(struct platform_device *pdev)
 	fsl_edma->dma_dev.device_tx_status = fsl_edma_tx_status;
 	fsl_edma->dma_dev.device_prep_slave_sg = fsl_edma_prep_slave_sg;
 	fsl_edma->dma_dev.device_prep_dma_cyclic = fsl_edma_prep_dma_cyclic;
+	fsl_edma->dma_dev.device_prep_dma_memcpy = fsl_edma_prep_memcpy;
 	fsl_edma->dma_dev.device_config = fsl_edma_slave_config;
 	fsl_edma->dma_dev.device_pause = fsl_edma_pause;
 	fsl_edma->dma_dev.device_resume = fsl_edma_resume;
-- 
1.8.0

