Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaEUIDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:03:35 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:19813
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751210AbaEUIDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:03:31 -0400
From: <hongbo.zhang@freescale.com>
To: <vkoul@infradead.org>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>
CC: <leo.li@freescale.com>, <scottwood@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
Subject: [PATCH v5 1/3] DMA: Freescale: use spin_lock_bh instead of spin_lock_irqsave
Date: Wed, 21 May 2014 16:03:01 +0800
Message-ID: <1400659383-6555-2-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400659383-6555-1-git-send-email-hongbo.zhang@freescale.com>
References: <1400659383-6555-1-git-send-email-hongbo.zhang@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(979002)(6009001)(199002)(189002)(48376002)(21056001)(77982001)(92726001)(62966002)(31966008)(2201001)(76176999)(86152002)(47776003)(92566001)(46102001)(89996001)(74502001)(50986999)(76482001)(74662001)(97736001)(80022001)(77096999)(50466002)(85852003)(20776003)(69596002)(88136002)(87936001)(19580395003)(84676001)(99396002)(551934003)(64706001)(36756003)(6806004)(68736004)(83072002)(102836001)(87286001)(33646001)(93916002)(81156002)(79102001)(86362001)(83322001)(81342001)(575784001)(44976005)(50226001)(81542001)(4396001)(19580405001)(77156001)(2101003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB397;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0218A015FA
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=hongbo.zhang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongbo Zhang <hongbo.zhang@freescale.com>

The usage of spin_lock_irqsave() is a stronger locking mechanism than is
required throughout the driver. The minimum locking required should be used
instead. Interrupts will be turned off and context will be saved, it is
unnecessary to use irqsave.

This patch changes all instances of spin_lock_irqsave() to spin_lock_bh(). All
manipulation of protected fields is done using tasklet context or weaker, which
makes spin_lock_bh() the correct choice.

Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
---
 drivers/dma/fsldma.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index e0fec68..b291e6c 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -396,10 +396,9 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	struct fsldma_chan *chan = to_fsl_chan(tx->chan);
 	struct fsl_desc_sw *desc = tx_to_fsl_desc(tx);
 	struct fsl_desc_sw *child;
-	unsigned long flags;
 	dma_cookie_t cookie = -EINVAL;
 
-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_bh(&chan->desc_lock);
 
 	/*
 	 * assign cookies to all of the software descriptors
@@ -412,7 +411,7 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	/* put this transaction onto the tail of the pending queue */
 	append_ld_queue(chan, desc);
 
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_bh(&chan->desc_lock);
 
 	return cookie;
 }
@@ -617,13 +616,12 @@ static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
 static void fsl_dma_free_chan_resources(struct dma_chan *dchan)
 {
 	struct fsldma_chan *chan = to_fsl_chan(dchan);
-	unsigned long flags;
 
 	chan_dbg(chan, "free all channel resources\n");
-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_bh(&chan->desc_lock);
 	fsldma_free_desc_list(chan, &chan->ld_pending);
 	fsldma_free_desc_list(chan, &chan->ld_running);
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_bh(&chan->desc_lock);
 
 	dma_pool_destroy(chan->desc_pool);
 	chan->desc_pool = NULL;
@@ -842,7 +840,6 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 {
 	struct dma_slave_config *config;
 	struct fsldma_chan *chan;
-	unsigned long flags;
 	int size;
 
 	if (!dchan)
@@ -852,7 +849,7 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 
 	switch (cmd) {
 	case DMA_TERMINATE_ALL:
-		spin_lock_irqsave(&chan->desc_lock, flags);
+		spin_lock_bh(&chan->desc_lock);
 
 		/* Halt the DMA engine */
 		dma_halt(chan);
@@ -862,7 +859,7 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 		fsldma_free_desc_list(chan, &chan->ld_running);
 		chan->idle = true;
 
-		spin_unlock_irqrestore(&chan->desc_lock, flags);
+		spin_unlock_bh(&chan->desc_lock);
 		return 0;
 
 	case DMA_SLAVE_CONFIG:
@@ -904,11 +901,10 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 static void fsl_dma_memcpy_issue_pending(struct dma_chan *dchan)
 {
 	struct fsldma_chan *chan = to_fsl_chan(dchan);
-	unsigned long flags;
 
-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_bh(&chan->desc_lock);
 	fsl_chan_xfer_ld_queue(chan);
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_bh(&chan->desc_lock);
 }
 
 /**
@@ -998,11 +994,10 @@ static void dma_do_tasklet(unsigned long data)
 	struct fsldma_chan *chan = (struct fsldma_chan *)data;
 	struct fsl_desc_sw *desc, *_desc;
 	LIST_HEAD(ld_cleanup);
-	unsigned long flags;
 
 	chan_dbg(chan, "tasklet entry\n");
 
-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_bh(&chan->desc_lock);
 
 	/* update the cookie if we have some descriptors to cleanup */
 	if (!list_empty(&chan->ld_running)) {
@@ -1031,7 +1026,7 @@ static void dma_do_tasklet(unsigned long data)
 	 * ahead and free the descriptors below.
 	 */
 	fsl_chan_xfer_ld_queue(chan);
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_bh(&chan->desc_lock);
 
 	/* Run the callback for each descriptor, in order */
 	list_for_each_entry_safe(desc, _desc, &ld_cleanup, node) {
-- 
1.7.9.5


