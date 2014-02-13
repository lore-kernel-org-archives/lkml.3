Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbaBMJST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:18:19 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54737 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbaBMJOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:14:31 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-93-52fc8cefee91
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: [PATCH v2 04/14] rtc: s5m: Remove undocumented time init on first boot
Date: Thu, 13 Feb 2014 10:13:57 +0100
Message-id: <1392282847-25444-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e/4Zd33PX+CDCbdUbNYcvEqu8XGGetZ
	LV6/MLQ42/SG3eL+16OMFpd3zWGzmHF+H5PF2iN32S32d3YwWpzuZrW4uOILkwO3x56JJ9k8
	7lzbw+Yx72SgR9+WVYwe0+f9ZPL4vEkugC2KyyYlNSezLLVI3y6BK+Pik+PMBZcFKp7/nMDS
	wLiWt4uRk0NCwERiz5yFzBC2mMSFe+vZuhi5OIQEljJKvGk/DeX0MUmc+nmEFaSKTcBYYvPy
	JWAJEYHNjBKLv19lBXGYBXqYJK61z2UBqRIW8Jf41zgPrINFQFVix5t2sDivgLvEvqVfmLoY
	OYD2KUjMmWQDEuYU8JD49+M32BlCQCU9i2exT2DkXcDIsIpRNLU0uaA4KT3XUK84Mbe4NC9d
	Lzk/dxMjJAi/7GBcfMzqEKMAB6MSD6/Fst9BQqyJZcWVuYcYJTiYlUR4ZST+BAnxpiRWVqUW
	5ccXleakFh9iZOLglGpgbLdepVyzJGJi0Jzb2StrZ3/81dbmeCaiL9Vd4Xic9CyRTTvevo8N
	OP5A2qltsujE0v+7dx32NLr5pYS90va48dz+38vnTej79C7C8IHv7VPzdv9mr6/v5vg+T3hN
	uE95W5JBJROfqR5H3/P4Q5wLIh5FTtRyEL7eZpRus+7hxD8Bd/aqO+a9U2Ipzkg01GIuKk4E
	AG8fCKQgAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the code for initializing time if this is first boot.

The code for detecting first boot uses undocumented field RTC_TCON in
RTC_UDR_CON register. According to S5M8767's datasheet this field is
reserved. On S2MPS14 it is not documented at all. On device first boot
the registers will be initialized with reset value (2000-01-01
00:00:00).

The code might work on S5M8763 but still this does not look like a task
for RTC driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com
---
 drivers/rtc/rtc-s5m.c |   30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
index d26e2480f8b3..b1627e9ab8f0 100644
--- a/drivers/rtc/rtc-s5m.c
+++ b/drivers/rtc/rtc-s5m.c
@@ -502,16 +502,7 @@ static void s5m_rtc_enable_smpl(struct s5m_rtc_info *info, bool enable)
 static int s5m8767_rtc_init_reg(struct s5m_rtc_info *info)
 {
 	u8 data[2];
-	unsigned int tp_read;
 	int ret;
-	struct rtc_time tm;
-
-	ret = regmap_read(info->regmap, S5M_RTC_UDR_CON, &tp_read);
-	if (ret < 0) {
-		dev_err(info->dev, "%s: fail to read control reg(%d)\n",
-			__func__, ret);
-		return ret;
-	}
 
 	/* Set RTC control register : Binary mode, 24hour mode */
 	data[0] = (1 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
@@ -525,27 +516,6 @@ static int s5m8767_rtc_init_reg(struct s5m_rtc_info *info)
 		return ret;
 	}
 
-	/* In first boot time, Set rtc time to 1/1/2012 00:00:00(SUN) */
-	if ((tp_read & RTC_TCON_MASK) == 0) {
-		dev_dbg(info->dev, "rtc init\n");
-		tm.tm_sec = 0;
-		tm.tm_min = 0;
-		tm.tm_hour = 0;
-		tm.tm_wday = 0;
-		tm.tm_mday = 1;
-		tm.tm_mon = 0;
-		tm.tm_year = 112;
-		tm.tm_yday = 0;
-		tm.tm_isdst = 0;
-		ret = s5m_rtc_set_time(info->dev, &tm);
-	}
-
-	ret = regmap_update_bits(info->regmap, S5M_RTC_UDR_CON,
-				 RTC_TCON_MASK, tp_read | RTC_TCON_MASK);
-	if (ret < 0)
-		dev_err(info->dev, "%s: fail to update TCON reg(%d)\n",
-			__func__, ret);
-
 	return ret;
 }
 
-- 
1.7.9.5

