Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175AbaJUOrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:47:33 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:54875 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353AbaJUOra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:47:30 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-tegra@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/12] soc/tegra: Add ram code reader helper
Date: Tue, 21 Oct 2014 16:45:35 +0200
Message-Id: <1413902788-7727-4-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413902788-7727-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1413902788-7727-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikko Perttunen <mperttunen@nvidia.com>

Needed for the EMC and MC drivers to know what timings from the DT to use.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/soc/tegra/fuse/tegra-apbmisc.c | 19 +++++++++++++++++++
 include/soc/tegra/fuse.h               |  1 +
 2 files changed, 20 insertions(+)

diff --git a/drivers/soc/tegra/fuse/tegra-apbmisc.c b/drivers/soc/tegra/fuse/tegra-apbmisc.c
index 3bf5aba..e580892 100644
--- a/drivers/soc/tegra/fuse/tegra-apbmisc.c
+++ b/drivers/soc/tegra/fuse/tegra-apbmisc.c
@@ -28,8 +28,13 @@
 #define APBMISC_SIZE	0x64
 #define FUSE_SKU_INFO	0x10
 
+#define PMC_STRAPPING_OPT_A_RAM_CODE_MASK_LONG	(0xf << 4)
+#define PMC_STRAPPING_OPT_A_RAM_CODE_MASK_SHORT	(0x3 << 4)
+#define PMC_STRAPPING_OPT_A_RAM_CODE_SHIFT	4
+
 static void __iomem *apbmisc_base;
 static void __iomem *strapping_base;
+static bool          long_ram_code;
 
 u32 tegra_read_chipid(void)
 {
@@ -54,6 +59,18 @@ u32 tegra_read_straps(void)
 		return 0;
 }
 
+u32 tegra_read_ram_code(void)
+{
+	u32 straps = tegra_read_straps();
+
+	if (long_ram_code)
+		straps &= PMC_STRAPPING_OPT_A_RAM_CODE_MASK_LONG;
+	else
+		straps &= PMC_STRAPPING_OPT_A_RAM_CODE_MASK_SHORT;
+
+	return straps >> PMC_STRAPPING_OPT_A_RAM_CODE_SHIFT;
+}
+
 static const struct of_device_id apbmisc_match[] __initconst = {
 	{ .compatible = "nvidia,tegra20-apbmisc", },
 	{},
@@ -112,4 +129,6 @@ void __init tegra_init_apbmisc(void)
 	strapping_base = of_iomap(np, 1);
 	if (!strapping_base)
 		pr_err("ioremap tegra strapping_base failed\n");
+
+	long_ram_code = of_property_read_bool(np, "nvidia,long-ram-code");
 }
diff --git a/include/soc/tegra/fuse.h b/include/soc/tegra/fuse.h
index 8e12494..4ad6fd9 100644
--- a/include/soc/tegra/fuse.h
+++ b/include/soc/tegra/fuse.h
@@ -55,6 +55,7 @@ struct tegra_sku_info {
 };
 
 u32 tegra_read_straps(void);
+u32 tegra_read_ram_code(void);
 u32 tegra_read_chipid(void);
 int tegra_fuse_readl(unsigned long offset, u32 *value);
 
-- 
1.9.3

