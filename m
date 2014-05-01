Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbaEAJ5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:57:46 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:53820 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575AbaEAJ5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:57:39 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 15/47] mtd: nand: stm_nand_bch: configure BCH and FLEX by ONFI timing mode
Date: Thu,  1 May 2014 10:56:22 +0100
Message-Id: <1398938214-17847-16-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for configuring the NAND Controller timing
registers according to 'nand_timing_spec' data. Since the stm_nand_bch
driver falls back to Hamming FLEX mode for certain operations, it is
necessary to configure the timing registers of both the Hamming
Controller and the BCH Controller.

The device initialisation is now performed in two stages,
nand_scan_ident() and nand_scan_tail(), rather than a single call to
nand_scan(). This allows information obtained during device discovery
(e.g. ONFI parameter data) to help optimise the timing configuration
prior to performing some of the more data intensive tasks found in
nand_scan_tail() (e.g. bad block scanning).

If 'nand_timing_spec' is supplied via platform data, then this is used
in preference for configuring the timing registers. Failing that, we
test for the timing mode advertised by ONFI-compliant NAND, and select
one of the predefined timing specifications. Finally, if no timing
data is available, the timing registers are left unmodified
(i.e. reset values, or as programmed by the boot-loader).

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 311 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 311 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index b1de66e..fdb06517 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -330,6 +330,10 @@ static void nandi_set_mtd_defaults(struct nandi_controller *nandi,
 	mtd->subpage_sft = 0;
 }
 
+/*
+ * Timing and Clocks
+ */
+
 static void nandi_clk_enable(struct nandi_controller *nandi)
 {
 	if (nandi->emi_clk)
@@ -368,6 +372,291 @@ static struct clk *nandi_clk_setup(struct nandi_controller *nandi,
 	return clk;
 }
 
+/* Derive Hamming-FLEX timing register values from 'nand_timing_spec' data */
+static void flex_calc_timing_registers(const struct nand_timing_spec *spec,
+				       int tCLK, int relax,
+				       uint32_t *ctl_timing,
+				       uint32_t *wen_timing,
+				       uint32_t *ren_timing)
+{
+	int tMAX_HOLD;
+	int n_ctl_setup;
+	int n_ctl_hold;
+	int n_ctl_wb;
+
+	int tMAX_WEN_OFF;
+	int n_wen_on;
+	int n_wen_off;
+
+	int tMAX_REN_OFF;
+	int n_ren_on;
+	int n_ren_off;
+
+	/*
+	 * CTL_TIMING
+	 */
+
+	/*	- SETUP */
+	n_ctl_setup = (spec->tCLS - spec->tWP + tCLK - 1)/tCLK;
+	if (n_ctl_setup < 1)
+		n_ctl_setup = 1;
+	n_ctl_setup += relax;
+
+	/*	- HOLD */
+	tMAX_HOLD = spec->tCLH;
+	if (spec->tCH > tMAX_HOLD)
+		tMAX_HOLD = spec->tCH;
+	if (spec->tALH > tMAX_HOLD)
+		tMAX_HOLD = spec->tALH;
+	if (spec->tDH > tMAX_HOLD)
+		tMAX_HOLD = spec->tDH;
+	n_ctl_hold = (tMAX_HOLD + tCLK - 1)/tCLK + relax;
+
+	/*	- CE_deassert_hold = 0 */
+
+	/*	- WE_high_to_RBn_low */
+	n_ctl_wb = (spec->tWB + tCLK - 1)/tCLK;
+
+	*ctl_timing = ((n_ctl_setup & 0xff) |
+		       (n_ctl_hold & 0xff) << 8 |
+		       (n_ctl_wb & 0xff) << 24);
+
+	/*
+	 * WEN_TIMING
+	 */
+
+	/*	- ON */
+	n_wen_on = (spec->tWH + tCLK - 1)/tCLK + relax;
+
+	/*	- OFF */
+	tMAX_WEN_OFF = spec->tWC - spec->tWH;
+	if (spec->tWP > tMAX_WEN_OFF)
+		tMAX_WEN_OFF = spec->tWP;
+	n_wen_off = (tMAX_WEN_OFF + tCLK - 1)/tCLK + relax;
+
+	*wen_timing = ((n_wen_on & 0xff) |
+		       (n_wen_off & 0xff) << 8);
+
+	/*
+	 * REN_TIMING
+	 */
+
+	/*	- ON */
+	n_ren_on = (spec->tREH + tCLK - 1)/tCLK + relax;
+
+	/*	- OFF */
+	tMAX_REN_OFF = spec->tRC - spec->tREH;
+	if (spec->tRP > tMAX_REN_OFF)
+		tMAX_REN_OFF = spec->tRP;
+	if (spec->tREA > tMAX_REN_OFF)
+		tMAX_REN_OFF = spec->tREA;
+	n_ren_off = (tMAX_REN_OFF + tCLK - 1)/tCLK + 1 + relax;
+
+	*ren_timing = ((n_ren_on & 0xff) |
+		       (n_ren_off & 0xff) << 8);
+}
+
+/* Derive BCH timing register values from 'nand_timing_spec' data */
+static void bch_calc_timing_registers(const struct nand_timing_spec *spec,
+				      int tCLK, int relax,
+				      uint32_t *ctl_timing,
+				      uint32_t *wen_timing,
+				      uint32_t *ren_timing)
+{
+	int tMAX_HOLD;
+	int n_ctl_setup;
+	int n_ctl_hold;
+	int n_ctl_wb;
+
+	int n_wen_on;
+	int n_wen_off;
+	int wen_half_on;
+	int wen_half_off;
+
+	int tMAX_REN_ON;
+	int tMAX_CS_DEASSERT;
+	int n_d_latch;
+	int n_telqv;
+	int n_ren_on;
+	int n_ren_off;
+	int ren_half_on;
+	int ren_half_off;
+
+	/*
+	 * CTL_TIMING
+	 */
+
+	/*	- SETUP */
+	if (spec->tCLS > spec->tWP)
+		n_ctl_setup = (spec->tCLS - spec->tWP + tCLK - 1)/tCLK;
+	else
+		n_ctl_setup = 0;
+	n_ctl_setup += relax;
+
+	/*	- HOLD */
+	tMAX_HOLD = spec->tCLH;
+	if (spec->tCH > tMAX_HOLD)
+		tMAX_HOLD = spec->tCH;
+	if (spec->tALH > tMAX_HOLD)
+		tMAX_HOLD = spec->tALH;
+	if (spec->tDH > tMAX_HOLD)
+		tMAX_HOLD = spec->tDH;
+	n_ctl_hold = (tMAX_HOLD + tCLK - 1)/tCLK + relax;
+	/*	- CE_deassert_hold = 0 */
+
+	/*	- WE_high_to_RBn_low */
+	n_ctl_wb = (spec->tWB + tCLK - 1)/tCLK;
+
+	*ctl_timing = ((n_ctl_setup & 0xff) |
+		       (n_ctl_hold & 0xff) << 8 |
+		       (n_ctl_wb & 0xff) << 24);
+
+	/*
+	 * WEN_TIMING
+	 */
+
+	/*	- ON */
+	n_wen_on = (2 * spec->tWH + tCLK - 1)/tCLK;
+	wen_half_on = n_wen_on % 2;
+	n_wen_on /= 2;
+	n_wen_on += relax;
+
+	/*	- OFF */
+	n_wen_off = (2 * spec->tWP + tCLK - 1)/tCLK;
+	wen_half_off = n_wen_off % 2;
+	n_wen_off /= 2;
+	n_wen_off += relax;
+
+	*wen_timing = ((n_wen_on & 0xff) |
+		       (n_wen_off & 0xff) << 8 |
+		       (wen_half_on << 16) |
+		       (wen_half_off << 17));
+
+	/*
+	 * REN_TIMING
+	 */
+
+	/*	- ON */
+	tMAX_REN_ON = spec->tRC - spec->tRP;
+	if (spec->tREH > tMAX_REN_ON)
+		tMAX_REN_ON = spec->tREH;
+
+	n_ren_on = (2 * tMAX_REN_ON + tCLK - 1)/tCLK;
+	ren_half_on = n_ren_on % 2;
+	n_ren_on /= 2;
+	n_ren_on += relax;
+
+	/*	- OFF */
+	n_ren_off = (2 * spec->tREA + tCLK - 1)/tCLK;
+	ren_half_off = n_ren_off % 2;
+	n_ren_off /= 2;
+	n_ren_off += relax;
+
+	/*	- DATA_LATCH */
+	if (spec->tREA <= (spec->tRP - (2 * tCLK)))
+		n_d_latch = 0;
+	else if (spec->tREA <= (spec->tRP - tCLK))
+		n_d_latch = 1;
+	else if ((spec->tREA <= spec->tRP) && (spec->tRHOH >= 2 * tCLK))
+		n_d_latch = 2;
+	else
+		n_d_latch = 3;
+
+	/*	- TELQV */
+	tMAX_CS_DEASSERT = spec->tCOH;
+	if (spec->tCHZ > tMAX_CS_DEASSERT)
+		tMAX_CS_DEASSERT = spec->tCHZ;
+	if (spec->tCSD > tMAX_CS_DEASSERT)
+		tMAX_CS_DEASSERT = spec->tCSD;
+
+	n_telqv = (tMAX_CS_DEASSERT + tCLK - 1)/tCLK;
+
+	*ren_timing = ((n_ren_on & 0xff) |
+		       (n_ren_off & 0xff) << 8 |
+		       (n_d_latch & 0x3) << 16 |
+		       (wen_half_on << 18) |
+		       (wen_half_off << 19) |
+		       (n_telqv & 0xff) << 24);
+}
+
+static void flex_configure_timing_registers(struct nandi_controller *nandi,
+					    const struct nand_timing_spec *spec,
+					    int relax)
+{
+	uint32_t ctl_timing;
+	uint32_t wen_timing;
+	uint32_t ren_timing;
+	int emi_t_ns;
+
+	/* Select Hamming Controller */
+	emiss_nandi_select(STM_NANDI_HAMMING);
+
+	/* Get EMI clock (default 100MHz) */
+	if (nandi->emi_clk)
+		emi_t_ns = 1000000000UL / clk_get_rate(nandi->emi_clk);
+	else {
+		dev_warn(nandi->dev,
+			 "No EMI clock available; assuming default 100MHz\n");
+		emi_t_ns = 10;
+	}
+
+	/* Derive timing register values from specification */
+	flex_calc_timing_registers(spec, emi_t_ns, relax,
+				   &ctl_timing, &wen_timing, &ren_timing);
+
+	dev_dbg(nandi->dev,
+		"updating FLEX timing configuration [0x%08x, 0x%08x, 0x%08x]\n",
+		ctl_timing, wen_timing, ren_timing);
+
+	/* Program timing registers */
+	writel(ctl_timing, nandi->base + NANDHAM_CTL_TIMING);
+	writel(wen_timing, nandi->base + NANDHAM_WEN_TIMING);
+	writel(ren_timing, nandi->base + NANDHAM_REN_TIMING);
+}
+
+static void bch_configure_timing_registers(struct nandi_controller *nandi,
+					   const struct nand_timing_spec *spec,
+					   int relax)
+{
+	uint32_t ctl_timing;
+	uint32_t wen_timing;
+	uint32_t ren_timing;
+	int bch_t_ns;
+
+	/* Select BCH Controller */
+	emiss_nandi_select(STM_NANDI_BCH);
+
+	/* Get BCH clock (default 200MHz) */
+	if (nandi->bch_clk)
+		bch_t_ns = 1000000000UL / clk_get_rate(nandi->bch_clk);
+	else {
+		dev_warn(nandi->dev,
+			 "No BCH clock available; assuming default 200MHz\n");
+		bch_t_ns = 5;
+	}
+
+	/* Derive timing register values from specification */
+	bch_calc_timing_registers(spec, bch_t_ns, relax,
+				  &ctl_timing, &wen_timing, &ren_timing);
+
+	dev_dbg(nandi->dev,
+		"updating BCH timing configuration [0x%08x, 0x%08x, 0x%08x]\n",
+		ctl_timing, wen_timing, ren_timing);
+
+	/* Program timing registers */
+	writel(ctl_timing, nandi->base + NANDBCH_CTL_TIMING);
+	writel(wen_timing, nandi->base + NANDBCH_WEN_TIMING);
+	writel(ren_timing, nandi->base + NANDBCH_REN_TIMING);
+}
+
+static void nandi_configure_timing_registers(struct nandi_controller *nandi,
+					const struct nand_timing_spec *spec,
+					int relax)
+{
+	bch_configure_timing_registers(nandi, spec, relax);
+	flex_configure_timing_registers(nandi, spec, relax);
+}
+
 static void nandi_init_hamming(struct nandi_controller *nandi, int emi_bank)
 {
 	dev_dbg(nandi->dev, "%s\n", __func__);
@@ -610,6 +899,28 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
+	/*
+	 * Configure timing registers
+	 */
+	if (bank && bank->timing_spec) {
+		dev_info(&pdev->dev, "Using platform timing data\n");
+		nandi_configure_timing_registers(nandi, bank->timing_spec,
+						 bank->timing_relax);
+	} else if (chip->onfi_version) {
+		int mode = fls(onfi_get_async_timing_mode(chip) - 1);
+
+		/* Modes 4 and 5 (EDO) are not supported on our H/W */
+		if (mode > 3)
+			mode = 3;
+
+		dev_info(&pdev->dev, "Using ONFI Timing Mode %d\n", mode);
+		nandi_configure_timing_registers(nandi,
+					&st_nand_onfi_timing_specs[mode],
+					bank ? bank->timing_relax : 0);
+	} else {
+		dev_warn(&pdev->dev, "No timing data available\n");
+	}
+
 	return 0;
 }
 
-- 
1.8.3.2

