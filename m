Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbaKDPES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:04:18 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57078 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbaKDPBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:01:51 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-24-5458ea5c7534
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
Subject: [PATCH RESEND v2 2/8] power_supply: sysfs: Use power_supply_*() API
 for accessing function attrs
Date: Tue, 04 Nov 2014 16:01:35 +0100
Message-id: <1415113301-25661-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415113301-25661-1-git-send-email-k.kozlowski@samsung.com>
References: <1415113301-25661-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xy7oxryJCDF43ylkc3KppsXHGelaL
	SU/eM1tMXDmZ2aLz7BNmi9cvDC3ONr1ht7j/9SijxZQ/y5ksNj2+xmpxedccNovPvUcYLZ4s
	PMNksfbIXXaL240r2CzunjrKZnG6m9Xi9O4SByGPCf2fGD12zrrL7rF5hZbHplWdbB53ru1h
	85h3MtBj85J6j53fG9g9+rasYvRYsfo7u8fnTXIB3FFcNimpOZllqUX6dglcGUcOlBds4q04
	8WkfYwNjO3cXIyeHhICJxN77bxkhbDGJC/fWs3UxcnEICSxllFjYfYoZwuljkth7dSorSBWb
	gLHE5uVLwKpEBK4zSXSumMAC4jALNDJLvGtoZgKpEhbIlmi41wk2l0VAVeLBrTcsIDavgLvE
	xckr2SH2yUmcPDYZbCqngIdEw9U/YLYQUM2K3na2CYy8CxgZVjGKppYmFxQnpeca6RUn5haX
	5qXrJefnbmKEBP3XHYxLj1kdYhTgYFTi4V0RHxEixJpYVlyZe4hRgoNZSYRX/TFQiDclsbIq
	tSg/vqg0J7X4ECMTB6dUA+OpPUVaja3bzu7RPLzQ/K3msv/Sthb/dh3Z+Drq6abkmn9eYly9
	H8y0n2i8il+bP0mhdQ1X+p2aFZ2Sm+f8mVMvFCH9+vU28wlzJloUs84/k9R6Zm4j96p99Zmi
	R1++e3VONLFz937+I4lVLHY1/ismXZtl9Yfr2/cuz/JbZ/+cedCdcNlPRVBSiaU4I9FQi7mo
	OBEARS2yk1gCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace direct calls to power supply function attributes with wrappers.
Wrappers provide safe access in case of unregistering the power
supply (e.g. by removing the driver). Replace:
 - get_property -> power_supply_get_property
 - set_property -> power_supply_set_property
 - property_is_writeable -> power_supply_property_is_writeable

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Jonghwa Lee <jonghwa3.lee@samusng.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/power/power_supply_sysfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 62653f50a524..f817aab80813 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -76,7 +76,7 @@ static ssize_t power_supply_show_property(struct device *dev,
 	if (off == POWER_SUPPLY_PROP_TYPE) {
 		value.intval = psy->type;
 	} else {
-		ret = psy->get_property(psy, off, &value);
+		ret = power_supply_get_property(psy, off, &value);
 
 		if (ret < 0) {
 			if (ret == -ENODATA)
@@ -125,7 +125,7 @@ static ssize_t power_supply_store_property(struct device *dev,
 
 	value.intval = long_val;
 
-	ret = psy->set_property(psy, off, &value);
+	ret = power_supply_set_property(psy, off, &value);
 	if (ret < 0)
 		return ret;
 
@@ -223,7 +223,7 @@ static umode_t power_supply_attr_is_visible(struct kobject *kobj,
 
 		if (property == attrno) {
 			if (psy->property_is_writeable &&
-			    psy->property_is_writeable(psy, property) > 0)
+			    power_supply_property_is_writeable(psy, property) > 0)
 				mode |= S_IWUSR;
 
 			return mode;
-- 
1.9.1

