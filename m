Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935043Ab3DKQoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:44:13 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:56318 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934437Ab3DKQn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:43:58 -0400
Date: Thu, 11 Apr 2013 09:43:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH] driver core: add uid and gid to devtmpfs
Message-ID: <20130411164356.GA23838@kroah.com>
References: <20130406165600.GA29660@kroah.com>
 <87y5cpvhaz.fsf@xmission.com>
 <20130411155606.GA14042@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411155606.GA14042@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 08:56:06AM -0700, Greg KH wrote:
> Again, thanks for the review, I'll go enable namespaces in my test
> kernel and fix up the fallout.

Here's the fixup patch, Eric, does it look correct to you?

thanks,

greg k-h

diff --git a/block/genhd.c b/block/genhd.c
index dfcec43..20625ee 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1112,7 +1112,7 @@ struct class block_class = {
 };
 
 static char *block_devnode(struct device *dev, umode_t *mode,
-			   uid_t *uid, gid_t *gid)
+			   kuid_t *uid, kgid_t *gid)
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 8a428b5..f88d9e2 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -283,8 +283,8 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 		const char *tmp;
 		const char *name;
 		umode_t mode = 0;
-		uid_t uid = 0;
-		gid_t gid = 0;
+		kuid_t uid = GLOBAL_ROOT_UID;
+		kgid_t gid = GLOBAL_ROOT_GID;
 
 		add_uevent_var(env, "MAJOR=%u", MAJOR(dev->devt));
 		add_uevent_var(env, "MINOR=%u", MINOR(dev->devt));
@@ -293,10 +293,10 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 			add_uevent_var(env, "DEVNAME=%s", name);
 			if (mode)
 				add_uevent_var(env, "DEVMODE=%#o", mode & 0777);
-			if (uid)
-				add_uevent_var(env, "DEVUID=%u", uid);
-			if (gid)
-				add_uevent_var(env, "DEVGID=%u", gid);
+			if (!uid_eq(uid, GLOBAL_ROOT_UID))
+				add_uevent_var(env, "DEVUID=%u", from_kuid(&init_user_ns, uid));
+			if (!gid_eq(gid, GLOBAL_ROOT_GID))
+				add_uevent_var(env, "DEVGID=%u", from_kgid(&init_user_ns, gid));
 			kfree(tmp);
 		}
 	}
@@ -1297,7 +1297,7 @@ static struct device *next_device(struct klist_iter *i)
  * freed by the caller.
  */
 const char *device_get_devnode(struct device *dev,
-			       umode_t *mode, uid_t *uid, gid_t *gid,
+			       umode_t *mode, kuid_t *uid, kgid_t *gid,
 			       const char **tmp)
 {
 	char *s;
diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index abd4eee..7413d06 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -42,8 +42,8 @@ static struct req {
 	int err;
 	const char *name;
 	umode_t mode;	/* 0 => delete */
-	uid_t uid;
-	gid_t gid;
+	kuid_t uid;
+	kgid_t gid;
 	struct device *dev;
 } *requests;
 
@@ -88,8 +88,8 @@ int devtmpfs_create_node(struct device *dev)
 		return 0;
 
 	req.mode = 0;
-	req.uid = 0;
-	req.gid = 0;
+	req.uid = GLOBAL_ROOT_UID;
+	req.gid = GLOBAL_ROOT_GID;
 	req.name = device_get_devnode(dev, &req.mode, &req.uid, &req.gid, &tmp);
 	if (!req.name)
 		return -ENOMEM;
@@ -192,8 +192,8 @@ static int create_path(const char *nodepath)
 	return err;
 }
 
-static int handle_create(const char *nodename, umode_t mode, uid_t uid,
-			 gid_t gid, struct device *dev)
+static int handle_create(const char *nodename, umode_t mode, kuid_t uid,
+			 kgid_t gid, struct device *dev)
 {
 	struct dentry *dentry;
 	struct path path;
@@ -212,8 +212,8 @@ static int handle_create(const char *nodename, umode_t mode, uid_t uid,
 		struct iattr newattrs;
 
 		newattrs.ia_mode = mode;
-		newattrs.ia_uid = KUIDT_INIT(uid);
-		newattrs.ia_gid = KGIDT_INIT(gid);
+		newattrs.ia_uid = uid;
+		newattrs.ia_gid = gid;
 		newattrs.ia_valid = ATTR_MODE|ATTR_UID|ATTR_GID;
 		mutex_lock(&dentry->d_inode->i_mutex);
 		notify_change(dentry, &newattrs);
@@ -364,7 +364,7 @@ int devtmpfs_mount(const char *mntdir)
 
 static DECLARE_COMPLETION(setup_done);
 
-static int handle(const char *name, umode_t mode, uid_t uid, gid_t gid,
+static int handle(const char *name, umode_t mode, kuid_t uid, kgid_t gid,
 		  struct device *dev)
 {
 	if (mode)
diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 1700283..e092b41 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -318,7 +318,7 @@ static const struct dev_pm_ops usb_device_pm_ops = {
 
 
 static char *usb_devnode(struct device *dev,
-			 umode_t *mode, uid_t *uid, gid_t *gid)
+			 umode_t *mode, kuid_t *uid, kgid_t *gid)
 {
 	struct usb_device *usb_dev;
 
diff --git a/include/linux/device.h b/include/linux/device.h
index 851b85c..88615cc 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -467,7 +467,7 @@ struct device_type {
 	const struct attribute_group **groups;
 	int (*uevent)(struct device *dev, struct kobj_uevent_env *env);
 	char *(*devnode)(struct device *dev, umode_t *mode,
-			 uid_t *uid, gid_t *gid);
+			 kuid_t *uid, kgid_t *gid);
 	void (*release)(struct device *dev);
 
 	const struct dev_pm_ops *pm;
@@ -845,7 +845,7 @@ extern int device_rename(struct device *dev, const char *new_name);
 extern int device_move(struct device *dev, struct device *new_parent,
 		       enum dpm_order dpm_order);
 extern const char *device_get_devnode(struct device *dev,
-				      umode_t *mode, uid_t *uid, gid_t *gid,
+				      umode_t *mode, kuid_t *uid, kgid_t *gid,
 				      const char **tmp);
 extern void *dev_get_drvdata(const struct device *dev);
 extern int dev_set_drvdata(struct device *dev, void *data);
