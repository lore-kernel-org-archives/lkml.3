Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaBGLnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:43:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41008 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbaBGLY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:24:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 42/88] dm: wait until embedded kobject is released before destroying a device
Date: Fri,  7 Feb 2014 11:22:39 +0000
Message-Id: <1391772205-22239-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit be35f486108227e10fe5d96fd42fb2b344c59983 upstream.

There may be other parts of the kernel holding a reference on the dm
kobject.  We must wait until all references are dropped before
deallocating the mapped_device structure.

The dm_kobject_release method signals that all references are dropped
via completion.  But dm_kobject_release doesn't free the kobject (which
is embedded in the mapped_device structure).

This is the sequence of operations:
* when destroying a DM device, call kobject_put from dm_sysfs_exit
* wait until all users stop using the kobject, when it happens the
  release method is called
* the release method signals the completion and should return without
  delay
* the dm device removal code that waits on the completion continues
* the dm device removal code drops the dm_mod reference the device had
* the dm device removal code frees the mapped_device structure that
  contains the kobject

Using kobject this way should avoid the module unload race that was
mentioned at the beginning of this thread:
https://lkml.org/lkml/2014/1/4/83

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-sysfs.c | 10 +++++++++-
 drivers/md/dm.c       | 11 +++++++++++
 drivers/md/dm.h       |  2 ++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
index 84d2b91..e0cc5d6 100644
--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -79,6 +79,11 @@ static const struct sysfs_ops dm_sysfs_ops = {
 	.show	= dm_attr_show,
 };
 
+static void dm_kobject_release(struct kobject *kobj)
+{
+	complete(dm_get_completion_from_kobject(kobj));
+}
+
 /*
  * dm kobject is embedded in mapped_device structure
  * no need to define release function here
@@ -86,6 +91,7 @@ static const struct sysfs_ops dm_sysfs_ops = {
 static struct kobj_type dm_ktype = {
 	.sysfs_ops	= &dm_sysfs_ops,
 	.default_attrs	= dm_attrs,
+	.release	= dm_kobject_release,
 };
 
 /*
@@ -104,5 +110,7 @@ int dm_sysfs_init(struct mapped_device *md)
  */
 void dm_sysfs_exit(struct mapped_device *md)
 {
-	kobject_put(dm_kobject(md));
+	struct kobject *kobj = dm_kobject(md);
+	kobject_put(kobj);
+	wait_for_completion(dm_get_completion_from_kobject(kobj));
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9a7290b..062f89a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -194,6 +194,9 @@ struct mapped_device {
 	/* sysfs handle */
 	struct kobject kobj;
 
+	/* wait until the kobject is released */
+	struct completion kobj_completion;
+
 	/* zero-length flush that will be cloned and submitted to targets */
 	struct bio flush_bio;
 };
@@ -1898,6 +1901,7 @@ static struct mapped_device *alloc_dev(int minor)
 	init_waitqueue_head(&md->wait);
 	INIT_WORK(&md->work, dm_wq_work);
 	init_waitqueue_head(&md->eventq);
+	init_completion(&md->kobj_completion);
 
 	md->disk->major = _major;
 	md->disk->first_minor = minor;
@@ -2712,6 +2716,13 @@ struct mapped_device *dm_get_from_kobject(struct kobject *kobj)
 	return md;
 }
 
+struct completion *dm_get_completion_from_kobject(struct kobject *kobj)
+{
+	struct mapped_device *md = container_of(kobj, struct mapped_device, kobj);
+
+	return &md->kobj_completion;
+}
+
 int dm_suspended_md(struct mapped_device *md)
 {
 	return test_bit(DMF_SUSPENDED, &md->flags);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index b7dacd5..1174e96 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -15,6 +15,7 @@
 #include <linux/list.h>
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
+#include <linux/completion.h>
 
 /*
  * Suspend feature flags
@@ -123,6 +124,7 @@ int dm_sysfs_init(struct mapped_device *md);
 void dm_sysfs_exit(struct mapped_device *md);
 struct kobject *dm_kobject(struct mapped_device *md);
 struct mapped_device *dm_get_from_kobject(struct kobject *kobj);
+struct completion *dm_get_completion_from_kobject(struct kobject *kobj);
 
 /*
  * Targets for linear and striped mappings
-- 
1.8.3.2

