Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3LQMub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:50:31 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:62654 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab3LQMu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:50:27 -0500
From: Laszlo Papp <lpapp@kde.org>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: linux-kernel@vger.kernel.org, Laszlo Papp <lpapp@kde.org>
Subject: [PATCH] mfd: max8997: Enforce mfd_add_devices() return value check
Date: Tue, 17 Dec 2013 12:45:50 +0000
Message-Id: <1387284350-28524-1-git-send-email-lpapp@kde.org>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original author provided a random return value check which is
redundant and seemingly floating. This patch not only relocates
the check so it is more clearly associated with the invokation of
mfd_add_devices(), but provides a store for the error value. We
also print a meaningful message on error before returning.

Signed-off-by: Laszlo Papp <lpapp@kde.org>
---
 drivers/mfd/max8997.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index 791aea3..ace1a2b 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -227,19 +227,19 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 	pm_runtime_set_active(max8997->dev);
 
 	max8997_irq_init(max8997);
-
-	mfd_add_devices(max8997->dev, -1, max8997_devs,
+	ret = mfd_add_devices(max8997->dev, -1, max8997_devs,
 			ARRAY_SIZE(max8997_devs),
 			NULL, 0, NULL);
+	if (ret < 0) {
+		dev_err(max8997->dev, "cannot add mfd cells\n");
+		goto err_mfd;
+	}
 
 	/*
 	 * TODO: enable others (flash, muic, rtc, battery, ...) and
 	 * check the return value
 	 */
 
-	if (ret < 0)
-		goto err_mfd;
-
 	/* MAX8997 has a power button input. */
 	device_init_wakeup(max8997->dev, pdata->wakeup);
 
-- 
1.8.5.1

