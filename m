Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbbAGNvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 08:51:38 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53590 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbAGNvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 08:51:36 -0500
From: Ashay Jaiswal <ashayj@codeaurora.org>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Anirudh Ghayal <aghayal@codeaurora.org>,
        Ashay Jaiswal <ashayj@codeaurora.org>
Subject: [PATCH] regulator: core: fix race condition in regulator_put()
Date: Wed,  7 Jan 2015 19:21:23 +0530
Message-Id: <1420638683-20216-1-git-send-email-ashayj@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator framework maintains a list of consumer regulators
for a regulator device and protects it from concurrent access
using the regulator device's mutex lock.

In the case of regulator_put() the consumer is removed without
holding the regulator device's mutex, resulting in a race condition
between any regulator operation which traverses the consumer list
and regulator_put() which releases the consumer regulator.
Fix this race condition by holding the regulator device's mutex while
removing and releasing the consumer regulator.

Signed-off-by: Ashay Jaiswal <ashayj@codeaurora.org>
---
 drivers/regulator/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c2554d8..3845397 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1498,6 +1498,7 @@ static void _regulator_put(struct regulator *regulator)

 	rdev = regulator->rdev;

+	mutex_lock(&rdev->mutex);
 	debugfs_remove_recursive(regulator->debugfs);

 	/* remove any sysfs entries */
@@ -1511,6 +1512,7 @@ static void _regulator_put(struct regulator *regulator)
 	rdev->exclusive = 0;

 	module_put(rdev->owner);
+	mutex_unlock(&rdev->mutex);
 }

 /**
--
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
