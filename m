Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab3FDT0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 15:26:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52438 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3FDTZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 15:25:43 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 10/12] ARM: msm: Prepare clk_get() users in mach-msm for clock-pcom driver
Date: Tue,  4 Jun 2013 12:25:36 -0700
Message-Id: <1370373938-32417-11-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc3.8.g5e49f30.dirty
In-Reply-To: <1370373938-32417-1-git-send-email-sboyd@codeaurora.org>
References: <1370373938-32417-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the near future we'll be moving clock-pcom to a platform
driver, in which case these two users of clk_get() in mach-msm
need to be updated. Have board-trout-panel.c make the proc_comm
call directly so that we don't have to port this board specific
code to the driver right now and reorder the initcall order of
dma.c so that it initializes after the clock driver probes but
before any drivers use dma APIs.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/Makefile            |  9 ++++++---
 arch/arm/mach-msm/board-trout-panel.c | 19 +++++++------------
 arch/arm/mach-msm/dma.c               |  5 ++---
 3 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 17519fa..3dbae74 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -5,12 +5,15 @@ obj-$(CONFIG_DEBUG_FS) += clock-debug.o
 obj-$(CONFIG_MSM_VIC) += irq-vic.o
 obj-$(CONFIG_MSM_IOMMU) += devices-iommu.o
 
-obj-$(CONFIG_ARCH_MSM7X00A) += dma.o irq.o
-obj-$(CONFIG_ARCH_MSM7X30) += dma.o
-obj-$(CONFIG_ARCH_QSD8X50) += dma.o sirc.o
+obj-$(CONFIG_ARCH_MSM7X00A) += irq.o
+obj-$(CONFIG_ARCH_QSD8X50) += sirc.o
 
 obj-$(CONFIG_MSM_PROC_COMM) += proc_comm.o clock-pcom.o vreg.o
 
+obj-$(CONFIG_ARCH_MSM7X00A) += dma.o
+obj-$(CONFIG_ARCH_MSM7X30) += dma.o
+obj-$(CONFIG_ARCH_QSD8X50) += dma.o
+
 obj-$(CONFIG_MSM_SMD) += smd.o smd_debug.o
 obj-$(CONFIG_MSM_SMD) += last_radio_log.o
 obj-$(CONFIG_MSM_SCM) += scm.o scm-boot.o
diff --git a/arch/arm/mach-msm/board-trout-panel.c b/arch/arm/mach-msm/board-trout-panel.c
index f9a5db6..77b0a26 100644
--- a/arch/arm/mach-msm/board-trout-panel.c
+++ b/arch/arm/mach-msm/board-trout-panel.c
@@ -7,7 +7,6 @@
 #include <linux/platform_device.h>
 #include <linux/delay.h>
 #include <linux/leds.h>
-#include <linux/clk.h>
 #include <linux/err.h>
 
 #include <asm/io.h>
@@ -19,6 +18,7 @@
 
 #include "board-trout.h"
 #include "proc_comm.h"
+#include "clock-pcom.h"
 #include "devices.h"
 
 #define TROUT_DEFAULT_BACKLIGHT_BRIGHTNESS 255
@@ -170,7 +170,6 @@ static struct mddi_table mddi_toshiba_init_table[] = {
 #define INTMASK_VWAKEOUT (1U << 0)
 
 
-static struct clk *gp_clk;
 static int trout_new_backlight = 1;
 static struct vreg *vreg_mddi_1v5;
 static struct vreg *vreg_lcm_2v85;
@@ -273,18 +272,14 @@ int __init trout_init_panel(void)
 	} else {
 		uint32_t config = PCOM_GPIO_CFG(27, 1, GPIO_OUTPUT,
 						GPIO_NO_PULL, GPIO_8MA);
+		uint32_t id = P_GP_CLK;
+		uint32_t rate = 19200000;
+
 		msm_proc_comm(PCOM_RPC_GPIO_TLMM_CONFIG_EX, &config, 0);
 
-		gp_clk = clk_get(NULL, "gp_clk");
-		if (IS_ERR(gp_clk)) {
-			printk(KERN_ERR "trout_init_panel: could not get gp"
-			       "clock\n");
-			gp_clk = NULL;
-		}
-		rc = clk_set_rate(gp_clk, 19200000);
-		if (rc)
-			printk(KERN_ERR "trout_init_panel: set clock rate "
-			       "failed\n");
+		msm_proc_comm(PCOM_CLKCTL_RPC_SET_RATE, &id, &rate);
+		if (id < 0)
+			pr_err("trout_init_panel: set clock rate failed\n");
 	}
 
 	rc = platform_device_register(&msm_device_mdp);
diff --git a/arch/arm/mach-msm/dma.c b/arch/arm/mach-msm/dma.c
index b279fd8..f8f6adf 100644
--- a/arch/arm/mach-msm/dma.c
+++ b/arch/arm/mach-msm/dma.c
@@ -284,6 +284,7 @@ static int __init msm_init_datamover(void)
 	clk = clk_get(NULL, "adm_clk");
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
+	clk_prepare(clk);
 	msm_dmov_clk = clk;
 	ret = request_irq(INT_ADM_AARM, msm_datamover_irq_handler, 0, "msmdatamover", NULL);
 	if (ret)
@@ -291,6 +292,4 @@ static int __init msm_init_datamover(void)
 	disable_irq(INT_ADM_AARM);
 	return 0;
 }
-
-arch_initcall(msm_init_datamover);
-
+module_init(msm_init_datamover);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

