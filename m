Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762876AbbA2Cq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:46:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47050 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762339AbbA2Cih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:38:37 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guo Zeng <guo.zeng@csr.com>, Barry Song <Baohua.Song@csr.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 102/139] drivers/rtc/rtc-sirfsoc.c: move hardware initilization earlier in probe
Date: Wed, 28 Jan 2015 14:20:45 -0800
Message-Id: <1422483682-15393-103-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guo Zeng <guo.zeng@csr.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/rtc/rtc-sirfsoc.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-sirfsoc.c b/drivers/rtc/rtc-sirfsoc.c
index 3eb3642..d2b1ab3 100644
--- a/drivers/rtc/rtc-sirfsoc.c
+++ b/drivers/rtc/rtc-sirfsoc.c
@@ -290,14 +290,6 @@ static int sirfsoc_rtc_probe(struct platform_device *pdev)
 	rtc_div = ((32768 / RTC_HZ) / 2) - 1;
 	sirfsoc_rtc_iobrg_writel(rtc_div, rtcdrv->rtc_base + RTC_DIV);
 
-	rtcdrv->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
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
 
+	rtcdrv->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
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
1.9.1

