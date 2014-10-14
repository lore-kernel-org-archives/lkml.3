Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbaJNMWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:22:31 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:54165 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbaJNMVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:21:06 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-ff-543d1530446a
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, Guenter Roeck <linux@roeck-us.net>,
        Pavel Machek <pavel@ucw.cz>, Myungjoo Ham <myungjoo.ham@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 5/8] mfd: ab8500: Use power_supply_*() API for accessing
 function attrs
Date: Tue, 14 Oct 2014 14:20:43 +0200
Message-id: <1413289246-31650-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413289246-31650-1-git-send-email-k.kozlowski@samsung.com>
References: <1413289246-31650-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t/xq7oGorYhBg8ecVsc3KppsXHGelaL
	SU/eM1tMXDmZ2aLz7BNmi9cvDC3ONr1ht7j/9SijxZQ/y5ksNj2+xmpxedccNovPvUcYLZ4s
	PMNksfbIXXaL240r2CzunjrKZnG6m9Xi9O4SByGPCf2fGD12zrrL7rF5hZbHplWdbB53ru1h
	85h3MtBj85J6j53fG9g9+rasYvRYsfo7u8fnTXIB3FFcNimpOZllqUX6dglcGX8/yBRc4qqY
	0+XUwPiAo4uRk0NCwESiceJnNghbTOLCvfVANheHkMBSRom3r/tYIZw+JolpU3qYQarYBIwl
	Ni9fAlYlInCdSaJzxQQWEIdZoJFZ4l1DMxNIlbBApMSzXffAbBYBVYndu/rAbF4Bd4kv668x
	QuyTkzh5bDIriM0p4CGxctERFhBbCKim/eRttgmMvAsYGVYxiqaWJhcUJ6XnGuoVJ+YWl+al
	6yXn525ihIT8lx2Mi49ZHWIU4GBU4uEtiLQJEWJNLCuuzD3EKMHBrCTCq8BhGyLEm5JYWZVa
	lB9fVJqTWnyIkYmDU6qBUfLDoYkarDqRj13TmCXePuu4+Pv30t9CHSULfAP41FMf3EqzcV12
	XTBr78x4XWHP6ecfNT6f6nNolvLmx6IX9U7tSOTX38wd7s95a/LN/M8fT1msuVPUfG3qjHSP
	yMNRTYv1OdZVl+wu/XfW6GSc0qLpdQunTo5++sNaL6vrlonY2+fz3x163qnEUpyRaKjFXFSc
	CABynMj4VwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace direct calls to power supply function attributes with wrappers.
Wrappers provide safe access access in case of unregistering the power
supply (.e.g by removing the driver). Replace:
 - get_property -> power_supply_get_property

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/ab8500-sysctrl.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
index 8e0dae59844d..93b2d2c32ca3 100644
--- a/drivers/mfd/ab8500-sysctrl.c
+++ b/drivers/mfd/ab8500-sysctrl.c
@@ -49,7 +49,8 @@ static void ab8500_power_off(void)
 		if (!psy)
 			continue;
 
-		ret = psy->get_property(psy, POWER_SUPPLY_PROP_ONLINE, &val);
+		ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_ONLINE,
+				&val);
 
 		if (!ret && val.intval) {
 			charger_present = true;
@@ -63,8 +64,8 @@ static void ab8500_power_off(void)
 	/* Check if battery is known */
 	psy = power_supply_get_by_name("ab8500_btemp");
 	if (psy) {
-		ret = psy->get_property(psy, POWER_SUPPLY_PROP_TECHNOLOGY,
-					&val);
+		ret = power_supply_get_property(psy,
+				POWER_SUPPLY_PROP_TECHNOLOGY, &val);
 		if (!ret && val.intval != POWER_SUPPLY_TECHNOLOGY_UNKNOWN) {
 			printk(KERN_INFO
 			       "Charger \"%s\" is connected with known battery."
-- 
1.9.1

