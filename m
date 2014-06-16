Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaFPDae (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 23:30:34 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:3447
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752787AbaFPDab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 23:30:31 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <vinod.koul@intel.com>, <s.hauer@pengutronix.de>
CC: <dan.j.williams@intel.com>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>
Subject: [PATCH] dma: imx-sdma: Save imx_dma_data into sdmac
Date: Mon, 16 Jun 2014 11:32:29 +0800
Message-ID: <1402889549-23864-1-git-send-email-nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130473630281563195;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(62966002)(73972005)(92726001)(80022001)(48376002)(82202001)(86362001)(47776003)(87286001)(61266001)(104166001)(50466002)(85306003)(74502001)(87936001)(31966008)(97736001)(21056001)(36756003)(84676001)(87572001)(85852003)(73392001)(6806004)(33646001)(68736004)(77156001)(77982001)(55446002)(93916002)(89996001)(46102001)(83072002)(102836001)(4396001)(74662001)(19580395003)(44976005)(81542001)(92566001)(20776003)(99396002)(64706001)(26826002)(88136002)(50226001)(79102001)(50986999)(81342001)(19580405001)(104016001)(81442001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB394;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0244637DEA
Authentication-Results: spf=softfail (sender IP is 192.88.168.50)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The filter() function is currently called by xlate() while it transfers
imx_dma_data as a local variable to the filter() but releases the data
right after returning a DMA channel pointer, which results chan->private
pointing an invalid memory space.

So this patch just stores the imx_dma_data into sdmac to make usre the
private pointer valid as long as the channel exists.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 drivers/dma/imx-sdma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 19041ce..fc04add 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -270,6 +270,7 @@ struct sdma_channel {
 	unsigned int			chn_count;
 	unsigned int			chn_real_count;
 	struct tasklet_struct		tasklet;
+	struct imx_dma_data		data;
 };
 
 #define IMX_DMA_SG_LOOP		BIT(0)
@@ -1402,12 +1403,14 @@ err_dma_alloc:
 
 static bool sdma_filter_fn(struct dma_chan *chan, void *fn_param)
 {
+	struct sdma_channel *sdmac = to_sdma_chan(chan);
 	struct imx_dma_data *data = fn_param;
 
 	if (!imx_dma_is_general_purpose(chan))
 		return false;
 
-	chan->private = data;
+	sdmac->data = *data;
+	chan->private = &sdmac->data;
 
 	return true;
 }
-- 
1.8.4

