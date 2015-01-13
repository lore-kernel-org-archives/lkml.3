Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbbAMGTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 01:19:30 -0500
Received: from mail-bn1bon0116.outbound.protection.outlook.com ([157.56.111.116]:47213
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751169AbbAMGT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 01:19:29 -0500
From: Robin Gong <b38343@freescale.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
CC: <s.hauer@pengutronix.de>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v1] dma: imx-sdma: switch to dynamic context mode after script loaded
Date: Tue, 13 Jan 2015 13:09:17 +0800
Message-ID: <1421125757-10794-1-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(243025005)(199003)(106466001)(81156004)(33646002)(575784001)(62966003)(64706001)(46102003)(104016003)(47776003)(15975445007)(36756003)(77096005)(48376002)(68736005)(50466002)(77156002)(19580395003)(19580405001)(6806004)(69596002)(85426001)(87936001)(50226001)(229853001)(105606002)(97736003)(50986999)(92566002)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0638;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:DM2PR0301MB0638;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0301MB0638;
X-Forefront-PRVS: 045584D28C
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0638;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2015 06:19:19.5962
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0301MB0638
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
index d0df198..510e463 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1323,6 +1323,10 @@ static void sdma_load_firmware(const struct firmware *fw, void *context)
 	sdma_load_script(sdma, ram_code,
 			header->ram_code_size,
 			addr->ram_code_start_addr);
+
+	/* Set bits of CONFIG register with given context switching mode */
+	writel_relaxed(SDMA_H_CONFIG_CSM, sdma->regs + SDMA_H_CONFIG);
+
 	clk_disable(sdma->clk_ipg);
 	clk_disable(sdma->clk_ahb);
 
@@ -1401,9 +1405,6 @@ static int sdma_init(struct sdma_engine *sdma)
 
 	writel_relaxed(ccb_phys, sdma->regs + SDMA_H_C0PTR);
 
-	/* Set bits of CONFIG register with given context switching mode */
-	writel_relaxed(SDMA_H_CONFIG_CSM, sdma->regs + SDMA_H_CONFIG);
-
 	/* Initializes channel's priorities */
 	sdma_set_channel_priority(&sdma->channel[0], 7);
 
-- 
1.9.1

