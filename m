Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab3AVJqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:46:33 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:51935 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab3AVJqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:46:30 -0500
Date: Tue, 22 Jan 2013 09:46:24 +0000
From: Lee Jones <lee.jones@linaro.org>
To: broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] regulator: Display in use regulators in sysfs
Message-ID: <20130122094624.GJ6857@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please excuse any poor formatting that may occur, as this is
copy-paste into my mailer, but what do you think of this idea?

To locate a consumer that currently holds a regulattor, a new sysfs
entry is created. The consumer are published in
/sys/class/regulator/regulator.<#>/use.

---
 drivers/regulator/core.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 046fb1b..40fd150 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -81,6 +81,7 @@ struct regulator {
   struct device_attribute dev_attr;
   struct regulator_dev *rdev;
   struct dentry *debugfs;
+  int use;
 };
 
 static int _regulator_is_enabled(struct regulator_dev *rdev);
@@ -602,6 +603,32 @@ static ssize_t
regulator_suspend_standby_state_show(struct device *dev,
 static DEVICE_ATTR(suspend_standby_state, 0444,
 					   regulator_suspend_standby_state_show,
					   NULL);
 
+static ssize_t regulator_use_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
+	struct regulator *reg;
+	size_t size = 0;
+
+	if (rdev->use_count == 0)
+	        return sprintf(buf, "no users\n");
+
+	list_for_each_entry(reg, &rdev->consumer_list, list) {
+		if (!reg->use)
+		        continue;
+
+		if (reg->dev != NULL)
+		   	size += sprintf((buf + size), "%s (%d) ",
+                                       dev_name(reg->dev), reg->use);
+		else
+			size += sprintf((buf + size), "unknown (%d) ",
+				                 reg->use);
+	}
+	size += sprintf((buf + size), "\n");
+
+	return size;
+}
+static DEVICE_ATTR(use, 0444, regulator_use_show, NULL);
 
 /*
  * These are the only attributes are present for all regulators.
@@ -1540,6 +1567,8 @@ int regulator_enable(struct regulator
*regulator)
 
	if (ret != 0 && rdev->supply)
 	        regulator_disable(rdev->supply);
+	else
+		regulator->use++;
 
	return ret;
 }
@@ -1613,6 +1642,9 @@ int regulator_disable(struct regulator
*regulator)
	if (ret == 0 && rdev->supply)
 	   regulator_disable(rdev->supply);
 
+	if (ret == 0)
+	        regulator->use--;
+
	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_disable);
@@ -2699,6 +2731,10 @@ static int add_regulator_attributes(struct
                                                           regulator_dev *rdev)
 	      struct regulator_ops	*ops = rdev->desc->ops;
 	      int    			     status = 0;
 
+	status = device_create_file(dev, &dev_attr_use);
+	if (status < 0)
+	        dev_warn(dev, "Create sysfs file \"use\" failed");
+
	/* some attributes need specific methods to be displayed */
 	if ((ops->get_voltage && ops->get_voltage(rdev) >= 0) ||
 	    (ops->get_voltage_sel && ops->get_voltage_sel(rdev) >= 0))
	        {

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
