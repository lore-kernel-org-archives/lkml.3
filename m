Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbbA0Lau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 06:30:50 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:34633 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757867AbbA0Lam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 06:30:42 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-f7-54c7764ccc6b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Artamonow <mad_soft@inbox.ru>, Marek Belisko <marek@goldelico.com>,
        Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
        Darren Hart <dvhart@infradead.org>, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [RFT PATCH 4/4] power_supply: ipaq_micro_battery: Check return values
 in probe
Date: Tue, 27 Jan 2015 12:30:21 +0100
Message-id: <1422358221-13199-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1422358221-13199-1-git-send-email-k.kozlowski@samsung.com>
References: <1422358221-13199-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t/xK7o+ZcdDDPa1m1ssOdHNYjHpyXtm
	i66FBhYTV05mtnj9wtDi8q45bBafe48wWmxvO8pi8W/pFjaL1XteMFuc3l1isWDjI0YHHo+d
	s+6ye6x5f4rZ49i1Oywem1doeWxa1cnm0bdlFaPH501yAexRXDYpqTmZZalF+nYJXBkXT7IX
	bBeqmL3vD1sD43H+LkZODgkBE4nlp9tYIGwxiQv31rN1MXJxCAksZZR49egfE4TTxySx+MlO
	VpAqNgFjic3Ll4BViQi0MEvsXHgKrJ1ZwFPi3d+H7CC2sECkxOt5xxhBbBYBVYkjHV3MXYwc
	HLwC7hKb1kVBbJOTOHlsMthMTgEPiV/r94KNEQIquTL9PMsERt4FjAyrGEVTS5MLipPSc430
	ihNzi0vz0vWS83M3MUJC8usOxqXHrA4xCnAwKvHwJpQcDxFiTSwrrsw9xCjBwawkwusVARTi
	TUmsrEotyo8vKs1JLT7EyMTBKdXAuIqpW5JJas9mv73bNIQOzGmKYt2wWH7enR+Rjn1CX1uU
	407m8TkdFumLaWir/d32pVfgQsmsU7c+qCnzrFs/ZUVk4RE/S6bXcouWzdqm9N/IjkemfPKu
	7Mob6cmb56wx7mkLLLyec7HreNzK48nLyv0PLXkTejfUYbaWY5jmnY/8a6VVjtvKKLEUZyQa
	ajEXFScCAAq/8u0nAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return values of create_singlethread_workqueue() and
power_supply_register() calls were not checked and even on error probe()
function returned 0.

1. If allocation of workqueue failed (returning NULL) then further
   accesses could lead to NULL pointer dereference. The
   queue_delayed_work() expects workqueue to be non-NULL.

2. If registration of power supply failed then during unbind the driver
   tried to unregister power supply which was not actually registered.
   This could lead to memory corruption because
   power_supply_unregister() unconditionally cleans up given power
   supply.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: 00a588f9d27f ("power: add driver for battery reading on iPaq h3xxx")
Cc: <stable@vger.kernel.org>
---
 drivers/power/ipaq_micro_battery.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/power/ipaq_micro_battery.c b/drivers/power/ipaq_micro_battery.c
index 698cf1636bb8..96b15e003f3f 100644
--- a/drivers/power/ipaq_micro_battery.c
+++ b/drivers/power/ipaq_micro_battery.c
@@ -226,6 +226,7 @@ static struct power_supply micro_ac_power = {
 static int micro_batt_probe(struct platform_device *pdev)
 {
 	struct micro_battery *mb;
+	int ret;
 
 	mb = devm_kzalloc(&pdev->dev, sizeof(*mb), GFP_KERNEL);
 	if (!mb)
@@ -233,14 +234,30 @@ static int micro_batt_probe(struct platform_device *pdev)
 
 	mb->micro = dev_get_drvdata(pdev->dev.parent);
 	mb->wq = create_singlethread_workqueue("ipaq-battery-wq");
+	if (!mb->wq)
+		return -ENOMEM;
+
 	INIT_DELAYED_WORK(&mb->update, micro_battery_work);
 	platform_set_drvdata(pdev, mb);
 	queue_delayed_work(mb->wq, &mb->update, 1);
-	power_supply_register(&pdev->dev, &micro_batt_power);
-	power_supply_register(&pdev->dev, &micro_ac_power);
+
+	ret = power_supply_register(&pdev->dev, &micro_batt_power);
+	if (ret < 0)
+		goto batt_err;
+
+	ret = power_supply_register(&pdev->dev, &micro_ac_power);
+	if (ret < 0)
+		goto ac_err;
 
 	dev_info(&pdev->dev, "iPAQ micro battery driver\n");
 	return 0;
+
+ac_err:
+	power_supply_unregister(&micro_ac_power);
+batt_err:
+	cancel_delayed_work_sync(&mb->update);
+	destroy_workqueue(mb->wq);
+	return ret;
 }
 
 static int micro_batt_remove(struct platform_device *pdev)
-- 
1.9.1

