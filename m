Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaJPHdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:33:44 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36248 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaJPHdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:33:38 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-eb-543f74ce63c9
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
Subject: [PATCH v2 4/8] power: ab8500: Use power_supply_*() API for accessing
 function attrs
Date: Thu, 16 Oct 2014 09:32:53 +0200
Message-id: <1413444777-24107-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413444777-24107-1-git-send-email-k.kozlowski@samsung.com>
References: <1413444777-24107-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t/xy7rnSuxDDLYeUbE4uFXTYuOM9awW
	k568Z7aYuHIys0Xn2SfMFq9fGFqcbXrDbnH/61FGiyl/ljNZbHp8jdXi8q45bBafe48wWjxZ
	eIbJYu2Ru+wWtxtXsFncPXWUzeJ0N6vF6d0lDkIeE/o/MXrsnHWX3WPzCi2PTas62TzuXNvD
	5jHvZKDH5iX1Hju/N7B79G1ZxeixYvV3do/Pm+QCuKO4bFJSczLLUov07RK4Mh6sSilokajY
	9/EFSwPjPJEuRk4OCQETiYMvdrNA2GISF+6tZ+ti5OIQEljKKHH98QwmkISQQB+TxOxFFiA2
	m4CxxOblS8CKRASuM0l0rpjAAuIwCzQyS7xraAbrEBaIk9jz7gMziM0ioCrx/O81RhCbV8Bd
	4tS2RnaIdXISJ49NZgWxOQU8JKafvcoOsc1donHCfrYJjLwLGBlWMYqmliYXFCel5xrqFSfm
	Fpfmpesl5+duYoSE/JcdjIuPWR1iFOBgVOLh1Qi2DxFiTSwrrsw9xCjBwawkwttcCBTiTUms
	rEotyo8vKs1JLT7EyMTBKdXAuOWdU5Px7Vstv3OOKy4y4WfzDFtRvfqq0+p0/e581bCeCykl
	srsrz+sxadxcdmCCe9g5F5dHzBbbQk0Od1x3Pvisbi6TT+zKvbX3c38nsb1i/3Z39s5iI9/q
	xARnl6sSLtlcR8PWRMsfshE+K/lv5y8lQ33hTd16r/xm9tseWHF5VS9P9CVtJZbijERDLeai
	4kQA1DhU51cCAAA=
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
---
 drivers/power/ab8500_btemp.c    | 2 +-
 drivers/power/ab8500_charger.c  | 2 +-
 drivers/power/ab8500_fg.c       | 2 +-
 drivers/power/abx500_chargalg.c | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 7f9a4547dccd..8161960ee78c 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -938,7 +938,7 @@ static int ab8500_btemp_get_ext_psy_data(struct device *dev, void *data)
 		enum power_supply_property prop;
 		prop = ext->properties[j];
 
-		if (ext->get_property(ext, prop, &ret))
+		if (power_supply_get_property(ext, prop, &ret))
 			continue;
 
 		switch (prop) {
diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 19110aa613a1..38d61523227f 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -1957,7 +1957,7 @@ static int ab8500_charger_get_ext_psy_data(struct device *dev, void *data)
 		enum power_supply_property prop;
 		prop = ext->properties[j];
 
-		if (ext->get_property(ext, prop, &ret))
+		if (power_supply_get_property(ext, prop, &ret))
 			continue;
 
 		switch (prop) {
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 217da4b2ca86..ed2aca42f968 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2199,7 +2199,7 @@ static int ab8500_fg_get_ext_psy_data(struct device *dev, void *data)
 		enum power_supply_property prop;
 		prop = ext->properties[j];
 
-		if (ext->get_property(ext, prop, &ret))
+		if (power_supply_get_property(ext, prop, &ret))
 			continue;
 
 		switch (prop) {
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 6d2723664a01..f3d9dbac3568 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -1001,7 +1001,7 @@ static int abx500_chargalg_get_ext_psy_data(struct device *dev, void *data)
 	 * property because of handling that sysfs entry on its own, this is
 	 * the place to get the battery capacity.
 	 */
-	if (!ext->get_property(ext, POWER_SUPPLY_PROP_CAPACITY, &ret)) {
+	if (!power_supply_get_property(ext, POWER_SUPPLY_PROP_CAPACITY, &ret)) {
 		di->batt_data.percent = ret.intval;
 		capacity_updated = true;
 	}
@@ -1019,7 +1019,7 @@ static int abx500_chargalg_get_ext_psy_data(struct device *dev, void *data)
 			ext->type == POWER_SUPPLY_TYPE_USB)
 			di->usb_chg = psy_to_ux500_charger(ext);
 
-		if (ext->get_property(ext, prop, &ret))
+		if (power_supply_get_property(ext, prop, &ret))
 			continue;
 		switch (prop) {
 		case POWER_SUPPLY_PROP_PRESENT:
-- 
1.9.1

