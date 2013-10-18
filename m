Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab3JRN0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:26:08 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15372 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab3JRN0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:26:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 18 Oct 2013 06:26:00 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v5 10/15] clk: tegra: move audio clk to common file
Date: Fri, 18 Oct 2013 16:25:14 +0300
Message-ID: <1382102719-5531-11-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1382102719-5531-1-git-send-email-pdeschrijver@nvidia.com>
References: <1382102719-5531-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move audio clocks and PLLA initialization to a common file so it can be used by
multiple Tegra SoCs. Also a new array tegra114_clks is introduced for Tegra114
which specifies which common clocks are available on Tegra114 and what their
DT IDs are.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/Makefile          |    1 +
 drivers/clk/tegra/clk-tegra-audio.c |  213 +++++++++++++++++++
 drivers/clk/tegra/clk-tegra114.c    |  390 ++++++++++++++++-------------------
 drivers/clk/tegra/clk.h             |    4 +
 4 files changed, 400 insertions(+), 208 deletions(-)
 create mode 100644 drivers/clk/tegra/clk-tegra-audio.c

diff --git a/drivers/clk/tegra/Makefile b/drivers/clk/tegra/Makefile
index f49fac2..796ff9a 100644
--- a/drivers/clk/tegra/Makefile
+++ b/drivers/clk/tegra/Makefile
@@ -6,6 +6,7 @@ obj-y					+= clk-periph-gate.o
 obj-y					+= clk-pll.o
 obj-y					+= clk-pll-out.o
 obj-y					+= clk-super.o
+obj-y					+= clk-tegra-audio.o
 
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clk-tegra20.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)         += clk-tegra30.o
diff --git a/drivers/clk/tegra/clk-tegra-audio.c b/drivers/clk/tegra/clk-tegra-audio.c
new file mode 100644
index 0000000..037adbe
--- /dev/null
+++ b/drivers/clk/tegra/clk-tegra-audio.c
@@ -0,0 +1,213 @@
+/*
+ * Copyright (c) 2012, 2013, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/delay.h>
+#include <linux/export.h>
+#include <linux/clk/tegra.h>
+
+#include "clk.h"
+#include "clk-id.h"
+
+#define AUDIO_SYNC_CLK_I2S0 0x4a0
+#define AUDIO_SYNC_CLK_I2S1 0x4a4
+#define AUDIO_SYNC_CLK_I2S2 0x4a8
+#define AUDIO_SYNC_CLK_I2S3 0x4ac
+#define AUDIO_SYNC_CLK_I2S4 0x4b0
+#define AUDIO_SYNC_CLK_SPDIF 0x4b4
+
+#define AUDIO_SYNC_DOUBLER 0x49c
+
+#define PLLA_OUT 0xb4
+
+#define PLL_BASE_LOCK BIT(27)
+#define PLL_MISC_LOCK_ENABLE 18
+
+struct tegra_sync_source_initdata {
+	char		*name;
+	unsigned long	rate;
+	unsigned long	max_rate;
+	int		clk_id;
+};
+
+struct tegra_audio_clk_initdata {
+	char		*gate_name;
+	char		*mux_name;
+	u32		offset;
+	int		gate_clk_id;
+	int		mux_clk_id;
+};
+
+#define AUDIO(_name, _offset) \
+	{\
+		.gate_name	= #_name,\
+		.mux_name	= #_name"_mux",\
+		.offset		= _offset,\
+		.gate_clk_id	= tegra_clk_ ## _name,\
+		.mux_clk_id	= tegra_clk_ ## _name ## _mux,\
+	}
+
+struct tegra_audio2x_clk_initdata {
+	char		*parent;
+	char		*gate_name;
+	char		*name_2x;
+	char		*div_name;
+	int		clk_id;
+	int		clk_num;
+	u8		div_offset;
+};
+
+#define AUDIO2X(_name, _num, _offset) \
+	{\
+		.parent		= #_name,\
+		.gate_name	= #_name"_2x",\
+		.name_2x	= #_name"_doubler",\
+		.div_name	= #_name"_div",\
+		.clk_id		= tegra_clk_ ## _name ## _2x,\
+		.clk_num	= _num,\
+		.div_offset	= _offset,\
+	}
+
+static DEFINE_SPINLOCK(clk_doubler_lock);
+
+static const char *mux_audio_sync_clk[] = { "spdif_in_sync", "i2s0_sync",
+	"i2s1_sync", "i2s2_sync", "i2s3_sync", "i2s4_sync", "vimclk_sync",
+};
+
+static struct tegra_sync_source_initdata sync_source_clks[] __initdata = {
+	{ .name = "spdif_in_sync", .rate = 24000000, .max_rate = 24000000, .clk_id = tegra_clk_spdif_in_sync},
+	{ .name = "i2s0_sync", .rate = 24000000, .max_rate = 24000000, .clk_id = tegra_clk_i2s0_sync},
+	{ .name = "i2s1_sync", .rate = 24000000, .max_rate = 24000000, .clk_id = tegra_clk_i2s1_sync},
+	{ .name = "i2s2_sync", .rate = 24000000, .max_rate = 24000000, .clk_id = tegra_clk_i2s2_sync},
+	{ .name = "i2s3_sync", .rate = 24000000, .max_rate = 24000000, .clk_id = tegra_clk_i2s3_sync},
+	{ .name = "i2s4_sync", .rate = 24000000, .max_rate = 24000000, .clk_id = tegra_clk_i2s4_sync},
+	{ .name = "vimclk_sync", .rate = 24000000, .max_rate = 24000000, .clk_id = tegra_clk_vimclk_sync},
+};
+
+static struct tegra_audio_clk_initdata audio_clks[] = {
+	AUDIO(audio0, AUDIO_SYNC_CLK_I2S0),
+	AUDIO(audio1, AUDIO_SYNC_CLK_I2S1),
+	AUDIO(audio2, AUDIO_SYNC_CLK_I2S2),
+	AUDIO(audio3, AUDIO_SYNC_CLK_I2S3),
+	AUDIO(audio4, AUDIO_SYNC_CLK_I2S4),
+	AUDIO(spdif, AUDIO_SYNC_CLK_SPDIF),
+};
+
+static struct tegra_audio2x_clk_initdata audio2x_clks[] = {
+	AUDIO2X(audio0, 113, 24),
+	AUDIO2X(audio1, 114, 25),
+	AUDIO2X(audio2, 115, 26),
+	AUDIO2X(audio3, 116, 27),
+	AUDIO2X(audio4, 117, 28),
+	AUDIO2X(spdif, 118, 29),
+};
+
+void __init tegra_audio_clk_init(void __iomem *clk_base,
+			void __iomem *pmc_base, struct tegra_clk *tegra_clks,
+			struct tegra_clk_pll_params *pll_a_params)
+{
+	struct clk *clk;
+	struct clk **dt_clk;
+	int i;
+
+	/* PLLA */
+	dt_clk = tegra_lookup_dt_id(tegra_clk_pll_a, tegra_clks);
+	if (dt_clk) {
+		clk = tegra_clk_register_pll("pll_a", "pll_p_out1", clk_base,
+				pmc_base, 0, pll_a_params, NULL);
+		clk_register_clkdev(clk, "pll_a", NULL);
+		*dt_clk = clk;
+	}
+
+	/* PLLA_OUT0 */
+	dt_clk = tegra_lookup_dt_id(tegra_clk_pll_a_out0, tegra_clks);
+	if (dt_clk) {
+		clk = tegra_clk_register_divider("pll_a_out0_div", "pll_a",
+				clk_base + PLLA_OUT, 0, TEGRA_DIVIDER_ROUND_UP,
+				8, 8, 1, NULL);
+		clk = tegra_clk_register_pll_out("pll_a_out0", "pll_a_out0_div",
+				clk_base + PLLA_OUT, 1, 0, CLK_IGNORE_UNUSED |
+				CLK_SET_RATE_PARENT, 0, NULL);
+		clk_register_clkdev(clk, "pll_a_out0", NULL);
+		*dt_clk = clk;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(sync_source_clks); i++) {
+		struct tegra_sync_source_initdata *data;
+
+		data = &sync_source_clks[i];
+
+		dt_clk = tegra_lookup_dt_id(data->clk_id, tegra_clks);
+		if (!dt_clk)
+			continue;
+
+		clk = tegra_clk_register_sync_source(data->name,
+					data->rate, data->max_rate);
+		*dt_clk = clk;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(audio_clks); i++) {
+		struct tegra_audio_clk_initdata *data;
+
+		data = &audio_clks[i];
+		dt_clk = tegra_lookup_dt_id(data->mux_clk_id, tegra_clks);
+
+		if (!dt_clk)
+			continue;
+		clk = clk_register_mux(NULL, data->mux_name, mux_audio_sync_clk,
+					ARRAY_SIZE(mux_audio_sync_clk),
+					CLK_SET_RATE_NO_REPARENT,
+					clk_base + data->offset, 0, 3, 0,
+					NULL);
+		*dt_clk = clk;
+
+		dt_clk = tegra_lookup_dt_id(data->gate_clk_id, tegra_clks);
+		if (!dt_clk)
+			continue;
+
+		clk = clk_register_gate(NULL, data->gate_name, data->mux_name,
+					0, clk_base + data->offset, 4,
+					CLK_GATE_SET_TO_DISABLE, NULL);
+		*dt_clk = clk;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(audio2x_clks); i++) {
+		struct tegra_audio2x_clk_initdata *data;
+
+		data = &audio2x_clks[i];
+		dt_clk = tegra_lookup_dt_id(data->clk_id, tegra_clks);
+		if (!dt_clk)
+			continue;
+
+		clk = clk_register_fixed_factor(NULL, data->name_2x,
+				data->parent, CLK_SET_RATE_PARENT, 2, 1);
+		clk = tegra_clk_register_divider(data->div_name,
+				data->name_2x, clk_base + AUDIO_SYNC_DOUBLER,
+				0, 0, data->div_offset, 1, 0,
+				&clk_doubler_lock);
+		clk = tegra_clk_register_periph_gate(data->gate_name,
+				data->div_name, TEGRA_PERIPH_NO_RESET,
+				clk_base, CLK_SET_RATE_PARENT, data->clk_num,
+				periph_clk_enb_refcnt);
+		*dt_clk = clk;
+	}
+}
+
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index 9082132..5d276fa 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -26,6 +26,7 @@
 #include <dt-bindings/clock/tegra114-car.h>
 
 #include "clk.h"
+#include "clk-id.h"
 
 #define RST_DFLL_DVCO			0x2F4
 #define CPU_FINETRIM_SELECT		0x4d4	/* override default prop dlys */
@@ -107,16 +108,6 @@
 #define PLLM_OUT 0x94
 #define PLLP_OUTA 0xa4
 #define PLLP_OUTB 0xa8
-#define PLLA_OUT 0xb4
-
-#define AUDIO_SYNC_CLK_I2S0 0x4a0
-#define AUDIO_SYNC_CLK_I2S1 0x4a4
-#define AUDIO_SYNC_CLK_I2S2 0x4a8
-#define AUDIO_SYNC_CLK_I2S3 0x4ac
-#define AUDIO_SYNC_CLK_I2S4 0x4b0
-#define AUDIO_SYNC_CLK_SPDIF 0x4b4
-
-#define AUDIO_SYNC_DOUBLER 0x49c
 
 #define PMC_CLK_OUT_CNTRL 0x1a8
 #define PMC_DPD_PADS_ORIDE 0x1c
@@ -272,7 +263,6 @@ static DEFINE_SPINLOCK(pll_d2_lock);
 static DEFINE_SPINLOCK(pll_u_lock);
 static DEFINE_SPINLOCK(pll_div_lock);
 static DEFINE_SPINLOCK(pll_re_lock);
-static DEFINE_SPINLOCK(clk_doubler_lock);
 static DEFINE_SPINLOCK(clk_out_lock);
 static DEFINE_SPINLOCK(sysrate_lock);
 
@@ -964,6 +954,186 @@ static const struct clk_div_table pll_re_div_table[] = {
 	{ .val = 0, .div = 0 },
 };
 
+static struct tegra_clk tegra114_clks[tegra_clk_max] __initdata = {
+	[tegra_clk_rtc] = { .dt_id = TEGRA114_CLK_RTC, .present = true },
+	[tegra_clk_timer] = { .dt_id = TEGRA114_CLK_TIMER, .present = true },
+	[tegra_clk_uarta] = { .dt_id = TEGRA114_CLK_UARTA, .present = true },
+	[tegra_clk_uartd] = { .dt_id = TEGRA114_CLK_UARTD, .present = true },
+	[tegra_clk_sdmmc2] = { .dt_id = TEGRA114_CLK_SDMMC2, .present = true },
+	[tegra_clk_i2s1] = { .dt_id = TEGRA114_CLK_I2S1, .present = true },
+	[tegra_clk_i2c1] = { .dt_id = TEGRA114_CLK_I2C1, .present = true },
+	[tegra_clk_ndflash] = { .dt_id = TEGRA114_CLK_NDFLASH, .present = true },
+	[tegra_clk_sdmmc1] = { .dt_id = TEGRA114_CLK_SDMMC1, .present = true },
+	[tegra_clk_sdmmc4] = { .dt_id = TEGRA114_CLK_SDMMC4, .present = true },
+	[tegra_clk_pwm] = { .dt_id = TEGRA114_CLK_PWM, .present = true },
+	[tegra_clk_i2s0] = { .dt_id = TEGRA114_CLK_I2S0, .present = true },
+	[tegra_clk_i2s2] = { .dt_id = TEGRA114_CLK_I2S2, .present = true },
+	[tegra_clk_epp_8] = { .dt_id = TEGRA114_CLK_EPP, .present = true },
+	[tegra_clk_gr2d_8] = { .dt_id = TEGRA114_CLK_GR2D, .present = true },
+	[tegra_clk_usbd] = { .dt_id = TEGRA114_CLK_USBD, .present = true },
+	[tegra_clk_isp] = { .dt_id = TEGRA114_CLK_ISP, .present = true },
+	[tegra_clk_gr3d_8] = { .dt_id = TEGRA114_CLK_GR3D, .present = true },
+	[tegra_clk_disp2] = { .dt_id = TEGRA114_CLK_DISP2, .present = true },
+	[tegra_clk_disp1] = { .dt_id = TEGRA114_CLK_DISP1, .present = true },
+	[tegra_clk_host1x_8] = { .dt_id = TEGRA114_CLK_HOST1X, .present = true },
+	[tegra_clk_vcp] = { .dt_id = TEGRA114_CLK_VCP, .present = true },
+	[tegra_clk_apbdma] = { .dt_id = TEGRA114_CLK_APBDMA, .present = true },
+	[tegra_clk_kbc] = { .dt_id = TEGRA114_CLK_KBC, .present = true },
+	[tegra_clk_kfuse] = { .dt_id = TEGRA114_CLK_KFUSE, .present = true },
+	[tegra_clk_sbc1_8] = { .dt_id = TEGRA114_CLK_SBC1, .present = true },
+	[tegra_clk_nor] = { .dt_id = TEGRA114_CLK_NOR, .present = true },
+	[tegra_clk_sbc2_8] = { .dt_id = TEGRA114_CLK_SBC2, .present = true },
+	[tegra_clk_sbc3_8] = { .dt_id = TEGRA114_CLK_SBC3, .present = true },
+	[tegra_clk_i2c5] = { .dt_id = TEGRA114_CLK_I2C5, .present = true },
+	[tegra_clk_dsia] = { .dt_id = TEGRA114_CLK_DSIA, .present = true },
+	[tegra_clk_mipi] = { .dt_id = TEGRA114_CLK_MIPI, .present = true },
+	[tegra_clk_hdmi] = { .dt_id = TEGRA114_CLK_HDMI, .present = true },
+	[tegra_clk_csi] = { .dt_id = TEGRA114_CLK_CSI, .present = true },
+	[tegra_clk_i2c2] = { .dt_id = TEGRA114_CLK_I2C2, .present = true },
+	[tegra_clk_uartc] = { .dt_id = TEGRA114_CLK_UARTC, .present = true },
+	[tegra_clk_mipi_cal] = { .dt_id = TEGRA114_CLK_MIPI_CAL, .present = true },
+	[tegra_clk_emc] = { .dt_id = TEGRA114_CLK_EMC, .present = true },
+	[tegra_clk_usb2] = { .dt_id = TEGRA114_CLK_USB2, .present = true },
+	[tegra_clk_usb3] = { .dt_id = TEGRA114_CLK_USB3, .present = true },
+	[tegra_clk_vde_8] = { .dt_id = TEGRA114_CLK_VDE, .present = true },
+	[tegra_clk_bsea] = { .dt_id = TEGRA114_CLK_BSEA, .present = true },
+	[tegra_clk_bsev] = { .dt_id = TEGRA114_CLK_BSEV, .present = true },
+	[tegra_clk_i2c3] = { .dt_id = TEGRA114_CLK_I2C3, .present = true },
+	[tegra_clk_sbc4_8] = { .dt_id = TEGRA114_CLK_SBC4, .present = true },
+	[tegra_clk_sdmmc3] = { .dt_id = TEGRA114_CLK_SDMMC3, .present = true },
+	[tegra_clk_owr] = { .dt_id = TEGRA114_CLK_OWR, .present = true },
+	[tegra_clk_csite] = { .dt_id = TEGRA114_CLK_CSITE, .present = true },
+	[tegra_clk_la] = { .dt_id = TEGRA114_CLK_LA, .present = true },
+	[tegra_clk_trace] = { .dt_id = TEGRA114_CLK_TRACE, .present = true },
+	[tegra_clk_soc_therm] = { .dt_id = TEGRA114_CLK_SOC_THERM, .present = true },
+	[tegra_clk_dtv] = { .dt_id = TEGRA114_CLK_DTV, .present = true },
+	[tegra_clk_ndspeed] = { .dt_id = TEGRA114_CLK_NDSPEED, .present = true },
+	[tegra_clk_i2cslow] = { .dt_id = TEGRA114_CLK_I2CSLOW, .present = true },
+	[tegra_clk_dsib] = { .dt_id = TEGRA114_CLK_DSIB, .present = true },
+	[tegra_clk_tsec] = { .dt_id = TEGRA114_CLK_TSEC, .present = true },
+	[tegra_clk_xusb_host] = { .dt_id = TEGRA114_CLK_XUSB_HOST, .present = true },
+	[tegra_clk_msenc] = { .dt_id = TEGRA114_CLK_MSENC, .present = true },
+	[tegra_clk_csus] = { .dt_id = TEGRA114_CLK_CSUS, .present = true },
+	[tegra_clk_mselect] = { .dt_id = TEGRA114_CLK_MSELECT, .present = true },
+	[tegra_clk_tsensor] = { .dt_id = TEGRA114_CLK_TSENSOR, .present = true },
+	[tegra_clk_i2s3] = { .dt_id = TEGRA114_CLK_I2S3, .present = true },
+	[tegra_clk_i2s4] = { .dt_id = TEGRA114_CLK_I2S4, .present = true },
+	[tegra_clk_i2c4] = { .dt_id = TEGRA114_CLK_I2C4, .present = true },
+	[tegra_clk_sbc5_8] = { .dt_id = TEGRA114_CLK_SBC5, .present = true },
+	[tegra_clk_sbc6_8] = { .dt_id = TEGRA114_CLK_SBC6, .present = true },
+	[tegra_clk_d_audio] = { .dt_id = TEGRA114_CLK_D_AUDIO, .present = true },
+	[tegra_clk_apbif] = { .dt_id = TEGRA114_CLK_APBIF, .present = true },
+	[tegra_clk_dam0] = { .dt_id = TEGRA114_CLK_DAM0, .present = true },
+	[tegra_clk_dam1] = { .dt_id = TEGRA114_CLK_DAM1, .present = true },
+	[tegra_clk_dam2] = { .dt_id = TEGRA114_CLK_DAM2, .present = true },
+	[tegra_clk_hda2codec_2x] = { .dt_id = TEGRA114_CLK_HDA2CODEC_2X, .present = true },
+	[tegra_clk_audio0_2x] = { .dt_id = TEGRA114_CLK_AUDIO0_2X, .present = true },
+	[tegra_clk_audio1_2x] = { .dt_id = TEGRA114_CLK_AUDIO1_2X, .present = true },
+	[tegra_clk_audio2_2x] = { .dt_id = TEGRA114_CLK_AUDIO2_2X, .present = true },
+	[tegra_clk_audio3_2x] = { .dt_id = TEGRA114_CLK_AUDIO3_2X, .present = true },
+	[tegra_clk_audio4_2x] = { .dt_id = TEGRA114_CLK_AUDIO4_2X, .present = true },
+	[tegra_clk_spdif_2x] = { .dt_id = TEGRA114_CLK_SPDIF_2X, .present = true },
+	[tegra_clk_actmon] = { .dt_id = TEGRA114_CLK_ACTMON, .present = true },
+	[tegra_clk_extern1] = { .dt_id = TEGRA114_CLK_EXTERN1, .present = true },
+	[tegra_clk_extern2] = { .dt_id = TEGRA114_CLK_EXTERN2, .present = true },
+	[tegra_clk_extern3] = { .dt_id = TEGRA114_CLK_EXTERN3, .present = true },
+	[tegra_clk_hda] = { .dt_id = TEGRA114_CLK_HDA, .present = true },
+	[tegra_clk_se] = { .dt_id = TEGRA114_CLK_SE, .present = true },
+	[tegra_clk_hda2hdmi] = { .dt_id = TEGRA114_CLK_HDA2HDMI, .present = true },
+	[tegra_clk_cilab] = { .dt_id = TEGRA114_CLK_CILAB, .present = true },
+	[tegra_clk_cilcd] = { .dt_id = TEGRA114_CLK_CILCD, .present = true },
+	[tegra_clk_cile] = { .dt_id = TEGRA114_CLK_CILE, .present = true },
+	[tegra_clk_dsialp] = { .dt_id = TEGRA114_CLK_DSIALP, .present = true },
+	[tegra_clk_dsiblp] = { .dt_id = TEGRA114_CLK_DSIBLP, .present = true },
+	[tegra_clk_dds] = { .dt_id = TEGRA114_CLK_DDS, .present = true },
+	[tegra_clk_dp2] = { .dt_id = TEGRA114_CLK_DP2, .present = true },
+	[tegra_clk_amx] = { .dt_id = TEGRA114_CLK_AMX, .present = true },
+	[tegra_clk_adx] = { .dt_id = TEGRA114_CLK_ADX, .present = true },
+	[tegra_clk_xusb_ss] = { .dt_id = TEGRA114_CLK_XUSB_SS, .present = true },
+	[tegra_clk_uartb] = { .dt_id = TEGRA114_CLK_UARTB, .present = true },
+	[tegra_clk_vfir] = { .dt_id = TEGRA114_CLK_VFIR, .present = true },
+	[tegra_clk_spdif_in] = { .dt_id = TEGRA114_CLK_SPDIF_IN, .present = true },
+	[tegra_clk_spdif_out] = { .dt_id = TEGRA114_CLK_SPDIF_OUT, .present = true },
+	[tegra_clk_vi_8] = { .dt_id = TEGRA114_CLK_VI, .present = true },
+	[tegra_clk_vi_sensor_8] = { .dt_id = TEGRA114_CLK_VI_SENSOR, .present = true },
+	[tegra_clk_fuse] = { .dt_id = TEGRA114_CLK_FUSE, .present = true },
+	[tegra_clk_fuse_burn] = { .dt_id = TEGRA114_CLK_FUSE_BURN, .present = true },
+	[tegra_clk_clk_32k] = { .dt_id = TEGRA114_CLK_CLK_32K, .present = true },
+	[tegra_clk_clk_m] = { .dt_id = TEGRA114_CLK_CLK_M, .present = true },
+	[tegra_clk_clk_m_div2] = { .dt_id = TEGRA114_CLK_CLK_M_DIV2, .present = true },
+	[tegra_clk_clk_m_div4] = { .dt_id = TEGRA114_CLK_CLK_M_DIV4, .present = true },
+	[tegra_clk_pll_ref] = { .dt_id = TEGRA114_CLK_PLL_REF, .present = true },
+	[tegra_clk_pll_c] = { .dt_id = TEGRA114_CLK_PLL_C, .present = true },
+	[tegra_clk_pll_c_out1] = { .dt_id = TEGRA114_CLK_PLL_C_OUT1, .present = true },
+	[tegra_clk_pll_c2] = { .dt_id = TEGRA114_CLK_PLL_C2, .present = true },
+	[tegra_clk_pll_c3] = { .dt_id = TEGRA114_CLK_PLL_C3, .present = true },
+	[tegra_clk_pll_m] = { .dt_id = TEGRA114_CLK_PLL_M, .present = true },
+	[tegra_clk_pll_m_out1] = { .dt_id = TEGRA114_CLK_PLL_M_OUT1, .present = true },
+	[tegra_clk_pll_p] = { .dt_id = TEGRA114_CLK_PLL_P, .present = true },
+	[tegra_clk_pll_p_out1] = { .dt_id = TEGRA114_CLK_PLL_P_OUT1, .present = true },
+	[tegra_clk_pll_p_out2_int] = { .dt_id = TEGRA114_CLK_PLL_P_OUT2, .present = true },
+	[tegra_clk_pll_p_out3] = { .dt_id = TEGRA114_CLK_PLL_P_OUT3, .present = true },
+	[tegra_clk_pll_p_out4] = { .dt_id = TEGRA114_CLK_PLL_P_OUT4, .present = true },
+	[tegra_clk_pll_a] = { .dt_id = TEGRA114_CLK_PLL_A, .present = true },
+	[tegra_clk_pll_a_out0] = { .dt_id = TEGRA114_CLK_PLL_A_OUT0, .present = true },
+	[tegra_clk_pll_d] = { .dt_id = TEGRA114_CLK_PLL_D, .present = true },
+	[tegra_clk_pll_d_out0] = { .dt_id = TEGRA114_CLK_PLL_D_OUT0, .present = true },
+	[tegra_clk_pll_d2] = { .dt_id = TEGRA114_CLK_PLL_D2, .present = true },
+	[tegra_clk_pll_d2_out0] = { .dt_id = TEGRA114_CLK_PLL_D2_OUT0, .present = true },
+	[tegra_clk_pll_u] = { .dt_id = TEGRA114_CLK_PLL_U, .present = true },
+	[tegra_clk_pll_u_480m] = { .dt_id = TEGRA114_CLK_PLL_U_480M, .present = true },
+	[tegra_clk_pll_u_60m] = { .dt_id = TEGRA114_CLK_PLL_U_60M, .present = true },
+	[tegra_clk_pll_u_48m] = { .dt_id = TEGRA114_CLK_PLL_U_48M, .present = true },
+	[tegra_clk_pll_u_12m] = { .dt_id = TEGRA114_CLK_PLL_U_12M, .present = true },
+	[tegra_clk_pll_x] = { .dt_id = TEGRA114_CLK_PLL_X, .present = true },
+	[tegra_clk_pll_x_out0] = { .dt_id = TEGRA114_CLK_PLL_X_OUT0, .present = true },
+	[tegra_clk_pll_re_vco] = { .dt_id = TEGRA114_CLK_PLL_RE_VCO, .present = true },
+	[tegra_clk_pll_re_out] = { .dt_id = TEGRA114_CLK_PLL_RE_OUT, .present = true },
+	[tegra_clk_pll_e_out0] = { .dt_id = TEGRA114_CLK_PLL_E_OUT0, .present = true },
+	[tegra_clk_spdif_in_sync] = { .dt_id = TEGRA114_CLK_SPDIF_IN_SYNC, .present = true },
+	[tegra_clk_i2s0_sync] = { .dt_id = TEGRA114_CLK_I2S0_SYNC, .present = true },
+	[tegra_clk_i2s1_sync] = { .dt_id = TEGRA114_CLK_I2S1_SYNC, .present = true },
+	[tegra_clk_i2s2_sync] = { .dt_id = TEGRA114_CLK_I2S2_SYNC, .present = true },
+	[tegra_clk_i2s3_sync] = { .dt_id = TEGRA114_CLK_I2S3_SYNC, .present = true },
+	[tegra_clk_i2s4_sync] = { .dt_id = TEGRA114_CLK_I2S4_SYNC, .present = true },
+	[tegra_clk_vimclk_sync] = { .dt_id = TEGRA114_CLK_VIMCLK_SYNC, .present = true },
+	[tegra_clk_audio0] = { .dt_id = TEGRA114_CLK_AUDIO0, .present = true },
+	[tegra_clk_audio1] = { .dt_id = TEGRA114_CLK_AUDIO1, .present = true },
+	[tegra_clk_audio2] = { .dt_id = TEGRA114_CLK_AUDIO2, .present = true },
+	[tegra_clk_audio3] = { .dt_id = TEGRA114_CLK_AUDIO3, .present = true },
+	[tegra_clk_audio4] = { .dt_id = TEGRA114_CLK_AUDIO4, .present = true },
+	[tegra_clk_spdif] = { .dt_id = TEGRA114_CLK_SPDIF, .present = true },
+	[tegra_clk_clk_out_1] = { .dt_id = TEGRA114_CLK_CLK_OUT_1, .present = true },
+	[tegra_clk_clk_out_2] = { .dt_id = TEGRA114_CLK_CLK_OUT_2, .present = true },
+	[tegra_clk_clk_out_3] = { .dt_id = TEGRA114_CLK_CLK_OUT_3, .present = true },
+	[tegra_clk_blink] = { .dt_id = TEGRA114_CLK_BLINK, .present = true },
+	[tegra_clk_xusb_host_src] = { .dt_id = TEGRA114_CLK_XUSB_HOST_SRC, .present = true },
+	[tegra_clk_xusb_falcon_src] = { .dt_id = TEGRA114_CLK_XUSB_FALCON_SRC, .present = true },
+	[tegra_clk_xusb_fs_src] = { .dt_id = TEGRA114_CLK_XUSB_FS_SRC, .present = true },
+	[tegra_clk_xusb_ss_src] = { .dt_id = TEGRA114_CLK_XUSB_SS_SRC, .present = true },
+	[tegra_clk_xusb_dev_src] = { .dt_id = TEGRA114_CLK_XUSB_DEV_SRC, .present = true },
+	[tegra_clk_xusb_dev] = { .dt_id = TEGRA114_CLK_XUSB_DEV, .present = true },
+	[tegra_clk_xusb_hs_src] = { .dt_id = TEGRA114_CLK_XUSB_HS_SRC, .present = true },
+	[tegra_clk_sclk] = { .dt_id = TEGRA114_CLK_SCLK, .present = true },
+	[tegra_clk_hclk] = { .dt_id = TEGRA114_CLK_HCLK, .present = true },
+	[tegra_clk_pclk] = { .dt_id = TEGRA114_CLK_PCLK, .present = true },
+	[tegra_clk_cclk_g] = { .dt_id = TEGRA114_CLK_CCLK_G, .present = true },
+	[tegra_clk_cclk_lp] = { .dt_id = TEGRA114_CLK_CCLK_LP, .present = true },
+	[tegra_clk_dfll_ref] = { .dt_id = TEGRA114_CLK_DFLL_REF, .present = true },
+	[tegra_clk_dfll_soc] = { .dt_id = TEGRA114_CLK_DFLL_SOC, .present = true },
+	[tegra_clk_audio0_mux] = { .dt_id = TEGRA114_CLK_AUDIO0_MUX, .present = true },
+	[tegra_clk_audio1_mux] = { .dt_id = TEGRA114_CLK_AUDIO1_MUX, .present = true },
+	[tegra_clk_audio2_mux] = { .dt_id = TEGRA114_CLK_AUDIO2_MUX, .present = true },
+	[tegra_clk_audio3_mux] = { .dt_id = TEGRA114_CLK_AUDIO3_MUX, .present = true },
+	[tegra_clk_audio4_mux] = { .dt_id = TEGRA114_CLK_AUDIO4_MUX, .present = true },
+	[tegra_clk_spdif_mux] = { .dt_id = TEGRA114_CLK_SPDIF_MUX, .present = true },
+	[tegra_clk_clk_out_1_mux] = { .dt_id = TEGRA114_CLK_CLK_OUT_1_MUX, .present = true },
+	[tegra_clk_clk_out_2_mux] = { .dt_id = TEGRA114_CLK_CLK_OUT_2_MUX, .present = true },
+	[tegra_clk_clk_out_3_mux] = { .dt_id = TEGRA114_CLK_CLK_OUT_3_MUX, .present = true },
+	[tegra_clk_dsia_mux] = { .dt_id = TEGRA114_CLK_DSIA_MUX, .present = true },
+	[tegra_clk_dsib_mux] = { .dt_id = TEGRA114_CLK_DSIB_MUX, .present = true },
+};
+
 static struct tegra_devclk devclks[] __initdata = {
 	{ .con_id = "clk_m", .dt_id = TEGRA114_CLK_CLK_M },
 	{ .con_id = "pll_ref", .dt_id = TEGRA114_CLK_PLL_REF },
@@ -1325,20 +1495,6 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 					CLK_SET_RATE_PARENT, 1, 2);
 	clks[TEGRA114_CLK_PLL_D2_OUT0] = clk;
 
-	/* PLLA */
-	clk = tegra_clk_register_pll("pll_a", "pll_p_out1", clk_base, pmc, 0,
-			    &pll_a_params, NULL);
-	clks[TEGRA114_CLK_PLL_A] = clk;
-
-	/* PLLA_OUT0 */
-	clk = tegra_clk_register_divider("pll_a_out0_div", "pll_a",
-				clk_base + PLLA_OUT, 0, TEGRA_DIVIDER_ROUND_UP,
-				8, 8, 1, NULL);
-	clk = tegra_clk_register_pll_out("pll_a_out0", "pll_a_out0_div",
-				clk_base + PLLA_OUT, 1, 0, CLK_IGNORE_UNUSED |
-				CLK_SET_RATE_PARENT, 0, NULL);
-	clks[TEGRA114_CLK_PLL_A_OUT0] = clk;
-
 	/* PLLRE */
 	clk = tegra_clk_register_pllre("pll_re_vco", "pll_ref", clk_base, pmc,
 			     0, &pll_re_vco_params, &pll_re_lock, pll_ref_freq);
@@ -1355,10 +1511,6 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	clks[TEGRA114_CLK_PLL_E_OUT0] = clk;
 }
 
-static const char *mux_audio_sync_clk[] = { "spdif_in_sync", "i2s0_sync",
-	"i2s1_sync", "i2s2_sync", "i2s3_sync", "i2s4_sync", "vimclk_sync",
-};
-
 static const char *clk_out1_parents[] = { "clk_m", "clk_m_div2",
 	"clk_m_div4", "extern1",
 };
@@ -1371,184 +1523,6 @@ static const char *clk_out3_parents[] = { "clk_m", "clk_m_div2",
 	"clk_m_div4", "extern3",
 };
 
-static void __init tegra114_audio_clk_init(void __iomem *clk_base)
-{
-	struct clk *clk;
-
-	/* spdif_in_sync */
-	clk = tegra_clk_register_sync_source("spdif_in_sync", 24000000,
-					     24000000);
-	clks[TEGRA114_CLK_SPDIF_IN_SYNC] = clk;
-
-	/* i2s0_sync */
-	clk = tegra_clk_register_sync_source("i2s0_sync", 24000000, 24000000);
-	clks[TEGRA114_CLK_I2S0_SYNC] = clk;
-
-	/* i2s1_sync */
-	clk = tegra_clk_register_sync_source("i2s1_sync", 24000000, 24000000);
-	clks[TEGRA114_CLK_I2S1_SYNC] = clk;
-
-	/* i2s2_sync */
-	clk = tegra_clk_register_sync_source("i2s2_sync", 24000000, 24000000);
-	clks[TEGRA114_CLK_I2S2_SYNC] = clk;
-
-	/* i2s3_sync */
-	clk = tegra_clk_register_sync_source("i2s3_sync", 24000000, 24000000);
-	clks[TEGRA114_CLK_I2S3_SYNC] = clk;
-
-	/* i2s4_sync */
-	clk = tegra_clk_register_sync_source("i2s4_sync", 24000000, 24000000);
-	clks[TEGRA114_CLK_I2S4_SYNC] = clk;
-
-	/* vimclk_sync */
-	clk = tegra_clk_register_sync_source("vimclk_sync", 24000000, 24000000);
-	clks[TEGRA114_CLK_VIMCLK_SYNC] = clk;
-
-	/* audio0 */
-	clk = clk_register_mux(NULL, "audio0_mux", mux_audio_sync_clk,
-			       ARRAY_SIZE(mux_audio_sync_clk),
-			       CLK_SET_RATE_NO_REPARENT,
-			       clk_base + AUDIO_SYNC_CLK_I2S0, 0, 3, 0,
-			       NULL);
-	clks[TEGRA114_CLK_AUDIO0_MUX] = clk;
-	clk = clk_register_gate(NULL, "audio0", "audio0_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S0, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clks[TEGRA114_CLK_AUDIO0] = clk;
-
-	/* audio1 */
-	clk = clk_register_mux(NULL, "audio1_mux", mux_audio_sync_clk,
-			       ARRAY_SIZE(mux_audio_sync_clk),
-			       CLK_SET_RATE_NO_REPARENT,
-			       clk_base + AUDIO_SYNC_CLK_I2S1, 0, 3, 0,
-			       NULL);
-	clks[TEGRA114_CLK_AUDIO1_MUX] = clk;
-	clk = clk_register_gate(NULL, "audio1", "audio1_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S1, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clks[TEGRA114_CLK_AUDIO1] = clk;
-
-	/* audio2 */
-	clk = clk_register_mux(NULL, "audio2_mux", mux_audio_sync_clk,
-			       ARRAY_SIZE(mux_audio_sync_clk),
-			       CLK_SET_RATE_NO_REPARENT,
-			       clk_base + AUDIO_SYNC_CLK_I2S2, 0, 3, 0,
-			       NULL);
-	clks[TEGRA114_CLK_AUDIO2_MUX] = clk;
-	clk = clk_register_gate(NULL, "audio2", "audio2_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S2, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clks[TEGRA114_CLK_AUDIO2] = clk;
-
-	/* audio3 */
-	clk = clk_register_mux(NULL, "audio3_mux", mux_audio_sync_clk,
-			       ARRAY_SIZE(mux_audio_sync_clk),
-			       CLK_SET_RATE_NO_REPARENT,
-			       clk_base + AUDIO_SYNC_CLK_I2S3, 0, 3, 0,
-			       NULL);
-	clks[TEGRA114_CLK_AUDIO3_MUX] = clk;
-	clk = clk_register_gate(NULL, "audio3", "audio3_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S3, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clks[TEGRA114_CLK_AUDIO3] = clk;
-
-	/* audio4 */
-	clk = clk_register_mux(NULL, "audio4_mux", mux_audio_sync_clk,
-			       ARRAY_SIZE(mux_audio_sync_clk),
-			       CLK_SET_RATE_NO_REPARENT,
-			       clk_base + AUDIO_SYNC_CLK_I2S4, 0, 3, 0,
-			       NULL);
-	clks[TEGRA114_CLK_AUDIO4_MUX] = clk;
-	clk = clk_register_gate(NULL, "audio4", "audio4_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S4, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clks[TEGRA114_CLK_AUDIO4] = clk;
-
-	/* spdif */
-	clk = clk_register_mux(NULL, "spdif_mux", mux_audio_sync_clk,
-			       ARRAY_SIZE(mux_audio_sync_clk),
-			       CLK_SET_RATE_NO_REPARENT,
-			       clk_base + AUDIO_SYNC_CLK_SPDIF, 0, 3, 0,
-			       NULL);
-	clks[TEGRA114_CLK_SPDIF_MUX] = clk;
-	clk = clk_register_gate(NULL, "spdif", "spdif_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_SPDIF, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clks[TEGRA114_CLK_SPDIF] = clk;
-
-	/* audio0_2x */
-	clk = clk_register_fixed_factor(NULL, "audio0_doubler", "audio0",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("audio0_div", "audio0_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 24, 1,
-				0, &clk_doubler_lock);
-	clk = tegra_clk_register_periph_gate("audio0_2x", "audio0_div",
-				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 113,
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_AUDIO0_2X] = clk;
-
-	/* audio1_2x */
-	clk = clk_register_fixed_factor(NULL, "audio1_doubler", "audio1",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("audio1_div", "audio1_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 25, 1,
-				0, &clk_doubler_lock);
-	clk = tegra_clk_register_periph_gate("audio1_2x", "audio1_div",
-				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 114,
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_AUDIO1_2X] = clk;
-
-	/* audio2_2x */
-	clk = clk_register_fixed_factor(NULL, "audio2_doubler", "audio2",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("audio2_div", "audio2_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 26, 1,
-				0, &clk_doubler_lock);
-	clk = tegra_clk_register_periph_gate("audio2_2x", "audio2_div",
-				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 115,
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_AUDIO2_2X] = clk;
-
-	/* audio3_2x */
-	clk = clk_register_fixed_factor(NULL, "audio3_doubler", "audio3",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("audio3_div", "audio3_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 27, 1,
-				0, &clk_doubler_lock);
-	clk = tegra_clk_register_periph_gate("audio3_2x", "audio3_div",
-				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 116,
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_AUDIO3_2X] = clk;
-
-	/* audio4_2x */
-	clk = clk_register_fixed_factor(NULL, "audio4_doubler", "audio4",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("audio4_div", "audio4_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 28, 1,
-				0, &clk_doubler_lock);
-	clk = tegra_clk_register_periph_gate("audio4_2x", "audio4_div",
-				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 117,
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_AUDIO4_2X] = clk;
-
-	/* spdif_2x */
-	clk = clk_register_fixed_factor(NULL, "spdif_doubler", "spdif",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("spdif_div", "spdif_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 29, 1,
-				0, &clk_doubler_lock);
-	clk = tegra_clk_register_periph_gate("spdif_2x", "spdif_div",
-				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 118,
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_SPDIF_2X] = clk;
-}
-
 static void __init tegra114_pmc_clk_init(void __iomem *pmc_base)
 {
 	struct clk *clk;
@@ -2195,7 +2169,7 @@ static void __init tegra114_clock_init(struct device_node *np)
 	tegra114_fixed_clk_init(clk_base);
 	tegra114_pll_init(clk_base, pmc_base);
 	tegra114_periph_clk_init(clk_base);
-	tegra114_audio_clk_init(clk_base);
+	tegra_audio_clk_init(clk_base, pmc_base, tegra114_clks, &pll_a_params);
 	tegra114_pmc_clk_init(pmc_base);
 	tegra114_super_clk_init(clk_base);
 
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index f742c7d..3306e41 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -593,6 +593,10 @@ struct clk **tegra_lookup_dt_id(int clk_id, struct tegra_clk *tegra_clk);
 void tegra_add_of_provider(struct device_node *np);
 void tegra_register_devclks(struct tegra_devclk *dev_clks, int num);
 
+void tegra_audio_clk_init(void __iomem *clk_base,
+			void __iomem *pmc_base, struct tegra_clk *tegra_clks,
+			struct tegra_clk_pll_params *pll_params);
+
 void tegra114_clock_tune_cpu_trimmers_high(void);
 void tegra114_clock_tune_cpu_trimmers_low(void);
 void tegra114_clock_tune_cpu_trimmers_init(void);
-- 
1.7.7.rc0.72.g4b5ea.dirty

