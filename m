Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaAWMjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 07:39:06 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:60668 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaAWMjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 07:39:04 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH v3 1/3] drm: add pseudo filesystem for shared inodes
Date: Thu, 23 Jan 2014 13:38:37 +0100
Message-Id: <1390480719-434-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our current DRM design uses a single address_space for all users of the
same DRM device. However, there is no way to create an anonymous
address_space without an underlying inode. Therefore, we wait for the
first ->open() callback on a registered char-dev and take-over the inode
of the char-dev. This worked well so far, but has several drawbacks:
 - We screw with FS internals and rely on some non-obvious invariants like
   inode->i_mapping being the same as inode->i_data for char-devs.
 - We don't have any address_space prior to the first ->open() from
   user-space. This leads to ugly fallback code and we cannot allocate
   global objects early.

As pointed out by Al-Viro, fs/anon_inode.c is *not* supposed to be used by
drivers for anonymous inode-allocation. Therefore, this patch follows the
proposed alternative solution and adds a pseudo filesystem mount-point to
DRM. We can then allocate private inodes including a private address_space
for each DRM device at initialization time.

Note that we could use:
  sysfs_get_inode(sysfs_mnt->mnt_sb, drm_device->dev->kobj.sd);
to get access to the underlying sysfs-inode of a "struct device" object.
However, most of this information is currently hidden and it's not clear
whether this address_space is suitable for driver access. Thus, unless
linux allows anonymous address_space objects or driver-core provides a
public inode per device, we're left with our own private internal mount
point.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
v3:
 - Move all stuff to drm_stub.c so we don't have to export it
 - Make drm.ko unloading work by switching to simple_pin_fs() instead of
   kern_mount().

Hey guys

So this is v3, this time with dynamic mount management. Downside is, if external
code takes a reference to our inodes, we *may* end up with multiple internal
vfsmounts during device hotplugging. However, this requires that there's a
timespan where *no* DRM device is registered.

But the actualy downside is just more memory-consumption, so this seems fine.
Comments welcome! Tested with i915 and nouveau.

Thanks
David

 drivers/gpu/drm/drm_stub.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index 98a33c580..f2903d7 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -31,8 +31,10 @@
  * DEALINGS IN THE SOFTWARE.
  */
 
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/mount.h>
 #include <linux/slab.h>
 #include <drm/drmP.h>
 #include <drm/drm_core.h>
@@ -416,6 +418,78 @@ void drm_unplug_dev(struct drm_device *dev)
 }
 EXPORT_SYMBOL(drm_unplug_dev);
 
+/*
+ * DRM internal mount
+ * We want to be able to allocate our own "struct address_space" to control
+ * memory-mappings in VRAM (or stolen RAM, ...). However, core MM does not allow
+ * stand-alone address_space objects, so we need an underlying inode. As there
+ * is no way to allocate an independent inode easily, we need a fake internal
+ * VFS mount-point.
+ *
+ * The drm_fs_inode_new() function allocates a new inode, drm_fs_inode_free()
+ * frees it again. You are allowed to use iget() and iput() to get references to
+ * the inode. But each drm_fs_inode_new() call must be paired with exactly one
+ * drm_fs_inode_free() call (which does not have to be the last iput()).
+ * We use drm_fs_inode_*() to manage our internal VFS mount-point and share it
+ * between multiple inode-users. You could, technically, call
+ * iget() + drm_fs_inode_free() directly after alloc and sometime later do an
+ * iput(), but this way you'd end up with a new vfsmount for each inode.
+ */
+
+static int drm_fs_cnt;
+static struct vfsmount *drm_fs_mnt;
+
+static const struct dentry_operations drm_fs_dops = {
+	.d_dname	= simple_dname,
+};
+
+static const struct super_operations drm_fs_sops = {
+	.statfs		= simple_statfs,
+};
+
+static struct dentry *drm_fs_mount(struct file_system_type *fs_type, int flags,
+				   const char *dev_name, void *data)
+{
+	return mount_pseudo(fs_type,
+			    "drm:",
+			    &drm_fs_sops,
+			    &drm_fs_dops,
+			    0x010203ff);
+}
+
+static struct file_system_type drm_fs_type = {
+	.name		= "drm",
+	.owner		= THIS_MODULE,
+	.mount		= drm_fs_mount,
+	.kill_sb	= kill_anon_super,
+};
+
+static struct inode *drm_fs_inode_new(void)
+{
+	struct inode *inode;
+	int r;
+
+	r = simple_pin_fs(&drm_fs_type, &drm_fs_mnt, &drm_fs_cnt);
+	if (r < 0) {
+		DRM_ERROR("Cannot mount pseudo fs: %d\n", r);
+		return ERR_PTR(r);
+	}
+
+	inode = alloc_anon_inode(drm_fs_mnt->mnt_sb);
+	if (IS_ERR(inode))
+		simple_release_fs(&drm_fs_mnt, &drm_fs_cnt);
+
+	return inode;
+}
+
+static void drm_fs_inode_free(struct inode *inode)
+{
+	if (inode) {
+		iput(inode);
+		simple_release_fs(&drm_fs_mnt, &drm_fs_cnt);
+	}
+}
+
 /**
  * drm_dev_alloc - Allocate new drm device
  * @driver: DRM driver to allocate device for
-- 
1.8.5.3

