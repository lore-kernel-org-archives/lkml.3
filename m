Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbbANHZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:25:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbbANHY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:24:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, Felipe Balbi <balbi@ti.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        Benot Cousson <bcousson@baylibre.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Sekhar Nori <nsekhar@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Keerthy J <j-keerthy@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.18 003/150] rtc: omap: fix missing wakealarm attribute
Date: Tue, 13 Jan 2015 23:21:14 -0800
Message-Id: <20150114072056.003465981@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-omap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -416,6 +416,8 @@ static int __init omap_rtc_probe(struct
 		rtc_writel(KICK1_VALUE, OMAP_RTC_KICK1_REG);
 	}
 
+	device_init_wakeup(&pdev->dev, true);
+
 	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 			&omap_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
@@ -484,8 +486,6 @@ static int __init omap_rtc_probe(struct
 	 *    is write-only, and always reads as zero...)
 	 */
 
-	device_init_wakeup(&pdev->dev, true);
-
 	if (new_ctrl & (u8) OMAP_RTC_CTRL_SPLIT)
 		pr_info("%s: split power mode\n", pdev->name);
 
@@ -495,6 +495,7 @@ static int __init omap_rtc_probe(struct
 	return 0;
 
 fail0:
+	device_init_wakeup(&pdev->dev, false);
 	if (id_entry->driver_data & OMAP_RTC_HAS_KICKER)
 		rtc_writel(0, OMAP_RTC_KICK0_REG);
 	pm_runtime_put_sync(&pdev->dev);


