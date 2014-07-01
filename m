Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbaGAIs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:48:57 -0400
Received: from regular1.263xmail.com ([211.150.99.130]:45753 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903AbaGAIsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:48:53 -0400
X-Greylist: delayed 596 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jul 2014 04:48:50 EDT
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: xjq@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: xjq@rock-chips.com
X-UNIQUE-TAG: <567796711e908415fd60f9bde6b42938>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: jianqun <xjq@rock-chips.com>
To: heiko@sntech.de, lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, grant.likely@linaro.org, robh+dt@kernel.org
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, zhangqing@rock-chips.com,
        hj@rock-chips.com, kever.yang@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, kfx@rock-chips.com, Jianqun Xu <xjq@rock-chips.com>
Subject: [PATCH 2/2] ASoC: add driver for Rockchip RK3xxx I2S controller
Date: Tue,  1 Jul 2014 16:47:38 +0800
Message-Id: <1404204458-30881-1-git-send-email-xjq@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404203860-30712-1-git-send-email-xjq@rock-chips.com>
References: <1404203860-30712-1-git-send-email-xjq@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jianqun Xu <xjq@rock-chips.com>

Add driver for I2S controller in Rockchip RK3xxx SoCs.

This driver patch has been tested on the RK3288 SDK board.

Signed-off-by: Jianqun Xu <xjq@rock-chips.com>
---
 sound/soc/Kconfig                 |    1 +
 sound/soc/Makefile                |    1 +
 sound/soc/rockchip/Kconfig        |   16 +
 sound/soc/rockchip/Makefile       |    6 +
 sound/soc/rockchip/i2s.h          |  222 +++++++++++++
 sound/soc/rockchip/pcm.h          |   14 +
 sound/soc/rockchip/rockchip_i2s.c |  622 +++++++++++++++++++++++++++++++++++++
 sound/soc/rockchip/rockchip_pcm.c |   64 ++++
 8 files changed, 946 insertions(+)
 create mode 100644 sound/soc/rockchip/Kconfig
 create mode 100644 sound/soc/rockchip/Makefile
 create mode 100644 sound/soc/rockchip/i2s.h
 create mode 100644 sound/soc/rockchip/pcm.h
 create mode 100644 sound/soc/rockchip/rockchip_i2s.c
 create mode 100644 sound/soc/rockchip/rockchip_pcm.c

diff --git a/sound/soc/Kconfig b/sound/soc/Kconfig
index 0060b31..0e96233 100644
--- a/sound/soc/Kconfig
+++ b/sound/soc/Kconfig
@@ -47,6 +47,7 @@ source "sound/soc/kirkwood/Kconfig"
 source "sound/soc/intel/Kconfig"
 source "sound/soc/mxs/Kconfig"
 source "sound/soc/pxa/Kconfig"
+source "sound/soc/rockchip/Kconfig"
 source "sound/soc/samsung/Kconfig"
 source "sound/soc/s6000/Kconfig"
 source "sound/soc/sh/Kconfig"
diff --git a/sound/soc/Makefile b/sound/soc/Makefile
index 5f1df02..534714a 100644
--- a/sound/soc/Makefile
+++ b/sound/soc/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_SND_SOC)	+= nuc900/
 obj-$(CONFIG_SND_SOC)	+= omap/
 obj-$(CONFIG_SND_SOC)	+= kirkwood/
 obj-$(CONFIG_SND_SOC)	+= pxa/
+obj-$(CONFIG_SND_SOC)	+= rockchip/
 obj-$(CONFIG_SND_SOC)	+= samsung/
 obj-$(CONFIG_SND_SOC)	+= s6000/
 obj-$(CONFIG_SND_SOC)	+= sh/
diff --git a/sound/soc/rockchip/Kconfig b/sound/soc/rockchip/Kconfig
new file mode 100644
index 0000000..946b60c
--- /dev/null
+++ b/sound/soc/rockchip/Kconfig
@@ -0,0 +1,16 @@
+config SND_SOC_ROCKCHIP
+	tristate "ASoC support for Rockchip"
+	depends on SND_SOC && ARCH_ROCKCHIP
+	select SND_SOC_GENERIC_DMAENGINE_PCM
+	select SND_ROCKCHIP_PCM
+	select SND_ROCKCHIP_I2S
+	help
+	  Say Y or M if you want to add support for codecs attached to
+	  the Rockchip SoCs' Audio interfaces. You will also need to
+	  select the audio interfaces to support below.
+
+config SND_ROCKCHIP_I2S
+	tristate
+
+config SND_ROCKCHIP_PCM
+	tristate
diff --git a/sound/soc/rockchip/Makefile b/sound/soc/rockchip/Makefile
new file mode 100644
index 0000000..0b5d47e
--- /dev/null
+++ b/sound/soc/rockchip/Makefile
@@ -0,0 +1,6 @@
+# ROCKCHIP Platform Support
+snd-soc-i2s-objs := rockchip_i2s.o
+snd-soc-pcm-objs := rockchip_pcm.o
+
+obj-$(CONFIG_SND_ROCKCHIP_I2S) += snd-soc-i2s.o
+obj-$(CONFIG_SND_ROCKCHIP_PCM) += snd-soc-pcm.o
diff --git a/sound/soc/rockchip/i2s.h b/sound/soc/rockchip/i2s.h
new file mode 100644
index 0000000..54a5a67
--- /dev/null
+++ b/sound/soc/rockchip/i2s.h
@@ -0,0 +1,222 @@
+/*
+ * i2s.h - ALSA IIS interface for the rockchip SoC
+ *
+ * Driver for rockchip iis audio
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/version.h>
+
+#ifndef _ROCKCHIP_IIS_H
+#define _ROCKCHIP_IIS_H
+
+/*
+ * TXCR
+ * transmit operation control register
+*/
+#define I2S_TXCR_RCNT_SHIFT	17
+#define I2S_TXCR_RCNT_MASK	(0x3f << I2S_TXCR_RCNT_SHIFT)
+#define I2S_TXCR_CSR_SHIFT	15
+#define I2S_TXCR_CSR(x)		(x << I2S_TXCR_CSR_SHIFT)
+#define I2S_TXCR_CSR_MASK	(3 << I2S_TXCR_CSR_SHIFT)
+#define I2S_TXCR_HWT		BIT(14)
+#define I2S_TXCR_SJM_SHIFT	12
+#define I2S_TXCR_SJM_R		(0 << I2S_TXCR_SJM_SHIFT)
+#define I2S_TXCR_SJM_L		(1 << I2S_TXCR_SJM_SHIFT)
+#define I2S_TXCR_FBM_SHIFT	11
+#define I2S_TXCR_FBM_MSB	(0 << I2S_TXCR_FBM_SHIFT)
+#define I2S_TXCR_FBM_LSB	(1 << I2S_TXCR_FBM_SHIFT)
+#define I2S_TXCR_IBM_SHIFT	9
+#define I2S_TXCR_IBM_NORMAL	(0 << I2S_TXCR_IBM_SHIFT)
+#define I2S_TXCR_IBM_LSJM	(1 << I2S_TXCR_IBM_SHIFT)
+#define I2S_TXCR_IBM_RSJM	(2 << I2S_TXCR_IBM_SHIFT)
+#define I2S_TXCR_IBM_MASK	(3 << I2S_TXCR_IBM_SHIFT)
+#define I2S_TXCR_PBM_SHIFT	7
+#define I2S_TXCR_PBM_MODE(x)	(x << I2S_TXCR_PBM_SHIFT)
+#define I2S_TXCR_PBM_MASK	(3 << I2S_TXCR_PBM_SHIFT)
+#define I2S_TXCR_TFS_SHIFT	5
+#define I2S_TXCR_TFS_I2S	(0 << I2S_TXCR_TFS_SHIFT)
+#define I2S_TXCR_TFS_PCM	(1 << I2S_TXCR_TFS_SHIFT)
+#define I2S_TXCR_VDW_SHIFT	0
+#define I2S_TXCR_VDW(x)		((x - 1) << I2S_TXCR_VDW_SHIFT)
+#define I2S_TXCR_VDW_MASK	(0x1f << I2S_TXCR_VDW_SHIFT)
+
+/*
+ * RXCR
+ * receive operation control register
+*/
+#define I2S_RXCR_HWT		BIT(14)
+#define I2S_RXCR_SJM_SHIFT	12
+#define I2S_RXCR_SJM_R		(0 << I2S_RXCR_SJM_SHIFT)
+#define I2S_RXCR_SJM_L		(1 << I2S_RXCR_SJM_SHIFT)
+#define I2S_RXCR_FBM_SHIFT	11
+#define I2S_RXCR_FBM_MSB	(0 << I2S_RXCR_FBM_SHIFT)
+#define I2S_RXCR_FBM_LSB	(1 << I2S_RXCR_FBM_SHIFT)
+#define I2S_RXCR_IBM_SHIFT	9
+#define I2S_RXCR_IBM_NORMAL	(0 << I2S_RXCR_IBM_SHIFT)
+#define I2S_RXCR_IBM_LSJM	(1 << I2S_RXCR_IBM_SHIFT)
+#define I2S_RXCR_IBM_RSJM	(2 << I2S_RXCR_IBM_SHIFT)
+#define I2S_RXCR_IBM_MASK	(3 << I2S_RXCR_IBM_SHIFT)
+#define I2S_RXCR_PBM_SHIFT	7
+#define I2S_RXCR_PBM_MODE(x)	(x << I2S_RXCR_PBM_SHIFT)
+#define I2S_RXCR_PBM_MASK	(3 << I2S_RXCR_PBM_SHIFT)
+#define I2S_RXCR_TFS_SHIFT	5
+#define I2S_RXCR_TFS_I2S	(0 << I2S_RXCR_TFS_SHIFT)
+#define I2S_RXCR_TFS_PCM	(1 << I2S_RXCR_TFS_SHIFT)
+#define I2S_RXCR_VDW_SHIFT	0
+#define I2S_RXCR_VDW(x)		((x - 1) << I2S_RXCR_VDW_SHIFT)
+#define I2S_RXCR_VDW_MASK	(0x1f << I2S_RXCR_VDW_SHIFT)
+
+/*
+ * CKR
+ * clock generation register
+*/
+#define I2S_CKR_MSS_SHIFT	27
+#define I2S_CKR_MSS_MASTER	(0 << I2S_CKR_MSS_SHIFT)
+#define I2S_CKR_MSS_SLAVE	(1 << I2S_CKR_MSS_SHIFT)
+#define I2S_CKR_MSS_MASK	(1 << I2S_CKR_MSS_SHIFT)
+#define I2S_CKR_CKP_SHIFT	26
+#define I2S_CKR_CKP_NEG		(0 << I2S_CKR_CKP_SHIFT)
+#define I2S_CKR_CKP_POS		(1 << I2S_CKR_CKP_SHIFT)
+#define I2S_CKR_RLP_SHIFT	25
+#define I2S_CKR_RLP_NORMAL	(0 << I2S_CKR_RLP_SHIFT)
+#define I2S_CKR_RLP_OPPSITE	(1 << I2S_CKR_RLP_SHIFT)
+#define I2S_CKR_TLP_SHIFT	24
+#define I2S_CKR_TLP_NORMAL	(0 << I2S_CKR_TLP_SHIFT)
+#define I2S_CKR_TLP_OPPSITE	(1 << I2S_CKR_TLP_SHIFT)
+#define I2S_CKR_MDIV_SHIFT	16
+#define I2S_CKR_MDIV(x)		((x - 1) << I2S_CKR_MDIV_SHIFT)
+#define I2S_CKR_MDIV_MASK	(0xff << I2S_CKR_MDIV_SHIFT)
+#define I2S_CKR_RSD_SHIFT	8
+#define I2S_CKR_RSD(x)		((x - 1) << I2S_CKR_RSD_SHIFT)
+#define I2S_CKR_RSD_MASK	(0xff << I2S_CKR_RSD_SHIFT)
+#define I2S_CKR_TSD_SHIFT	0
+#define I2S_CKR_TSD(x)		((x - 1) << I2S_CKR_TSD_SHIFT)
+#define I2S_CKR_TSD_MASK	(0xff << I2S_CKR_TSD_SHIFT)
+
+/*
+ * FIFOLR
+ * FIFO level register
+*/
+#define I2S_FIFOLR_RFL_SHIFT	24
+#define I2S_FIFOLR_RFL_MASK	(0x3f << I2S_FIFOLR_RFL_SHIFT)
+#define I2S_FIFOLR_TFL3_SHIFT	18
+#define I2S_FIFOLR_TFL3_MASK	(0x3f << I2S_FIFOLR_TFL3_SHIFT)
+#define I2S_FIFOLR_TFL2_SHIFT	12
+#define I2S_FIFOLR_TFL2_MASK	(0x3f << I2S_FIFOLR_TFL2_SHIFT)
+#define I2S_FIFOLR_TFL1_SHIFT	6
+#define I2S_FIFOLR_TFL1_MASK	(0x3f << I2S_FIFOLR_TFL1_SHIFT)
+#define I2S_FIFOLR_TFL0_SHIFT	0
+#define I2S_FIFOLR_TFL0_MASK	(0x3f << I2S_FIFOLR_TFL0_SHIFT)
+
+/*
+ * DMACR
+ * DMA control register
+*/
+#define I2S_DMACR_RDE_SHIFT	24
+#define I2S_DMACR_RDE_DISABLE	(0 << I2S_DMACR_RDE_SHIFT)
+#define I2S_DMACR_RDE_ENABLE	(1 << I2S_DMACR_RDE_SHIFT)
+#define I2S_DMACR_RDL_SHIFT	16
+#define I2S_DMACR_RDL(x)	((x - 1) << I2S_DMACR_RDL_SHIFT)
+#define I2S_DMACR_RDL_MASK	(0x1f << I2S_DMACR_RDL_SHIFT)
+#define I2S_DMACR_TDE_SHIFT	8
+#define I2S_DMACR_TDE_DISABLE	(0 << I2S_DMACR_TDE_SHIFT)
+#define I2S_DMACR_TDE_ENABLE	(1 << I2S_DMACR_TDE_SHIFT)
+#define I2S_DMACR_TDL_SHIFT	0
+#define I2S_DMACR_TDL(x)	((x - 1) << I2S_DMACR_TDL_SHIFT)
+#define I2S_DMACR_TDL_MASK	(0x1f << I2S_DMACR_TDL_SHIFT)
+
+/*
+ * INTCR
+ * interrupt control register
+*/
+#define I2S_INTCR_RFT_SHIFT	20
+#define I2S_INTCR_RFT(x)	((x - 1) << I2S_INTCR_RFT_SHIFT)
+#define I2S_INTCR_RXOIC		BIT(18)
+#define I2S_INTCR_RXOIE_SHIFT	17
+#define I2S_INTCR_RXOIE_DISABLE	(0 << I2S_INTCR_RXOIE_SHIFT)
+#define I2S_INTCR_RXOIE_ENABLE	(1 << I2S_INTCR_RXOIE_SHIFT)
+#define I2S_INTCR_RXFIE_SHIFT	16
+#define I2S_INTCR_RXFIE_DISABLE	(0 << I2S_INTCR_RXFIE_SHIFT)
+#define I2S_INTCR_RXFIE_ENABLE	(1 << I2S_INTCR_RXFIE_SHIFT)
+#define I2S_INTCR_TFT_SHIFT	4
+#define I2S_INTCR_TFT(x)	((x - 1) << I2S_INTCR_TFT_SHIFT)
+#define I2S_INTCR_TFT_MASK	(0x1f << I2S_INTCR_TFT_SHIFT)
+#define I2S_INTCR_TXUIC		BIT(2)
+#define I2S_INTCR_TXUIE_SHIFT	1
+#define I2S_INTCR_TXUIE_DISABLE	(0 << I2S_INTCR_TXUIE_SHIFT)
+#define I2S_INTCR_TXUIE_ENABLE	(1 << I2S_INTCR_TXUIE_SHIFT)
+
+/*
+ * INTSR
+ * interrupt status register
+*/
+#define I2S_INTSR_TXEIE_SHIFT	0
+#define I2S_INTSR_TXEIE_DISABLE	(0 << I2S_INTSR_TXEIE_SHIFT)
+#define I2S_INTSR_TXEIE_ENABLE	(1 << I2S_INTSR_TXEIE_SHIFT)
+#define I2S_INTSR_RXOI_SHIFT	17
+#define I2S_INTSR_RXOI_INA	(0 << I2S_INTSR_RXOI_SHIFT)
+#define I2S_INTSR_RXOI_ACT	(1 << I2S_INTSR_RXOI_SHIFT)
+#define I2S_INTSR_RXFI_SHIFT	16
+#define I2S_INTSR_RXFI_INA	(0 << I2S_INTSR_RXFI_SHIFT)
+#define I2S_INTSR_RXFI_ACT	(1 << I2S_INTSR_RXFI_SHIFT)
+#define I2S_INTSR_TXUI_SHIFT	1
+#define I2S_INTSR_TXUI_INA	(0 << I2S_INTSR_TXUI_SHIFT)
+#define I2S_INTSR_TXUI_ACT	(1 << I2S_INTSR_TXUI_SHIFT)
+#define I2S_INTSR_TXEI_SHIFT	0
+#define I2S_INTSR_TXEI_INA	(0 << I2S_INTSR_TXEI_SHIFT)
+#define I2S_INTSR_TXEI_ACT	(1 << I2S_INTSR_TXEI_SHIFT)
+
+/*
+ * XFER
+ * Transfer start register
+*/
+#define I2S_XFER_RXS_SHIFT	1
+#define I2S_XFER_RXS_STOP	(0 << I2S_XFER_RXS_SHIFT)
+#define I2S_XFER_RXS_START	(1 << I2S_XFER_RXS_SHIFT)
+#define I2S_XFER_TXS_SHIFT	0
+#define I2S_XFER_TXS_STOP	(0 << I2S_XFER_TXS_SHIFT)
+#define I2S_XFER_TXS_START	(1 << I2S_XFER_TXS_SHIFT)
+
+/*
+ * CLR
+ * clear SCLK domain logic register
+*/
+#define I2S_CLR_RXC	BIT(1)
+#define I2S_CLR_TXC	BIT(0)
+
+/*
+ * TXDR
+ * Transimt FIFO data register, write only.
+*/
+#define I2S_TXDR_MASK	(0xff)
+
+/*
+ * RXDR
+ * Receive FIFO data register, write only.
+*/
+#define I2S_RXDR_MASK	(0xff)
+
+/* Clock divider id */
+enum {
+	ROCKCHIP_DIV_MCLK = 0,
+	ROCKCHIP_DIV_BCLK,
+};
+
+/* I2S REGS */
+#define I2S_TXCR	(0x0000)
+#define I2S_RXCR	(0x0004)
+#define I2S_CKR		(0x0008)
+#define I2S_FIFOLR	(0x000c)
+#define I2S_DMACR	(0x0010)
+#define I2S_INTCR	(0x0014)
+#define I2S_INTSR	(0x0018)
+#define I2S_XFER	(0x001c)
+#define I2S_CLR		(0x0020)
+#define I2S_TXDR	(0x0024)
+#define I2S_RXDR	(0x0028)
+
+#endif /* _ROCKCHIP_IIS_H */
diff --git a/sound/soc/rockchip/pcm.h b/sound/soc/rockchip/pcm.h
new file mode 100644
index 0000000..c373058
--- /dev/null
+++ b/sound/soc/rockchip/pcm.h
@@ -0,0 +1,14 @@
+/* sound/soc/rockchip/pcm.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ROCKCHIP_PCM_H
+#define _ROCKCHIP_PCM_H
+
+int rockchip_pcm_platform_register(struct device *dev);
+void rockchip_pcm_platform_unregister(struct device *dev);
+
+#endif /* _ROCKCHIP_PCM_H */
diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
new file mode 100644
index 0000000..bb52ae3
--- /dev/null
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -0,0 +1,622 @@
+/* sound/soc/rockchip/i2s.c
+ *
+ * ALSA SoC Audio Layer - Rockchip I2S Controller driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/clk.h>
+#include <linux/version.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+#include <asm/dma.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/initval.h>
+#include <sound/soc.h>
+#include <sound/dmaengine_pcm.h>
+
+#include "pcm.h"
+#include "i2s.h"
+
+#define DRV_NAME "rockchip-i2s"
+
+struct rk_i2s_dev {
+	void __iomem *regs;
+	struct device *dev;
+
+	struct clk *hclk;
+	struct clk *clk;
+
+	struct snd_dmaengine_dai_dma_data capture_dma_data;
+	struct snd_dmaengine_dai_dma_data playback_dma_data;
+
+	bool i2s_tx_status;
+	bool i2s_rx_status;
+
+	spinlock_t lock;
+};
+
+static inline struct rk_i2s_dev *to_info(struct snd_soc_dai *dai)
+{
+	return snd_soc_dai_get_drvdata(dai);
+}
+
+static inline void i2s_writel(struct rk_i2s_dev *i2s, u32 value,
+			      unsigned int offset)
+{
+	writel_relaxed(value, i2s->regs + offset);
+}
+
+static inline u32 i2s_readl(struct rk_i2s_dev *i2s, unsigned int offset)
+{
+	return readl_relaxed(i2s->regs + offset);
+}
+
+static void rockchip_snd_txctrl(struct rk_i2s_dev *i2s, int on)
+{
+	u32 opr, xfer, clr;
+	unsigned long flags;
+	bool need_delay = false;
+	int try_cnt = 10;
+
+	spin_lock_irqsave(&i2s->lock, flags);
+
+	opr = i2s_readl(i2s, I2S_DMACR);
+	xfer = i2s_readl(i2s, I2S_XFER);
+	clr = i2s_readl(i2s, I2S_CLR);
+
+	if (on) {
+		if ((opr & I2S_DMACR_TDE_ENABLE) == 0) {
+			opr  |= I2S_DMACR_TDE_ENABLE;
+			i2s_writel(i2s, opr, I2S_DMACR);
+		}
+
+		if ((xfer & I2S_XFER_TXS_START) == 0 ||
+			(xfer & I2S_XFER_RXS_START) == 0) {
+			xfer |= I2S_XFER_TXS_START;
+			xfer |= I2S_XFER_RXS_START;
+			i2s_writel(i2s, xfer, I2S_XFER);
+		}
+
+		i2s->i2s_tx_status = 1;
+	} else {
+		i2s->i2s_tx_status = 0;
+
+		opr &= ~I2S_DMACR_TDE_ENABLE;
+		i2s_writel(i2s, opr, I2S_DMACR);
+
+		if (i2s->i2s_rx_status == 0) {
+			xfer &= ~I2S_XFER_TXS_START;
+			xfer &= ~I2S_XFER_RXS_START;
+			i2s_writel(i2s, xfer, I2S_XFER);
+
+			clr |= I2S_CLR_TXC;
+			clr |= I2S_CLR_RXC;
+			i2s_writel(i2s, clr, I2S_CLR);
+
+			need_delay = true;
+		}
+	}
+
+	spin_unlock_irqrestore(&i2s->lock, flags);
+
+	if (need_delay) {
+		while (i2s_readl(i2s, I2S_CLR) && try_cnt) {
+			udelay(1);
+			try_cnt--;
+		}
+	}
+}
+
+static void rockchip_snd_rxctrl(struct rk_i2s_dev *i2s, int on)
+{
+	u32 opr, xfer, clr;
+	unsigned long flags;
+	bool need_delay = false;
+	int try_cnt = 10;
+
+	spin_lock_irqsave(&i2s->lock, flags);
+
+	opr  = i2s_readl(i2s, I2S_DMACR);
+	xfer = i2s_readl(i2s, I2S_XFER);
+	clr  = i2s_readl(i2s, I2S_CLR);
+
+	if (on) {
+		if ((opr & I2S_DMACR_RDE_ENABLE) == 0) {
+			opr  |= I2S_DMACR_RDE_ENABLE;
+			i2s_writel(i2s, opr, I2S_DMACR);
+		}
+
+		if ((xfer & I2S_XFER_TXS_START) == 0 ||
+			(xfer & I2S_XFER_RXS_START) == 0) {
+			xfer |= I2S_XFER_TXS_START;
+			xfer |= I2S_XFER_RXS_START;
+			i2s_writel(i2s, xfer, I2S_XFER);
+		}
+
+		i2s->i2s_rx_status = 1;
+	} else {
+		i2s->i2s_rx_status = 0;
+
+		opr &= ~I2S_DMACR_RDE_ENABLE;
+		i2s_writel(i2s, opr, I2S_DMACR);
+
+		if (i2s->i2s_tx_status == 0) {
+			xfer &= ~I2S_XFER_RXS_START;
+			xfer &= ~I2S_XFER_TXS_START;
+			i2s_writel(i2s, xfer, I2S_XFER);
+
+			clr |= I2S_CLR_TXC;
+			clr |= I2S_CLR_RXC;
+			i2s_writel(i2s, clr, I2S_CLR);
+
+			need_delay = true;
+		}
+	}
+
+	spin_unlock_irqrestore(&i2s->lock, flags);
+
+	if (need_delay) {
+		while (i2s_readl(i2s, I2S_CLR) && try_cnt) {
+			udelay(1);
+			try_cnt--;
+		}
+	}
+}
+
+static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai, unsigned int fmt)
+{
+	struct rk_i2s_dev *i2s = to_info(cpu_dai);
+	unsigned long flags;
+	u32 tx_ctl, rx_ctl;
+	u32 iis_ckr_value;
+	int ret = 0;
+
+	spin_lock_irqsave(&i2s->lock, flags);
+
+	iis_ckr_value = i2s_readl(i2s, I2S_CKR);
+	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
+	case SND_SOC_DAIFMT_CBM_CFM:
+		iis_ckr_value &= ~I2S_CKR_MSS_MASK;
+		iis_ckr_value |= I2S_CKR_MSS_SLAVE;
+		break;
+	case SND_SOC_DAIFMT_CBS_CFS:
+		iis_ckr_value &= ~I2S_CKR_MSS_MASK;
+		iis_ckr_value |= I2S_CKR_MSS_MASTER;
+		break;
+	default:
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	i2s_writel(i2s, iis_ckr_value, I2S_CKR);
+
+	tx_ctl = i2s_readl(i2s, I2S_TXCR);
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_RIGHT_J:
+		tx_ctl &= ~I2S_TXCR_IBM_MASK;
+		tx_ctl |= I2S_TXCR_IBM_RSJM;
+		break;
+	case SND_SOC_DAIFMT_LEFT_J:
+		tx_ctl &= ~I2S_TXCR_IBM_MASK;
+		tx_ctl |= I2S_TXCR_IBM_LSJM;
+		break;
+	case SND_SOC_DAIFMT_I2S:
+		tx_ctl &= ~I2S_TXCR_IBM_MASK;
+		tx_ctl |= I2S_TXCR_IBM_NORMAL;
+		break;
+	default:
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	i2s_writel(i2s, tx_ctl, I2S_TXCR);
+
+	rx_ctl = i2s_readl(i2s, I2S_RXCR);
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_RIGHT_J:
+		rx_ctl &= ~I2S_RXCR_IBM_MASK;
+		rx_ctl |= I2S_RXCR_IBM_RSJM;
+		break;
+	case SND_SOC_DAIFMT_LEFT_J:
+		rx_ctl &= ~I2S_RXCR_IBM_MASK;
+		rx_ctl |= I2S_RXCR_IBM_LSJM;
+		break;
+	case SND_SOC_DAIFMT_I2S:
+		rx_ctl &= ~I2S_RXCR_IBM_MASK;
+		rx_ctl |= I2S_RXCR_IBM_NORMAL;
+		break;
+	default:
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	i2s_writel(i2s, rx_ctl, I2S_RXCR);
+
+exit:
+	spin_unlock_irqrestore(&i2s->lock, flags);
+
+	return ret;
+}
+
+static int rockchip_i2s_hw_params(struct snd_pcm_substream *substream,
+	struct snd_pcm_hw_params *params, struct snd_soc_dai *dai)
+{
+	struct rk_i2s_dev *i2s = to_info(dai);
+	unsigned long flags;
+	u32 tx_ctl, rx_ctl;
+	u32 dmacr;
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		dai->playback_dma_data = &i2s->playback_dma_data;
+	else
+		dai->capture_dma_data = &i2s->capture_dma_data;
+
+	spin_lock_irqsave(&i2s->lock, flags);
+
+	tx_ctl = i2s_readl(i2s, I2S_TXCR);
+	tx_ctl &= ~I2S_TXCR_VDW_MASK;
+	switch (params_format(params)) {
+	case SNDRV_PCM_FORMAT_S8:
+		tx_ctl |= I2S_TXCR_VDW(8);
+		break;
+	case SNDRV_PCM_FORMAT_S16_LE:
+		tx_ctl |= I2S_TXCR_VDW(16);
+		break;
+	case SNDRV_PCM_FORMAT_S20_3LE:
+		tx_ctl |= I2S_TXCR_VDW(20);
+		break;
+	case SNDRV_PCM_FORMAT_S24_LE:
+		tx_ctl |= I2S_TXCR_VDW(24);
+		break;
+	case SNDRV_PCM_FORMAT_S32_LE:
+		tx_ctl |= I2S_TXCR_VDW(32);
+		break;
+	}
+
+	i2s_writel(i2s, tx_ctl, I2S_TXCR);
+
+	rx_ctl = i2s_readl(i2s, I2S_TXCR);
+	rx_ctl &= ~I2S_TXCR_VDW_MASK;
+	switch (params_format(params)) {
+	case SNDRV_PCM_FORMAT_S8:
+		rx_ctl |= I2S_TXCR_VDW(8);
+		break;
+	case SNDRV_PCM_FORMAT_S16_LE:
+		rx_ctl |= I2S_TXCR_VDW(16);
+		break;
+	case SNDRV_PCM_FORMAT_S20_3LE:
+		rx_ctl |= I2S_TXCR_VDW(20);
+		break;
+	case SNDRV_PCM_FORMAT_S24_LE:
+		rx_ctl |= I2S_TXCR_VDW(24);
+		break;
+	case SNDRV_PCM_FORMAT_S32_LE:
+		rx_ctl |= I2S_TXCR_VDW(32);
+		break;
+	}
+
+	i2s_writel(i2s, rx_ctl, I2S_RXCR);
+
+	dmacr = i2s_readl(i2s, I2S_DMACR);
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		dmacr = ((dmacr & ~I2S_DMACR_TDL_MASK) |
+				I2S_DMACR_TDL(1) |
+				I2S_DMACR_TDE_ENABLE);
+	else
+		dmacr = ((dmacr & ~I2S_DMACR_RDL_MASK) |
+				I2S_DMACR_RDL(1) |
+				I2S_DMACR_RDE_ENABLE);
+
+	i2s_writel(i2s, dmacr, I2S_DMACR);
+
+	spin_unlock_irqrestore(&i2s->lock, flags);
+
+	return 0;
+}
+
+static int rockchip_i2s_trigger(struct snd_pcm_substream *substream,
+	int cmd, struct snd_soc_dai *dai)
+{
+	struct rk_i2s_dev *i2s = to_info(dai);
+	int ret = 0;
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+	case SNDRV_PCM_TRIGGER_RESUME:
+	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)
+			rockchip_snd_rxctrl(i2s, 1);
+		else
+			rockchip_snd_txctrl(i2s, 1);
+		break;
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+	case SNDRV_PCM_TRIGGER_STOP:
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)
+			rockchip_snd_rxctrl(i2s, 0);
+		else
+			rockchip_snd_txctrl(i2s, 0);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static int rockchip_i2s_set_sysclk(struct snd_soc_dai *cpu_dai,
+	int clk_id, unsigned int freq, int dir)
+{
+	struct rk_i2s_dev *i2s = to_info(cpu_dai);
+
+	clk_set_rate(i2s->clk, freq);
+
+	return 0;
+}
+
+static int rockchip_i2s_set_clkdiv(struct snd_soc_dai *cpu_dai,
+	int div_id, int div)
+{
+	struct rk_i2s_dev *i2s = to_info(cpu_dai);
+	unsigned long flags;
+	u32 reg;
+	int ret;
+
+	spin_lock_irqsave(&i2s->lock, flags);
+
+	reg = i2s_readl(i2s, I2S_CKR);
+	switch (div_id) {
+	case ROCKCHIP_DIV_BCLK:
+		reg &= ~I2S_CKR_TSD_MASK;
+		reg |= I2S_CKR_TSD(div);
+		reg &= ~I2S_CKR_RSD_MASK;
+		reg |= I2S_CKR_RSD(div);
+		break;
+	case ROCKCHIP_DIV_MCLK:
+		reg &= ~I2S_CKR_MDIV_MASK;
+		reg |= I2S_CKR_MDIV(div);
+		break;
+	default:
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	i2s_writel(i2s, reg, I2S_CKR);
+
+exit:
+	spin_unlock_irqrestore(&i2s->lock, flags);
+
+	return ret;
+}
+
+static struct snd_soc_dai_ops rockchip_i2s_dai_ops = {
+	.trigger = rockchip_i2s_trigger,
+	.hw_params = rockchip_i2s_hw_params,
+	.set_fmt = rockchip_i2s_set_fmt,
+	.set_clkdiv = rockchip_i2s_set_clkdiv,
+	.set_sysclk = rockchip_i2s_set_sysclk,
+};
+
+#define ROCKCHIP_I2S_STEREO_RATES SNDRV_PCM_RATE_8000_96000
+#define ROCKCHIP_I2S_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | \
+		SNDRV_PCM_FMTBIT_S20_3LE | SNDRV_PCM_FMTBIT_S24_LE | \
+		SNDRV_PCM_FMTBIT_S8)
+
+struct snd_soc_dai_driver rockchip_i2s_dai[] = {
+	{
+		.name = "rockchip-i2s.0",
+		.id = 0,
+		.playback = {
+			.channels_min = 2,
+			.channels_max = 8,
+			.rates = ROCKCHIP_I2S_STEREO_RATES,
+			.formats = ROCKCHIP_I2S_FORMATS,
+		},
+		.capture = {
+			.channels_min = 2,
+			.channels_max = 2,
+			.rates = ROCKCHIP_I2S_STEREO_RATES,
+			.formats = ROCKCHIP_I2S_FORMATS,
+		},
+		.ops = &rockchip_i2s_dai_ops,
+		.symmetric_rates = 1,
+	},
+	{
+		.name = "rockchip-i2s.1",
+		.id = 1,
+		.playback = {
+			.channels_min = 2,
+			.channels_max = 2,
+			.rates = ROCKCHIP_I2S_STEREO_RATES,
+			.formats = ROCKCHIP_I2S_FORMATS,
+		},
+		.capture = {
+			.channels_min = 2,
+			.channels_max = 2,
+			.rates = ROCKCHIP_I2S_STEREO_RATES,
+			.formats = ROCKCHIP_I2S_FORMATS,
+		},
+		.ops = &rockchip_i2s_dai_ops,
+		.symmetric_rates = 1,
+	},
+};
+
+static const struct snd_soc_component_driver rockchip_i2s_component = {
+	.name	= DRV_NAME,
+};
+
+#ifdef CONFIG_PM_RUNTIME
+static int i2s_runtime_suspend(struct device *dev)
+{
+	struct rk_i2s_dev *i2s = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(i2s->clk);
+
+	return 0;
+}
+
+static int i2s_runtime_resume(struct device *dev)
+{
+	struct rk_i2s_dev *i2s = dev_get_drvdata(dev);
+
+	return clk_prepare_enable(i2s->clk);
+}
+#else
+#define i2s_runtime_suspend NULL
+#define i2s_runtime_resume NULL
+#endif
+
+static int rockchip_i2s_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct rk_i2s_dev *i2s;
+	struct resource *res;
+	int ret;
+
+	i2s = devm_kzalloc(&pdev->dev, sizeof(struct rk_i2s_dev),
+				GFP_KERNEL);
+	if (!i2s)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	i2s->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(i2s->regs)) {
+		dev_err(&pdev->dev, "Could not get I2S source, %p\n",
+				i2s->regs);
+		return PTR_ERR(i2s->regs);
+	}
+
+	i2s->playback_dma_data.addr = res->start + I2S_TXDR;
+	i2s->playback_dma_data.addr_width = 4;
+	i2s->playback_dma_data.maxburst = 1;
+
+	i2s->capture_dma_data.addr = res->start + I2S_RXDR;
+	i2s->capture_dma_data.addr_width = 4;
+	i2s->capture_dma_data.maxburst = 1;
+
+	i2s->i2s_tx_status = false;
+	i2s->i2s_rx_status = false;
+
+	spin_lock_init(&i2s->lock);
+
+	ret = rockchip_pcm_platform_register(&pdev->dev);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not register PCM\n");
+		goto err_pcm_register;
+	}
+
+	/* Must success to get some clocks from dt */
+	i2s->hclk = devm_clk_get(&pdev->dev, "i2s_hclk");
+	if (IS_ERR(i2s->hclk)) {
+		dev_err(&pdev->dev, "Could not get i2s_hclk\n");
+		return PTR_ERR(i2s->hclk);
+	}
+
+	i2s->clk = devm_clk_get(&pdev->dev, "i2s_clk");
+	if (IS_ERR(i2s->clk)) {
+		dev_err(&pdev->dev, "Could not get i2s_clk\n");
+		return PTR_ERR(i2s->clk);
+	}
+
+	ret = clk_prepare_enable(i2s->hclk);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not enable i2s_hclk\n");
+		return ret;
+	}
+
+	ret = clk_prepare_enable(i2s->clk);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not enable i2s_clk\n");
+		goto err_hclk_disable;
+	}
+
+	/* Try to set the I2S Channel id from dt */
+	pdev->id = of_alias_get_id(np, "i2s");
+	dev_set_name(&pdev->dev, "%s.%d",
+				pdev->dev.driver->name,
+				pdev->id);
+
+	i2s->dev = &pdev->dev;
+	dev_set_drvdata(&pdev->dev, i2s);
+
+	ret = devm_snd_soc_register_component(&pdev->dev,
+				&rockchip_i2s_component,
+				&rockchip_i2s_dai[pdev->id], 1);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not register DAI\n");
+		goto err_clk_disable;
+	}
+
+	pm_runtime_enable(&pdev->dev);
+
+	return 0;
+
+err_clk_disable:
+	clk_disable_unprepare(i2s->clk);
+err_hclk_disable:
+	clk_disable_unprepare(i2s->hclk);
+err_pcm_register:
+	rockchip_pcm_platform_unregister(&pdev->dev);
+
+	return ret;
+}
+
+static int rockchip_i2s_remove(struct platform_device *pdev)
+{
+	struct rk_i2s_dev *i2s = dev_get_drvdata(&pdev->dev);
+
+	clk_disable_unprepare(i2s->clk);
+	clk_disable_unprepare(i2s->hclk);
+	rockchip_pcm_platform_unregister(&pdev->dev);
+	snd_soc_unregister_component(&pdev->dev);
+
+	return 0;
+}
+
+static const struct of_device_id rockchip_i2s_match[] = {
+	{
+		.compatible = "rockchip,rk3066-i2s"
+	},
+};
+MODULE_DEVICE_TABLE(of, rockchip_i2s_match);
+
+static const struct dev_pm_ops rockchip_i2s_pm_ops = {
+	SET_RUNTIME_PM_OPS(i2s_runtime_suspend,
+			i2s_runtime_resume, NULL)
+};
+
+static struct platform_driver rockchip_i2s_driver = {
+	.probe = rockchip_i2s_probe,
+	.remove = rockchip_i2s_remove,
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(rockchip_i2s_match),
+		.pm = &rockchip_i2s_pm_ops,
+	},
+};
+module_platform_driver(rockchip_i2s_driver);
+
+MODULE_DESCRIPTION("ROCKCHIP IIS ASoC Interface");
+MODULE_AUTHOR("jianqun <jay.xu@rock-chips.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/sound/soc/rockchip/rockchip_pcm.c b/sound/soc/rockchip/rockchip_pcm.c
new file mode 100644
index 0000000..454c609
--- /dev/null
+++ b/sound/soc/rockchip/rockchip_pcm.c
@@ -0,0 +1,64 @@
+/* sound/soc/rockchip/pcm.c
+ *
+ * ALSA SoC Audio Layer - Rockchip I2S Controller driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+#include <sound/dmaengine_pcm.h>
+
+#include "pcm.h"
+
+static const struct snd_pcm_hardware rockchip_pcm_hardware = {
+	.info = SNDRV_PCM_INFO_INTERLEAVED |
+			SNDRV_PCM_INFO_BLOCK_TRANSFER |
+			SNDRV_PCM_INFO_MMAP |
+			SNDRV_PCM_INFO_MMAP_VALID |
+			SNDRV_PCM_INFO_PAUSE |
+			SNDRV_PCM_INFO_RESUME,
+	.formats = SNDRV_PCM_FMTBIT_S24_LE |
+			SNDRV_PCM_FMTBIT_S20_3LE |
+			SNDRV_PCM_FMTBIT_S16_LE,
+	.channels_min = 2,
+	.channels_max = 8,
+	.buffer_bytes_max = 128*1024,
+	.period_bytes_min = 64,
+	.period_bytes_max = 2048*4,
+	.periods_min = 3,
+	.periods_max = 128,
+	.fifo_size = 16,
+};
+
+static const struct snd_dmaengine_pcm_config rockchip_dmaengine_pcm_config = {
+	.pcm_hardware = &rockchip_pcm_hardware,
+	.prepare_slave_config = snd_dmaengine_pcm_prepare_slave_config,
+	.compat_filter_fn = NULL,
+	.prealloc_buffer_size = PAGE_SIZE * 8,
+};
+
+int rockchip_pcm_platform_register(struct device *dev)
+{
+	return snd_dmaengine_pcm_register(dev, &rockchip_dmaengine_pcm_config,
+			SND_DMAENGINE_PCM_FLAG_COMPAT|
+			SND_DMAENGINE_PCM_FLAG_NO_RESIDUE);
+}
+EXPORT_SYMBOL_GPL(rockchip_pcm_platform_register);
+
+void rockchip_pcm_platform_unregister(struct device *dev)
+{
+	snd_dmaengine_pcm_unregister(dev);
+}
+EXPORT_SYMBOL_GPL(rockchip_pcm_platform_unregister);
+
+MODULE_DESCRIPTION("ROCKCHIP PCM ASoC Interface");
+MODULE_AUTHOR("jianqun <jay.xu@rock-chips.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5


