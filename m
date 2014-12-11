Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933809AbaLKLFC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 06:05:02 -0500
Received: from regular1.263xmail.com ([211.150.99.131]:40713 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933770AbaLKLE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 06:04:58 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: wsa@the-dreams.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <312b3677b24b0c02300438182522a235>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Addy Ke <addy.ke@rock-chips.com>
To: wsa@the-dreams.de, max.schwarz@online.de, heiko@sntech.de, olof@lixom.net,
        dianders@chromium.org, robh+dt@kernel.org, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        u.kleine-koenig@pengutronix.de
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, cf@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, hj@rock-chips.com, kever.yang@rock-chips.com,
        hl@rock-chips.com, caesar.wang@rock-chips.com, zhengsq@rock-chips.com,
        Addy Ke <addy.ke@rock-chips.com>
Subject: [PATCH v5] i2c: rk3x: fix bug that cause measured high_ns doesn't meet I2C specification
Date: Thu, 11 Dec 2014 19:02:40 +0800
Message-Id: <1418295760-19639-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1418277650-25215-1-git-send-email-addy.ke@rock-chips.com>
References: <1418277650-25215-1-git-send-email-addy.ke@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of clock cycles to be written into the CLKDIV register
that determines the I2C clk high phase includes the rise time.
So to meet the timing requirements defined in the I2C specification
which defines the minimal time SCL has to be high, the rise time
has to taken into account. The same applies to the low phase with
falling time.

In my test on RK3288-Pink2 board, which is not an upstream board yet,
if external pull-up resistor is 4.7K, rise_ns is about 700ns.
So the measured high_ns is about 3900ns, which is less than 4000ns
(the minimum high_ns in I2C specification for Standard-mode).

To fix this bug min_low_ns should include fall time and min_high_ns
should include rise time.

This patch merged the patch from chromium project which can get the
rise and fall times for signals from the device tree. This allows us
to more accurately calculate timings. see:
https://chromium-review.googlesource.com/#/c/232774/

Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
---
Changes in v2:
- merged the patch that Doug submitted to chromium project
Changes in v3:
- merged the patch that Doug submitted to chromium to projectchange bindins
  see: https://chromium-review.googlesource.com/#/c/232774/
Changes in v4:
- Fix some typos pointed out by Uwe
- adjust "i2c" capitalization to "I2C"
Changes in v5:
- Fix some typos pointed out by Uwe in patch v4

 Documentation/devicetree/bindings/i2c/i2c-rk3x.txt | 11 ++++
 drivers/i2c/busses/i2c-rk3x.c                      | 72 +++++++++++++++-------
 2 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-rk3x.txt b/Documentation/devicetree/bindings/i2c/i2c-rk3x.txt
index dde6c22..1885bd8 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-rk3x.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-rk3x.txt
@@ -21,6 +21,14 @@ Required on RK3066, RK3188 :
 Optional properties :
 
  - clock-frequency : SCL frequency to use (in Hz). If omitted, 100kHz is used.
+ - i2c-scl-rising-time-ns : Number of nanoseconds the signal takes to rise
+	(t(r) in I2C specification). If not specified this is assumed to be
+	the maximum the specification allows(1000 ns for Standard-mode,
+	300 ns for Fast-mode) which might cause slightly slower communication.
+ - i2c-scl-falling-time-ns : Number of nanoseconds the signal takes to fall
+	(t(f) in the I2C specification). If not specified this is assumed to
+	be the maximum the specification allows (300 ns) which might cause
+	slightly slowercommunication.
 
 Example:
 
@@ -39,4 +47,7 @@ i2c0: i2c@2002d000 {
 
 	clock-names = "i2c";
 	clocks = <&cru PCLK_I2C0>;
+
+	i2c-scl-rising-time-ns = <800>;
+	i2c-scl-falling-time-ns = <100>;
 };
diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
index 0ee5802..6fe2bab 100644
--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -102,6 +102,8 @@ struct rk3x_i2c {
 
 	/* Settings */
 	unsigned int scl_frequency;
+	unsigned int rise_ns;
+	unsigned int fall_ns;
 
 	/* Synchronization & notification */
 	spinlock_t lock;
@@ -435,6 +437,8 @@ out:
  *
  * @clk_rate: I2C input clock rate
  * @scl_rate: Desired SCL rate
+ * @rise_ns: How many ns it takes for signals to rise.
+ * @fall_ns: How many ns it takes for signals to fall.
  * @div_low: Divider output for low
  * @div_high: Divider output for high
  *
@@ -443,11 +447,14 @@ out:
  * too high, we silently use the highest possible rate.
  */
 static int rk3x_i2c_calc_divs(unsigned long clk_rate, unsigned long scl_rate,
+			      unsigned long rise_ns, unsigned long fall_ns,
 			      unsigned long *div_low, unsigned long *div_high)
 {
-	unsigned long min_low_ns, min_high_ns;
-	unsigned long max_data_hold_ns;
+	unsigned long spec_min_low_ns, spec_min_high_ns;
+	unsigned long spec_max_data_hold_ns;
 	unsigned long data_hold_buffer_ns;
+
+	unsigned long min_low_ns, min_high_ns;
 	unsigned long max_low_ns, min_total_ns;
 
 	unsigned long clk_rate_khz, scl_rate_khz;
@@ -469,29 +476,33 @@ static int rk3x_i2c_calc_divs(unsigned long clk_rate, unsigned long scl_rate,
 		scl_rate = 1000;
 
 	/*
-	 * min_low_ns:  The minimum number of ns we need to hold low
-	 *		to meet i2c spec
-	 * min_high_ns: The minimum number of ns we need to hold high
-	 *		to meet i2c spec
-	 * max_low_ns:  The maximum number of ns we can hold low
-	 *		to meet i2c spec
+	 * min_low_ns:  The minimum number of ns we need to hold low to
+	 *		meet I2C specification, should include fall time.
+	 * min_high_ns: The minimum number of ns we need to hold high to
+	 *		meet I2C specification, should include rise time.
+	 * max_low_ns:  The maximum number of ns we can hold low to meet
+	 *		I2C specification.
 	 *
-	 * Note: max_low_ns should be (max data hold time * 2 - buffer)
+	 * Note: max_low_ns should be (maximum data hold time * 2 - buffer)
 	 *	 This is because the i2c host on Rockchip holds the data line
 	 *	 for half the low time.
 	 */
 	if (scl_rate <= 100000) {
-		min_low_ns = 4700;
-		min_high_ns = 4000;
-		max_data_hold_ns = 3450;
+		/* Standard-mode */
+		spec_min_low_ns = 4700;
+		spec_min_high_ns = 4000;
+		spec_max_data_hold_ns = 3450;
 		data_hold_buffer_ns = 50;
 	} else {
-		min_low_ns = 1300;
-		min_high_ns = 600;
-		max_data_hold_ns = 900;
+		/* Fast-mode */
+		spec_min_low_ns = 1300;
+		spec_min_high_ns = 600;
+		spec_max_data_hold_ns = 900;
 		data_hold_buffer_ns = 50;
 	}
-	max_low_ns = max_data_hold_ns * 2 - data_hold_buffer_ns;
+	min_low_ns = spec_min_low_ns + fall_ns;
+	min_high_ns = spec_min_high_ns + rise_ns;
+	max_low_ns = spec_max_data_hold_ns * 2 - data_hold_buffer_ns;
 	min_total_ns = min_low_ns + min_high_ns;
 
 	/* Adjust to avoid overflow */
@@ -510,8 +521,8 @@ static int rk3x_i2c_calc_divs(unsigned long clk_rate, unsigned long scl_rate,
 	min_div_for_hold = (min_low_div + min_high_div);
 
 	/*
-	 * This is the maximum divider so we don't go over the max.
-	 * We don't round up here (we round down) since this is a max.
+	 * This is the maximum divider so we don't go over the maximum.
+	 * We don't round up here (we round down) since this is a maximum.
 	 */
 	max_low_div = clk_rate_khz * max_low_ns / (8 * 1000000);
 
@@ -544,7 +555,7 @@ static int rk3x_i2c_calc_divs(unsigned long clk_rate, unsigned long scl_rate,
 		ideal_low_div = DIV_ROUND_UP(clk_rate_khz * min_low_ns,
 					     scl_rate_khz * 8 * min_total_ns);
 
-		/* Don't allow it to go over the max */
+		/* Don't allow it to go over the maximum */
 		if (ideal_low_div > max_low_div)
 			ideal_low_div = max_low_div;
 
@@ -588,8 +599,8 @@ static void rk3x_i2c_adapt_div(struct rk3x_i2c *i2c, unsigned long clk_rate)
 	u64 t_low_ns, t_high_ns;
 	int ret;
 
-	ret = rk3x_i2c_calc_divs(clk_rate, i2c->scl_frequency, &div_low,
-				 &div_high);
+	ret = rk3x_i2c_calc_divs(clk_rate, i2c->scl_frequency, i2c->rise_ns,
+				 i2c->fall_ns, &div_low, &div_high);
 
 	WARN_ONCE(ret != 0, "Could not reach SCL freq %u", i2c->scl_frequency);
 
@@ -633,9 +644,9 @@ static int rk3x_i2c_clk_notifier_cb(struct notifier_block *nb, unsigned long
 	switch (event) {
 	case PRE_RATE_CHANGE:
 		if (rk3x_i2c_calc_divs(ndata->new_rate, i2c->scl_frequency,
-				      &div_low, &div_high) != 0) {
+				       i2c->rise_ns, i2c->fall_ns, &div_low,
+				       &div_high) != 0)
 			return NOTIFY_STOP;
-		}
 
 		/* scale up */
 		if (ndata->new_rate > ndata->old_rate)
@@ -859,6 +870,21 @@ static int rk3x_i2c_probe(struct platform_device *pdev)
 		i2c->scl_frequency = DEFAULT_SCL_RATE;
 	}
 
+	/*
+	 * Read rise and fall time from device tree. If not available use
+	 * the default maximum timing from the specification.
+	 */
+	if (of_property_read_u32(pdev->dev.of_node, "i2c-scl-rising-time-ns",
+				 &i2c->rise_ns)) {
+		if (i2c->scl_frequency <= 100000)
+			i2c->rise_ns = 1000;
+		else
+			i2c->rise_ns = 300;
+	}
+	if (of_property_read_u32(pdev->dev.of_node, "i2c-scl-falling-time-ns",
+				 &i2c->fall_ns))
+		i2c->fall_ns = 300;
+
 	strlcpy(i2c->adap.name, "rk3x-i2c", sizeof(i2c->adap.name));
 	i2c->adap.owner = THIS_MODULE;
 	i2c->adap.algo = &rk3x_i2c_algorithm;
-- 
1.8.3.2


