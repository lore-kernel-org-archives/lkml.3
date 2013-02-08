Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883Ab3BHBNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:13:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41889 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759138Ab3BHA5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:57:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 17/34] drivers/rtc/rtc-pl031.c: fix the missing operation on enable
Date: Thu,  7 Feb 2013 16:57:13 -0800
Message-Id: <20130208004630.359979062@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.375461662@linuxfoundation.org>
References: <20130208004627.375461662@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
@@ -320,7 +321,7 @@ static int pl031_probe(struct amba_devic
 	struct pl031_local *ldata;
 	struct pl031_vendor_data *vendor = id->data;
 	struct rtc_class_ops *ops = &vendor->ops;
-	unsigned long time;
+	unsigned long time, data;
 
 	ret = amba_request_regions(adev, NULL);
 	if (ret)
@@ -345,10 +346,11 @@ static int pl031_probe(struct amba_devic
 	dev_dbg(&adev->dev, "designer ID = 0x%02x\n", amba_manf(adev));
 	dev_dbg(&adev->dev, "revision = 0x%01x\n", amba_rev(adev));
 
+	data = readl(ldata->base + RTC_CR);
 	/* Enable the clockwatch on ST Variants */
 	if (vendor->clockwatch)
-		writel(readl(ldata->base + RTC_CR) | RTC_CR_CWEN,
-		       ldata->base + RTC_CR);
+		data |= RTC_CR_CWEN;
+	writel(data | RTC_CR_EN, ldata->base + RTC_CR);
 
 	/*
 	 * On ST PL031 variants, the RTC reset value does not provide correct


