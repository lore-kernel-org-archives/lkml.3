Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbaDBOQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:16:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47089 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932120AbaDBOQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:16:24 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: [PATCH] regulator: core: Get and put regulator of_node
Date: Wed,  2 Apr 2014 15:06:54 +0100
Message-Id: <1396447614-3048-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should be incrementing the reference count of the of_node for the
regulator when we take a copy of it. This patch does so.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index afca1bc..e26372a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3433,7 +3433,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 
 	/* register with sysfs */
 	rdev->dev.class = &regulator_class;
-	rdev->dev.of_node = config->of_node;
+	rdev->dev.of_node = of_node_get(config->of_node);
 	rdev->dev.parent = dev;
 	dev_set_name(&rdev->dev, "regulator.%d",
 		     atomic_inc_return(&regulator_no) - 1);
@@ -3575,6 +3575,7 @@ void regulator_unregister(struct regulator_dev *rdev)
 	list_del(&rdev->list);
 	kfree(rdev->constraints);
 	regulator_ena_gpio_free(rdev);
+	of_node_put(rdev->dev.of_node);
 	device_unregister(&rdev->dev);
 	mutex_unlock(&regulator_list_mutex);
 }
-- 
1.7.2.5

