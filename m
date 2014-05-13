Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221AbaEMQTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:19:01 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:32883 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760488AbaEMQSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:18:52 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>
Subject: [PATCH] of/selftest: clean-up of_selftest_platform_populate pass/fail handling
Date: Tue, 13 May 2014 11:18:28 -0500
Message-Id: <1399997908-30916-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Move the pass/fail checks into selftest() calls instead of a separate if
condition. Unconditionally calling pass was wrong.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/selftest.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
index fe70b86..c1d7d38 100644
--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@ -440,22 +440,18 @@ static void __init of_selftest_platform_populate(void)
 	/* Test that a missing irq domain returns -EPROBE_DEFER */
 	np = of_find_node_by_path("/testcase-data/testcase-device1");
 	pdev = of_find_device_by_node(np);
-	if (!pdev)
-		selftest(0, "device 1 creation failed\n");
+	selftest(pdev, "device 1 creation failed\n");
+
 	irq = platform_get_irq(pdev, 0);
-	if (irq != -EPROBE_DEFER)
-		selftest(0, "device deferred probe failed - %d\n", irq);
+	selftest(irq == -EPROBE_DEFER, "device deferred probe failed - %d\n", irq);
 
 	/* Test that a parsing failure does not return -EPROBE_DEFER */
 	np = of_find_node_by_path("/testcase-data/testcase-device2");
 	pdev = of_find_device_by_node(np);
-	if (!pdev)
-		selftest(0, "device 2 creation failed\n");
+	selftest(pdev, "device 2 creation failed\n");
 	irq = platform_get_irq(pdev, 0);
-	if (irq >= 0 || irq == -EPROBE_DEFER)
-		selftest(0, "device parsing error failed - %d\n", irq);
+	selftest(irq < 0 && irq != -EPROBE_DEFER, "device parsing error failed - %d\n", irq);
 
-	selftest(1, "passed");
 }
 
 static int __init of_selftest(void)
-- 
1.9.1

