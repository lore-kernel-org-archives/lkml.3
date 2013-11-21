Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab3KUCm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 21:42:28 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2909 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab3KUCmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 21:42:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 20 Nov 2013 18:36:22 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v2] ARM: tegra: switch FUSE clock on before usage
Date: Thu, 21 Nov 2013 11:40:13 +0900
Message-ID: <1385001613-19098-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUSE clock is enabled by most bootloaders, but we cannot expect it to be
on in all contexts (e.g. kexec).

Ensure the FUSE clock is enabled before any of its registers is touched.
Since FUSE is touched very early during system boot (before the clock
devices are registered), directly manipulate the clock register bit in
case the clock device cannot be acquired.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
--
Changelog since v1:
- Moved clock device definition into another patch
- Kept the initial idea of enabling the fuse clock at init and keeping
  it that way until the clock framework takes it over. The reason is
  that exported functions might be called from tegra_init_fuse() that
  acquire the clock (e.g. tegra_get_revision()). Since we don't have
  any enable counter here, the clock would be disabled earlier than we
  want if we were to allow disabling of the clock before the clock
  framework is available.
---
 arch/arm/mach-tegra/fuse.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c
index 9a4e910c3796..2adc2ab081e2 100644
--- a/arch/arm/mach-tegra/fuse.c
+++ b/arch/arm/mach-tegra/fuse.c
@@ -22,6 +22,7 @@
 #include <linux/io.h>
 #include <linux/export.h>
 #include <linux/random.h>
+#include <linux/clk.h>
 #include <linux/tegra-soc.h>
 
 #include "fuse.h"
@@ -54,6 +55,7 @@ int tegra_cpu_speedo_id;		/* only exist in Tegra30 and later */
 int tegra_soc_speedo_id;
 enum tegra_revision tegra_revision;
 
+static struct clk *fuse_clk;
 static int tegra_fuse_spare_bit;
 static void (*tegra_init_speedo_data)(void);
 
@@ -77,6 +79,22 @@ static const char *tegra_revision_name[TEGRA_REVISION_MAX] = {
 	[TEGRA_REVISION_A04]     = "A04",
 };
 
+static void tegra_fuse_enable_clk(void)
+{
+	if (IS_ERR(fuse_clk))
+		fuse_clk = clk_get_sys(NULL, "fuse");
+	if (IS_ERR(fuse_clk))
+		return;
+	clk_prepare_enable(fuse_clk);
+}
+
+static void tegra_fuse_disable_clk(void)
+{
+	if (IS_ERR(fuse_clk))
+		return;
+	clk_disable_unprepare(fuse_clk);
+}
+
 u32 tegra_fuse_readl(unsigned long offset)
 {
 	return tegra_apb_readl(TEGRA_FUSE_BASE + offset);
@@ -84,7 +102,15 @@ u32 tegra_fuse_readl(unsigned long offset)
 
 bool tegra_spare_fuse(int bit)
 {
-	return tegra_fuse_readl(tegra_fuse_spare_bit + bit * 4);
+	bool ret;
+
+	tegra_fuse_enable_clk();
+
+	ret = tegra_fuse_readl(tegra_fuse_spare_bit + bit * 4);
+
+	tegra_fuse_disable_clk();
+
+	return ret;
 }
 
 static enum tegra_revision tegra_get_revision(u32 id)
@@ -113,10 +139,14 @@ static void tegra_get_process_id(void)
 {
 	u32 reg;
 
+	tegra_fuse_enable_clk();
+
 	reg = tegra_fuse_readl(tegra_fuse_spare_bit);
 	tegra_cpu_process_id = (reg >> 6) & 3;
 	reg = tegra_fuse_readl(tegra_fuse_spare_bit);
 	tegra_core_process_id = (reg >> 12) & 3;
+
+	tegra_fuse_disable_clk();
 }
 
 u32 tegra_read_chipid(void)
@@ -159,6 +189,15 @@ void __init tegra_init_fuse(void)
 	reg |= 1 << 28;
 	writel(reg, IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x48));
 
+	/*
+	 * Enable FUSE clock. This needs to be hardcoded because the clock
+	 * subsystem is not active during early boot.
+	 */
+	reg = readl(IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x14));
+	reg |= 1 << 7;
+	writel(reg, IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x14));
+	fuse_clk = ERR_PTR(-EINVAL);
+
 	reg = tegra_fuse_readl(FUSE_SKU_INFO);
 	randomness[0] = reg;
 	tegra_sku_id = reg & 0xFF;
-- 
1.8.4.2

