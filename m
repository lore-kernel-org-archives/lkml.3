Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217Ab3EGBUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:20:35 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:37103 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757704Ab3EGBUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:20:33 -0400
X-Greylist: delayed 85810 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 May 2013 21:20:16 EDT
From: Chao Xie <chao.xie@marvell.com>
To: <haojian.zhuang@gmail.com>, <xiechao.mail@gmail.com>,
        <linux@arm.linux.org.uk>, <a.zummo@towertech.it>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead>, <robert.jarzmik@free.fr>,
        <akpm@linux-foundation.org>, <liangs@marvell.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH 1/2] Revert "drivers/rtc/rtc-pxa.c: fix set time sync time issue"
Date: Mon, 6 May 2013 21:17:26 -0400
Message-ID: <1367889447-15619-2-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1367889447-15619-1-git-send-email-chao.xie@marvell.com>
References: <1367889447-15619-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch have something wrong.
1.The pxa_sync_time API is not needed. The RTC sync can be done
by user space applications, so in kernel this API is not needed.
2.The pxa_rtc_open can not be deleted. This change has been
declined during review at the mail list
3.Based on specification and talked with owner of driver, it
does not matter to set WOM and DOW.

Only need to keep PSBR control for pxa95x

This reverts commit 57489fabb7f3fc02483df2125fdbfb8b1bb1fcd8.
---
 drivers/rtc/rtc-pxa.c   |   63 +++++-----------------------------------------
 include/linux/rtc-pxa.h |   18 -------------
 2 files changed, 7 insertions(+), 74 deletions(-)
 delete mode 100644 include/linux/rtc-pxa.h

diff --git a/drivers/rtc/rtc-pxa.c b/drivers/rtc/rtc-pxa.c
index a2c75c1..e261e2f 100644
--- a/drivers/rtc/rtc-pxa.c
+++ b/drivers/rtc/rtc-pxa.c
@@ -81,29 +81,22 @@
 #define RYAR1		0x1c
 #define RTCPICR		0x34
 #define PIAR		0x38
-#define PSBR_RTC	0x00
 
 #define rtc_readl(pxa_rtc, reg)	\
 	__raw_readl((pxa_rtc)->base + (reg))
 #define rtc_writel(pxa_rtc, reg, value)	\
 	__raw_writel((value), (pxa_rtc)->base + (reg))
-#define rtc_readl_psbr(pxa_rtc, reg)	\
-	__raw_readl((pxa_rtc)->base_psbr + (reg))
-#define rtc_writel_psbr(pxa_rtc, reg, value)	\
-	__raw_writel((value), (pxa_rtc)->base_psbr + (reg))
 
 struct pxa_rtc {
 	struct resource	*ress;
-	struct resource	*ress_psbr;
 	void __iomem		*base;
-	void __iomem		*base_psbr;
 	int			irq_1Hz;
 	int			irq_Alrm;
 	struct rtc_device	*rtc;
 	spinlock_t		lock;		/* Protects this structure */
 };
 
-static struct pxa_rtc *rtc_info;
+
 static u32 ryxr_calc(struct rtc_time *tm)
 {
 	return ((tm->tm_year + 1900) << RYxR_YEAR_S)
@@ -125,7 +118,7 @@ static void tm_calc(u32 rycr, u32 rdcr, struct rtc_time *tm)
 	tm->tm_year = ((rycr & RYxR_YEAR_MASK) >> RYxR_YEAR_S) - 1900;
 	tm->tm_mon = (((rycr & RYxR_MONTH_MASK) >> RYxR_MONTH_S)) - 1;
 	tm->tm_mday = (rycr & RYxR_DAY_MASK);
-	tm->tm_wday = ((rdcr & RDxR_DOW_MASK) >> RDxR_DOW_S) - 1;
+	tm->tm_wday = ((rycr & RDxR_DOW_MASK) >> RDxR_DOW_S) - 1;
 	tm->tm_hour = (rdcr & RDxR_HOUR_MASK) >> RDxR_HOUR_S;
 	tm->tm_min = (rdcr & RDxR_MIN_MASK) >> RDxR_MIN_S;
 	tm->tm_sec = rdcr & RDxR_SEC_MASK;
@@ -183,6 +176,7 @@ static irqreturn_t pxa_rtc_irq(int irq, void *dev_id)
 
 	/* enable back rtc interrupts */
 	rtc_writel(pxa_rtc, RTSR, rtsr & ~RTSR_TRIG_MASK);
+
 	spin_unlock(&pxa_rtc->lock);
 	return IRQ_HANDLED;
 }
@@ -257,45 +251,12 @@ static int pxa_rtc_read_time(struct device *dev, struct rtc_time *tm)
 static int pxa_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	struct pxa_rtc *pxa_rtc = dev_get_drvdata(dev);
-	/* sequence to wirte pxa rtc register RCNR RDCR RYCR is
-	*1. set PSBR[RWE] bit, take 2x32-khz to complete
-	*2. write to RTC register,take 2x32-khz to complete
-	*3. clear PSBR[RWE] bit,take 2x32-khz to complete
-	*/
-	if ((tm->tm_year < 70) || (tm->tm_year > 138))
-		return -EINVAL;
-	rtc_writel_psbr(rtc_info, PSBR_RTC, 0x01);
-	udelay(100);
+
 	rtc_writel(pxa_rtc, RYCR, ryxr_calc(tm));
 	rtc_writel(pxa_rtc, RDCR, rdxr_calc(tm));
-	udelay(100);
-	rtc_writel_psbr(rtc_info, PSBR_RTC, 0x00);
-	udelay(100);
-	pxa_rtc_read_time(dev, tm);
-	dev_info(dev, "tm.year = %d, tm.month = %d, tm.day = %d\n",
-			tm->tm_year + 1900, tm->tm_mon, tm->tm_mday);
-	return 0;
-}
 
-int pxa_rtc_sync_time(unsigned int ticks)
-{
-	/* sequence to wirte pxa rtc register RCNR RDCR RYCR is
-	*1. set PSBR[RWE] bit, take 2x32-khz to complete
-	*2. write to RTC register,take 2x32-khz to complete
-	*3. clear PSBR[RWE] bit,take 2x32-khz to complete
-	*/
-	struct rtc_time tm;
-	rtc_time_to_tm(ticks, &tm);
-	rtc_writel_psbr(rtc_info, PSBR_RTC, 0x01);
-	udelay(100);
-	rtc_writel(rtc_info, RYCR, ryxr_calc(&tm));
-	rtc_writel(rtc_info, RDCR, rdxr_calc(&tm));
-	udelay(100);
-	rtc_writel_psbr(rtc_info, PSBR_RTC, 0x00);
-	udelay(100);
 	return 0;
 }
-EXPORT_SYMBOL(pxa_rtc_sync_time);
 
 static int pxa_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
@@ -367,7 +328,7 @@ static int __init pxa_rtc_probe(struct platform_device *pdev)
 	pxa_rtc = kzalloc(sizeof(struct pxa_rtc), GFP_KERNEL);
 	if (!pxa_rtc)
 		return -ENOMEM;
-	rtc_info = pxa_rtc;
+
 	spin_lock_init(&pxa_rtc->lock);
 	platform_set_drvdata(pdev, pxa_rtc);
 
@@ -377,11 +338,6 @@ static int __init pxa_rtc_probe(struct platform_device *pdev)
 		dev_err(dev, "No I/O memory resource defined\n");
 		goto err_ress;
 	}
-	pxa_rtc->ress_psbr = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (!pxa_rtc->ress_psbr) {
-		dev_err(dev, "No I/O memory resource defined\n");
-		goto err_ress;
-	}
 
 	pxa_rtc->irq_1Hz = platform_get_irq(pdev, 0);
 	if (pxa_rtc->irq_1Hz < 0) {
@@ -393,6 +349,7 @@ static int __init pxa_rtc_probe(struct platform_device *pdev)
 		dev_err(dev, "No alarm IRQ resource defined\n");
 		goto err_ress;
 	}
+	pxa_rtc_open(dev);
 	ret = -ENOMEM;
 	pxa_rtc->base = ioremap(pxa_rtc->ress->start,
 				resource_size(pxa_rtc->ress));
@@ -401,12 +358,6 @@ static int __init pxa_rtc_probe(struct platform_device *pdev)
 		goto err_map;
 	}
 
-	pxa_rtc->base_psbr = ioremap(pxa_rtc->ress_psbr->start,
-				resource_size(pxa_rtc->ress_psbr));
-	if (!pxa_rtc->base_psbr) {
-		dev_err(&pdev->dev, "Unable to map pxa RTC PSBR I/O memory\n");
-		goto err_map;
-	}
 	/*
 	 * If the clock divider is uninitialized then reset it to the
 	 * default value to get the 1Hz clock.
@@ -429,7 +380,7 @@ static int __init pxa_rtc_probe(struct platform_device *pdev)
 	}
 
 	device_init_wakeup(dev, 1);
-	pxa_rtc_open(dev);
+
 	return 0;
 
 err_rtc_reg:
diff --git a/include/linux/rtc-pxa.h b/include/linux/rtc-pxa.h
deleted file mode 100644
index 71bc45f..0000000
--- a/include/linux/rtc-pxa.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/*
- * include/linux/rtc-pxa.h
- *
- * RTC PXA Header file
- *
- * Copyright (C) 2010 Marvell International Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef __LINUX_RTC_PXA_H
-#define __LINUX_RTC_PXA_H
-
-extern int pxa_rtc_sync_time(unsigned int ticks);
-
-#endif /* __LINUX_RTC_PXA_H */
-- 
1.7.4.1

