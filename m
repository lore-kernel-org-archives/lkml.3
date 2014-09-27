Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbaI0HL4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 03:11:56 -0400
Received: from regular1.263xmail.com ([211.150.99.131]:39158 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaI0HLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 03:11:54 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: wsa@the-dreams.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <403e4710341bb600c92f00f61fe06e4c>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Addy Ke <addy.ke@rock-chips.com>
To: wsa@the-dreams.de, max.schwarz@online.de, heiko@sntech.de, olof@lixom.net,
        dianders@chromium.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, cf@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, hj@rock-chips.com, kever.yang@rock-chips.com,
        hl@rock-chips.com, caesar.wang@rock-chips.com, zhengsq@rock-chips.com,
        Addy <addy.ke@rock-chips.com>
Subject: [PATCH v2] i2c: rk3x: adjust the LOW divison based on characteristics of SCL
Date: Sat, 27 Sep 2014 15:11:28 +0800
Message-Id: <1411801888-3152-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Addy <addy.ke@rock-chips.com>

As show in I2C specification:
- Standard-mode: the minimum HIGH period of the scl clock is 4.0us
                 the minimum LOW period of the scl clock is 4.7us
- Fast-mode: the minimum HIGH period of the scl clock is 0.6us
             the minimum LOW period of the scl clock is 1.3us

I have measured i2c SCL waveforms in fast-mode by oscilloscope
on rk3288-pinky board. the LOW period of the scl clock is 1.3us.
It is so critical that we must adjust LOW division to increase
the LOW period of the scl clock.

After put this patch, we can find that min_low_ns is about
5.4us in Standard-mode and 1.6us in Fast-mode.

Thanks Doug for the suggestion about division formulas.

Signed-off-by: Addy <addy.ke@rock-chips.com>
---
Changes in v2:
- remove Fast-mode plus and HS-mode
- use new formulas suggested by Doug

 drivers/i2c/busses/i2c-rk3x.c | 104 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 97 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
index e637c32..81672a8 100644
--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -428,19 +428,109 @@ out:
 	return IRQ_HANDLED;
 }
 
+static void rk3x_i2c_get_min_ns(unsigned int scl_rate,
+				unsigned long *min_low_ns,
+				unsigned long *min_high_ns)
+{
+	WARN_ON(scl_rate > 400000);
+
+	/* As show in I2C specification:
+	 * - Standard-mode(100KHz):
+	 *   min_low_ns is 4700ns
+	 *   min_high_ns is 4000ns
+	 * - Fast-mode(400KHz):
+	 *   min_low_ns is 1300ns
+	 *   min_high_ns is 600ns
+	 *
+	 * (min_low_ns + min_high_ns) up to 10000ns in Standard-mode
+	 * and 2500ns in Fast-mode
+	 */
+	if (scl_rate <= 100000) {
+		*min_low_ns = 4700 + 650;
+		*min_high_ns = 4000 + 650;
+	} else {
+		*min_low_ns = 1300 + 300;
+		*min_high_ns = 600 + 300;
+	}
+}
+
+static void rk3x_i2c_calc_divs(unsigned long i2c_rate, unsigned long scl_rate,
+			       unsigned long *div_low, unsigned long *div_high)
+{
+	unsigned long min_low_ns, min_high_ns, min_total_ns;
+	unsigned long min_low_div, min_high_div;
+	unsigned long min_total_div, min_div_for_hold;
+	unsigned long extra_div, extra_low_div, ideal_low_div;
+	unsigned long i2c_rate_khz, scl_rate_khz;
+
+	rk3x_i2c_get_min_ns(scl_rate, &min_low_ns, &min_high_ns);
+	min_total_ns = min_low_ns + min_high_ns;
+
+	/* To avoid from overflow warning */
+	i2c_rate_khz = i2c_rate / 1000;
+	scl_rate_khz = scl_rate / 1000;
+
+	/*We need the total div to be >= this number
+	 * so we don't clock too fast.
+	 */
+	min_total_div = DIV_ROUND_UP(i2c_rate_khz, scl_rate_khz * 8);
+
+	/* These are the min dividers needed for hold times */
+	min_low_div = DIV_ROUND_UP(i2c_rate_khz * min_low_ns, 8 * 1000000);
+	min_high_div = DIV_ROUND_UP(i2c_rate_khz * min_high_ns, 8 * 1000000);
+	min_div_for_hold = (min_low_div + min_high_div);
+
+	if (min_div_for_hold > min_total_div) {
+		/* Time needed to meet hold requirements is important.
+		 * Just use that
+		 * */
+		*div_low = min_low_div;
+		*div_high = min_high_div;
+	} else {
+		/* We've got to distribute some time among the low and high
+		 * so we don't run too fast.
+		 */
+		extra_div = min_total_div - min_div_for_hold;
+		/* We'll try to split things up perfectly evenly,
+		 * biasing slightly towards having a higher div
+		 * for low (spend more time low).
+		 */
+		ideal_low_div = DIV_ROUND_UP(i2c_rate_khz * min_low_ns,
+					     scl_rate_khz * 8 * min_total_ns);
+		/* Handle when the ideal low div is going to take up
+		 * more than we have.
+		 */
+		if (ideal_low_div > min_low_div + extra_div)
+			ideal_low_div = min_low_div + extra_div;
+		/* Give low the "ideal" and give high whatever extra is left.*/
+		extra_low_div = ideal_low_div - min_low_div;
+		*div_low = ideal_low_div;
+		*div_high
+			= min_high_div + (extra_div - extra_low_div);
+	}
+
+	/* Adjust to the fact that the hardware has an implicit "+1".*/
+	*div_low = *div_low - 1;
+	*div_high = *div_high - 1;
+}
+
 static void rk3x_i2c_set_scl_rate(struct rk3x_i2c *i2c, unsigned long scl_rate)
 {
 	unsigned long i2c_rate = clk_get_rate(i2c->clk);
-	unsigned int div;
+	unsigned long div_low, div_high;
 
-	/* SCL rate = (clk rate) / (8 * DIV) */
-	div = DIV_ROUND_UP(i2c_rate, scl_rate * 8);
+	/* The formulas in rk3x TRM:
+	 * - T_scl_high = T_clk * (divh + 1) * 8
+	 * - T_scl_low = T_clk * (divl + 1) * 8
+	 * */
+	rk3x_i2c_calc_divs(i2c_rate, scl_rate, &div_low, &div_high);
 
-	/* The lower and upper half of the CLKDIV reg describe the length of
-	 * SCL low & high periods. */
-	div = DIV_ROUND_UP(div, 2);
+	i2c_writel(i2c, (div_high << 16) | (div_low & 0xffff), REG_CLKDIV);
 
-	i2c_writel(i2c, (div << 16) | (div & 0xffff), REG_CLKDIV);
+	dev_dbg(i2c->dev, "scl_ns: %luns, scl_low_ns: %luns, scl_high_ns: %luns\n",
+		1000000000/scl_rate,
+		(1000000000 / i2c_rate) * (div_low + 1) * 8,
+		(1000000000 / i2c_rate) * (div_high + 1) * 8);
 }
 
 /**
-- 
1.8.3.2


