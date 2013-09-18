Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3IROxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:53:46 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13348 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab3IROxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:53:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 18 Sep 2013 07:53:43 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH 08/12] clk: tegra: move periph clocks to common file
Date: Wed, 18 Sep 2013 17:41:00 +0300
Message-ID: <1379515331-19427-9-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com>
References: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new file for peripheral clocks common between several Tegra
SoCs and move Tegra114 to this new infrastructure. Also PLLP and the PLLP_OUT
clocks will be initialized here.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/Makefile           |    2 +-
 drivers/clk/tegra/clk-tegra-periph.c |  595 +++++++++++++++++++++++++++++++
 drivers/clk/tegra/clk-tegra114.c     |  635 +---------------------------------
 drivers/clk/tegra/clk-tegra20.c      |    4 +-
 drivers/clk/tegra/clk-tegra30.c      |    4 +-
 drivers/clk/tegra/clk.h              |   10 +-
 6 files changed, 624 insertions(+), 626 deletions(-)
 create mode 100644 drivers/clk/tegra/clk-tegra-periph.c

diff --git a/drivers/clk/tegra/Makefile b/drivers/clk/tegra/Makefile
index 796ff9a..304ea5d 100644
--- a/drivers/clk/tegra/Makefile
+++ b/drivers/clk/tegra/Makefile
@@ -7,7 +7,7 @@ obj-y					+= clk-pll.o
 obj-y					+= clk-pll-out.o
 obj-y					+= clk-super.o
 obj-y					+= clk-tegra-audio.o
-
+obj-y					+= clk-tegra-periph.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clk-tegra20.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)         += clk-tegra30.o
 obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= clk-tegra114.o
diff --git a/drivers/clk/tegra/clk-tegra-periph.c b/drivers/clk/tegra/clk-tegra-periph.c
new file mode 100644
index 0000000..6599024
--- /dev/null
+++ b/drivers/clk/tegra/clk-tegra-periph.c
@@ -0,0 +1,595 @@
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
+#define CLK_SOURCE_I2S0 0x1d8
+#define CLK_SOURCE_I2S1 0x100
+#define CLK_SOURCE_I2S2 0x104
+#define CLK_SOURCE_NDFLASH 0x160
+#define CLK_SOURCE_I2S3 0x3bc
+#define CLK_SOURCE_I2S4 0x3c0
+#define CLK_SOURCE_SPDIF_OUT 0x108
+#define CLK_SOURCE_SPDIF_IN 0x10c
+#define CLK_SOURCE_PWM 0x110
+#define CLK_SOURCE_ADX 0x638
+#define CLK_SOURCE_AMX 0x63c
+#define CLK_SOURCE_HDA 0x428
+#define CLK_SOURCE_HDA2CODEC_2X 0x3e4
+#define CLK_SOURCE_SBC1 0x134
+#define CLK_SOURCE_SBC2 0x118
+#define CLK_SOURCE_SBC3 0x11c
+#define CLK_SOURCE_SBC4 0x1b4
+#define CLK_SOURCE_SBC5 0x3c8
+#define CLK_SOURCE_SBC6 0x3cc
+#define CLK_SOURCE_SATA_OOB 0x420
+#define CLK_SOURCE_SATA 0x424
+#define CLK_SOURCE_NDSPEED 0x3f8
+#define CLK_SOURCE_VFIR 0x168
+#define CLK_SOURCE_SDMMC1 0x150
+#define CLK_SOURCE_SDMMC2 0x154
+#define CLK_SOURCE_SDMMC3 0x1bc
+#define CLK_SOURCE_SDMMC4 0x164
+#define CLK_SOURCE_VDE 0x1c8
+#define CLK_SOURCE_CSITE 0x1d4
+#define CLK_SOURCE_LA 0x1f8
+#define CLK_SOURCE_TRACE 0x634
+#define CLK_SOURCE_OWR 0x1cc
+#define CLK_SOURCE_NOR 0x1d0
+#define CLK_SOURCE_MIPI 0x174
+#define CLK_SOURCE_I2C1 0x124
+#define CLK_SOURCE_I2C2 0x198
+#define CLK_SOURCE_I2C3 0x1b8
+#define CLK_SOURCE_I2C4 0x3c4
+#define CLK_SOURCE_I2C5 0x128
+#define CLK_SOURCE_UARTA 0x178
+#define CLK_SOURCE_UARTB 0x17c
+#define CLK_SOURCE_UARTC 0x1a0
+#define CLK_SOURCE_UARTD 0x1c0
+#define CLK_SOURCE_VI_SENSOR 0x1a8
+#define CLK_SOURCE_VI 0x148
+#define CLK_SOURCE_EPP 0x16c
+#define CLK_SOURCE_MSENC 0x1f0
+#define CLK_SOURCE_TSEC 0x1f4
+#define CLK_SOURCE_HOST1X 0x180
+#define CLK_SOURCE_HDMI 0x18c
+#define CLK_SOURCE_DISP1 0x138
+#define CLK_SOURCE_DISP2 0x13c
+#define CLK_SOURCE_CILAB 0x614
+#define CLK_SOURCE_CILCD 0x618
+#define CLK_SOURCE_CILE 0x61c
+#define CLK_SOURCE_DSIALP 0x620
+#define CLK_SOURCE_DSIBLP 0x624
+#define CLK_SOURCE_TSENSOR 0x3b8
+#define CLK_SOURCE_D_AUDIO 0x3d0
+#define CLK_SOURCE_DAM0 0x3d8
+#define CLK_SOURCE_DAM1 0x3dc
+#define CLK_SOURCE_DAM2 0x3e0
+#define CLK_SOURCE_ACTMON 0x3e8
+#define CLK_SOURCE_EXTERN1 0x3ec
+#define CLK_SOURCE_EXTERN2 0x3f0
+#define CLK_SOURCE_EXTERN3 0x3f4
+#define CLK_SOURCE_I2CSLOW 0x3fc
+#define CLK_SOURCE_SE 0x42c
+#define CLK_SOURCE_MSELECT 0x3b4
+#define CLK_SOURCE_DFLL_REF 0x62c
+#define CLK_SOURCE_DFLL_SOC 0x630
+#define CLK_SOURCE_SOC_THERM 0x644
+#define CLK_SOURCE_XUSB_HOST_SRC 0x600
+#define CLK_SOURCE_XUSB_FALCON_SRC 0x604
+#define CLK_SOURCE_XUSB_FS_SRC 0x608
+#define CLK_SOURCE_XUSB_SS_SRC 0x610
+#define CLK_SOURCE_XUSB_DEV_SRC 0x60c
+
+#define MASK(x) (BIT(x) - 1)
+
+#define MUX(_name, _con_id, _dev_id, _parents, _offset,	\
+			    _clk_num, _gate_flags, _clk_id)	\
+	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
+			30, MASK(2), 0, 0, 8, 1, 0, 0,\
+			_clk_num,  _gate_flags, _clk_id, _parents##_idx, 0)
+
+#define MUX_FLAGS(_name, _con_id, _dev_id, _parents, _offset,\
+			    _clk_num, _gate_flags, _clk_id, flags)\
+	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
+			30, MASK(2), 0, 0, 8, 1, 0, 0, _clk_num,	\
+			_gate_flags, _clk_id, _parents##_idx, flags)
+
+#define MUX8(_name, _con_id, _dev_id, _parents, _offset, \
+			     _clk_num, _gate_flags, _clk_id)	\
+	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
+			29, MASK(3), 0, 0, 8, 1, 0, 0, _clk_num,	\
+			_gate_flags, _clk_id, _parents##_idx, 0)
+
+#define INT(_name, _con_id, _dev_id, _parents, _offset,	\
+			    _clk_num, _gate_flags, _clk_id)	\
+	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
+			30, MASK(2), 0, 0, 8, 1, TEGRA_DIVIDER_INT, 0,\
+			_clk_num, _gate_flags, _clk_id, _parents##_idx, 0)
+
+#define INT_FLAGS(_name, _con_id, _dev_id, _parents, _offset,\
+			    _clk_num, _gate_flags, _clk_id, flags)\
+	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
+			30, MASK(2), 0, 0, 8, 1, TEGRA_DIVIDER_INT, 0,\
+			_clk_num,  _gate_flags, _clk_id, _parents##_idx, flags)
+
+#define INT8(_name, _con_id, _dev_id, _parents, _offset,\
+			    _clk_num, _gate_flags, _clk_id)	\
+	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
+			29, MASK(3), 0, 0, 8, 1, TEGRA_DIVIDER_INT, 0,\
+			_clk_num, _gate_flags, _clk_id, _parents##_idx, 0)
+
+#define UART(_name, _con_id, _dev_id, _parents, _offset,\
+			     _clk_num, _clk_id)			\
+	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
+			30, MASK(2), 0, 0, 16, 1, TEGRA_DIVIDER_UART, 0,\
+			_clk_num, 0, _clk_id, _parents##_idx, 0)
+
+#define I2C(_name, _con_id, _dev_id, _parents, _offset,\
+			     _clk_num, _clk_id)			\
+	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
+			30, MASK(2), 0, 0, 16, 0, 0, 0, _clk_num,	\
+			0, _clk_id, _parents##_idx, 0)
+
+#define XUSB(_name, _con_id, _dev_id, _parents, _offset, \
+			     _clk_num, _gate_flags, _clk_id)	 \
+	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset, \
+			29, MASK(3), 0, 0, 8, 1, TEGRA_DIVIDER_INT, 0, \
+			_clk_num, _gate_flags, _clk_id, _parents##_idx, 0)
+
+#define AUDIO(_name, _con_id, _dev_id, _offset,  _clk_num,\
+				 _gate_flags, _clk_id)		\
+	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, mux_d_audio_clk,	\
+			_offset, 16, 0xE01F, 0, 0, 8, 1, 0, 0, _clk_num, \
+			_gate_flags , _clk_id,	mux_d_audio_clk_idx, 0)
+
+#define NODIV(_name, _con_id, _dev_id, _parents, _offset, \
+			      _mux_shift, _mux_mask, _clk_num, \
+			      _gate_flags, _clk_id)			\
+	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
+			_mux_shift, _mux_mask, 0, 0, 0, 0, 0, 0,	\
+			_clk_num, (_gate_flags) | TEGRA_PERIPH_NO_DIV,\
+			_clk_id, _parents##_idx, 0)
+
+#define GATE(_name, _con_id, _dev_id, _parent_name,	\
+			     _clk_num, _gate_flags,  _clk_id, _flags)	\
+	{								\
+		.name = _name,						\
+		.clk_id = _clk_id,					\
+		.p.parent_name = _parent_name,				\
+		.periph = TEGRA_CLK_PERIPH(0, 0, 0, 0, 0, 0, 0, 	\
+				_clk_num, 0, _gate_flags, 0),		\
+		.con_id = _con_id,					\
+		.dev_id = _dev_id,					\
+		.flags = _flags						\
+	}
+
+#define PLLP_BASE 0xa0
+#define PLLP_MISC 0xac
+#define PLLP_OUTA 0xa4
+#define PLLP_OUTB 0xa8
+
+#define PLL_BASE_LOCK BIT(27)
+#define PLL_MISC_LOCK_ENABLE 18
+
+static DEFINE_SPINLOCK(PLLP_OUTA_lock);
+static DEFINE_SPINLOCK(PLLP_OUTB_lock);
+
+#define MUX_I2S_SPDIF(_id)						\
+static const char *mux_pllaout0_##_id##_2x_pllp_clkm[] = { "pll_a_out0", \
+							   #_id, "pll_p",\
+							   "clk_m"};
+MUX_I2S_SPDIF(audio0)
+MUX_I2S_SPDIF(audio1)
+MUX_I2S_SPDIF(audio2)
+MUX_I2S_SPDIF(audio3)
+MUX_I2S_SPDIF(audio4)
+MUX_I2S_SPDIF(audio)
+
+#define mux_pllaout0_audio0_2x_pllp_clkm_idx NULL
+#define mux_pllaout0_audio1_2x_pllp_clkm_idx NULL
+#define mux_pllaout0_audio2_2x_pllp_clkm_idx NULL
+#define mux_pllaout0_audio3_2x_pllp_clkm_idx NULL
+#define mux_pllaout0_audio4_2x_pllp_clkm_idx NULL
+#define mux_pllaout0_audio_2x_pllp_clkm_idx NULL
+
+static const char *mux_pllp_pllc_pllm_clkm[] = {
+	"pll_p", "pll_c", "pll_m", "clk_m"
+};
+#define mux_pllp_pllc_pllm_clkm_idx NULL
+
+static const char *mux_pllp_pllc_pllm[] = { "pll_p", "pll_c", "pll_m" };
+#define mux_pllp_pllc_pllm_idx NULL
+
+static const char *mux_pllp_pllc_clk32_clkm[] = {
+	"pll_p", "pll_c", "clk_32k", "clk_m"
+};
+#define mux_pllp_pllc_clk32_clkm_idx NULL
+
+static const char *mux_plla_pllc_pllp_clkm[] = {
+	"pll_a_out0", "pll_c", "pll_p", "clk_m"
+};
+#define mux_plla_pllc_pllp_clkm_idx mux_pllp_pllc_pllm_clkm_idx
+
+static const char *mux_pllp_pllc2_c_c3_pllm_clkm[] = {
+	"pll_p", "pll_c2", "pll_c", "pll_c3", "pll_m", "clk_m"
+};
+static u32 mux_pllp_pllc2_c_c3_pllm_clkm_idx[] = {
+	[0] = 0, [1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 6,
+};
+
+static const char *mux_pllp_clkm[] = {
+	"pll_p", "clk_m"
+};
+static u32 mux_pllp_clkm_idx[] = {
+	[0] = 0, [1] = 3,
+};
+
+static const char *mux_pllm_pllc2_c_c3_pllp_plla[] = {
+	"pll_m", "pll_c2", "pll_c", "pll_c3", "pll_p", "pll_a_out0"
+};
+#define mux_pllm_pllc2_c_c3_pllp_plla_idx mux_pllp_pllc2_c_c3_pllm_clkm_idx
+
+static const char *mux_pllp_pllm_plld_plla_pllc_plld2_clkm[] = {
+	"pll_p", "pll_m", "pll_d_out0", "pll_a_out0", "pll_c",
+	"pll_d2_out0", "clk_m"
+};
+#define mux_pllp_pllm_plld_plla_pllc_plld2_clkm_idx NULL
+
+static const char *mux_pllm_pllc_pllp_plla[] = {
+	"pll_m", "pll_c", "pll_p", "pll_a_out0"
+};
+#define mux_pllm_pllc_pllp_plla_idx mux_pllp_pllc_pllm_clkm_idx
+
+static const char *mux_pllp_pllc_clkm[] = {
+	"pll_p", "pll_c", "pll_m"
+};
+static u32 mux_pllp_pllc_clkm_idx[] = {
+	[0] = 0, [1] = 1, [2] = 3,
+};
+
+static const char *mux_pllp_pllc_clkm_clk32[] = {
+	"pll_p", "pll_c", "clk_m", "clk_32k"
+};
+#define mux_pllp_pllc_clkm_clk32_idx NULL
+
+static const char *mux_plla_clk32_pllp_clkm_plle[] = {
+	"pll_a_out0", "clk_32k", "pll_p", "clk_m", "pll_e_out0"
+};
+#define mux_plla_clk32_pllp_clkm_plle_idx NULL
+
+static const char *mux_clkm_pllp_pllc_pllre[] = {
+	"clk_m", "pll_p", "pll_c", "pll_re_out"
+};
+static u32 mux_clkm_pllp_pllc_pllre_idx[] = {
+	[0] = 0, [1] = 1, [2] = 3, [3] = 5,
+};
+
+static const char *mux_clkm_48M_pllp_480M[] = {
+	"clk_m", "pll_u_48M", "pll_p", "pll_u_480M"
+};
+#define mux_clkm_48M_pllp_480M_idx NULL
+
+static const char *mux_clkm_pllre_clk32_480M_pllc_ref[] = {
+	"clk_m", "pll_re_out", "clk_32k", "pll_u_480M", "pll_c", "pll_ref"
+};
+static u32 mux_clkm_pllre_clk32_480M_pllc_ref_idx[] = {
+	[0] = 0, [1] = 1, [2] = 3, [3] = 3, [4] = 4, [5] = 7,
+};
+
+static const char *mux_d_audio_clk[] = {
+	"pll_a_out0", "pll_p", "clk_m", "spdif_in_sync", "i2s0_sync",
+	"i2s1_sync", "i2s2_sync", "i2s3_sync", "i2s4_sync", "vimclk_sync",
+};
+static u32 mux_d_audio_clk_idx[] = {
+	[0] = 0, [1] = 0x8000, [2] = 0xc000, [3] = 0xE000, [4] = 0xE001,
+	[5] = 0xE002, [6] = 0xE003, [7] = 0xE004, [8] = 0xE005, [9] = 0xE007,
+};
+
+static struct tegra_periph_init_data periph_clks[] = {
+	MUX("i2s0", NULL, "tegra30-i2s.0", mux_pllaout0_audio0_2x_pllp_clkm, CLK_SOURCE_I2S0, 30, TEGRA_PERIPH_ON_APB, tegra_clk_i2s0),
+	MUX("i2s1", NULL, "tegra30-i2s.1", mux_pllaout0_audio1_2x_pllp_clkm, CLK_SOURCE_I2S1, 11, TEGRA_PERIPH_ON_APB, tegra_clk_i2s1),
+	MUX("i2s2", NULL, "tegra30-i2s.2", mux_pllaout0_audio2_2x_pllp_clkm, CLK_SOURCE_I2S2, 18, TEGRA_PERIPH_ON_APB, tegra_clk_i2s2),
+	MUX("i2s3", NULL, "tegra30-i2s.3", mux_pllaout0_audio3_2x_pllp_clkm, CLK_SOURCE_I2S3, 101, TEGRA_PERIPH_ON_APB, tegra_clk_i2s3),
+	MUX("i2s4", NULL, "tegra30-i2s.4", mux_pllaout0_audio4_2x_pllp_clkm, CLK_SOURCE_I2S4, 102, TEGRA_PERIPH_ON_APB, tegra_clk_i2s4),
+	MUX("spdif_out", "spdif_out", "tegra30-spdif", mux_pllaout0_audio_2x_pllp_clkm, CLK_SOURCE_SPDIF_OUT, 10, TEGRA_PERIPH_ON_APB, tegra_clk_spdif_out),
+	MUX("spdif_in", "spdif_in", "tegra30-spdif", mux_pllp_pllc_pllm, CLK_SOURCE_SPDIF_IN, 10, TEGRA_PERIPH_ON_APB, tegra_clk_spdif_in),
+	MUX("pwm", NULL, "pwm", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_PWM, 17, TEGRA_PERIPH_ON_APB, tegra_clk_pwm),
+	MUX("adx", NULL, "adx", mux_plla_pllc_pllp_clkm, CLK_SOURCE_ADX, 154, TEGRA_PERIPH_ON_APB, tegra_clk_adx),
+	MUX("amx", NULL, "amx", mux_plla_pllc_pllp_clkm, CLK_SOURCE_AMX, 153, TEGRA_PERIPH_ON_APB, tegra_clk_amx),
+	MUX("hda", "hda", "tegra30-hda", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_HDA, 125, TEGRA_PERIPH_ON_APB, tegra_clk_hda),
+	MUX("hda2codec_2x", "hda2codec", "tegra30-hda", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_HDA2CODEC_2X, 111, TEGRA_PERIPH_ON_APB, tegra_clk_hda2codec_2x),
+	MUX("sbc1", NULL, "tegra11-spi.0", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC1, 41, TEGRA_PERIPH_ON_APB, tegra_clk_sbc1),
+	MUX("sbc2", NULL, "tegra11-spi.1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC2, 44, TEGRA_PERIPH_ON_APB, tegra_clk_sbc2),
+	MUX("sbc3", NULL, "tegra11-spi.2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC3, 46, TEGRA_PERIPH_ON_APB, tegra_clk_sbc3),
+	MUX("sbc4", NULL, "tegra11-spi.3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC4, 68, TEGRA_PERIPH_ON_APB, tegra_clk_sbc4),
+	MUX("sbc5", NULL, "tegra11-spi.4", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC5, 104, TEGRA_PERIPH_ON_APB, tegra_clk_sbc5),
+	MUX("sbc6", NULL, "tegra11-spi.5", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC6, 105, TEGRA_PERIPH_ON_APB, tegra_clk_sbc6),
+	MUX8("ndflash", NULL, "tegra_nand", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_NDFLASH, 13, TEGRA_PERIPH_ON_APB, tegra_clk_ndspeed),
+	MUX8("ndspeed", NULL, "tegra_nand_speed", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_NDSPEED, 80, TEGRA_PERIPH_ON_APB, tegra_clk_ndspeed),
+	MUX("vfir", NULL, "vfir", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_VFIR, 7, TEGRA_PERIPH_ON_APB, tegra_clk_vfir),
+	MUX("sdmmc1", NULL, "sdhci-tegra.0", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC1, 14, 0, tegra_clk_sdmmc1),
+	MUX("sdmmc2", NULL, "sdhci-tegra.1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC2, 9, 0, tegra_clk_sdmmc2),
+	MUX("sdmmc3", NULL, "sdhci-tegra.2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC3, 69, 0, tegra_clk_sdmmc3),
+	MUX("sdmmc4", NULL, "sdhci-tegra.3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC4, 15, 0, tegra_clk_sdmmc4),
+	INT("vde", NULL, "vde", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_VDE, 61, 0, tegra_clk_vde),
+	MUX_FLAGS("csite", NULL, "csite", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_CSITE, 73, TEGRA_PERIPH_ON_APB, tegra_clk_csite, CLK_IGNORE_UNUSED),
+	MUX("la", NULL, "la", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_LA, 76, TEGRA_PERIPH_ON_APB, tegra_clk_la),
+	MUX("trace", NULL, "trace", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_TRACE, 77, TEGRA_PERIPH_ON_APB, tegra_clk_trace),
+	MUX("owr", NULL, "tegra_w1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_OWR, 71, TEGRA_PERIPH_ON_APB, tegra_clk_owr),
+	MUX("nor", NULL, "tegra-nor", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_NOR, 42, 0, tegra_clk_nor),
+	MUX("mipi", NULL, "mipi", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_MIPI, 50, TEGRA_PERIPH_ON_APB, tegra_clk_mipi),
+	I2C("i2c1", "div-clk", "tegra11-i2c.0", mux_pllp_clkm, CLK_SOURCE_I2C1, 12, tegra_clk_i2c1),
+	I2C("i2c2", "div-clk", "tegra11-i2c.1", mux_pllp_clkm, CLK_SOURCE_I2C2, 54, tegra_clk_i2c2),
+	I2C("i2c3", "div-clk", "tegra11-i2c.2", mux_pllp_clkm, CLK_SOURCE_I2C3, 67, tegra_clk_i2c3),
+	I2C("i2c4", "div-clk", "tegra11-i2c.3", mux_pllp_clkm, CLK_SOURCE_I2C4, 103, tegra_clk_i2c4),
+	I2C("i2c5", "div-clk", "tegra11-i2c.4", mux_pllp_clkm, CLK_SOURCE_I2C5, 47, tegra_clk_i2c5),
+	UART("uarta", NULL, "tegra_uart.0", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTA, 6, tegra_clk_uarta),
+	UART("uartb", NULL, "tegra_uart.1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTB, 7, tegra_clk_uartb),
+	UART("uartc", NULL, "tegra_uart.2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTC, 55, tegra_clk_uartc),
+	UART("uartd", NULL, "tegra_uart.3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTD, 65, tegra_clk_uartd),
+	MUX("vi_sensor", "vi_sensor", "tegra_camera", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI_SENSOR, 20, TEGRA_PERIPH_NO_RESET, tegra_clk_vi_sensor),
+	INT8("vi", "vi", "tegra_camera", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI, 20, 0, tegra_clk_vi),
+	INT8("epp", NULL, "epp", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_EPP, 19, 0, tegra_clk_epp),
+	INT8("msenc", NULL, "msenc", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_MSENC, 91, TEGRA_PERIPH_WAR_1005168, tegra_clk_msenc),
+	INT8("tsec", NULL, "tsec", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_TSEC, 83, 0, tegra_clk_tsec),
+	INT8("host1x", NULL, "host1x", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_HOST1X, 28, 0, tegra_clk_host1x),
+	MUX8("hdmi", NULL, "hdmi", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_HDMI, 51, 0, tegra_clk_hdmi),
+	MUX("cilab", "cilab", "tegra_camera", mux_pllp_pllc_clkm, CLK_SOURCE_CILAB, 144, 0, tegra_clk_cilab),
+	MUX("cilcd", "cilcd", "tegra_camera", mux_pllp_pllc_clkm, CLK_SOURCE_CILCD, 145, 0, tegra_clk_cilcd),
+	MUX("cile", "cile", "tegra_camera", mux_pllp_pllc_clkm, CLK_SOURCE_CILE, 146, 0, tegra_clk_cile),
+	MUX("dsialp", "dsialp", "tegradc.0", mux_pllp_pllc_clkm, CLK_SOURCE_DSIALP, 147, 0, tegra_clk_dsialp),
+	MUX("dsiblp", "dsiblp", "tegradc.1", mux_pllp_pllc_clkm, CLK_SOURCE_DSIBLP, 148, 0, tegra_clk_dsiblp),
+	MUX("tsensor", NULL, "tegra-tsensor", mux_pllp_pllc_clkm_clk32, CLK_SOURCE_TSENSOR, 100, TEGRA_PERIPH_ON_APB, tegra_clk_tsensor),
+	MUX("actmon", NULL, "actmon", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_ACTMON, 119, 0, tegra_clk_actmon),
+	MUX8("extern1", NULL, "extern1", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN1, 120, 0, tegra_clk_extern1),
+	MUX8("extern2", NULL, "extern2", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN2, 121, 0, tegra_clk_extern2),
+	MUX8("extern3", NULL, "extern3", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN3, 122, 0, tegra_clk_extern3),
+	MUX("i2cslow", NULL, "i2cslow", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_I2CSLOW, 81, TEGRA_PERIPH_ON_APB, tegra_clk_i2cslow),
+	INT8("se", NULL, "se", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SE, 127, TEGRA_PERIPH_ON_APB, tegra_clk_se),
+	INT_FLAGS("mselect", NULL, "mselect", mux_pllp_clkm, CLK_SOURCE_MSELECT, 99, 0, tegra_clk_mselect, CLK_IGNORE_UNUSED),
+	MUX("dfll_ref", "ref", "t114_dfll", mux_pllp_clkm, CLK_SOURCE_DFLL_REF, 155, TEGRA_PERIPH_ON_APB, tegra_clk_dfll_ref),
+	MUX("dfll_soc", "soc", "t114_dfll", mux_pllp_clkm, CLK_SOURCE_DFLL_SOC, 155, TEGRA_PERIPH_ON_APB, tegra_clk_dfll_soc),
+	MUX8("soc_therm", NULL, "soc_therm", mux_pllm_pllc_pllp_plla, CLK_SOURCE_SOC_THERM, 78, TEGRA_PERIPH_ON_APB, tegra_clk_soc_therm),
+	XUSB("xusb_host_src", "host_src", "tegra_xhci", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_HOST_SRC, 143, TEGRA_PERIPH_ON_APB | TEGRA_PERIPH_NO_RESET, tegra_clk_xusb_host_src),
+	XUSB("xusb_falcon_src", "falcon_src", "tegra_xhci", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_FALCON_SRC, 143, TEGRA_PERIPH_NO_RESET, tegra_clk_xusb_falcon_src),
+	XUSB("xusb_fs_src", "fs_src", "tegra_xhci", mux_clkm_48M_pllp_480M, CLK_SOURCE_XUSB_FS_SRC, 143, TEGRA_PERIPH_NO_RESET, tegra_clk_xusb_fs_src),
+	XUSB("xusb_ss_src", "ss_src", "tegra_xhci", mux_clkm_pllre_clk32_480M_pllc_ref, CLK_SOURCE_XUSB_SS_SRC, 143, TEGRA_PERIPH_NO_RESET, tegra_clk_xusb_ss_src),
+	XUSB("xusb_dev_src", "dev_src", "tegra_xhci", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_DEV_SRC, 95, TEGRA_PERIPH_ON_APB | TEGRA_PERIPH_NO_RESET, tegra_clk_xusb_dev_src),
+	AUDIO("d_audio", "d_audio", "tegra30-ahub", CLK_SOURCE_D_AUDIO, 106, TEGRA_PERIPH_ON_APB, tegra_clk_d_audio),
+	AUDIO("dam0", NULL, "tegra30-dam.0", CLK_SOURCE_DAM0, 108, TEGRA_PERIPH_ON_APB, tegra_clk_dam0),
+	AUDIO("dam1", NULL, "tegra30-dam.1", CLK_SOURCE_DAM1, 109, TEGRA_PERIPH_ON_APB, tegra_clk_dam1),
+	AUDIO("dam2", NULL, "tegra30-dam.2", CLK_SOURCE_DAM2, 110, TEGRA_PERIPH_ON_APB, tegra_clk_dam2),
+	NODIV("disp1", NULL, "tegradc.0", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_DISP1, 29, 7, 27, 0, tegra_clk_disp1),
+	NODIV("disp2", NULL, "tegradc.1", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_DISP2, 29, 7, 26, 0, tegra_clk_disp2),
+};
+
+static struct tegra_periph_init_data gate_clks[] = {
+	GATE("rtc", NULL, "rtc-tegra", "clk_32k", 4, TEGRA_PERIPH_ON_APB | TEGRA_PERIPH_NO_RESET, tegra_clk_rtc, 0),
+	GATE("timer", NULL, "timer", "clk_m", 5, 0, tegra_clk_timer, 0),
+	GATE("vcp", NULL, NULL, "clk_m", 29, 0, tegra_clk_hda2hdmi, 0),
+	GATE("apbdma", NULL, NULL, "clk_m", 34, 0, tegra_clk_apbdma, 0),
+	GATE("kbc", NULL, NULL, "clk_32k", 36, TEGRA_PERIPH_ON_APB | TEGRA_PERIPH_NO_RESET, tegra_clk_kbc, 0),
+	GATE("fuse", NULL, NULL, "clk_m", 39, TEGRA_PERIPH_ON_APB, tegra_clk_fuse, 0),
+	GATE("fuse_burn", NULL, NULL, "clk_m", 39, TEGRA_PERIPH_ON_APB, tegra_clk_fuse_burn, 0),
+	GATE("kfuse", NULL, NULL, "clk_m", 40, TEGRA_PERIPH_ON_APB, tegra_clk_kfuse, 0),
+	GATE("apbif", NULL, NULL, "clk_m", 107, TEGRA_PERIPH_ON_APB, tegra_clk_apbif, 0),
+	GATE("hda2hdmi", NULL, NULL, "clk_m", 128, TEGRA_PERIPH_ON_APB, tegra_clk_hda2hdmi, 0),
+	GATE("bsea", NULL, NULL, "clk_m", 62, 0, tegra_clk_hda2hdmi, 0),
+	GATE("bsev", NULL, NULL, "clk_m", 63, 0, tegra_clk_bsev, 0),
+	GATE("mipi-cal", NULL, NULL, "clk_m", 56, 0, tegra_clk_mipi_cal, 0),
+	GATE("usbd", NULL, NULL, "clk_m", 22, 0, tegra_clk_usbd, 0),
+	GATE("usb2", NULL, NULL, "clk_m", 58, 0, tegra_clk_usb2, 0),
+	GATE("usb3", NULL, NULL, "clk_m", 59, 0, tegra_clk_usb3, 0),
+	GATE("csi", NULL, NULL, "pll_p_out3", 52, 0, tegra_clk_csi, 0),
+	GATE("csus", NULL, NULL, "clk_m", 92, TEGRA_PERIPH_NO_RESET, tegra_clk_csus, 0),
+	GATE("dds", NULL, NULL, "clk_m", 150, TEGRA_PERIPH_ON_APB, tegra_clk_dds, 0),
+	GATE("dp2", NULL, NULL, "clk_m", 152, TEGRA_PERIPH_ON_APB, tegra_clk_dp2, 0),
+	GATE("dtv", NULL, NULL, "clk_m", 79, TEGRA_PERIPH_ON_APB, tegra_clk_dtv, 0),
+	GATE("xusb_host", NULL, NULL, "xusb_host_src", 89, 0, tegra_clk_xusb_host, 0),
+	GATE("xusb_ss", NULL, NULL, "xusb_ss_src", 156, 0, tegra_clk_xusb_ss, 0),
+	GATE("xusb_dev", NULL, NULL, "xusb_dev_src", 95, 0, tegra_clk_xusb_dev, 0),
+	GATE("dsia", NULL, NULL, "dsia_mux", 48, 0, tegra_clk_dsia, 0),
+	GATE("dsib", NULL, NULL, "dsib_mux", 82, 0, tegra_clk_dsib, 0),
+	GATE("emc", NULL, NULL, "emc_mux", 57, 0, tegra_clk_emc, CLK_IGNORE_UNUSED),
+};
+
+struct pll_out_data {
+	char *div_name;
+	char *pll_out_name;
+	u32 offset;
+	int clk_id;
+	u8 div_shift;
+	u8 div_flags;
+	u8 rst_shift;
+	spinlock_t *lock;
+};
+
+#define PLL_OUT(_num, _offset, _div_shift, _div_flags, _rst_shift) \
+	{\
+		.div_name = "pll_p_out" #_num "_div",\
+		.pll_out_name = "pll_p_out" #_num,\
+		.offset = _offset,\
+		.div_shift = _div_shift,\
+		.div_flags = _div_flags | TEGRA_DIVIDER_FIXED |\
+                                TEGRA_DIVIDER_ROUND_UP ,\
+		.rst_shift = _rst_shift,\
+		.clk_id = tegra_clk_pll_p_out ## _num,\
+		.lock = &_offset ##_lock,\
+	}
+
+static struct pll_out_data pllp_out_clks[] = {
+	PLL_OUT(1, PLLP_OUTA, 8, 0, 0),
+	PLL_OUT(2, PLLP_OUTA, 24, TEGRA_DIVIDER_INT, 16),
+	PLL_OUT(3, PLLP_OUTB, 8, 0, 0),
+	PLL_OUT(4, PLLP_OUTB, 24, 0, 16),
+};
+
+static struct div_nmp pllp_nmp = {
+	.divm_shift = 0,
+	.divm_width = 5,
+	.divn_shift = 8,
+	.divn_width = 10,
+	.divp_shift = 20,
+	.divp_width = 3,
+};
+
+static struct tegra_clk_pll_freq_table pll_p_freq_table[] = {
+	{12000000, 216000000, 432, 12, 1, 8},
+	{13000000, 216000000, 432, 13, 1, 8},
+	{16800000, 216000000, 360, 14, 1, 8},
+	{19200000, 216000000, 360, 16, 1, 8},
+	{26000000, 216000000, 432, 26, 1, 8},
+	{0, 0, 0, 0, 0, 0},
+};
+
+static struct tegra_clk_pll_params pll_p_params = {
+	.input_min = 2000000,
+	.input_max = 31000000,
+	.cf_min = 1000000,
+	.cf_max = 6000000,
+	.vco_min = 200000000,
+	.vco_max = 700000000,
+	.base_reg = PLLP_BASE,
+	.misc_reg = PLLP_MISC,
+	.lock_mask = PLL_BASE_LOCK,
+	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
+	.lock_delay = 300,
+	.div_nmp = &pllp_nmp,
+};
+
+static void __init periph_clk_init(void __iomem *clk_base,
+				struct tegra_clk *tegra_clks)
+{
+	int i;
+	struct clk *clk;
+	struct clk **dt_clk;
+
+	for (i = 0; i < ARRAY_SIZE(periph_clks); i++) {
+		struct tegra_clk_periph_regs *bank;
+		struct tegra_periph_init_data *data;
+
+		data = periph_clks + i;
+
+		bank = get_reg_bank(data->periph.gate.clk_num);
+		if (!bank)
+			continue;
+
+		dt_clk = tegra_lookup_dt_id(data->clk_id, tegra_clks);
+		if (!dt_clk)
+			continue;
+
+		data->periph.gate.regs = bank;
+		clk = tegra_clk_register_periph(data->name,
+			data->p.parent_names, data->num_parents,
+			&data->periph, clk_base, data->offset,
+			data->flags);
+		*dt_clk = clk;
+	}
+}
+
+static void __init gate_clk_init(void __iomem *clk_base,
+				struct tegra_clk *tegra_clks)
+{
+	int i;
+	struct clk *clk;
+	struct clk **dt_clk;
+
+	for (i = 0; i < ARRAY_SIZE(gate_clks); i++) {
+		struct tegra_clk_periph_regs *bank;
+		struct tegra_periph_init_data *data;
+
+		data = gate_clks + i;
+
+		bank = get_reg_bank(data->periph.gate.clk_num);
+		if (!bank)
+			continue;
+
+		dt_clk = tegra_lookup_dt_id(data->clk_id, tegra_clks);
+		if (!dt_clk)
+			continue;
+
+		clk = tegra_clk_register_periph_gate(data->name,
+				data->p.parent_name, data->periph.gate.flags,
+				clk_base, data->flags,
+				data->periph.gate.clk_num, bank,
+				periph_clk_enb_refcnt);
+		*dt_clk = clk;
+
+		if (data->con_id || data->dev_id)
+			clk_register_clkdev(clk, data->con_id, data->dev_id);
+	}
+}
+
+static void __init init_pllp(void __iomem *clk_base, void __iomem *pmc_base,
+				struct tegra_clk *tegra_clks)
+{
+	struct clk *clk;
+	struct clk **dt_clk;
+	int i;
+
+	dt_clk = tegra_lookup_dt_id(tegra_clk_pll_p, tegra_clks);
+	if (!dt_clk)
+		return;
+
+	/* PLLP */
+	clk = tegra_clk_register_pll("pll_p", "pll_ref", clk_base, pmc_base, 0,
+			    408000000, &pll_p_params,
+			    TEGRA_PLL_FIXED | TEGRA_PLL_USE_LOCK,
+			    pll_p_freq_table, NULL);
+	clk_register_clkdev(clk, "pll_p", NULL);
+	*dt_clk = clk;
+
+	for (i = 0; i < ARRAY_SIZE(pllp_out_clks); i++) {
+		struct pll_out_data *data;
+
+		data = pllp_out_clks + i;
+
+		dt_clk = tegra_lookup_dt_id(data->clk_id, tegra_clks);
+		if (!dt_clk)
+			continue;
+
+		clk = tegra_clk_register_divider(data->div_name, "pll_p",
+				clk_base + data->offset, 0, data->div_flags,
+				data->div_shift, 8, 1, data->lock);
+		clk = tegra_clk_register_pll_out(data->pll_out_name,
+				data->div_name, clk_base + data->offset,
+				data->rst_shift + 1, data->rst_shift,
+				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
+				data->lock);
+		*dt_clk = clk;
+	}
+}
+
+
+void __init tegra_periph_clk_init(void __iomem *clk_base,
+			void __iomem *pmc_base, struct tegra_clk *tegra_clks)
+{
+	init_pllp(clk_base, pmc_base, tegra_clks);
+	periph_clk_init(clk_base, tegra_clks);
+	gate_clk_init( clk_base, tegra_clks);
+}
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index 02bfd4f..9bcdd29 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -102,8 +102,6 @@
 #define PLLE_AUX 0x48c
 #define PLLC_OUT 0x84
 #define PLLM_OUT 0x94
-#define PLLP_OUTA 0xa4
-#define PLLP_OUTB 0xa8
 
 #define PMC_CLK_OUT_CNTRL 0x1a8
 #define PMC_DPD_PADS_ORIDE 0x1c
@@ -149,91 +147,8 @@
 #define UTMIPLL_HW_PWRDN_CFG0_IDDQ_OVERRIDE	BIT(1)
 #define UTMIPLL_HW_PWRDN_CFG0_IDDQ_SWCTL	BIT(0)
 
-#define CLK_SOURCE_I2S0 0x1d8
-#define CLK_SOURCE_I2S1 0x100
-#define CLK_SOURCE_I2S2 0x104
-#define CLK_SOURCE_NDFLASH 0x160
-#define CLK_SOURCE_I2S3 0x3bc
-#define CLK_SOURCE_I2S4 0x3c0
-#define CLK_SOURCE_SPDIF_OUT 0x108
-#define CLK_SOURCE_SPDIF_IN 0x10c
-#define CLK_SOURCE_PWM 0x110
-#define CLK_SOURCE_ADX 0x638
-#define CLK_SOURCE_AMX 0x63c
-#define CLK_SOURCE_HDA 0x428
-#define CLK_SOURCE_HDA2CODEC_2X 0x3e4
-#define CLK_SOURCE_SBC1 0x134
-#define CLK_SOURCE_SBC2 0x118
-#define CLK_SOURCE_SBC3 0x11c
-#define CLK_SOURCE_SBC4 0x1b4
-#define CLK_SOURCE_SBC5 0x3c8
-#define CLK_SOURCE_SBC6 0x3cc
-#define CLK_SOURCE_SATA_OOB 0x420
-#define CLK_SOURCE_SATA 0x424
-#define CLK_SOURCE_NDSPEED 0x3f8
-#define CLK_SOURCE_VFIR 0x168
-#define CLK_SOURCE_SDMMC1 0x150
-#define CLK_SOURCE_SDMMC2 0x154
-#define CLK_SOURCE_SDMMC3 0x1bc
-#define CLK_SOURCE_SDMMC4 0x164
-#define CLK_SOURCE_VDE 0x1c8
 #define CLK_SOURCE_CSITE 0x1d4
-#define CLK_SOURCE_LA 0x1f8
-#define CLK_SOURCE_TRACE 0x634
-#define CLK_SOURCE_OWR 0x1cc
-#define CLK_SOURCE_NOR 0x1d0
-#define CLK_SOURCE_MIPI 0x174
-#define CLK_SOURCE_I2C1 0x124
-#define CLK_SOURCE_I2C2 0x198
-#define CLK_SOURCE_I2C3 0x1b8
-#define CLK_SOURCE_I2C4 0x3c4
-#define CLK_SOURCE_I2C5 0x128
-#define CLK_SOURCE_UARTA 0x178
-#define CLK_SOURCE_UARTB 0x17c
-#define CLK_SOURCE_UARTC 0x1a0
-#define CLK_SOURCE_UARTD 0x1c0
-#define CLK_SOURCE_UARTE 0x1c4
-#define CLK_SOURCE_UARTA_DBG 0x178
-#define CLK_SOURCE_UARTB_DBG 0x17c
-#define CLK_SOURCE_UARTC_DBG 0x1a0
-#define CLK_SOURCE_UARTD_DBG 0x1c0
-#define CLK_SOURCE_UARTE_DBG 0x1c4
-#define CLK_SOURCE_3D 0x158
-#define CLK_SOURCE_2D 0x15c
-#define CLK_SOURCE_VI_SENSOR 0x1a8
-#define CLK_SOURCE_VI 0x148
-#define CLK_SOURCE_EPP 0x16c
-#define CLK_SOURCE_MSENC 0x1f0
-#define CLK_SOURCE_TSEC 0x1f4
-#define CLK_SOURCE_HOST1X 0x180
-#define CLK_SOURCE_HDMI 0x18c
-#define CLK_SOURCE_DISP1 0x138
-#define CLK_SOURCE_DISP2 0x13c
-#define CLK_SOURCE_CILAB 0x614
-#define CLK_SOURCE_CILCD 0x618
-#define CLK_SOURCE_CILE 0x61c
-#define CLK_SOURCE_DSIALP 0x620
-#define CLK_SOURCE_DSIBLP 0x624
-#define CLK_SOURCE_TSENSOR 0x3b8
-#define CLK_SOURCE_D_AUDIO 0x3d0
-#define CLK_SOURCE_DAM0 0x3d8
-#define CLK_SOURCE_DAM1 0x3dc
-#define CLK_SOURCE_DAM2 0x3e0
-#define CLK_SOURCE_ACTMON 0x3e8
-#define CLK_SOURCE_EXTERN1 0x3ec
-#define CLK_SOURCE_EXTERN2 0x3f0
-#define CLK_SOURCE_EXTERN3 0x3f4
-#define CLK_SOURCE_I2CSLOW 0x3fc
-#define CLK_SOURCE_SE 0x42c
-#define CLK_SOURCE_MSELECT 0x3b4
-#define CLK_SOURCE_DFLL_REF 0x62c
-#define CLK_SOURCE_DFLL_SOC 0x630
-#define CLK_SOURCE_SOC_THERM 0x644
-#define CLK_SOURCE_XUSB_HOST_SRC 0x600
-#define CLK_SOURCE_XUSB_FALCON_SRC 0x604
-#define CLK_SOURCE_XUSB_FS_SRC 0x608
 #define CLK_SOURCE_XUSB_SS_SRC 0x610
-#define CLK_SOURCE_XUSB_DEV_SRC 0x60c
 #define CLK_SOURCE_EMC 0x19c
 
 /* PLLM override registers */
@@ -257,7 +172,6 @@ static void __iomem *pmc_base;
 static DEFINE_SPINLOCK(pll_d_lock);
 static DEFINE_SPINLOCK(pll_d2_lock);
 static DEFINE_SPINLOCK(pll_u_lock);
-static DEFINE_SPINLOCK(pll_div_lock);
 static DEFINE_SPINLOCK(pll_re_lock);
 static DEFINE_SPINLOCK(clk_out_lock);
 static DEFINE_SPINLOCK(sysrate_lock);
@@ -444,30 +358,6 @@ static struct div_nmp pllp_nmp = {
 	.divp_width = 3,
 };
 
-static struct tegra_clk_pll_freq_table pll_p_freq_table[] = {
-	{12000000, 216000000, 432, 12, 1, 8},
-	{13000000, 216000000, 432, 13, 1, 8},
-	{16800000, 216000000, 360, 14, 1, 8},
-	{19200000, 216000000, 360, 16, 1, 8},
-	{26000000, 216000000, 432, 26, 1, 8},
-	{0, 0, 0, 0, 0, 0},
-};
-
-static struct tegra_clk_pll_params pll_p_params = {
-	.input_min = 2000000,
-	.input_max = 31000000,
-	.cf_min = 1000000,
-	.cf_max = 6000000,
-	.vco_min = 200000000,
-	.vco_max = 700000000,
-	.base_reg = PLLP_BASE,
-	.misc_reg = PLLP_MISC,
-	.lock_mask = PLL_BASE_LOCK,
-	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
-	.lock_delay = 300,
-	.div_nmp = &pllp_nmp,
-};
-
 static struct tegra_clk_pll_freq_table pll_d_freq_table[] = {
 	{12000000, 216000000, 864, 12, 2, 12},
 	{13000000, 216000000, 864, 13, 2, 12},
@@ -663,73 +553,12 @@ static unsigned long tegra114_input_freq[] = {
 
 #define MASK(x) (BIT(x) - 1)
 
-#define TEGRA_INIT_DATA_MUX(_name, _con_id, _dev_id, _parents, _offset,	\
-			    _clk_num, _gate_flags, _clk_id)	\
-	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			30, MASK(2), 0, 0, 8, 1, 0, 0,\
-			_clk_num,  _gate_flags, _clk_id, _parents##_idx, 0)
-
-#define TEGRA_INIT_DATA_MUX_FLAGS(_name, _con_id, _dev_id, _parents, _offset,\
-			    _clk_num, _gate_flags, _clk_id, flags)\
-	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			30, MASK(2), 0, 0, 8, 1, 0, 0, _clk_num,	\
-			_gate_flags, _clk_id, _parents##_idx, flags)
-
-#define TEGRA_INIT_DATA_MUX8(_name, _con_id, _dev_id, _parents, _offset, \
-			     _clk_num, _gate_flags, _clk_id)	\
-	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			29, MASK(3), 0, 0, 8, 1, 0, 0, _clk_num,	\
-			_gate_flags, _clk_id, _parents##_idx, 0)
-
 #define TEGRA_INIT_DATA_INT(_name, _con_id, _dev_id, _parents, _offset,	\
 			    _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
 			30, MASK(2), 0, 0, 8, 1, TEGRA_DIVIDER_INT, 0,\
 			_clk_num, _gate_flags, _clk_id, _parents##_idx, 0)
 
-#define TEGRA_INIT_DATA_INT_FLAGS(_name, _con_id, _dev_id, _parents, _offset,\
-			    _clk_num, _gate_flags, _clk_id, flags)\
-	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			30, MASK(2), 0, 0, 8, 1, TEGRA_DIVIDER_INT, 0,\
-			_clk_num,  _gate_flags, _clk_id, _parents##_idx, flags)
-
-#define TEGRA_INIT_DATA_INT8(_name, _con_id, _dev_id, _parents, _offset,\
-			    _clk_num, _gate_flags, _clk_id)	\
-	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			29, MASK(3), 0, 0, 8, 1, TEGRA_DIVIDER_INT, 0,\
-			_clk_num, _gate_flags, _clk_id, _parents##_idx, 0)
-
-#define TEGRA_INIT_DATA_UART(_name, _con_id, _dev_id, _parents, _offset,\
-			     _clk_num, _clk_id)			\
-	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			30, MASK(2), 0, 0, 16, 1, TEGRA_DIVIDER_UART, 0,\
-			_clk_num, 0, _clk_id, _parents##_idx, 0)
-
-#define TEGRA_INIT_DATA_I2C(_name, _con_id, _dev_id, _parents, _offset,\
-			     _clk_num, _clk_id)			\
-	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			30, MASK(2), 0, 0, 16, 0, 0, 0, _clk_num,	\
-			0, _clk_id, _parents##_idx, 0)
-
-#define TEGRA_INIT_DATA_NODIV(_name, _con_id, _dev_id, _parents, _offset, \
-			      _mux_shift, _mux_mask, _clk_num, \
-			      _gate_flags, _clk_id)			\
-	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			_mux_shift, _mux_mask, 0, 0, 0, 0, 0, 0,	\
-			_clk_num, _gate_flags, _clk_id, _parents##_idx, 0)
-
-#define TEGRA_INIT_DATA_XUSB(_name, _con_id, _dev_id, _parents, _offset, \
-			     _clk_num, _gate_flags, _clk_id)	 \
-	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset, \
-			29, MASK(3), 0, 0, 8, 1, TEGRA_DIVIDER_INT, 0, \
-			_clk_num, _gate_flags, _clk_id, _parents##_idx, 0)
-
-#define TEGRA_INIT_DATA_AUDIO(_name, _con_id, _dev_id, _offset,  _clk_num,\
-				 _gate_flags, _clk_id)		\
-	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, mux_d_audio_clk,	\
-			_offset, 16, 0xE01F, 0, 0, 8, 1, 0, 0, _clk_num, \
-			_gate_flags , _clk_id,	mux_d_audio_clk_idx, 0)
-
 struct utmi_clk_param {
 	/* Oscillator Frequency in KHz */
 	u32 osc_frequency;
@@ -763,122 +592,11 @@ static const struct utmi_clk_param utmi_parameters[] = {
 
 /* peripheral mux definitions */
 
-#define MUX_I2S_SPDIF(_id)						\
-static const char *mux_pllaout0_##_id##_2x_pllp_clkm[] = { "pll_a_out0", \
-							   #_id, "pll_p",\
-							   "clk_m"};
-MUX_I2S_SPDIF(audio0)
-MUX_I2S_SPDIF(audio1)
-MUX_I2S_SPDIF(audio2)
-MUX_I2S_SPDIF(audio3)
-MUX_I2S_SPDIF(audio4)
-MUX_I2S_SPDIF(audio)
-
-#define mux_pllaout0_audio0_2x_pllp_clkm_idx NULL
-#define mux_pllaout0_audio1_2x_pllp_clkm_idx NULL
-#define mux_pllaout0_audio2_2x_pllp_clkm_idx NULL
-#define mux_pllaout0_audio3_2x_pllp_clkm_idx NULL
-#define mux_pllaout0_audio4_2x_pllp_clkm_idx NULL
-#define mux_pllaout0_audio_2x_pllp_clkm_idx NULL
-
-static const char *mux_pllp_pllc_pllm_clkm[] = {
-	"pll_p", "pll_c", "pll_m", "clk_m"
-};
-#define mux_pllp_pllc_pllm_clkm_idx NULL
-
-static const char *mux_pllp_pllc_pllm[] = { "pll_p", "pll_c", "pll_m" };
-#define mux_pllp_pllc_pllm_idx NULL
-
-static const char *mux_pllp_pllc_clk32_clkm[] = {
-	"pll_p", "pll_c", "clk_32k", "clk_m"
-};
-#define mux_pllp_pllc_clk32_clkm_idx NULL
-
-static const char *mux_plla_pllc_pllp_clkm[] = {
-	"pll_a_out0", "pll_c", "pll_p", "clk_m"
-};
-#define mux_plla_pllc_pllp_clkm_idx mux_pllp_pllc_pllm_clkm_idx
-
-static const char *mux_pllp_pllc2_c_c3_pllm_clkm[] = {
-	"pll_p", "pll_c2", "pll_c", "pll_c3", "pll_m", "clk_m"
-};
-static u32 mux_pllp_pllc2_c_c3_pllm_clkm_idx[] = {
-	[0] = 0, [1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 6,
-};
-
-static const char *mux_pllp_clkm[] = {
-	"pll_p", "clk_m"
-};
-static u32 mux_pllp_clkm_idx[] = {
-	[0] = 0, [1] = 3,
-};
-
-static const char *mux_pllm_pllc2_c_c3_pllp_plla[] = {
-	"pll_m", "pll_c2", "pll_c", "pll_c3", "pll_p", "pll_a_out0"
-};
-#define mux_pllm_pllc2_c_c3_pllp_plla_idx mux_pllp_pllc2_c_c3_pllm_clkm_idx
-
-static const char *mux_pllp_pllm_plld_plla_pllc_plld2_clkm[] = {
-	"pll_p", "pll_m", "pll_d_out0", "pll_a_out0", "pll_c",
-	"pll_d2_out0", "clk_m"
-};
-#define mux_pllp_pllm_plld_plla_pllc_plld2_clkm_idx NULL
-
-static const char *mux_pllm_pllc_pllp_plla[] = {
-	"pll_m", "pll_c", "pll_p", "pll_a_out0"
-};
-#define mux_pllm_pllc_pllp_plla_idx mux_pllp_pllc_pllm_clkm_idx
-
-static const char *mux_pllp_pllc_clkm[] = {
-	"pll_p", "pll_c", "pll_m"
-};
-static u32 mux_pllp_pllc_clkm_idx[] = {
-	[0] = 0, [1] = 1, [2] = 3,
-};
-
-static const char *mux_pllp_pllc_clkm_clk32[] = {
-	"pll_p", "pll_c", "clk_m", "clk_32k"
-};
-#define mux_pllp_pllc_clkm_clk32_idx NULL
-
-static const char *mux_plla_clk32_pllp_clkm_plle[] = {
-	"pll_a_out0", "clk_32k", "pll_p", "clk_m", "pll_e_out0"
-};
-#define mux_plla_clk32_pllp_clkm_plle_idx NULL
-
-static const char *mux_clkm_pllp_pllc_pllre[] = {
-	"clk_m", "pll_p", "pll_c", "pll_re_out"
-};
-static u32 mux_clkm_pllp_pllc_pllre_idx[] = {
-	[0] = 0, [1] = 1, [2] = 3, [3] = 5,
-};
-
-static const char *mux_clkm_48M_pllp_480M[] = {
-	"clk_m", "pll_u_48M", "pll_p", "pll_u_480M"
-};
-#define mux_clkm_48M_pllp_480M_idx NULL
-
-static const char *mux_clkm_pllre_clk32_480M_pllc_ref[] = {
-	"clk_m", "pll_re_out", "clk_32k", "pll_u_480M", "pll_c", "pll_ref"
-};
-static u32 mux_clkm_pllre_clk32_480M_pllc_ref_idx[] = {
-	[0] = 0, [1] = 1, [2] = 3, [3] = 3, [4] = 4, [5] = 7,
-};
-
 static const char *mux_plld_out0_plld2_out0[] = {
 	"pll_d_out0", "pll_d2_out0",
 };
 #define mux_plld_out0_plld2_out0_idx NULL
 
-static const char *mux_d_audio_clk[] = {
-	"pll_a_out0", "pll_p", "clk_m", "spdif_in_sync", "i2s0_sync",
-	"i2s1_sync", "i2s2_sync", "i2s3_sync", "i2s4_sync", "vimclk_sync",
-};
-static u32 mux_d_audio_clk_idx[] = {
-	[0] = 0, [1] = 0x8000, [2] = 0xc000, [3] = 0xE000, [4] = 0xE001,
-	[5] = 0xE002, [6] = 0xE003, [7] = 0xE004, [8] = 0xE005, [9] = 0xE007,
-};
-
 static const char *mux_pllmcp_clkm[] = {
 	"pll_m_out0", "pll_c_out0", "pll_p_out0", "clk_m", "pll_m_ud",
 };
@@ -1253,60 +971,6 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	clk_register_clkdev(clk, "pll_c3", NULL);
 	clks[TEGRA114_CLK_PLL_C3] = clk;
 
-	/* PLLP */
-	clk = tegra_clk_register_pll("pll_p", "pll_ref", clk_base, pmc, 0,
-			    408000000, &pll_p_params,
-			    TEGRA_PLL_FIXED | TEGRA_PLL_USE_LOCK,
-			    pll_p_freq_table, NULL);
-	clk_register_clkdev(clk, "pll_p", NULL);
-	clks[TEGRA114_CLK_PLL_P] = clk;
-
-	/* PLLP_OUT1 */
-	clk = tegra_clk_register_divider("pll_p_out1_div", "pll_p",
-				clk_base + PLLP_OUTA, 0, TEGRA_DIVIDER_FIXED |
-				TEGRA_DIVIDER_ROUND_UP, 8, 8, 1, &pll_div_lock);
-	clk = tegra_clk_register_pll_out("pll_p_out1", "pll_p_out1_div",
-				clk_base + PLLP_OUTA, 1, 0,
-				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
-				&pll_div_lock);
-	clk_register_clkdev(clk, "pll_p_out1", NULL);
-	clks[TEGRA114_CLK_PLL_P_OUT1] = clk;
-
-	/* PLLP_OUT2 */
-	clk = tegra_clk_register_divider("pll_p_out2_div", "pll_p",
-				clk_base + PLLP_OUTA, 0, TEGRA_DIVIDER_FIXED |
-				TEGRA_DIVIDER_ROUND_UP | TEGRA_DIVIDER_INT, 24,
-				8, 1, &pll_div_lock);
-	clk = tegra_clk_register_pll_out("pll_p_out2", "pll_p_out2_div",
-				clk_base + PLLP_OUTA, 17, 16,
-				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
-				&pll_div_lock);
-	clk_register_clkdev(clk, "pll_p_out2", NULL);
-	clks[TEGRA114_CLK_PLL_P_OUT2] = clk;
-
-	/* PLLP_OUT3 */
-	clk = tegra_clk_register_divider("pll_p_out3_div", "pll_p",
-				clk_base + PLLP_OUTB, 0, TEGRA_DIVIDER_FIXED |
-				TEGRA_DIVIDER_ROUND_UP, 8, 8, 1, &pll_div_lock);
-	clk = tegra_clk_register_pll_out("pll_p_out3", "pll_p_out3_div",
-				clk_base + PLLP_OUTB, 1, 0,
-				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
-				&pll_div_lock);
-	clk_register_clkdev(clk, "pll_p_out3", NULL);
-	clks[TEGRA114_CLK_PLL_P_OUT3] = clk;
-
-	/* PLLP_OUT4 */
-	clk = tegra_clk_register_divider("pll_p_out4_div", "pll_p",
-				clk_base + PLLP_OUTB, 0, TEGRA_DIVIDER_FIXED |
-				TEGRA_DIVIDER_ROUND_UP, 24, 8, 1,
-				&pll_div_lock);
-	clk = tegra_clk_register_pll_out("pll_p_out4", "pll_p_out4_div",
-				clk_base + PLLP_OUTB, 17, 16,
-				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
-				&pll_div_lock);
-	clk_register_clkdev(clk, "pll_p_out4", NULL);
-	clks[TEGRA114_CLK_PLL_P_OUT4] = clk;
-
 	/* PLLM */
 	clk = tegra_clk_register_pllm("pll_m", "pll_ref", clk_base, pmc,
 			     CLK_IGNORE_UNUSED | CLK_SET_RATE_GATE, 0,
@@ -1442,20 +1106,6 @@ static const char *clk_out3_parents[] = { "clk_m", "clk_m_div2",
 	"clk_m_div4", "extern3",
 };
 
-static struct clk * __init tegra114_periph_gate_helper(const char *name,
-		const char *parent_name, u8 gate_flags, void __iomem *clk_base,
-		unsigned long flags, int clk_num, int *enable_refcnt)
-{
-	struct tegra_clk_periph_regs *bank;
-
-	bank = get_reg_bank(clk_num);
-	if (!bank)
-		return NULL;
-
-	return tegra_clk_register_periph_gate(name, parent_name, gate_flags,
-			clk_base, flags, clk_num, bank, enable_refcnt);
-}
-
 static void __init tegra114_pmc_clk_init(void __iomem *pmc_base)
 {
 	struct clk *clk;
@@ -1574,230 +1224,12 @@ static void __init tegra114_super_clk_init(void __iomem *clk_base)
 	clks[TEGRA114_CLK_PCLK] = clk;
 }
 
-static struct tegra_periph_init_data tegra_periph_clk_list[] = {
-	TEGRA_INIT_DATA_MUX("i2s0", NULL, "tegra30-i2s.0", mux_pllaout0_audio0_2x_pllp_clkm, CLK_SOURCE_I2S0, 30, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S0),
-	TEGRA_INIT_DATA_MUX("i2s1", NULL, "tegra30-i2s.1", mux_pllaout0_audio1_2x_pllp_clkm, CLK_SOURCE_I2S1, 11, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S1),
-	TEGRA_INIT_DATA_MUX("i2s2", NULL, "tegra30-i2s.2", mux_pllaout0_audio2_2x_pllp_clkm, CLK_SOURCE_I2S2, 18, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S2),
-	TEGRA_INIT_DATA_MUX("i2s3", NULL, "tegra30-i2s.3", mux_pllaout0_audio3_2x_pllp_clkm, CLK_SOURCE_I2S3, 101, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S3),
-	TEGRA_INIT_DATA_MUX("i2s4", NULL, "tegra30-i2s.4", mux_pllaout0_audio4_2x_pllp_clkm, CLK_SOURCE_I2S4, 102, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S4),
-	TEGRA_INIT_DATA_MUX("spdif_out", "spdif_out", "tegra30-spdif", mux_pllaout0_audio_2x_pllp_clkm, CLK_SOURCE_SPDIF_OUT, 10, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SPDIF_OUT),
-	TEGRA_INIT_DATA_MUX("spdif_in", "spdif_in", "tegra30-spdif", mux_pllp_pllc_pllm, CLK_SOURCE_SPDIF_IN, 10, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SPDIF_IN),
-	TEGRA_INIT_DATA_MUX("pwm", NULL, "pwm", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_PWM, 17, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_PWM),
-	TEGRA_INIT_DATA_MUX("adx", NULL, "adx", mux_plla_pllc_pllp_clkm, CLK_SOURCE_ADX, 154, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_ADX),
-	TEGRA_INIT_DATA_MUX("amx", NULL, "amx", mux_plla_pllc_pllp_clkm, CLK_SOURCE_AMX, 153, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_AMX),
-	TEGRA_INIT_DATA_MUX("hda", "hda", "tegra30-hda", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_HDA, 125, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_HDA),
-	TEGRA_INIT_DATA_MUX("hda2codec_2x", "hda2codec", "tegra30-hda", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_HDA2CODEC_2X, 111, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_HDA2CODEC_2X),
-	TEGRA_INIT_DATA_MUX("sbc1", NULL, "tegra11-spi.0", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC1, 41, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC1),
-	TEGRA_INIT_DATA_MUX("sbc2", NULL, "tegra11-spi.1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC2, 44, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC2),
-	TEGRA_INIT_DATA_MUX("sbc3", NULL, "tegra11-spi.2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC3, 46, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC3),
-	TEGRA_INIT_DATA_MUX("sbc4", NULL, "tegra11-spi.3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC4, 68, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC4),
-	TEGRA_INIT_DATA_MUX("sbc5", NULL, "tegra11-spi.4", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC5, 104, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC5),
-	TEGRA_INIT_DATA_MUX("sbc6", NULL, "tegra11-spi.5", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC6, 105, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC6),
-	TEGRA_INIT_DATA_MUX8("ndflash", NULL, "tegra_nand", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_NDFLASH, 13, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_NDSPEED),
-	TEGRA_INIT_DATA_MUX8("ndspeed", NULL, "tegra_nand_speed", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_NDSPEED, 80, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_NDSPEED),
-	TEGRA_INIT_DATA_MUX("vfir", NULL, "vfir", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_VFIR, 7, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_VFIR),
-	TEGRA_INIT_DATA_MUX("sdmmc1", NULL, "sdhci-tegra.0", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC1, 14, 0, TEGRA114_CLK_SDMMC1),
-	TEGRA_INIT_DATA_MUX("sdmmc2", NULL, "sdhci-tegra.1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC2, 9, 0, TEGRA114_CLK_SDMMC2),
-	TEGRA_INIT_DATA_MUX("sdmmc3", NULL, "sdhci-tegra.2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC3, 69, 0, TEGRA114_CLK_SDMMC3),
-	TEGRA_INIT_DATA_MUX("sdmmc4", NULL, "sdhci-tegra.3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC4, 15, 0, TEGRA114_CLK_SDMMC4),
-	TEGRA_INIT_DATA_INT("vde", NULL, "vde", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_VDE, 61, 0, TEGRA114_CLK_VDE),
-	TEGRA_INIT_DATA_MUX_FLAGS("csite", NULL, "csite", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_CSITE, 73, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_CSITE, CLK_IGNORE_UNUSED),
-	TEGRA_INIT_DATA_MUX("la", NULL, "la", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_LA, 76, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_LA),
-	TEGRA_INIT_DATA_MUX("trace", NULL, "trace", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_TRACE, 77, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_TRACE),
-	TEGRA_INIT_DATA_MUX("owr", NULL, "tegra_w1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_OWR, 71, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_OWR),
-	TEGRA_INIT_DATA_MUX("nor", NULL, "tegra-nor", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_NOR, 42, 0, TEGRA114_CLK_NOR),
-	TEGRA_INIT_DATA_MUX("mipi", NULL, "mipi", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_MIPI, 50, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_MIPI),
-	TEGRA_INIT_DATA_I2C("i2c1", "div-clk", "tegra11-i2c.0", mux_pllp_clkm, CLK_SOURCE_I2C1, 12, TEGRA114_CLK_I2C1),
-	TEGRA_INIT_DATA_I2C("i2c2", "div-clk", "tegra11-i2c.1", mux_pllp_clkm, CLK_SOURCE_I2C2, 54, TEGRA114_CLK_I2C2),
-	TEGRA_INIT_DATA_I2C("i2c3", "div-clk", "tegra11-i2c.2", mux_pllp_clkm, CLK_SOURCE_I2C3, 67, TEGRA114_CLK_I2C3),
-	TEGRA_INIT_DATA_I2C("i2c4", "div-clk", "tegra11-i2c.3", mux_pllp_clkm, CLK_SOURCE_I2C4, 103, TEGRA114_CLK_I2C4),
-	TEGRA_INIT_DATA_I2C("i2c5", "div-clk", "tegra11-i2c.4", mux_pllp_clkm, CLK_SOURCE_I2C5, 47, TEGRA114_CLK_I2C5),
-	TEGRA_INIT_DATA_UART("uarta", NULL, "tegra_uart.0", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTA, 6, TEGRA114_CLK_UARTA),
-	TEGRA_INIT_DATA_UART("uartb", NULL, "tegra_uart.1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTB, 7, TEGRA114_CLK_UARTB),
-	TEGRA_INIT_DATA_UART("uartc", NULL, "tegra_uart.2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTC, 55, TEGRA114_CLK_UARTC),
-	TEGRA_INIT_DATA_UART("uartd", NULL, "tegra_uart.3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTD, 65, TEGRA114_CLK_UARTD),
-	TEGRA_INIT_DATA_INT("3d", NULL, "3d", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_3D, 24, 0, TEGRA114_CLK_GR_3D),
-	TEGRA_INIT_DATA_INT("2d", NULL, "2d", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_2D, 21, 0, TEGRA114_CLK_GR_2D),
-	TEGRA_INIT_DATA_MUX("vi_sensor", "vi_sensor", "tegra_camera", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI_SENSOR, 20, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_VI_SENSOR),
-	TEGRA_INIT_DATA_INT8("vi", "vi", "tegra_camera", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI, 20, 0, TEGRA114_CLK_VI),
-	TEGRA_INIT_DATA_INT8("epp", NULL, "epp", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_EPP, 19, 0, TEGRA114_CLK_EPP),
-	TEGRA_INIT_DATA_INT8("msenc", NULL, "msenc", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_MSENC, 91, TEGRA_PERIPH_WAR_1005168, TEGRA114_CLK_MSENC),
-	TEGRA_INIT_DATA_INT8("tsec", NULL, "tsec", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_TSEC, 83, 0, TEGRA114_CLK_TSEC),
-	TEGRA_INIT_DATA_INT8("host1x", NULL, "host1x", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_HOST1X, 28, 0, TEGRA114_CLK_HOST1X),
-	TEGRA_INIT_DATA_MUX8("hdmi", NULL, "hdmi", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_HDMI, 51, 0, TEGRA114_CLK_HDMI),
-	TEGRA_INIT_DATA_MUX("cilab", "cilab", "tegra_camera", mux_pllp_pllc_clkm, CLK_SOURCE_CILAB, 144, 0, TEGRA114_CLK_CILAB),
-	TEGRA_INIT_DATA_MUX("cilcd", "cilcd", "tegra_camera", mux_pllp_pllc_clkm, CLK_SOURCE_CILCD, 145, 0, TEGRA114_CLK_CILCD),
-	TEGRA_INIT_DATA_MUX("cile", "cile", "tegra_camera", mux_pllp_pllc_clkm, CLK_SOURCE_CILE, 146, 0, TEGRA114_CLK_CILE),
-	TEGRA_INIT_DATA_MUX("dsialp", "dsialp", "tegradc.0", mux_pllp_pllc_clkm, CLK_SOURCE_DSIALP, 147, 0, TEGRA114_CLK_DSIALP),
-	TEGRA_INIT_DATA_MUX("dsiblp", "dsiblp", "tegradc.1", mux_pllp_pllc_clkm, CLK_SOURCE_DSIBLP, 148, 0, TEGRA114_CLK_DSIBLP),
-	TEGRA_INIT_DATA_MUX("tsensor", NULL, "tegra-tsensor", mux_pllp_pllc_clkm_clk32, CLK_SOURCE_TSENSOR, 100, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_TSENSOR),
-	TEGRA_INIT_DATA_MUX("actmon", NULL, "actmon", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_ACTMON, 119, 0, TEGRA114_CLK_ACTMON),
-	TEGRA_INIT_DATA_MUX8("extern1", NULL, "extern1", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN1, 120, 0, TEGRA114_CLK_EXTERN1),
-	TEGRA_INIT_DATA_MUX8("extern2", NULL, "extern2", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN2, 121, 0, TEGRA114_CLK_EXTERN2),
-	TEGRA_INIT_DATA_MUX8("extern3", NULL, "extern3", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN3, 122, 0, TEGRA114_CLK_EXTERN3),
-	TEGRA_INIT_DATA_MUX("i2cslow", NULL, "i2cslow", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_I2CSLOW, 81, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2CSLOW),
-	TEGRA_INIT_DATA_INT8("se", NULL, "se", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SE, 127, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SE),
-	TEGRA_INIT_DATA_INT_FLAGS("mselect", NULL, "mselect", mux_pllp_clkm, CLK_SOURCE_MSELECT, 99, 0, TEGRA114_CLK_MSELECT, CLK_IGNORE_UNUSED),
-	TEGRA_INIT_DATA_MUX("dfll_ref", "ref", "t114_dfll", mux_pllp_clkm, CLK_SOURCE_DFLL_REF, 155, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DFLL_REF),
-	TEGRA_INIT_DATA_MUX("dfll_soc", "soc", "t114_dfll", mux_pllp_clkm, CLK_SOURCE_DFLL_SOC, 155, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DFLL_SOC),
-	TEGRA_INIT_DATA_MUX8("soc_therm", NULL, "soc_therm", mux_pllm_pllc_pllp_plla, CLK_SOURCE_SOC_THERM, 78, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SOC_THERM),
-	TEGRA_INIT_DATA_XUSB("xusb_host_src", "host_src", "tegra_xhci", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_HOST_SRC, 143, TEGRA_PERIPH_ON_APB | TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_HOST_SRC),
-	TEGRA_INIT_DATA_XUSB("xusb_falcon_src", "falcon_src", "tegra_xhci", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_FALCON_SRC, 143, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_FALCON_SRC),
-	TEGRA_INIT_DATA_XUSB("xusb_fs_src", "fs_src", "tegra_xhci", mux_clkm_48M_pllp_480M, CLK_SOURCE_XUSB_FS_SRC, 143, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_FS_SRC),
-	TEGRA_INIT_DATA_XUSB("xusb_ss_src", "ss_src", "tegra_xhci", mux_clkm_pllre_clk32_480M_pllc_ref, CLK_SOURCE_XUSB_SS_SRC, 143, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_SS_SRC),
-	TEGRA_INIT_DATA_XUSB("xusb_dev_src", "dev_src", "tegra_xhci", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_DEV_SRC, 95, TEGRA_PERIPH_ON_APB | TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_DEV_SRC),
-	TEGRA_INIT_DATA_AUDIO("d_audio", "d_audio", "tegra30-ahub", CLK_SOURCE_D_AUDIO, 106, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_D_AUDIO),
-	TEGRA_INIT_DATA_AUDIO("dam0", NULL, "tegra30-dam.0", CLK_SOURCE_DAM0, 108, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DAM0),
-	TEGRA_INIT_DATA_AUDIO("dam1", NULL, "tegra30-dam.1", CLK_SOURCE_DAM1, 109, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DAM1),
-	TEGRA_INIT_DATA_AUDIO("dam2", NULL, "tegra30-dam.2", CLK_SOURCE_DAM2, 110, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DAM2),
-};
-
-static struct tegra_periph_init_data tegra_periph_nodiv_clk_list[] = {
-	TEGRA_INIT_DATA_NODIV("disp1", NULL, "tegradc.0", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_DISP1, 29, 7, 27, 0, TEGRA114_CLK_DISP1),
-	TEGRA_INIT_DATA_NODIV("disp2", NULL, "tegradc.1", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_DISP2, 29, 7, 26, 0, TEGRA114_CLK_DISP2),
-};
-
-static __init void tegra114_periph_clk_init(void __iomem *clk_base)
+static __init void tegra114_periph_clk_init(void __iomem *clk_base,
+					    void __iomem *pmc_base)
 {
-	struct tegra_periph_init_data *data;
 	struct clk *clk;
-	int i;
 	u32 val;
 
-	/* apbdma */
-	clk = tegra114_periph_gate_helper("apbdma", "clk_m", 0, clk_base,
-				  0, 34, periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_APBDMA] = clk;
-
-	/* rtc */
-	clk = tegra114_periph_gate_helper("rtc", "clk_32k",
-				    TEGRA_PERIPH_ON_APB |
-				    TEGRA_PERIPH_NO_RESET, clk_base,
-				    0, 4, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "rtc-tegra");
-	clks[TEGRA114_CLK_RTC] = clk;
-
-	/* kbc */
-	clk = tegra114_periph_gate_helper("kbc", "clk_32k",
-				    TEGRA_PERIPH_ON_APB |
-				    TEGRA_PERIPH_NO_RESET, clk_base,
-				    0, 36, periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_KBC] = clk;
-
-	/* timer */
-	clk = tegra114_periph_gate_helper("timer", "clk_m", 0, clk_base,
-				  0, 5, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "timer");
-	clks[TEGRA114_CLK_TIMER] = clk;
-
-	/* kfuse */
-	clk = tegra114_periph_gate_helper("kfuse", "clk_m",
-				  TEGRA_PERIPH_ON_APB, clk_base,  0, 40,
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_KFUSE] = clk;
-
-	/* fuse */
-	clk = tegra114_periph_gate_helper("fuse", "clk_m",
-				  TEGRA_PERIPH_ON_APB, clk_base,  0, 39,
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_FUSE] = clk;
-
-	/* fuse_burn */
-	clk = tegra114_periph_gate_helper("fuse_burn", "clk_m",
-				  TEGRA_PERIPH_ON_APB, clk_base,  0, 39,
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_FUSE_BURN] = clk;
-
-	/* apbif */
-	clk = tegra114_periph_gate_helper("apbif", "clk_m",
-				  TEGRA_PERIPH_ON_APB, clk_base,  0, 107,
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_APBIF] = clk;
-
-	/* hda2hdmi */
-	clk = tegra114_periph_gate_helper("hda2hdmi", "clk_m",
-				    TEGRA_PERIPH_ON_APB, clk_base,  0, 128,
-				    periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_HDA2HDMI] = clk;
-
-	/* vcp */
-	clk = tegra114_periph_gate_helper("vcp", "clk_m", 0, clk_base,  0,
-				  29, periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_VCP] = clk;
-
-	/* bsea */
-	clk = tegra114_periph_gate_helper("bsea", "clk_m", 0, clk_base,
-				  0, 62, periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_BSEA] = clk;
-
-	/* bsev */
-	clk = tegra114_periph_gate_helper("bsev", "clk_m", 0, clk_base,
-				  0, 63, periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_BSEV] = clk;
-
-	/* mipi-cal */
-	clk = tegra114_periph_gate_helper("mipi-cal", "clk_m", 0, clk_base,
-				   0, 56, periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_MIPI_CAL] = clk;
-
-	/* usbd */
-	clk = tegra114_periph_gate_helper("usbd", "clk_m", 0, clk_base,
-				  0, 22, periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_USBD] = clk;
-
-	/* usb2 */
-	clk = tegra114_periph_gate_helper("usb2", "clk_m", 0, clk_base,
-				  0, 58, periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_USB2] = clk;
-
-	/* usb3 */
-	clk = tegra114_periph_gate_helper("usb3", "clk_m", 0, clk_base,
-				  0, 59, periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_USB3] = clk;
-
-	/* csi */
-	clk = tegra114_periph_gate_helper("csi", "pll_p_out3", 0, clk_base,
-				   0, 52, periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_CSI] = clk;
-
-	/* isp */
-	clk = tegra114_periph_gate_helper("isp", "clk_m", 0, clk_base, 0,
-				  23, periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_ISP] = clk;
-
-	/* csus */
-	clk = tegra114_periph_gate_helper("csus", "clk_m",
-				  TEGRA_PERIPH_NO_RESET, clk_base, 0, 92,
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_CSUS] = clk;
-
-	/* dds */
-	clk = tegra114_periph_gate_helper("dds", "clk_m",
-				  TEGRA_PERIPH_ON_APB, clk_base, 0, 150,
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_DDS] = clk;
-
-	/* dp2 */
-	clk = tegra114_periph_gate_helper("dp2", "clk_m",
-				  TEGRA_PERIPH_ON_APB, clk_base, 0, 152,
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_DP2] = clk;
-
-	/* dtv */
-	clk = tegra114_periph_gate_helper("dtv", "clk_m",
-				    TEGRA_PERIPH_ON_APB, clk_base, 0, 79,
-				    periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_DTV] = clk;
-
-	/* dsia */
-	clk = clk_register_mux(NULL, "dsia_mux", mux_plld_out0_plld2_out0,
-			       ARRAY_SIZE(mux_plld_out0_plld2_out0), 0,
-			       clk_base + PLLD_BASE, 25, 1, 0, &pll_d_lock);
-	clks[TEGRA114_CLK_DSIA_MUX] = clk;
-	clk = tegra114_periph_gate_helper("dsia", "dsia_mux", 0, clk_base,
-				    0, 48, periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_DSIA] = clk;
-
 	/* xusb_hs_src */
 	val = readl(clk_base + CLK_SOURCE_XUSB_SS_SRC);
 	val |= BIT(25); /* always select PLLU_60M */
@@ -1807,61 +1239,25 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 					1, 1);
 	clks[TEGRA114_CLK_XUSB_HS_SRC] = clk;
 
-	/* xusb_host */
-	clk = tegra114_periph_gate_helper("xusb_host", "xusb_host_src", 0,
-				    clk_base, 0, 89, periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_XUSB_HOST] = clk;
-
-	/* xusb_ss */
-	clk = tegra114_periph_gate_helper("xusb_ss", "xusb_ss_src", 0,
-				    clk_base, 0, 156, periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_XUSB_HOST] = clk;
+	/* dsia mux */
+	clk = clk_register_mux(NULL, "dsia_mux", mux_plld_out0_plld2_out0,
+			       ARRAY_SIZE(mux_plld_out0_plld2_out0), 0,
+			       clk_base + PLLD_BASE, 25, 1, 0, &pll_d_lock);
+	clks[TEGRA114_CLK_DSIA_MUX] = clk;
 
-	/* xusb_dev */
-	clk = tegra114_periph_gate_helper("xusb_dev", "xusb_dev_src", 0,
-				    clk_base, 0, 95, periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_XUSB_DEV] = clk;
+	/* dsib mux */
+	clk = clk_register_mux(NULL, "dsib_mux", mux_plld_out0_plld2_out0,
+			       ARRAY_SIZE(mux_plld_out0_plld2_out0), 0,
+			       clk_base + PLLD2_BASE, 25, 1, 0, &pll_d2_lock);
+	clks[TEGRA114_CLK_DSIB_MUX] = clk;
 
-	/* emc */
+	/* emc mux */
 	clk = clk_register_mux(NULL, "emc_mux", mux_pllmcp_clkm,
 			       ARRAY_SIZE(mux_pllmcp_clkm), 0,
 			       clk_base + CLK_SOURCE_EMC,
 			       29, 3, 0, NULL);
-	clk = tegra114_periph_gate_helper("emc", "emc_mux", 0, clk_base,
-				CLK_IGNORE_UNUSED, 57, periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_EMC] = clk;
-
-	for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
-		struct tegra_clk_periph_regs *bank;
 
-		data = &tegra_periph_clk_list[i];
-		bank = get_reg_bank(data->periph.gate.clk_num);
-
-		if (!bank)
-			continue;
-
-		data->periph.gate.regs = bank;
-		clk = tegra_clk_register_periph(data->name,
-			data->parent_names, data->num_parents, &data->periph,
-			clk_base, data->offset, data->flags);
-		clks[data->clk_id] = clk;
-	}
-
-	for (i = 0; i < ARRAY_SIZE(tegra_periph_nodiv_clk_list); i++) {
-		struct tegra_clk_periph_regs *bank;
-
-		data = &tegra_periph_nodiv_clk_list[i];
-		bank = get_reg_bank(data->periph.gate.clk_num);
-
-		if (!bank)
-			continue;
-
-		data->periph.gate.regs = bank;
-		clk = tegra_clk_register_periph_nodiv(data->name,
-				data->parent_names, data->num_parents,
-				&data->periph, clk_base, data->offset);
-		clks[data->clk_id] = clk;
-	}
+	tegra_periph_clk_init(clk_base, pmc_base, tegra114_clks);
 }
 
 /* Tegra114 CPU clock and reset control functions */
@@ -2107,9 +1503,10 @@ static void __init tegra114_clock_init(struct device_node *np)
 
 	tegra114_fixed_clk_init(clk_base);
 	tegra114_pll_init(clk_base, pmc_base);
-	tegra114_periph_clk_init(clk_base);
+	tegra114_periph_clk_init(clk_base, pmc_base);
 	tegra_audio_clk_init(clk_base, pmc_base, tegra114_clks, NULL);
 	tegra114_pmc_clk_init(pmc_base);
+
 	tegra114_super_clk_init(clk_base);
 
 	tegra_add_of_provider(np);
diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index 0391122..6900f1b 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -1019,7 +1019,7 @@ static void __init tegra20_periph_clk_init(void)
 
 	for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
 		data = &tegra_periph_clk_list[i];
-		clk = tegra_clk_register_periph(data->name, data->parent_names,
+		clk = tegra_clk_register_periph(data->name, data->p.parent_names,
 				data->num_parents, &data->periph,
 				clk_base, data->offset, data->flags);
 		clk_register_clkdev(clk, data->con_id, data->dev_id);
@@ -1029,7 +1029,7 @@ static void __init tegra20_periph_clk_init(void)
 	for (i = 0; i < ARRAY_SIZE(tegra_periph_nodiv_clk_list); i++) {
 		data = &tegra_periph_nodiv_clk_list[i];
 		clk = tegra_clk_register_periph_nodiv(data->name,
-					data->parent_names,
+					data->p.parent_names,
 					data->num_parents, &data->periph,
 					clk_base, data->offset);
 		clk_register_clkdev(clk, data->con_id, data->dev_id);
diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index b637a06..d857eef 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -1684,7 +1684,7 @@ static void __init tegra30_periph_clk_init(void)
 
 	for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
 		data = &tegra_periph_clk_list[i];
-		clk = tegra_clk_register_periph(data->name, data->parent_names,
+		clk = tegra_clk_register_periph(data->name, data->p.parent_names,
 				data->num_parents, &data->periph,
 				clk_base, data->offset, data->flags);
 		clk_register_clkdev(clk, data->con_id, data->dev_id);
@@ -1694,7 +1694,7 @@ static void __init tegra30_periph_clk_init(void)
 	for (i = 0; i < ARRAY_SIZE(tegra_periph_nodiv_clk_list); i++) {
 		data = &tegra_periph_nodiv_clk_list[i];
 		clk = tegra_clk_register_periph_nodiv(data->name,
-					data->parent_names,
+					data->p.parent_names,
 					data->num_parents, &data->periph,
 					clk_base, data->offset);
 		clk_register_clkdev(clk, data->con_id, data->dev_id);
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 9ed9bd6..e847aa9 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -474,7 +474,10 @@ struct clk *tegra_clk_register_periph_nodiv(const char *name,
 struct tegra_periph_init_data {
 	const char *name;
 	int clk_id;
-	const char **parent_names;
+	union {
+		const char **parent_names;
+		const char *parent_name;
+	} p;
 	int num_parents;
 	struct tegra_clk_periph periph;
 	u32 offset;
@@ -490,7 +493,7 @@ struct tegra_periph_init_data {
 	{								\
 		.name = _name,						\
 		.clk_id = _clk_id,					\
-		.parent_names = _parent_names,				\
+		.p.parent_names = _parent_names,			\
 		.num_parents = ARRAY_SIZE(_parent_names),		\
 		.periph = TEGRA_CLK_PERIPH(_mux_shift, _mux_mask,	\
 					   _mux_flags, _div_shift,	\
@@ -604,6 +607,9 @@ void tegra_audio_clk_init(void __iomem *clk_base,
 			void __iomem *pmc_base, struct tegra_clk *tegra_clks,
 			struct tegra_clk_pll_freq_table *freq_table);
 
+void tegra_periph_clk_init(void __iomem *clk_base, void __iomem *pmc_base,
+			struct tegra_clk *tegra_clks);
+
 void tegra114_clock_tune_cpu_trimmers_high(void);
 void tegra114_clock_tune_cpu_trimmers_low(void);
 void tegra114_clock_tune_cpu_trimmers_init(void);
-- 
1.7.7.rc0.72.g4b5ea.dirty

