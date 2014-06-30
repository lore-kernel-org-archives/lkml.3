Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbaF3Gnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:43:32 -0400
Received: from relay-s04-hub004.domainlocalhost.com ([74.115.207.103]:23636
	"EHLO relay-S04-HUB004.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751910AbaF3Gnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:43:31 -0400
From: Dudley Du <dudl@cypress.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "patrikf@google.com" <patrikf@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Benson Leung <bleung@google.com>, Daniel Kurtz <djkurtz@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 4/14] input: cyapa: add cyapa key function interfaces in
 sysfs system
Thread-Topic: [PATCH v2 4/14] input: cyapa: add cyapa key function
 interfaces in sysfs system
Thread-Index: Ac+ULpgkzG9Rk9hfQVaFLUOhwOjB0A==
Date: Mon, 30 Jun 2014 06:43:28 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4C902C65@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.30.12.155]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5U6hc5Y009574

Add key basic function interfaces in cyapa driver in sysfs system,
these interfaces are commonly used in pre- and after production, and
for trackpad device state checking, manage and firmware image updating.
These interfaces including firmware_version and product_id interfaces
for reading firmware version and trackpad device product id values,
and including update_fw interface to command firmware image update
process. Also including baseline and calibrate interfaces, so can
read and check the trackpad device states. If the baseline values are
invalid, then can use calibrate interface to recover it.
TEST=test on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index c2b67d3..3b80de6 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -190,6 +190,17 @@ void cyapa_default_irq_handler(struct cyapa *cyapa)
 const struct cyapa_dev_ops cyapa_default_ops = {
        NULL,
        NULL,
+       NULL,
+       NULL,
+       NULL,
+       NULL,
+       NULL,
+
+       NULL,
+       NULL,
+
+       NULL,
+       NULL,

        NULL,
        NULL,
@@ -470,6 +481,78 @@ static void cyapa_detect(struct cyapa *cyapa)
        }
 }

+static int cyapa_firmware(struct cyapa *cyapa, const char *fw_name)
+{
+       struct device *dev = &cyapa->client->dev;
+       int ret;
+       const struct firmware *fw;
+
+       ret = request_firmware(&fw, fw_name, dev);
+       if (ret) {
+               dev_err(dev, "Could not load firmware from %s, %d\n",
+                       fw_name, ret);
+               return ret;
+       }
+
+       if (cyapa->ops->cyapa_check_fw) {
+               ret = cyapa->ops->cyapa_check_fw(cyapa, fw);
+               if (ret) {
+                       dev_err(dev, "Invalid CYAPA firmware image: %s\n",
+                                       fw_name);
+                       goto done;
+               }
+       } else {
+               dev_err(dev, "Unknown status, operation forbidden, gen=%d\n",
+                       cyapa->gen);
+               ret = -EPERM;
+               goto done;
+       }
+
+       /*
+        * Resume the potentially suspended device because doing FW
+        * update on a device not in the FULL mode has a chance to
+        * fail.
+        */
+       pm_runtime_get_sync(dev);
+
+       if (cyapa->ops->cyapa_bl_enter) {
+               ret = cyapa->ops->cyapa_bl_enter(cyapa);
+               if (ret)
+                       goto err_detect;
+       }
+
+       if (cyapa->ops->cyapa_bl_activate) {
+               ret = cyapa->ops->cyapa_bl_activate(cyapa);
+               if (ret)
+                       goto err_detect;
+       }
+
+       if (cyapa->ops->cyapa_bl_initiate) {
+               ret = cyapa->ops->cyapa_bl_initiate(cyapa, fw);
+               if (ret)
+                       goto err_detect;
+       }
+
+       if (cyapa->ops->cyapa_update_fw) {
+               ret = cyapa->ops->cyapa_update_fw(cyapa, fw);
+               if (ret)
+                       goto err_detect;
+       }
+
+       if (cyapa->ops->cyapa_bl_verify_app_integrity) {
+               ret = cyapa->ops->cyapa_bl_verify_app_integrity(cyapa);
+               if (ret)
+                       goto err_detect;
+       }
+
+err_detect:
+       pm_runtime_put_noidle(dev);
+
+done:
+       release_firmware(fw);
+       return ret;
+}
+
 /*
  * Sysfs Interface.
  */
@@ -656,6 +739,127 @@ static void cyapa_start_runtime(struct cyapa *cyapa)
 static void cyapa_start_runtime(struct cyapa *cyapa) {}
 #endif /* CONFIG_PM_RUNTIME */

+static ssize_t cyapa_show_fm_ver(struct device *dev,
+                                struct device_attribute *attr, char *buf)
+{
+       int ret;
+       struct cyapa *cyapa = dev_get_drvdata(dev);
+
+       if (!cyapa_state_sync_enter(cyapa))
+               return -EBUSY;
+
+       ret = scnprintf(buf, PAGE_SIZE, "%d.%d\n", cyapa->fw_maj_ver,
+                        cyapa->fw_min_ver);
+       cyapa_state_sync_exit(cyapa);
+       return ret;
+}
+
+static ssize_t cyapa_show_product_id(struct device *dev,
+                                    struct device_attribute *attr, char *buf)
+{
+       int ret;
+       struct cyapa *cyapa = dev_get_drvdata(dev);
+
+       if (!cyapa_state_sync_enter(cyapa))
+               return -EBUSY;
+
+       ret = scnprintf(buf, PAGE_SIZE, "%s\n", cyapa->product_id);
+       cyapa_state_sync_exit(cyapa);
+       return ret;
+}
+
+static ssize_t cyapa_update_fw_store(struct device *dev,
+                                    struct device_attribute *attr,
+                                    const char *buf, size_t count)
+{
+       struct cyapa *cyapa = dev_get_drvdata(dev);
+       const char *fw_name;
+       int ret;
+
+       /* Do not allow paths that step out of /lib/firmware  */
+       if (strstr(buf, "../") != NULL)
+               return -EINVAL;
+
+       fw_name = !strncmp(buf, "1", count) ||
+                 !strncmp(buf, "1\n", count) ? CYAPA_FW_NAME : buf;
+
+       if (!cyapa_state_sync_enter(cyapa))
+               return -EBUSY;
+
+       ret = cyapa_firmware(cyapa, fw_name);
+       if (ret)
+               dev_err(dev, "firmware update failed, %d\n", ret);
+       else
+               dev_dbg(dev, "firmware update succeeded\n");
+
+       cyapa_state_sync_exit(cyapa);
+
+       /* redetect trackpad device states. */
+       cyapa_detect_async(cyapa, 0);
+
+       return ret ? ret : count;
+}
+
+static ssize_t cyapa_calibrate_store(struct device *dev,
+                                    struct device_attribute *attr,
+                                    const char *buf, size_t count)
+{
+       struct cyapa *cyapa = dev_get_drvdata(dev);
+       int ret;
+
+       if (!cyapa_state_sync_enter(cyapa))
+               return -EBUSY;
+
+       if (!cyapa->ops->cyapa_calibrate_store) {
+               cyapa_state_sync_exit(cyapa);
+               dev_err(dev, "Calibrate operation not permitted.\n");
+               return -EPERM;
+       }
+       ret = cyapa->ops->cyapa_calibrate_store(dev, attr, buf, count);
+
+       cyapa_state_sync_exit(cyapa);
+       return ret < 0 ? ret : count;
+}
+
+static ssize_t cyapa_show_baseline(struct device *dev,
+                                  struct device_attribute *attr, char *buf)
+{
+       struct cyapa *cyapa = dev_get_drvdata(dev);
+       ssize_t ret;
+
+       if (!cyapa_state_sync_enter(cyapa))
+               return -EBUSY;
+
+       if (!cyapa->ops->cyapa_show_baseline) {
+               cyapa_state_sync_exit(cyapa);
+               dev_err(dev, "Calibrate operation not permitted.\n");
+               return -EPERM;
+       }
+       ret = cyapa->ops->cyapa_show_baseline(dev, attr, buf);
+
+       cyapa_state_sync_exit(cyapa);
+       return ret;
+}
+
+static DEVICE_ATTR(firmware_version, S_IRUGO, cyapa_show_fm_ver, NULL);
+static DEVICE_ATTR(product_id, S_IRUGO, cyapa_show_product_id, NULL);
+static DEVICE_ATTR(update_fw, S_IWUSR, NULL, cyapa_update_fw_store);
+static DEVICE_ATTR(baseline, S_IRUGO, cyapa_show_baseline, NULL);
+static DEVICE_ATTR(calibrate, S_IWUSR, NULL, cyapa_calibrate_store);
+
+static struct attribute *cyapa_sysfs_entries[] = {
+       &dev_attr_firmware_version.attr,
+       &dev_attr_product_id.attr,
+       &dev_attr_update_fw.attr,
+       &dev_attr_baseline.attr,
+       &dev_attr_calibrate.attr,
+       NULL,
+};
+
+static const struct attribute_group cyapa_sysfs_group = {
+       .attrs = cyapa_sysfs_entries,
+};
+
 void cyapa_detect_async(void *data, async_cookie_t cookie)
 {
        struct cyapa *cyapa = (struct cyapa *)data;
@@ -740,6 +944,9 @@ static int cyapa_probe(struct i2c_client *client,
        }
        cyapa_disable_irq(cyapa);

+       if (sysfs_create_group(&client->dev.kobj, &cyapa_sysfs_group))
+               dev_warn(dev, "error creating sysfs entries.\n");
+
 #ifdef CONFIG_PM_SLEEP
        if (device_can_wakeup(dev) &&
            sysfs_merge_group(&client->dev.kobj, &cyapa_power_wakeup_group))
@@ -762,6 +969,7 @@ static int cyapa_remove(struct i2c_client *client)
        struct cyapa *cyapa = i2c_get_clientdata(client);

        pm_runtime_disable(&client->dev);
+       sysfs_remove_group(&client->dev.kobj, &cyapa_sysfs_group);

 #ifdef CONFIG_PM_SLEEP
        sysfs_unmerge_group(&client->dev.kobj, &cyapa_power_wakeup_group);
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index 91fb84a..3e72fca 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -160,6 +160,19 @@ struct cyapa;
 typedef bool (*cb_sort)(struct cyapa *, u8 *, int);

 struct cyapa_dev_ops {
+       int (*cyapa_check_fw)(struct cyapa *, const struct firmware *);
+       int (*cyapa_bl_enter)(struct cyapa *);
+       int (*cyapa_bl_activate)(struct cyapa *);
+       int (*cyapa_bl_initiate)(struct cyapa *, const struct firmware *);
+       int (*cyapa_update_fw)(struct cyapa *, const struct firmware *);
+       int (*cyapa_bl_verify_app_integrity)(struct cyapa *);
+       int (*cyapa_bl_deactivate)(struct cyapa *);
+
+       ssize_t (*cyapa_show_baseline)(struct device *,
+                       struct device_attribute *, char *);
+       ssize_t (*cyapa_calibrate_store)(struct device *,
+                       struct device_attribute *, const char *, size_t);
+
        size_t (*cyapa_get_private_size)(void);
        int (*cyapa_private_init)(struct cyapa *cyapa, void *private_mem);

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
