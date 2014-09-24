Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbaIXB4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 21:56:17 -0400
Received: from regular1.263xmail.com ([211.150.99.134]:51288 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbaIXB4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 21:56:14 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: wsa@the-dreams.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <fec3743d4776d5a220a8126d5b6f0e83>
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
Subject: [PATCH] i2c: rk3x: adjust the LOW divison based on characteristics of SCL
Date: Wed, 24 Sep 2014 09:55:43 +0800
Message-Id: <1411523743-3444-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As show in I2C specification:
- Standard-mode:
  the minimum HIGH period of the scl clock is 4.0us
  the minimum LOW period of the scl clock is 4.7us
- Fast-mode:
  the minimum HIGH period of the scl clock is 0.6us
  the minimum LOW period of the scl clock is 1.3us
- Fast-mode plus:
  the minimum HIGH period of the scl clock is 0.26us
  the minimum LOW period of the scl clock is 0.5us
- HS-mode(<1.7MHz):
  the minimum HIGH period of the scl clock is 0.12us
  the minimum LOW period of the scl clock is 0.32us
- HS-mode(<3.4MHz):
  the minimum HIGH period of the scl clock is 0.06us
  the minimum LOW period of the scl clock is 0.16us

I have measured i2c SCL waveforms in fast-mode by oscilloscope
on rk3288-pinky board. the LOW period of the scl clock is 1.3us.
It is so critical that we must adjust LOW division to increase
the LOW period of the scl clock.

Thanks Doug for the suggestion about division formula.

Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
---
 drivers/i2c/busses/i2c-rk3x.c | 79 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 72 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
index 93cfc83..49d67b7 100644
--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -428,18 +428,83 @@ out:
 	return IRQ_HANDLED;
 }
 
+static void rk3x_i2c_get_ratios(unsigned long scl_rate,
+				unsigned long *high_ratio,
+				unsigned long *low_ratio)
+{
+	/* As show in I2C specification:
+	 * - Standard-mode:
+	 *   the minimum HIGH period of the scl clock is 4.0us
+	 *   the minimum LOW period of the scl clock is 4.7us
+	 * - Fast-mode:
+	 *   the minimum HIGH period of the scl clock is 0.6us
+	 *   the minimum LOW period of the scl clock is 1.3us
+	 * - Fast-mode plus:
+	 *   the minimum HIGH period of the scl clock is 0.26us
+	 *   the minimum LOW period of the scl clock is 0.5us
+	 * - HS-mode(<1.7MHz):
+	 *   the minimum HIGH period of the scl clock is 0.12us
+	 *   the minimum LOW period of the scl clock is 0.32us
+	 * - HS-mode(<3.4MHz):
+	 *   the minimum HIGH period of the scl clock is 0.06us
+	 *   the minimum LOW period of the scl clock is 0.16us
+	 */
+	if (scl_rate <= 100000) {
+		*high_ratio = 40;
+		*low_ratio = 47;
+	} else if (scl_rate <= 400000) {
+		*high_ratio = 6;
+		*low_ratio = 13;
+	} else if (scl_rate <= 1000000) {
+		*high_ratio = 26;
+		*low_ratio = 50;
+	} else if (scl_rate <= 1700000) {
+		*high_ratio = 12;
+		*low_ratio = 32;
+	} else {
+		*high_ratio = 6;
+		*low_ratio = 16;
+	}
+}
+
+static void rk3x_i2c_calc_divs(unsigned long i2c_rate, unsigned long scl_rate,
+			       unsigned long *divh, unsigned long *divl)
+{
+	unsigned long high_ratio, low_ratio;
+	unsigned long ratio_sum;
+
+	rk3x_i2c_get_ratios(scl_rate, &high_ratio, &low_ratio);
+	ratio_sum = high_ratio + low_ratio;
+
+	/* T_high = T_clk * (divh + 1) * 8
+	 * T_low = T_clk * (divl + 1) * 8
+	 * T_scl = T_high + T_low
+	 * T_scl = 1 / scl_rate
+	 * T_clk = 1 / i2c_rate
+	 * T_high : T_low = high_ratio : low_ratio
+	 * ratio_sum = high_ratio + low_ratio
+	 *
+	 * so:
+	 * divh = (i2c_rate * high_ratio) / (scl_rate * ratio_sum * 8) - 1
+	 * divl = (i2c_rate * low_ratio) / (scl_rate * ratio_sum * 8) - 1
+	 */
+	*divh = DIV_ROUND_UP(i2c_rate * high_ratio, scl_rate * ratio_sum * 8);
+	if (*divh)
+		*divh = *divh - 1;
+
+	*divl = DIV_ROUND_UP(i2c_rate * low_ratio, scl_rate * ratio_sum * 8);
+	if (*divl)
+		*divl = *divl - 1;
+}
+
 static void rk3x_i2c_set_scl_rate(struct rk3x_i2c *i2c, unsigned long scl_rate)
 {
 	unsigned long i2c_rate = clk_get_rate(i2c->clk);
-	unsigned int div;
+	unsigned long divh, divl;
 
-	/* set DIV = DIVH = DIVL
-	 * SCL rate = (clk rate) / (8 * (DIVH + 1 + DIVL + 1))
-	 *          = (clk rate) / (16 * (DIV + 1))
-	 */
-	div = DIV_ROUND_UP(i2c_rate, scl_rate * 16) - 1;
+	rk3x_i2c_calc_divs(i2c_rate, scl_rate, &divh, &divl);
 
-	i2c_writel(i2c, (div << 16) | (div & 0xffff), REG_CLKDIV);
+	i2c_writel(i2c, (divh << 16) | (divl & 0xffff), REG_CLKDIV);
 }
 
 /**
-- 
1.8.3.2


