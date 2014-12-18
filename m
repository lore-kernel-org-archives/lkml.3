Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaLRRoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 12:44:19 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:61036 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaLRRoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 12:44:17 -0500
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
Subject: [PATCH v3] i2c: rk3x: Account for repeated start time requirement
Date: Thu, 18 Dec 2014 09:44:07 -0800
Message-Id: <1418924647-23795-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Rockchip I2C the controller drops SDA low slightly too soon to meet
the "repeated start" requirements.

>From my own experimentation over a number of rates:
 - controller appears to drop SDA at .875x (7/8) programmed clk high.
 - controller appears to keep SCL high for 2x programmed clk high.

The first rule isn't enough to meet tSU;STA requirements in
Standard-mode on the system I tested on.  The second rule is probably
enough to meet tHD;STA requirements in nearly all cases (especially
after accounting for the first), but it doesn't hurt to account for it
anyway just in case.

Even though the repeated start requirement only need to be accounted
for during a small part of the transfer, we'll adjust the timings for
the whole transfer to meet it.  I believe that adjusting the timings
in just the right place to switch things up for repeated start would
require several extra interrupts and that doesn't seem terribly worth
it.

With this change and worst case rise/fall times, I see 100kHz i2c
going to ~85kHz.  With slightly optimized rise/fall (800ns / 50ns) I
see i2c going to ~89kHz.  Fast-mode isn't affected much because
tSU;STA is shorter relative to tHD;STA there.

As part of this change we needed to account for the SDA falling time.
The specification indicates that this should be the same, but we'll
follow Designware's lead and add a binding.  Note that we deviate from
Designware and assign the default SDA falling time to be the same as
the SCL falling time, which is incredibly likely.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Note: This is based on Addy's patch (i2c: rk3x: fix bug that cause
measured high_ns doesn't meet I2C specification) that can be found at
<https://patchwork.kernel.org/patch/5475331/>.

Changes in v3:
- Totally changed code and tested myself; now actually works

Changes in v2:
- Also multiply SCL rise time by 2 for repeated start calculation

 Documentation/devicetree/bindings/i2c/i2c-rk3x.txt |  7 ++-
 drivers/i2c/busses/i2c-rk3x.c                      | 61 +++++++++++++++-------
 2 files changed, 48 insertions(+), 20 deletions(-)

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
index 36a9224..5f96b1b 100644
--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -102,8 +102,9 @@ struct rk3x_i2c {
 
 	/* Settings */
 	unsigned int scl_frequency;
-	unsigned int rise_ns;
-	unsigned int fall_ns;
+	unsigned int scl_rise_ns;
+	unsigned int scl_fall_ns;
+	unsigned int sda_fall_ns;
 
 	/* Synchronization & notification */
 	spinlock_t lock;
@@ -437,8 +438,9 @@ out:
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
  *
@@ -447,11 +449,13 @@ out:
  * too high, we silently use the highest possible rate.
  */
 static int rk3x_i2c_calc_divs(unsigned long clk_rate, unsigned long scl_rate,
-			      unsigned long rise_ns, unsigned long fall_ns,
+			      unsigned long scl_rise_ns,
+			      unsigned long scl_fall_ns,
+			      unsigned long sda_fall_ns,
 			      unsigned long *div_low, unsigned long *div_high)
 {
 	unsigned long spec_min_low_ns, spec_min_high_ns;
-	unsigned long spec_max_data_hold_ns;
+	unsigned long spec_setup_start, spec_max_data_hold_ns;
 	unsigned long data_hold_buffer_ns;
 
 	unsigned long min_low_ns, min_high_ns;
@@ -490,18 +494,35 @@ static int rk3x_i2c_calc_divs(unsigned long clk_rate, unsigned long scl_rate,
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
+	min_high_ns = scl_rise_ns + spec_min_high_ns;
+
+	/*
+	 * Timings for repeated start:
+	 * - controller appears to drop SDA at .875x (7/8) programmed clk high.
+	 * - controller appears to keep SCL high for 2x programmed clk high.
+	 *
+	 * We need to account for those rules in picking our "high" time so
+	 * we meet tSU;STA and tHD;STA times.
+	 */
+	min_high_ns = max(min_high_ns,
+		DIV_ROUND_UP((scl_rise_ns + spec_setup_start) * 1000, 875));
+	min_high_ns = max(min_high_ns,
+		DIV_ROUND_UP((scl_rise_ns + spec_setup_start +
+			      sda_fall_ns + spec_min_high_ns), 2));
+
+	min_low_ns = scl_fall_ns + spec_min_low_ns;
 	max_low_ns = spec_max_data_hold_ns * 2 - data_hold_buffer_ns;
 	min_total_ns = min_low_ns + min_high_ns;
 
@@ -599,9 +620,9 @@ static void rk3x_i2c_adapt_div(struct rk3x_i2c *i2c, unsigned long clk_rate)
 	u64 t_low_ns, t_high_ns;
 	int ret;
 
-	ret = rk3x_i2c_calc_divs(clk_rate, i2c->scl_frequency, i2c->rise_ns,
-				 i2c->fall_ns, &div_low, &div_high);
-
+	ret = rk3x_i2c_calc_divs(clk_rate, i2c->scl_frequency, i2c->scl_rise_ns,
+				 i2c->scl_fall_ns, i2c->sda_fall_ns,
+				 &div_low, &div_high);
 	WARN_ONCE(ret != 0, "Could not reach SCL freq %u", i2c->scl_frequency);
 
 	clk_enable(i2c->clk);
@@ -644,8 +665,9 @@ static int rk3x_i2c_clk_notifier_cb(struct notifier_block *nb, unsigned long
 	switch (event) {
 	case PRE_RATE_CHANGE:
 		if (rk3x_i2c_calc_divs(ndata->new_rate, i2c->scl_frequency,
-				       i2c->rise_ns, i2c->fall_ns, &div_low,
-				       &div_high) != 0)
+				       i2c->scl_rise_ns, i2c->scl_fall_ns,
+				       i2c->sda_fall_ns,
+				       &div_low, &div_high) != 0)
 			return NOTIFY_STOP;
 
 		/* scale up */
@@ -875,15 +897,18 @@ static int rk3x_i2c_probe(struct platform_device *pdev)
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

