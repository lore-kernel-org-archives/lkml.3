Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbaLKTS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:18:56 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:57133 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802AbaLKTSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:18:53 -0500
From: Doug Anderson <dianders@chromium.org>
To: wsa@the-dreams.de, max.schwarz@online.de
Cc: heiko@sntech.de, u.kleine-koenig@pengutronix.de, addy.ke@rock-chips.com,
        hl@rock-chips.com, cyw@rock-chips.com,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: [PATCH] i2c: rk3x: Account for repeated start time requirement
Date: Thu, 11 Dec 2014 11:18:31 -0800
Message-Id: <1418325511-16648-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Rockchip I2C the controller drops SDA low in the repeated start
condition at half the SCL high time.

If we want to meet timing requirements, that means we need to hold SCL
high for (4.7us * 2) when we're sending a repeated start (.6us * 2 for
Fast-mode).  That lets us achieve minimum tSU;STA.  However, we don't
want to always hold SCL high for that long because we'd never be able
to make 100kHz or 400kHz speeds.

Let's fix this by doing our clock calculations twice: once taking the
above into account and once running at normal speeds.  We'll use the
slower speed when sending the start bit and the normal speed
otherwise.

Note: we really only need the conservative timing when sending
_repeated_ starts, not when sending the first start.  We don't account
for this so technically the first start bit will be longer too.
...well, except in the case when we use the combined write/read
optimization which doesn't use the same code.

As part of this change we needed to account for the SDA falling time.
The specification indicates that this should be the same, but we'll
follow Designware and add a binding.  Note that we deviate from
Designware and assign the default SDA falling time to be the same as
the SCL falling time, which is incredibly likely.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Note: This is based on Addy's patch (i2c: rk3x: fix bug that cause
measured high_ns doesn't meet I2C specification) that can be found at
<https://patchwork.kernel.org/patch/5475331/>.

 Documentation/devicetree/bindings/i2c/i2c-rk3x.txt |  7 +-
 drivers/i2c/busses/i2c-rk3x.c                      | 90 +++++++++++++++++-----
 2 files changed, 74 insertions(+), 23 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-rk3x.txt b/Documentation/devicetree/bindings/i2c/i2c-rk3x.txt
index 1885bd8..8cc75d9 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-rk3x.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-rk3x.txt
@@ -21,14 +21,17 @@ Required on RK3066, RK3188 :
 Optional properties :
 
  - clock-frequency : SCL frequency to use (in Hz). If omitted, 100kHz is used.
- - i2c-scl-rising-time-ns : Number of nanoseconds the signal takes to rise
+ - i2c-scl-rising-time-ns : Number of nanoseconds the SCL signal takes to rise
 	(t(r) in I2C specification). If not specified this is assumed to be
 	the maximum the specification allows(1000 ns for Standard-mode,
 	300 ns for Fast-mode) which might cause slightly slower communication.
- - i2c-scl-falling-time-ns : Number of nanoseconds the signal takes to fall
+ - i2c-scl-falling-time-ns : Number of nanoseconds the SCL signal takes to fall
 	(t(f) in the I2C specification). If not specified this is assumed to
 	be the maximum the specification allows (300 ns) which might cause
 	slightly slowercommunication.
+ - i2c-sda-falling-time-ns : Number of nanoseconds the SDA signal takes to fall
+	(t(f) in the I2C specification). If not specified we'll use the SCL
+	value since they are the same in nearly all cases.
 
 Example:
 
diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
index 36a9224..1f994df 100644
--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -102,8 +102,14 @@ struct rk3x_i2c {
 
 	/* Settings */
 	unsigned int scl_frequency;
-	unsigned int rise_ns;
-	unsigned int fall_ns;
+	unsigned int scl_rise_ns;
+	unsigned int scl_fall_ns;
+	unsigned int sda_fall_ns;
+
+	/* DIV changes when we're sending a repeated start; keep both */
+	bool sending_start;
+	u32 div_normal;
+	u32 div_start;
 
 	/* Synchronization & notification */
 	spinlock_t lock;
@@ -146,6 +152,9 @@ static void rk3x_i2c_start(struct rk3x_i2c *i2c)
 {
 	u32 val;
 
+	i2c->sending_start = true;
+	i2c_writel(i2c, i2c->div_start, REG_CLKDIV);
+
 	rk3x_i2c_clean_ipd(i2c);
 	i2c_writel(i2c, REG_INT_START, REG_IEN);
 
@@ -281,6 +290,9 @@ static void rk3x_i2c_handle_start(struct rk3x_i2c *i2c, unsigned int ipd)
 	/* disable start bit */
 	i2c_writel(i2c, i2c_readl(i2c, REG_CON) & ~REG_CON_START, REG_CON);
 
+	i2c->sending_start = false;
+	i2c_writel(i2c, i2c->div_normal, REG_CLKDIV);
+
 	/* enable appropriate interrupts and transition */
 	if (i2c->mode == REG_CON_MOD_TX) {
 		i2c_writel(i2c, REG_INT_MBTF | REG_INT_NAKRCV, REG_IEN);
@@ -437,21 +449,26 @@ out:
  *
  * @clk_rate: I2C input clock rate
  * @scl_rate: Desired SCL rate
- * @rise_ns: How many ns it takes for signals to rise.
- * @fall_ns: How many ns it takes for signals to fall.
+ * @scl_rise_ns: How many ns it takes for SCL to rise.
+ * @scl_fall_ns: How many ns it takes for SCL to fall.
+ * @sda_fall_ns: How many ns it takes for SDA to fall.
  * @div_low: Divider output for low
  * @div_high: Divider output for high
+ * @for_start: Take into account that we might be sending a start bit.
  *
  * Returns: 0 on success, -EINVAL if the goal SCL rate is too slow. In that case
  * a best-effort divider value is returned in divs. If the target rate is
  * too high, we silently use the highest possible rate.
  */
 static int rk3x_i2c_calc_divs(unsigned long clk_rate, unsigned long scl_rate,
-			      unsigned long rise_ns, unsigned long fall_ns,
-			      unsigned long *div_low, unsigned long *div_high)
+			      unsigned long scl_rise_ns,
+			      unsigned long scl_fall_ns,
+			      unsigned long sda_fall_ns,
+			      unsigned long *div_low, unsigned long *div_high,
+			      bool for_start)
 {
 	unsigned long spec_min_low_ns, spec_min_high_ns;
-	unsigned long spec_max_data_hold_ns;
+	unsigned long spec_setup_start, spec_max_data_hold_ns;
 	unsigned long data_hold_buffer_ns;
 
 	unsigned long min_low_ns, min_high_ns;
@@ -490,18 +507,32 @@ static int rk3x_i2c_calc_divs(unsigned long clk_rate, unsigned long scl_rate,
 	if (scl_rate <= 100000) {
 		/* Standard-mode */
 		spec_min_low_ns = 4700;
+		spec_setup_start = 4700;
 		spec_min_high_ns = 4000;
 		spec_max_data_hold_ns = 3450;
 		data_hold_buffer_ns = 50;
 	} else {
 		/* Fast-mode */
 		spec_min_low_ns = 1300;
+		spec_setup_start = 600;
 		spec_min_high_ns = 600;
 		spec_max_data_hold_ns = 900;
 		data_hold_buffer_ns = 50;
 	}
-	min_low_ns = spec_min_low_ns + fall_ns;
-	min_high_ns = spec_min_high_ns + rise_ns;
+	/*
+	 * For repeated start we need at least (spec_setup_start * 2) to meet
+	 * (tSU;SDA) requirements. The controller drops data low at half the
+	 * high time). Also need to meet normal specification requirements.
+	 */
+	if (for_start)
+		min_high_ns = max(spec_setup_start * 2,
+				  spec_setup_start + sda_fall_ns +
+				  spec_min_high_ns);
+	else
+		min_high_ns = spec_min_high_ns;
+	min_high_ns += scl_rise_ns;
+
+	min_low_ns = spec_min_low_ns + scl_fall_ns;
 	max_low_ns = spec_max_data_hold_ns * 2 - data_hold_buffer_ns;
 	min_total_ns = min_low_ns + min_high_ns;
 
@@ -597,15 +628,28 @@ static void rk3x_i2c_adapt_div(struct rk3x_i2c *i2c, unsigned long clk_rate)
 {
 	unsigned long div_low, div_high;
 	u64 t_low_ns, t_high_ns;
+	unsigned long flags;
 	int ret;
 
-	ret = rk3x_i2c_calc_divs(clk_rate, i2c->scl_frequency, i2c->rise_ns,
-				 i2c->fall_ns, &div_low, &div_high);
+	ret = rk3x_i2c_calc_divs(clk_rate, i2c->scl_frequency, i2c->scl_rise_ns,
+				 i2c->scl_fall_ns, i2c->sda_fall_ns,
+				 &div_low, &div_high, true);
+	i2c->div_start = (div_high << 16) | (div_low & 0xffff);
+	WARN_ONCE(ret != 0, "Could not reach SCL freq %u", i2c->scl_frequency);
 
+	ret = rk3x_i2c_calc_divs(clk_rate, i2c->scl_frequency, i2c->scl_rise_ns,
+				 i2c->scl_fall_ns, i2c->sda_fall_ns,
+				 &div_low, &div_high, false);
+	i2c->div_normal = (div_high << 16) | (div_low & 0xffff);
 	WARN_ONCE(ret != 0, "Could not reach SCL freq %u", i2c->scl_frequency);
 
 	clk_enable(i2c->clk);
-	i2c_writel(i2c, (div_high << 16) | (div_low & 0xffff), REG_CLKDIV);
+	spin_lock_irqsave(&i2c->lock, flags);
+	if (i2c->sending_start)
+		i2c_writel(i2c, i2c->div_start, REG_CLKDIV);
+	else
+		i2c_writel(i2c, i2c->div_normal, REG_CLKDIV);
+	spin_unlock_irqrestore(&i2c->lock, flags);
 	clk_disable(i2c->clk);
 
 	t_low_ns = div_u64(((u64)div_low + 1) * 8 * 1000000000, clk_rate);
@@ -644,8 +688,9 @@ static int rk3x_i2c_clk_notifier_cb(struct notifier_block *nb, unsigned long
 	switch (event) {
 	case PRE_RATE_CHANGE:
 		if (rk3x_i2c_calc_divs(ndata->new_rate, i2c->scl_frequency,
-				       i2c->rise_ns, i2c->fall_ns, &div_low,
-				       &div_high) != 0)
+				       i2c->scl_rise_ns, i2c->scl_fall_ns,
+				       i2c->sda_fall_ns,
+				       &div_low, &div_high, true) != 0)
 			return NOTIFY_STOP;
 
 		/* scale up */
@@ -779,10 +824,10 @@ static int rk3x_i2c_xfer(struct i2c_adapter *adap,
 		if (i + ret >= num)
 			i2c->is_last_msg = true;
 
-		spin_unlock_irqrestore(&i2c->lock, flags);
-
 		rk3x_i2c_start(i2c);
 
+		spin_unlock_irqrestore(&i2c->lock, flags);
+
 		timeout = wait_event_timeout(i2c->wait, !i2c->busy,
 					     msecs_to_jiffies(WAIT_TIMEOUT));
 
@@ -875,15 +920,18 @@ static int rk3x_i2c_probe(struct platform_device *pdev)
 	 * the default maximum timing from the specification.
 	 */
 	if (of_property_read_u32(pdev->dev.of_node, "i2c-scl-rising-time-ns",
-				 &i2c->rise_ns)) {
+				 &i2c->scl_rise_ns)) {
 		if (i2c->scl_frequency <= 100000)
-			i2c->rise_ns = 1000;
+			i2c->scl_rise_ns = 1000;
 		else
-			i2c->rise_ns = 300;
+			i2c->scl_rise_ns = 300;
 	}
 	if (of_property_read_u32(pdev->dev.of_node, "i2c-scl-falling-time-ns",
-				 &i2c->fall_ns))
-		i2c->fall_ns = 300;
+				 &i2c->scl_fall_ns))
+		i2c->scl_fall_ns = 300;
+	if (of_property_read_u32(pdev->dev.of_node, "i2c-sda-falling-time-ns",
+				 &i2c->scl_fall_ns))
+		i2c->sda_fall_ns = i2c->scl_fall_ns;
 
 	strlcpy(i2c->adap.name, "rk3x-i2c", sizeof(i2c->adap.name));
 	i2c->adap.owner = THIS_MODULE;
-- 
2.2.0.rc0.207.ga3a616c

