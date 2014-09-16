Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaIPQKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:10:53 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41488 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbaIPQKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:10:52 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-e1-54186109de90
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND 1/2] power: max8925: Fix NULL ptr dereference on memory
 allocation failure
Date: Tue, 16 Sep 2014 18:10:40 +0200
Message-id: <1410883841-8276-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOJMWRmVeSWpSXmKPExsVy+t/xy7qciRIhBo3flS0mPXnPbDFx5WRm
	i9cvDC0u75rDZvG59wijxendJQ5sHjtn3WX32LxCy2PTqk42j74tqxg9Pm+SC2CN4rJJSc3J
	LEst0rdL4Mp4fv8ZW8EJroofu3sZGxibObsYOTkkBEwkTre3MUPYYhIX7q1n62Lk4hASWMoo
	8ez8dSYIp49JorH3FCtIFZuAscTm5UvAqkQEdjNKTJi6nAUkwSxgKPHz3R92EFtYIFniy4+f
	YDaLgKrEpkXzwWxeATeJlbv/MUGsk5M4eWwy6wRG7gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS
	9ZLzczcxQgLjyw7GxcesDjEKcDAq8fBm/BMPEWJNLCuuzD3EKMHBrCTC+8NXIkSINyWxsiq1
	KD++qDQntfgQIxMHp1QD41JuB7s0S9ZDE2KfnIi0PZa94C3jyymlZZ4WP+Qnv7/80d+I6ZRX
	w/UtE5U/xXzcc+3uH1Xjpr+8HP7/FrFcmyj76mZjQ2qgltbB3nv1Sw8J+UyfXu2ZKJ1iXDtf
	7CgH1/66LzHhMosyhdliFs2JZV52Yfmmrcvjgycs2/sge836/IOOt4Rd5imxFGckGmoxFxUn
	AgB+qqde6gEAAA==
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

