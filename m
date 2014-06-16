Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaFPD3J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 23:29:09 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:21898
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753084AbaFPD27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 23:28:59 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <vinod.koul@intel.com>, <s.hauer@pengutronix.de>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <dan.j.williams@intel.com>,
        <shawn.guo@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>
Subject: [PATCH] dma: imx-sdma: Add a new DMATYPE for Shared Peripheral ASRC
Date: Mon, 16 Jun 2014 11:31:05 +0800
Message-ID: <1402889465-23797-1-git-send-email-nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130473629370877130;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(19580405001)(33646001)(87572001)(87286001)(61266001)(104166001)(86362001)(47776003)(64706001)(85306003)(48376002)(20776003)(81542001)(4396001)(62966002)(55446002)(81442001)(73392001)(79102001)(93916002)(92566001)(102836001)(81342001)(73972005)(50986999)(50466002)(97736001)(50226001)(99396002)(92726001)(74502001)(46102001)(89996001)(74662001)(87936001)(77982001)(84676001)(6806004)(68736004)(88136002)(82202001)(31966008)(85852003)(104016001)(21056001)(36756003)(83072002)(26826002)(80022001)(77156001)(19580395003)(575784001)(44976005);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB396;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0244637DEA
Authentication-Results: spf=softfail (sender IP is 192.88.168.50)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shared Peripheral ASRC, running on SPBA, needs to use shp sciprts for
DMA transfer. So this patch just adds a new DMATYPE for it.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 Documentation/devicetree/bindings/dma/fsl-imx-sdma.txt | 1 +
 drivers/dma/imx-sdma.c                                 | 5 +++++
 include/linux/platform_data/dma-imx.h                  | 1 +
 3 files changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/dma/fsl-imx-sdma.txt b/Documentation/devicetree/bindings/dma/fsl-imx-sdma.txt
index ee9be99..d2e91f1 100644
--- a/Documentation/devicetree/bindings/dma/fsl-imx-sdma.txt
+++ b/Documentation/devicetree/bindings/dma/fsl-imx-sdma.txt
@@ -47,6 +47,7 @@ The full ID of peripheral types can be found below.
 	20	ASRC
 	21	ESAI
 	22	SSI Dual FIFO	(needs firmware ver >= 2)
+	23	Shared ASRC
 
 The third cell specifies the transfer priority as below.
 
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index fc04add..85561dc 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -745,6 +745,11 @@ static void sdma_get_pc(struct sdma_channel *sdmac,
 		emi_2_per = sdma->script_addrs->asrc_2_mcu_addr;
 		per_2_per = sdma->script_addrs->per_2_per_addr;
 		break;
+	case IMX_DMATYPE_ASRC_SP:
+		per_2_emi = sdma->script_addrs->shp_2_mcu_addr;
+		emi_2_per = sdma->script_addrs->mcu_2_shp_addr;
+		per_2_per = sdma->script_addrs->per_2_per_addr;
+		break;
 	case IMX_DMATYPE_MSHC:
 		per_2_emi = sdma->script_addrs->mshc_2_mcu_addr;
 		emi_2_per = sdma->script_addrs->mcu_2_mshc_addr;
diff --git a/include/linux/platform_data/dma-imx.h b/include/linux/platform_data/dma-imx.h
index bcbc6c3..7aa0e89 100644
--- a/include/linux/platform_data/dma-imx.h
+++ b/include/linux/platform_data/dma-imx.h
@@ -40,6 +40,7 @@ enum sdma_peripheral_type {
 	IMX_DMATYPE_ASRC,	/* ASRC */
 	IMX_DMATYPE_ESAI,	/* ESAI */
 	IMX_DMATYPE_SSI_DUAL,	/* SSI Dual FIFO */
+	IMX_DMATYPE_ASRC_SP,	/* Shared ASRC */
 };
 
 enum imx_dma_prio {
-- 
1.8.4

