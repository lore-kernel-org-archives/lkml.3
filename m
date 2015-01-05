Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbbAEPt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:49:26 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56286 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbbAEPsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:48:31 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-d1-54aab24a215d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCHv2 16/19] power: 88pm860x_charger: Decrement the power
 supply's device reference counter
Date: Mon, 05 Jan 2015 16:47:59 +0100
Message-id: <1420472882-10463-17-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
References: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsVy+t/xa7pem1aFGNzvVLeY9OQ9s8XElZOZ
	LV6/MLTY+fAtm8Xyff2MFpseX2O1uLxrDpvF594jjBZ3Tx1lszhz+hKrxendJQ7cHjtn3WX3
	2LxCy2PTqk42j81L6j22XG1n8ejbsorRY8Xq7+wenzfJBXBEcdmkpOZklqUW6dslcGV8W7iN
	qWA3d0XD5wtMDYyHObsYOTkkBEwktk9/wwJhi0lcuLeerYuRi0NIYCmjxOZ73YwQTh+TxMT9
	78Cq2ASMJTYvXwJWJSLwhElieutJsASzgKHEz3d/2EFsYYFciRPT+oC6OThYBFQl1s9VBQnz
	CnhI9HQeY4PYJidx8thkVhCbEyje9PcC2BghAXeJD89+sU5g5F3AyLCKUTS1NLmgOCk910iv
	ODG3uDQvXS85P3cTIyQov+5gXHrM6hCjAAejEg+vx4mVIUKsiWXFlbmHGCU4mJVEeF+lrwoR
	4k1JrKxKLcqPLyrNSS0+xMjEwSnVwLhocsEr6Ydtm0336F0oeiHxyePRa7Hf0iwuVx8J7A3m
	1/cXv3Pxtc2vFSlyQa9XFbXHfVvn28UpmT5j3YXS2X45Zw5fXXCq763KXWHDVV1uqcvW/TuS
	Lcd9VeRdZcIMDfvTN39cPXtw8uVZLzYdkvwv9tjyv/TqLVYbf687FBcsnGG5OLnrX/xKJZbi
	jERDLeai4kQAmTpP3CgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use power_supply_put() to decrement the power supply's device reference
counter.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/power/88pm860x_charger.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/power/88pm860x_charger.c b/drivers/power/88pm860x_charger.c
index 59d62665b526..f88caee01ee9 100644
--- a/drivers/power/88pm860x_charger.c
+++ b/drivers/power/88pm860x_charger.c
@@ -298,13 +298,18 @@ static int set_charging_fsm(struct pm860x_charger_info *info)
 		return -EINVAL;
 	ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_VOLTAGE_NOW,
 			&data);
-	if (ret)
+	if (ret) {
+		power_supply_put(psy);
 		return ret;
+	}
 	vbatt = data.intval / 1000;
 
 	ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_PRESENT, &data);
-	if (ret)
+	if (ret) {
+		power_supply_put(psy);
 		return ret;
+	}
+	power_supply_put(psy);
 
 	mutex_lock(&info->lock);
 	info->present = data.intval;
@@ -447,6 +452,7 @@ static irqreturn_t pm860x_temp_handler(int irq, void *data)
 
 	set_charging_fsm(info);
 out:
+	power_supply_put(psy);
 	return IRQ_HANDLED;
 }
 
@@ -507,6 +513,7 @@ static irqreturn_t pm860x_done_handler(int irq, void *data)
 
 out:
 	mutex_unlock(&info->lock);
+	power_supply_put(psy);
 	dev_dbg(info->dev, "%s, Allowed: %d\n", __func__, info->allowed);
 	set_charging_fsm(info);
 
-- 
1.9.1

