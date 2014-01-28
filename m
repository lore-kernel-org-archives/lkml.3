Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbaA1Xgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:36:47 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19778 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbaA1Xgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:36:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 28 Jan 2014 15:35:25 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH v3 1/6] ARM: tegra: export apb dma readl/writel
Date: Wed, 29 Jan 2014 01:36:11 +0200
Message-ID: <1390952176-30402-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1390952176-30402-1-git-send-email-pdeschrijver@nvidia.com>
References: <1390952176-30402-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export APB DMA readl and writel. These are needed because we can't access
the fuses directly on Tegra20 without potentially causing a system hang.
Also have the APB DMA readl and writel return an error in case of a read
failure instead of just returning zero or ignore write failures.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/apbio.c |   51 ++++++++++++++++++++++++++----------------
 include/linux/tegra-soc.h   |   14 +++++++++++
 2 files changed, 45 insertions(+), 20 deletions(-)

diff --git a/arch/arm/mach-tegra/apbio.c b/arch/arm/mach-tegra/apbio.c
index bc47197..e0bf49d 100644
--- a/arch/arm/mach-tegra/apbio.c
+++ b/arch/arm/mach-tegra/apbio.c
@@ -32,8 +32,8 @@ static u32 *tegra_apb_bb;
 static dma_addr_t tegra_apb_bb_phys;
 static DECLARE_COMPLETION(tegra_apb_wait);
 
-static u32 tegra_apb_readl_direct(unsigned long offset);
-static void tegra_apb_writel_direct(u32 value, unsigned long offset);
+static int tegra_apb_readl_direct(unsigned long offset, u32 *value);
+static int tegra_apb_writel_direct(u32 value, unsigned long offset);
 
 static struct dma_chan *tegra_apb_dma_chan;
 static struct dma_slave_config dma_sconfig;
@@ -128,58 +128,64 @@ static int do_dma_transfer(unsigned long apb_add,
 	return 0;
 }
 
-static u32 tegra_apb_readl_using_dma(unsigned long offset)
+int tegra_apb_readl_using_dma(unsigned long offset, u32 *value)
 {
 	int ret;
 
 	if (!tegra_apb_dma_chan && !tegra_apb_dma_init())
-		return tegra_apb_readl_direct(offset);
+		return tegra_apb_readl_direct(offset, value);
 
 	mutex_lock(&tegra_apb_dma_lock);
 	ret = do_dma_transfer(offset, DMA_DEV_TO_MEM);
-	if (ret < 0) {
+	if (ret < 0)
 		pr_err("error in reading offset 0x%08lx using dma\n", offset);
-		*(u32 *)tegra_apb_bb = 0;
-	}
+	else
+		*value = *tegra_apb_bb;
+
 	mutex_unlock(&tegra_apb_dma_lock);
-	return *((u32 *)tegra_apb_bb);
+
+	return ret;
 }
 
-static void tegra_apb_writel_using_dma(u32 value, unsigned long offset)
+int tegra_apb_writel_using_dma(u32 value, unsigned long offset)
 {
 	int ret;
 
-	if (!tegra_apb_dma_chan && !tegra_apb_dma_init()) {
-		tegra_apb_writel_direct(value, offset);
-		return;
-	}
+	if (!tegra_apb_dma_chan && !tegra_apb_dma_init())
+		return tegra_apb_writel_direct(value, offset);
 
 	mutex_lock(&tegra_apb_dma_lock);
 	*((u32 *)tegra_apb_bb) = value;
 	ret = do_dma_transfer(offset, DMA_MEM_TO_DEV);
+	mutex_unlock(&tegra_apb_dma_lock);
 	if (ret < 0)
 		pr_err("error in writing offset 0x%08lx using dma\n", offset);
-	mutex_unlock(&tegra_apb_dma_lock);
+
+	return ret;
 }
 #else
 #define tegra_apb_readl_using_dma tegra_apb_readl_direct
 #define tegra_apb_writel_using_dma tegra_apb_writel_direct
 #endif
 
-typedef u32 (*apbio_read_fptr)(unsigned long offset);
-typedef void (*apbio_write_fptr)(u32 value, unsigned long offset);
+typedef int (*apbio_read_fptr)(unsigned long offset, u32 *value);
+typedef int (*apbio_write_fptr)(u32 value, unsigned long offset);
 
 static apbio_read_fptr apbio_read;
 static apbio_write_fptr apbio_write;
 
-static u32 tegra_apb_readl_direct(unsigned long offset)
+static int tegra_apb_readl_direct(unsigned long offset, u32 *value)
 {
-	return readl(IO_ADDRESS(offset));
+	*value = readl(IO_ADDRESS(offset));
+
+	return 0;
 }
 
-static void tegra_apb_writel_direct(u32 value, unsigned long offset)
+static int tegra_apb_writel_direct(u32 value, unsigned long offset)
 {
 	writel(value, IO_ADDRESS(offset));
+
+	return 0;
 }
 
 void tegra_apb_io_init(void)
@@ -197,7 +203,12 @@ void tegra_apb_io_init(void)
 
 u32 tegra_apb_readl(unsigned long offset)
 {
-	return apbio_read(offset);
+	u32 val;
+
+	if (apbio_read(offset, &val) < 0)
+		return 0;
+	else
+		return val;
 }
 
 void tegra_apb_writel(u32 value, unsigned long offset)
diff --git a/include/linux/tegra-soc.h b/include/linux/tegra-soc.h
index 95f611d..b02d73b 100644
--- a/include/linux/tegra-soc.h
+++ b/include/linux/tegra-soc.h
@@ -19,4 +19,18 @@
 
 u32 tegra_read_chipid(void);
 
+
+#if defined(CONFIG_TEGRA20_APB_DMA)
+int tegra_apb_readl_using_dma(unsigned long offset, u32 *value);
+int tegra_apb_writel_using_dma(u32 value, unsigned long offset);
+#else
+static inline int tegra_apb_readl_using_dma(unsigned long offset, u32 *value)
+{
+	return -EINVAL;
+}
+static inline int tegra_apb_writel_using_dma(u32 value, unsigned long offset)
+{
+	return -EINVAL;
+}
+#endif
 #endif /* __LINUX_TEGRA_SOC_H_ */
-- 
1.7.7.rc0.72.g4b5ea.dirty

