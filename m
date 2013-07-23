Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab3GWIKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:10:06 -0400
Received: from smtpbg52.qq.com ([64.71.138.43]:44481 "HELO smtpbg52.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755326Ab3GWIJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:09:24 -0400
X-QQ-mid: bizesmtp1t1374566960t587t034
X-QQ-SSF: 01400000000000F0FNF2000B0000000
Message-ID: <51EE3AD4.7030607@tnsoft.com.cn>
Date: Tue, 23 Jul 2013 16:12:04 +0800
From: Dennis Chen <xschen@tnsoft.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: viro@zeniv.linux.org.uk, Dennis Chen <xschen@tnsoft.com.cn>
Subject: [PATCH]Fix kernel NULL function pointer dereference in vfs_kern_mount()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-QQ-FName: 9FD1DA4EEBCB4C408B6F1B15A27BB463
X-QQ-LocalIP: 112.95.241.173
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is try to fix a potential NULL function pointer dereference in the exported
vfs_kern_mount() function which can be triggered by following kernel module code piece:

static struct vfsmount *npfs_mnt;
static struct file_system_type np_fs_type = {
         .name		= "npfs",
         .kill_sb      	= npfs_kill_sb,
         .fs_flags     	= FS_USERNS_MOUNT,
};

static int fsmod_init(void)
{
	int err = -ENOMEM;

	err = register_filesystem(&np_fs_type);
	if (!err) {
		npfs_mnt = kern_mount(&np_fs_type);
		if (IS_ERR(npfs_mnt)) {
			printk(KERN_ERR "npfs: could not mount!\n");
			unregister_filesystem(&np_fs_type);
			return PTR_ERR(npfs_mnt);
		}
	}

	return err;
}

I happened to forget to implement a (*mount)() function in the np_fs_type instance which
is buggy definitely, but as an exported function to the outside, kernel should not suppose
the caller will always take the right action. In this scenario, I have to reboot my machine
to clean the loaded kernel module.

Signed-off-by: Dennis Chen <xschen@tnsoft.com.cn>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---
fs/filesystems.c |    5 +++++
fs/namespace.c   |    2 ++
fs/super.c       |   10 ++++++++++
3 files changed, 17 insertions(+)

diff --git a/fs/filesystems.c b/fs/filesystems.c
index 92567d9..6d6b162 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -71,6 +71,11 @@ int register_filesystem(struct file_system_type * fs)
         int res = 0;
         struct file_system_type ** p;
  
+       if (!fs)
+               return -ENODEV;
+       if (!fs->name)
+               return -EINVAL;
+
         BUG_ON(strchr(fs->name, '.'));
         if (fs->next)
                 return -EBUSY;
diff --git a/fs/namespace.c b/fs/namespace.c
index 7b1ca9b..ad17692 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2758,6 +2758,8 @@ void put_mnt_ns(struct mnt_namespace *ns)
  struct vfsmount *kern_mount_data(struct file_system_type *type, void *data)
  {
         struct vfsmount *mnt;
+       if (!type)
+               return ERR_PTR(-ENODEV);
         mnt = vfs_kern_mount(type, MS_KERNMOUNT, type->name, data);
         if (!IS_ERR(mnt)) {
                 /*
diff --git a/fs/super.c b/fs/super.c
index 68307c0..d995a19 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1101,11 +1101,21 @@ mount_fs(struct file_system_type *type, int flags, const char *name, void *data)
                         goto out_free_secdata;
         }
  
+       if (!type->mount) {
+               error = -EINVAL;
+               printk(KERN_ERR "No 'mount' method defined in %s\n", type->name);
+               goto out_free_secdata;
+       }
         root = type->mount(type, flags, name, data);
         if (IS_ERR(root)) {
                 error = PTR_ERR(root);
                 goto out_free_secdata;
         }
+       if (!root) {
+               error = -EINVAL;
+               goto out_free_secdata;
+       }
+
         sb = root->d_sb;
         BUG_ON(!sb);
         WARN_ON(!sb->s_bdi);

