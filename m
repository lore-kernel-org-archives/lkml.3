Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab3FFIOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 04:14:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37237 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab3FFIOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 04:14:14 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tony Lindgren <tony@atomide.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, <rtc-linux@googlegroups.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH v3 1/2] RTC: rtc-twl: Fix rtc_reg_map initialization
Date: Thu, 6 Jun 2013 10:13:37 +0200
Message-ID: <1370506418-1491-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize the rtc_reg_map in platform_driver's probe function instead at
module_init time. This way we can make sure that the twl-core has been already
probed and initialized (twl_priv->twl_id is valid) since the platform device
for the RTC driver will be created by the twl-core after it finished it's
init.

Reported-by: Christoph Fritz <chf.fritz@googlemail.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Tested-by: Kevin Hilman <khilman@linaro.org>
Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
Hi,

Changes since v2:
- Acked-by and Tested-by added to patches
- Recreated on top of 3.10-rc4

Regards,
Peter

 drivers/rtc/rtc-twl.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 8751a52..c9060e9 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -469,6 +469,12 @@ static int twl_rtc_probe(struct platform_device *pdev)
 	if (irq <= 0)
 		goto out1;
 
+	/* Initialize the register map */
+	if (twl_class_is_4030())
+		rtc_reg_map = (u8 *)twl4030_rtc_reg_map;
+	else
+		rtc_reg_map = (u8 *)twl6030_rtc_reg_map;
+
 	ret = twl_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
 	if (ret < 0)
 		goto out1;
@@ -610,11 +616,6 @@ static struct platform_driver twl4030rtc_driver = {
 
 static int __init twl_rtc_init(void)
 {
-	if (twl_class_is_4030())
-		rtc_reg_map = (u8 *) twl4030_rtc_reg_map;
-	else
-		rtc_reg_map = (u8 *) twl6030_rtc_reg_map;
-
 	return platform_driver_register(&twl4030rtc_driver);
 }
 module_init(twl_rtc_init);
-- 
1.8.2.1

