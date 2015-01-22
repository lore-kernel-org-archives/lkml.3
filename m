Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbbAVIeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:34:21 -0500
Received: from mail-bl2on0129.outbound.protection.outlook.com ([65.55.169.129]:30381
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751902AbbAVIeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:34:10 -0500
X-Greylist: delayed 12240 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jan 2015 03:34:09 EST
From: Robin Gong <b38343@freescale.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>,
        <s.hauer@pengutronix.de>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] dma: imx-sdma: switch to dynamic context mode after script loaded
Date: Thu, 22 Jan 2015 15:23:40 +0800
Message-ID: <1421911420-31821-1-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(243025005)(189002)(199003)(77156002)(62966003)(33646002)(50986999)(97736003)(92566002)(105606002)(106466001)(77096005)(68736005)(104016003)(48376002)(229853001)(36756003)(50466002)(64706001)(15975445007)(50226001)(85426001)(2201001)(46102003)(575784001)(47776003)(19580395003)(19580405001)(6806004)(87936001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB327;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BLUPR03MB327;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR03MB327;
X-Forefront-PRVS: 0464DBBBC4
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB327;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2015 08:34:06.8625
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR03MB327
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
 drivers/dma/imx-sdma.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index d0df198..a95b1d7 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -531,6 +531,10 @@ static int sdma_run_channel0(struct sdma_engine *sdma)
 		dev_err(sdma->dev, "Timeout waiting for CH0 ready\n");
 	}
 
+	/* Set bits of CONFIG register with dynamic context switching */
+	if (readl(SDMA_H_CONFIG_CSM, sdma->regs + SDMA_H_CONFIG) == 0)
+		writel_relaxed(SDMA_H_CONFIG_CSM, sdma->regs + SDMA_H_CONFIG);
+
 	return ret ? 0 : -ETIMEDOUT;
 }
 
@@ -1401,9 +1405,6 @@ static int sdma_init(struct sdma_engine *sdma)
 
 	writel_relaxed(ccb_phys, sdma->regs + SDMA_H_C0PTR);
 
-	/* Set bits of CONFIG register with given context switching mode */
-	writel_relaxed(SDMA_H_CONFIG_CSM, sdma->regs + SDMA_H_CONFIG);
-
 	/* Initializes channel's priorities */
 	sdma_set_channel_priority(&sdma->channel[0], 7);
 
-- 
1.9.1

