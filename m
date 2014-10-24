Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbaJXOqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:46:45 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:40911 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463AbaJXOk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:40:56 -0400
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com, gnurou@gmail.com,
        pdeschrijver@nvidia.com, rjw@rjwysocki.net, viresh.kumar@linaro.org
Cc: mturquette@linaro.org, pwalmsley@nvidia.com, vinceh@nvidia.com,
        pgaikwad@nvidia.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tuomas.tynkkynen@iki.fi,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>
Subject: [PATCH v5 03/16] clk: tegra: Add closed loop support for the DFLL
Date: Fri, 24 Oct 2014 17:39:10 +0300
Message-Id: <1414161563-16812-4-git-send-email-mikko.perttunen@kapsi.fi>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414161563-16812-1-git-send-email-mikko.perttunen@kapsi.fi>
References: <1414161563-16812-1-git-send-email-mikko.perttunen@kapsi.fi>
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>

With closed loop support, the clock rate of the DFLL can be adjusted.

The oscillator itself in the DFLL is a free-running oscillator whose
rate is directly determined the supply voltage. However, the DFLL
module contains logic to compare the DFLL output rate to a fixed
reference clock (51 MHz) and make a decision to either lower or raise
the DFLL supply voltage. The DFLL module can then autonomously change
the supply voltage by communicating with an off-chip PMIC via either I2C
or PWM signals. This driver currently supports only I2C.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Signed-off-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
---
 drivers/clk/tegra/clk-dfll.c | 657 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 654 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/tegra/clk-dfll.c b/drivers/clk/tegra/clk-dfll.c
index 358c5d4..e71f4fb 100644
--- a/drivers/clk/tegra/clk-dfll.c
+++ b/drivers/clk/tegra/clk-dfll.c
@@ -205,12 +205,16 @@
  */
 #define REF_CLOCK_RATE			51000000UL
 
+#define DVCO_RATE_TO_MULT(rate, ref_rate)	((rate) / ((ref_rate) / 2))
+#define MULT_TO_DVCO_RATE(mult, ref_rate)	((mult) * ((ref_rate) / 2))
 
 /**
  * enum dfll_ctrl_mode - DFLL hardware operating mode
  * @DFLL_UNINITIALIZED: (uninitialized state - not in hardware bitfield)
  * @DFLL_DISABLED: DFLL not generating an output clock
  * @DFLL_OPEN_LOOP: DVCO running, but DFLL not adjusting voltage
+ * @DFLL_CLOSED_LOOP: DVCO running, and DFLL adjusting voltage to match
+ *		      the requested rate
  *
  * The integer corresponding to the last two states, minus one, is
  * written to the DFLL hardware to change operating modes.
@@ -219,6 +223,7 @@ enum dfll_ctrl_mode {
 	DFLL_UNINITIALIZED = 0,
 	DFLL_DISABLED = 1,
 	DFLL_OPEN_LOOP = 2,
+	DFLL_CLOSED_LOOP = 3,
 };
 
 /**
@@ -236,6 +241,22 @@ enum dfll_tune_range {
 	DFLL_TUNE_LOW = 1,
 };
 
+/**
+ * struct dfll_rate_req - target DFLL rate request data
+ * @rate: target frequency, after the postscaling
+ * @dvco_target_rate: target frequency, after the postscaling
+ * @lut_index: LUT index at which voltage the dvco_target_rate will be reached
+ * @mult_bits: value to program to the MULT bits of the DFLL_FREQ_REQ register
+ * @scale_bits: value to program to the SCALE bits of the DFLL_FREQ_REQ register
+ */
+struct dfll_rate_req {
+	unsigned long rate;
+	unsigned long dvco_target_rate;
+	int lut_index;
+	u8 mult_bits;
+	u8 scale_bits;
+};
+
 struct tegra_dfll {
 	struct device			*dev;
 	struct tegra_dfll_soc_data	*soc;
@@ -259,9 +280,26 @@ struct tegra_dfll {
 	struct dentry			*debugfs_dir;
 	struct clk_hw			dfll_clk_hw;
 	const char			*output_clock_name;
+	struct dfll_rate_req		last_req;
 
 	/* Parameters from DT */
 	u32				droop_ctrl;
+	u32				sample_rate;
+	u32				force_mode;
+	u32				cf;
+	u32				ci;
+	u32				cg;
+	bool				cg_scale;
+
+	/* I2C interface parameters */
+	u32				i2c_fs_rate;
+	u32				i2c_reg;
+	u32				i2c_slave_addr;
+
+	/* i2c_lut array entries are regulator framework selectors */
+	unsigned			i2c_lut[MAX_DFLL_VOLTAGES];
+	int				i2c_lut_size;
+	u8				lut_min, lut_max, lut_safe;
 };
 
 #define clk_hw_to_dfll(_hw) container_of(_hw, struct tegra_dfll, dfll_clk_hw)
@@ -271,6 +309,7 @@ static const char * const mode_name[] = {
 	[DFLL_UNINITIALIZED] = "uninitialized",
 	[DFLL_DISABLED] = "disabled",
 	[DFLL_OPEN_LOOP] = "open_loop",
+	[DFLL_CLOSED_LOOP] = "closed_loop",
 };
 
 /*
@@ -494,6 +533,282 @@ static void dfll_set_mode(struct tegra_dfll *td,
 }
 
 /*
+ * DFLL-to-I2C controller interface
+ */
+
+/**
+ * dfll_i2c_set_output_enabled - enable/disable I2C PMIC voltage requests
+ * @td: DFLL instance
+ * @enable: whether to enable or disable the I2C voltage requests
+ *
+ * Set the master enable control for I2C control value updates. If disabled,
+ * then I2C control messages are inhibited, regardless of the DFLL mode.
+ */
+static int dfll_i2c_set_output_enabled(struct tegra_dfll *td, bool enable)
+{
+	u32 val;
+
+	val = dfll_i2c_readl(td, DFLL_OUTPUT_CFG);
+
+	if (enable)
+		val |= DFLL_OUTPUT_CFG_I2C_ENABLE;
+	else
+		val &= ~DFLL_OUTPUT_CFG_I2C_ENABLE;
+
+	dfll_i2c_writel(td, val, DFLL_OUTPUT_CFG);
+	dfll_i2c_wmb(td);
+
+	return 0;
+}
+
+/**
+ * dfll_load_lut - load the voltage lookup table
+ * @td: struct tegra_dfll *
+ *
+ * Load the voltage-to-PMIC register value lookup table into the DFLL
+ * IP block memory. Look-up tables can be loaded at any time.
+ */
+static void dfll_load_i2c_lut(struct tegra_dfll *td)
+{
+	int i, lut_index;
+	u32 val;
+
+	for (i = 0; i < MAX_DFLL_VOLTAGES; i++) {
+		if (i < td->lut_min)
+			lut_index = td->lut_min;
+		else if (i > td->lut_max)
+			lut_index = td->lut_max;
+		else
+			lut_index = i;
+
+		  val = regulator_list_hardware_vsel(td->vdd_reg,
+						     td->i2c_lut[lut_index]);
+		__raw_writel(val, td->lut_base + i * 4);
+	}
+
+	dfll_i2c_wmb(td);
+}
+
+/**
+ * dfll_init_i2c_if - set up the DFLL's DFLL-I2C interface
+ * @td: DFLL instance
+ *
+ * During DFLL driver initialization, program the DFLL-I2C interface
+ * with the PMU slave address, vdd register offset, and transfer mode.
+ * This data is used by the DFLL to automatically construct I2C
+ * voltage-set commands, which are then passed to the DFLL's internal
+ * I2C controller.
+ */
+static void dfll_init_i2c_if(struct tegra_dfll *td)
+{
+	u32 val;
+
+	if (td->i2c_slave_addr > 0x7f) {
+		val = td->i2c_slave_addr << DFLL_I2C_CFG_SLAVE_ADDR_SHIFT_10BIT;
+		val |= DFLL_I2C_CFG_SLAVE_ADDR_10;
+	} else {
+		val = td->i2c_slave_addr << DFLL_I2C_CFG_SLAVE_ADDR_SHIFT_7BIT;
+	}
+	val |= DFLL_I2C_CFG_SIZE_MASK;
+	val |= DFLL_I2C_CFG_ARB_ENABLE;
+	dfll_i2c_writel(td, val, DFLL_I2C_CFG);
+
+	dfll_i2c_writel(td, td->i2c_reg, DFLL_I2C_VDD_REG_ADDR);
+
+	val = DIV_ROUND_UP(td->i2c_clk_rate, td->i2c_fs_rate * 8);
+	BUG_ON(!val || (val > DFLL_I2C_CLK_DIVISOR_MASK));
+	val = (val - 1) << DFLL_I2C_CLK_DIVISOR_FS_SHIFT;
+
+	/* default hs divisor just in case */
+	val |= 1 << DFLL_I2C_CLK_DIVISOR_HS_SHIFT;
+	__raw_writel(val, td->i2c_controller_base + DFLL_I2C_CLK_DIVISOR);
+	dfll_i2c_wmb(td);
+}
+
+/**
+ * dfll_init_out_if - prepare DFLL-to-PMIC interface
+ * @td: DFLL instance
+ *
+ * During DFLL driver initialization or resume from context loss,
+ * disable the I2C command output to the PMIC, set safe voltage and
+ * output limits, and disable and clear limit interrupts.
+ */
+static void dfll_init_out_if(struct tegra_dfll *td)
+{
+	u32 val;
+
+	td->lut_min = 0;
+	td->lut_max = td->i2c_lut_size - 1;
+	td->lut_safe = td->lut_min + 1;
+
+	dfll_i2c_writel(td, 0, DFLL_OUTPUT_CFG);
+	val = (td->lut_safe << DFLL_OUTPUT_CFG_SAFE_SHIFT) |
+		(td->lut_max << DFLL_OUTPUT_CFG_MAX_SHIFT) |
+		(td->lut_min << DFLL_OUTPUT_CFG_MIN_SHIFT);
+	dfll_i2c_writel(td, val, DFLL_OUTPUT_CFG);
+	dfll_i2c_wmb(td);
+
+	dfll_writel(td, 0, DFLL_OUTPUT_FORCE);
+	dfll_i2c_writel(td, 0, DFLL_INTR_EN);
+	dfll_i2c_writel(td, DFLL_INTR_MAX_MASK | DFLL_INTR_MIN_MASK,
+			DFLL_INTR_STS);
+
+	dfll_load_i2c_lut(td);
+	dfll_init_i2c_if(td);
+}
+
+/*
+ * Set/get the DFLL's targeted output clock rate
+ */
+
+/**
+ * find_lut_index_for_rate - determine I2C LUT index for given DFLL rate
+ * @td: DFLL instance
+ * @rate: clock rate
+ *
+ * Determines the index of a I2C LUT entry for a voltage that approximately
+ * produces the given DFLL clock rate. This is used when forcing a value
+ * to the integrator during rate changes. Returns -ENOENT if a suitable
+ * LUT index is not found.
+ */
+static int find_lut_index_for_rate(struct tegra_dfll *td, unsigned long rate)
+{
+	struct dev_pm_opp *opp;
+	int i, uv;
+
+	opp = dev_pm_opp_find_freq_ceil(td->soc->opp_dev, &rate);
+	if (IS_ERR(opp))
+		return PTR_ERR(opp);
+	uv = dev_pm_opp_get_voltage(opp);
+
+	for (i = 0; i < td->i2c_lut_size; i++) {
+		if (regulator_list_voltage(td->vdd_reg, td->i2c_lut[i]) == uv)
+			return i;
+	}
+
+	return -ENOENT;
+}
+
+/**
+ * dfll_calculate_rate_request - calculate DFLL parameters for a given rate
+ * @td: DFLL instance
+ * @req: DFLL-rate-request structure
+ * @rate: the desired DFLL rate
+ *
+ * Populate the DFLL-rate-request record @req fields with the scale_bits
+ * and mult_bits fields, based on the target input rate. Returns 0 upon
+ * success, or -EINVAL if the requested rate in req->rate is too high
+ * or low for the DFLL to generate.
+ */
+static int dfll_calculate_rate_request(struct tegra_dfll *td,
+				       struct dfll_rate_req *req,
+				       unsigned long rate)
+{
+	u32 val;
+
+	/*
+	 * If requested rate is below the minimum DVCO rate, active the scaler.
+	 * In the future the DVCO minimum voltage should be selected based on
+	 * chip temperature and the actual minimum rate should be calibrated
+	 * at runtime.
+	 */
+	req->scale_bits = DFLL_FREQ_REQ_SCALE_MAX - 1;
+	if (rate < td->dvco_rate_min) {
+		int scale;
+
+		scale = DIV_ROUND_CLOSEST(rate / 1000 * DFLL_FREQ_REQ_SCALE_MAX,
+					  td->dvco_rate_min / 1000);
+		if (!scale) {
+			dev_err(td->dev, "%s: Rate %lu is too low\n",
+				__func__, rate);
+			return -EINVAL;
+		}
+		req->scale_bits = scale - 1;
+		rate = td->dvco_rate_min;
+	}
+
+	/* Convert requested rate into frequency request and scale settings */
+	val = DVCO_RATE_TO_MULT(rate, td->ref_rate);
+	if (val > FREQ_MAX) {
+		dev_err(td->dev, "%s: Rate %lu is above dfll range\n",
+			__func__, rate);
+		return -EINVAL;
+	}
+	req->mult_bits = val;
+	req->dvco_target_rate = MULT_TO_DVCO_RATE(req->mult_bits, td->ref_rate);
+	req->rate = dfll_scale_dvco_rate(req->scale_bits,
+					 req->dvco_target_rate);
+	req->lut_index = find_lut_index_for_rate(td, req->dvco_target_rate);
+	if (req->lut_index < 0)
+		return req->lut_index;
+
+	return 0;
+}
+
+/**
+ * dfll_set_frequency_request - start the frequency change operation
+ * @td: DFLL instance
+ * @req: rate request structure
+ *
+ * Tell the DFLL to try to change its output frequency to the
+ * frequency represented by @req. DFLL must be in closed-loop mode.
+ */
+static void dfll_set_frequency_request(struct tegra_dfll *td,
+				       struct dfll_rate_req *req)
+{
+	u32 val = 0;
+	int force_val;
+	int coef = 128; /* FIXME: td->cg_scale? */;
+
+	force_val = (req->lut_index - td->lut_safe) * coef / td->cg;
+	force_val = clamp(force_val, FORCE_MIN, FORCE_MAX);
+
+	val |= req->mult_bits << DFLL_FREQ_REQ_MULT_SHIFT;
+	val |= req->scale_bits << DFLL_FREQ_REQ_SCALE_SHIFT;
+	val |= ((u32)force_val << DFLL_FREQ_REQ_FORCE_SHIFT) &
+		DFLL_FREQ_REQ_FORCE_MASK;
+	val |= DFLL_FREQ_REQ_FREQ_VALID | DFLL_FREQ_REQ_FORCE_ENABLE;
+
+	dfll_writel(td, val, DFLL_FREQ_REQ);
+	dfll_wmb(td);
+}
+
+/**
+ * tegra_dfll_request_rate - set the next rate for the DFLL to tune to
+ * @td: DFLL instance
+ * @rate: clock rate to target
+ *
+ * Convert the requested clock rate @rate into the DFLL control logic
+ * settings. In closed-loop mode, update new settings immediately to
+ * adjust DFLL output rate accordingly. Otherwise, just save them
+ * until the next switch to closed loop. Returns 0 upon success,
+ * -EPERM if the DFLL driver has not yet been initialized, or -EINVAL
+ * if @rate is outside the DFLL's tunable range.
+ */
+static int dfll_request_rate(struct tegra_dfll *td, unsigned long rate)
+{
+	int ret;
+	struct dfll_rate_req req;
+
+	if (td->mode == DFLL_UNINITIALIZED) {
+		dev_err(td->dev, "%s: Cannot set DFLL rate in %s mode\n",
+			__func__, mode_name[td->mode]);
+		return -EPERM;
+	}
+
+	ret = dfll_calculate_rate_request(td, &req, rate);
+	if (ret)
+		return ret;
+
+	td->last_req = req;
+
+	if (td->mode == DFLL_CLOSED_LOOP)
+		dfll_set_frequency_request(td, &td->last_req);
+
+	return 0;
+}
+
+/*
  * DFLL enable/disable & open-loop <-> closed-loop transitions
  */
 
@@ -565,8 +880,76 @@ static void dfll_set_open_loop_config(struct tegra_dfll *td)
 	dfll_wmb(td);
 }
 
+/**
+ * tegra_dfll_lock - switch from open-loop to closed-loop mode
+ * @td: DFLL instance
+ *
+ * Switch from OPEN_LOOP state to CLOSED_LOOP state. Returns 0 upon success,
+ * -EINVAL if the DFLL's target rate hasn't been set yet, or -EPERM if the
+ * DFLL is not currently in open-loop mode.
+ */
+static int dfll_lock(struct tegra_dfll *td)
+{
+	struct dfll_rate_req *req = &td->last_req;
+
+	switch (td->mode) {
+	case DFLL_CLOSED_LOOP:
+		return 0;
+
+	case DFLL_OPEN_LOOP:
+		if (req->rate == 0) {
+			dev_err(td->dev, "%s: Cannot lock DFLL at rate 0\n",
+				__func__);
+			return -EINVAL;
+		}
+
+		dfll_i2c_set_output_enabled(td, true);
+		dfll_set_mode(td, DFLL_CLOSED_LOOP);
+		dfll_set_frequency_request(td, req);
+		return 0;
+
+	default:
+		BUG_ON(td->mode > DFLL_CLOSED_LOOP);
+		dev_err(td->dev, "%s: Cannot lock DFLL in %s mode\n",
+			__func__, mode_name[td->mode]);
+		return -EPERM;
+	}
+}
+
+/**
+ * tegra_dfll_unlock - switch from closed-loop to open-loop mode
+ * @td: DFLL instance
+ *
+ * Switch from CLOSED_LOOP state to OPEN_LOOP state. Returns 0 upon success,
+ * or -EPERM if the DFLL is not currently in open-loop mode.
+ */
+static int dfll_unlock(struct tegra_dfll *td)
+{
+	switch (td->mode) {
+	case DFLL_CLOSED_LOOP:
+		dfll_set_open_loop_config(td);
+		dfll_set_mode(td, DFLL_OPEN_LOOP);
+		dfll_i2c_set_output_enabled(td, false);
+		return 0;
+
+	case DFLL_OPEN_LOOP:
+		return 0;
+
+	default:
+		BUG_ON(td->mode > DFLL_CLOSED_LOOP);
+		dev_err(td->dev, "%s: Cannot unlock DFLL in %s mode\n",
+			__func__, mode_name[td->mode]);
+		return -EPERM;
+	}
+}
+
 /*
  * Clock framework integration
+ *
+ * When the DFLL is being controlled by the CCF, always enter closed loop
+ * mode when the clk is enabled. This requires that a DFLL rate request
+ * has been set beforehand, which implies that a clk_set_rate() call is
+ * always required before a clk_enable().
  */
 
 static int dfll_clk_is_enabled(struct clk_hw *hw)
@@ -579,21 +962,67 @@ static int dfll_clk_is_enabled(struct clk_hw *hw)
 static int dfll_clk_enable(struct clk_hw *hw)
 {
 	struct tegra_dfll *td = clk_hw_to_dfll(hw);
+	int ret;
+
+	ret = dfll_enable(td);
+	if (ret)
+		return ret;
 
-	return dfll_enable(td);
+	ret = dfll_lock(td);
+	if (ret)
+		dfll_disable(td);
+
+	return ret;
 }
 
 static void dfll_clk_disable(struct clk_hw *hw)
 {
 	struct tegra_dfll *td = clk_hw_to_dfll(hw);
+	int ret;
+
+	ret = dfll_unlock(td);
+	if (!ret)
+		dfll_disable(td);
+}
+
+static unsigned long dfll_clk_recalc_rate(struct clk_hw *hw,
+					  unsigned long parent_rate)
+{
+	struct tegra_dfll *td = clk_hw_to_dfll(hw);
+
+	return td->last_req.rate;
+}
+
+static long dfll_clk_round_rate(struct clk_hw *hw,
+				unsigned long rate,
+				unsigned long *parent_rate)
+{
+	struct tegra_dfll *td = clk_hw_to_dfll(hw);
+	struct dfll_rate_req req;
+	int ret;
+
+	ret = dfll_calculate_rate_request(td, &req, rate);
+	if (ret)
+		return ret;
+
+	return req.rate;
+}
+
+static int dfll_clk_set_rate(struct clk_hw *hw, unsigned long rate,
+			     unsigned long parent_rate)
+{
+	struct tegra_dfll *td = clk_hw_to_dfll(hw);
 
-	dfll_disable(td);
+	return dfll_request_rate(td, rate);
 }
 
 static const struct clk_ops dfll_clk_ops = {
 	.is_enabled	= dfll_clk_is_enabled,
 	.enable		= dfll_clk_enable,
 	.disable	= dfll_clk_disable,
+	.recalc_rate	= dfll_clk_recalc_rate,
+	.round_rate	= dfll_clk_round_rate,
+	.set_rate	= dfll_clk_set_rate,
 };
 
 static struct clk_init_data dfll_clk_init_data = {
@@ -675,6 +1104,23 @@ static int attr_enable_set(void *data, u64 val)
 DEFINE_SIMPLE_ATTRIBUTE(enable_fops, attr_enable_get, attr_enable_set,
 			"%llu\n");
 
+static int attr_lock_get(void *data, u64 *val)
+{
+	struct tegra_dfll *td = data;
+
+	*val = (td->mode == DFLL_CLOSED_LOOP);
+
+	return 0;
+}
+static int attr_lock_set(void *data, u64 val)
+{
+	struct tegra_dfll *td = data;
+
+	return val ? dfll_lock(td) :  dfll_unlock(td);
+}
+DEFINE_SIMPLE_ATTRIBUTE(lock_fops, attr_lock_get, attr_lock_set,
+			"%llu\n");
+
 static int attr_rate_get(void *data, u64 *val)
 {
 	struct tegra_dfll *td = data;
@@ -683,7 +1129,14 @@ static int attr_rate_get(void *data, u64 *val)
 
 	return 0;
 }
-DEFINE_SIMPLE_ATTRIBUTE(rate_fops, attr_rate_get, NULL, "%llu\n");
+
+static int attr_rate_set(void *data, u64 val)
+{
+	struct tegra_dfll *td = data;
+
+	return dfll_request_rate(td, val);
+}
+DEFINE_SIMPLE_ATTRIBUTE(rate_fops, attr_rate_get, attr_rate_set, "%llu\n");
 
 static int attr_registers_show(struct seq_file *s, void *data)
 {
@@ -749,6 +1202,10 @@ static int dfll_debug_init(struct tegra_dfll *td)
 				 td->debugfs_dir, td, &enable_fops))
 		goto err_out;
 
+	if (!debugfs_create_file("lock", S_IRUGO,
+				 td->debugfs_dir, td, &lock_fops))
+		goto err_out;
+
 	if (!debugfs_create_file("rate", S_IRUGO,
 				 td->debugfs_dir, td, &rate_fops))
 		goto err_out;
@@ -780,6 +1237,19 @@ err_out:
  */
 static void dfll_set_default_params(struct tegra_dfll *td)
 {
+	u32 val;
+
+	val = DIV_ROUND_UP(td->ref_rate, td->sample_rate * 32);
+	BUG_ON(val > DFLL_CONFIG_DIV_MASK);
+	dfll_writel(td, val, DFLL_CONFIG);
+
+	val = (td->force_mode << DFLL_PARAMS_FORCE_MODE_SHIFT) |
+		(td->cf << DFLL_PARAMS_CF_PARAM_SHIFT) |
+		(td->ci << DFLL_PARAMS_CI_PARAM_SHIFT) |
+		(td->cg << DFLL_PARAMS_CG_PARAM_SHIFT) |
+		(td->cg_scale ? DFLL_PARAMS_CG_SCALE : 0);
+	dfll_writel(td, val, DFLL_PARAMS);
+
 	dfll_tune_low(td);
 	dfll_writel(td, td->droop_ctrl, DFLL_DROOP_CTRL);
 	dfll_writel(td, DFLL_MONITOR_CTRL_FREQ, DFLL_MONITOR_CTRL);
@@ -869,6 +1339,8 @@ static int dfll_init(struct tegra_dfll *td)
 
 	dfll_set_open_loop_config(td);
 
+	dfll_init_out_if(td);
+
 	pm_runtime_put_sync(td->dev);
 
 	return 0;
@@ -888,6 +1360,130 @@ di_err1:
  * DT data fetch
  */
 
+/*
+ * Find a PMIC voltage register-to-voltage mapping for the given voltage.
+ * An exact voltage match is required.
+ */
+static int find_vdd_map_entry_exact(struct tegra_dfll *td, int uV)
+{
+	int i, n_voltages, reg_uV;
+
+	n_voltages = regulator_count_voltages(td->vdd_reg);
+	for (i = 0; i < n_voltages; i++) {
+		reg_uV = regulator_list_voltage(td->vdd_reg, i);
+		if (reg_uV < 0)
+			break;
+
+		if (uV == reg_uV)
+			return i;
+	}
+
+	dev_err(td->dev, "no voltage map entry for %d uV\n", uV);
+	return -EINVAL;
+}
+
+/*
+ * Find a PMIC voltage register-to-voltage mapping for the given voltage,
+ * rounding up to the closest supported voltage.
+ * */
+static int find_vdd_map_entry_min(struct tegra_dfll *td, int uV)
+{
+	int i, n_voltages, reg_uV;
+
+	n_voltages = regulator_count_voltages(td->vdd_reg);
+	for (i = 0; i < n_voltages; i++) {
+		reg_uV = regulator_list_voltage(td->vdd_reg, i);
+		if (reg_uV < 0)
+			break;
+
+		if (uV <= reg_uV)
+			return i;
+	}
+
+	dev_err(td->dev, "no voltage map entry rounding to %d uV\n", uV);
+	return -EINVAL;
+}
+
+/**
+ * dfll_build_i2c_lut - build the I2C voltage register lookup table
+ * @td: DFLL instance
+ *
+ * The DFLL hardware has 33 bytes of look-up table RAM that must be filled with
+ * PMIC voltage register values that span the entire DFLL operating range.
+ * This function builds the look-up table based on the OPP table provided by
+ * the soc-specific platform driver (td->soc->opp_dev) and the PMIC
+ * register-to-voltage mapping queried from the regulator framework.
+ *
+ * On success, fills in td->i2c_lut and returns 0, or -err on failure.
+ */
+static int dfll_build_i2c_lut(struct tegra_dfll *td)
+{
+	int ret = -EINVAL;
+	int j, v, v_max, v_opp;
+	int selector;
+	unsigned long rate;
+	struct dev_pm_opp *opp;
+
+	rcu_read_lock();
+
+	rate = ULONG_MAX;
+	opp = dev_pm_opp_find_freq_floor(td->soc->opp_dev, &rate);
+	if (IS_ERR(opp)) {
+		dev_err(td->dev, "couldn't get vmax opp, empty opp table?\n");
+		goto out;
+	}
+	v_max = dev_pm_opp_get_voltage(opp);
+
+	v = td->soc->min_millivolts * 1000;
+	td->i2c_lut[0] = find_vdd_map_entry_exact(td, v);
+	if (td->i2c_lut[0] < 0)
+		goto out;
+
+	for (j = 1, rate = 0; ; rate++) {
+		opp = dev_pm_opp_find_freq_ceil(td->soc->opp_dev, &rate);
+		if (IS_ERR(opp))
+			break;
+		v_opp = dev_pm_opp_get_voltage(opp);
+
+		if (v_opp <= td->soc->min_millivolts * 1000)
+			td->dvco_rate_min = dev_pm_opp_get_freq(opp);
+
+		for (;;) {
+			v += max(1, (v_max - v) / (MAX_DFLL_VOLTAGES - j));
+			if (v >= v_opp)
+				break;
+
+			selector = find_vdd_map_entry_min(td, v);
+			if (selector < 0)
+				goto out;
+			if (selector != td->i2c_lut[j - 1])
+				td->i2c_lut[j++] = selector;
+		}
+
+		v = (j == MAX_DFLL_VOLTAGES - 1) ? v_max : v_opp;
+		selector = find_vdd_map_entry_exact(td, v);
+		if (selector < 0)
+			goto out;
+		if (selector != td->i2c_lut[j - 1])
+			td->i2c_lut[j++] = selector;
+
+		if (v >= v_max)
+			break;
+	}
+	td->i2c_lut_size = j;
+
+	if (!td->dvco_rate_min)
+		dev_err(td->dev, "no opp above DFLL minimum voltage %d mV\n",
+			td->soc->min_millivolts);
+	else
+		ret = 0;
+
+out:
+	rcu_read_unlock();
+
+	return ret;
+}
+
 /**
  * read_dt_param - helper function for reading required parameters from the DT
  * @td: DFLL instance
@@ -912,6 +1508,50 @@ static bool read_dt_param(struct tegra_dfll *td, const char *param, u32 *dest)
 }
 
 /**
+ * dfll_fetch_i2c_params - query PMIC I2C params from DT & regulator subsystem
+ * @td: DFLL instance
+ *
+ * Read all the parameters required for operation in I2C mode. The parameters
+ * can originate from the device tree or the regulator subsystem.
+ * Returns 0 on success or -err on failure.
+ */
+static int dfll_fetch_i2c_params(struct tegra_dfll *td)
+{
+	struct regmap *regmap;
+	struct device *i2c_dev;
+	struct i2c_client *i2c_client;
+	int vsel_reg, vsel_mask;
+	int ret;
+
+	if (!read_dt_param(td, "nvidia,i2c-fs-rate", &td->i2c_fs_rate))
+		return -EINVAL;
+
+	regmap = regulator_get_regmap(td->vdd_reg);
+	i2c_dev = regmap_get_device(regmap);
+	i2c_client = to_i2c_client(i2c_dev);
+
+	td->i2c_slave_addr = i2c_client->addr;
+
+	ret = regulator_get_hardware_vsel_register(td->vdd_reg,
+						   &vsel_reg,
+						   &vsel_mask);
+	if (ret < 0) {
+		dev_err(td->dev,
+			"regulator unsuitable for DFLL I2C operation\n");
+		return -EINVAL;
+	}
+	td->i2c_reg = vsel_reg;
+
+	ret = dfll_build_i2c_lut(td);
+	if (ret) {
+		dev_err(td->dev, "couldn't build I2C LUT\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+/**
  * dfll_fetch_common_params - read DFLL parameters from the device tree
  * @td: DFLL instance
  *
@@ -923,6 +1563,13 @@ static int dfll_fetch_common_params(struct tegra_dfll *td)
 	bool ok = true;
 
 	ok &= read_dt_param(td, "nvidia,droop-ctrl", &td->droop_ctrl);
+	ok &= read_dt_param(td, "nvidia,sample-rate", &td->sample_rate);
+	ok &= read_dt_param(td, "nvidia,force-mode", &td->force_mode);
+	ok &= read_dt_param(td, "nvidia,cf", &td->cf);
+	ok &= read_dt_param(td, "nvidia,ci", &td->ci);
+	ok &= read_dt_param(td, "nvidia,cg", &td->cg);
+	td->cg_scale = of_property_read_bool(td->dev->of_node,
+					     "nvidia,cg-scale");
 
 	if (of_property_read_string(td->dev->of_node, "clock-output-names",
 				    &td->output_clock_name)) {
@@ -978,6 +1625,10 @@ int tegra_dfll_register(struct platform_device *pdev,
 		return ret;
 	}
 
+	ret = dfll_fetch_i2c_params(td);
+	if (ret)
+		return ret;
+
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!mem) {
 		dev_err(td->dev, "no control register resource\n");
-- 
2.1.0

