Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933420AbaJURo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:44:58 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:57921 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125AbaJURox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:44:53 -0400
X-Google-Original-Sender: <johan@hovold.com>
From: Johan Hovold <johan@kernel.org>
To: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Felipe Balbi <balbi@ti.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        nsekhar@ti.com, t-kristo@ti.com, j-keerthy@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH v2 01/20] rtc: omap: fix clock-source configuration
Date: Tue, 21 Oct 2014 19:37:47 +0200
Message-Id: <1413913086-12730-2-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1413913086-12730-1-git-send-email-johan@kernel.org>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1413913086-12730-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure not to reset the clock-source configuration when enabling the
32kHz clock mux.

Until the clock source can be configured through device tree we must not
overwrite settings made by the bootloader (e.g. clock-source selection).

Fixes: cd914bba03d8 ("drivers/rtc/rtc-omap.c: add support for enabling
32khz clock")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/rtc/rtc-omap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index 21142e6574a9..f842c216f2dd 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -431,8 +431,10 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
 
 	/* enable RTC functional clock */
-	if (id_entry->driver_data & OMAP_RTC_HAS_32KCLK_EN)
-		rtc_writel(OMAP_RTC_OSC_32KCLK_EN, OMAP_RTC_OSC_REG);
+	if (id_entry->driver_data & OMAP_RTC_HAS_32KCLK_EN) {
+		reg = rtc_read(OMAP_RTC_OSC_REG);
+		rtc_writel(reg | OMAP_RTC_OSC_32KCLK_EN, OMAP_RTC_OSC_REG);
+	}
 
 	/* clear old status */
 	reg = rtc_read(OMAP_RTC_STATUS_REG);
-- 
2.0.4

