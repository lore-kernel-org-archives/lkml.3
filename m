Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760556AbbA2JHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:07:30 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44891 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760484AbbA2JHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:07:23 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Guo Zeng <guo.zeng@csr.com>,
        Barry Song <Baohua.Song@csr.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 002/176] drivers/rtc/rtc-sirfsoc.c: move hardware initilization earlier in probe
Date: Wed, 28 Jan 2015 15:27:12 +0100
Message-Id: <56773a63532f311fbac75b5c16dfccebd2525bbe.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guo Zeng <guo.zeng@csr.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 0e95325525c4383565cea4f402f15a3113162d05 upstream.

Move rtc register to be later than hardware initialization.  The reason
is that devm_rtc_device_register() will do read_time() which is a
callback accessing hardware.  This sometimes causes a hang in the
hardware related callback.

Signed-off-by: Guo Zeng <guo.zeng@csr.com>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/rtc/rtc-sirfsoc.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-sirfsoc.c b/drivers/rtc/rtc-sirfsoc.c
index 63460cf80f1b..3b13401b3682 100644
--- a/drivers/rtc/rtc-sirfsoc.c
+++ b/drivers/rtc/rtc-sirfsoc.c
@@ -290,14 +290,6 @@ static int sirfsoc_rtc_probe(struct platform_device *pdev)
 	rtc_div = ((32768 / RTC_HZ) / 2) - 1;
 	sirfsoc_rtc_iobrg_writel(rtc_div, rtcdrv->rtc_base + RTC_DIV);
 
-	rtcdrv->rtc = rtc_device_register(pdev->name, &(pdev->dev),
-			&sirfsoc_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtcdrv->rtc)) {
-		err = PTR_ERR(rtcdrv->rtc);
-		dev_err(&pdev->dev, "can't register RTC device\n");
-		return err;
-	}
-
 	/* 0x3 -> RTC_CLK */
 	sirfsoc_rtc_iobrg_writel(SIRFSOC_RTC_CLK,
 			rtcdrv->rtc_base + RTC_CLOCK_SWITCH);
@@ -312,6 +304,14 @@ static int sirfsoc_rtc_probe(struct platform_device *pdev)
 	rtcdrv->overflow_rtc =
 		sirfsoc_rtc_iobrg_readl(rtcdrv->rtc_base + RTC_SW_VALUE);
 
+	rtcdrv->rtc = rtc_device_register(pdev->name, &(pdev->dev),
+			&sirfsoc_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtcdrv->rtc)) {
+		err = PTR_ERR(rtcdrv->rtc);
+		dev_err(&pdev->dev, "can't register RTC device\n");
+		return err;
+	}
+
 	rtcdrv->irq = platform_get_irq(pdev, 0);
 	err = devm_request_irq(
 			&pdev->dev,
-- 
2.2.2

