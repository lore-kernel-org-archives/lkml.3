Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbbALTBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:01:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58037 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbbALS3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:29:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <johan@kernel.org>, Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        Benot Cousson <bcousson@baylibre.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Sekhar Nori <nsekhar@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Keerthy J <j-keerthy@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 119/216] rtc: omap: fix missing wakealarm attribute
Date: Mon, 12 Jan 2015 18:28:17 +0000
Message-Id: <1421087394-2712-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 7ecd9a3f062147400e605713724dd67dbb7e5053 upstream.

The platform device must be registered as wakeup capable before
registering the class device, or the wakealarm attribute will not be
created.

Also make sure to unregister the wakeup source on probe errors.

Fixes: 1d2e2b65d098 ("rtc: omap: restore back (hard-code) wakeup support")
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Tested-by: Felipe Balbi <balbi@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Benot Cousson <bcousson@baylibre.com>
Cc: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: Keerthy J <j-keerthy@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/rtc/rtc-omap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index f842c216f2dd..828cb9983cc2 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -416,6 +416,8 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 		rtc_writel(KICK1_VALUE, OMAP_RTC_KICK1_REG);
 	}
 
+	device_init_wakeup(&pdev->dev, true);
+
 	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 			&omap_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
@@ -484,8 +486,6 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	 *    is write-only, and always reads as zero...)
 	 */
 
-	device_init_wakeup(&pdev->dev, true);
-
 	if (new_ctrl & (u8) OMAP_RTC_CTRL_SPLIT)
 		pr_info("%s: split power mode\n", pdev->name);
 
@@ -495,6 +495,7 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	return 0;
 
 fail0:
+	device_init_wakeup(&pdev->dev, false);
 	if (id_entry->driver_data & OMAP_RTC_HAS_KICKER)
 		rtc_writel(0, OMAP_RTC_KICK0_REG);
 	pm_runtime_put_sync(&pdev->dev);
-- 
2.1.4

