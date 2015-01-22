Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbbAVTQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:16:55 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:36209 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbbAVTQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:16:51 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v3 7/7] platform/chrome: Expose Chrome OS Lightbar to users
Date: Thu, 22 Jan 2015 20:16:26 +0100
Message-Id: <1421954186-29764-8-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421954186-29764-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1421954186-29764-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bill Richardson <wfrichar@chromium.org>

This adds some sysfs entries to provide userspace control of the
four-element LED "lightbar" on the Chromebook Pixel. This only instantiates
the lightbar controls if the device actually exists.

To prevent DoS attacks, this interface is limited to 20 accesses/second,
although that rate can be adjusted by a privileged user.

On Chromebooks without a lightbar, this should have no effect. On the
Chromebook Pixel, you should be able to do things like this:

    $ cd /sys/devices/virtual/chromeos/cros_ec/lightbar
    $ echo 0x80 > brightness
    $ echo 255 > brightness
    $
    $ cat sequence
    S0
    $ echo konami > sequence
    $ cat sequence
    KONAMI
    $
    $ cat sequence
    S0

And

    $ cd /sys/devices/virtual/chromeos/cros_ec/lightbar
    $ echo stop > sequence
    $ echo "4 255 255 255" > led_rgb
    $ echo "0 255 0 0  1 0 255 0  2 0 0 255  3 255 255 0" > led_rgb
    $ echo run  > sequence

Test the DoS prevention with this:

    $ cd /sys/devices/virtual/chromeos/cros_ec/lightbar
    $ echo 500 > interval_msec
    $ time (cat version version version version version version version)

Signed-off-by: Bill Richardson <wfrichar@chromium.org>
Reviewed-by: Olof Johansson <olofj@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Changes since v2: None

Changes since v1:
 - Moved from drivers/mfd to drivers/platform/chrome.
 - Modify to use the fixed-size arrays for cros_ec_command in and out buffers.
---
 drivers/platform/chrome/Makefile           |   2 +-
 drivers/platform/chrome/cros_ec_dev.c      |   2 +
 drivers/platform/chrome/cros_ec_dev.h      |   3 +
 drivers/platform/chrome/cros_ec_lightbar.c | 367 +++++++++++++++++++++++++++++
 4 files changed, 373 insertions(+), 1 deletion(-)
 create mode 100644 drivers/platform/chrome/cros_ec_lightbar.c

diff --git a/drivers/platform/chrome/Makefile b/drivers/platform/chrome/Makefile
index 3e7980b9bc86..cc5d2f294c40 100644
--- a/drivers/platform/chrome/Makefile
+++ b/drivers/platform/chrome/Makefile
@@ -1,5 +1,5 @@
 
 obj-$(CONFIG_CHROMEOS_LAPTOP)	+= chromeos_laptop.o
 obj-$(CONFIG_CHROMEOS_PSTORE)	+= chromeos_pstore.o
-cros_ec_devs-objs		:= cros_ec_dev.o cros_ec_sysfs.o
+cros_ec_devs-objs		:= cros_ec_dev.o cros_ec_sysfs.o cros_ec_lightbar.o
 obj-$(CONFIG_CROS_EC_CHARDEV)	+= cros_ec_devs.o
diff --git a/drivers/platform/chrome/cros_ec_dev.c b/drivers/platform/chrome/cros_ec_dev.c
index 33f37ad36892..ce714317a59e 100644
--- a/drivers/platform/chrome/cros_ec_dev.c
+++ b/drivers/platform/chrome/cros_ec_dev.c
@@ -200,6 +200,7 @@ static int ec_device_probe(struct platform_device *pdev)
 
 	/* Initialize extra interfaces */
 	ec_dev_sysfs_init(ec);
+	ec_dev_lightbar_init(ec);
 
 	return 0;
 }
@@ -208,6 +209,7 @@ static int ec_device_remove(struct platform_device *pdev)
 {
 	struct cros_ec_device *ec = dev_get_drvdata(pdev->dev.parent);
 
+	ec_dev_lightbar_remove(ec);
 	ec_dev_sysfs_remove(ec);
 	device_destroy(cros_class, MKDEV(ec_major, 0));
 	cdev_del(&ec->cdev);
diff --git a/drivers/platform/chrome/cros_ec_dev.h b/drivers/platform/chrome/cros_ec_dev.h
index f03613290ecf..45d67f7e518c 100644
--- a/drivers/platform/chrome/cros_ec_dev.h
+++ b/drivers/platform/chrome/cros_ec_dev.h
@@ -47,4 +47,7 @@ struct cros_ec_readmem {
 void ec_dev_sysfs_init(struct cros_ec_device *);
 void ec_dev_sysfs_remove(struct cros_ec_device *);
 
+void ec_dev_lightbar_init(struct cros_ec_device *);
+void ec_dev_lightbar_remove(struct cros_ec_device *);
+
 #endif /* _CROS_EC_DEV_H_ */
diff --git a/drivers/platform/chrome/cros_ec_lightbar.c b/drivers/platform/chrome/cros_ec_lightbar.c
new file mode 100644
index 000000000000..35fc892e4c95
--- /dev/null
+++ b/drivers/platform/chrome/cros_ec_lightbar.c
@@ -0,0 +1,367 @@
+/*
+ * cros_ec_lightbar - expose the Chromebook Pixel lightbar to userspace
+ *
+ * Copyright (C) 2014 Google, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#define pr_fmt(fmt) "cros_ec_lightbar: " fmt
+
+#include <linux/ctype.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/kobject.h>
+#include <linux/mfd/cros_ec.h>
+#include <linux/mfd/cros_ec_commands.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+
+#include "cros_ec_dev.h"
+
+/* Rate-limit the lightbar interface to prevent DoS. */
+static unsigned long lb_interval_jiffies = 50 * HZ / 1000;
+
+static ssize_t interval_msec_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	unsigned long msec = lb_interval_jiffies * 1000 / HZ;
+
+	return scnprintf(buf, PAGE_SIZE, "%lu\n", msec);
+}
+
+static ssize_t interval_msec_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
+{
+	unsigned long msec;
+
+	if (kstrtoul(buf, 0, &msec))
+		return -EINVAL;
+
+	lb_interval_jiffies = msec * HZ / 1000;
+
+	return count;
+}
+
+static DEFINE_MUTEX(lb_mutex);
+/* Return 0 if able to throttle correctly, error otherwise */
+static int lb_throttle(void)
+{
+	static unsigned long last_access;
+	unsigned long now, next_timeslot;
+	long delay;
+	int ret = 0;
+
+	mutex_lock(&lb_mutex);
+
+	now = jiffies;
+	next_timeslot = last_access + lb_interval_jiffies;
+
+	if (time_before(now, next_timeslot)) {
+		delay = (long)(next_timeslot) - (long)now;
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (schedule_timeout(delay) > 0) {
+			/* interrupted - just abort */
+			ret = -EINTR;
+			goto out;
+		}
+		now = jiffies;
+	}
+
+	last_access = now;
+out:
+	mutex_unlock(&lb_mutex);
+
+	return ret;
+}
+
+#define INIT_MSG(P, R) { \
+		.command = EC_CMD_LIGHTBAR_CMD, \
+		.outsize = sizeof(*P), \
+		.insize = sizeof(*R), \
+	}
+
+static int get_lightbar_version(struct cros_ec_device *ec,
+				uint32_t *ver_ptr, uint32_t *flg_ptr)
+{
+	struct ec_params_lightbar *param;
+	struct ec_response_lightbar *resp;
+	struct cros_ec_command msg = INIT_MSG(param, resp);
+	int ret;
+
+	param = (struct ec_params_lightbar *)msg.outdata;
+	param->cmd = LIGHTBAR_CMD_VERSION;
+	ret = cros_ec_cmd_xfer(ec, &msg);
+	if (ret < 0)
+		return 0;
+
+	switch (msg.result) {
+	case EC_RES_INVALID_PARAM:
+		/* Pixel had no version command. */
+		if (ver_ptr)
+			*ver_ptr = 0;
+		if (flg_ptr)
+			*flg_ptr = 0;
+		return 1;
+
+	case EC_RES_SUCCESS:
+		resp = (struct ec_response_lightbar *)msg.indata;
+
+		/* Future devices w/lightbars should implement this command */
+		if (ver_ptr)
+			*ver_ptr = resp->version.num;
+		if (flg_ptr)
+			*flg_ptr = resp->version.flags;
+		return 1;
+	}
+
+	/* Anything else (ie, EC_RES_INVALID_COMMAND) - no lightbar */
+	return 0;
+}
+
+static ssize_t version_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	uint32_t version, flags;
+	struct cros_ec_device *ec = dev_get_drvdata(dev);
+	int ret;
+
+	ret = lb_throttle();
+	if (ret)
+		return ret;
+
+	/* This should always succeed, because we check during init. */
+	if (!get_lightbar_version(ec, &version, &flags))
+		return -EIO;
+
+	return scnprintf(buf, PAGE_SIZE, "%d %d\n", version, flags);
+}
+
+static ssize_t brightness_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct ec_params_lightbar *param;
+	struct ec_response_lightbar *resp;
+	struct cros_ec_command msg = INIT_MSG(param, resp);
+	int ret;
+	unsigned int val;
+	struct cros_ec_device *ec = dev_get_drvdata(dev);
+
+	if (kstrtouint(buf, 0, &val))
+		return -EINVAL;
+
+	param = (struct ec_params_lightbar *)msg.outdata;
+	param->cmd = LIGHTBAR_CMD_BRIGHTNESS;
+	param->brightness.num = val;
+	ret = lb_throttle();
+	if (ret)
+		return ret;
+
+	ret = cros_ec_cmd_xfer(ec, &msg);
+	if (ret < 0)
+		return ret;
+
+	if (msg.result != EC_RES_SUCCESS)
+		return -EINVAL;
+
+	return count;
+}
+
+
+/*
+ * We expect numbers, and we'll keep reading until we find them, skipping over
+ * any whitespace (sysfs guarantees that the input is null-terminated). Every
+ * four numbers are sent to the lightbar as <LED,R,G,B>. We fail at the first
+ * parsing error, if we don't parse any numbers, or if we have numbers left
+ * over.
+ */
+static ssize_t led_rgb_store(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t count)
+{
+	struct ec_params_lightbar *param;
+	struct ec_response_lightbar *resp;
+	struct cros_ec_command msg = INIT_MSG(param, resp);
+	struct cros_ec_device *ec = dev_get_drvdata(dev);
+	unsigned int val[4];
+	int ret, i = 0, j = 0, ok = 0;
+
+	do {
+		/* Skip any whitespace */
+		while (*buf && isspace(*buf))
+			buf++;
+
+		if (!*buf)
+			break;
+
+		ret = sscanf(buf, "%i", &val[i++]);
+		if (ret == 0)
+			return -EINVAL;
+
+		if (i == 4) {
+			param = (struct ec_params_lightbar *)msg.outdata;
+			param->cmd = LIGHTBAR_CMD_RGB;
+			param->rgb.led = val[0];
+			param->rgb.red = val[1];
+			param->rgb.green = val[2];
+			param->rgb.blue = val[3];
+			/*
+			 * Throttle only the first of every four transactions,
+			 * so that the user can update all four LEDs at once.
+			 */
+			if ((j++ % 4) == 0) {
+				ret = lb_throttle();
+				if (ret)
+					return ret;
+			}
+
+			ret = cros_ec_cmd_xfer(ec, &msg);
+			if (ret < 0)
+				return ret;
+
+			if (msg.result != EC_RES_SUCCESS)
+				return -EINVAL;
+
+			i = 0;
+			ok = 1;
+		}
+
+		/* Skip over the number we just read */
+		while (*buf && !isspace(*buf))
+			buf++;
+
+	} while (*buf);
+
+	return (ok && i == 0) ? count : -EINVAL;
+}
+
+static const char const *seqname[] = {
+	"ERROR", "S5", "S3", "S0", "S5S3", "S3S0",
+	"S0S3", "S3S5", "STOP", "RUN", "PULSE", "TEST", "KONAMI",
+};
+
+static ssize_t sequence_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct ec_params_lightbar *param;
+	struct ec_response_lightbar *resp;
+	struct cros_ec_command msg = INIT_MSG(param, resp);
+	int ret;
+	struct cros_ec_device *ec = dev_get_drvdata(dev);
+
+	param = (struct ec_params_lightbar *)msg.outdata;
+	param->cmd = LIGHTBAR_CMD_GET_SEQ;
+	ret = lb_throttle();
+	if (ret)
+		return ret;
+
+	ret = cros_ec_cmd_xfer(ec, &msg);
+	if (ret < 0)
+		return ret;
+
+	if (msg.result != EC_RES_SUCCESS)
+		return scnprintf(buf, PAGE_SIZE,
+				 "ERROR: EC returned %d\n", msg.result);
+
+	resp = (struct ec_response_lightbar *)msg.indata;
+	if (resp->get_seq.num >= ARRAY_SIZE(seqname))
+		return scnprintf(buf, PAGE_SIZE, "%d\n", resp->get_seq.num);
+	else
+		return scnprintf(buf, PAGE_SIZE, "%s\n",
+				 seqname[resp->get_seq.num]);
+}
+
+static ssize_t sequence_store(struct device *dev, struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct ec_params_lightbar *param;
+	struct ec_response_lightbar *resp;
+	struct cros_ec_command msg = INIT_MSG(param, resp);
+	unsigned int num;
+	int ret, len;
+	struct cros_ec_device *ec = dev_get_drvdata(dev);
+
+	for (len = 0; len < count; len++)
+		if (!isalnum(buf[len]))
+			break;
+
+	for (num = 0; num < ARRAY_SIZE(seqname); num++)
+		if (!strncasecmp(seqname[num], buf, len))
+			break;
+
+	if (num >= ARRAY_SIZE(seqname)) {
+		ret = kstrtouint(buf, 0, &num);
+		if (ret)
+			return ret;
+	}
+
+	param = (struct ec_params_lightbar *)msg.outdata;
+	param->cmd = LIGHTBAR_CMD_SEQ;
+	param->seq.num = num;
+	ret = lb_throttle();
+	if (ret)
+		return ret;
+
+	ret = cros_ec_cmd_xfer(ec, &msg);
+	if (ret < 0)
+		return ret;
+
+	if (msg.result != EC_RES_SUCCESS)
+		return -EINVAL;
+
+	return count;
+}
+
+/* Module initialization */
+
+static DEVICE_ATTR_RW(interval_msec);
+static DEVICE_ATTR_RO(version);
+static DEVICE_ATTR_WO(brightness);
+static DEVICE_ATTR_WO(led_rgb);
+static DEVICE_ATTR_RW(sequence);
+static struct attribute *__lb_cmds_attrs[] = {
+	&dev_attr_interval_msec.attr,
+	&dev_attr_version.attr,
+	&dev_attr_brightness.attr,
+	&dev_attr_led_rgb.attr,
+	&dev_attr_sequence.attr,
+	NULL,
+};
+static struct attribute_group lb_cmds_attr_group = {
+	.name = "lightbar",
+	.attrs = __lb_cmds_attrs,
+};
+
+void ec_dev_lightbar_init(struct cros_ec_device *ec)
+{
+	int ret = 0;
+
+	/* Only instantiate this stuff if the EC has a lightbar */
+	if (!get_lightbar_version(ec, NULL, NULL))
+		return;
+
+	ret = sysfs_create_group(&ec->vdev->kobj, &lb_cmds_attr_group);
+	if (ret)
+		pr_warn("sysfs_create_group() failed: %d\n", ret);
+}
+
+void ec_dev_lightbar_remove(struct cros_ec_device *ec)
+{
+	sysfs_remove_group(&ec->vdev->kobj, &lb_cmds_attr_group);
+}
-- 
2.1.3

