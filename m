Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbaJHDuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 23:50:40 -0400
Received: from regular1.263xmail.com ([211.150.99.139]:34580 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaJHDui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 23:50:38 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: wsa@the-dreams.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <0b131071dfc72cf5c3f289569e515fe5>
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
        Addy Ke <addy.ke@rock-chips.com>
Subject: [PATCH v3] i2c: rk3x: adjust the LOW divison based on characteristics of SCL
Date: Wed,  8 Oct 2014 11:50:11 +0800
Message-Id: <1412740211-3345-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As show in I2C specification:
- Standard-mode: the minimum HIGH period of the scl clock is 4.0us
                 the minimum LOW period of the scl clock is 4.7us
- Fast-mode: the minimum HIGH period of the scl clock is 0.6us
             the minimum LOW period of the scl clock is 1.3us

I have measured i2c SCL waveforms in fast-mode by oscilloscope
on rk3288-pinky board. the LOW period of the scl clock is 1.3us.
It is so critical that we must adjust LOW division to increase
the LOW period of the scl clock.

Thanks Doug for the suggestion about division formulas.

Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
---
Changes in v2:
- remove Fast-mode plus and HS-mode
- use new formulas suggested by Doug
Changes in V3:
- use new formulas (sep 30) suggested by Doug

 drivers/i2c/busses/i2c-rk3x.c | 135 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 128 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
index b41d979..9612eba 100644
--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -24,6 +24,7 @@
 #include <linux/wait.h>
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
+#include <linux/math64.h>
 
 
 /* Register Map */
@@ -428,18 +429,138 @@ out:
 	return IRQ_HANDLED;
 }
 
+static void rk3x_i2c_calc_divs(unsigned long i2c_rate, unsigned long scl_rate,
+			       unsigned long *div_low, unsigned long *div_high)
+{
+	unsigned long min_low_ns, min_high_ns;
+	unsigned long max_data_hold_ns;
+	unsigned long data_hold_buffer_ns;
+	unsigned long max_low_ns, min_total_ns;
+
+	unsigned long i2c_rate_khz, scl_rate_khz;
+
+	unsigned long min_low_div, min_high_div;
+	unsigned long max_low_div;
+
+	unsigned long min_div_for_hold, min_total_div;
+	unsigned long extra_div, extra_low_div, ideal_low_div;
+
+	/* Only support standard-mode and fast-mode */
+	WARN_ON(scl_rate > 400000);
+
+	/*
+	 * min_low_ns:  The minimum number of ns we need to hold low
+	 *		to meet i2c spec
+	 * min_high_ns: The minimum number of ns we need to hold high
+	 *		to meet i2c spec
+	 * max_low_ns:  The maximum number of ns we can hold low
+	 *		to meet i2c spec
+	 *
+	 * Note: max_low_ns should be (max data hold time * 2 - buffer)
+	 *	 This is because the i2c host on Rockchip holds the data line
+	 *	 for half the low time.
+	 */
+	if (scl_rate <= 100000) {
+		min_low_ns = 4700;
+		min_high_ns = 4000;
+		max_data_hold_ns = 3450;
+		data_hold_buffer_ns = 50;
+	} else {
+		min_low_ns = 1300;
+		min_high_ns = 600;
+		max_data_hold_ns = 900;
+		data_hold_buffer_ns = 50;
+	}
+	max_low_ns = max_data_hold_ns * 2 - data_hold_buffer_ns;
+	min_total_ns = min_low_ns + min_high_ns;
+
+	/* Adjust to avoid overflow */
+	i2c_rate_khz = DIV_ROUND_UP(i2c_rate, 1000);
+	scl_rate_khz = DIV_ROUND_UP(scl_rate, 1000);
+
+	/*
+	 * We need the total div to be >= this number
+	 * so we don't clock too fast.
+	 */
+	min_total_div = DIV_ROUND_UP(i2c_rate_khz, scl_rate_khz * 8);
+
+	/* These are the min dividers needed for min hold times.*/
+	min_low_div = DIV_ROUND_UP(i2c_rate_khz * min_low_ns, 8 * 1000000);
+	min_high_div = DIV_ROUND_UP(i2c_rate_khz * min_high_ns, 8 * 1000000);
+	min_div_for_hold = (min_low_div + min_high_div);
+
+	/*
+	 * This is the maximum divider so we don't go over the max.
+	 * We don't round up here (we round down) since this is a max.
+	 */
+	max_low_div = i2c_rate_khz * max_low_ns / (8 * 1000000);
+
+	if (min_low_div > max_low_div)
+		max_low_div = min_low_div;
+
+	if (min_div_for_hold > min_total_div) {
+		/*
+		 * Time needed to meet hold requirements is important.
+		 * Just use that.
+		 */
+		*div_low = min_low_div;
+		*div_high = min_high_div;
+	} else {
+		/*
+		 * We've got to distribute some time among the low and high
+		 * so we don't run too fast.
+		 */
+		extra_div = min_total_div - min_div_for_hold;
+		/*
+		 * We'll try to split things up perfectly evenly,
+		 * biasing slightly towards having a higher div
+		 * for low (spend more time low).
+		 */
+
+		ideal_low_div = DIV_ROUND_UP(i2c_rate_khz * min_low_ns,
+					     scl_rate_khz * 8 * min_total_ns);
+
+		/* Don't allow it to go over the max */
+		if (ideal_low_div > max_low_div)
+			ideal_low_div = max_low_div;
+
+		/* Handle when the ideal low div is going to take up
+		 * more than we have.
+		 */
+		if (ideal_low_div > min_low_div + extra_div)
+			ideal_low_div = min_low_div + extra_div;
+
+		/* Give low the "ideal" and give high whatever extra is left */
+		extra_low_div = ideal_low_div - min_low_div;
+		*div_low = ideal_low_div;
+		*div_high = min_high_div + (extra_div - extra_low_div);
+	}
+
+	/*
+	* Adjust to the fact that the hardware has an implicit "+1".
+	* NOTE: Above calculations always produce div_low > 0 and  div_high > 0.
+	*/
+	*div_low = *div_low - 1;
+	*div_high = *div_high - 1;
+}
+
 static void rk3x_i2c_set_scl_rate(struct rk3x_i2c *i2c, unsigned long scl_rate)
 {
 	unsigned long i2c_rate = clk_get_rate(i2c->clk);
-	unsigned int div;
+	unsigned long div_low, div_high;
+	u64 t_low_ns, t_high_ns;
 
-	/* set DIV = DIVH = DIVL
-	 * SCL rate = (clk rate) / (8 * (DIVH + 1 + DIVL + 1))
-	 *          = (clk rate) / (16 * (DIV + 1))
-	 */
-	div = DIV_ROUND_UP(i2c_rate, scl_rate * 16) - 1;
+	rk3x_i2c_calc_divs(i2c_rate, scl_rate, &div_low, &div_high);
+
+	i2c_writel(i2c, (div_high << 16) | (div_low & 0xffff), REG_CLKDIV);
 
-	i2c_writel(i2c, (div << 16) | (div & 0xffff), REG_CLKDIV);
+	t_low_ns = div_u64(((u64)div_low + 1) * 8 * 1000000000, i2c_rate);
+	t_high_ns = div_u64(((u64)div_high + 1) * 8 * 1000000000, i2c_rate);
+	dev_dbg(i2c->dev,
+		"CLK %lukhz, Req %luns, Act low %lluns high %lluns\n",
+		i2c_rate / 1000,
+		1000000000 / scl_rate,
+		t_low_ns, t_high_ns);
 }
 
 /**
-- 
1.8.3.2


