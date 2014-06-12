Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbaFLPmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:42:20 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19355 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968AbaFLPmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:42:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 12 Jun 2014 08:36:59 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Joseph Lo <josephl@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Olof Johansson <olof@lixom.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 6/6] misc: fuse: move APB DMA into Tegra20 fuse driver
Date: Thu, 12 Jun 2014 18:36:40 +0300
Message-ID: <1402587400-1544-7-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1402587400-1544-1-git-send-email-pdeschrijver@nvidia.com>
References: <1402587400-1544-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tegra20 fuse driver is the only user of tegra_apb_readl_using_dma().
Therefore we can simply the code by incorporating the APB DMA handling into
the driver directly. tegra_apb_writel_using_dma() is dropped because there
are no users.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/Makefile           |    1 -
 arch/arm/mach-tegra/apbio.c            |  217 --------------------------------
 arch/arm/mach-tegra/apbio.h            |   22 ----
 arch/arm/mach-tegra/tegra.c            |    2 -
 drivers/misc/fuse/tegra/fuse-tegra20.c |   79 +++++++++++-
 include/linux/tegra-soc.h              |   14 --
 6 files changed, 76 insertions(+), 259 deletions(-)
 delete mode 100644 arch/arm/mach-tegra/apbio.c
 delete mode 100644 arch/arm/mach-tegra/apbio.h

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index e8601bb..c303b55 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -5,7 +5,6 @@ obj-y                                   += irq.o
 obj-y					+= pmc.o
 obj-y					+= flowctrl.o
 obj-y					+= powergate.o
-obj-y					+= apbio.o
 obj-y					+= pm.o
 obj-y					+= reset.o
 obj-y					+= reset-handler.o
diff --git a/arch/arm/mach-tegra/apbio.c b/arch/arm/mach-tegra/apbio.c
deleted file mode 100644
index e0bf49d..0000000
--- a/arch/arm/mach-tegra/apbio.c
+++ /dev/null
@@ -1,217 +0,0 @@
-/*
- * Copyright (C) 2010 NVIDIA Corporation.
- * Copyright (C) 2010 Google, Inc.
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/io.h>
-#include <linux/of.h>
-#include <linux/dmaengine.h>
-#include <linux/dma-mapping.h>
-#include <linux/spinlock.h>
-#include <linux/completion.h>
-#include <linux/sched.h>
-#include <linux/mutex.h>
-
-#include "apbio.h"
-#include "iomap.h"
-
-#if defined(CONFIG_TEGRA20_APB_DMA)
-static DEFINE_MUTEX(tegra_apb_dma_lock);
-static u32 *tegra_apb_bb;
-static dma_addr_t tegra_apb_bb_phys;
-static DECLARE_COMPLETION(tegra_apb_wait);
-
-static int tegra_apb_readl_direct(unsigned long offset, u32 *value);
-static int tegra_apb_writel_direct(u32 value, unsigned long offset);
-
-static struct dma_chan *tegra_apb_dma_chan;
-static struct dma_slave_config dma_sconfig;
-
-static bool tegra_apb_dma_init(void)
-{
-	dma_cap_mask_t mask;
-
-	mutex_lock(&tegra_apb_dma_lock);
-
-	/* Check to see if we raced to setup */
-	if (tegra_apb_dma_chan)
-		goto skip_init;
-
-	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
-	tegra_apb_dma_chan = dma_request_channel(mask, NULL, NULL);
-	if (!tegra_apb_dma_chan) {
-		/*
-		 * This is common until the device is probed, so don't
-		 * shout about it.
-		 */
-		pr_debug("%s: can not allocate dma channel\n", __func__);
-		goto err_dma_alloc;
-	}
-
-	tegra_apb_bb = dma_alloc_coherent(NULL, sizeof(u32),
-		&tegra_apb_bb_phys, GFP_KERNEL);
-	if (!tegra_apb_bb) {
-		pr_err("%s: can not allocate bounce buffer\n", __func__);
-		goto err_buff_alloc;
-	}
-
-	dma_sconfig.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-	dma_sconfig.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-	dma_sconfig.src_maxburst = 1;
-	dma_sconfig.dst_maxburst = 1;
-
-skip_init:
-	mutex_unlock(&tegra_apb_dma_lock);
-	return true;
-
-err_buff_alloc:
-	dma_release_channel(tegra_apb_dma_chan);
-	tegra_apb_dma_chan = NULL;
-
-err_dma_alloc:
-	mutex_unlock(&tegra_apb_dma_lock);
-	return false;
-}
-
-static void apb_dma_complete(void *args)
-{
-	complete(&tegra_apb_wait);
-}
-
-static int do_dma_transfer(unsigned long apb_add,
-		enum dma_transfer_direction dir)
-{
-	struct dma_async_tx_descriptor *dma_desc;
-	int ret;
-
-	if (dir == DMA_DEV_TO_MEM)
-		dma_sconfig.src_addr = apb_add;
-	else
-		dma_sconfig.dst_addr = apb_add;
-
-	ret = dmaengine_slave_config(tegra_apb_dma_chan, &dma_sconfig);
-	if (ret)
-		return ret;
-
-	dma_desc = dmaengine_prep_slave_single(tegra_apb_dma_chan,
-			tegra_apb_bb_phys, sizeof(u32), dir,
-			DMA_PREP_INTERRUPT |  DMA_CTRL_ACK);
-	if (!dma_desc)
-		return -EINVAL;
-
-	dma_desc->callback = apb_dma_complete;
-	dma_desc->callback_param = NULL;
-
-	reinit_completion(&tegra_apb_wait);
-
-	dmaengine_submit(dma_desc);
-	dma_async_issue_pending(tegra_apb_dma_chan);
-	ret = wait_for_completion_timeout(&tegra_apb_wait,
-		msecs_to_jiffies(50));
-
-	if (WARN(ret == 0, "apb read dma timed out")) {
-		dmaengine_terminate_all(tegra_apb_dma_chan);
-		return -EFAULT;
-	}
-	return 0;
-}
-
-int tegra_apb_readl_using_dma(unsigned long offset, u32 *value)
-{
-	int ret;
-
-	if (!tegra_apb_dma_chan && !tegra_apb_dma_init())
-		return tegra_apb_readl_direct(offset, value);
-
-	mutex_lock(&tegra_apb_dma_lock);
-	ret = do_dma_transfer(offset, DMA_DEV_TO_MEM);
-	if (ret < 0)
-		pr_err("error in reading offset 0x%08lx using dma\n", offset);
-	else
-		*value = *tegra_apb_bb;
-
-	mutex_unlock(&tegra_apb_dma_lock);
-
-	return ret;
-}
-
-int tegra_apb_writel_using_dma(u32 value, unsigned long offset)
-{
-	int ret;
-
-	if (!tegra_apb_dma_chan && !tegra_apb_dma_init())
-		return tegra_apb_writel_direct(value, offset);
-
-	mutex_lock(&tegra_apb_dma_lock);
-	*((u32 *)tegra_apb_bb) = value;
-	ret = do_dma_transfer(offset, DMA_MEM_TO_DEV);
-	mutex_unlock(&tegra_apb_dma_lock);
-	if (ret < 0)
-		pr_err("error in writing offset 0x%08lx using dma\n", offset);
-
-	return ret;
-}
-#else
-#define tegra_apb_readl_using_dma tegra_apb_readl_direct
-#define tegra_apb_writel_using_dma tegra_apb_writel_direct
-#endif
-
-typedef int (*apbio_read_fptr)(unsigned long offset, u32 *value);
-typedef int (*apbio_write_fptr)(u32 value, unsigned long offset);
-
-static apbio_read_fptr apbio_read;
-static apbio_write_fptr apbio_write;
-
-static int tegra_apb_readl_direct(unsigned long offset, u32 *value)
-{
-	*value = readl(IO_ADDRESS(offset));
-
-	return 0;
-}
-
-static int tegra_apb_writel_direct(u32 value, unsigned long offset)
-{
-	writel(value, IO_ADDRESS(offset));
-
-	return 0;
-}
-
-void tegra_apb_io_init(void)
-{
-	/* Need to use dma only when it is Tegra20 based platform */
-	if (of_machine_is_compatible("nvidia,tegra20") ||
-			!of_have_populated_dt()) {
-		apbio_read = tegra_apb_readl_using_dma;
-		apbio_write = tegra_apb_writel_using_dma;
-	} else {
-		apbio_read = tegra_apb_readl_direct;
-		apbio_write = tegra_apb_writel_direct;
-	}
-}
-
-u32 tegra_apb_readl(unsigned long offset)
-{
-	u32 val;
-
-	if (apbio_read(offset, &val) < 0)
-		return 0;
-	else
-		return val;
-}
-
-void tegra_apb_writel(u32 value, unsigned long offset)
-{
-	apbio_write(value, offset);
-}
diff --git a/arch/arm/mach-tegra/apbio.h b/arch/arm/mach-tegra/apbio.h
deleted file mode 100644
index f05d71c..0000000
--- a/arch/arm/mach-tegra/apbio.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- * Copyright (C) 2010 NVIDIA Corporation.
- * Copyright (C) 2010 Google, Inc.
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#ifndef __MACH_TEGRA_APBIO_H
-#define __MACH_TEGRA_APBIO_H
-
-void tegra_apb_io_init(void);
-u32 tegra_apb_readl(unsigned long offset);
-void tegra_apb_writel(u32 value, unsigned long offset);
-#endif
diff --git a/arch/arm/mach-tegra/tegra.c b/arch/arm/mach-tegra/tegra.c
index 093d5f4..ee6fbc6 100644
--- a/arch/arm/mach-tegra/tegra.c
+++ b/arch/arm/mach-tegra/tegra.c
@@ -43,7 +43,6 @@
 #include <asm/setup.h>
 #include <asm/trusted_foundations.h>
 
-#include "apbio.h"
 #include "board.h"
 #include "common.h"
 #include "cpuidle.h"
@@ -100,7 +99,6 @@ static void __init tegra_init_cache(void)
 static void __init tegra_init_early(void)
 {
 	of_register_trusted_foundations();
-	tegra_apb_io_init();
 	tegra_init_fuse();
 	tegra_cpu_reset_handler_init();
 	tegra_init_cache();
diff --git a/drivers/misc/fuse/tegra/fuse-tegra20.c b/drivers/misc/fuse/tegra/fuse-tegra20.c
index 09f91bf..c3dcf11 100644
--- a/drivers/misc/fuse/tegra/fuse-tegra20.c
+++ b/drivers/misc/fuse/tegra/fuse-tegra20.c
@@ -18,6 +18,9 @@
 
 #include <linux/device.h>
 #include <linux/clk.h>
+#include <linux/completion.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
@@ -38,18 +41,58 @@ static phys_addr_t fuse_phys;
 static struct clk *fuse_clk;
 static void __iomem __initdata *fuse_base;
 
+static DEFINE_MUTEX(apb_dma_lock);
+static DECLARE_COMPLETION(apb_dma_wait);
+static struct dma_chan *apb_dma_chan;
+static struct dma_slave_config dma_sconfig;
+static u32 *apb_buffer;
+static dma_addr_t apb_buffer_phys;
+
+static void apb_dma_complete(void *args)
+{
+	complete(&apb_dma_wait);
+}
+
 static u32 tegra20_fuse_readl(const unsigned int offset)
 {
 	int ret;
-	u32 val;
+	u32 val = 0;
+	struct dma_async_tx_descriptor *dma_desc;
+
+	mutex_lock(&apb_dma_lock);
+
+	dma_sconfig.src_addr = fuse_phys + FUSE_BEGIN + offset;
+	ret = dmaengine_slave_config(apb_dma_chan, &dma_sconfig);
+	if (ret)
+		goto out;
+
+	dma_desc = dmaengine_prep_slave_single(apb_dma_chan, apb_buffer_phys,
+			sizeof(u32), DMA_DEV_TO_MEM,
+			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!dma_desc)
+		goto out;
+
+	dma_desc->callback = apb_dma_complete;
+	dma_desc->callback_param = NULL;
+
+	reinit_completion(&apb_dma_wait);
 
 	clk_prepare_enable(fuse_clk);
 
-	ret = tegra_apb_readl_using_dma(fuse_phys + FUSE_BEGIN + offset, &val);
+	dmaengine_submit(dma_desc);
+	dma_async_issue_pending(apb_dma_chan);
+	ret = wait_for_completion_timeout(&apb_dma_wait, msecs_to_jiffies(50));
+
+	if (WARN(ret == 0, "apb read dma timed out"))
+		dmaengine_terminate_all(apb_dma_chan);
+	else
+		val = *apb_buffer;
 
 	clk_disable_unprepare(fuse_clk);
+out:
+	mutex_unlock(&apb_dma_lock);
 
-	return (ret < 0) ? 0 : val;
+	return val;
 }
 
 static const struct of_device_id tegra20_fuse_of_match[] = {
@@ -57,9 +100,35 @@ static const struct of_device_id tegra20_fuse_of_match[] = {
 	{},
 };
 
+static int apb_dma_init(void)
+{
+	dma_cap_mask_t mask;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+	apb_dma_chan = dma_request_channel(mask, NULL, NULL);
+	if (!apb_dma_chan)
+		return -EPROBE_DEFER;
+
+	apb_buffer = dma_alloc_coherent(NULL, sizeof(u32), &apb_buffer_phys,
+					GFP_KERNEL);
+	if (!apb_buffer) {
+		dma_release_channel(apb_dma_chan);
+		return -ENOMEM;
+	}
+
+	dma_sconfig.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	dma_sconfig.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	dma_sconfig.src_maxburst = 1;
+	dma_sconfig.dst_maxburst = 1;
+
+	return 0;
+}
+
 static int tegra20_fuse_probe(struct platform_device *pdev)
 {
 	struct resource *res;
+	int err;
 
 	fuse_clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(fuse_clk)) {
@@ -72,6 +141,10 @@ static int tegra20_fuse_probe(struct platform_device *pdev)
 		return -EINVAL;
 	fuse_phys = res->start;
 
+	err = apb_dma_init();
+	if (err)
+		return err;
+
 	if (tegra_fuse_create_sysfs(&pdev->dev, FUSE_SIZE, tegra20_fuse_readl))
 		return -ENODEV;
 
diff --git a/include/linux/tegra-soc.h b/include/linux/tegra-soc.h
index 1ca3756..fcf65ec 100644
--- a/include/linux/tegra-soc.h
+++ b/include/linux/tegra-soc.h
@@ -59,20 +59,6 @@ int tegra_fuse_readl(u32 offset, u32 *val);
 extern int tegra_chip_id;
 extern struct tegra_sku_info tegra_sku_info;
 
-#if defined(CONFIG_TEGRA20_APB_DMA)
-int tegra_apb_readl_using_dma(unsigned long offset, u32 *value);
-int tegra_apb_writel_using_dma(u32 value, unsigned long offset);
-#else
-static inline int tegra_apb_readl_using_dma(unsigned long offset, u32 *value)
-{
-	return -EINVAL;
-}
-static inline int tegra_apb_writel_using_dma(u32 value, unsigned long offset)
-{
-	return -EINVAL;
-}
-#endif
-
 #endif /* __ASSEMBLY__ */
 
 #endif /* __LINUX_TEGRA_SOC_H_ */
-- 
1.7.7.rc0.72.g4b5ea.dirty

