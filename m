Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3IWUfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:35:01 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:58125 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab3IWUe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:34:59 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>, Fenghua Yu <fenghua.yu@intel.com>
Cc: "Artem S. Tashkinov" <t.artem@mailcity.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v5 1/2] hwmon: (coretemp) Rename temp_data to core_data
Date: Mon, 23 Sep 2013 13:34:48 -0700
Message-Id: <1379968489-13781-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are going to use the data structure for power data as well.

Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v5: Merged to 3.12-rc1

 drivers/hwmon/coretemp.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 78be661..38d458b 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -76,11 +76,11 @@ MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
  * @status_reg: One of IA32_THERM_STATUS or IA32_PACKAGE_THERM_STATUS,
  *		from where the temperature values should be read.
  * @attr_size:  Total number of pre-core attrs displayed in the sysfs.
- * @is_pkg_data: If this is 1, the temp_data holds pkgtemp data.
- *		Otherwise, temp_data holds coretemp data.
- * @valid: If this is 1, the current temperature is valid.
+ * @is_pkg_data: If this is true, the core_data holds pkgtemp data.
+ *		Otherwise, core_data holds coretemp data.
+ * @valid: If this is true, the current temperature is valid.
  */
-struct temp_data {
+struct core_data {
 	int temp;
 	int ttarget;
 	int tjmax;
@@ -100,7 +100,7 @@ struct temp_data {
 struct platform_data {
 	struct device *hwmon_dev;
 	u16 phys_proc_id;
-	struct temp_data *core_data[MAX_CORE_DATA];
+	struct core_data *core_data[MAX_CORE_DATA];
 	struct device_attribute name_attr;
 };
 
@@ -124,7 +124,7 @@ static ssize_t show_label(struct device *dev,
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct platform_data *pdata = dev_get_drvdata(dev);
-	struct temp_data *tdata = pdata->core_data[attr->index];
+	struct core_data *tdata = pdata->core_data[attr->index];
 
 	if (tdata->is_pkg_data)
 		return sprintf(buf, "Physical id %u\n", pdata->phys_proc_id);
@@ -138,7 +138,7 @@ static ssize_t show_crit_alarm(struct device *dev,
 	u32 eax, edx;
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct platform_data *pdata = dev_get_drvdata(dev);
-	struct temp_data *tdata = pdata->core_data[attr->index];
+	struct core_data *tdata = pdata->core_data[attr->index];
 
 	rdmsr_on_cpu(tdata->cpu, tdata->status_reg, &eax, &edx);
 
@@ -169,7 +169,7 @@ static ssize_t show_temp(struct device *dev,
 	u32 eax, edx;
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct platform_data *pdata = dev_get_drvdata(dev);
-	struct temp_data *tdata = pdata->core_data[attr->index];
+	struct core_data *tdata = pdata->core_data[attr->index];
 
 	mutex_lock(&tdata->update_lock);
 
@@ -377,7 +377,7 @@ static int create_name_attr(struct platform_data *pdata,
 	return device_create_file(dev, &pdata->name_attr);
 }
 
-static int create_core_attrs(struct temp_data *tdata, struct device *dev,
+static int create_core_attrs(struct core_data *tdata, struct device *dev,
 			     int attr_no)
 {
 	int err, i;
@@ -444,11 +444,11 @@ static struct platform_device *coretemp_get_pdev(unsigned int cpu)
 	return NULL;
 }
 
-static struct temp_data *init_temp_data(unsigned int cpu, int pkg_flag)
+static struct core_data *init_core_data(unsigned int cpu, bool pkg_flag)
 {
-	struct temp_data *tdata;
+	struct core_data *tdata;
 
-	tdata = kzalloc(sizeof(struct temp_data), GFP_KERNEL);
+	tdata = kzalloc(sizeof(struct core_data), GFP_KERNEL);
 	if (!tdata)
 		return NULL;
 
@@ -463,9 +463,9 @@ static struct temp_data *init_temp_data(unsigned int cpu, int pkg_flag)
 }
 
 static int create_core_data(struct platform_device *pdev, unsigned int cpu,
-			    int pkg_flag)
+			    bool pkg_flag)
 {
-	struct temp_data *tdata;
+	struct core_data *tdata;
 	struct platform_data *pdata = platform_get_drvdata(pdev);
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	u32 eax, edx;
@@ -492,7 +492,7 @@ static int create_core_data(struct platform_device *pdev, unsigned int cpu,
 	if (pdata->core_data[attr_no] != NULL)
 		return 0;
 
-	tdata = init_temp_data(cpu, pkg_flag);
+	tdata = init_core_data(cpu, pkg_flag);
 	if (!tdata)
 		return -ENOMEM;
 
@@ -533,7 +533,7 @@ exit_free:
 	return err;
 }
 
-static void coretemp_add_core(unsigned int cpu, int pkg_flag)
+static void coretemp_add_core(unsigned int cpu, bool pkg_flag)
 {
 	struct platform_device *pdev = coretemp_get_pdev(cpu);
 	int err;
@@ -550,7 +550,7 @@ static void coretemp_remove_core(struct platform_data *pdata,
 				struct device *dev, int indx)
 {
 	int i;
-	struct temp_data *tdata = pdata->core_data[indx];
+	struct core_data *tdata = pdata->core_data[indx];
 
 	/* Remove the sysfs attributes */
 	for (i = 0; i < tdata->attr_size; i++)
@@ -723,13 +723,13 @@ static void get_core_online(unsigned int cpu)
 		 * If so, add interfaces for pkgtemp.
 		 */
 		if (cpu_has(c, X86_FEATURE_PTS))
-			coretemp_add_core(cpu, 1);
+			coretemp_add_core(cpu, true);
 	}
 	/*
 	 * Physical CPU device already exists.
 	 * So, just add interfaces for this core.
 	 */
-	coretemp_add_core(cpu, 0);
+	coretemp_add_core(cpu, false);
 }
 
 static void put_core_offline(unsigned int cpu)
-- 
1.7.9.7

