Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaGBJSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:18:14 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22523 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaGBJSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 05:18:12 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-98-53b3ce52e9b4
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton@enomsg.org>
Cc: Philip Rakity <prakity@marvell.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND 1/2] power: max8925: Fix NULL ptr dereference on memory
 allocation failure
Date: Wed, 02 Jul 2014 11:17:53 +0200
Message-id: <1404292674-5260-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJMWRmVeSWpSXmKPExsVy+t/xy7pB5zYHGxy/z2txcKumxaQn75kt
	Jq6czGzx+oWhxeVdc9gs5q9+wujA5jGh/xOjx85Zd9k9Nq/Q8pi88CKzR9+WVYwenzfJBbBF
	cdmkpOZklqUW6dslcGU8v/+MreAEV8WP3b2MDYzNnF2MnBwSAiYS7fvWsUHYYhIX7q0Hsrk4
	hASWMkr86b/BBOH0MUlMuP6UCaSKTcBYYvPyJWBVIgLzGSWmH5wO1s4sECHx/thfMFtYIFni
	y4+f7F2MHBwsAqoSu3dZgIR5Bdwkdq39xg6xTU7i5LHJrBMYuRcwMqxiFE0tTS4oTkrPNdIr
	TswtLs1L10vOz93ECAmQrzsYlx6zOsQowMGoxMP7Qn9TsBBrYllxZe4hRgkOZiUR3kdnNgcL
	8aYkVlalFuXHF5XmpBYfYmTi4JRqYCw7H6GhtGxS0/aAA2yvud2ehvesar7weOFrzcPaFWI8
	Ctw6/xK61zf/8Y7ZPcNq4lyRrI8nbm/eXbCwpGhChUL20W3R17ftZJZftEV33eoJ6zQr2YJS
	HseHMs1dEsRq6Jeo36Yb/P9g6HbbvvOnJfbXTUnf5H+KY7+S6NnrLe6dUXn/u/+1nFNiKc5I
	NNRiLipOBAC7GLJP7gEAAA==
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

