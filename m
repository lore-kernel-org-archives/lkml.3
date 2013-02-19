Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934522Ab3BSTHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:07:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54327 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933434Ab3BSSw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:52:26 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 38/81] drivers/rtc/rtc-pl031.c: fix the missing operation on enable
Date: Tue, 19 Feb 2013 15:49:01 -0300
Message-Id: <1361299784-8830-39-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

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
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/rtc/rtc-pl031.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-pl031.c b/drivers/rtc/rtc-pl031.c
index cc05339..c42054b 100644
--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -44,6 +44,7 @@
 #define RTC_YMR		0x34	/* Year match register */
 #define RTC_YLR		0x38	/* Year data load register */
 
+#define RTC_CR_EN	(1 << 0)	/* counter enable bit */
 #define RTC_CR_CWEN	(1 << 26)	/* Clockwatch enable bit */
 
 #define RTC_TCR_EN	(1 << 1) /* Periodic timer enable bit */
@@ -304,7 +305,7 @@ static int pl031_probe(struct amba_device *adev, const struct amba_id *id)
 	int ret;
 	struct pl031_local *ldata;
 	struct rtc_class_ops *ops = id->data;
-	unsigned long time;
+	unsigned long time, data;
 
 	ret = amba_request_regions(adev, NULL);
 	if (ret)
@@ -331,10 +332,11 @@ static int pl031_probe(struct amba_device *adev, const struct amba_id *id)
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
-- 
1.7.9.5

