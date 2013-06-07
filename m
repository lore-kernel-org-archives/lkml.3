Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838Ab3FGXxC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:53:02 -0400
Received: from smtp.outflux.net ([198.145.64.163]:56172 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757639Ab3FGXwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:52:46 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Karsten Keil <isdn@linux-pingi.de>, Kees Cook <keescook@chromium.org>
Subject: [PATCH 3/6] device: avoid format string in dev_set_name
Date: Fri,  7 Jun 2013 16:50:52 -0700
Message-Id: <1370649055-12830-4-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370649055-12830-1-git-send-email-keescook@chromium.org>
References: <1370649055-12830-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling dev_set_name with a single paramter causes it to be handled as
a format string. Many callers are passing potentially dynamic string
content, so use "%s" in those cases to avoid any potential accidents,
including wrappers like device_create*() and bdi_register().

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/base/attribute_container.c       |    2 +-
 drivers/devfreq/devfreq.c                |    2 +-
 drivers/extcon/extcon-class.c            |    2 +-
 drivers/hsi/hsi.c                        |    2 +-
 drivers/ide/ide-cd.c                     |    2 +-
 drivers/ide/ide-gd.c                     |    2 +-
 drivers/ide/ide-probe.c                  |    4 ++--
 drivers/ide/ide-tape.c                   |    2 +-
 drivers/infiniband/core/sysfs.c          |    2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c |    2 +-
 drivers/isdn/mISDN/dsp_pipeline.c        |    2 +-
 drivers/mtd/mtdcore.c                    |    2 +-
 drivers/platform/x86/wmi.c               |    2 +-
 drivers/scsi/sd.c                        |    2 +-
 drivers/staging/android/timed_output.c   |    2 +-
 drivers/staging/dgrp/dgrp_sysfs.c        |    2 +-
 drivers/uwb/lc-dev.c                     |    2 +-
 drivers/video/backlight/backlight.c      |    2 +-
 drivers/video/backlight/lcd.c            |    2 +-
 drivers/video/output.c                   |    2 +-
 drivers/xen/xenbus/xenbus_probe.c        |    2 +-
 mm/backing-dev.c                         |    5 ++---
 sound/sound_core.c                       |    2 +-
 23 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index d78b204..ecc1929 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -167,7 +167,7 @@ attribute_container_add_device(struct device *dev,
 		ic->classdev.parent = get_device(dev);
 		ic->classdev.class = cont->class;
 		cont->class->dev_release = attribute_container_release;
-		dev_set_name(&ic->classdev, dev_name(dev));
+		dev_set_name(&ic->classdev, "%s", dev_name(dev));
 		if (fn)
 			fn(cont, dev, &ic->classdev);
 		else
diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 3b36797..af8372f 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -477,7 +477,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
 						GFP_KERNEL);
 	devfreq->last_stat_updated = jiffies;
 
-	dev_set_name(&devfreq->dev, dev_name(dev));
+	dev_set_name(&devfreq->dev, "%s", dev_name(dev));
 	err = device_register(&devfreq->dev);
 	if (err) {
 		put_device(&devfreq->dev);
diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 60adc04..8b77e60 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -620,7 +620,7 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
 	edev->dev->class = extcon_class;
 	edev->dev->release = extcon_dev_release;
 
-	dev_set_name(edev->dev, edev->name ? edev->name : dev_name(dev));
+	dev_set_name(edev->dev, "%s", edev->name ? edev->name : dev_name(dev));
 
 	if (edev->max_supported) {
 		char buf[10];
diff --git a/drivers/hsi/hsi.c b/drivers/hsi/hsi.c
index 833dd1a..66d4458 100644
--- a/drivers/hsi/hsi.c
+++ b/drivers/hsi/hsi.c
@@ -75,7 +75,7 @@ static void hsi_new_client(struct hsi_port *port, struct hsi_board_info *info)
 	cl->device.bus = &hsi_bus_type;
 	cl->device.parent = &port->device;
 	cl->device.release = hsi_client_release;
-	dev_set_name(&cl->device, info->name);
+	dev_set_name(&cl->device, "%s", info->name);
 	cl->device.platform_data = info->platform_data;
 	if (info->archdata)
 		cl->device.archdata = *info->archdata;
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 2ff6204..0b510ba 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1756,7 +1756,7 @@ static int ide_cd_probe(ide_drive_t *drive)
 
 	info->dev.parent = &drive->gendev;
 	info->dev.release = ide_cd_release;
-	dev_set_name(&info->dev, dev_name(&drive->gendev));
+	dev_set_name(&info->dev, "%s", dev_name(&drive->gendev));
 
 	if (device_register(&info->dev))
 		goto out_free_disk;
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index de86631..838996a 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -392,7 +392,7 @@ static int ide_gd_probe(ide_drive_t *drive)
 
 	idkp->dev.parent = &drive->gendev;
 	idkp->dev.release = ide_disk_release;
-	dev_set_name(&idkp->dev, dev_name(&drive->gendev));
+	dev_set_name(&idkp->dev, "%s", dev_name(&drive->gendev));
 
 	if (device_register(&idkp->dev))
 		goto out_free_disk;
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 068cef0..2a744a9 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -545,7 +545,7 @@ static int ide_register_port(ide_hwif_t *hwif)
 	int ret;
 
 	/* register with global device tree */
-	dev_set_name(&hwif->gendev, hwif->name);
+	dev_set_name(&hwif->gendev, "%s", hwif->name);
 	dev_set_drvdata(&hwif->gendev, hwif);
 	if (hwif->gendev.parent == NULL)
 		hwif->gendev.parent = hwif->dev;
@@ -559,7 +559,7 @@ static int ide_register_port(ide_hwif_t *hwif)
 	}
 
 	hwif->portdev = device_create(ide_port_class, &hwif->gendev,
-				      MKDEV(0, 0), hwif, hwif->name);
+				      MKDEV(0, 0), hwif, "%s", hwif->name);
 	if (IS_ERR(hwif->portdev)) {
 		ret = PTR_ERR(hwif->portdev);
 		device_unregister(&hwif->gendev);
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index c6c574b..1793aea 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1985,7 +1985,7 @@ static int ide_tape_probe(ide_drive_t *drive)
 
 	tape->dev.parent = &drive->gendev;
 	tape->dev.release = ide_tape_release;
-	dev_set_name(&tape->dev, dev_name(&drive->gendev));
+	dev_set_name(&tape->dev, "%s", dev_name(&drive->gendev));
 
 	if (device_register(&tape->dev))
 		goto out_free_disk;
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 246fdc1..99904f7 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -813,7 +813,7 @@ int ib_device_register_sysfs(struct ib_device *device,
 
 	class_dev->class      = &ib_class;
 	class_dev->parent     = device->dma_device;
-	dev_set_name(class_dev, device->name);
+	dev_set_name(class_dev, "%s", device->name);
 	dev_set_drvdata(class_dev, device);
 
 	INIT_LIST_HEAD(&device->port_list);
diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index b56c942..9dd0bc8 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -2208,7 +2208,7 @@ int qib_cdev_init(int minor, const char *name,
 		goto err_cdev;
 	}
 
-	device = device_create(qib_class, NULL, dev, NULL, name);
+	device = device_create(qib_class, NULL, dev, NULL, "%s", name);
 	if (!IS_ERR(device))
 		goto done;
 	ret = PTR_ERR(device);
diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
index 88305c9..8b1a66c 100644
--- a/drivers/isdn/mISDN/dsp_pipeline.c
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -102,7 +102,7 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
 	entry->dev.class = elements_class;
 	entry->dev.release = mISDN_dsp_dev_release;
 	dev_set_drvdata(&entry->dev, elem);
-	dev_set_name(&entry->dev, elem->name);
+	dev_set_name(&entry->dev, "%s", elem->name);
 	ret = device_register(&entry->dev);
 	if (ret) {
 		printk(KERN_ERR "%s: failed to register %s\n",
diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index c400c57..048c823 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -1151,7 +1151,7 @@ static int __init mtd_bdi_init(struct backing_dev_info *bdi, const char *name)
 
 	ret = bdi_init(bdi);
 	if (!ret)
-		ret = bdi_register(bdi, NULL, name);
+		ret = bdi_register(bdi, NULL, "%s", name);
 
 	if (ret)
 		bdi_destroy(bdi);
diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index e4ac38a..b13344c 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -743,7 +743,7 @@ static int wmi_create_device(const struct guid_block *gblock,
 	wblock->dev.class = &wmi_class;
 
 	wmi_gtoa(gblock->guid, guid_string);
-	dev_set_name(&wblock->dev, guid_string);
+	dev_set_name(&wblock->dev, "%s", guid_string);
 
 	dev_set_drvdata(&wblock->dev, wblock);
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c1c5552..8fa3d0b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2931,7 +2931,7 @@ static int sd_probe(struct device *dev)
 	device_initialize(&sdkp->dev);
 	sdkp->dev.parent = dev;
 	sdkp->dev.class = &sd_disk_class;
-	dev_set_name(&sdkp->dev, dev_name(dev));
+	dev_set_name(&sdkp->dev, "%s", dev_name(dev));
 
 	if (device_add(&sdkp->dev))
 		goto out_free_index;
diff --git a/drivers/staging/android/timed_output.c b/drivers/staging/android/timed_output.c
index ec9e2ae..ee3a57f 100644
--- a/drivers/staging/android/timed_output.c
+++ b/drivers/staging/android/timed_output.c
@@ -78,7 +78,7 @@ int timed_output_dev_register(struct timed_output_dev *tdev)
 
 	tdev->index = atomic_inc_return(&device_count);
 	tdev->dev = device_create(timed_output_class, NULL,
-		MKDEV(0, tdev->index), NULL, tdev->name);
+		MKDEV(0, tdev->index), NULL, "%s", tdev->name);
 	if (IS_ERR(tdev->dev))
 		return PTR_ERR(tdev->dev);
 
diff --git a/drivers/staging/dgrp/dgrp_sysfs.c b/drivers/staging/dgrp/dgrp_sysfs.c
index 7d1b36d..8cee9c8 100644
--- a/drivers/staging/dgrp/dgrp_sysfs.c
+++ b/drivers/staging/dgrp/dgrp_sysfs.c
@@ -273,7 +273,7 @@ void dgrp_create_node_class_sysfs_files(struct nd_struct *nd)
 		sprintf(name, "node%ld", nd->nd_major);
 
 	nd->nd_class_dev = device_create(dgrp_class, dgrp_class_nodes_dev,
-		MKDEV(0, nd->nd_major), NULL, name);
+		MKDEV(0, nd->nd_major), NULL, "%s", name);
 
 	ret = sysfs_create_group(&nd->nd_class_dev->kobj,
 				 &dgrp_node_attribute_group);
diff --git a/drivers/uwb/lc-dev.c b/drivers/uwb/lc-dev.c
index 5241f1d..9209eaf 100644
--- a/drivers/uwb/lc-dev.c
+++ b/drivers/uwb/lc-dev.c
@@ -440,7 +440,7 @@ void uwbd_dev_onair(struct uwb_rc *rc, struct uwb_beca_e *bce)
 	uwb_dev_init(uwb_dev);		/* This sets refcnt to one, we own it */
 	uwb_dev->mac_addr = *bce->mac_addr;
 	uwb_dev->dev_addr = bce->dev_addr;
-	dev_set_name(&uwb_dev->dev, macbuf);
+	dev_set_name(&uwb_dev->dev, "%s", macbuf);
 	result = uwb_dev_add(uwb_dev, &rc->uwb_dev.dev, rc);
 	if (result < 0) {
 		dev_err(dev, "new device %s: cannot instantiate device\n",
diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index c74e7aa..e3c2790 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -304,7 +304,7 @@ struct backlight_device *backlight_device_register(const char *name,
 	new_bd->dev.class = backlight_class;
 	new_bd->dev.parent = parent;
 	new_bd->dev.release = bl_device_release;
-	dev_set_name(&new_bd->dev, name);
+	dev_set_name(&new_bd->dev, "%s", name);
 	dev_set_drvdata(&new_bd->dev, devdata);
 
 	/* Set default properties */
diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index 34fb6bd..3649fd9 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -219,7 +219,7 @@ struct lcd_device *lcd_device_register(const char *name, struct device *parent,
 	new_ld->dev.class = lcd_class;
 	new_ld->dev.parent = parent;
 	new_ld->dev.release = lcd_device_release;
-	dev_set_name(&new_ld->dev, name);
+	dev_set_name(&new_ld->dev, "%s", name);
 	dev_set_drvdata(&new_ld->dev, devdata);
 
 	rc = device_register(&new_ld->dev);
diff --git a/drivers/video/output.c b/drivers/video/output.c
index 0d6f2cd..6285b97 100644
--- a/drivers/video/output.c
+++ b/drivers/video/output.c
@@ -97,7 +97,7 @@ struct output_device *video_output_register(const char *name,
 	new_dev->props = op;
 	new_dev->dev.class = &video_output_class;
 	new_dev->dev.parent = dev;
-	dev_set_name(&new_dev->dev, name);
+	dev_set_name(&new_dev->dev, "%s", name);
 	dev_set_drvdata(&new_dev->dev, devdata);
 	ret_code = device_register(&new_dev->dev);
 	if (ret_code) {
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 56cfaaa..8c9db16 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -447,7 +447,7 @@ int xenbus_probe_node(struct xen_bus_type *bus,
 	if (err)
 		goto fail;
 
-	dev_set_name(&xendev->dev, devname);
+	dev_set_name(&xendev->dev, "%s", devname);
 
 	/* Register with generic device framework. */
 	err = device_register(&xendev->dev);
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 5025174..d014ee5 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -515,7 +515,6 @@ EXPORT_SYMBOL(bdi_destroy);
 int bdi_setup_and_register(struct backing_dev_info *bdi, char *name,
 			   unsigned int cap)
 {
-	char tmp[32];
 	int err;
 
 	bdi->name = name;
@@ -524,8 +523,8 @@ int bdi_setup_and_register(struct backing_dev_info *bdi, char *name,
 	if (err)
 		return err;
 
-	sprintf(tmp, "%.28s%s", name, "-%d");
-	err = bdi_register(bdi, NULL, tmp, atomic_long_inc_return(&bdi_seq));
+	err = bdi_register(bdi, NULL, "%.28s-%ld", name,
+			   atomic_long_inc_return(&bdi_seq));
 	if (err) {
 		bdi_destroy(bdi);
 		return err;
diff --git a/sound/sound_core.c b/sound/sound_core.c
index 359753f..45759f4 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -292,7 +292,7 @@ retry:
 	}
 
 	device_create(sound_class, dev, MKDEV(SOUND_MAJOR, s->unit_minor),
-		      NULL, s->name+6);
+		      NULL, "%s", s->name+6);
 	return s->unit_minor;
 
 fail:
-- 
1.7.9.5

