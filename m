Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab3BQWzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:55:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45851 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755159Ab3BQWzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:53 -0500
Message-Id: <20130217225004.567336995@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:26 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Haojian Zhuang <haojian.zhuang@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 25/66] drivers/rtc/rtc-pl031.c: fix the missing operation on enable
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haojian Zhuang <haojian.zhuang@linaro.org>

commit e7e034e18a0ab6bafb2425c3242cac311164f4d6 upstream.

The RTC control register should be enabled in the process of
initializing.

Without this patch, I failed to enable RTC in Hisilicon Hi3620 SoC.  The
register mapping section in RTC is always read as zero.  So I doubt that
ST guys may already enable this register in bootloader.  So they won't
meet this issue.

Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/rtc/rtc-pl031.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -44,6 +44,7 @@
 #define RTC_YMR		0x34	/* Year match register */
 #define RTC_YLR		0x38	/* Year data load register */
 
+#define RTC_CR_EN	(1 << 0)	/* counter enable bit */
 #define RTC_CR_CWEN	(1 << 26)	/* Clockwatch enable bit */
 
 #define RTC_TCR_EN	(1 << 1) /* Periodic timer enable bit */
@@ -312,7 +313,7 @@ static int pl031_probe(struct amba_devic
 	int ret;
 	struct pl031_local *ldata;
 	struct rtc_class_ops *ops = id->data;
-	unsigned long time;
+	unsigned long time, data;
 
 	ret = amba_request_regions(adev, NULL);
 	if (ret)
@@ -339,10 +340,11 @@ static int pl031_probe(struct amba_devic
 	dev_dbg(&adev->dev, "designer ID = 0x%02x\n", ldata->hw_designer);
 	dev_dbg(&adev->dev, "revision = 0x%01x\n", ldata->hw_revision);
 
+	data = readl(ldata->base + RTC_CR);
 	/* Enable the clockwatch on ST Variants */
 	if (ldata->hw_designer == AMBA_VENDOR_ST)
-		writel(readl(ldata->base + RTC_CR) | RTC_CR_CWEN,
-		       ldata->base + RTC_CR);
+		data |= RTC_CR_CWEN;
+	writel(data | RTC_CR_EN, ldata->base + RTC_CR);
 
 	/*
 	 * On ST PL031 variants, the RTC reset value does not provide correct


