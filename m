Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaKFIMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:12:24 -0500
Received: from regular1.263xmail.com ([211.150.99.131]:45965 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaKFIMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:12:22 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: wsa@the-dreams.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <70dad6a6034f865c668b382ca3029277>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
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
Subject: [PATCH] i2c: rk3x: fix bug that cause measured high_ns doesn't meet I2C spec
Date: Thu,  6 Nov 2014 16:11:54 +0800
Message-Id: <1415261514-4051-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

high_ns calculated from the low division of CLKDIV register is the sum of
actual measured high_ns and rise_ns. The rise time which related to
external pull-up resistor can be up to the maximum rise time in I2C spec.

In my test, if external pull-up resistor is 4.7K, rise_ns is about 700ns.
So the actual measured high_ns is about 3900ns, which is less than 4000ns
(the minimum high_ns in I2C spec).

Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
---
 drivers/i2c/busses/i2c-rk3x.c | 58 +++++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 21 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
index e276ffb..8e1cc2b 100644
--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -432,9 +432,12 @@ out:
 static int rk3x_i2c_calc_divs(unsigned long i2c_rate, unsigned long scl_rate,
 			       unsigned long *div_low, unsigned long *div_high)
 {
+	unsigned long spec_min_low_ns, spec_min_high_ns;
+	unsigned long spec_max_data_hold_ns;
+	unsigned long spec_data_hold_buffer_ns;
+	unsigned long spec_max_rise_ns;
+
 	unsigned long min_low_ns, min_high_ns;
-	unsigned long max_data_hold_ns;
-	unsigned long data_hold_buffer_ns;
 	unsigned long max_low_ns, min_total_ns;
 
 	unsigned long i2c_rate_khz, scl_rate_khz;
@@ -453,30 +456,43 @@ static int rk3x_i2c_calc_divs(unsigned long i2c_rate, unsigned long scl_rate,
 	if (WARN_ON(scl_rate < 1000))
 		scl_rate = 1000;
 
+	if (scl_rate <= 100000) {
+		spec_min_low_ns = 4700;
+		spec_min_high_ns = 4000;
+		spec_max_rise_ns = 1000;
+		spec_max_data_hold_ns = 3450;
+		spec_data_hold_buffer_ns = 50;
+	} else {
+		spec_min_low_ns = 1300;
+		spec_min_high_ns = 600;
+		spec_max_rise_ns = 300;
+		spec_max_data_hold_ns = 900;
+		spec_data_hold_buffer_ns = 50;
+	}
+
 	/*
-	 * min_low_ns:  The minimum number of ns we need to hold low
-	 *		to meet i2c spec
-	 * min_high_ns: The minimum number of ns we need to hold high
-	 *		to meet i2c spec
-	 * max_low_ns:  The maximum number of ns we can hold low
-	 *		to meet i2c spec
+	 * min_low_ns:  The minimum number of ns we need to hold low.
+	 *		The fall time in RK3X's I2C controller is approximately
+	 *		equal to 0. So min_low_ns = spec_min_low_ns.
+	 * Note: low_ns should be (measured_low_ns + measured_fall_time)
+	 *	 and measured_low_ns must meet I2C spec.
 	 *
-	 * Note: max_low_ns should be (max data hold time * 2 - buffer)
+	 * min_high_ns: The minimum number of ns we need to hold high.
+	 *		The rise time which related to external pull-up resistor
+	 *		can be up to spec_max_rise_ns.
+	 *		So min_high_ns = spec_min_high_ns + spec_max_rise_ns
+	 * Note: high_ns should be (measured_high_ns + measured_rise_time)
+	 *	 and measured_high_ns must meet I2C spec.
+	 *
+	 * max_low_ns:  The maximum number of ns we can hold low.
+	 * Note: max_low_ns should be (max_data_hold_time * 2 - buffer)
 	 *	 This is because the i2c host on Rockchip holds the data line
 	 *	 for half the low time.
 	 */
-	if (scl_rate <= 100000) {
-		min_low_ns = 4700;
-		min_high_ns = 4000;
-		max_data_hold_ns = 3450;
-		data_hold_buffer_ns = 50;
-	} else {
-		min_low_ns = 1300;
-		min_high_ns = 600;
-		max_data_hold_ns = 900;
-		data_hold_buffer_ns = 50;
-	}
-	max_low_ns = max_data_hold_ns * 2 - data_hold_buffer_ns;
+	min_low_ns = spec_min_low_ns;
+	min_high_ns = spec_min_high_ns + spec_max_rise_ns;
+	max_low_ns = spec_max_data_hold_ns * 2 - spec_data_hold_buffer_ns;
+
 	min_total_ns = min_low_ns + min_high_ns;
 
 	/* Adjust to avoid overflow */
-- 
1.8.3.2


