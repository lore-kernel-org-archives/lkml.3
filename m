Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbaDDHv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:51:56 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60589 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbaDDHvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:51:50 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-81-533e64947df4
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/2] power: max8925: Fix NULL ptr dereference on memory
 allocation failure
Date: Fri, 04 Apr 2014 09:51:41 +0200
Message-id: <1396597902-2371-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGJMWRmVeSWpSXmKPExsVy+t/xq7pTUuyCDd69FrGY9OQ9s8XElZOZ
	LV6/MLS4vGsOmwOLx85Zd9k9Nq/Q8ujbsorR4/MmuQCWKC6blNSczLLUIn27BK6MqW82shac
	5ar4cPUlWwNjK2cXIyeHhICJxN+bC1kgbDGJC/fWs3UxcnEICSxllLix5DsjhNPHJNF3pp8d
	pIpNwFhi8/IlbCC2iEClxLfTJ8C6mQUMJX6++wNWIywQI/H4fh9zFyMHB4uAqsSNzXogYV4B
	N4m186aygYQlBBQk5kyymcDIvYCRYRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGiN+/7mBc
	eszqEKMAB6MSDy9Hum2wEGtiWXFl7iFGCQ5mJRHevkC7YCHelMTKqtSi/Pii0pzU4kOMTByc
	Ug2MvLbhnh8tbb+eXJKgWbBP5vSfpf4rzbc84bu2cMGz5zy7piWvtlHbflX2FUdzf80EkfKv
	/yIF+404NiTvuXDJoSr6e+2Ux3l3DvmL+N9ivNG4YU2Ni+DGv+pLZ+6faLvgTK9tc8amja62
	DaEl+3Jmtgu8mynzJ0C8/+SMCVsv7TnKd6sqluudgRJLcUaioRZzUXEiAG72z4DZAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check the return value of devm_kzalloc() to fix possible NULL pointer
dereference and properly exit the probe() on memory allocation failure.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/power/max8925_power.c |    5 ++++-
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
1.7.9.5

