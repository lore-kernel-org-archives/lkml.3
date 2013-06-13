Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab3FMHuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 03:50:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478Ab3FMHup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 03:50:45 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] HID: i2c-hid: add DT bindings
Date: Thu, 13 Jun 2013 09:50:35 +0200
Message-Id: <1371109835-30796-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree based support for HID over I2C devices.

Tested on an Odroid-X board with a Synaptics touchpad.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Hi guys,

well, as the commit message says, this is the DT binding for HID over I2C.
I honestly don't know if it will be used besides me, but it may help others
with a DT based board.
As the spec is for ACPI only, I had no specifications regarding the DT names. So
these names can be changed if you think they are bad.

I also created a new bindings directory in the devicetree doc to reflect the
split we have between input and hid. However, if the DT experts prefer having
it under input, I'm fine with that.

Cheers,
Benjamin

 .../devicetree/bindings/hid/hid-over-i2c.txt       | 28 ++++++++++++++
 drivers/hid/i2c-hid/i2c-hid.c                      | 44 +++++++++++++++++++++-
 include/linux/i2c/i2c-hid.h                        |  3 +-
 3 files changed, 73 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hid/hid-over-i2c.txt

diff --git a/Documentation/devicetree/bindings/hid/hid-over-i2c.txt b/Documentation/devicetree/bindings/hid/hid-over-i2c.txt
new file mode 100644
index 0000000..488edcb
--- /dev/null
+++ b/Documentation/devicetree/bindings/hid/hid-over-i2c.txt
@@ -0,0 +1,28 @@
+* HID over I2C Device-Tree bindings
+
+HID over I2C provides support for various Human Interface Devices over the
+I2C bus. These devices can be for example touchpads, keyboards, touch screens
+or sensors.
+
+The specification has been written by Microsoft and is currently available here:
+http://msdn.microsoft.com/en-us/library/windows/hardware/hh852380.aspx
+
+If this binding is used, the kernel module i2c-hid will handle the communication
+with the device and the generic hid core layer will handle the protocol.
+
+Required properties:
+- compatible: must be "hid-over-i2c"
+- reg: i2c slave address
+- hid-descr-addr: HID descriptor address
+- interrupt-parent: the phandle for the interrupt controller
+- interrupts: interrupt line
+
+Example:
+
+	i2c-hid-dev@2c {
+		compatible = "hid-over-i2c";
+		reg = <0x2c>;
+		hid-descr-addr = <0x0020>;
+		interrupt-parent = <&gpx3>;
+		interrupts = <3 2>;
+	};
diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index 2b1799a..85b15a8 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -35,6 +35,7 @@
 #include <linux/hid.h>
 #include <linux/mutex.h>
 #include <linux/acpi.h>
+#include <linux/of.h>
 
 #include <linux/i2c/i2c-hid.h>
 
@@ -919,6 +920,42 @@ static inline int i2c_hid_acpi_pdata(struct i2c_client *client,
 }
 #endif
 
+#ifdef CONFIG_OF
+static int i2c_hid_of_probe(struct i2c_client *client,
+		struct i2c_hid_platform_data *pdata)
+{
+	struct device *dev = &client->dev;
+	u32 val;
+	int ret;
+
+	ret = of_property_read_u32(dev->of_node, "hid-descr-addr", &val);
+	if (ret) {
+		dev_err(&client->dev, "HID register address not provided\n");
+		return -ENODEV;
+	}
+	if (val >> 16) {
+		dev_err(&client->dev, "Bad HID register address: 0x%08x\n",
+			val);
+		return -EINVAL;
+	}
+	pdata->hid_descriptor_address = val;
+
+	return 0;
+}
+
+static const struct of_device_id i2c_hid_of_match[] = {
+	{ .compatible = "hid-over-i2c" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, i2c_hid_of_match);
+#else
+static inline int i2c_hid_of_probe(struct i2c_client *client,
+		struct i2c_hid_platform_data *pdata)
+{
+	return -ENODEV;
+}
+#endif
+
 static int i2c_hid_probe(struct i2c_client *client,
 			 const struct i2c_device_id *dev_id)
 {
@@ -940,7 +977,11 @@ static int i2c_hid_probe(struct i2c_client *client,
 	if (!ihid)
 		return -ENOMEM;
 
-	if (!platform_data) {
+	if (client->dev.of_node) {
+		ret = i2c_hid_of_probe(client, &ihid->pdata);
+		if (ret)
+			goto err;
+	} else if (!platform_data) {
 		ret = i2c_hid_acpi_pdata(client, &ihid->pdata);
 		if (ret) {
 			dev_err(&client->dev,
@@ -1081,6 +1122,7 @@ static struct i2c_driver i2c_hid_driver = {
 		.owner	= THIS_MODULE,
 		.pm	= &i2c_hid_pm,
 		.acpi_match_table = ACPI_PTR(i2c_hid_acpi_match),
+		.of_match_table = of_match_ptr(i2c_hid_of_match),
 	},
 
 	.probe		= i2c_hid_probe,
diff --git a/include/linux/i2c/i2c-hid.h b/include/linux/i2c/i2c-hid.h
index 60e411d..7aa901d 100644
--- a/include/linux/i2c/i2c-hid.h
+++ b/include/linux/i2c/i2c-hid.h
@@ -19,7 +19,8 @@
  * @hid_descriptor_address: i2c register where the HID descriptor is stored.
  *
  * Note that it is the responsibility of the platform driver (or the acpi 5.0
- * driver) to setup the irq related to the gpio in the struct i2c_board_info.
+ * driver, or the flattened device tree) to setup the irq related to the gpio in
+ * the struct i2c_board_info.
  * The platform driver should also setup the gpio according to the device:
  *
  * A typical example is the following:
-- 
1.8.2.1

