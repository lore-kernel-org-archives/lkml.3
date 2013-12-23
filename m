Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab3LWOo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 09:44:57 -0500
Received: from mail-qe0-f41.google.com ([209.85.128.41]:46040 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab3LWOo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 09:44:56 -0500
From: Fabio Estevam <festevam@gmail.com>
To: broonie@kernel.org
Cc: shawn.guo@linaro.org, Anson.Huang@freescale.com,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v3 1/2] regulator: anatop-regulator: Fix the error handling on probe
Date: Mon, 23 Dec 2013 12:44:40 -0200
Message-Id: <1387809881-16092-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Currently when of_get_parent() or syscon_node_to_regmap() fail 
'kfree(sreg->name)' is not called, which is incorrect.

Fix this by jumping to 'anatop_probe_end' instead.

While at it, make 'anatop_probe_end' to be executed only on the error path, so
that the code can be a bit easier to follow.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v2:
- Fix the error path for of_get_parent() or syscon_node_to_regmap().

 drivers/regulator/anatop-regulator.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index c734d09..88d95cd 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -132,12 +132,16 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 	rdesc->owner = THIS_MODULE;
 
 	anatop_np = of_get_parent(np);
-	if (!anatop_np)
-		return -ENODEV;
+	if (!anatop_np) {
+		ret = -ENODEV;
+		goto anatop_probe_end;
+	}
 	sreg->anatop = syscon_node_to_regmap(anatop_np);
 	of_node_put(anatop_np);
-	if (IS_ERR(sreg->anatop))
-		return PTR_ERR(sreg->anatop);
+	if (IS_ERR(sreg->anatop)) {
+		ret = PTR_ERR(sreg->anatop);
+		goto anatop_probe_end;
+	}
 
 	ret = of_property_read_u32(np, "anatop-reg-offset",
 				   &sreg->control_reg);
@@ -210,9 +214,10 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, rdev);
 
+	return 0;
+
 anatop_probe_end:
-	if (ret)
-		kfree(sreg->name);
+	kfree(sreg->name);
 
 	return ret;
 }
-- 
1.8.1.2

