Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaFFHcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:32:23 -0400
Received: from relay-s04-hub002.domainlocalhost.com ([74.115.207.101]:27870
	"EHLO relay-S04-HUB002.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467AbaFFH2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:28:54 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F4406C8C3S04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Benson Leung <bleung@google.com>, Lily Rui <lily@cypress.com>,
        "Daniel Kurtz" <djkurtz@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: [PATCH v2 5/14] input: cyapa: add read firmware image and raw data
 interfaces in debugfs system
Thread-Topic: [PATCH v2 5/14] input: cyapa: add read firmware image and raw
 data interfaces in debugfs system
Thread-Index: Ac+BWOlnZdsTdFNRR5mxwICJn+qIrg==
Date: Fri, 6 Jun 2014 07:28:52 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4406C8C3@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F4406C8C3@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.146]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8C3S04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Add read_fw and raw_data debugfs interfaces for easier issues location
and collection when report by user.
TEST=3Dtest on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 3b80de6..b5dc9f9 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -39,6 +39,9 @@

 const char unique_str[] =3D "CYTRA";

+/* global root node of the cyapa debugfs directory. */
+static struct dentry *cyapa_debugfs_root;
+

 void cyapa_enable_irq(struct cyapa *cyapa)
 {
@@ -205,6 +208,9 @@ const struct cyapa_dev_ops cyapa_default_ops =3D {
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
+       struct cyapa *cyapa =3D inode->i_private;
+       int ret;
+
+       if (!cyapa)
+               return -ENODEV;
+
+       ret =3D mutex_lock_interruptible(&cyapa->debugfs_mutex);
+       if (ret)
+               return ret;
+
+       if (!kobject_get(&cyapa->client->dev.kobj)) {
+               ret =3D -ENODEV;
+               goto out;
+       }
+
+       file->private_data =3D cyapa;
+
+       if (cyapa->read_fw_image) {
+               ret =3D 0;
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
+               ret =3D cyapa->ops->cyapa_read_fw(cyapa);
+       else
+               ret =3D -EPERM;
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
+       struct cyapa *cyapa =3D file->private_data;
+       int ret;
+
+       if (!cyapa)
+               return 0;
+
+       ret =3D mutex_lock_interruptible(&cyapa->debugfs_mutex);
+       if (ret)
+               return ret;
+       file->private_data =3D NULL;
+       kobject_put(&cyapa->client->dev.kobj);
+       mutex_unlock(&cyapa->debugfs_mutex);
+
+       return 0;
+}
+
+/* Return some bytes from the buffered firmware image, starting from *ppos=
 */
+static ssize_t cyapa_debugfs_read_fw(struct file *file, char __user *buffe=
r,
+                                    size_t count, loff_t *ppos)
+{
+       struct cyapa *cyapa =3D file->private_data;
+
+       if (!cyapa->read_fw_image)
+               return -EINVAL;
+
+       if (*ppos >=3D cyapa->read_fw_image_size)
+               return 0;
+
+       if (count + *ppos > cyapa->read_fw_image_size)
+               count =3D cyapa->read_fw_image_size - *ppos;
+
+       if (copy_to_user(buffer, &cyapa->read_fw_image[*ppos], count))
+               return -EFAULT;
+
+       *ppos +=3D count;
+       return count;
+}
+
+static const struct file_operations cyapa_read_fw_fops =3D {
+       .open =3D cyapa_debugfs_open,
+       .release =3D cyapa_debugfs_release,
+       .read =3D cyapa_debugfs_read_fw
+};
+
+static int cyapa_debugfs_raw_data_open(struct inode *inode, struct file *f=
ile)
+{
+       struct cyapa *cyapa =3D inode->i_private;
+       int ret;
+
+       if (!cyapa)
+               return -ENODEV;
+
+       ret =3D mutex_lock_interruptible(&cyapa->debugfs_mutex);
+       if (ret)
+               return ret;
+
+       if (!kobject_get(&cyapa->client->dev.kobj)) {
+               ret =3D -ENODEV;
+               goto out;
+       }
+
+       file->private_data =3D cyapa;
+
+       if (!cyapa_state_sync_enter(cyapa)) {
+               ret =3D -EBUSY;
+               goto out;
+       }
+       if (cyapa->ops->cyapa_read_raw_data)
+               ret =3D cyapa->ops->cyapa_read_raw_data(cyapa);
+       else
+               ret =3D -EPERM;
+       cyapa_state_sync_exit(cyapa);
+out:
+       mutex_unlock(&cyapa->debugfs_mutex);
+       return ret;
+}
+
+static int cyapa_debugfs_raw_data_release(struct inode *inode,
+                               struct file *file)
+{
+       struct cyapa *cyapa =3D file->private_data;
+       int ret;
+
+       if (!cyapa)
+               return 0;
+
+       ret =3D mutex_lock_interruptible(&cyapa->debugfs_mutex);
+       if (ret)
+               return ret;
+       file->private_data =3D NULL;
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
+       struct cyapa *cyapa =3D file->private_data;
+
+       if (!cyapa->tp_raw_data)
+               return -EINVAL;
+
+       if (*ppos >=3D cyapa->tp_raw_data_size)
+               return 0;
+
+       if (count + *ppos > cyapa->tp_raw_data_size)
+               count =3D cyapa->tp_raw_data_size - *ppos;
+
+       if (copy_to_user(buffer, &cyapa->tp_raw_data[*ppos], count))
+               return -EFAULT;
+
+       *ppos +=3D count;
+       return count;
+}
+
+static const struct file_operations cyapa_read_raw_data_fops =3D {
+       .open =3D cyapa_debugfs_raw_data_open,
+       .release =3D cyapa_debugfs_raw_data_release,
+       .read =3D cyapa_debugfs_read_raw_data
+};
+
+static int cyapa_debugfs_init(struct cyapa *cyapa)
+{
+       struct device *dev =3D &cyapa->client->dev;
+
+       if (!cyapa_debugfs_root)
+               return -ENODEV;
+
+       cyapa->dentry_dev =3D debugfs_create_dir(kobject_name(&dev->kobj),
+                                              cyapa_debugfs_root);
+
+       if (!cyapa->dentry_dev)
+               return -ENODEV;
+
+       mutex_init(&cyapa->debugfs_mutex);
+
+       debugfs_create_file(CYAPA_DEBUGFS_READ_FW, S_IRUSR, cyapa->dentry_d=
ev,
+                           cyapa, &cyapa_read_fw_fops);
+
+       debugfs_create_file(CYAPA_DEBUGFS_RAW_DATA, S_IRUSR, cyapa->dentry_=
dev,
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
+       cyapa_debugfs_root =3D debugfs_create_dir("cyapa", NULL);
+       if (cyapa_debugfs_root =3D=3D ERR_PTR(-ENODEV))
+               cyapa_debugfs_root =3D NULL;
+       if (cyapa_debugfs_init(cyapa))
+               dev_warn(dev, "error creating debugfs entries.\n");
+
 #ifdef CONFIG_PM_SLEEP
        if (device_can_wakeup(dev) &&
            sysfs_merge_group(&client->dev.kobj, &cyapa_power_wakeup_group)=
)
@@ -978,8 +1190,19 @@ static int cyapa_remove(struct i2c_client *client)
 #ifdef CONFIG_PM_RUNTIME
        sysfs_unmerge_group(&client->dev.kobj, &cyapa_power_runtime_group);
 #endif
+
+       kfree(cyapa->read_fw_image);
+       cyapa->read_fw_image =3D NULL;
+       cyapa->read_fw_image_size =3D 0;
+       kfree(cyapa->tp_raw_data);
+       cyapa->tp_raw_data =3D NULL;
+       cyapa->tp_raw_data_size =3D 0;
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

This message and any attachments may contain Cypress (or its subsidiaries) =
confidential information. If it has been received in error, please advise t=
he sender and immediately delete this message.

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8C3S04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
dT/AKk4Lkf6GVVMPtP+frV9b4NBgxlAggHMnvwD/zDCLoFjisE+z8lr5tQ+GZN9a/pWfBjbGSoRc
KslRXDdz1Dgv1VRobDBnsGgwc39Q8jiQ0cA4kKsAjCENcGj35nBKEMSRYasAjPHVcC/w/USgeaTx
hkDtkCCB1xAzgPhzdWJbsOWQMZAz4Tlg/4zxAPDj0siQotHJMCCAUOD71ZCNAC4NAO2AdxGNYDOA
/xHgQwDwQQ2AYaHRwMcBGuM9XmBwziTRsIvQzRF0aP+5o0iAIJHFQUow5nDIgSTw/myrAEiAARCM
kc2wxIgNpgx9fRQA0VAfAEIAAQAAABQAAABEAHUAZABsAGUAeQAgAEQAdQAAAB8AZQABAAAAIgAA
AGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8AZAABAAAACgAAAFMATQBUAFAA
AAAAAAIBQQABAAAAWAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEQAdQBkAGwAZQB5ACAARAB1
AAAAUwBNAFQAUAAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAfAAJdAQAAACIA
AABkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAAAAfAOVfAQAAACoAAABzAGkAcAA6
AGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8AGgwBAAAAFAAAAEQAdQBkAGwA
ZQB5ACAARAB1AAAAHwAfDAEAAAAiAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAA
AAAAHwAeDAEAAAAKAAAAUwBNAFQAUAAAAAAAAgEZDAEAAABYAAAAAAAAAIErH6S+oxAZnW4A3QEP
VAIAAACARAB1AGQAbABlAHkAIABEAHUAAABTAE0AVABQAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBz
AHMALgBjAG8AbQAAAB8AAV0BAAAAIgAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0A
AAAAAB8A+D8BAAAAFAAAAEQAdQBkAGwAZQB5ACAARAB1AAAAHwAjQAEAAAAiAAAAZAB1AGQAbABA
AGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAAAAHwAiQAEAAAAKAAAAUwBNAFQAUAAAAAAAAgH5PwEA
AABYAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACARAB1AGQAbABlAHkAIABEAHUAAABTAE0AVABQ
AAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAB8ACV0BAAAAIgAAAGQAdQBkAGwA
QABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8AMUABAAAAAgAAAAAAAAALAEA6AQAAAB8AMEAB
AAAAAgAAAAAAAAAfABoAAQAAABIAAABJAFAATQAuAE4AbwB0AGUAAAAAAAMA8T8ECAAACwBAOgEA
AAADAP0/qAMAAAIBCzABAAAAEAAAAAXjuiGHOsdDs/y79iPvHT4DABcAAQAAAEAAOQAA0hz3WIHP
AUAACDBtjVf3WIHPAQsAKQAAAAAACwAjAAAAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAeAAAA
YQBjAGMAZQBwAHQAbABhAG4AZwB1AGEAZwBlAAAAAAABAAAAGgAAAHoAaAAtAEMATgAsACAAZQBu
AC0AVQBTAAAAAAALAACACCAGAAAAAADAAAAAAAAARgAAAAAGhQAAAAAAAB8ANwABAAAAwAAAAFsA
UABBAFQAQwBIACAAdgAyACAANQAvADEANABdACAAaQBuAHAAdQB0ADoAIABjAHkAYQBwAGEAOgAg
AGEAZABkACAAcgBlAGEAZAAgAGYAaQByAG0AdwBhAHIAZQAgAGkAbQBhAGcAZQAgAGEAbgBkACAA
cgBhAHcAIABkAGEAdABhACAAaQBuAHQAZQByAGYAYQBjAGUAcwAgAGkAbgAgAGQAZQBiAHUAZwBm
AHMAIABzAHkAcwB0AGUAbQAAAB8APQABAAAAAgAAAAAAAAADADYAAAAAAAIBcQABAAAAFgAAAAHP
gVjpZ2XbE3RTUUeZscCAiZ/qiK4AAB8AcAABAAAAwAAAAFsAUABBAFQAQwBIACAAdgAyACAANQAv
ADEANABdACAAaQBuAHAAdQB0ADoAIABjAHkAYQBwAGEAOgAgAGEAZABkACAAcgBlAGEAZAAgAGYA
aQByAG0AdwBhAHIAZQAgAGkAbQBhAGcAZQAgAGEAbgBkACAAcgBhAHcAIABkAGEAdABhACAAaQBu
AHQAZQByAGYAYQBjAGUAcwAgAGkAbgAgAGQAZQBiAHUAZwBmAHMAIABzAHkAcwB0AGUAbQAAAB8A
NRABAAAAhAAAADwANwA3AEIAQwA3ADIANQBDADkAMAA2ADIANwA2ADQARgA4ADcANABEADcAOQBG
ADUAMQBFADEARgAxAEEAOABGADQANAAwADYAQwA4AEMAMwBAAFMAMAA0AC0ATQBCAFgAMAAxAC0A
MAAxAC4AcwAwADQALgBsAG8AYwBhAGwAPgAAAAMA3j+fTgAACwAAgAggBgAAAAAAwAAAAAAAAEYA
AAAAA4UAAAAAAAADAACACCAGAAAAAADAAAAAAAAARgAAAAABhQAAAAAAAAMAAIADIAYAAAAAAMAA
AAAAAABGAAAAAAGBAAAAAAAAAwCAEP////8FAACAAyAGAAAAAADAAAAAAAAARgAAAAACgQAAAAAA
AAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAAAAAcgQAAAAAAAEAABzBJeL31WIHPAQsAAgABAAAA
AwAmAAAAAAACARAwAQAAAEYAAAAAAAAAsR+hOTAgUUadtKVw3tCf1AcAd7xyXJBidk+HTXn1Hh8a
jwAAAJk8GwAAuqc+7svX90Cjdu81/GFZiQAYg/zDSgAAAAAfAPo/AQAAABQAAABEAHUAZABsAGUA
eQAgAEQAdQAAAAMACVkBAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAEIUAAAAAAAAfAACAH6Tr
M6h6LkK+e3nhqY5UswEAAAA4AAAAQwBvAG4AdgBlAHIAcwBhAHQAaQBvAG4ASQBuAGQAZQB4AFQA
cgBhAGMAawBpAG4AZwBFAHgAAAABAAAAugAAAEkASQA9ADAAMQBDAEYAOAAxADUAOABFADkANgA3
ADYANQBEAEIAMQAzADcANAA1ADMANQAxADQANwA5ADkAQgAxAEMAMAA4ADAAOAA5ADkARgBFAEEA
OAA4AEEARQA7AFYAZQByAHMAaQBvAG4APQBWAGUAcgBzAGkAbwBuACAAMQA0AC4AMwAgACgAQgB1
AGkAbABkACAAMQA3ADQALgAwACkALAAgAFMAdABhAGcAZQA9AEgANAAAAAAAAwAAgAMgBgAAAAAA
wAAAAAAAAEYAAAAAE4EAAAEAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAAjgQAA////fwMAAIAD
IAYAAAAAAMAAAAAAAABGAAAAABCBAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAEYEAAAAA
AAALAACAAyAGAAAAAADAAAAAAAAARgAAAAAkgQAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAA
ACyBAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAKYEAAAAAAAADAACAAyAGAAAAAADAAAAA
AAAARgAAAAAqgQAAAAAAAB8AAIADIAYAAAAAAMAAAAAAAABGAAAAACeBAAABAAAAAgAAAAAAAAAD
AACAAyAGAAAAAADAAAAAAAAARgAAAAASgQAAAQAAAB8AAIADIAYAAAAAAMAAAAAAAABGAAAAACGB
AAABAAAAAgAAAAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAAAAADgQAAAAAAAAsAAIADIAYAAAAA
AMAAAAAAAABGAAAAACaBAAAAAAAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAADoUAAAAAAAADAACA
CCAGAAAAAADAAAAAAAAARgAAAAAYhQAAAAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAIKFAAAA
AAAAAwANNP0/AAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAgAAAAeAAtAG0AcwAtAGgAYQBzAC0A
YQB0AHQAYQBjAGgAAAABAAAAAgAAAAAAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAiAAAAeAAt
AG8AcgBpAGcAaQBuAGEAdABpAG4AZwAtAGkAcAAAAAAAAQAAAB4AAABbADEAMAAuADMAMAAuADEA
MgAuADEANAA2AF0AAAAAAJiz

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8C3S04MBX0101s04lo_--
