Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab3KTXBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 18:01:36 -0500
Received: from pavo.uberspace.de ([95.143.172.191]:57137 "HELO
	pavo.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754421Ab3KTXBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 18:01:17 -0500
From: =?UTF-8?q?Friedrich=20Sch=C3=B6ller?= <linux@schoeller.se>
To: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Friedrich=20Sch=C3=B6ller?= <linux@schoeller.se>
Subject: [PATCH 3/3] Input: Added thumb detection in BCM5974 multitouch driver
Date: Wed, 20 Nov 2013 23:54:12 +0100
Message-Id: <1384988052-31898-3-git-send-email-linux@schoeller.se>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1384988052-31898-1-git-send-email-linux@schoeller.se>
References: <1384988052-31898-1-git-send-email-linux@schoeller.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trackpads with integrated buttons are hard to use when the driver responds to
movements of the thumb that is resting or clicking on the surface of the
trackpad. This patch adds rudimentary support to filter out these touch events.

The feature can be turned on via sysfs:
	/sys/class/input/input[0-9]+/thumb_ignore:
		Enables thumb detection
		Values: 0/1
	/sys/class/input/input[0-9]+/thumb_ratio_on:
		When the ratio of ABS_MT_TOUCH_MINOR / ABS_MT_TOUCH_MAJOR
		times 100 is smaller than this value the touch qualifies
		as a thumb.
	/sys/class/input/input[0-9]+/thumb_ratio_off:
		When the ratio of ABS_MT_TOUCH_MINOR / ABS_MT_TOUCH_MAJOR
		times 100 is bigger than this value the touch no longer
		qualifies as a thumb.
	/sys/class/input/input[0-9]+/thumb_y_on:
		When ABS_MT_POSITION_Y is bigger than this value the touch
		qualifies as a thumb.
	/sys/class/input/input[0-9]+/thumb_y_off:
		When ABS_MT_POSITION_Y is smaller than this value the touch
		no longer qualifies as a thumb.
---
 drivers/input/mouse/bcm5974.c | 150 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 150 insertions(+)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index ecbf359..826cdb4 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -259,6 +259,12 @@ struct bcm5974 {
 	const struct tp_finger *index[MAX_FINGERS];	/* finger index data */
 	struct input_mt_pos pos[MAX_FINGERS];		/* position array */
 	int slots[MAX_FINGERS];				/* slot assignments */
+	bool thb_ignore;		/* ignore thumb */
+	unsigned int thb_r_on;		/* ratio to start ignoring thumb */
+	unsigned int thb_r_off;		/* ratio to stop ignoring thumb */
+	int thb_y_on;			/* y coord. to start ignoring thumb */
+	int thb_y_off;			/* y coord. to stop ignoring thumb */
+	bool thb_found;			/* thumb detected */
 };
 
 /* logical signal quality */
@@ -554,6 +560,7 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 	const struct tp_finger *f;
 	struct input_dev *input = dev->input;
 	int raw_n, i, n = 0, p = 0, w = 0;
+	int thb_r = 0, thb_y = 0;
 
 	if (size < c->tp_offset || (size - c->tp_offset) % SIZEOF_FINGER != 0)
 		return -EIO;
@@ -562,11 +569,30 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 	f = (const struct tp_finger *)(dev->tp_data + c->tp_offset);
 	raw_n = (size - c->tp_offset) / SIZEOF_FINGER;
 
+	if (dev->thb_ignore) {
+		if (dev->thb_found) {
+			thb_r = dev->thb_r_off;
+			thb_y = dev->thb_y_off;
+		} else {
+			thb_r = dev->thb_r_on;
+			thb_y = dev->thb_y_on;
+		}
+		dev->thb_found = false;
+	}
+
 	for (i = 0; i < raw_n; i++) {
 		if (raw2int(f[i].touch_major) == 0)
 			continue;
 		dev->pos[n].x = raw2int(f[i].abs_x);
 		dev->pos[n].y = c->y.min + c->y.max - raw2int(f[i].abs_y);
+
+		if (dev->thb_ignore && thb_y < dev->pos[n].y &&
+		    thb_r * 2 * raw2int(f[i].touch_major) >
+		    100 * c->touch_minor_f * raw2int(f[i].touch_minor)) {
+			dev->thb_found = true;
+			continue;
+		}
+
 		dev->index[n++] = &f[i];
 		p += raw2int(f[i].touch_major);
 		w += raw2int(f[i].tool_major);
@@ -596,6 +622,118 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 	return 0;
 }
 
+static ssize_t bcm5974_thb_ignore_show(struct device *dev,
+				       struct device_attribute *attr, char *buf)
+{
+	struct bcm5974 *bcm5974_dev = dev_get_drvdata(dev);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", bcm5974_dev->thb_ignore);
+}
+
+static ssize_t bcm5974_thb_ignore_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct bcm5974 *bcm5974_dev = dev_get_drvdata(dev);
+	int val;
+
+	unsigned int error = kstrtoint(buf, 10, &val);
+	if (error)
+		return error;
+
+	bcm5974_dev->thb_ignore = !!val;
+	bcm5974_dev->thb_found = false;
+
+	return count;
+}
+
+static ssize_t bcm5974_thb_r_on_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct bcm5974 *bcm5974_dev = dev_get_drvdata(dev);
+	return scnprintf(buf, PAGE_SIZE, "%d%%\n", bcm5974_dev->thb_r_on);
+}
+
+static ssize_t bcm5974_thb_r_on_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct bcm5974 *bcm5974_dev = dev_get_drvdata(dev);
+	unsigned int error = kstrtouint(buf, 10, &bcm5974_dev->thb_r_on);
+	return error ? error : count;
+}
+
+static ssize_t bcm5974_thb_r_off_show(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct bcm5974 *bcm5974_dev = dev_get_drvdata(dev);
+	return scnprintf(buf, PAGE_SIZE, "%d%%\n", bcm5974_dev->thb_r_off);
+}
+
+static ssize_t bcm5974_thb_r_off_store(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count)
+{
+	struct bcm5974 *bcm5974_dev = dev_get_drvdata(dev);
+	unsigned int error = kstrtouint(buf, 10, &bcm5974_dev->thb_r_off);
+	return error ? error : count;
+}
+
+static ssize_t bcm5974_thb_y_on_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct bcm5974 *bcm5974_dev = dev_get_drvdata(dev);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", bcm5974_dev->thb_y_on);
+}
+
+static ssize_t bcm5974_thb_y_on_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct bcm5974 *bcm5974_dev = dev_get_drvdata(dev);
+	int error = kstrtoint(buf, 10, &bcm5974_dev->thb_y_on);
+	return error ? error : count;
+}
+
+static ssize_t bcm5974_thb_y_off_show(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct bcm5974 *bcm5974_dev = dev_get_drvdata(dev);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", bcm5974_dev->thb_y_off);
+}
+
+static ssize_t bcm5974_thb_y_off_store(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count)
+{
+	struct bcm5974 *bcm5974_dev = dev_get_drvdata(dev);
+	int error = kstrtoint(buf, 10, &bcm5974_dev->thb_y_off);
+	return error ? error : count;
+}
+
+static DEVICE_ATTR(thumb_ignore, 0664, bcm5974_thb_ignore_show,
+		   bcm5974_thb_ignore_store);
+static DEVICE_ATTR(thumb_ratio_on, 0664, bcm5974_thb_r_on_show,
+		   bcm5974_thb_r_on_store);
+static DEVICE_ATTR(thumb_ratio_off, 0664, bcm5974_thb_r_off_show,
+		   bcm5974_thb_r_off_store);
+static DEVICE_ATTR(thumb_y_on, 0664, bcm5974_thb_y_on_show,
+		   bcm5974_thb_y_on_store);
+static DEVICE_ATTR(thumb_y_off, 0664, bcm5974_thb_y_off_show,
+		   bcm5974_thb_y_off_store);
+
+static struct attribute *bcm5974_attributes[] = {
+	&dev_attr_thumb_ignore.attr,
+	&dev_attr_thumb_ratio_on.attr,
+	&dev_attr_thumb_ratio_off.attr,
+	&dev_attr_thumb_y_on.attr,
+	&dev_attr_thumb_y_off.attr,
+	NULL
+};
+
+static const struct attribute_group bcm5974_attr_group = {
+	.attrs = bcm5974_attributes,
+};
+
 /* Wellspring initialization constants */
 #define BCM5974_WELLSPRING_MODE_READ_REQUEST_ID		1
 #define BCM5974_WELLSPRING_MODE_WRITE_REQUEST_ID	9
@@ -880,6 +1018,11 @@ static int bcm5974_probe(struct usb_interface *iface,
 	dev->cfg = *cfg;
 	mutex_init(&dev->pm_mutex);
 
+	dev->thb_r_on  = 40;
+	dev->thb_r_off = 60;
+	dev->thb_y_on  = (cfg->y.max - cfg->y.min) * 0.75 + cfg->y.min;
+	dev->thb_y_off = (cfg->y.max - cfg->y.min) * 0.73 + cfg->y.min;
+
 	/* setup urbs */
 	if (cfg->tp_type == TYPE1) {
 		dev->bt_urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -941,8 +1084,14 @@ static int bcm5974_probe(struct usb_interface *iface,
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(iface, dev);
 
+	error = sysfs_create_group(&input_dev->dev.kobj, &bcm5974_attr_group);
+	if (error)
+		goto err_unregister_input;
+
 	return 0;
 
+err_unregister_input:
+	input_unregister_device(dev->input);
 err_free_buffer:
 	usb_free_coherent(dev->udev, dev->cfg.tp_datalen,
 		dev->tp_data, dev->tp_urb->transfer_dma);
@@ -967,6 +1116,7 @@ static void bcm5974_disconnect(struct usb_interface *iface)
 
 	usb_set_intfdata(iface, NULL);
 
+	sysfs_remove_group(&dev->input->dev.kobj, &bcm5974_attr_group);
 	input_unregister_device(dev->input);
 	usb_free_coherent(dev->udev, dev->cfg.tp_datalen,
 			  dev->tp_data, dev->tp_urb->transfer_dma);
-- 
1.8.4.2

