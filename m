Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab3J2Mdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 08:33:42 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:45766
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752620Ab3J2Md2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 08:33:28 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
From: Nicolin Chen <b42378@freescale.com>
To: <timur@tabi.org>, <shawn.guo@linaro.org>, <broonie@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <rob.herring@calxeda.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <s.hauer@pengutronix.de>,
        <b32955@freescale.com>
Subject: [PATCH 1/3] dma: imx-sdma: Add ssi dual fifo script support
Date: Tue, 29 Oct 2013 20:33:15 +0800
Message-ID: <9ed025d4e98f716ba80b27acaaa98f43ad3bd75a.1383047327.git.b42378@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1383047327.git.b42378@freescale.com>
References: <cover.1383047327.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a script for SSI missing in current sdma script list. Thus add it.
This script would allow SSI use its dual fifo mode to transimit/receive
data without occasional hardware underrun/overrun.

This patch also fixed a counting error for total number of scripts.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
---
 Documentation/devicetree/bindings/dma/fsl-imx-sdma.txt | 1 +
 drivers/dma/imx-sdma.c                                 | 6 +++++-
 include/linux/platform_data/dma-imx-sdma.h             | 2 ++
 include/linux/platform_data/dma-imx.h                  | 1 +
 4 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/dma/fsl-imx-sdma.txt b/Documentation/devicetree/bindings/dma/fsl-imx-sdma.txt
index 4fa814d..3b933c5 100644
--- a/Documentation/devicetree/bindings/dma/fsl-imx-sdma.txt
+++ b/Documentation/devicetree/bindings/dma/fsl-imx-sdma.txt
@@ -42,6 +42,7 @@ The full ID of peripheral types can be found below.
 	19	IPU Memory
 	20	ASRC
 	21	ESAI
+	22	SSI Dual FIFO
 
 The third cell specifies the transfer priority as below.
 
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index fc43603..695871f 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -724,6 +724,10 @@ static void sdma_get_pc(struct sdma_channel *sdmac,
 		per_2_emi = sdma->script_addrs->app_2_mcu_addr;
 		emi_2_per = sdma->script_addrs->mcu_2_app_addr;
 		break;
+	case IMX_DMATYPE_SSI_DUAL:
+		per_2_emi = sdma->script_addrs->ssish_2_mcu_addr;
+		emi_2_per = sdma->script_addrs->mcu_2_ssish_addr;
+		break;
 	case IMX_DMATYPE_SSI_SP:
 	case IMX_DMATYPE_MMC:
 	case IMX_DMATYPE_SDHC:
@@ -1237,7 +1241,7 @@ static void sdma_issue_pending(struct dma_chan *chan)
 		sdma_enable_channel(sdma, sdmac->channel);
 }
 
-#define SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V1	34
+#define SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V1	37
 
 static void sdma_add_scripts(struct sdma_engine *sdma,
 		const struct sdma_script_start_addrs *addr)
diff --git a/include/linux/platform_data/dma-imx-sdma.h b/include/linux/platform_data/dma-imx-sdma.h
index 3a39428..19cfa9a 100644
--- a/include/linux/platform_data/dma-imx-sdma.h
+++ b/include/linux/platform_data/dma-imx-sdma.h
@@ -43,6 +43,8 @@ struct sdma_script_start_addrs {
 	s32 dptc_dvfs_addr;
 	s32 utra_addr;
 	s32 ram_code_start_addr;
+	s32 mcu_2_ssish_addr;
+	s32 ssish_2_mcu_addr;
 };
 
 /**
diff --git a/include/linux/platform_data/dma-imx.h b/include/linux/platform_data/dma-imx.h
index beac6b8..bcbc6c3 100644
--- a/include/linux/platform_data/dma-imx.h
+++ b/include/linux/platform_data/dma-imx.h
@@ -39,6 +39,7 @@ enum sdma_peripheral_type {
 	IMX_DMATYPE_IPU_MEMORY,	/* IPU Memory */
 	IMX_DMATYPE_ASRC,	/* ASRC */
 	IMX_DMATYPE_ESAI,	/* ESAI */
+	IMX_DMATYPE_SSI_DUAL,	/* SSI Dual FIFO */
 };
 
 enum imx_dma_prio {
-- 
1.8.4


