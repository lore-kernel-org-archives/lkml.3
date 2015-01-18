Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbbARQRJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 11:17:09 -0500
Received: from regular2.263xmail.com ([211.157.152.4]:39978 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbbARQRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 11:17:04 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: caesar.wang@rock-chips.com
X-SENDER-IP: 173.208.56.148
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <624b0ace62b5abc33ef2ba8851c849f4>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 5
From: Caesar Wang <wxt@rock-chips.com>
To: Heiko Stuebner <heiko@sntech.de>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Caesar Wang <wxt@rock-chips.com>, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1] thermal: rockchip: make temperature reporting much more accurate
Date: Mon, 19 Jan 2015 00:15:53 +0800
Message-Id: <1421597753-2082-2-git-send-email-wxt@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421597753-2082-1-git-send-email-wxt@rock-chips.com>
References: <1421597753-2082-1-git-send-email-wxt@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In general, the kernel should report temperature readings exactly as
reported by the hardware. The cpu / gpu thermal driver works in 5 degree
increments,but we ought to do more accurate. The temperature will do
linear interpolation between the entries in the table.

Test= $md5sum /dev/zero &
$while true; do grep "" /sys/class/thermal/thermal_zone[1-2]/temp;
sleep .5; done

e.g. We can get the result as follows:
    /sys/class/thermal/thermal_zone1/temp:39994
    /sys/class/thermal/thermal_zone2/temp:39086
    /sys/class/thermal/thermal_zone1/temp:39994
    /sys/class/thermal/thermal_zone2/temp:39540
    /sys/class/thermal/thermal_zone1/temp:39540
    /sys/class/thermal/thermal_zone2/temp:39540
    /sys/class/thermal/thermal_zone1/temp:39540
    /sys/class/thermal/thermal_zone2/temp:39994

Signed-off-by: Caesar Wang <wxt@rock-chips.com>

---

 drivers/thermal/rockchip_thermal.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/thermal/rockchip_thermal.c b/drivers/thermal/rockchip_thermal.c
index 1bcddfc..a7ae23a 100644
--- a/drivers/thermal/rockchip_thermal.c
+++ b/drivers/thermal/rockchip_thermal.c
@@ -193,19 +193,18 @@ static u32 rk_tsadcv2_temp_to_code(long temp)
 
 static long rk_tsadcv2_code_to_temp(u32 code)
 {
-	int high, low, mid;
-
-	low = 0;
-	high = ARRAY_SIZE(v2_code_table) - 1;
-	mid = (high + low) / 2;
+	unsigned int low = 0;
+	unsigned int high = ARRAY_SIZE(v2_code_table) - 1;
+	unsigned int mid = (low + high) / 2;
+	unsigned int scale;
 
 	if (code > v2_code_table[low].code || code < v2_code_table[high].code)
 		return 125000; /* No code available, return max temperature */
 
 	while (low <= high) {
-		if (code >= v2_code_table[mid].code && code <
-		    v2_code_table[mid - 1].code)
-			return v2_code_table[mid].temp;
+		if (code >= v2_code_table[mid].code &&
+		    code < v2_code_table[mid - 1].code)
+			break;
 		else if (code < v2_code_table[mid].code)
 			low = mid + 1;
 		else
@@ -213,7 +212,16 @@ static long rk_tsadcv2_code_to_temp(u32 code)
 		mid = (low + high) / 2;
 	}
 
-	return 125000;
+	/*
+	 * The 5C granularity provided by the table is too much. Let's
+	 * assume that the relationship between sensor readings and
+	 * temperature between 2 table entries is linear and extrapolate
+	 * to produce less granular result.
+	 */
+	scale = (v2_code_table[mid].temp - v2_code_table[mid - 1].temp) /
+		(v2_code_table[mid - 1].code - v2_code_table[mid].code);
+	return v2_code_table[mid - 1].temp +
+			(v2_code_table[mid - 1].code - code) * scale;
 }
 
 /**
-- 
1.9.1


