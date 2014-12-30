Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaL3Jhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 04:37:45 -0500
Received: from mail-bn1on0136.outbound.protection.outlook.com ([157.56.110.136]:7456
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751994AbaL3Jhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 04:37:43 -0500
From: Jingchang Lu <jingchang.lu@freescale.com>
To: <vinod.koul@intel.com>
CC: <dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: [PATCH 2/2] dmaengine: fsl-edma: add PM suspend/resume support
Date: Tue, 30 Dec 2014 16:41:47 +0800
Message-ID: <1419928907-18053-3-git-send-email-jingchang.lu@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1419928907-18053-1-git-send-email-jingchang.lu@freescale.com>
References: <1419928907-18053-1-git-send-email-jingchang.lu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=jingchang.lu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(199003)(50226001)(50986999)(47776003)(85426001)(89996001)(120916001)(19580395003)(50466002)(21056001)(2950100001)(46102003)(48376002)(87936001)(62966003)(84676001)(77156002)(68736005)(31966008)(97736003)(64706001)(92566001)(110136001)(33646002)(575784001)(107046002)(229853001)(6806004)(86362001)(4396001)(106466001)(20776003)(76176999)(77096005)(99396003)(104016003)(105606002)(36756003)(19580405001)(2351001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1235;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN3PR0301MB1235;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN3PR0301MB1235;
X-Forefront-PRVS: 04410E544A
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1235;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2014 09:37:40.8897
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0301MB1235
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds power management suspend/resume support for
the fsl-edma driver.

Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
---
 drivers/dma/fsl-edma.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/dma/fsl-edma.c b/drivers/dma/fsl-edma.c
index e0bd517..6a81699 100644
--- a/drivers/dma/fsl-edma.c
+++ b/drivers/dma/fsl-edma.c
@@ -1017,6 +1017,43 @@ static int fsl_edma_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int fsl_edma_pm_suspend(struct device *dev)
+{
+	struct fsl_edma_engine *fsl_edma = dev_get_drvdata(dev);
+	struct fsl_edma_chan *fsl_chan;
+	int i;
+
+	for (i = 0; i < fsl_edma->n_chans; i++) {
+		fsl_chan = &fsl_edma->chans[i];
+		fsl_edma_chan_mux(fsl_chan, 0, false);
+	}
+
+	return 0;
+}
+
+static int fsl_edma_pm_resume(struct device *dev)
+{
+	struct fsl_edma_engine *fsl_edma = dev_get_drvdata(dev);
+	struct fsl_edma_chan *fsl_chan;
+	int i;
+
+	for (i = 0; i < fsl_edma->n_chans; i++) {
+		fsl_chan = &fsl_edma->chans[i];
+		edma_writew(fsl_edma, 0x0, fsl_edma->membase + EDMA_TCD_CSR(i));
+		/* restore the channel slave id configuration */
+		fsl_edma_chan_mux(fsl_chan, fsl_chan->slave_id, true);
+	}
+
+	edma_writel(fsl_edma, EDMA_CR_ERGA | EDMA_CR_ERCA,
+		    fsl_edma->membase + EDMA_CR);
+
+	return 0;
+}
+#endif
+static
+SIMPLE_DEV_PM_OPS(fsl_edma_pm_ops, fsl_edma_pm_suspend, fsl_edma_pm_resume);
+
 static const struct of_device_id fsl_edma_dt_ids[] = {
 	{ .compatible = "fsl,vf610-edma", },
 	{ /* sentinel */ }
@@ -1027,6 +1064,7 @@ static struct platform_driver fsl_edma_driver = {
 	.driver		= {
 		.name	= "fsl-edma",
 		.of_match_table = fsl_edma_dt_ids,
+		.pm	= &fsl_edma_pm_ops,
 	},
 	.probe          = fsl_edma_probe,
 	.remove		= fsl_edma_remove,
-- 
1.8.0

