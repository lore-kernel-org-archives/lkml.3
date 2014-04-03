Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaDCOlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:41:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50292 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752374AbaDCOlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:41:08 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: [PATCH 3/3] regulator: core: Get and put regulator of_node
Date: Thu,  3 Apr 2014 15:32:17 +0100
Message-Id: <1396535537-1352-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1396535537-1352-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1396535537-1352-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the regulator core does not take an additional reference to
the of_node it is passed. This means that the caller must ensure that
the of_node is valid for the duration of the regulator's existance.
It is reasonable for the framework to assume it is passed a valid
of_node but seems onerous for it to assume the caller will keep the node
valid for the life-time of the regulator, especially when
devm_regulator_register is used and there will likely be no code in the
driver called at the point it would be safe to put the of_node.

This patch adds an additional of_node_get when the regulator is
registered and an of_node_put when it is unregistered in the core. This
means individual drivers are free to put their of_node references at the
end of probe letting the regulator core handling it from there. This
simplifies code on the driver side.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index bac485a..5a673f6 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3447,7 +3447,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 
 	/* register with sysfs */
 	rdev->dev.class = &regulator_class;
-	rdev->dev.of_node = config->of_node;
+	rdev->dev.of_node = of_node_get(config->of_node);
 	rdev->dev.parent = dev;
 	dev_set_name(&rdev->dev, "regulator.%d",
 		     atomic_inc_return(&regulator_no) - 1);
@@ -3589,6 +3589,7 @@ void regulator_unregister(struct regulator_dev *rdev)
 	list_del(&rdev->list);
 	kfree(rdev->constraints);
 	regulator_ena_gpio_free(rdev);
+	of_node_put(rdev->dev.of_node);
 	device_unregister(&rdev->dev);
 	mutex_unlock(&regulator_list_mutex);
 }
-- 
1.7.2.5

