Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaJIUHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 16:07:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:14944 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbaJIUHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 16:07:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,687,1406617200"; 
   d="scan'208";a="586274844"
From: Octavian Purdila <octavian.purdila@intel.com>
To: wsa@the-dreams.de
Cc: johan@kernel.org, linux-i2c@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [RFC PATCH 3/3] i2c: show and change bus frequency via sysfs
Date: Thu,  9 Oct 2014 23:07:15 +0300
Message-Id: <1412885235-14026-4-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412885235-14026-1-git-send-email-octavian.purdila@intel.com>
References: <1412885235-14026-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds two new sysfs files, bus_frequency and
bus_supported_frequencies which allows the user to view or change the
bus frequency on a per bus level.

This is required for e.g. USB I2C buses where we can have multiple
device plugged in a system and where a module parameter does not allow
controlling the bus speed individually.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-i2c | 24 ++++++++++
 drivers/i2c/i2c-core.c                  | 77 +++++++++++++++++++++++++++++++++
 include/linux/i2c.h                     | 10 +++++
 3 files changed, 111 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-i2c b/Documentation/ABI/testing/sysfs-bus-i2c
index 22c621a..058ac68 100644
--- a/Documentation/ABI/testing/sysfs-bus-i2c
+++ b/Documentation/ABI/testing/sysfs-bus-i2c
@@ -43,3 +43,27 @@ Contact:	linux-i2c@vger.kernel.org
 Description:
 		An i2c device attached to bus X that is enumerated via
 		ACPI. Y is the ACPI device name and its format is "%s".
+
+What:		/sys/bus/i2c/devices/i2c-X/bus_frequency
+KernelVersion:	3.19
+Contact:	linux-i2c@vger.kernel.org
+Description:
+		The current bus frequency for bus X. Can be updated if
+		the bus supports it. The unit is HZ and format is
+		"%d\n".
+		If the bus does not support showing/changing the
+		frequency then reading/writting to this entry will
+		fail with -EOPNOTSUPP.
+		When updating the bus frequency that value must be one
+		of the values in bus_supported_frequencies otherwise
+		writting will fail with -EINVAL.
+
+What:		/sys/bus/i2c/devices/i2c-X/bus_supported_frequencies
+KernelVersion:	3.19
+Contact:	linux-i2c@vger.kernel.org
+Description:
+		Supported frequencies for bus X. The unit is HZ and
+		format is "%d %d %d ... %d\n".
+		If the bus does not support showing/changing the
+		frequency then reading to this entry will fail with
+		-EOPNOTSUPP.
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 632057a..32b918a 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -940,10 +940,87 @@ static DEVICE_ATTR(new_device, S_IWUSR, NULL, i2c_sysfs_new_device);
 static DEVICE_ATTR_IGNORE_LOCKDEP(delete_device, S_IWUSR, NULL,
 				   i2c_sysfs_delete_device);
 
+static ssize_t
+i2c_sysfs_freq_show(struct device *dev, struct device_attribute *attr,
+		    char *buf)
+{
+	struct i2c_adapter *adap = to_i2c_adapter(dev);
+
+	if (!adap->freq)
+		return -EOPNOTSUPP;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", adap->freq);
+}
+
+static ssize_t
+i2c_sysfs_freq_store(struct device *dev, struct device_attribute *attr,
+		     const char *buf, size_t count)
+{
+	struct i2c_adapter *adap = to_i2c_adapter(dev);
+	unsigned int freq;
+	int ret;
+	int i;
+
+	if (!adap->set_freq)
+		return -EOPNOTSUPP;
+
+	if (kstrtouint(buf, 0, &freq))
+		return -EINVAL;
+
+	if (freq == 0)
+		return -EINVAL;
+
+	for (i = 0; i < I2C_MAX_FREQS && adap->supported_freqs[i]; i++)
+		if (adap->supported_freqs[i] >= freq)
+			break;
+
+	if (adap->supported_freqs[i] != freq)
+		return -EINVAL;
+
+	i2c_lock_adapter(adap);
+	ret = adap->set_freq(adap, freq);
+	i2c_unlock_adapter(adap);
+
+	if (ret)
+		return ret;
+
+	adap->freq = freq;
+
+	return count;
+}
+
+static DEVICE_ATTR(bus_frequency, S_IWUSR | S_IRUGO, i2c_sysfs_freq_show,
+		   i2c_sysfs_freq_store);
+
+
+static ssize_t
+i2c_sysfs_supp_freqs_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct i2c_adapter *adap = to_i2c_adapter(dev);
+	ssize_t count = 0;
+	int i;
+
+	if (!adap->supported_freqs[0])
+		return -EOPNOTSUPP;
+
+	for (i = 0; i < I2C_MAX_FREQS && adap->supported_freqs[i]; i++)
+		count += snprintf(buf + count, PAGE_SIZE - count, "%d ",
+				  adap->supported_freqs[i]);
+	buf[count - 1] = '\n';
+
+	return count;
+}
+
+static DEVICE_ATTR(bus_supported_frequencies, S_IRUGO,
+		   i2c_sysfs_supp_freqs_show, NULL);
+
 static struct attribute *i2c_adapter_attrs[] = {
 	&dev_attr_name.attr,
 	&dev_attr_new_device.attr,
 	&dev_attr_delete_device.attr,
+	&dev_attr_bus_frequency.attr,
+	&dev_attr_bus_supported_frequencies.attr,
 	NULL
 };
 
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 36041e2..e410637 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -418,6 +418,8 @@ int i2c_recover_bus(struct i2c_adapter *adap);
 int i2c_generic_gpio_recovery(struct i2c_adapter *adap);
 int i2c_generic_scl_recovery(struct i2c_adapter *adap);
 
+#define I2C_MAX_FREQS 16
+
 /**
  * struct i2c_adapter - represents an I2C physical bus
  *
@@ -431,6 +433,10 @@ int i2c_generic_scl_recovery(struct i2c_adapter *adap);
  *	usb->interface->dev, platform_device->dev etc.)
  * @name: name of this i2c bus
  * @bus_recovery_info: see struct i2c_bus_recovery_info. Optional.
+ * @supported_freqs: supported bus frequencies (in HZ). Must be sorted
+ *	in ascending order. Optional.
+ * @freq: initial bus frequency. Optional.
+ * @set_bus_freq: set the bus frequency (in HZ). Optional.
  */
 struct i2c_adapter {
 	struct module *owner;
@@ -438,6 +444,10 @@ struct i2c_adapter {
 	const struct i2c_algorithm *algo; /* the algorithm to access the bus */
 	void *algo_data;
 
+	unsigned int supported_freqs[I2C_MAX_FREQS];
+	unsigned int freq;
+	int (*set_freq)(struct i2c_adapter *a, unsigned int freq);
+
 	/* data fields that are valid for all devices	*/
 	struct rt_mutex bus_lock;
 
-- 
1.9.1

