Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab3E1VnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:43:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59507 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030Ab3E1VVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:21:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Inderpal Singh <inderpal.singh@linaro.org>,
        Boojin Kim <boojin.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 02/78] ARM: S5PV210: Fix PL330 DMA controller clkdev entries
Date: Tue, 28 May 2013 14:19:11 -0700
Message-Id: <1369776027-17859-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>

commit b83e831a3c2d358fea4bf8fa13f387405f2880b6 upstream.

Since the DMA controller clocks are managed at amba bus level, the
PL330 device clocks handling has been removed from the driver in
commit 7c71b8eb("DMA: PL330: Remove redundant runtime_suspend/
resume functions")

However, this left the S5PV210 platform with only clkdev entries
linking "apb_pclk" clock conn_id to a dummy clock, rather than
to corresponding platform PL330 DMAC clock.
As a result the DMA controller is now attempted to be used on
S5PV210 with the clock disabled and the driver fails with an
error:

dma-pl330 dma-pl330.0: PERIPH_ID 0x0, PCELL_ID 0x0 !
dma-pl330: probe of dma-pl330.0 failed with error -22
dma-pl330 dma-pl330.1: PERIPH_ID 0x0, PCELL_ID 0x0 !
dma-pl330: probe of dma-pl330.1 failed with error -22

Fix this by adding "apb_pclk" clkdev entries for the Peripheral
DMA controllers 0/1 and removing the dummy apb_pclk clock.

Reported-by: Lonsn <lonsn2005@gmail.com>
Tested-by: Lonsn <lonsn2005@gmail.com>
Cc: Inderpal Singh <inderpal.singh@linaro.org>
Cc: Boojin Kim <boojin.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-s5pv210/clock.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/arm/mach-s5pv210/clock.c b/arch/arm/mach-s5pv210/clock.c
index fcdf52d..f051f53 100644
--- a/arch/arm/mach-s5pv210/clock.c
+++ b/arch/arm/mach-s5pv210/clock.c
@@ -214,11 +214,6 @@ static struct clk clk_pcmcdclk2 = {
 	.name		= "pcmcdclk",
 };
 
-static struct clk dummy_apb_pclk = {
-	.name		= "apb_pclk",
-	.id		= -1,
-};
-
 static struct clk *clkset_vpllsrc_list[] = {
 	[0] = &clk_fin_vpll,
 	[1] = &clk_sclk_hdmi27m,
@@ -305,18 +300,6 @@ static struct clk_ops clk_fout_apll_ops = {
 
 static struct clk init_clocks_off[] = {
 	{
-		.name		= "dma",
-		.devname	= "dma-pl330.0",
-		.parent		= &clk_hclk_psys.clk,
-		.enable		= s5pv210_clk_ip0_ctrl,
-		.ctrlbit	= (1 << 3),
-	}, {
-		.name		= "dma",
-		.devname	= "dma-pl330.1",
-		.parent		= &clk_hclk_psys.clk,
-		.enable		= s5pv210_clk_ip0_ctrl,
-		.ctrlbit	= (1 << 4),
-	}, {
 		.name		= "rot",
 		.parent		= &clk_hclk_dsys.clk,
 		.enable		= s5pv210_clk_ip0_ctrl,
@@ -573,6 +556,20 @@ static struct clk clk_hsmmc3 = {
 	.ctrlbit	= (1<<19),
 };
 
+static struct clk clk_pdma0 = {
+	.name		= "pdma0",
+	.parent		= &clk_hclk_psys.clk,
+	.enable		= s5pv210_clk_ip0_ctrl,
+	.ctrlbit	= (1 << 3),
+};
+
+static struct clk clk_pdma1 = {
+	.name		= "pdma1",
+	.parent		= &clk_hclk_psys.clk,
+	.enable		= s5pv210_clk_ip0_ctrl,
+	.ctrlbit	= (1 << 4),
+};
+
 static struct clk *clkset_uart_list[] = {
 	[6] = &clk_mout_mpll.clk,
 	[7] = &clk_mout_epll.clk,
@@ -1075,6 +1072,8 @@ static struct clk *clk_cdev[] = {
 	&clk_hsmmc1,
 	&clk_hsmmc2,
 	&clk_hsmmc3,
+	&clk_pdma0,
+	&clk_pdma1,
 };
 
 /* Clock initialisation code */
@@ -1333,6 +1332,8 @@ static struct clk_lookup s5pv210_clk_lookup[] = {
 	CLKDEV_INIT(NULL, "spi_busclk0", &clk_p),
 	CLKDEV_INIT("s5pv210-spi.0", "spi_busclk1", &clk_sclk_spi0.clk),
 	CLKDEV_INIT("s5pv210-spi.1", "spi_busclk1", &clk_sclk_spi1.clk),
+	CLKDEV_INIT("dma-pl330.0", "apb_pclk", &clk_pdma0),
+	CLKDEV_INIT("dma-pl330.1", "apb_pclk", &clk_pdma1),
 };
 
 void __init s5pv210_register_clocks(void)
@@ -1361,6 +1362,5 @@ void __init s5pv210_register_clocks(void)
 	for (ptr = 0; ptr < ARRAY_SIZE(clk_cdev); ptr++)
 		s3c_disable_clocks(clk_cdev[ptr], 1);
 
-	s3c24xx_register_clock(&dummy_apb_pclk);
 	s3c_pwmclk_init();
 }
-- 
1.8.1.2

