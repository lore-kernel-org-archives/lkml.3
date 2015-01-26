Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbbAZO3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:29:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:25737 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755283AbbAZO3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:29:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,469,1418112000"; 
   d="scan'208";a="667649497"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] HID: i2c-hid: Add support for GPIO interrupts
Date: Mon, 26 Jan 2015 16:29:33 +0200
Message-Id: <1422282573-18215-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422282573-18215-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1422282573-18215-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HID over I2C specification allows to have the interrupt for a HID
device to be GPIO instead of directly connected to the IO-APIC.

Add support for this so that when the driver does not find proper interrupt
number from the I2C client structure we check if the device has property
named "gpios". This is then assumed to be the GPIO that serves as an
interrupt for the device.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 .../devicetree/bindings/hid/hid-over-i2c.txt       |  5 +-
 drivers/hid/i2c-hid/i2c-hid.c                      | 70 ++++++++++++++++------
 2 files changed, 56 insertions(+), 19 deletions(-)

diff --git a/Documentation/devicetree/bindings/hid/hid-over-i2c.txt b/Documentation/devicetree/bindings/hid/hid-over-i2c.txt
index 488edcb264c4..8f4a99dad3b9 100644
--- a/Documentation/devicetree/bindings/hid/hid-over-i2c.txt
+++ b/Documentation/devicetree/bindings/hid/hid-over-i2c.txt
@@ -15,7 +15,10 @@ Required properties:
 - reg: i2c slave address
 - hid-descr-addr: HID descriptor address
 - interrupt-parent: the phandle for the interrupt controller
-- interrupts: interrupt line
+- interrupts: interrupt line if the device uses IO-APIC interrupts
+
+Optional properties:
+- gpios: GPIO used as an interrupt if the device uses GPIO interrupts
 
 Example:
 
diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index 8f1dfc5c5d9c..d3c49ff4888e 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -37,6 +37,7 @@
 #include <linux/mutex.h>
 #include <linux/acpi.h>
 #include <linux/of.h>
+#include <linux/gpio/consumer.h>
 
 #include <linux/i2c/i2c-hid.h>
 
@@ -144,6 +145,8 @@ struct i2c_hid {
 	unsigned long		flags;		/* device flags */
 
 	wait_queue_head_t	wait;		/* For waiting the interrupt */
+	struct gpio_desc	*desc;
+	int			irq;
 
 	struct i2c_hid_platform_data pdata;
 };
@@ -782,16 +785,16 @@ static int i2c_hid_init_irq(struct i2c_client *client)
 	struct i2c_hid *ihid = i2c_get_clientdata(client);
 	int ret;
 
-	dev_dbg(&client->dev, "Requesting IRQ: %d\n", client->irq);
+	dev_dbg(&client->dev, "Requesting IRQ: %d\n", ihid->irq);
 
-	ret = request_threaded_irq(client->irq, NULL, i2c_hid_irq,
+	ret = request_threaded_irq(ihid->irq, NULL, i2c_hid_irq,
 			IRQF_TRIGGER_LOW | IRQF_ONESHOT,
 			client->name, ihid);
 	if (ret < 0) {
 		dev_warn(&client->dev,
 			"Could not register for %s interrupt, irq = %d,"
 			" ret = %d\n",
-			client->name, client->irq, ret);
+			client->name, ihid->irq, ret);
 
 		return ret;
 	}
@@ -838,6 +841,14 @@ static int i2c_hid_fetch_hid_descriptor(struct i2c_hid *ihid)
 }
 
 #ifdef CONFIG_ACPI
+
+/* Default GPIO mapping */
+static const struct acpi_gpio_params i2c_hid_irq_gpio = { 0, 0, true };
+static const struct acpi_gpio_mapping i2c_hid_acpi_gpios[] = {
+	{ "gpios", &i2c_hid_irq_gpio, 1 },
+	{ },
+};
+
 static int i2c_hid_acpi_pdata(struct i2c_client *client,
 		struct i2c_hid_platform_data *pdata)
 {
@@ -863,7 +874,7 @@ static int i2c_hid_acpi_pdata(struct i2c_client *client,
 	pdata->hid_descriptor_address = obj->integer.value;
 	ACPI_FREE(obj);
 
-	return 0;
+	return acpi_dev_add_driver_gpios(adev, i2c_hid_acpi_gpios);
 }
 
 static const struct acpi_device_id i2c_hid_acpi_match[] = {
@@ -927,12 +938,6 @@ static int i2c_hid_probe(struct i2c_client *client,
 
 	dbg_hid("HID probe called for i2c 0x%02x\n", client->addr);
 
-	if (!client->irq) {
-		dev_err(&client->dev,
-			"HID over i2c has not been provided an Int IRQ\n");
-		return -EINVAL;
-	}
-
 	ihid = kzalloc(sizeof(struct i2c_hid), GFP_KERNEL);
 	if (!ihid)
 		return -ENOMEM;
@@ -952,6 +957,25 @@ static int i2c_hid_probe(struct i2c_client *client,
 		ihid->pdata = *platform_data;
 	}
 
+	if (client->irq > 0) {
+		ihid->irq = client->irq;
+	} else {
+		ihid->desc = gpiod_get(&client->dev, NULL);
+		if (IS_ERR(ihid->desc)) {
+			dev_err(&client->dev, "Failed to get GPIO interrupt\n");
+			return PTR_ERR(ihid->desc);
+		}
+
+		gpiod_direction_input(ihid->desc);
+
+		ihid->irq = gpiod_to_irq(ihid->desc);
+		if (ihid->irq < 0) {
+			gpiod_put(ihid->desc);
+			dev_err(&client->dev, "Failed to convert GPIO to IRQ\n");
+			return ihid->irq;
+		}
+	}
+
 	i2c_set_clientdata(client, ihid);
 
 	ihid->client = client;
@@ -1014,13 +1038,16 @@ err_mem_free:
 	hid_destroy_device(hid);
 
 err_irq:
-	free_irq(client->irq, ihid);
+	free_irq(ihid->irq, ihid);
 
 err_pm:
 	pm_runtime_put_noidle(&client->dev);
 	pm_runtime_disable(&client->dev);
 
 err:
+	if (ihid->desc)
+		gpiod_put(ihid->desc);
+
 	i2c_hid_free_buffers(ihid);
 	kfree(ihid);
 	return ret;
@@ -1039,13 +1066,18 @@ static int i2c_hid_remove(struct i2c_client *client)
 	hid = ihid->hid;
 	hid_destroy_device(hid);
 
-	free_irq(client->irq, ihid);
+	free_irq(ihid->irq, ihid);
 
 	if (ihid->bufsize)
 		i2c_hid_free_buffers(ihid);
 
+	if (ihid->desc)
+		gpiod_put(ihid->desc);
+
 	kfree(ihid);
 
+	acpi_dev_remove_driver_gpios(ACPI_COMPANION(&client->dev));
+
 	return 0;
 }
 
@@ -1057,9 +1089,9 @@ static int i2c_hid_suspend(struct device *dev)
 	struct hid_device *hid = ihid->hid;
 	int ret = 0;
 
-	disable_irq(client->irq);
+	disable_irq(ihid->irq);
 	if (device_may_wakeup(&client->dev))
-		enable_irq_wake(client->irq);
+		enable_irq_wake(ihid->irq);
 
 	if (hid->driver && hid->driver->suspend)
 		ret = hid->driver->suspend(hid, PMSG_SUSPEND);
@@ -1077,13 +1109,13 @@ static int i2c_hid_resume(struct device *dev)
 	struct i2c_hid *ihid = i2c_get_clientdata(client);
 	struct hid_device *hid = ihid->hid;
 
-	enable_irq(client->irq);
+	enable_irq(ihid->irq);
 	ret = i2c_hid_hwreset(client);
 	if (ret)
 		return ret;
 
 	if (device_may_wakeup(&client->dev))
-		disable_irq_wake(client->irq);
+		disable_irq_wake(ihid->irq);
 
 	if (hid->driver && hid->driver->reset_resume) {
 		ret = hid->driver->reset_resume(hid);
@@ -1098,17 +1130,19 @@ static int i2c_hid_resume(struct device *dev)
 static int i2c_hid_runtime_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_hid *ihid = i2c_get_clientdata(client);
 
 	i2c_hid_set_power(client, I2C_HID_PWR_SLEEP);
-	disable_irq(client->irq);
+	disable_irq(ihid->irq);
 	return 0;
 }
 
 static int i2c_hid_runtime_resume(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_hid *ihid = i2c_get_clientdata(client);
 
-	enable_irq(client->irq);
+	enable_irq(ihid->irq);
 	i2c_hid_set_power(client, I2C_HID_PWR_ON);
 	return 0;
 }
-- 
2.1.4

