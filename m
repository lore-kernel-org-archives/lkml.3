Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab3CALYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 06:24:24 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:21192 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3CALYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 06:24:23 -0500
X-AuditID: cbfec7f5-b7fd76d000007247-d2-51308fe59f90
From: Andrzej Hajda <a.hajda@samsung.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] regulator: fixed regulator_bulk_enable unwinding code
Date: Fri, 01 Mar 2013 12:24:05 +0100
Message-id: <1362137045-25600-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLJMWRmVeSWpSXmKPExsVy+t/xa7pP+w0CDe5c1LS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZu1Y9Yyw4xV7x9sRX5gbGeWxdjJwcEgImEmenbWeHsMUkLtxb
	DxTn4hASWMoocanhDCOEs55J4sWX9WAdbAKaEn833wSzRQRCJJquTmUCKWIWaGSUmLbpGjNI
	QljATeLusi4wm0VAVeL43BMsIDavgLPE5FvLmSDWKUp0P5vANoGRewEjwypG0dTS5ILipPRc
	I73ixNzi0rx0veT83E2MEC9+3cG49JjVIUYBDkYlHt7AKv1AIdbEsuLK3EOMEhzMSiK8/xsN
	AoV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwrnB4KxZi2ywpJNatdvvQt+uHvBaxZjaICt3Lj7rr
	/uhHk1zktDmfixtvJaecnnfv3s6eNfl/G/V+pL8s8vvlqRCntKQ06Mf0e5mNV5cy3WtWY/iz
	ynvK/GeGr53Xs7F/nVSycUGVRVem9yzd1ZtLYw5fjreJ4NwiPXlfl3TbDLHc/j3FARbRSizF
	GYmGWsxFxYkAP8klT8ABAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unwinding code disables all successfully enabled regulators.
Error is logged for every failed regulator.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/core.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 2785843..90af271 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3032,9 +3032,13 @@ int regulator_bulk_enable(int num_consumers,
 	return 0;
 
 err:
-	pr_err("Failed to enable %s: %d\n", consumers[i].supply, ret);
-	while (--i >= 0)
-		regulator_disable(consumers[i].consumer);
+	for (i = 0; i < num_consumers; i++) {
+		if (consumers[i].ret < 0)
+			pr_err("Failed to enable %s: %d\n", consumers[i].supply,
+			       consumers[i].ret);
+		else
+			regulator_disable(consumers[i].consumer);
+	}
 
 	return ret;
 }
-- 
1.7.10.4

