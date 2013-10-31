Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab3JaGdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:33:10 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:54316 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753183Ab3JaGdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:33:07 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
From: Nicolin Chen <b42378@freescale.com>
To: <s.hauer@pengutronix.de>, <timur@tabi.org>, <shawn.guo@linaro.org>,
        <broonie@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <rob.herring@calxeda.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>
Subject: [PATCH v2 1/4] dma: imx-sdma: Add sdma firmware version 2 support
Date: Thu, 31 Oct 2013 14:32:03 +0800
Message-ID: <cfe6edbff010aefc8a35df8a719b26bd238cb3cc.1383197521.git.b42378@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1383197521.git.b42378@freescale.com>
References: <cover.1383197521.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On i.MX5/6 series, SDMA is using new version firmware to support SSI
dual FIFO feature and HDMI Audio (i.MX6Q/DL only). Thus add it.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
---
 drivers/dma/imx-sdma.c                     | 15 ++++++++++++++-
 include/linux/platform_data/dma-imx-sdma.h |  3 +++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index fc43603..c7ece8d 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -323,6 +323,7 @@ struct sdma_engine {
 	struct clk			*clk_ipg;
 	struct clk			*clk_ahb;
 	spinlock_t			channel_0_lock;
+	u32				script_number;
 	struct sdma_script_start_addrs	*script_addrs;
 	const struct sdma_driver_data	*drvdata;
 };
@@ -1238,6 +1239,7 @@ static void sdma_issue_pending(struct dma_chan *chan)
 }
 
 #define SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V1	34
+#define SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V2	38
 
 static void sdma_add_scripts(struct sdma_engine *sdma,
 		const struct sdma_script_start_addrs *addr)
@@ -1246,7 +1248,7 @@ static void sdma_add_scripts(struct sdma_engine *sdma,
 	s32 *saddr_arr = (u32 *)sdma->script_addrs;
 	int i;
 
-	for (i = 0; i < SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V1; i++)
+	for (i = 0; i < sdma->script_number; i++)
 		if (addr_arr[i] > 0)
 			saddr_arr[i] = addr_arr[i];
 }
@@ -1272,6 +1274,17 @@ static void sdma_load_firmware(const struct firmware *fw, void *context)
 		goto err_firmware;
 	if (header->ram_code_start + header->ram_code_size > fw->size)
 		goto err_firmware;
+	switch (header->version_major) {
+		case 1:
+			sdma->script_number = SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V1;
+			break;
+		case 2:
+			sdma->script_number = SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V2;
+			break;
+		default:
+			dev_err(sdma->dev, "unknown firmware version\n");
+			return;
+	}
 
 	addr = (void *)header + header->script_addrs_start;
 	ram_code = (void *)header + header->ram_code_start;
diff --git a/include/linux/platform_data/dma-imx-sdma.h b/include/linux/platform_data/dma-imx-sdma.h
index 3a39428..14ca582 100644
--- a/include/linux/platform_data/dma-imx-sdma.h
+++ b/include/linux/platform_data/dma-imx-sdma.h
@@ -43,6 +43,9 @@ struct sdma_script_start_addrs {
 	s32 dptc_dvfs_addr;
 	s32 utra_addr;
 	s32 ram_code_start_addr;
+	s32 mcu_2_ssish_addr;
+	s32 ssish_2_mcu_addr;
+	s32 hdmi_dma_addr;
 };
 
 /**
-- 
1.8.4


