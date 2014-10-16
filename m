Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaJPHdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:33:41 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36248 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaJPHdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:33:36 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-f6-543f74cd4f2c
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
Subject: [PATCH v2 3/8] power: 88pm860x_charger: Use power_supply_*() API for
 accessing function attrs
Date: Thu, 16 Oct 2014 09:32:52 +0200
Message-id: <1413444777-24107-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413444777-24107-1-git-send-email-k.kozlowski@samsung.com>
References: <1413444777-24107-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xy7pnS+xDDO4vN7E4uFXTYuOM9awW
	k568Z7aYuHIys0Xn2SfMFq9fGFqcbXrDbnH/61FGiyl/ljNZbHp8jdXi8q45bBafe48wWjxZ
	eIbJYu2Ru+wWtxtXsFncPXWUzeJ0N6vF6d0lDkIeE/o/MXrsnHWX3WPzCi2PTas62TzuXNvD
	5jHvZKDH5iX1Hju/N7B79G1ZxeixYvV3do/Pm+QCuKO4bFJSczLLUov07RK4Mtr7+tkKnglV
	XH65hrGB8Tl/FyMnh4SAicSkW6/ZIWwxiQv31rN1MXJxCAksZZT4enwmlNPHJLGgcRMzSBWb
	gLHE5uVLwBIiAteZJDpXTGABcZgFGpkl3jU0M4FUCQtkSCx4PgOsg0VAVaJ17iqwOK+Au8TJ
	tqMsEPvkJE4em8wKYnMKeEhMP3sV7A4hoJrGCfvZJjDyLmBkWMUomlqaXFCclJ5rpFecmFtc
	mpeul5yfu4kREvZfdzAuPWZ1iFGAg1GJh1cj2D5EiDWxrLgy9xCjBAezkghvcyFQiDclsbIq
	tSg/vqg0J7X4ECMTB6dUA6NAg/k/rckf2L+3O6tzOwp/WLr2sCfPVbVbrZ4fLuspX42J7D79
	VXd5A/cN57+5zAGPMr5cEOI2PvXDZC9rwUyHlZ02u6ZM71awY/3NMMOM696rSZyzJ5SopjR2
	yWT1vBdZIGHQpf79+pYt918V9wlPecOffYfReOL36dcuvZ54ecuhZ3/qlJyUWIozEg21mIuK
	EwHNW/0fWQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace direct calls to power supply function attributes with wrappers.
Wrappers provide safe access in case of unregistering the power
supply (e.g. by removing the driver). Replace:
 - get_property -> power_supply_get_property
 - set_property -> power_supply_set_property

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Jonghwa Lee <jonghwa3.lee@samusng.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/power/88pm860x_charger.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/power/88pm860x_charger.c b/drivers/power/88pm860x_charger.c
index de029bbc1cc1..534b3e2e3487 100644
--- a/drivers/power/88pm860x_charger.c
+++ b/drivers/power/88pm860x_charger.c
@@ -296,12 +296,13 @@ static int set_charging_fsm(struct pm860x_charger_info *info)
 	psy = power_supply_get_by_name(pm860x_supplied_to[0]);
 	if (!psy)
 		return -EINVAL;
-	ret = psy->get_property(psy, POWER_SUPPLY_PROP_VOLTAGE_NOW, &data);
+	ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_VOLTAGE_NOW,
+			&data);
 	if (ret)
 		return ret;
 	vbatt = data.intval / 1000;
 
-	ret = psy->get_property(psy, POWER_SUPPLY_PROP_PRESENT, &data);
+	ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_PRESENT, &data);
 	if (ret)
 		return ret;
 
@@ -430,7 +431,7 @@ static irqreturn_t pm860x_temp_handler(int irq, void *data)
 	psy = power_supply_get_by_name(pm860x_supplied_to[0]);
 	if (!psy)
 		goto out;
-	ret = psy->get_property(psy, POWER_SUPPLY_PROP_TEMP, &temp);
+	ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_TEMP, &temp);
 	if (ret)
 		goto out;
 	value = temp.intval / 10;
@@ -485,7 +486,8 @@ static irqreturn_t pm860x_done_handler(int irq, void *data)
 	psy = power_supply_get_by_name(pm860x_supplied_to[0]);
 	if (!psy)
 		goto out;
-	ret = psy->get_property(psy, POWER_SUPPLY_PROP_VOLTAGE_NOW, &val);
+	ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_VOLTAGE_NOW,
+			&val);
 	if (ret)
 		goto out;
 	vbatt = val.intval / 1000;
@@ -500,7 +502,8 @@ static irqreturn_t pm860x_done_handler(int irq, void *data)
 	if (ret < 0)
 		goto out;
 	if (vbatt > CHARGE_THRESHOLD && ret & STATUS2_CHG)
-		psy->set_property(psy, POWER_SUPPLY_PROP_CHARGE_FULL, &val);
+		power_supply_set_property(psy, POWER_SUPPLY_PROP_CHARGE_FULL,
+				&val);
 
 out:
 	mutex_unlock(&info->lock);
-- 
1.9.1

