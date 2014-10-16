Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaJPHdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:33:46 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33231 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaJPHdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:33:37 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-ef-543f74cf2c0c
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
Subject: [PATCH v2 5/8] mfd: ab8500: Use power_supply_*() API for accessing
 function attrs
Date: Thu, 16 Oct 2014 09:32:54 +0200
Message-id: <1413444777-24107-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413444777-24107-1-git-send-email-k.kozlowski@samsung.com>
References: <1413444777-24107-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xy7rnS+xDDP63iloc3KppsXHGelaL
	SU/eM1tMXDmZ2aLz7BNmi9cvDC3ONr1ht7j/9SijxZQ/y5ksNj2+xmpxedccNovPvUcYLZ4s
	PMNksfbIXXaL240r2CzunjrKZnG6m9Xi9O4SByGPCf2fGD12zrrL7rF5hZbHplWdbB53ru1h
	85h3MtBj85J6j53fG9g9+rasYvRYsfo7u8fnTXIB3FFcNimpOZllqUX6dglcGVeOPWMtuMBd
	8b7/M1MD4wXOLkZODgkBE4nlS+czQdhiEhfurWfrYuTiEBJYyihx6995Vginj0ni4bdOVpAq
	NgFjic3Ll4BViQhcZ5LoXDGBBcRhFmhklnjX0Aw2S1ggRqJ/9zsWEJtFQFXixI4pbCA2r4C7
	xLzLG9gh9slJnDw2GWwqp4CHxPSzV8HiQkA1jRP2s01g5F3AyLCKUTS1NLmgOCk911CvODG3
	uDQvXS85P3cTIyTsv+xgXHzM6hCjAAejEg+vRrB9iBBrYllxZe4hRgkOZiUR3uZCoBBvSmJl
	VWpRfnxRaU5q8SFGJg5OqQbGyLLffsarwrLY8/t2c5zmPSq45qh00WWpjUtKP82X4tXnvbt+
	oZn940j3w+xRLy+u2D+R/dmuu/Ghj2fe69y4qrRN/+HaV0+kJqx/xWB79W1zxeJIWcs58tuu
	L6k7M2fj3TurxTje9/4JTF7A8khOyu77t63sj6oUN3neS9/KYfHujoi3Qu/ZiUosxRmJhlrM
	RcWJANKE02ZZAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace direct calls to power supply function attributes with wrappers.
Wrappers provide safe access in case of unregistering the power
supply (e.g. by removing the driver). Replace:
 - get_property -> power_supply_get_property

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Jonghwa Lee <jonghwa3.lee@samusng.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Lee Jones <lee.jones@linaro.org>
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

