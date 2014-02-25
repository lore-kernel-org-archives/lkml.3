Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbaBYLZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:25:11 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:42029 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaBYLZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:25:09 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, philippe.retornaz@epfl.ch,
        sachin.kamat@linaro.org
Subject: [PATCH 1/1] regulator: mc13xxx: Fix NULL pointer error in non-DT mode
Date: Tue, 25 Feb 2014 16:49:27 +0530
Message-Id: <1393327167-8526-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a check to avoid NULL pointer dereference error when
booted in non-DT mode. While at it also remove the additional
of_node_get which is no longer needed for of_get_child_by_name
and fix the node pointer.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Reported-by: Philippe Rétornaz <philippe.retornaz@epfl.ch>
---
 drivers/regulator/mc13xxx-regulator-core.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index 4498a3f0733d..bf75fcabfa3c 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -167,8 +167,10 @@ int mc13xxx_get_num_regulators_dt(struct platform_device *pdev)
 	struct device_node *parent;
 	int num;
 
-	of_node_get(pdev->dev.parent->of_node);
-	parent = of_get_child_by_name(pdev->dev.parent->of_node, "regulators");
+	if (!pdev->dev.of_node)
+		return -ENODEV;
+
+	parent = of_get_child_by_name(pdev->dev.of_node, "regulators");
 	if (!parent)
 		return -ENODEV;
 
@@ -187,8 +189,10 @@ struct mc13xxx_regulator_init_data *mc13xxx_parse_regulators_dt(
 	struct device_node *parent, *child;
 	int i, parsed = 0;
 
-	of_node_get(pdev->dev.parent->of_node);
-	parent = of_get_child_by_name(pdev->dev.parent->of_node, "regulators");
+	if (!pdev->dev.of_node)
+		return NULL;
+
+	parent = of_get_child_by_name(pdev->dev.of_node, "regulators");
 	if (!parent)
 		return NULL;
 
-- 
1.7.9.5

