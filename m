Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbbANCnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 21:43:43 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:43148 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbANCnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 21:43:42 -0500
From: Chris Zhong <zyw@rock-chips.com>
To: akpm@linux-foundation.org
Cc: dianders@chromium.org, heiko@sntech.de, linux-rockchip@lists.infradead.org,
        Chris Zhong <zyw@rock-chips.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] RTC: RK808: fix the rtc time reading issue
Date: Wed, 14 Jan 2015 10:43:32 +0800
Message-Id: <1421203412-5159-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After we set the GET_TIME bit, the rtc time couldn't be read immediately,
we should wait up to 31.25 us, about one cycle of 32khz. Otherwise reading
RTC time will return a old time. If clear the GET_TIME bit after setting,
the time of i2c transfer certainly more than 31.25us.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>

---

 drivers/rtc/rtc-rk808.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-rk808.c b/drivers/rtc/rtc-rk808.c
index df42257..8dae322 100644
--- a/drivers/rtc/rtc-rk808.c
+++ b/drivers/rtc/rtc-rk808.c
@@ -67,15 +67,20 @@ static int rk808_rtc_readtime(struct device *dev, struct rtc_time *tm)
 	/* Force an update of the shadowed registers right now */
 	ret = regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
 				 BIT_RTC_CTRL_REG_RTC_GET_TIME,
-				 0);
+				 BIT_RTC_CTRL_REG_RTC_GET_TIME);
 	if (ret) {
 		dev_err(dev, "Failed to update bits rtc_ctrl: %d\n", ret);
 		return ret;
 	}
 
+	/* After we set the GET_TIME bit, the rtc time couldn't be read
+	 * immediately, we should wait up to 31.25 us, about one cycle of
+	 * 32khz. If we clear the GET_TIME bit here, the time of i2c transfer
+	 * certainly more than 31.25us.
+	 */
 	ret = regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
 				 BIT_RTC_CTRL_REG_RTC_GET_TIME,
-				 BIT_RTC_CTRL_REG_RTC_GET_TIME);
+				 0);
 	if (ret) {
 		dev_err(dev, "Failed to update bits rtc_ctrl: %d\n", ret);
 		return ret;
-- 
1.9.1

