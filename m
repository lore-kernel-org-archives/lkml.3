Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbbANHYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:24:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57566 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbbANHYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:24:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guo Zeng <guo.zeng@csr.com>, Barry Song <Baohua.Song@csr.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.18 001/150] drivers/rtc/rtc-sirfsoc.c: move hardware initilization earlier in probe
Date: Tue, 13 Jan 2015 23:21:12 -0800
Message-Id: <20150114072055.911516074@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-sirfsoc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/rtc/rtc-sirfsoc.c
+++ b/drivers/rtc/rtc-sirfsoc.c
@@ -286,14 +286,6 @@ static int sirfsoc_rtc_probe(struct plat
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
@@ -308,6 +300,14 @@ static int sirfsoc_rtc_probe(struct plat
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


