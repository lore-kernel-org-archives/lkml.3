Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab3BUH42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 02:56:28 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18955 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3BUH41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 02:56:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 20 Feb 2013 23:55:45 -0800
From: Shawn Joo <sjoo@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>
CC: <sjoo@nvidia.com>
Subject: [PATCH] regulator: core: use regulator name for sysfs
Date: Thu, 21 Feb 2013 16:53:57 +0900
Message-ID: <1361433237-3217-1-git-send-email-sjoo@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regulator is named by numbering on sysfs, e.g. regulator.0, regulator.1
it confuses to find desired regulator before counting the order.
add option for regulator name by use_name_onsysfs.
if it is true and name is not NULL, desc's name will be the name.
e.g. if name in desc is "LDO0", then regulator.LDO0 on sysfs.
otherwise it follows origin.

Signed-off-by: Shawn Joo <sjoo@nvidia.com>
---
 drivers/regulator/core.c         |    7 ++++++-
 include/linux/regulator/driver.h |    1 +
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 2785843..4dde54d 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3399,7 +3399,12 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	rdev->dev.class = &regulator_class;
 	rdev->dev.of_node = config->of_node;
 	rdev->dev.parent = dev;
-	dev_set_name(&rdev->dev, "regulator.%d",
+	if (regulator_desc->use_name_onsysfs &&
+			regulator_desc->name != NULL)
+		dev_set_name(&rdev->dev, "regulator.%s",
+			regulator_desc->name);
+	else
+		dev_set_name(&rdev->dev, "regulator.%d",
 		     atomic_inc_return(&regulator_no) - 1);
 	ret = device_register(&rdev->dev);
 	if (ret != 0) {
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index d10bb0f..597f8dd 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -224,6 +224,7 @@ struct regulator_desc {
 	unsigned int bypass_mask;
 
 	unsigned int enable_time;
+	bool use_name_onsysfs;
 };
 
 /**
-- 
1.7.0.4

