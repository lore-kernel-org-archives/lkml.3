Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbaJQPRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:17:12 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:43598 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaJQPRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 11:17:11 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH] regulator: Ensure unique regulator debugfs directory names
Date: Fri, 17 Oct 2014 08:17:03 -0700
Message-Id: <1413559023-18293-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If multiple regulator devices of the same type exist in a system,
the regulator driver assigns generic names for the regulators it
provides, and debugfs is enabled, the regulator subsystem attempts
to create multiple entries with the same name in the regulator debugfs
directory. This fails for all but the first regulator, resulting in
multiple "Failed to create debugfs directory" log entries.

To avoid the problem, prepend the debugfs directory name for a regulator
with its parent device name if available, but only if no explicit
regulator name was provided.

Cc: Alan Tull <atull@opensource.altera.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/regulator/core.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index cd87c0c..92f7a53 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3538,7 +3538,18 @@ static int add_regulator_attributes(struct regulator_dev *rdev)
 
 static void rdev_init_debugfs(struct regulator_dev *rdev)
 {
-	rdev->debugfs = debugfs_create_dir(rdev_get_name(rdev), debugfs_root);
+	struct device *parent = rdev->dev.parent;
+	const char *rname = rdev_get_name(rdev);
+	char name[NAME_MAX];
+
+	/* Avoid duplicate debugfs directory names */
+	if (parent && rname == rdev->desc->name) {
+		snprintf(name, sizeof(name), "%s-%s", dev_name(parent),
+			 rname);
+		rname = name;
+	}
+
+	rdev->debugfs = debugfs_create_dir(rname, debugfs_root);
 	if (!rdev->debugfs) {
 		rdev_warn(rdev, "Failed to create debugfs directory\n");
 		return;
-- 
1.9.1

