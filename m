Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbaAVNUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:20:45 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:43901 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462AbaAVNUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:20:43 -0500
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: linux-input@vger.kernel.org
Cc: andrew.smirnov@gmail.com, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] ims-pcu: Add commands supported by the new version of the FW
Date: Wed, 22 Jan 2014 05:20:25 -0800
Message-Id: <1390396825-10255-1-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New version of the PCU firmware supports two new commands:
  - IMS_PCU_CMD_OFN_SET_CONFIG which allows to write data to the
  registers of one finger navigation(OFN) chip present on the device
  - IMS_PCU_CMD_OFN_GET_CONFIG which allows to read data form the
  registers of said chip.

This commit adds two helper functions to use those commands and sysfs
attributes to use them. It also exposes some OFN configuration
parameters via sysfs.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/misc/ims-pcu.c | 260 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 251 insertions(+), 9 deletions(-)

diff --git a/drivers/input/misc/ims-pcu.c b/drivers/input/misc/ims-pcu.c
index e204f26..1d084d9 100644
--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -51,6 +51,8 @@ struct ims_pcu_backlight {
 #define IMS_PCU_BL_VERSION_LEN		(9 + 1)
 #define IMS_PCU_BL_RESET_REASON_LEN	(2 + 1)
 
+#define IMS_PCU_PCU_B_DEVICE_ID		5
+
 #define IMS_PCU_BUF_SIZE		128
 
 struct ims_pcu {
@@ -68,6 +70,9 @@ struct ims_pcu {
 	char bl_version[IMS_PCU_BL_VERSION_LEN];
 	char reset_reason[IMS_PCU_BL_RESET_REASON_LEN];
 	int update_firmware_status;
+	u8 device_id;
+
+	u8 ofn_reg_addr;
 
 	struct usb_interface *ctrl_intf;
 
@@ -371,6 +376,8 @@ static void ims_pcu_destroy_gamepad(struct ims_pcu *pcu)
 #define IMS_PCU_CMD_GET_DEVICE_ID	0xae
 #define IMS_PCU_CMD_SPECIAL_INFO	0xb0
 #define IMS_PCU_CMD_BOOTLOADER		0xb1	/* Pass data to bootloader */
+#define IMS_PCU_CMD_OFN_SET_CONFIG	0xb3
+#define IMS_PCU_CMD_OFN_GET_CONFIG	0xb4
 
 /* PCU responses */
 #define IMS_PCU_RSP_STATUS		0xc0
@@ -389,6 +396,9 @@ static void ims_pcu_destroy_gamepad(struct ims_pcu *pcu)
 #define IMS_PCU_RSP_GET_DEVICE_ID	0xce
 #define IMS_PCU_RSP_SPECIAL_INFO	0xd0
 #define IMS_PCU_RSP_BOOTLOADER		0xd1	/* Bootloader response */
+#define IMS_PCU_RSP_OFN_SET_CONFIG	0xd2
+#define IMS_PCU_RSP_OFN_GET_CONFIG	0xd3
+
 
 #define IMS_PCU_RSP_EVNT_BUTTONS	0xe0	/* Unsolicited, button state */
 #define IMS_PCU_GAMEPAD_MASK		0x0001ff80UL	/* Bits 7 through 16 */
@@ -1226,7 +1236,7 @@ static struct attribute *ims_pcu_attrs[] = {
 	&dev_attr_reset_device.attr,
 	&dev_attr_update_firmware.attr,
 	&dev_attr_update_firmware_status.attr,
-	NULL
+	NULL,
 };
 
 static umode_t ims_pcu_is_attr_visible(struct kobject *kobj,
@@ -1256,6 +1266,225 @@ static struct attribute_group ims_pcu_attr_group = {
 	.attrs		= ims_pcu_attrs,
 };
 
+/* Support for a separate OFN attribute group */
+
+#define OFN_REG_RESULT_OFFSET	2
+
+static int ims_pcu_read_ofn_config(struct ims_pcu *pcu, u8 addr, u8 *data)
+{
+	int error;
+	s16 result;
+
+	error = ims_pcu_execute_command(pcu, OFN_GET_CONFIG,
+					&addr, sizeof(addr));
+	if (error)
+		return error;
+
+	result = (s16)get_unaligned_le16(pcu->cmd_buf + OFN_REG_RESULT_OFFSET);
+	if (result < 0)
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
+	result = (s16)get_unaligned_le16(pcu->cmd_buf + OFN_REG_RESULT_OFFSET);
+	if ((result < 0)
+		return -EIO;
+
+	return 0;
+}
+
+static ssize_t ims_pcu_ofn_reg_data_show(struct device *dev,
+					 struct device_attribute *dattr,
+					 char *buf)
+{
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct ims_pcu *pcu = usb_get_intfdata(intf);
+	int error;
+	u8 data;
+
+	mutex_lock(&pcu->cmd_mutex);
+	error = ims_pcu_read_ofn_config(pcu, pcu->ofn_reg_addr, &data);
+	mutex_unlock(&pcu->cmd_mutex);
+
+	if (error)
+		return error;
+
+	return scnprintf(buf, PAGE_SIZE, "%x\n", data);
+}
+
+static ssize_t ims_pcu_ofn_reg_data_store(struct device *dev,
+					  struct device_attribute *dattr,
+					  const char *buf, size_t count)
+{
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct ims_pcu *pcu = usb_get_intfdata(intf);
+	int error;
+	u8 value;
+
+	error = kstrtou8(buf, 0, &value);
+	if (error)
+		return error;
+
+	mutex_lock(&pcu->cmd_mutex);
+	error = ims_pcu_write_ofn_config(pcu, pcu->ofn_reg_addr, value);
+	mutex_unlock(&pcu->cmd_mutex);
+
+	return error ?: count;
+}
+
+static DEVICE_ATTR(reg_data, S_IRUGO | S_IWUSR,
+		   ims_pcu_ofn_reg_data_show, ims_pcu_ofn_reg_data_store);
+
+static ssize_t ims_pcu_ofn_reg_addr_show(struct device *dev,
+					 struct device_attribute *dattr,
+					 char *buf)
+{
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct ims_pcu *pcu = usb_get_intfdata(intf);
+	int error;
+
+	mutex_lock(&pcu->cmd_mutex);
+	error = scnprintf(buf, PAGE_SIZE, "%x\n", pcu->ofn_reg_addr);
+	mutex_unlock(&pcu->cmd_mutex);
+
+	return error;
+}
+
+static ssize_t ims_pcu_ofn_reg_addr_store(struct device *dev,
+					  struct device_attribute *dattr,
+					  const char *buf, size_t count)
+{
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct ims_pcu *pcu = usb_get_intfdata(intf);
+	int error;
+	u8 value;
+
+	error = kstrtou8(buf, 0, &value);
+	if (error)
+		return error;
+
+	mutex_lock(&pcu->cmd_mutex);
+	pcu->ofn_reg_addr = value;
+	mutex_unlock(&pcu->cmd_mutex);
+
+	return error ?: count;
+}
+
+static DEVICE_ATTR(reg_addr, S_IRUGO | S_IWUSR,
+		   ims_pcu_ofn_reg_addr_show, ims_pcu_ofn_reg_addr_store);
+
+struct ims_pcu_ofn_bit_attribute {
+	struct device_attribute dattr;
+	u8 addr;
+	u8 nr;
+};
+
+static ssize_t ims_pcu_ofn_bit_show(struct device *dev,
+				    struct device_attribute *dattr,
+				    char *buf)
+{
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct ims_pcu *pcu = usb_get_intfdata(intf);
+	struct ims_pcu_ofn_bit_attribute *attr =
+		container_of(dattr, struct ims_pcu_ofn_bit_attribute, dattr);
+	int error;
+	u8 data;
+
+	mutex_lock(&pcu->cmd_mutex);
+	error = ims_pcu_read_ofn_config(pcu, attr->addr, &data);
+	mutex_unlock(&pcu->cmd_mutex);
+
+	if (error)
+		return error;
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", !!(data & (1 << attr->nr)));
+}
+
+static ssize_t ims_pcu_ofn_bit_store(struct device *dev,
+				     struct device_attribute *dattr,
+				     const char *buf, size_t count)
+{
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct ims_pcu *pcu = usb_get_intfdata(intf);
+	struct ims_pcu_ofn_bit_attribute *attr =
+		container_of(dattr, struct ims_pcu_ofn_bit_attribute, dattr);
+	int error;
+	int value;
+	u8 data;
+
+	error = kstrtoint(buf, 0, &value);
+	if (error)
+		return error;
+
+	if (value > 1)
+		return -EINVAL;
+
+	mutex_lock(&pcu->cmd_mutex);
+
+	error = ims_pcu_read_ofn_config(pcu, attr->addr, &data);
+	if (!error) {
+		if (value)
+			data |= 1U << attr->nr;
+		else
+			data &= ~(1U << attr->nr);
+
+		error = ims_pcu_write_ofn_config(pcu, attr->addr, data);
+	}
+
+	mutex_unlock(&pcu->cmd_mutex);
+
+	return error ?: count;
+}
+
+#define IMS_PCU_OFN_BIT_ATTR(_field, _addr, _nr)			\
+struct ims_pcu_ofn_bit_attribute ims_pcu_ofn_attr_##_field = {		\
+	.dattr = __ATTR(_field, S_IWUSR | S_IRUGO,			\
+			ims_pcu_ofn_bit_show, ims_pcu_ofn_bit_store),	\
+	.addr = _addr,							\
+	.nr = _nr,							\
+}
+
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
+	NULL
+};
+
+static struct attribute_group ims_pcu_ofn_attr_group = {
+	.name	= "ofn",
+	.attrs	= ims_pcu_ofn_attrs,
+};
+
 static void ims_pcu_irq(struct urb *urb)
 {
 	struct ims_pcu *pcu = urb->context;
@@ -1624,7 +1853,6 @@ static int ims_pcu_init_application_mode(struct ims_pcu *pcu)
 	static atomic_t device_no = ATOMIC_INIT(0);
 
 	const struct ims_pcu_device_info *info;
-	u8 device_id;
 	int error;
 
 	error = ims_pcu_get_device_info(pcu);
@@ -1633,7 +1861,7 @@ static int ims_pcu_init_application_mode(struct ims_pcu *pcu)
 		return error;
 	}
 
-	error = ims_pcu_identify_type(pcu, &device_id);
+	error = ims_pcu_identify_type(pcu, &pcu->device_id);
 	if (error) {
 		dev_err(pcu->dev,
 			"Failed to identify device, error: %d\n", error);
@@ -1645,9 +1873,9 @@ static int ims_pcu_init_application_mode(struct ims_pcu *pcu)
 		return 0;
 	}
 
-	if (device_id >= ARRAY_SIZE(ims_pcu_device_info) ||
-	    !ims_pcu_device_info[device_id].keymap) {
-		dev_err(pcu->dev, "Device ID %d is not valid\n", device_id);
+	if (pcu->device_id >= ARRAY_SIZE(ims_pcu_device_info) ||
+	    !ims_pcu_device_info[pcu->device_id].keymap) {
+		dev_err(pcu->dev, "Device ID %d is not valid\n", pcu->device_id);
 		/* Same as above, punt to userspace */
 		return 0;
 	}
@@ -1655,11 +1883,21 @@ static int ims_pcu_init_application_mode(struct ims_pcu *pcu)
 	/* Device appears to be operable, complete initialization */
 	pcu->device_no = atomic_inc_return(&device_no) - 1;
 
+	/*
+	   PCU-B devices, both GEN_1 and GEN_2 do not have OFN sensor
+	*/
+	if (pcu->device_id != IMS_PCU_PCU_B_DEVICE_ID) {
+		error = sysfs_create_group(&pcu->dev->kobj,
+					   &ims_pcu_ofn_attr_group);
+		if (error)
+			return error;
+	}
+
 	error = ims_pcu_setup_backlight(pcu);
 	if (error)
 		return error;
 
-	info = &ims_pcu_device_info[device_id];
+	info = &ims_pcu_device_info[pcu->device_id];
 	error = ims_pcu_setup_buttons(pcu, info->keymap, info->keymap_len);
 	if (error)
 		goto err_destroy_backlight;
@@ -1674,10 +1912,10 @@ static int ims_pcu_init_application_mode(struct ims_pcu *pcu)
 
 	return 0;
 
-err_destroy_backlight:
-	ims_pcu_destroy_backlight(pcu);
 err_destroy_buttons:
 	ims_pcu_destroy_buttons(pcu);
+err_destroy_backlight:
+	ims_pcu_destroy_backlight(pcu);
 	return error;
 }
 
@@ -1691,6 +1929,10 @@ static void ims_pcu_destroy_application_mode(struct ims_pcu *pcu)
 			ims_pcu_destroy_gamepad(pcu);
 		ims_pcu_destroy_buttons(pcu);
 		ims_pcu_destroy_backlight(pcu);
+
+		if (pcu->device_id != IMS_PCU_PCU_B_DEVICE_ID)
+			sysfs_remove_group(&pcu->dev->kobj,
+					   &ims_pcu_ofn_attr_group);
 	}
 }
 
-- 
1.8.3.2

