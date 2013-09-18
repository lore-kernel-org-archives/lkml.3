Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3IROqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:46:47 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:1278 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab3IROqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:46:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 18 Sep 2013 07:43:24 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH 02/12] clk: tegra: periph_clk_enb_refcnt as common infra
Date: Wed, 18 Sep 2013 17:40:54 +0300
Message-ID: <1379515331-19427-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com>
References: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes periph_clk_enb_refcnt a global array, dynamically allocated
at boottime. It simplifies the macros somewhat and allows clocks common to
several Tegra SoCs to be defined in a separate files.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-periph.c   |    1 +
 drivers/clk/tegra/clk-tegra114.c |   36 +++++++++++-------------------------
 drivers/clk/tegra/clk-tegra20.c  |   16 +++++-----------
 drivers/clk/tegra/clk-tegra30.c  |   19 +++++++------------
 drivers/clk/tegra/clk.c          |    2 ++
 drivers/clk/tegra/clk.h          |   14 +++++++-------
 6 files changed, 33 insertions(+), 55 deletions(-)

diff --git a/drivers/clk/tegra/clk-periph.c b/drivers/clk/tegra/clk-periph.c
index b2309d3..55ab4b1 100644
--- a/drivers/clk/tegra/clk-periph.c
+++ b/drivers/clk/tegra/clk-periph.c
@@ -191,6 +191,7 @@ static struct clk *_tegra_clk_register_periph(const char *name,
 	periph->mux.reg = clk_base + offset;
 	periph->divider.reg = div ? (clk_base + offset) : NULL;
 	periph->gate.clk_base = clk_base;
+	periph->gate.enable_refcnt = periph_clk_enb_refcnt;
 
 	clk = clk_register(NULL, &periph->hw);
 	if (IS_ERR(clk))
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index 2ec3488..9970f87 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -57,8 +57,6 @@
 #define CPU_FINETRIM_R_FCPU_6_SHIFT	10		/* ftop */
 #define CPU_FINETRIM_R_FCPU_6_MASK	(0x3 << CPU_FINETRIM_R_FCPU_6_SHIFT)
 
-#define CLK_OUT_ENB_NUM			6
-
 #define PLLC_BASE 0x80
 #define PLLC_MISC2 0x88
 #define PLLC_MISC 0x8c
@@ -264,8 +262,6 @@ static struct cpu_clk_suspend_context {
 } tegra114_cpu_clk_sctx;
 #endif
 
-static int periph_clk_enb_refcnt[CLK_OUT_ENB_NUM * 32];
-
 static void __iomem *clk_base;
 static void __iomem *pmc_base;
 
@@ -710,78 +706,68 @@ static unsigned long tegra114_input_freq[] = {
 			    _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
 			30, MASK(2), 0, 0, 8, 1, 0, 0,\
-			_clk_num, periph_clk_enb_refcnt, _gate_flags,\
-			 _clk_id, _parents##_idx, 0)
+			_clk_num,  _gate_flags, _clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_MUX_FLAGS(_name, _con_id, _dev_id, _parents, _offset,\
 			    _clk_num, _gate_flags, _clk_id, flags)\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
 			30, MASK(2), 0, 0, 8, 1, 0, 0, _clk_num,	\
-			periph_clk_enb_refcnt, _gate_flags, _clk_id,	\
-			_parents##_idx, flags)
+			_gate_flags, _clk_id, _parents##_idx, flags)
 
 #define TEGRA_INIT_DATA_MUX8(_name, _con_id, _dev_id, _parents, _offset, \
 			     _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
 			29, MASK(3), 0, 0, 8, 1, 0, 0, _clk_num,	\
-			periph_clk_enb_refcnt, _gate_flags, _clk_id,	\
-			_parents##_idx, 0)
+			_gate_flags, _clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_INT(_name, _con_id, _dev_id, _parents, _offset,	\
 			    _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
 			30, MASK(2), 0, 0, 8, 1, TEGRA_DIVIDER_INT, 0,\
-			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
-			_clk_id, _parents##_idx, 0)
+			_clk_num, _gate_flags, _clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_INT_FLAGS(_name, _con_id, _dev_id, _parents, _offset,\
 			    _clk_num, _gate_flags, _clk_id, flags)\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
 			30, MASK(2), 0, 0, 8, 1, TEGRA_DIVIDER_INT, 0,\
-			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
-			_clk_id, _parents##_idx, flags)
+			_clk_num,  _gate_flags, _clk_id, _parents##_idx, flags)
 
 #define TEGRA_INIT_DATA_INT8(_name, _con_id, _dev_id, _parents, _offset,\
 			    _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
 			29, MASK(3), 0, 0, 8, 1, TEGRA_DIVIDER_INT, 0,\
-			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
-			_clk_id, _parents##_idx, 0)
+			_clk_num, _gate_flags, _clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_UART(_name, _con_id, _dev_id, _parents, _offset,\
 			     _clk_num, _clk_id)			\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
 			30, MASK(2), 0, 0, 16, 1, TEGRA_DIVIDER_UART, 0,\
-			_clk_num, periph_clk_enb_refcnt, 0, _clk_id,	\
-			_parents##_idx, 0)
+			_clk_num, 0, _clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_I2C(_name, _con_id, _dev_id, _parents, _offset,\
 			     _clk_num, _clk_id)			\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
 			30, MASK(2), 0, 0, 16, 0, 0, 0, _clk_num,	\
-			periph_clk_enb_refcnt, 0, _clk_id, _parents##_idx, 0)
+			0, _clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_NODIV(_name, _con_id, _dev_id, _parents, _offset, \
 			      _mux_shift, _mux_mask, _clk_num, \
 			      _gate_flags, _clk_id)			\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
 			_mux_shift, _mux_mask, 0, 0, 0, 0, 0, 0,	\
-			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
-			_clk_id, _parents##_idx, 0)
+			_clk_num, _gate_flags, _clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_XUSB(_name, _con_id, _dev_id, _parents, _offset, \
 			     _clk_num, _gate_flags, _clk_id)	 \
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset, \
 			29, MASK(3), 0, 0, 8, 1, TEGRA_DIVIDER_INT, 0, \
-			_clk_num, periph_clk_enb_refcnt, _gate_flags,	 \
-			_clk_id, _parents##_idx, 0)
+			_clk_num, _gate_flags, _clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_AUDIO(_name, _con_id, _dev_id, _offset,  _clk_num,\
 				 _gate_flags, _clk_id)		\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, mux_d_audio_clk,	\
 			_offset, 16, 0xE01F, 0, 0, 8, 1, 0, 0, _clk_num, \
-			periph_clk_enb_refcnt, _gate_flags , _clk_id,	\
-			mux_d_audio_clk_idx, 0)
+			_gate_flags , _clk_id,	mux_d_audio_clk_idx, 0)
 
 struct utmi_clk_param {
 	/* Oscillator Frequency in KHz */
diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index ebe94ce..0391122 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -188,8 +188,6 @@ static struct cpu_clk_suspend_context {
 } tegra20_cpu_clk_sctx;
 #endif
 
-static int periph_clk_enb_refcnt[CLK_OUT_ENB_NUM * 32];
-
 static void __iomem *clk_base;
 static void __iomem *pmc_base;
 
@@ -200,30 +198,26 @@ static DEFINE_SPINLOCK(sysrate_lock);
 			    _clk_num, _regs, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
 			30, 2, 0, 0, 8, 1, TEGRA_DIVIDER_ROUND_UP,	\
-			_regs, _clk_num, periph_clk_enb_refcnt,		\
-			_gate_flags, _clk_id)
+			_regs, _clk_num, _gate_flags, _clk_id)
 
 #define TEGRA_INIT_DATA_INT(_name, _con_id, _dev_id, _parents, _offset,	\
 			    _clk_num, _regs, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
 			30, 2, 0, 0, 8, 1, TEGRA_DIVIDER_INT, _regs,	\
-			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
-			_clk_id)
+			_clk_num, _gate_flags, _clk_id)
 
 #define TEGRA_INIT_DATA_DIV16(_name, _con_id, _dev_id, _parents, _offset, \
 			      _clk_num, _regs, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
 			30, 2, 0, 0, 16, 0, TEGRA_DIVIDER_ROUND_UP, _regs, \
-			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
-			_clk_id)
+			_clk_num, _gate_flags, _clk_id)
 
 #define TEGRA_INIT_DATA_NODIV(_name, _con_id, _dev_id, _parents, _offset, \
 			      _mux_shift, _mux_width, _clk_num, _regs,	\
 			      _gate_flags, _clk_id)			\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
 			_mux_shift, _mux_width, 0, 0, 0, 0, 0, _regs,	\
-			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
-			_clk_id)
+			_clk_num, _gate_flags, _clk_id)
 
 /* IDs assigned here must be in sync with DT bindings definition
  * for Tegra20 clocks .
@@ -853,7 +847,7 @@ static struct tegra_periph_init_data tegra_periph_clk_list[] = {
 	TEGRA_INIT_DATA_DIV16("i2c3",	"div-clk",	"tegra-i2c.2",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C3,	  67,	&periph_u_regs,	TEGRA_PERIPH_ON_APB, i2c3),
 	TEGRA_INIT_DATA_DIV16("dvc",	"div-clk",	"tegra-i2c.3",	 mux_pllpcm_clkm,   CLK_SOURCE_DVC,	  47,	&periph_h_regs,	TEGRA_PERIPH_ON_APB, dvc),
 	TEGRA_INIT_DATA_MUX("hdmi",	NULL,		"hdmi",		 mux_pllpdc_clkm,   CLK_SOURCE_HDMI,	  51,	&periph_h_regs,	0, hdmi),
-	TEGRA_INIT_DATA("pwm",		NULL,		"tegra-pwm",	 pwm_parents,	    CLK_SOURCE_PWM,	  28, 3, 0, 0, 8, 1, 0, &periph_l_regs, 17, periph_clk_enb_refcnt, TEGRA_PERIPH_ON_APB, pwm),
+	TEGRA_INIT_DATA("pwm",		NULL,		"tegra-pwm",	 pwm_parents,	    CLK_SOURCE_PWM,	  28, 3, 0, 0, 8, 1, 0, &periph_l_regs, 17, TEGRA_PERIPH_ON_APB, pwm),
 };
 
 static struct tegra_periph_init_data tegra_periph_nodiv_clk_list[] = {
diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index ab35040..b637a06 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -266,8 +266,6 @@ static struct cpu_clk_suspend_context {
 } tegra30_cpu_clk_sctx;
 #endif
 
-static int periph_clk_enb_refcnt[CLK_OUT_ENB_NUM * 32];
-
 static void __iomem *clk_base;
 static void __iomem *pmc_base;
 static unsigned long input_freq;
@@ -283,41 +281,38 @@ static DEFINE_SPINLOCK(sysrate_lock);
 			    _clk_num, _regs, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
 			30, 2, 0, 0, 8, 1, 0, _regs, _clk_num,		\
-			periph_clk_enb_refcnt, _gate_flags, _clk_id)
+			 _gate_flags, _clk_id)
 
 #define TEGRA_INIT_DATA_DIV16(_name, _con_id, _dev_id, _parents, _offset, \
 			    _clk_num, _regs, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
 			30, 2, 0, 0, 16, 0, TEGRA_DIVIDER_ROUND_UP,	\
-			_regs, _clk_num, periph_clk_enb_refcnt,		\
-			_gate_flags, _clk_id)
+			_regs, _clk_num,  _gate_flags, _clk_id)
 
 #define TEGRA_INIT_DATA_MUX8(_name, _con_id, _dev_id, _parents, _offset, \
 			     _clk_num, _regs, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
 			29, 3, 0, 0, 8, 1, 0, _regs, _clk_num,		\
-			periph_clk_enb_refcnt, _gate_flags, _clk_id)
+			_gate_flags, _clk_id)
 
 #define TEGRA_INIT_DATA_INT(_name, _con_id, _dev_id, _parents, _offset,	\
 			    _clk_num, _regs, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
 			30, 2, 0, 0, 8, 1, TEGRA_DIVIDER_INT, _regs,	\
-			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
-			_clk_id)
+			_clk_num, _gate_flags, _clk_id)
 
 #define TEGRA_INIT_DATA_UART(_name, _con_id, _dev_id, _parents, _offset,\
 			     _clk_num, _regs, _clk_id)			\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
 			30, 2, 0, 0, 16, 1, TEGRA_DIVIDER_UART, _regs,	\
-			_clk_num, periph_clk_enb_refcnt, 0, _clk_id)
+			_clk_num, 0, _clk_id)
 
 #define TEGRA_INIT_DATA_NODIV(_name, _con_id, _dev_id, _parents, _offset, \
 			      _mux_shift, _mux_width, _clk_num, _regs,	\
 			      _gate_flags, _clk_id)			\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
 			_mux_shift, _mux_width, 0, 0, 0, 0, 0, _regs,	\
-			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
-			_clk_id)
+			_clk_num, _gate_flags, _clk_id)
 
 /*
  * IDs assigned here must be in sync with DT bindings definition
@@ -1497,7 +1492,7 @@ static struct tegra_periph_init_data tegra_periph_clk_list[] = {
 	TEGRA_INIT_DATA_MUX8("extern1",	NULL,		"extern1",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN1,	120,	&periph_v_regs,	0, extern1),
 	TEGRA_INIT_DATA_MUX8("extern2",	NULL,		"extern2",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN2,	121,	&periph_v_regs,	0, extern2),
 	TEGRA_INIT_DATA_MUX8("extern3",	NULL,		"extern3",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN3,	122,	&periph_v_regs,	0, extern3),
-	TEGRA_INIT_DATA("pwm",		NULL,		"pwm",			mux_pllpc_clk32k_clkm,	CLK_SOURCE_PWM,		28, 2, 0, 0, 8, 1, 0, &periph_l_regs, 17, periph_clk_enb_refcnt, 0, pwm),
+	TEGRA_INIT_DATA("pwm",		NULL,		"pwm",			mux_pllpc_clk32k_clkm,	CLK_SOURCE_PWM,		28, 2, 0, 0, 8, 1, 0, &periph_l_regs, 17, 0, pwm),
 };
 
 static struct tegra_periph_init_data tegra_periph_nodiv_clk_list[] = {
diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
index 0508dd1..07b0702 100644
--- a/drivers/clk/tegra/clk.c
+++ b/drivers/clk/tegra/clk.c
@@ -125,6 +125,8 @@ int __init tegra_clk_periph_banks(int num)
 	if (num > ARRAY_SIZE(periph_regs))
 		return -EINVAL;
 
+	periph_clk_enb_refcnt = kzalloc(32 * num *
+				sizeof(*periph_clk_enb_refcnt), GFP_KERNEL);
 	periph_banks = num;
 
 	return 0;
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index da1e01f..a133279 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -37,6 +37,8 @@ struct tegra_clk_sync_source {
 	container_of(_hw, struct tegra_clk_sync_source, hw)
 
 extern const struct clk_ops tegra_clk_sync_source_ops;
+extern int *periph_clk_enb_refcnt;
+
 struct clk *tegra_clk_register_sync_source(const char *name,
 		unsigned long fixed_rate, unsigned long max_rate);
 
@@ -443,7 +445,7 @@ struct clk *tegra_clk_register_periph_nodiv(const char *name,
 
 #define TEGRA_CLK_PERIPH(_mux_shift, _mux_mask, _mux_flags,		\
 			 _div_shift, _div_width, _div_frac_width,	\
-			 _div_flags, _clk_num, _enb_refcnt, _regs,	\
+			 _div_flags, _clk_num,  _regs,			\
 			 _gate_flags, _table)				\
 	{								\
 		.mux = {						\
@@ -461,7 +463,6 @@ struct clk *tegra_clk_register_periph_nodiv(const char *name,
 		.gate = {						\
 			.flags = _gate_flags,				\
 			.clk_num = _clk_num,				\
-			.enable_refcnt = _enb_refcnt,			\
 			.regs = _regs,					\
 		},							\
 		.mux_ops = &clk_mux_ops,				\
@@ -484,8 +485,7 @@ struct tegra_periph_init_data {
 #define TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parent_names, _offset,\
 			_mux_shift, _mux_mask, _mux_flags, _div_shift,	\
 			_div_width, _div_frac_width, _div_flags, _regs,	\
-			_clk_num, _enb_refcnt, _gate_flags, _clk_id, _table,\
-			_flags) \
+			_clk_num, _gate_flags, _clk_id, _table, _flags) \
 	{								\
 		.name = _name,						\
 		.clk_id = _clk_id,					\
@@ -495,7 +495,7 @@ struct tegra_periph_init_data {
 					   _mux_flags, _div_shift,	\
 					   _div_width, _div_frac_width,	\
 					   _div_flags, _clk_num,	\
-					   _enb_refcnt, _regs,		\
+					   _regs,			\
 					   _gate_flags, _table),	\
 		.offset = _offset,					\
 		.con_id = _con_id,					\
@@ -506,11 +506,11 @@ struct tegra_periph_init_data {
 #define TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parent_names, _offset,\
 			_mux_shift, _mux_width, _mux_flags, _div_shift,	\
 			_div_width, _div_frac_width, _div_flags, _regs,	\
-			_clk_num, _enb_refcnt, _gate_flags, _clk_id)	\
+			_clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parent_names, _offset,\
 			_mux_shift, BIT(_mux_width) - 1, _mux_flags,	\
 			_div_shift, _div_width, _div_frac_width, _div_flags, \
-			_regs, _clk_num, _enb_refcnt, _gate_flags, _clk_id,\
+			_regs, _clk_num, _gate_flags, _clk_id,\
 			NULL, 0)
 
 /**
-- 
1.7.7.rc0.72.g4b5ea.dirty

