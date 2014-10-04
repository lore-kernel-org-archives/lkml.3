Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaJDXbb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 19:31:31 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:39314 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaJDXb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 19:31:28 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] power: ab8500_fg: Fix build warning
Date: Sat,  4 Oct 2014 16:31:13 -0700
Message-Id: <1412465473-13495-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix

drivers/power/ab8500_fg.c: In function 'ab8500_fg_probe':
drivers/power/ab8500_fg.c:2989:27:
		warning: 'i' may be used uninitialized in this function
drivers/power/ab8500_fg.c:2972:15: note: 'i' was declared here

which actually points to a real bug.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/power/ab8500_fg.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 3cb4178..217da4b 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2969,7 +2969,7 @@ static struct device_attribute ab8505_fg_sysfs_psy_attrs[] = {
 
 static int ab8500_fg_sysfs_psy_create_attrs(struct device *dev)
 {
-	unsigned int i, j;
+	unsigned int i;
 	struct power_supply *psy = dev_get_drvdata(dev);
 	struct ab8500_fg *di;
 
@@ -2978,14 +2978,15 @@ static int ab8500_fg_sysfs_psy_create_attrs(struct device *dev)
 	if (((is_ab8505(di->parent) || is_ab9540(di->parent)) &&
 	     abx500_get_chip_id(dev->parent) >= AB8500_CUT2P0)
 	    || is_ab8540(di->parent)) {
-		for (j = 0; j < ARRAY_SIZE(ab8505_fg_sysfs_psy_attrs); j++)
-			if (device_create_file(dev, &ab8505_fg_sysfs_psy_attrs[j]))
+		for (i = 0; i < ARRAY_SIZE(ab8505_fg_sysfs_psy_attrs); i++)
+			if (device_create_file(dev,
+					       &ab8505_fg_sysfs_psy_attrs[i]))
 				goto sysfs_psy_create_attrs_failed_ab8505;
 	}
 	return 0;
 sysfs_psy_create_attrs_failed_ab8505:
 	dev_err(dev, "Failed creating sysfs psy attrs for ab8505.\n");
-	while (j--)
+	while (i--)
 		device_remove_file(dev, &ab8505_fg_sysfs_psy_attrs[i]);
 
 	return -EIO;
-- 
1.9.1

