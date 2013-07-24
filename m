Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab3GXWNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:13:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab3GXWGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:06:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 18/36] regulator: convert class code to use dev_groups
Date: Wed, 24 Jul 2013 15:05:21 -0700
Message-Id: <1374703539-9705-19-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the regulator class code to use
the correct field.

Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Mark, feel free to take this through your tree, or ACK it and I can take it
through mine.

 drivers/regulator/core.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 288c75ab..e75ed1ef 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -323,13 +323,14 @@ static ssize_t regulator_uA_show(struct device *dev,
 }
 static DEVICE_ATTR(microamps, 0444, regulator_uA_show, NULL);
 
-static ssize_t regulator_name_show(struct device *dev,
-			     struct device_attribute *attr, char *buf)
+static ssize_t name_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
 {
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%s\n", rdev_get_name(rdev));
 }
+static DEVICE_ATTR_RO(name);
 
 static ssize_t regulator_print_opmode(char *buf, int mode)
 {
@@ -489,15 +490,16 @@ static ssize_t regulator_total_uA_show(struct device *dev,
 }
 static DEVICE_ATTR(requested_microamps, 0444, regulator_total_uA_show, NULL);
 
-static ssize_t regulator_num_users_show(struct device *dev,
-				      struct device_attribute *attr, char *buf)
+static ssize_t num_users_show(struct device *dev, struct device_attribute *attr,
+			      char *buf)
 {
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
 	return sprintf(buf, "%d\n", rdev->use_count);
 }
+static DEVICE_ATTR_RO(num_users);
 
-static ssize_t regulator_type_show(struct device *dev,
-				  struct device_attribute *attr, char *buf)
+static ssize_t type_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
 {
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
@@ -509,6 +511,7 @@ static ssize_t regulator_type_show(struct device *dev,
 	}
 	return sprintf(buf, "unknown\n");
 }
+static DEVICE_ATTR_RO(type);
 
 static ssize_t regulator_suspend_mem_uV_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -632,12 +635,13 @@ static DEVICE_ATTR(bypass, 0444,
  * These are the only attributes are present for all regulators.
  * Other attributes are a function of regulator functionality.
  */
-static struct device_attribute regulator_dev_attrs[] = {
-	__ATTR(name, 0444, regulator_name_show, NULL),
-	__ATTR(num_users, 0444, regulator_num_users_show, NULL),
-	__ATTR(type, 0444, regulator_type_show, NULL),
-	__ATTR_NULL,
+static struct attribute *regulator_dev_attrs[] = {
+	&dev_attr_name.attr,
+	&dev_attr_num_users.attr,
+	&dev_attr_type.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(regulator_dev);
 
 static void regulator_dev_release(struct device *dev)
 {
@@ -648,7 +652,7 @@ static void regulator_dev_release(struct device *dev)
 static struct class regulator_class = {
 	.name = "regulator",
 	.dev_release = regulator_dev_release,
-	.dev_attrs = regulator_dev_attrs,
+	.dev_groups = regulator_dev_groups,
 };
 
 /* Calculate the new optimum regulator operating mode based on the new total
-- 
1.8.3.rc0.20.gb99dd2e

