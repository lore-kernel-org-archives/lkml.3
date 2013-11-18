Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab3KRKlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 05:41:09 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6541 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab3KRKlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 05:41:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 18 Nov 2013 02:35:13 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] ARM: tegra: properly use FUSE clock
Date: Mon, 18 Nov 2013 19:40:47 +0900
Message-ID: <1384771247-16547-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUSE clock is enabled by most bootloaders, but we cannot expect it to be
on in all contexts (e.g. kexec).

This patch adds a FUSE clkdev to all Tegra platforms and makes sure
it is enabled before touching FUSE registers. tegra_init_fuse() is
invoked during very early boot and thus cannot rely on the clock
framework ; therefore the FUSE clock is forcibly enabled using a
register write in that function, and remains that way until the
clock framework can be used.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/mach-tegra/fuse.c       | 41 +++++++++++++++++++++++++++++++++++++++-
 drivers/clk/tegra/clk-tegra114.c |  1 +
 drivers/clk/tegra/clk-tegra124.c |  1 +
 drivers/clk/tegra/clk-tegra20.c  |  1 +
 4 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c
index 9a4e910c3796..3b9191b930b5 100644
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
+		fuse_clk = clk_get_sys("fuse-tegra", "fuse");
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
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index dbab27f773b5..a83fdfd19bfc 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -925,6 +925,7 @@ static struct tegra_devclk devclks[] __initdata = {
 	{ .con_id = "sclk", .dt_id = TEGRA114_CLK_SCLK },
 	{ .con_id = "hclk", .dt_id = TEGRA114_CLK_HCLK },
 	{ .con_id = "pclk", .dt_id = TEGRA114_CLK_PCLK },
+	{ .con_id = "fuse", .dev_id = "fuse-tegra", .dt_id = TEGRA114_CLK_FUSE },
 	{ .dev_id = "rtc-tegra", .dt_id = TEGRA114_CLK_RTC },
 	{ .dev_id = "timer", .dt_id = TEGRA114_CLK_TIMER },
 };
diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index 266e80b51d38..0a324a2d7309 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -1007,6 +1007,7 @@ static struct tegra_devclk devclks[] __initdata = {
 	{ .con_id = "sclk", .dt_id = TEGRA124_CLK_SCLK },
 	{ .con_id = "hclk", .dt_id = TEGRA124_CLK_HCLK },
 	{ .con_id = "pclk", .dt_id = TEGRA124_CLK_PCLK },
+	{ .con_id = "fuse", .dev_id = "fuse-tegra", .dt_id = TEGRA124_CLK_FUSE },
 	{ .dev_id = "rtc-tegra", .dt_id = TEGRA124_CLK_RTC },
 	{ .dev_id = "timer", .dt_id = TEGRA124_CLK_TIMER },
 };
diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index 58faac5f509e..48dca0f4762a 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -452,6 +452,7 @@ static struct tegra_devclk devclks[] __initdata = {
 	{ .con_id = "sclk", .dt_id = TEGRA20_CLK_SCLK },
 	{ .con_id = "hclk", .dt_id = TEGRA20_CLK_HCLK },
 	{ .con_id = "pclk", .dt_id = TEGRA20_CLK_PCLK },
+	{ .con_id = "fuse", .dev_id = "fuse-tegra", .dt_id = TEGRA20_CLK_FUSE },
 	{ .con_id = "twd", .dt_id = TEGRA20_CLK_TWD },
 	{ .con_id = "audio", .dt_id = TEGRA20_CLK_AUDIO },
 	{ .con_id = "audio_2x", .dt_id = TEGRA20_CLK_AUDIO_2X },
-- 
1.8.4.2

