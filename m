Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334Ab3ECP5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:57:04 -0400
Received: from nm12.access.bullet.mail.sp2.yahoo.com ([98.139.44.139]:42605
	"EHLO nm12.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933017Ab3ECP5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:57:02 -0400
X-Yahoo-Newman-Id: 652488.62824.bm@smtp111.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zSiifRsVM1kXOOX3Z6y27Wi1wFUncz5_iCbFDOyRFiTMjyJ
 sTKn1.bc5i6eUojqUu2FaUL.wawdPvGvotUPC39U8pAd1ggZ1zvJVe5AspBA
 sA6q49xiMJLm8i2xauQXUtgLhMmt8ch3ILdg_PUGe1wZZ4pF9PZ2bMy.NFY6
 HCc011e3uR6aN45vMFwzU2uA0lfcTWYd6r6CUL5NRpnDZUhvmuQfsR7IpqL.
 J234jy6biFgfk7DNMoaYmSqYG7Ug5rK6b7aQ_cX4U4pSw9.CKe0DBJTPoxyt
 _RzqN24CtMAj3tFYU3Rv.3YICcTgpLSmmpG9tTj4MDYZSCpe.cT5aoV9SUb6
 CpGjriRIdjUwLLX0dz99FImDJ75YG1zR14qK1PB0r7KyDN2.RPpwYc8O5g1L
 eVPzeFgXTfyWWCYOrM3d7bgADWtHF.al3I23zYUm1H_Wl9N45YZdNx.nzJXu
 CXHaRwd8i_52bVDK2PsJsc.1Z0uQmj5qF0XBi1nR4ItWZh98rftIeouHn
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp111.sbc.mail.gq1.yahoo.com with SMTP; 03 May 2013 15:57:01 +0000 UTC
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Dirk Eibach <dirk.eibach@gdsys.cc>
Subject: [RFC PATCH 2/2] watchdog: booke: Add device tree support
Date: Fri,  3 May 2013 08:56:46 -0700
Message-Id: <1367596606-22476-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1367596606-22476-1-git-send-email-linux@roeck-us.net>
References: <1367596606-22476-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable timeout initialization from device tree data.

Cc: Dirk Eibach <dirk.eibach@gdsys.cc>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Compile tested only. Need to determine final "compatible" strings
documentation of properties.

 drivers/watchdog/booke_wdt.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index 9b066b9..d433675 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -18,6 +18,7 @@
 #include <linux/smp.h>
 #include <linux/watchdog.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
 
 #include <asm/reg_booke.h>
 #include <asm/time.h>
@@ -238,8 +239,10 @@ static int booke_wdt_probe(struct platform_device *pdev)
 	dev_info(&pdev->dev, "powerpc book-e watchdog driver loaded\n");
 
 	booke_wdt_info.firmware_version = cur_cpu_spec->pvr_value;
-	booke_wdt_set_timeout(&booke_wdt_dev,
-			      period_to_sec(CONFIG_BOOKE_WDT_DEFAULT_TIMEOUT));
+	watchdog_init_timeout(&booke_wdt_dev,
+			      period_to_sec(CONFIG_BOOKE_WDT_DEFAULT_TIMEOUT),
+			      &pdev->dev);
+	booke_wdt_set_timeout(&booke_wdt_dev, booke_wdt_dev.timeout);
 	watchdog_set_nowayout(&booke_wdt_dev, nowayout);
 	if (booke_wdt_enabled)
 		__booke_wdt_start(&booke_wdt_dev);
@@ -249,6 +252,13 @@ static int booke_wdt_probe(struct platform_device *pdev)
 	return ret;
 }
 
+static const struct of_device_id booke_wdt_of_match[] = {
+	{ .compatible = "booke_wdt", },
+	{ .compatible = "fsl,booke-wdt", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, booke_wdt_of_match);
+
 static struct platform_driver booke_wdt_driver = {
 	.probe = booke_wdt_probe,
 	.remove = booke_wdt_remove,
@@ -256,6 +266,7 @@ static struct platform_driver booke_wdt_driver = {
 	.driver = {
 		.owner  = THIS_MODULE,
 		.name = "booke_wdt",
+		.of_match_table = booke_wdt_of_match,
 	},
 };
 
-- 
1.7.9.7

