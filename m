Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbaIIJrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:47:31 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:65252 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbaIIJr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:47:29 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-1e-540eccaf1a1f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RESEND PATCH 1/2] power: max8925: Fix NULL ptr dereference on memory
 allocation failure
Date: Tue, 09 Sep 2014 11:47:14 +0200
Message-id: <1410256035-24051-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOJMWRmVeSWpSXmKPExsVy+t/xa7rrz/CFGBz6LGwx6cl7ZouJKycz
	W7x+YWhxedccNovPvUcYLU7vLnFg89g56y67x+YVWh6bVnWyefRtWcXo8XmTXABrFJdNSmpO
	Zllqkb5dAlfG8/vP2ApOcFX82N3L2MDYzNnFyMkhIWAiserLTCYIW0ziwr31bF2MXBxCAksZ
	JU7sP8IC4fQxSZx49pkVpIpNwFhi8/IlYFUiArsZJSZMXc4CkmAWMJT4+e4PO4gtLJAssXr2
	fTYQm0VAVeLp9COMIDavgLvE2cabUOvkJE4em8w6gZF7ASPDKkbR1NLkguKk9FwjveLE3OLS
	vHS95PzcTYyQwPi6g3HpMatDjAIcjEo8vBPL+EKEWBPLiitzDzFKcDArifDuPggU4k1JrKxK
	LcqPLyrNSS0+xMjEwSnVwJiX9tMkdtM+bakrH1591jnUyXHhu09Ro+e7ZvF6ay0d21px5XVR
	kZEXPVWm/I4/XeSqWP/5VM7FV8GPlmSK53Q/+V3W8+zJw2tL1a4lMG3o/vA/MvND3c2tXz7u
	rA4y+r/mT8CanRvuXt3cd6WHc5W6ztTnh0ylI/9f+bKFccN828X35qnLFf1QYinOSDTUYi4q
	TgQAIlRK9+oBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check the return value of devm_kzalloc() to fix possible NULL pointer
dereference and properly exit the probe() on memory allocation failure.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/power/max8925_power.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
index b4513f284bbc..0cf237808d47 100644
--- a/drivers/power/max8925_power.c
+++ b/drivers/power/max8925_power.c
@@ -452,13 +452,14 @@ max8925_power_dt_init(struct platform_device *pdev)
 	pdata = devm_kzalloc(&pdev->dev,
 			sizeof(struct max8925_power_pdata),
 			GFP_KERNEL);
+	if (!pdata)
+		goto ret;
 
 	of_property_read_u32(np, "topoff-threshold", &topoff_threshold);
 	of_property_read_u32(np, "batt-detect", &batt_detect);
 	of_property_read_u32(np, "fast-charge", &fast_charge);
 	of_property_read_u32(np, "no-insert-detect", &no_insert_detect);
 	of_property_read_u32(np, "no-temp-support", &no_temp_support);
-	of_node_put(np);
 
 	pdata->batt_detect = batt_detect;
 	pdata->fast_charge = fast_charge;
@@ -466,6 +467,8 @@ max8925_power_dt_init(struct platform_device *pdev)
 	pdata->no_insert_detect = no_insert_detect;
 	pdata->no_temp_support = no_temp_support;
 
+ret:
+	of_node_put(np);
 	return pdata;
 }
 #else
-- 
1.9.1

