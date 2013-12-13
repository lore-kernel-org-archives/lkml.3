Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3LMCa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:30:58 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:46881 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab3LMCan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:30:43 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [PATCH v2 16/16] misc: support for I-8024 in LP-8x4x
Date: Fri, 13 Dec 2013 06:27:25 +0400
Message-Id: <1386901645-28895-17-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com>
 <1386901645-28895-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Status of I-8042 4 analog output channels can be managed via
sysfs.

http://www.icpdas.com/root/product/solutions/remote_io/rs-485/i-8k_i-87k/i-8024w.html

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
---
   v0..v2
   * no changes

 Documentation/misc-devices/lp8x4x_bus.txt | 15 ++++++
 drivers/misc/lp8x4x_bus.c                 | 89 +++++++++++++++++++++++++++++++
 2 files changed, 104 insertions(+)

diff --git a/Documentation/misc-devices/lp8x4x_bus.txt b/Documentation/misc-devices/lp8x4x_bus.txt
index e3a8bcf..08419d1 100644
--- a/Documentation/misc-devices/lp8x4x_bus.txt
+++ b/Documentation/misc-devices/lp8x4x_bus.txt
@@ -57,3 +57,18 @@ input_status
 output_status
 	RW - set status of digital output channels on the module in
 	     the expansion slot. Value can be read back.
+
+analog_output
+	RW - set status of analog output channels on the module in
+	     the expansion slot. Tested with voltage output. Bits 0-13:
+	     0x00c0 is -10.0V
+	     0x2000 is   0.0V
+	     0x3f40 is +10.0V
+
+	     So 1 unit of output is 1.25 mV.
+
+	     Bits 15 and 14 determine which channel to apply the value:
+	     0x0000 is channel 1
+	     0x4000 is channel 2
+	     0x8000 is channel 3
+	     0xc000 is channel 4
diff --git a/drivers/misc/lp8x4x_bus.c b/drivers/misc/lp8x4x_bus.c
index 684e640..58cfc8c 100644
--- a/drivers/misc/lp8x4x_bus.c
+++ b/drivers/misc/lp8x4x_bus.c
@@ -8,12 +8,14 @@
  *  it under the terms of the GNU General Public License version 2 as
  *  published by the Free Software Foundation or any later version.
  */
+#include <linux/hrtimer.h>
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 
 #define MODULE_NAME	"lp8x4x-bus"
@@ -21,6 +23,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sergei Ianovich <ynvich@gmail.com>");
 MODULE_DESCRIPTION("ICP DAS LP-8x4x parallel bus driver");
 
+#define LP8X4X_MAX_AO_CHANNELS	4
 struct lp8x4x_slot {
 	void			*data_addr;
 	unsigned int		model;
@@ -29,6 +32,8 @@ struct lp8x4x_slot {
 	u32			DO;
 	unsigned int		DI_len;
 	u32			DI;
+	unsigned int		AO_len;
+	u32			AO[LP8X4X_MAX_AO_CHANNELS];
 	struct device		dev;
 };
 
@@ -115,6 +120,36 @@ static void lp8x4x_slot_set_DO(struct lp8x4x_slot *s)
 	mutex_unlock(&s->lock);
 }
 
+void nsleep(unsigned long nanosec)
+{
+	ktime_t t = ns_to_ktime(nanosec);
+	long state = current->state;
+
+	__set_current_state(TASK_UNINTERRUPTIBLE);
+	schedule_hrtimeout(&t, HRTIMER_MODE_REL);
+	__set_current_state(state);
+}
+
+static void lp8x4x_slot_reset_AO(struct lp8x4x_slot *s)
+{
+	int i;
+	mutex_lock(&s->lock);
+	for (i = 0; i < s->AO_len; i++)
+		s->AO[i] = 0x2000;
+	iowrite8(0x00, s->data_addr);
+	nsleep(450);
+	iowrite8(0xff, s->data_addr);
+	mutex_unlock(&s->lock);
+}
+
+static void lp8x4x_slot_set_AO(struct lp8x4x_slot *s, u32 val)
+{
+	mutex_lock(&s->lock);
+	iowrite8(val & 0xff, s->data_addr + 2);
+	iowrite8((val >> 8) & 0xff, s->data_addr + 4);
+	mutex_unlock(&s->lock);
+}
+
 static ssize_t input_status_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -186,6 +221,48 @@ static ssize_t output_status_store(struct device *dev,
 
 static DEVICE_ATTR_RW(output_status);
 
+static ssize_t analog_output_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct lp8x4x_slot *s = container_of(dev, struct lp8x4x_slot, dev);
+	int i, c = 0;
+
+	for (i = 0; i < s->AO_len; i++)
+		c += sprintf(&buf[c], "0x%04x\n", s->AO[i]);
+	return c;
+}
+
+static ssize_t analog_output_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct lp8x4x_slot *s = container_of(dev, struct lp8x4x_slot, dev);
+	u32 AO;
+	int i;
+
+	if (!buf)
+		return count;
+	if (0 == count)
+		return count;
+
+	if (kstrtouint(buf, 16, &AO) != 0) {
+		dev_err(dev, "bad input\n");
+		return count;
+	}
+
+	if (AO & 0xffff0000) {
+		dev_err(dev, "bad input\n");
+		return count;
+	}
+
+	i = AO >> 14;
+	s->AO[i] = AO & 0x3fff;
+	lp8x4x_slot_set_AO(s, AO);
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(analog_output);
+
 static ssize_t model_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -217,6 +294,13 @@ static struct attribute *dio_slot_dev_attrs[] = {
 };
 ATTRIBUTE_GROUPS(dio_slot_dev);
 
+static struct attribute *ao_slot_dev_attrs[] = {
+	&dev_attr_model.attr,
+	&dev_attr_analog_output.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(ao_slot_dev);
+
 static void lp8x4x_master_release(struct device *dev)
 {
 	struct lp8x4x_master *m = container_of(dev, struct lp8x4x_master, dev);
@@ -316,6 +400,11 @@ static void __init lp8x4x_bus_probe_slot(struct lp8x4x_master *m, int i,
 	mutex_init(&s->lock);
 
 	switch (model) {
+	case 24:
+		s->AO_len = 4;
+		lp8x4x_slot_reset_AO(s);
+		s->dev.groups = ao_slot_dev_groups;
+		break;
 	case 41:
 		s->DO_len = 4;
 		lp8x4x_slot_set_DO(s);
-- 
1.8.4.3

