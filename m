Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbaC0AHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 20:07:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55020 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756684AbaC0AG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 20:06:58 -0400
From: Felipe Balbi <balbi@ti.com>
To: Balaji T K <balajitk@ti.com>
CC: <chris@printf.net>, <ulf.hansson@linaro.org>, <linux-mmc@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 5/5] mmc: host: omap_hsmmc: set max_blk_size correctly
Date: Wed, 26 Mar 2014 19:04:50 -0500
Message-ID: <1395878690-9650-6-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.1.286.g5172cb3
In-Reply-To: <1395878690-9650-1-git-send-email-balbi@ti.com>
References: <1395878690-9650-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

now that we can finally read the new registers for
new versions of the mmc IP, we can set max_blk_size
correctly depending on the version of the IP we're
running on.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mmc/host/omap_hsmmc.c | 45 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index d32f6ac..ae5583e 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -62,6 +62,18 @@
 #define OMAP_HSMMC_AC12		0x013C
 #define OMAP_HSMMC_CAPA		0x0140
 
+/* OMAP HSMMC Host Controller Register (NEW)
+ *
+ * NOTE: DO NOT READ THESE WITH OFFSET
+ */
+#define OMAP_HSMMC_HL_REV	0x0000
+#define OMAP_HSMMC_HL_HWINFO	0x0004
+#	define OMAP_HSMMC_HL_HWINFO_MADMA_EN	(1 << 0)
+#	define OMAP_HSMMC_HL_HWINFO_MERGE_MEM	(1 << 1)
+#	define OMAP_HSMMC_HL_HWINFO_MEM_SIZE(x)	(((x) & (0x0f << 2)) >> 2)
+#	define OMAP_HSMMC_HL_HWINFO_RETMODE	(1 << 6)
+#define OMAP_HSMMC_HL_SYSCONFIG	0x0010
+
 #define VS18			(1 << 26)
 #define VS30			(1 << 25)
 #define HSS			(1 << 21)
@@ -1867,6 +1879,37 @@ static inline struct omap_mmc_platform_data
 }
 #endif
 
+static void omap_hsmmc_set_max_blk_size(struct omap_hsmmc_host *host)
+{
+	struct mmc_host *mmc = host->mmc;
+
+	if (of_device_is_compatible(host->dev->of_node, "ti,omap4-hsmmc")) {
+		u32 mem;
+		u32 reg;
+
+		reg = omap_hsmmc_read_no_offset(host, OMAP_HSMMC_HL_HWINFO);
+		mem = OMAP_HSMMC_HL_HWINFO_MEM_SIZE(reg);
+
+		switch (mem) {
+		case 1:
+			mmc->max_blk_size = 512;
+			break;
+		case 2:
+			mmc->max_blk_size = 1024;
+			break;
+		case 4:
+			/* FALLTHROUGH */
+		case 8:
+			/* FALLTHROUGH */
+		default:
+			mmc->max_blk_size = 2048;
+			break;
+		}
+	} else {
+		mmc->max_blk_size = 512;       /* Block Length at max can be 1024 */
+	}
+}
+
 static int omap_hsmmc_probe(struct platform_device *pdev)
 {
 	struct omap_mmc_platform_data *pdata = pdev->dev.platform_data;
@@ -1986,7 +2029,7 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 	 * as we want. */
 	mmc->max_segs = 1024;
 
-	mmc->max_blk_size = 512;       /* Block Length at max can be 1024 */
+	omap_hsmmc_set_max_blk_size(host);
 	mmc->max_blk_count = 0xFFFF;    /* No. of Blocks is 16 bits */
 	mmc->max_req_size = mmc->max_blk_size * mmc->max_blk_count;
 	mmc->max_seg_size = mmc->max_req_size;
-- 
1.9.1.286.g5172cb3

