Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab3LKVFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:05:25 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:46775 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3LKVFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:05:23 -0500
Date: Wed, 11 Dec 2013 16:05:15 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, kay@vrfy.org
Subject: test-kernfs module
Message-ID: <20131211210515.GA7683@mtj.dyndns.org>
References: <1386795780-23324-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386795780-23324-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/test-kernfs/Makefile b/test-kernfs/Makefile
new file mode 100644
index 0000000..e64553b
--- /dev/null
+++ b/test-kernfs/Makefile
@@ -0,0 +1 @@
+obj-m := test-kernfs.o
diff --git a/test-kernfs/test-kernfs.c b/test-kernfs/test-kernfs.c
new file mode 100644
index 0000000..4f91b1b
--- /dev/null
+++ b/test-kernfs/test-kernfs.c
@@ -0,0 +1,153 @@
+#include <linux/module.h>
+#include <linux/kernfs.h>
+#include <linux/fs.h>
+#include <linux/seq_file.h>
+
+static struct kernfs_root *test_root;
+
+char test_buf[4096] = "whatever";
+
+static int test_seq_show(struct seq_file *sf, void *v)
+{
+	struct kernfs_open_file *of = sf->private;
+
+	seq_printf(sf, "%s: %s\n", of->kn->name, test_buf);
+	return 0;
+}
+
+static ssize_t test_write(struct kernfs_open_file *sf, char *buf, size_t bytes,
+			  loff_t off)
+{
+	bytes = min_t(size_t, bytes, PAGE_SIZE - 1);
+	memcpy(test_buf, buf, bytes);
+	test_buf[bytes] = '\0';
+	return bytes;
+}
+
+static struct kernfs_ops test_kernfs_ops = {
+	.seq_show	= test_seq_show,
+	.write		= test_write,
+};
+
+static int test_mkdir(struct kernfs_node *parent, const char *name, umode_t mode)
+{
+	struct kernfs_node *kn;
+
+	if (IS_ERR(kn = kernfs_create_dir(parent, name, mode, NULL))) {
+		printk("XXX test_mkdir %zd\n", PTR_ERR(kn));
+		return PTR_ERR(kn);
+	}
+
+	kernfs_create_file(kn, "file", 0755, 4096, &test_kernfs_ops, NULL);
+
+	printk("XXX test_mkdir success\n");
+	return 0;
+}
+
+static int test_rmdir(struct kernfs_node *kn)
+{
+	printk("XXX test_rmdir\n");
+	kernfs_remove(kn);
+	return 0;
+}
+
+static int test_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
+		       const char *new_name)
+{
+	static char namebuf[4096];
+
+	snprintf(namebuf, sizeof(namebuf), "%s-XXX", new_name);
+	printk("XXX test_rename\n");
+	return kernfs_rename_ns(kn, new_parent, namebuf, NULL);
+}
+
+static struct kernfs_dir_ops test_dops = {
+	.mkdir		= test_mkdir,
+	.rmdir		= test_rmdir,
+	.rename		= test_rename,
+};
+
+static void test_populate(void)
+{
+	struct kernfs_node *root = test_root->kn;
+	struct kernfs_node *d0, *d00, *d01, *d1, *d10;
+	struct kernfs_node *f0_0, *f0_1, *f00_0, *f01_1;
+	struct kernfs_node *l1_0, *l1_1, *l10_0;
+
+	if (IS_ERR(d0 = kernfs_create_dir(root, "d0", 0755, NULL)))
+		goto err;
+	if (IS_ERR(d00 = kernfs_create_dir(d0, "d00", 0755, NULL)))
+		goto err;
+	if (IS_ERR(d01 = kernfs_create_dir(d0, "d01", 0755, NULL)))
+		goto err;
+	if (IS_ERR(d1 = kernfs_create_dir(root, "d1", 0755, NULL)))
+		goto err;
+	if (IS_ERR(d10 = kernfs_create_dir(d1, "d10", 0755, NULL)))
+		goto err;
+
+	if (IS_ERR(f0_0 = kernfs_create_file(d0, "f0_0", 0755, 4096,
+					     &test_kernfs_ops, NULL)))
+		goto err;
+	if (IS_ERR(f0_1 = kernfs_create_file(d0, "f0_1", 0755, 4096,
+					     &test_kernfs_ops, NULL)))
+		goto err;
+	if (IS_ERR(f00_0 = kernfs_create_file(d00, "f00_0", 0755, 4096,
+					      &test_kernfs_ops, NULL)))
+		goto err;
+	if (IS_ERR(f01_1 = kernfs_create_file(d01, "f01_1", 0755, 4096,
+					      &test_kernfs_ops, NULL)))
+		goto err;
+
+	if (IS_ERR(l1_0 = kernfs_create_link(d1, "l1_0", f0_0)))
+		goto err;
+	if (IS_ERR(l1_1 = kernfs_create_link(d1, "l1_1", f0_1)))
+		goto err;
+	if (IS_ERR(l10_0 = kernfs_create_link(d10, "l10_0", f0_0)))
+		goto err;
+
+	return;
+err:
+	printk("XXX failed to populate\n");
+}
+
+static struct dentry *test_mount(struct file_system_type *fs_type, int flags,
+				 const char *dev_name, void *data)
+{
+	return kernfs_mount(fs_type, flags, test_root);
+}
+
+static struct file_system_type test_fs_type = {
+	.name		= "test",
+	.mount		= test_mount,
+	.kill_sb	= kernfs_kill_sb,
+	.owner		= THIS_MODULE,
+};
+
+static int __init test_init(void)
+{
+	int err;
+
+	test_root = kernfs_create_root(&test_dops, NULL);
+	if (IS_ERR(test_root))
+		return PTR_ERR(test_root);
+
+	err = register_filesystem(&test_fs_type);
+	if (err) {
+		kernfs_destroy_root(test_root);
+		return err;
+	}
+
+	test_populate();
+
+	return 0;
+}
+
+static void __exit test_exit(void)
+{
+	unregister_filesystem(&test_fs_type);
+	kernfs_destroy_root(test_root);
+}
+
+module_init(test_init);
+module_exit(test_exit);
+MODULE_LICENSE("GPL");
