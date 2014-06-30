Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbaF3Gn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:43:56 -0400
Received: from relay-s04-hub004.domainlocalhost.com ([74.115.207.103]:23716
	"EHLO relay-S04-HUB004.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752510AbaF3Gnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:43:55 -0400
From: Dudley Du <dudl@cypress.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "patrikf@google.com" <patrikf@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Benson Leung <bleung@google.com>, Daniel Kurtz <djkurtz@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 5/14] input: cyapa: add read firmware image and raw data
 interfaces in debugfs system
Thread-Topic: [PATCH v2 5/14] input: cyapa: add read firmware image and raw
 data interfaces in debugfs system
Thread-Index: Ac+ULqbyvrkxAl2iTDmcTI+DiLlNpA==
Date: Mon, 30 Jun 2014 06:43:53 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4C902C7A@S04-MBX01-01.s04.local>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5U6i2c7009578

Add read_fw and raw_data debugfs interfaces for easier issues location
and collection when report by user.
TEST=test on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 3b80de6..b5dc9f9 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -39,6 +39,9 @@

 const char unique_str[] = "CYTRA";

+/* global root node of the cyapa debugfs directory. */
+static struct dentry *cyapa_debugfs_root;
+

 void cyapa_enable_irq(struct cyapa *cyapa)
 {
@@ -205,6 +208,9 @@ const struct cyapa_dev_ops cyapa_default_ops = {
        NULL,
        NULL,

+       NULL,
+       NULL,
+
        cyapa_default_irq_handler,
        NULL,
        NULL,
@@ -554,6 +560,205 @@ done:
 }

 /*
+ **************************************************************
+ * debugfs interface
+ **************************************************************
+*/
+static int cyapa_debugfs_open(struct inode *inode, struct file *file)
+{
+       struct cyapa *cyapa = inode->i_private;
+       int ret;
+
+       if (!cyapa)
+               return -ENODEV;
+
+       ret = mutex_lock_interruptible(&cyapa->debugfs_mutex);
+       if (ret)
+               return ret;
+
+       if (!kobject_get(&cyapa->client->dev.kobj)) {
+               ret = -ENODEV;
+               goto out;
+       }
+
+       file->private_data = cyapa;
+
+       if (cyapa->read_fw_image) {
+               ret = 0;
+               goto out;
+       }
+
+       if (!cyapa_state_sync_enter(cyapa))
+               return -EBUSY;
+       /*
+        * If firmware hasn't been read yet, read it all in one pass.
+        * Subsequent opens will reuse the data in this same buffer.
+        */
+       if (cyapa->ops->cyapa_read_fw)
+               ret = cyapa->ops->cyapa_read_fw(cyapa);
+       else
+               ret = -EPERM;
+       cyapa_state_sync_exit(cyapa);
+
+       /* redetect trackpad device states. */
+       cyapa_detect_async(cyapa, 0);
+
+out:
+       mutex_unlock(&cyapa->debugfs_mutex);
+       return ret;
+}
+
+static int cyapa_debugfs_release(struct inode *inode, struct file *file)
+{
+       struct cyapa *cyapa = file->private_data;
+       int ret;
+
+       if (!cyapa)
+               return 0;
+
+       ret = mutex_lock_interruptible(&cyapa->debugfs_mutex);
+       if (ret)
+               return ret;
+       file->private_data = NULL;
+       kobject_put(&cyapa->client->dev.kobj);
+       mutex_unlock(&cyapa->debugfs_mutex);
+
+       return 0;
+}
+
+/* Return some bytes from the buffered firmware image, starting from *ppos */
+static ssize_t cyapa_debugfs_read_fw(struct file *file, char __user *buffer,
+                                    size_t count, loff_t *ppos)
+{
+       struct cyapa *cyapa = file->private_data;
+
+       if (!cyapa->read_fw_image)
+               return -EINVAL;
+
+       if (*ppos >= cyapa->read_fw_image_size)
+               return 0;
+
+       if (count + *ppos > cyapa->read_fw_image_size)
+               count = cyapa->read_fw_image_size - *ppos;
+
+       if (copy_to_user(buffer, &cyapa->read_fw_image[*ppos], count))
+               return -EFAULT;
+
+       *ppos += count;
+       return count;
+}
+
+static const struct file_operations cyapa_read_fw_fops = {
+       .open = cyapa_debugfs_open,
+       .release = cyapa_debugfs_release,
+       .read = cyapa_debugfs_read_fw
+};
+
+static int cyapa_debugfs_raw_data_open(struct inode *inode, struct file *file)
+{
+       struct cyapa *cyapa = inode->i_private;
+       int ret;
+
+       if (!cyapa)
+               return -ENODEV;
+
+       ret = mutex_lock_interruptible(&cyapa->debugfs_mutex);
+       if (ret)
+               return ret;
+
+       if (!kobject_get(&cyapa->client->dev.kobj)) {
+               ret = -ENODEV;
+               goto out;
+       }
+
+       file->private_data = cyapa;
+
+       if (!cyapa_state_sync_enter(cyapa)) {
+               ret = -EBUSY;
+               goto out;
+       }
+       if (cyapa->ops->cyapa_read_raw_data)
+               ret = cyapa->ops->cyapa_read_raw_data(cyapa);
+       else
+               ret = -EPERM;
+       cyapa_state_sync_exit(cyapa);
+out:
+       mutex_unlock(&cyapa->debugfs_mutex);
+       return ret;
+}
+
+static int cyapa_debugfs_raw_data_release(struct inode *inode,
+                               struct file *file)
+{
+       struct cyapa *cyapa = file->private_data;
+       int ret;
+
+       if (!cyapa)
+               return 0;
+
+       ret = mutex_lock_interruptible(&cyapa->debugfs_mutex);
+       if (ret)
+               return ret;
+       file->private_data = NULL;
+       kobject_put(&cyapa->client->dev.kobj);
+       mutex_unlock(&cyapa->debugfs_mutex);
+
+       return 0;
+}
+
+/* Always return the sensors' latest raw data from trackpad device. */
+static ssize_t cyapa_debugfs_read_raw_data(struct file *file,
+                                    char __user *buffer,
+                                    size_t count, loff_t *ppos)
+{
+       struct cyapa *cyapa = file->private_data;
+
+       if (!cyapa->tp_raw_data)
+               return -EINVAL;
+
+       if (*ppos >= cyapa->tp_raw_data_size)
+               return 0;
+
+       if (count + *ppos > cyapa->tp_raw_data_size)
+               count = cyapa->tp_raw_data_size - *ppos;
+
+       if (copy_to_user(buffer, &cyapa->tp_raw_data[*ppos], count))
+               return -EFAULT;
+
+       *ppos += count;
+       return count;
+}
+
+static const struct file_operations cyapa_read_raw_data_fops = {
+       .open = cyapa_debugfs_raw_data_open,
+       .release = cyapa_debugfs_raw_data_release,
+       .read = cyapa_debugfs_read_raw_data
+};
+
+static int cyapa_debugfs_init(struct cyapa *cyapa)
+{
+       struct device *dev = &cyapa->client->dev;
+
+       if (!cyapa_debugfs_root)
+               return -ENODEV;
+
+       cyapa->dentry_dev = debugfs_create_dir(kobject_name(&dev->kobj),
+                                              cyapa_debugfs_root);
+
+       if (!cyapa->dentry_dev)
+               return -ENODEV;
+
+       mutex_init(&cyapa->debugfs_mutex);
+
+       debugfs_create_file(CYAPA_DEBUGFS_READ_FW, S_IRUSR, cyapa->dentry_dev,
+                           cyapa, &cyapa_read_fw_fops);
+
+       debugfs_create_file(CYAPA_DEBUGFS_RAW_DATA, S_IRUSR, cyapa->dentry_dev,
+                           cyapa, &cyapa_read_raw_data_fops);
+       return 0;
+}
+
+/*
  * Sysfs Interface.
  */

@@ -947,6 +1152,13 @@ static int cyapa_probe(struct i2c_client *client,
        if (sysfs_create_group(&client->dev.kobj, &cyapa_sysfs_group))
                dev_warn(dev, "error creating sysfs entries.\n");

+       /* Create a global debugfs root for all cyapa devices */
+       cyapa_debugfs_root = debugfs_create_dir("cyapa", NULL);
+       if (cyapa_debugfs_root == ERR_PTR(-ENODEV))
+               cyapa_debugfs_root = NULL;
+       if (cyapa_debugfs_init(cyapa))
+               dev_warn(dev, "error creating debugfs entries.\n");
+
 #ifdef CONFIG_PM_SLEEP
        if (device_can_wakeup(dev) &&
            sysfs_merge_group(&client->dev.kobj, &cyapa_power_wakeup_group))
@@ -978,8 +1190,19 @@ static int cyapa_remove(struct i2c_client *client)
 #ifdef CONFIG_PM_RUNTIME
        sysfs_unmerge_group(&client->dev.kobj, &cyapa_power_runtime_group);
 #endif
+
+       kfree(cyapa->read_fw_image);
+       cyapa->read_fw_image = NULL;
+       cyapa->read_fw_image_size = 0;
+       kfree(cyapa->tp_raw_data);
+       cyapa->tp_raw_data = NULL;
+       cyapa->tp_raw_data_size = 0;
        free_irq(cyapa->irq, cyapa);

+       debugfs_remove_recursive(cyapa->dentry_dev);
+       debugfs_remove_recursive(cyapa_debugfs_root);
+       mutex_destroy(&cyapa->debugfs_mutex);
+
        input_unregister_device(cyapa->input);
        if (cyapa->ops->cyapa_set_power_mode)
                cyapa->ops->cyapa_set_power_mode(cyapa, PWR_MODE_OFF, 0);
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index 3e72fca..319f19d 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -173,6 +173,9 @@ struct cyapa_dev_ops {
        ssize_t (*cyapa_calibrate_store)(struct device *,
                        struct device_attribute *, const char *, size_t);

+       int (*cyapa_read_fw)(struct cyapa *);
+       int (*cyapa_read_raw_data)(struct cyapa *);
+
        size_t (*cyapa_get_private_size)(void);
        int (*cyapa_private_init)(struct cyapa *cyapa, void *private_mem);

@@ -244,6 +247,17 @@ struct cyapa {
        bool irq_enabled;
        bool prev_irq_enabled;

+       /* per-instance debugfs root */
+       struct dentry *dentry_dev;
+
+       /* Buffer to store firmware read using debugfs */
+       struct mutex debugfs_mutex;
+       u8 *read_fw_image;
+       size_t read_fw_image_size;
+       /* Buffer to store sensors' raw data */
+       u8 *tp_raw_data;
+       size_t tp_raw_data_size;
+
        const struct cyapa_dev_ops *ops;
 };

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
