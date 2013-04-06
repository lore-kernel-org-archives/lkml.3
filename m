Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab3DFQ4H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 12:56:07 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:36401 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab3DFQ4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 12:56:04 -0400
Date: Sat, 6 Apr 2013 09:56:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay@vrfy.org>
Subject: [PATCH] driver core: add uid and gid to devtmpfs
Message-ID: <20130406165600.GA29660@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay@vrfy.org>

Some drivers want to tell userspace what uid and gid should be used for
their device nodes, so allow that information to percolate through the
driver core to userspace in order to make this happen.  This means that
some systems (i.e.  Android and friends) will not need to even run a
udev-like daemon for their device node manager and can just rely in
devtmpfs fully, reducing their footprint even more.

Signed-off-by: Kay Sievers <kay@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/genhd.c           |    3 ++-
 drivers/base/core.c     |   17 +++++++++++++----
 drivers/base/devtmpfs.c |   27 +++++++++++++++++----------
 drivers/usb/core/usb.c  |    3 ++-
 include/linux/device.h  |    7 +++++--
 5 files changed, 39 insertions(+), 18 deletions(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1111,7 +1111,8 @@ struct class block_class = {
 	.name		= "block",
 };
 
-static char *block_devnode(struct device *dev, umode_t *mode)
+static char *block_devnode(struct device *dev, umode_t *mode,
+			   uid_t *uid, gid_t *gid)
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -283,15 +283,21 @@ static int dev_uevent(struct kset *kset,
 		const char *tmp;
 		const char *name;
 		umode_t mode = 0;
+		uid_t uid = 0;
+		gid_t gid = 0;
 
 		add_uevent_var(env, "MAJOR=%u", MAJOR(dev->devt));
 		add_uevent_var(env, "MINOR=%u", MINOR(dev->devt));
-		name = device_get_devnode(dev, &mode, &tmp);
+		name = device_get_devnode(dev, &mode, &uid, &gid, &tmp);
 		if (name) {
 			add_uevent_var(env, "DEVNAME=%s", name);
-			kfree(tmp);
 			if (mode)
 				add_uevent_var(env, "DEVMODE=%#o", mode & 0777);
+			if (uid)
+				add_uevent_var(env, "DEVUID=%u", uid);
+			if (gid)
+				add_uevent_var(env, "DEVGID=%u", gid);
+			kfree(tmp);
 		}
 	}
 
@@ -1274,6 +1280,8 @@ static struct device *next_device(struct
  * device_get_devnode - path of device node file
  * @dev: device
  * @mode: returned file access mode
+ * @uid: returned file owner
+ * @gid: returned file group
  * @tmp: possibly allocated string
  *
  * Return the relative path of a possible device node.
@@ -1282,7 +1290,8 @@ static struct device *next_device(struct
  * freed by the caller.
  */
 const char *device_get_devnode(struct device *dev,
-			       umode_t *mode, const char **tmp)
+			       umode_t *mode, uid_t *uid, gid_t *gid,
+			       const char **tmp)
 {
 	char *s;
 
@@ -1290,7 +1299,7 @@ const char *device_get_devnode(struct de
 
 	/* the device type may provide a specific name */
 	if (dev->type && dev->type->devnode)
-		*tmp = dev->type->devnode(dev, mode);
+		*tmp = dev->type->devnode(dev, mode, uid, gid);
 	if (*tmp)
 		return *tmp;
 
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -41,6 +41,8 @@ static struct req {
 	int err;
 	const char *name;
 	umode_t mode;	/* 0 => delete */
+	uid_t uid;
+	gid_t gid;
 	struct device *dev;
 } *requests;
 
@@ -85,7 +87,9 @@ int devtmpfs_create_node(struct device *
 		return 0;
 
 	req.mode = 0;
-	req.name = device_get_devnode(dev, &req.mode, &tmp);
+	req.uid = 0;
+	req.gid = 0;
+	req.name = device_get_devnode(dev, &req.mode, &req.uid, &req.gid, &tmp);
 	if (!req.name)
 		return -ENOMEM;
 
@@ -121,7 +125,7 @@ int devtmpfs_delete_node(struct device *
 	if (!thread)
 		return 0;
 
-	req.name = device_get_devnode(dev, NULL, &tmp);
+	req.name = device_get_devnode(dev, NULL, NULL, NULL, &tmp);
 	if (!req.name)
 		return -ENOMEM;
 
@@ -187,7 +191,8 @@ static int create_path(const char *nodep
 	return err;
 }
 
-static int handle_create(const char *nodename, umode_t mode, struct device *dev)
+static int handle_create(const char *nodename, umode_t mode, uid_t uid,
+			 gid_t gid, struct device *dev)
 {
 	struct dentry *dentry;
 	struct path path;
@@ -201,14 +206,14 @@ static int handle_create(const char *nod
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-	err = vfs_mknod(path.dentry->d_inode,
-			dentry, mode, dev->devt);
+	err = vfs_mknod(path.dentry->d_inode, dentry, mode, dev->devt);
 	if (!err) {
 		struct iattr newattrs;
 
-		/* fixup possibly umasked mode */
 		newattrs.ia_mode = mode;
-		newattrs.ia_valid = ATTR_MODE;
+		newattrs.ia_uid = uid;
+		newattrs.ia_gid = gid;
+		newattrs.ia_valid = ATTR_MODE|ATTR_UID|ATTR_GID;
 		mutex_lock(&dentry->d_inode->i_mutex);
 		notify_change(dentry, &newattrs);
 		mutex_unlock(&dentry->d_inode->i_mutex);
@@ -358,10 +363,11 @@ int devtmpfs_mount(const char *mntdir)
 
 static DECLARE_COMPLETION(setup_done);
 
-static int handle(const char *name, umode_t mode, struct device *dev)
+static int handle(const char *name, umode_t mode, uid_t uid, gid_t gid,
+		  struct device *dev)
 {
 	if (mode)
-		return handle_create(name, mode, dev);
+		return handle_create(name, mode, uid, gid, dev);
 	else
 		return handle_remove(name, dev);
 }
@@ -387,7 +393,8 @@ static int devtmpfsd(void *p)
 			spin_unlock(&req_lock);
 			while (req) {
 				struct req *next = req->next;
-				req->err = handle(req->name, req->mode, req->dev);
+				req->err = handle(req->name, req->mode,
+						  req->uid, req->gid, req->dev);
 				complete(&req->done);
 				req = next;
 			}
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -317,7 +317,8 @@ static const struct dev_pm_ops usb_devic
 #endif	/* CONFIG_PM */
 
 
-static char *usb_devnode(struct device *dev, umode_t *mode)
+static char *usb_devnode(struct device *dev,
+			 umode_t *mode, uid_t *uid, gid_t *gid)
 {
 	struct usb_device *usb_dev;
 
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -25,6 +25,7 @@
 #include <linux/pm.h>
 #include <linux/atomic.h>
 #include <linux/ratelimit.h>
+#include <linux/uidgid.h>
 #include <asm/device.h>
 
 struct device;
@@ -471,7 +472,8 @@ struct device_type {
 	const char *name;
 	const struct attribute_group **groups;
 	int (*uevent)(struct device *dev, struct kobj_uevent_env *env);
-	char *(*devnode)(struct device *dev, umode_t *mode);
+	char *(*devnode)(struct device *dev, umode_t *mode,
+			 uid_t *uid, gid_t *gid);
 	void (*release)(struct device *dev);
 
 	const struct dev_pm_ops *pm;
@@ -849,7 +851,8 @@ extern int device_rename(struct device *
 extern int device_move(struct device *dev, struct device *new_parent,
 		       enum dpm_order dpm_order);
 extern const char *device_get_devnode(struct device *dev,
-				      umode_t *mode, const char **tmp);
+				      umode_t *mode, uid_t *uid, gid_t *gid,
+				      const char **tmp);
 extern void *dev_get_drvdata(const struct device *dev);
 extern int dev_set_drvdata(struct device *dev, void *data);
 
