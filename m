Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762826AbbA2CqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:46:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47054 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762331AbbA2Cik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:38:40 -0500
From: Kamal Mostafa <kamal@canonical.com>
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
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 103/139] rtc: omap: fix missing wakealarm attribute
Date: Wed, 28 Jan 2015 14:20:46 -0800
Message-Id: <1422483682-15393-104-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/rtc/rtc-omap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index 26de5f8..336b0f0 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -379,6 +379,8 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 		rtc_writel(KICK1_VALUE, OMAP_RTC_KICK1_REG);
 	}
 
+	device_init_wakeup(&pdev->dev, true);
+
 	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 			&omap_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
@@ -441,8 +443,6 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	 *    is write-only, and always reads as zero...)
 	 */
 
-	device_init_wakeup(&pdev->dev, true);
-
 	if (new_ctrl & (u8) OMAP_RTC_CTRL_SPLIT)
 		pr_info("%s: split power mode\n", pdev->name);
 
@@ -452,6 +452,7 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	return 0;
 
 fail0:
+	device_init_wakeup(&pdev->dev, false);
 	if (id_entry && (id_entry->driver_data & OMAP_RTC_HAS_KICKER))
 		rtc_writel(0, OMAP_RTC_KICK0_REG);
 	pm_runtime_put_sync(&pdev->dev);
-- 
1.9.1

