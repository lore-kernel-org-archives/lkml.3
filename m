Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaEZHQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 03:16:29 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25204 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaEZHQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 03:16:27 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-fc-5382ea48e15f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Cc: Libo Chen <clbchenlibo.chen@huawei.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RESEND PATCH 1/2] power: max8925: Fix NULL ptr dereference on memory
 allocation failure
Date: Mon, 26 May 2014 09:16:10 +0200
Message-id: <1401088571-4407-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJMWRmVeSWpSXmKPExsVy+t/xy7oer5qCDRr/8Foc3KppMfnWXjaL
	SU/eM1tMXDmZ2eL1C0OLy7vmsDmweUzo/8TosXPWXXaPliNvWT02r9Dy6NuyitHj8ya5ALYo
	LpuU1JzMstQifbsErozn95+xFZzgqvixu5exgbGZs4uRk0NCwERiV/NHVghbTOLCvfVsXYxc
	HEICSxklprzoZYVw+pgk1s1ezARSxSZgLLF5+RI2EFtEoFLi2+kTLCBFzAJNjBJNb/8zgiSE
	BZIlVs++D1bEIqAqcX/+ZLA4r4CbxMeWyVDr5CROHpvMOoGRewEjwypG0dTS5ILipPRcQ73i
	xNzi0rx0veT83E2MkBD5soNx8TGrQ4wCHIxKPLwngpqChVgTy4orcw8xSnAwK4nwXsgFCvGm
	JFZWpRblxxeV5qQWH2Jk4uCUamBcYN6wfJG60PmD3C0e2RfMp+66v2+Hvf7l5/NlHTlvsNs8
	1eS4XvziwLb9ZQemvr2yvs/r98Qwx4ee3GXZt6eJqfNHMk36r+HmcenyxuX7IlJvN+n/2LTc
	xWODmrlj+nyzEK2ZNmXHjnD+m8Z6SCrC//pen/yvX+aX/FIt+Hqs3fVPgY767GUaSizFGYmG
	WsxFxYkAD57jYu8BAAA=
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

