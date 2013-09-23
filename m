Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab3IWUfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:35:30 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:40560 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab3IWUf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:35:27 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>, Fenghua Yu <fenghua.yu@intel.com>
Cc: "Artem S. Tashkinov" <t.artem@mailcity.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v5 2/2] hwmon: (coretemp) Report power and energy consumption
Date: Mon, 23 Sep 2013 13:34:49 -0700
Message-Id: <1379968489-13781-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1379968489-13781-1-git-send-email-linux@roeck-us.net>
References: <1379968489-13781-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supported by SandyBridge and newer CPUs.

Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v5: Merged to 3.12-rc1
v4: Replaced INIT_DELAYED_WORK with INIT_DEFERRABLE_WORK
v3: Added Cc:
v2: Fix missing symbol error on i386 builds
    Dropped leftover pr_info from debugging

I am inclined to drop this patch set, as I received neither test nor code
review feedback even though the patch set has been out there for a long time.
Also, I am concerned that it overlaps or even conflicts with the proposed
Power Cap/RAPL driver (https://lkml.org/lkml/2013/9/19/260).

Consider this to be a Last Call.

 Documentation/hwmon/coretemp |   16 ++
 drivers/hwmon/coretemp.c     |  386 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 376 insertions(+), 26 deletions(-)

diff --git a/Documentation/hwmon/coretemp b/Documentation/hwmon/coretemp
index fec5a9b..cdb533d 100644
--- a/Documentation/hwmon/coretemp
+++ b/Documentation/hwmon/coretemp
@@ -43,6 +43,22 @@ tempX_crit_alarm - Set when Out-of-spec bit is set, never clears.
 tempX_label	 - Contains string "Core X", where X is processor
 		   number. For Package temp, this will be "Physical id Y",
 		   where Y is the package number.
+energy1_input	 - Package energy consumption since driver was loaded
+power1_cap	 - Package power limit
+power1_input	 - Package power consumption
+power1_max	 - Maximum package power
+energy2_input	 - Cores energy consumption since driver was loaded
+power2_cap	 - Cores power limit
+power2_input	 - Cores power consumption
+energy3_input	 - Graphics domain energy consumption since driver was loaded
+power3_cap	 - Graphics domain power limit
+power3_input	 - Graphics domain power consumption
+energy4_input	 - DRAM domain energy consumption since driver was loaded
+power4_cap	 - DRAM domain power limit
+power4_input	 - DRAM domain power consumption
+
+Graphics and DRAM power domains are not supported on all chip variants.
+powerX_cap is only reported if enabled.
 
 On CPU models which support it, TjMax is read from a model-specific register.
 On other models, it is set to an arbitrary value based on weak heuristics.
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 38d458b..d79fc8c 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -54,6 +54,7 @@ MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
 #define NUM_REAL_CORES		32	/* Number of Real cores per cpu */
 #define CORETEMP_NAME_LENGTH	17	/* String Length of attrs */
 #define MAX_CORE_ATTRS		4	/* Maximum no of basic attrs */
+#define MAX_POWER_ATTRS		6	/* Maximum no of power attrs */
 #define TOTAL_ATTRS		(MAX_CORE_ATTRS + 1)
 #define MAX_CORE_DATA		(NUM_REAL_CORES + BASE_SYSFS_ATTR_NO)
 
@@ -67,6 +68,36 @@ MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
 #define for_each_sibling(i, cpu)	for (i = 0; false; )
 #endif
 
+#define RAPL_PKG_INDEX		0
+#define RAPL_CORE_INDEX		1
+#define RAPL_GFX_INDEX		2
+#define RAPL_DRAM_INDEX		3
+#define RAPL_DOMAINS		(RAPL_DRAM_INDEX + 1)
+
+#define HAS_RAPL_PKG		(1 << RAPL_PKG_INDEX)
+#define HAS_RAPL_CORE		(1 << RAPL_CORE_INDEX)
+
+static const u32 power_limit_msr[] = {
+	MSR_PKG_POWER_LIMIT,
+	MSR_PP0_POWER_LIMIT,
+	MSR_PP1_POWER_LIMIT,
+	MSR_DRAM_POWER_LIMIT,
+};
+
+static const u32 energy_status_msr[] = {
+	MSR_PKG_ENERGY_STATUS,
+	MSR_PP0_ENERGY_STATUS,
+	MSR_PP1_ENERGY_STATUS,
+	MSR_DRAM_ENERGY_STATUS,
+};
+
+static const u32 power_info_msr[] = {
+	MSR_PKG_POWER_INFO,
+	0,
+	0,
+	MSR_DRAM_POWER_INFO,
+};
+
 /*
  * Per-Core Temperature Data
  * @last_updated: The time when the current temperature value was updated
@@ -75,10 +106,20 @@ MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
  *		This value is passed as "id" field to rdmsr/wrmsr functions.
  * @status_reg: One of IA32_THERM_STATUS or IA32_PACKAGE_THERM_STATUS,
  *		from where the temperature values should be read.
- * @attr_size:  Total number of pre-core attrs displayed in the sysfs.
+ * @attr_size:  Total number of per-core attrs displayed in the sysfs.
  * @is_pkg_data: If this is true, the core_data holds pkgtemp data.
  *		Otherwise, core_data holds coretemp data.
  * @valid: If this is true, the current temperature is valid.
+ * @rapl:		Bit mask or supported RAPL (energy measurement) domains
+ * @rapl_attr_mask:	Masks for enabled power attributes per domain
+ * @rapl_timestamp:	Last time energy/power was retrieved
+ * @rapl_power_units:	Units of power as reported by the chip
+ * @rapl_energy_units:	Units of energy as reported by the chip
+ * @rapl_energy_raw:	Most recent energy measurement (raw) per domain
+ * @rapl_energy:	cumulative energy (mJ) per domain
+ * @rapl_power:		current power usage (mW) per domain
+ * @rapl_power_max:	maximum power (TDP, mW) per domain as reported
+ *			by the chip
  */
 struct core_data {
 	int temp;
@@ -91,9 +132,24 @@ struct core_data {
 	int attr_size;
 	bool is_pkg_data;
 	bool valid;
-	struct sensor_device_attribute sd_attrs[TOTAL_ATTRS];
+	struct sensor_device_attribute_2 sd_attrs[TOTAL_ATTRS];
 	char attr_name[TOTAL_ATTRS][CORETEMP_NAME_LENGTH];
 	struct mutex update_lock;
+	/* power/energy */
+	struct sensor_device_attribute_2 sd_power_attrs[MAX_POWER_ATTRS
+							* RAPL_DOMAINS];
+	char power_attr_name[MAX_POWER_ATTRS * RAPL_DOMAINS]
+			    [CORETEMP_NAME_LENGTH];
+	u32 rapl;
+	u32 rapl_attr_mask[RAPL_DOMAINS];
+	unsigned long rapl_timestamp;
+	u32 rapl_power_units;
+	u32 rapl_energy_units;
+	u32 rapl_energy_raw[RAPL_DOMAINS];
+	u64 rapl_energy[RAPL_DOMAINS];
+	u32 rapl_power[RAPL_DOMAINS];
+	u32 rapl_power_max[RAPL_DOMAINS];
+	struct delayed_work rapl_wq;
 };
 
 /* Platform Data per Physical CPU */
@@ -122,7 +178,7 @@ static ssize_t show_name(struct device *dev,
 static ssize_t show_label(struct device *dev,
 				struct device_attribute *devattr, char *buf)
 {
-	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
 	struct platform_data *pdata = dev_get_drvdata(dev);
 	struct core_data *tdata = pdata->core_data[attr->index];
 
@@ -132,11 +188,34 @@ static ssize_t show_label(struct device *dev,
 	return sprintf(buf, "Core %u\n", tdata->cpu_core_id);
 }
 
+static const char * const power_domains[] = {
+	"Pkg",
+	"Cores",
+	"Graphics",
+	"DRAM",
+};
+
+static ssize_t show_power_label(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
+
+	return sprintf(buf, "%s power\n", power_domains[attr->nr]);
+}
+
+static ssize_t show_energy_label(struct device *dev,
+				 struct device_attribute *devattr, char *buf)
+{
+	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
+
+	return sprintf(buf, "%s energy\n", power_domains[attr->nr]);
+}
+
 static ssize_t show_crit_alarm(struct device *dev,
 				struct device_attribute *devattr, char *buf)
 {
 	u32 eax, edx;
-	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
 	struct platform_data *pdata = dev_get_drvdata(dev);
 	struct core_data *tdata = pdata->core_data[attr->index];
 
@@ -148,7 +227,7 @@ static ssize_t show_crit_alarm(struct device *dev,
 static ssize_t show_tjmax(struct device *dev,
 			struct device_attribute *devattr, char *buf)
 {
-	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
 	struct platform_data *pdata = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%d\n", pdata->core_data[attr->index]->tjmax);
@@ -157,7 +236,7 @@ static ssize_t show_tjmax(struct device *dev,
 static ssize_t show_ttarget(struct device *dev,
 				struct device_attribute *devattr, char *buf)
 {
-	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
 	struct platform_data *pdata = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%d\n", pdata->core_data[attr->index]->ttarget);
@@ -167,7 +246,7 @@ static ssize_t show_temp(struct device *dev,
 			struct device_attribute *devattr, char *buf)
 {
 	u32 eax, edx;
-	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
 	struct platform_data *pdata = dev_get_drvdata(dev);
 	struct core_data *tdata = pdata->core_data[attr->index];
 
@@ -190,6 +269,58 @@ static ssize_t show_temp(struct device *dev,
 	return tdata->valid ? sprintf(buf, "%d\n", tdata->temp) : -EAGAIN;
 }
 
+static ssize_t show_power(struct device *dev,
+			  struct device_attribute *devattr, char *buf)
+{
+	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
+	struct platform_data *pdata = dev_get_drvdata(dev);
+	struct core_data *tdata = pdata->core_data[attr->index];
+
+	return sprintf(buf, "%u\n", tdata->rapl_power[attr->nr] * 1000);
+}
+
+static ssize_t show_power_max(struct device *dev,
+			      struct device_attribute *devattr, char *buf)
+{
+	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
+	struct platform_data *pdata = dev_get_drvdata(dev);
+	struct core_data *tdata = pdata->core_data[attr->index];
+
+	return sprintf(buf, "%u\n", tdata->rapl_power_max[attr->nr] * 1000);
+}
+
+static ssize_t show_power_cap(struct device *dev,
+			      struct device_attribute *devattr, char *buf)
+{
+	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
+	struct platform_data *pdata = dev_get_drvdata(dev);
+	struct core_data *tdata = pdata->core_data[attr->index];
+	u32 eax, edx;
+	u64 cap;
+
+	rdmsr_on_cpu(tdata->cpu, power_limit_msr[attr->nr], &eax, &edx);
+
+	/* Report lowest configured cap limit */
+	cap = (eax & 0x8000) ? (eax & 0x7fff) : 0;
+	if (attr->nr && (edx & 0x8000) && (!(eax & 0x8000) ||
+					   (edx & 0x7fff) < cap))
+		cap = edx & 0x7fff;
+
+	cap = (cap * 1000000LL) >> tdata->rapl_power_units;
+
+	return sprintf(buf, "%llu\n", cap);
+}
+
+static ssize_t show_energy(struct device *dev,
+			   struct device_attribute *devattr, char *buf)
+{
+	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
+	struct platform_data *pdata = dev_get_drvdata(dev);
+	struct core_data *tdata = pdata->core_data[attr->index];
+
+	return sprintf(buf, "%llu\n", tdata->rapl_energy[attr->nr] * 1000ULL);
+}
+
 struct tjmax {
 	char const *id;
 	int tjmax;
@@ -377,10 +508,55 @@ static int create_name_attr(struct platform_data *pdata,
 	return device_create_file(dev, &pdata->name_attr);
 }
 
-static int create_core_attrs(struct core_data *tdata, struct device *dev,
-			     int attr_no)
+static void remove_core_files(struct device *dev, struct core_data *tdata)
 {
-	int err, i;
+	int d, i;
+
+	for (i = 0; i < tdata->attr_size; i++)
+		device_remove_file(dev, &tdata->sd_attrs[i].dev_attr);
+
+	if (!tdata->is_pkg_data)
+		return;
+
+	for (d = 0; d < RAPL_DOMAINS; d++) {
+		if (!(tdata->rapl & (1 << d)))
+			continue;
+		for (i = 0; i < MAX_POWER_ATTRS; i++) {
+			int index = d * MAX_POWER_ATTRS + i;
+
+			if (!(tdata->rapl_attr_mask[d] & (1 << i)))
+				continue;
+			device_remove_file(dev,
+					&tdata->sd_power_attrs[index].dev_attr);
+		}
+	}
+}
+
+static int create_core_attr(struct device *dev,
+			    struct sensor_device_attribute_2 *attr,
+			    char *attr_name,
+			    int index, int nr,
+			    ssize_t (*const rd_ptr)(struct device *,
+				struct device_attribute *, char *),
+			    const char *const template)
+{
+	int err;
+
+	snprintf(attr_name, CORETEMP_NAME_LENGTH, template, nr);
+	sysfs_attr_init(&attr->dev_attr.attr);
+	attr->dev_attr.attr.name = attr_name;
+	attr->dev_attr.attr.mode = S_IRUGO;
+	attr->dev_attr.show = rd_ptr;
+	attr->index = index;
+	attr->nr = nr - 1;
+	err = device_create_file(dev, &attr->dev_attr);
+	return err;
+}
+
+static int create_core_attrs(struct core_data *tdata,
+			     struct device *dev, int attr_no)
+{
+	int err, d, i;
 	static ssize_t (*const rd_ptr[TOTAL_ATTRS]) (struct device *dev,
 			struct device_attribute *devattr, char *buf) = {
 			show_label, show_crit_alarm, show_temp, show_tjmax,
@@ -389,24 +565,51 @@ static int create_core_attrs(struct core_data *tdata, struct device *dev,
 					"temp%d_label", "temp%d_crit_alarm",
 					"temp%d_input", "temp%d_crit",
 					"temp%d_max" };
+	static ssize_t (*const p_rd_ptr[MAX_POWER_ATTRS]) (struct device *dev,
+			struct device_attribute *devattr, char *buf) = {
+			show_energy_label, show_energy,
+			show_power_label, show_power, show_power_max,
+			show_power_cap };
+	static const char *const power_names[MAX_POWER_ATTRS] = {
+					"energy%d_label", "energy%d_input",
+					"power%d_label", "power%d_input",
+					"power%d_max", "power%d_cap" };
 
 	for (i = 0; i < tdata->attr_size; i++) {
-		snprintf(tdata->attr_name[i], CORETEMP_NAME_LENGTH, names[i],
-			attr_no);
-		sysfs_attr_init(&tdata->sd_attrs[i].dev_attr.attr);
-		tdata->sd_attrs[i].dev_attr.attr.name = tdata->attr_name[i];
-		tdata->sd_attrs[i].dev_attr.attr.mode = S_IRUGO;
-		tdata->sd_attrs[i].dev_attr.show = rd_ptr[i];
-		tdata->sd_attrs[i].index = attr_no;
-		err = device_create_file(dev, &tdata->sd_attrs[i].dev_attr);
+		err = create_core_attr(dev, &tdata->sd_attrs[i],
+				       tdata->attr_name[i],
+				       attr_no, attr_no,
+				       rd_ptr[i],
+				       names[i]);
 		if (err)
 			goto exit_free;
 	}
+	if (tdata->is_pkg_data) {
+		for (d = 0; d < RAPL_DOMAINS; d++) {
+			if (!(tdata->rapl & (1 << d)))
+				continue;
+			for (i = 0; i < MAX_POWER_ATTRS; i++) {
+				int index = d * MAX_POWER_ATTRS + i;
+
+				if (!(tdata->rapl_attr_mask[d] & (1 << i)))
+					continue;
+
+				err = create_core_attr(dev,
+					&tdata->sd_power_attrs[index],
+					tdata->power_attr_name[index],
+					attr_no, d + 1,
+					p_rd_ptr[i],
+					power_names[i]);
+				if (err)
+					goto exit_free;
+			}
+		}
+	}
+
 	return 0;
 
 exit_free:
-	while (--i >= 0)
-		device_remove_file(dev, &tdata->sd_attrs[i].dev_attr);
+	remove_core_files(dev, tdata);
 	return err;
 }
 
@@ -462,8 +665,83 @@ static struct core_data *init_core_data(unsigned int cpu, bool pkg_flag)
 	return tdata;
 }
 
-static int create_core_data(struct platform_device *pdev, unsigned int cpu,
-			    bool pkg_flag)
+static void coretemp_rapl_work(struct work_struct *work)
+{
+	struct core_data *tdata = container_of(work, struct core_data,
+					       rapl_wq.work);
+	u32 eax, edx;
+	u32 delta;
+	u32 power;
+	int d;
+	unsigned long elapsed = jiffies - tdata->rapl_timestamp;
+
+	for (d = 0; d < RAPL_DOMAINS; d++) {
+		if (!(tdata->rapl & (1 << d)))
+			continue;
+
+		rdmsr_on_cpu(tdata->cpu, energy_status_msr[d], &eax, &edx);
+		delta = eax - tdata->rapl_energy_raw[d];
+		power = (delta * 1000LL) >> tdata->rapl_energy_units;
+		tdata->rapl_energy_raw[d] = eax;
+		tdata->rapl_energy[d] += power;
+		if (elapsed)
+			power = DIV_ROUND_CLOSEST(power * HZ, elapsed);
+		tdata->rapl_power[d] = power;
+	}
+
+	tdata->rapl_timestamp = jiffies;
+	schedule_delayed_work(&tdata->rapl_wq, HZ);
+}
+
+static void coretemp_init_rapl(struct platform_device *pdev,
+			       int cpu, struct core_data *tdata)
+{
+	u32 eax, edx;
+	int d, err;
+
+	/* Test if we can access rapl registers */
+	err = rdmsr_safe_on_cpu(cpu, MSR_RAPL_POWER_UNIT, &eax, &edx);
+	if (err)
+		return;
+
+	tdata->rapl_power_units = eax & 0x000f;
+	tdata->rapl_energy_units = (eax >> 8) & 0x001f;
+
+	INIT_DEFERRABLE_WORK(&tdata->rapl_wq, coretemp_rapl_work);
+
+	tdata->rapl_timestamp = jiffies;
+
+	for (d = 0; d < RAPL_DOMAINS; d++) {
+		err = rdmsr_safe_on_cpu(cpu, energy_status_msr[d], &eax, &edx);
+		if (err)
+			continue;
+		tdata->rapl |= 1 << d;
+		tdata->rapl_energy_raw[d] = eax;
+		tdata->rapl_attr_mask[d] = BIT(0) | BIT(1) | BIT(2) | BIT(3);
+
+		/*
+		 * Only report power cap if supported for domain and enabled.
+		 * Note: package domain (index 0) has two cap limits.
+		 */
+		err = rdmsr_safe_on_cpu(tdata->cpu, power_limit_msr[d],
+					&eax, &edx);
+		if (!err && ((eax & 0x8000) || (d && (edx & 0x8000))))
+			tdata->rapl_attr_mask[d] |= BIT(5);
+
+		/* Only report max power if it exists for the domain */
+		if (!power_info_msr[d])
+			continue;
+		err = rdmsr_safe_on_cpu(cpu, power_info_msr[d], &eax, &edx);
+		if (err)
+			continue;
+		tdata->rapl_power_max[d] =
+			((eax & 0x7fff) * 1000) >> tdata->rapl_power_units;
+		tdata->rapl_attr_mask[d] |= BIT(4);
+	}
+}
+
+static int create_core_data(struct platform_device *pdev,
+			    unsigned int cpu, bool pkg_flag)
 {
 	struct core_data *tdata;
 	struct platform_data *pdata = platform_get_drvdata(pdev);
@@ -519,6 +797,9 @@ static int create_core_data(struct platform_device *pdev, unsigned int cpu,
 		}
 	}
 
+	if (tdata->is_pkg_data)
+		coretemp_init_rapl(pdev, cpu, tdata);
+
 	pdata->core_data[attr_no] = tdata;
 
 	/* Create sysfs interfaces */
@@ -526,6 +807,9 @@ static int create_core_data(struct platform_device *pdev, unsigned int cpu,
 	if (err)
 		goto exit_free;
 
+	if (tdata->rapl)
+		schedule_delayed_work(&tdata->rapl_wq, HZ);
+
 	return 0;
 exit_free:
 	pdata->core_data[attr_no] = NULL;
@@ -549,12 +833,12 @@ static void coretemp_add_core(unsigned int cpu, bool pkg_flag)
 static void coretemp_remove_core(struct platform_data *pdata,
 				struct device *dev, int indx)
 {
-	int i;
 	struct core_data *tdata = pdata->core_data[indx];
 
-	/* Remove the sysfs attributes */
-	for (i = 0; i < tdata->attr_size; i++)
-		device_remove_file(dev, &tdata->sd_attrs[i].dev_attr);
+	if (tdata->rapl)
+		cancel_delayed_work_sync(&tdata->rapl_wq);
+
+	remove_core_files(dev, tdata);
 
 	kfree(pdata->core_data[indx]);
 	pdata->core_data[indx] = NULL;
@@ -607,10 +891,60 @@ static int coretemp_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int coretemp_suspend(struct device *dev)
+{
+	struct platform_data *pdata = dev_get_drvdata(dev);
+	struct core_data *tdata;
+	int i;
+
+	for (i = 0; i < MAX_CORE_DATA; i++) {
+		tdata = pdata->core_data[i];
+		if (tdata && tdata->rapl)
+			cancel_delayed_work_sync(&tdata->rapl_wq);
+	}
+	return 0;
+}
+
+static int coretemp_resume(struct device *dev)
+{
+	struct platform_data *pdata = dev_get_drvdata(dev);
+	struct core_data *tdata;
+	int d, i;
+	u32 eax, edx;
+
+	for (i = 0; i < MAX_CORE_DATA; i++) {
+		tdata = pdata->core_data[i];
+		if (tdata && tdata->rapl) {
+			tdata->rapl_timestamp = jiffies;
+			for (d = 0; d < RAPL_DOMAINS; d++) {
+				if (!(tdata->rapl & (1 << d)))
+					continue;
+
+				rdmsr_on_cpu(tdata->cpu,
+					     energy_status_msr[d],
+					     &eax, &edx);
+				tdata->rapl_energy_raw[d] = eax;
+			}
+			schedule_delayed_work(&tdata->rapl_wq, HZ);
+		}
+	}
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(coretemp_dev_pm_ops, coretemp_suspend,
+			 coretemp_resume);
+
+#define CORETEMP_DEV_PM_OPS (&coretemp_dev_pm_ops)
+#else
+#define CORETEMP_DEV_PM_OPS NULL
+#endif /* CONFIG_PM_SLEEP */
+
 static struct platform_driver coretemp_driver = {
 	.driver = {
 		.owner = THIS_MODULE,
 		.name = DRVNAME,
+		.pm = CORETEMP_DEV_PM_OPS,
 	},
 	.probe = coretemp_probe,
 	.remove = coretemp_remove,
-- 
1.7.9.7

