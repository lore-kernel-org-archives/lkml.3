Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbbAHNYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 08:24:47 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54639 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbbAHNYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 08:24:46 -0500
From: Ashay Jaiswal <ashayj@codeaurora.org>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Anirudh Ghayal <aghayal@codeaurora.org>,
        David Collins <collinsd@codeaurora.org>,
        Ashay Jaiswal <ashayj@codeaurora.org>
Subject: [PATCH v2] regulator: core: fix race condition in regulator_put()
Date: Thu,  8 Jan 2015 18:54:25 +0530
Message-Id: <1420723465-12045-1-git-send-email-ashayj@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator framework maintains a list of consumer regulators
for a regulator device and protects it from concurrent access using
the regulator device's mutex lock.

In the case of regulator_put() the consumer is removed and regulator
device's parameters are updated without holding the regulator device's
mutex. This would lead to a race condition between the regulator_put()
and any function which traverses the consumer list or modifies regulator
device's parameters.
Fix this race condition by holding the regulator device's mutex in case
of regulator_put.

Signed-off-by: Ashay Jaiswal <ashayj@codeaurora.org>
---
 Changes:
 V1-->V2:
	- Updated comment on top of _regulator_put function
	- Updated lock region

 drivers/regulator/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c2554d8..f70a02c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1488,7 +1488,7 @@ struct regulator *regulator_get_optional(struct device *dev, const char *id)
 }
 EXPORT_SYMBOL_GPL(regulator_get_optional);

-/* Locks held by regulator_put() */
+/* regulator_list_mutex lock held by regulator_put() */
 static void _regulator_put(struct regulator *regulator)
 {
 	struct regulator_dev *rdev;
@@ -1503,12 +1503,14 @@ static void _regulator_put(struct regulator *regulator)
 	/* remove any sysfs entries */
 	if (regulator->dev)
 		sysfs_remove_link(&rdev->dev.kobj, regulator->supply_name);
+	mutex_lock(&rdev->mutex);
 	kfree(regulator->supply_name);
 	list_del(&regulator->list);
 	kfree(regulator);

 	rdev->open_count--;
 	rdev->exclusive = 0;
+	mutex_unlock(&rdev->mutex);

 	module_put(rdev->owner);
 }
--
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

