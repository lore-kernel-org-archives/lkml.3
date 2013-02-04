Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab3BDMOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:14:39 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:63854 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab3BDL4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:56:11 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 12/73] regulator: core: Show consumers that hold a regulator in Sysfs
Date: Mon,  4 Feb 2013 11:53:27 +0000
Message-Id: <1359978868-28736-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To locate the consumers that currently hold a regulator we're
creating a new sysfs entry. The consumers are published in
/sys/class/regulator/regulator.<#>/use

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/core.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 2785843..81212c7 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -85,6 +85,7 @@ struct regulator {
 	struct device_attribute dev_attr;
 	struct regulator_dev *rdev;
 	struct dentry *debugfs;
+	int use;
 };
 
 static int _regulator_is_enabled(struct regulator_dev *rdev);
@@ -614,6 +615,33 @@ static ssize_t regulator_bypass_show(struct device *dev,
 static DEVICE_ATTR(bypass, 0444,
 		   regulator_bypass_show, NULL);
 
+static ssize_t regulator_use_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
+	struct regulator *reg;
+	size_t size = 0;
+
+	if (rdev->use_count == 0)
+		return sprintf(buf, "no users\n");
+
+	list_for_each_entry(reg, &rdev->consumer_list, list) {
+		if (!reg->use)
+			continue;
+
+		if (reg->dev != NULL)
+			size += sprintf((buf + size), "%s (%d) ",
+					dev_name(reg->dev), reg->use);
+		else
+			size += sprintf((buf + size), "unknown (%d) ",
+					reg->use);
+	}
+	size += sprintf((buf + size), "\n");
+
+	return size;
+}
+static DEVICE_ATTR(use, 0444, regulator_use_show, NULL);
+
 /*
  * These are the only attributes are present for all regulators.
  * Other attributes are a function of regulator functionality.
@@ -1564,6 +1592,8 @@ int regulator_enable(struct regulator *regulator)
 
 	if (ret != 0 && rdev->supply)
 		regulator_disable(rdev->supply);
+	else
+		regulator->use++;
 
 	return ret;
 }
@@ -1656,6 +1686,9 @@ int regulator_disable(struct regulator *regulator)
 	if (ret == 0 && rdev->supply)
 		regulator_disable(rdev->supply);
 
+	if (ret == 0)
+		regulator->use--;
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_disable);
@@ -3190,6 +3223,10 @@ static int add_regulator_attributes(struct regulator_dev *rdev)
 	struct regulator_ops	*ops = rdev->desc->ops;
 	int			status = 0;
 
+	status = device_create_file(dev, &dev_attr_use);
+	if (status < 0)
+		return status;
+
 	/* some attributes need specific methods to be displayed */
 	if ((ops->get_voltage && ops->get_voltage(rdev) >= 0) ||
 	    (ops->get_voltage_sel && ops->get_voltage_sel(rdev) >= 0) ||
-- 
1.7.9.5

