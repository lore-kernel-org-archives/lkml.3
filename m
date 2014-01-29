Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbaA2JYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:24:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:26913 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbaA2JYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:24:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,741,1384329600"; 
   d="scan'208";a="474351133"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] HID: i2c-hid: add runtime PM support
Date: Wed, 29 Jan 2014 11:24:36 +0200
Message-Id: <1390987476-1905-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds runtime PM support for the HID over I2C driver. When the
i2c-hid device is first opened we power it on and on the last close we
power it off. This is actually what the driver is already doing but in
addition it allows subsystems, like ACPI power domain to power off the
device during runtime PM suspend, which should save even more power.

The implementation is not the most power efficient because it needs some
interaction from the userspace (e.g close the device node whenever we are
no more interested in getting events), nevertheless it allows us to save
some power and works with devices that are not wake capable.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
v2:
  - Update changelog to mention that ACPI power domain for example can
    power off the device on suspend.
  - Make i2c_hid_power to just call RPM get/put

 drivers/hid/i2c-hid/i2c-hid.c | 68 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 57 insertions(+), 11 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index d1f81f52481a..923ff818a1bf 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -25,6 +25,7 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/pm.h>
+#include <linux/pm_runtime.h>
 #include <linux/device.h>
 #include <linux/wait.h>
 #include <linux/err.h>
@@ -454,10 +455,18 @@ static void i2c_hid_init_reports(struct hid_device *hid)
 		return;
 	}
 
+	/*
+	 * The device must be powered on while we fetch initial reports
+	 * from it.
+	 */
+	pm_runtime_get_sync(&client->dev);
+
 	list_for_each_entry(report,
 		&hid->report_enum[HID_FEATURE_REPORT].report_list, list)
 		i2c_hid_init_report(report, inbuf, ihid->bufsize);
 
+	pm_runtime_put(&client->dev);
+
 	kfree(inbuf);
 }
 
@@ -703,8 +712,8 @@ static int i2c_hid_open(struct hid_device *hid)
 
 	mutex_lock(&i2c_hid_open_mut);
 	if (!hid->open++) {
-		ret = i2c_hid_set_power(client, I2C_HID_PWR_ON);
-		if (ret) {
+		ret = pm_runtime_get_sync(&client->dev);
+		if (ret < 0) {
 			hid->open--;
 			goto done;
 		}
@@ -712,7 +721,7 @@ static int i2c_hid_open(struct hid_device *hid)
 	}
 done:
 	mutex_unlock(&i2c_hid_open_mut);
-	return ret;
+	return ret < 0 ? ret : 0;
 }
 
 static void i2c_hid_close(struct hid_device *hid)
@@ -729,7 +738,7 @@ static void i2c_hid_close(struct hid_device *hid)
 		clear_bit(I2C_HID_STARTED, &ihid->flags);
 
 		/* Save some power */
-		i2c_hid_set_power(client, I2C_HID_PWR_SLEEP);
+		pm_runtime_put(&client->dev);
 	}
 	mutex_unlock(&i2c_hid_open_mut);
 }
@@ -738,19 +747,18 @@ static int i2c_hid_power(struct hid_device *hid, int lvl)
 {
 	struct i2c_client *client = hid->driver_data;
 	struct i2c_hid *ihid = i2c_get_clientdata(client);
-	int ret = 0;
 
 	i2c_hid_dbg(ihid, "%s lvl:%d\n", __func__, lvl);
 
 	switch (lvl) {
 	case PM_HINT_FULLON:
-		ret = i2c_hid_set_power(client, I2C_HID_PWR_ON);
+		pm_runtime_get_sync(&client->dev);
 		break;
 	case PM_HINT_NORMAL:
-		ret = i2c_hid_set_power(client, I2C_HID_PWR_SLEEP);
+		pm_runtime_put(&client->dev);
 		break;
 	}
-	return ret;
+	return 0;
 }
 
 static struct hid_ll_driver i2c_hid_ll_driver = {
@@ -973,13 +981,17 @@ static int i2c_hid_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto err;
 
+	pm_runtime_get_noresume(&client->dev);
+	pm_runtime_set_active(&client->dev);
+	pm_runtime_enable(&client->dev);
+
 	ret = i2c_hid_fetch_hid_descriptor(ihid);
 	if (ret < 0)
-		goto err;
+		goto err_pm;
 
 	ret = i2c_hid_init_irq(client);
 	if (ret < 0)
-		goto err;
+		goto err_pm;
 
 	hid = hid_allocate_device();
 	if (IS_ERR(hid)) {
@@ -1010,6 +1022,7 @@ static int i2c_hid_probe(struct i2c_client *client,
 		goto err_mem_free;
 	}
 
+	pm_runtime_put(&client->dev);
 	return 0;
 
 err_mem_free:
@@ -1018,6 +1031,10 @@ err_mem_free:
 err_irq:
 	free_irq(client->irq, ihid);
 
+err_pm:
+	pm_runtime_put_noidle(&client->dev);
+	pm_runtime_disable(&client->dev);
+
 err:
 	i2c_hid_free_buffers(ihid);
 	kfree(ihid);
@@ -1029,6 +1046,11 @@ static int i2c_hid_remove(struct i2c_client *client)
 	struct i2c_hid *ihid = i2c_get_clientdata(client);
 	struct hid_device *hid;
 
+	pm_runtime_get_sync(&client->dev);
+	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
+	pm_runtime_put_noidle(&client->dev);
+
 	hid = ihid->hid;
 	hid_destroy_device(hid);
 
@@ -1074,7 +1096,31 @@ static int i2c_hid_resume(struct device *dev)
 }
 #endif
 
-static SIMPLE_DEV_PM_OPS(i2c_hid_pm, i2c_hid_suspend, i2c_hid_resume);
+#ifdef CONFIG_PM_RUNTIME
+static int i2c_hid_runtime_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+
+	i2c_hid_set_power(client, I2C_HID_PWR_SLEEP);
+	disable_irq(client->irq);
+	return 0;
+}
+
+static int i2c_hid_runtime_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+
+	enable_irq(client->irq);
+	i2c_hid_set_power(client, I2C_HID_PWR_ON);
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops i2c_hid_pm = {
+	SET_SYSTEM_SLEEP_PM_OPS(i2c_hid_suspend, i2c_hid_resume)
+	SET_RUNTIME_PM_OPS(i2c_hid_runtime_suspend, i2c_hid_runtime_resume,
+			   NULL)
+};
 
 static const struct i2c_device_id i2c_hid_id_table[] = {
 	{ "hid", 0 },
-- 
1.8.5.2

