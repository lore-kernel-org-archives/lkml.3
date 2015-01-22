Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbbAVFYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 00:24:22 -0500
Received: from mail-bl2on0104.outbound.protection.outlook.com ([65.55.169.104]:27940
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750796AbbAVFYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 00:24:13 -0500
From: Robin Gong <b38343@freescale.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>,
        <s.hauer@pengutronix.de>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] dma: imx-sdma: switch to dynamic context mode after script loaded
Date: Thu, 22 Jan 2015 11:59:37 +0800
Message-ID: <1421899177-30406-1-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(243025005)(189002)(575784001)(6806004)(229853001)(46102003)(104016003)(33646002)(2201001)(105606002)(19580395003)(19580405001)(106466001)(36756003)(77156002)(48376002)(64706001)(97736003)(47776003)(50466002)(15975445007)(68736005)(77096005)(87936001)(92566002)(50226001)(85426001)(50986999)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB329;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR03MB329;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR03MB329;
X-Forefront-PRVS: 0464DBBBC4
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB329;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2015 05:10:05.9950
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR03MB329
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below comments got from Page4724 of Reference Manual of i.mx6q:
http://cache.freescale.com/files/32bit/doc/ref_manual/IMX6DQRM.pdf

--"Static context mode should be used for the first channel called
after reset to ensure that the all context RAM for that channel is
initialized during the context SAVE phase when the channel is
done or yields. Subsequent calls to the same channel or
different channels may use any of the dynamic context modes.
This will ensure that all context locations for the bootload
channel are initialized, and prevent undefined values in context
RAM from being loaded during the context restore if the
channel is re-started later"

Unfortunately, the rule was broken by commit(5b28aa319bba96987316425a1131813d87cbab35)
.This patch just take them back.

Signed-off-by: Robin Gong <b38343@freescale.com>
---
 drivers/dma/imx-sdma.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index d0df198..d84b7a8 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -330,6 +330,8 @@ struct sdma_engine {
 	const struct sdma_driver_data	*drvdata;
 };
 
+static bool channel0_first;
+
 static struct sdma_driver_data sdma_imx31 = {
 	.chnenbl0 = SDMA_CHNENBL0_IMX31,
 	.num_events = 32,
@@ -531,6 +533,12 @@ static int sdma_run_channel0(struct sdma_engine *sdma)
 		dev_err(sdma->dev, "Timeout waiting for CH0 ready\n");
 	}
 
+	if (!channel0_first) {
+		/* Set bits of CONFIG register with given context switching mode */
+		writel_relaxed(SDMA_H_CONFIG_CSM, sdma->regs + SDMA_H_CONFIG);
+		channel0_first = true;
+	}
+
 	return ret ? 0 : -ETIMEDOUT;
 }
 
@@ -1401,9 +1409,6 @@ static int sdma_init(struct sdma_engine *sdma)
 
 	writel_relaxed(ccb_phys, sdma->regs + SDMA_H_C0PTR);
 
-	/* Set bits of CONFIG register with given context switching mode */
-	writel_relaxed(SDMA_H_CONFIG_CSM, sdma->regs + SDMA_H_CONFIG);
-
 	/* Initializes channel's priorities */
 	sdma_set_channel_priority(&sdma->channel[0], 7);
 
-- 
1.9.1

