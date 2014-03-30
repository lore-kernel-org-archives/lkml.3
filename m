Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbaCaAHx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:07:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754328AbaC3Xmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:42:43 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mike Snitzer" <snitzer@redhat.com>,
        "Mikulas Patocka" <mpatocka@redhat.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.578704762@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 039/200] dm sysfs: fix a module unload race
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 2995fa78e423d7193f3b57835f6c1c75006a0315 upstream.

This reverts commit be35f48610 ("dm: wait until embedded kobject is
released before destroying a device") and provides an improved fix.

The kobject release code that calls the completion must be placed in a
non-module file, otherwise there is a module unload race (if the process
calling dm_kobject_release is preempted and the DM module unloaded after
the completion is triggered, but before dm_kobject_release returns).

To fix this race, this patch moves the completion code to dm-builtin.c
which is always compiled directly into the kernel if BLK_DEV_DM is
selected.

The patch introduces a new dm_kobject_holder structure, its purpose is
to keep the completion and kobject in one place, so that it can be
accessed from non-module code without the need to export the layout of
struct mapped_device to that code.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[bwh: Backported to 3.2:
 - Adjust context
 - Remove paranoid check of container_of() result in dm_get_from_kobject(),
   which would now be incorrect
 - Include <linux/export.h> in dm-builtin.c, included indirectly upstream]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -185,8 +185,12 @@ config MD_FAULTY
 
 	  In unsure, say N.
 
+config BLK_DEV_DM_BUILTIN
+	boolean
+
 config BLK_DEV_DM
 	tristate "Device mapper support"
+	select BLK_DEV_DM_BUILTIN
 	---help---
 	  Device-mapper is a low level volume manager.  It works by allowing
 	  people to specify mappings for ranges of logical sectors.  Various
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_MD_MULTIPATH)	+= multipath.
 obj-$(CONFIG_MD_FAULTY)		+= faulty.o
 obj-$(CONFIG_BLK_DEV_MD)	+= md-mod.o
 obj-$(CONFIG_BLK_DEV_DM)	+= dm-mod.o
+obj-$(CONFIG_BLK_DEV_DM_BUILTIN) += dm-builtin.o
 obj-$(CONFIG_DM_BUFIO)		+= dm-bufio.o
 obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
 obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
--- /dev/null
+++ b/drivers/md/dm-builtin.c
@@ -0,0 +1,49 @@
+#include <linux/export.h>
+#include "dm.h"
+
+/*
+ * The kobject release method must not be placed in the module itself,
+ * otherwise we are subject to module unload races.
+ *
+ * The release method is called when the last reference to the kobject is
+ * dropped. It may be called by any other kernel code that drops the last
+ * reference.
+ *
+ * The release method suffers from module unload race. We may prevent the
+ * module from being unloaded at the start of the release method (using
+ * increased module reference count or synchronizing against the release
+ * method), however there is no way to prevent the module from being
+ * unloaded at the end of the release method.
+ *
+ * If this code were placed in the dm module, the following race may
+ * happen:
+ *  1. Some other process takes a reference to dm kobject
+ *  2. The user issues ioctl function to unload the dm device
+ *  3. dm_sysfs_exit calls kobject_put, however the object is not released
+ *     because of the other reference taken at step 1
+ *  4. dm_sysfs_exit waits on the completion
+ *  5. The other process that took the reference in step 1 drops it,
+ *     dm_kobject_release is called from this process
+ *  6. dm_kobject_release calls complete()
+ *  7. a reschedule happens before dm_kobject_release returns
+ *  8. dm_sysfs_exit continues, the dm device is unloaded, module reference
+ *     count is decremented
+ *  9. The user unloads the dm module
+ * 10. The other process that was rescheduled in step 7 continues to run,
+ *     it is now executing code in unloaded module, so it crashes
+ *
+ * Note that if the process that takes the foreign reference to dm kobject
+ * has a low priority and the system is sufficiently loaded with
+ * higher-priority processes that prevent the low-priority process from
+ * being scheduled long enough, this bug may really happen.
+ *
+ * In order to fix this module unload race, we place the release method
+ * into a helper code that is compiled directly into the kernel.
+ */
+
+void dm_kobject_release(struct kobject *kobj)
+{
+	complete(dm_get_completion_from_kobject(kobj));
+}
+
+EXPORT_SYMBOL(dm_kobject_release);
--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -79,11 +79,6 @@ static const struct sysfs_ops dm_sysfs_o
 	.show	= dm_attr_show,
 };
 
-static void dm_kobject_release(struct kobject *kobj)
-{
-	complete(dm_get_completion_from_kobject(kobj));
-}
-
 /*
  * dm kobject is embedded in mapped_device structure
  * no need to define release function here
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -192,11 +192,8 @@ struct mapped_device {
 	/* forced geometry settings */
 	struct hd_geometry geometry;
 
-	/* sysfs handle */
-	struct kobject kobj;
-
-	/* wait until the kobject is released */
-	struct completion kobj_completion;
+	/* kobject and completion */
+	struct dm_kobject_holder kobj_holder;
 
 	/* zero-length flush that will be cloned and submitted to targets */
 	struct bio flush_bio;
@@ -1894,7 +1891,7 @@ static struct mapped_device *alloc_dev(i
 	init_waitqueue_head(&md->wait);
 	INIT_WORK(&md->work, dm_wq_work);
 	init_waitqueue_head(&md->eventq);
-	init_completion(&md->kobj_completion);
+	init_completion(&md->kobj_holder.completion);
 
 	md->disk->major = _major;
 	md->disk->first_minor = minor;
@@ -2686,7 +2683,7 @@ struct gendisk *dm_disk(struct mapped_de
 
 struct kobject *dm_kobject(struct mapped_device *md)
 {
-	return &md->kobj;
+	return &md->kobj_holder.kobj;
 }
 
 /*
@@ -2697,9 +2694,7 @@ struct mapped_device *dm_get_from_kobjec
 {
 	struct mapped_device *md;
 
-	md = container_of(kobj, struct mapped_device, kobj);
-	if (&md->kobj != kobj)
-		return NULL;
+	md = container_of(kobj, struct mapped_device, kobj_holder.kobj);
 
 	if (test_bit(DMF_FREEING, &md->flags) ||
 	    dm_deleting_md(md))
@@ -2709,13 +2704,6 @@ struct mapped_device *dm_get_from_kobjec
 	return md;
 }
 
-struct completion *dm_get_completion_from_kobject(struct kobject *kobj)
-{
-	struct mapped_device *md = container_of(kobj, struct mapped_device, kobj);
-
-	return &md->kobj_completion;
-}
-
 int dm_suspended_md(struct mapped_device *md)
 {
 	return test_bit(DMF_SUSPENDED, &md->flags);
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -16,6 +16,7 @@
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/completion.h>
+#include <linux/kobject.h>
 
 /*
  * Suspend feature flags
@@ -120,11 +121,25 @@ void dm_interface_exit(void);
 /*
  * sysfs interface
  */
+struct dm_kobject_holder {
+	struct kobject kobj;
+	struct completion completion;
+};
+
+static inline struct completion *dm_get_completion_from_kobject(struct kobject *kobj)
+{
+	return &container_of(kobj, struct dm_kobject_holder, kobj)->completion;
+}
+
 int dm_sysfs_init(struct mapped_device *md);
 void dm_sysfs_exit(struct mapped_device *md);
 struct kobject *dm_kobject(struct mapped_device *md);
 struct mapped_device *dm_get_from_kobject(struct kobject *kobj);
-struct completion *dm_get_completion_from_kobject(struct kobject *kobj);
+
+/*
+ * The kobject helper
+ */
+void dm_kobject_release(struct kobject *kobj);
 
 /*
  * Targets for linear and striped mappings

