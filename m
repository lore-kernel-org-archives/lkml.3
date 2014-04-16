Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbaDPRUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 13:20:35 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:38915 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbaDPRT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:19:58 -0400
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [PATCH v4 21/21] misc: support for I-8024 in LP-8x4x
Date: Wed, 16 Apr 2014 21:17:26 +0400
Message-Id: <1397668667-27328-15-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397668667-27328-1-git-send-email-ynvich@gmail.com>
References: <1397668411-27162-7-git-send-email-ynvich@gmail.com>
 <1397668667-27328-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Status of I-8042 4 analog output channels can be managed via
sysfs.

http://www.icpdas.com/root/product/solutions/remote_io/rs-485/i-8k_i-87k/i-8024w.html

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
---
   v3..v4
   * no changes

   v2..v3
   * use usleep_range instead of custom nsleep
   * number change (16/16 -> 21/21)

   v0..v2
   * no changes

 Documentation/misc-devices/lp8x4x_bus.txt | 15 ++++++
 drivers/misc/lp8x4x_bus.c                 | 78 +++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+)

diff --git a/Documentation/misc-devices/lp8x4x_bus.txt b/Documentation/misc-devices/lp8x4x_bus.txt
index 3ea257d..6076e01 100644
--- a/Documentation/misc-devices/lp8x4x_bus.txt
+++ b/Documentation/misc-devices/lp8x4x_bus.txt
@@ -66,3 +66,18 @@ input_status
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
index 3fb227d..72cd0b2 100644
--- a/drivers/misc/lp8x4x_bus.c
+++ b/drivers/misc/lp8x4x_bus.c
@@ -8,6 +8,7 @@
  *  it under the terms of the GNU General Public License version 2 as
  *  published by the Free Software Foundation or any later version.
  */
+#include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/gpio/consumer.h>
 #include <linux/init.h>
@@ -23,6 +24,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sergei Ianovich <ynvich@gmail.com>");
 MODULE_DESCRIPTION("ICP DAS LP-8x4x parallel bus driver");
 
+#define LP8X4X_MAX_AO_CHANNELS	4
 struct lp8x4x_slot {
 	void			*data_addr;
 	unsigned int		model;
@@ -31,6 +33,8 @@ struct lp8x4x_slot {
 	u32			DO;
 	unsigned int		DI_len;
 	u32			DI;
+	unsigned int		AO_len;
+	u32			AO[LP8X4X_MAX_AO_CHANNELS];
 	struct device		dev;
 };
 
@@ -120,6 +124,26 @@ static void lp8x4x_slot_set_DO(struct lp8x4x_slot *s)
 	mutex_unlock(&s->lock);
 }
 
+static void lp8x4x_slot_reset_AO(struct lp8x4x_slot *s)
+{
+	int i;
+	mutex_lock(&s->lock);
+	for (i = 0; i < s->AO_len; i++)
+		s->AO[i] = 0x2000;
+	iowrite8(0x00, s->data_addr);
+	usleep_range(1, 2);
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
@@ -191,6 +215,48 @@ static ssize_t output_status_store(struct device *dev,
 
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
@@ -222,6 +288,13 @@ static struct attribute *dio_slot_dev_attrs[] = {
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
@@ -382,6 +455,11 @@ static void __init lp8x4x_bus_probe_slot(struct lp8x4x_master *m, int i,
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
1.8.4.2

