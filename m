Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340AbaJNMhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:37:13 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12285 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297AbaJNMhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:37:07 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-60-543d18f18860
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, Pavel Machek <pavel@ucw.cz>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 5/7] power: 88pm860x_charger: Decrement the power supply's
 device reference counter
Date: Tue, 14 Oct 2014 14:35:15 +0200
Message-id: <1413290117-13082-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413290117-13082-1-git-send-email-k.kozlowski@samsung.com>
References: <1413290117-13082-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t/xK7ofJWxDDGaf4LE4uFXTYuOM9awW
	S5oyLCY9ec9sMXHlZGaLaRvFLV6/MLRYtvgpo8XZpjfsFve/HmW0mPJnOZPFpsfXWC0u75rD
	ZvG59wijxcelG1gt1h65y25x6cACJou7p46yWTxe8Zbd4nQ3q8Xp3SUWmzdNZbb4seExq4O4
	x4T+T4weO2fdZfdYsKnUY/MKLY/Fe14yeWxa1cnmcefaHjaPd+fOsXvMOxnosXlJvcfHp7dY
	PN7vu8rm0bdlFaPHitXf2T0+b5LzONHyhTVAIIrLJiU1J7MstUjfLoEr49aqBWwFU7grTl6x
	amBcyNnFyMkhIWAisX3GFzYIW0ziwr31QDYXh5DAUkaJtplPWCGcPiaJju3HGEGq2ASMJTYv
	XwJWJSKwiVVi24oFTCAOs8B1RonVV2+zg1QJC6RKvL7/F2wui4CqxNZzu5hAbF4Bd4mn73cx
	QuyTkzh5bDLQCg4OTgEPiYm71EBMIaCSWc9kJzDyLmBkWMUomlqaXFCclJ5rpFecmFtcmpeu
	l5yfu4kREk9fdzAuPWZ1iFGAg1GJh7cg0iZEiDWxrLgy9xCjBAezkgivAodtiBBvSmJlVWpR
	fnxRaU5q8SFGJg5OqQZGDYWLy63Yr0zLnJAismU219laqWkGp/T7ri4UneO76lFNudK86lSm
	c+xFaarOBzPlly9f1eb07O77m0Kb91t8nDh/wuu5mS7L1womteqWlsRM27k47FDNx6fxi5tL
	LFbOenNcN+bg+t32HLe2Ghb88rXZFmydlq1pfvIbX8huBnkmjnqdR1k6SizFGYmGWsxFxYkA
	fO+KO4UCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use power_supply_put() to decrement the power supply's device reference
counter.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/power/88pm860x_charger.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/power/88pm860x_charger.c b/drivers/power/88pm860x_charger.c
index 534b3e2e3487..48aa0d829cb0 100644
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

