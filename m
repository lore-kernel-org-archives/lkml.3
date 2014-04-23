Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbaDWM0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:26:09 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52062 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaDWM0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:26:06 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-dd-5357b15cedbb
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Libo Chen <clbchenlibo.chen@huawei.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND 1/2] power: max8925: Fix NULL ptr dereference on memory
 allocation failure
Date: Wed, 23 Apr 2014 14:26:03 +0200
Message-id: <1398255964-389-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t/xq7oxG8ODDY4+VrA4uFXTYvKtvWwW
	k568Z7aYuHIys8W5iZ3MFq9fGFpc3jWHzYHdY0L/J0aPnbPusnu0HHnL6rF5hZbH5IUXmT36
	tqxi9Pi8SS6APYrLJiU1J7MstUjfLoEr4/n9Z2wFJ7gqfuzuZWxgbObsYuTkkBAwkbjwag4j
	hC0mceHeerYuRi4OIYGljBLv955igXD6mCQOXIaoYhMwlti8fAkbiC0iUCnx7fQJsCJmgfWM
	Eo0r9rGCJIQFkiW+/PjJDmKzCKhKvPy6F8zmFXCVeLzuH9Q6OYmTxyazTmDkXsDIsIpRNLU0
	uaA4KT3XSK84Mbe4NC9dLzk/dxMjJGy+7mBceszqEKMAB6MSD6/E8rBgIdbEsuLK3EOMEhzM
	SiK8SxaFBwvxpiRWVqUW5ccXleakFh9iZOLglGpgFLzLa7tr36utBVFzjcSvbuJcK2276rOG
	9QQ39b/Rczb/e7zo2LYZJ9S+2P1Y+JDvgd6lwqzrz1ov+gks5ba4Erp1zX+HjfNnRan8mz3L
	d/4bvtKvU/qPvKv4mHEx0ztQQlefQyUq9MpJ7hVL8j8E7O/fze3VY9x7pyiB7Z1NyV359H/f
	5jprrFRiKc5INNRiLipOBAABTAJE+QEAAA==
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

