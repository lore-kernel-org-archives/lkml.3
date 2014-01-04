Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaADBkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 20:40:05 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:63242 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbaADBkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 20:40:03 -0500
Date: Fri, 3 Jan 2014 17:39:57 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ims-pcu: Add commands supported by the new version of
 the FW
Message-ID: <20140104013957.GA19702@core.coreip.homeip.net>
References: <1388623621-32245-1-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388623621-32245-1-git-send-email-andrew.smirnov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey,

On Wed, Jan 01, 2014 at 04:47:01PM -0800, Andrey Smirnov wrote:
> New version of the PCU firmware supports two new commands:
>   - IMS_PCU_CMD_OFN_SET_CONFIG which allows to write data to the
>   registers of one finger navigation(OFN) chip present on the device
>   - IMS_PCU_CMD_OFN_GET_CONFIG which allows to read data form the
>   registers of said chip.
> 
> This commit adds two helper functions to use those commands and sysfs
> attributes to use them. It also exposes some OFN configuration
> parameters via sysfs.

Thank you for making the changes. I do not still quite like the games we
play with the OFN attributes, how about the patch below (on top of
yours)?

Thanks.

-- 
Dmitry

Input: ims-pci - misc changes

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Split OFN code into separate named attribute group, tidy up attribute
handling.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/misc/ims-pcu.c |  330 ++++++++++++++++++++----------------------
 1 file changed, 156 insertions(+), 174 deletions(-)

diff --git a/drivers/input/misc/ims-pcu.c b/drivers/input/misc/ims-pcu.c
index 4244f47..bd25a78 100644
--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -1224,11 +1224,87 @@ ims_pcu_update_firmware_status_show(struct device *dev,
 static DEVICE_ATTR(update_firmware_status, S_IRUGO,
 		   ims_pcu_update_firmware_status_show, NULL);
 
-enum pcu_ofn_offsets {
-	OFN_REG_RESULT_LSB_OFFSET = 2,
-	OFN_REG_RESULT_MSB_OFFSET = 3,
+static struct attribute *ims_pcu_attrs[] = {
+	&ims_pcu_attr_part_number.dattr.attr,
+	&ims_pcu_attr_serial_number.dattr.attr,
+	&ims_pcu_attr_date_of_manufacturing.dattr.attr,
+	&ims_pcu_attr_fw_version.dattr.attr,
+	&ims_pcu_attr_bl_version.dattr.attr,
+	&ims_pcu_attr_reset_reason.dattr.attr,
+	&dev_attr_reset_device.attr,
+	&dev_attr_update_firmware.attr,
+	&dev_attr_update_firmware_status.attr,
+	NULL,
+};
+
+static umode_t ims_pcu_is_attr_visible(struct kobject *kobj,
+				       struct attribute *attr, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct ims_pcu *pcu = usb_get_intfdata(intf);
+	umode_t mode = attr->mode;
+
+	if (pcu->bootloader_mode) {
+		if (attr != &dev_attr_update_firmware_status.attr &&
+		    attr != &dev_attr_update_firmware.attr &&
+		    attr != &dev_attr_reset_device.attr) {
+			mode = 0;
+		}
+	} else {
+		if (attr == &dev_attr_update_firmware_status.attr)
+			mode = 0;
+	}
+
+	return mode;
+}
+
+static struct attribute_group ims_pcu_attr_group = {
+	.is_visible	= ims_pcu_is_attr_visible,
+	.attrs		= ims_pcu_attrs,
 };
 
+/* Support for a separate OFN attribute group */
+
+#define OFN_REG_RESULT_OFFSET	2
+
+static int ims_pcu_read_ofn_config(struct ims_pcu *pcu, u8 addr, u8 *data)
+{
+	int error;
+	u16 result;
+
+	error = ims_pcu_execute_command(pcu, OFN_GET_CONFIG,
+					&addr, sizeof(addr));
+	if (error)
+		return error;
+
+	result = le16_to_cpup((__le16 *)&pcu->cmd_buf[OFN_REG_RESULT_OFFSET]);
+	if ((s16)result < 0)
+		return -EIO;
+
+	/* We only need LSB */
+	*data = pcu->cmd_buf[OFN_REG_RESULT_OFFSET];
+	return 0;
+}
+
+static int ims_pcu_write_ofn_config(struct ims_pcu *pcu, u8 addr, u8 data)
+{
+	u8 buffer[] = { addr, data };
+	int error;
+	u16 result;
+
+	error = ims_pcu_execute_command(pcu, OFN_SET_CONFIG,
+					&buffer, sizeof(buffer));
+	if (error)
+		return error;
+
+	result = le16_to_cpup((__le16 *)&pcu->cmd_buf[OFN_REG_RESULT_OFFSET]);
+	if ((s16)result < 0)
+		return -EIO;
+
+	return 0;
+}
+
 static ssize_t ims_pcu_ofn_reg_data_show(struct device *dev,
 					 struct device_attribute *dattr,
 					 char *buf)
@@ -1236,24 +1312,16 @@ static ssize_t ims_pcu_ofn_reg_data_show(struct device *dev,
 	struct usb_interface *intf = to_usb_interface(dev);
 	struct ims_pcu *pcu = usb_get_intfdata(intf);
 	int error;
+	u8 data;
 
 	mutex_lock(&pcu->cmd_mutex);
-
-	error = ims_pcu_execute_command(pcu, OFN_GET_CONFIG,
-					&pcu->ofn_reg_addr,
-					sizeof(pcu->ofn_reg_addr));
-	if (error >= 0) {
-		const s16 result = pcu->cmd_buf[OFN_REG_RESULT_MSB_OFFSET] << 8 |
-			           pcu->cmd_buf[OFN_REG_RESULT_LSB_OFFSET];
-		if (result < 0)
-			error = result;
-		else
-			error = scnprintf(buf, PAGE_SIZE, "%x\n", result);
-	}
-
+	error = ims_pcu_read_ofn_config(pcu, pcu->ofn_reg_addr, &data);
 	mutex_unlock(&pcu->cmd_mutex);
 
-	return error;
+	if (error)
+		return error;
+
+	return scnprintf(buf, PAGE_SIZE, "%x\n", data);
 }
 
 static ssize_t ims_pcu_ofn_reg_data_store(struct device *dev,
@@ -1264,33 +1332,19 @@ static ssize_t ims_pcu_ofn_reg_data_store(struct device *dev,
 	struct ims_pcu *pcu = usb_get_intfdata(intf);
 	int error;
 	u8 value;
-	u8 buffer[2];
-	s16 result;
 
 	error = kstrtou8(buf, 0, &value);
 	if (error)
 		return error;
 
-	buffer[0] = pcu->ofn_reg_addr;
-	buffer[1] = value;
-
 	mutex_lock(&pcu->cmd_mutex);
-
-	error = ims_pcu_execute_command(pcu, OFN_SET_CONFIG,
-					&buffer, sizeof(buffer));
-
-	result = pcu->cmd_buf[OFN_REG_RESULT_MSB_OFFSET] << 8 |
-  		 pcu->cmd_buf[OFN_REG_RESULT_LSB_OFFSET];
-
+	error = ims_pcu_write_ofn_config(pcu, pcu->ofn_reg_addr, value);
 	mutex_unlock(&pcu->cmd_mutex);
 
-	if (!error && result < 0)
-		error = -ENOENT;
-
 	return error ?: count;
 }
 
-static DEVICE_ATTR(ofn_reg_data, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(reg_data, S_IRUGO | S_IWUSR,
 		   ims_pcu_ofn_reg_data_show, ims_pcu_ofn_reg_data_store);
 
 static ssize_t ims_pcu_ofn_reg_addr_show(struct device *dev,
@@ -1328,47 +1382,47 @@ static ssize_t ims_pcu_ofn_reg_addr_store(struct device *dev,
 	return error ?: count;
 }
 
-static DEVICE_ATTR(ofn_reg_addr, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(reg_addr, S_IRUGO | S_IWUSR,
 		   ims_pcu_ofn_reg_addr_show, ims_pcu_ofn_reg_addr_store);
 
-static ssize_t ims_pcu_ofn_bit_show(u8 addr, u8 nr,
-				    struct device *dev,
+struct ims_pcu_ofn_bit_attribute {
+	struct device_attribute dattr;
+	u8 addr;
+	u8 nr;
+};
+
+static ssize_t ims_pcu_ofn_bit_show(struct device *dev,
 				    struct device_attribute *dattr,
 				    char *buf)
 {
 	struct usb_interface *intf = to_usb_interface(dev);
 	struct ims_pcu *pcu = usb_get_intfdata(intf);
+	struct ims_pcu_ofn_bit_attribute *attr =
+		container_of(dattr, struct ims_pcu_ofn_bit_attribute, dattr);
 	int error;
+	u8 data;
 
 	mutex_lock(&pcu->cmd_mutex);
+	error = ims_pcu_read_ofn_config(pcu, attr->addr, &data);
+	mutex_unlock(&pcu->cmd_mutex);
 
-	error = ims_pcu_execute_command(pcu, OFN_GET_CONFIG,
-					&addr, sizeof(addr));
-	if (error >= 0) {
-		const s16 result = pcu->cmd_buf[OFN_REG_RESULT_MSB_OFFSET] << 8 |
-			           pcu->cmd_buf[OFN_REG_RESULT_LSB_OFFSET];
-		if (result < 0)
-			error = result;
-		else
-			error = scnprintf(buf, PAGE_SIZE, "%d\n",
-					  !!(result & (1 << nr)));
-	}
+	if (error)
+		return error;
 
-	mutex_unlock(&pcu->cmd_mutex);
-	return error;
+	return scnprintf(buf, PAGE_SIZE, "%d\n", !!(data & (1 << attr->nr)));
 }
 
-static ssize_t ims_pcu_ofn_bit_store(u8 addr, u8 nr,
-				     struct device *dev,
+static ssize_t ims_pcu_ofn_bit_store(struct device *dev,
 				     struct device_attribute *dattr,
 				     const char *buf, size_t count)
 {
 	struct usb_interface *intf = to_usb_interface(dev);
 	struct ims_pcu *pcu = usb_get_intfdata(intf);
+	struct ims_pcu_ofn_bit_attribute *attr =
+		container_of(dattr, struct ims_pcu_ofn_bit_attribute, dattr);
 	int error;
 	int value;
-	u8 contents;
-
+	u8 data;
 
 	error = kstrtoint(buf, 0, &value);
 	if (error)
@@ -1379,135 +1433,54 @@ static ssize_t ims_pcu_ofn_bit_store(u8 addr, u8 nr,
 
 	mutex_lock(&pcu->cmd_mutex);
 
-	error = ims_pcu_execute_command(pcu, OFN_GET_CONFIG,
-					&addr, sizeof(addr));
-	if (error < 0)
-		goto exit;
-
-	{
-		const s16 result = pcu->cmd_buf[OFN_REG_RESULT_MSB_OFFSET] << 8 |
-			           pcu->cmd_buf[OFN_REG_RESULT_LSB_OFFSET];
-		if (result < 0) {
-			error = result;
-			goto exit;
-		}
-		contents = (u8) result;
-	}
-
-	if (value)
-		contents |= 1 << nr;
-	else
-		contents &= ~(1 << nr);
+	error = ims_pcu_read_ofn_config(pcu, attr->addr, &data);
+	if (!error) {
+		if (value)
+			data |= 1U << attr->nr;
+		else
+			data &= ~(1U << attr->nr);
 
-	{
-		const u8 buffer[] = { addr, contents };
-		error = ims_pcu_execute_command(pcu, OFN_SET_CONFIG,
-						&buffer, sizeof(buffer));
+		error = ims_pcu_write_ofn_config(pcu, attr->addr, data);
 	}
 
-exit:
 	mutex_unlock(&pcu->cmd_mutex);
 
-	if (!error) {
-		const s16 result = pcu->cmd_buf[OFN_REG_RESULT_MSB_OFFSET] << 8 |
-			           pcu->cmd_buf[OFN_REG_RESULT_LSB_OFFSET];
-		error = result;
-	}
-
 	return error ?: count;
 }
 
+#define IMS_PCU_OFN_BIT_ATTR(_field, _addr, _nr)			\
+struct ims_pcu_ofn_bit_attribute ims_pcu_ofn_attr_##_field = {		\
+	.dattr = __ATTR(_field, S_IWUSR | S_IRUGO,			\
+			ims_pcu_ofn_bit_show, ims_pcu_ofn_bit_store),	\
+	.addr = _addr,							\
+	.nr = _nr,							\
+}
 
-#define IMS_PCU_BIT_ATTR(name, addr, nr)				\
-	static ssize_t ims_pcu_##name##_show(struct device *dev,	\
-					     struct device_attribute *dattr, \
-					     char *buf)			\
-	{								\
-		return ims_pcu_ofn_bit_show(addr, nr, dev, dattr, buf);	\
-	}								\
-									\
-	static ssize_t ims_pcu_##name##_store(struct device *dev,	\
-					      struct device_attribute *dattr, \
-					      const char *buf, size_t count) \
-	{								\
-		return ims_pcu_ofn_bit_store(addr, nr, dev, dattr, buf, count); \
-	}								\
-									\
-	static DEVICE_ATTR(name, S_IRUGO | S_IWUSR,			\
-			   ims_pcu_##name##_show, ims_pcu_##name##_store)
-
-IMS_PCU_BIT_ATTR(ofn_engine_enable,   0x60, 7);
-IMS_PCU_BIT_ATTR(ofn_speed_enable,    0x60, 6);
-IMS_PCU_BIT_ATTR(ofn_assert_enable,   0x60, 5);
-IMS_PCU_BIT_ATTR(ofn_xyquant_enable,  0x60, 4);
-IMS_PCU_BIT_ATTR(ofn_xyscale_enable,  0x60, 1);
-
-IMS_PCU_BIT_ATTR(ofn_scale_x2,        0x63, 6);
-IMS_PCU_BIT_ATTR(ofn_scale_y2,        0x63, 7);
-
-static struct attribute *ims_pcu_attrs[] = {
-	&ims_pcu_attr_part_number.dattr.attr,
-	&ims_pcu_attr_serial_number.dattr.attr,
-	&ims_pcu_attr_date_of_manufacturing.dattr.attr,
-	&ims_pcu_attr_fw_version.dattr.attr,
-	&ims_pcu_attr_bl_version.dattr.attr,
-	&ims_pcu_attr_reset_reason.dattr.attr,
-	&dev_attr_reset_device.attr,
-	&dev_attr_update_firmware.attr,
-	&dev_attr_update_firmware_status.attr,
-
-#define IMS_PCU_ATTRS_OFN_START_OFFSET (9)
-
-	&dev_attr_ofn_reg_data.attr,
-	&dev_attr_ofn_reg_addr.attr,
-	&dev_attr_ofn_engine_enable.attr,
-	&dev_attr_ofn_speed_enable.attr,
-	&dev_attr_ofn_assert_enable.attr,
-	&dev_attr_ofn_xyquant_enable.attr,
-	&dev_attr_ofn_xyscale_enable.attr,
-	&dev_attr_ofn_scale_x2.attr,
-	&dev_attr_ofn_scale_y2.attr,
+static IMS_PCU_OFN_BIT_ATTR(engine_enable,   0x60, 7);
+static IMS_PCU_OFN_BIT_ATTR(speed_enable,    0x60, 6);
+static IMS_PCU_OFN_BIT_ATTR(assert_enable,   0x60, 5);
+static IMS_PCU_OFN_BIT_ATTR(xyquant_enable,  0x60, 4);
+static IMS_PCU_OFN_BIT_ATTR(xyscale_enable,  0x60, 1);
+
+static IMS_PCU_OFN_BIT_ATTR(scale_x2,        0x63, 6);
+static IMS_PCU_OFN_BIT_ATTR(scale_y2,        0x63, 7);
+
+static struct attribute *ims_pcu_ofn_attrs[] = {
+	&dev_attr_reg_data.attr,
+	&dev_attr_reg_addr.attr,
+	&ims_pcu_ofn_attr_engine_enable.dattr.attr,
+	&ims_pcu_ofn_attr_speed_enable.dattr.attr,
+	&ims_pcu_ofn_attr_assert_enable.dattr.attr,
+	&ims_pcu_ofn_attr_xyquant_enable.dattr.attr,
+	&ims_pcu_ofn_attr_xyscale_enable.dattr.attr,
+	&ims_pcu_ofn_attr_scale_x2.dattr.attr,
+	&ims_pcu_ofn_attr_scale_y2.dattr.attr,
 	NULL
 };
 
-static umode_t ims_pcu_is_attr_visible(struct kobject *kobj,
-				       struct attribute *attr, int n)
-{
-	struct device *dev = container_of(kobj, struct device, kobj);
-	struct usb_interface *intf = to_usb_interface(dev);
-	struct ims_pcu *pcu = usb_get_intfdata(intf);
-	umode_t mode = attr->mode;
-
-	if (pcu->bootloader_mode) {
-		if (attr != &dev_attr_update_firmware_status.attr &&
-		    attr != &dev_attr_update_firmware.attr &&
-		    attr != &dev_attr_reset_device.attr) {
-			mode = 0;
-		}
-	} else {
-		if (attr == &dev_attr_update_firmware_status.attr) {
-			mode = 0;
-		} else if (pcu->setup_complete && pcu->device_id == 5) {
-			/*
-			   PCU-B devices, both GEN_1 and GEN_2(device_id == 5),
-			   have no OFN sensor so exposing those attributes
-			   for them does not make any sense
-			*/
-			int i;
-			for (i = IMS_PCU_ATTRS_OFN_START_OFFSET; ims_pcu_attrs[i]; i++)
-				if (attr == ims_pcu_attrs[i]) {
-					mode = 0;
-					break;
-				}
-		}
-	}
-
-	return mode;
-}
-
-static struct attribute_group ims_pcu_attr_group = {
-	.is_visible	= ims_pcu_is_attr_visible,
-	.attrs		= ims_pcu_attrs,
+static struct attribute_group ims_pcu_ofn_attr_group = {
+	.name	= "ofn",
+	.attrs	= ims_pcu_ofn_attrs,
 };
 
 static void ims_pcu_irq(struct urb *urb)
@@ -1908,6 +1881,13 @@ static int ims_pcu_init_application_mode(struct ims_pcu *pcu)
 	/* Device appears to be operable, complete initialization */
 	pcu->device_no = atomic_inc_return(&device_no) - 1;
 
+	if (pcu->device_id != 5) {
+		error = sysfs_create_group(&pcu->dev->kobj,
+					   &ims_pcu_attr_group);
+		if (error)
+			return error;
+	}
+
 	error = ims_pcu_setup_backlight(pcu);
 	if (error)
 		return error;
@@ -1925,14 +1905,12 @@ static int ims_pcu_init_application_mode(struct ims_pcu *pcu)
 
 	pcu->setup_complete = true;
 
-	sysfs_update_group(&pcu->dev->kobj, &ims_pcu_attr_group);
-
 	return 0;
 
-err_destroy_backlight:
-	ims_pcu_destroy_backlight(pcu);
 err_destroy_buttons:
 	ims_pcu_destroy_buttons(pcu);
+err_destroy_backlight:
+	ims_pcu_destroy_backlight(pcu);
 	return error;
 }
 
@@ -1946,6 +1924,10 @@ static void ims_pcu_destroy_application_mode(struct ims_pcu *pcu)
 			ims_pcu_destroy_gamepad(pcu);
 		ims_pcu_destroy_buttons(pcu);
 		ims_pcu_destroy_backlight(pcu);
+
+		if (pcu->device_id != 5)
+			sysfs_remove_group(&pcu->dev->kobj,
+					   &ims_pcu_ofn_attr_group);
 	}
 }
 
