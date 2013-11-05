Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab3KESmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 13:42:04 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:60147 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755372Ab3KESl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 13:41:59 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH 3/3] DT: proc: Add runtime overlay interface in /proc
Date: Tue,  5 Nov 2013 20:41:38 +0200
Message-Id: <1383676898-29819-4-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com>
References: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a runtime interface to /proc to enable generic device tree overlay
usage.

Two new /proc files are added:

/proc/device-tree-overlay & /proc/device-tree-overlay-status

/proc/device-tree-overlay accepts a stream of a device tree objects and
applies it to the running kernel's device tree.

	$ cat ~/BB-UART2-00A0.dtbo >device-tree-overlay
	overlay_proc_release: Applied #2 overlay segments @0

/proc/device-tree-overlay-status displays the the overlays added using
the /proc interface

	$ cat device-tree-overlay-status
	0: 861 bytes BB-UART2:00A0

The format of the status line is
	<ID>: <SIZE> bytes <part-number>:<version>

<ID> is the id of the overlay
<SIZE> is the size of the overlay in bytes
<part-number>, <version> are (optional) root level properties of the DTBO

You can remove an overlay by echoing the <ID> number of the overlay
precedded with a '-'

So
	$ echo "-0" >device-tree-overlay-status

Removes the overlay.

Note that this seldom works on most platforms since platform_device
removal is something that almost never works without extra patches.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 fs/proc/proc_devtree.c | 278 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 278 insertions(+)

diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
index 106a835..48f7925 100644
--- a/fs/proc/proc_devtree.c
+++ b/fs/proc/proc_devtree.c
@@ -16,6 +16,9 @@
 #include <linux/slab.h>
 #include <asm/prom.h>
 #include <asm/uaccess.h>
+#include <linux/of_fdt.h>
+#include <linux/idr.h>
+
 #include "internal.h"
 
 static inline void set_node_proc_entry(struct device_node *np,
@@ -28,6 +31,275 @@ static inline void set_node_proc_entry(struct device_node *np,
 
 static struct proc_dir_entry *proc_device_tree;
 
+#if defined(CONFIG_OF_OVERLAY)
+static struct proc_dir_entry *proc_device_tree_overlay;
+static struct proc_dir_entry *proc_device_tree_overlay_status;
+static DEFINE_MUTEX(overlay_lock);
+static DEFINE_IDR(overlay_idr);
+
+struct proc_overlay_data {
+	void			*buf;
+	size_t			alloc;
+	size_t			size;
+
+	int 			id;
+	struct device_node	*overlay;
+	int			ovinfo_cnt;
+	struct of_overlay_info	*ovinfo;
+	unsigned int		failed : 1;
+	unsigned int		applied : 1;
+	unsigned int		removing : 1;
+};
+
+static int overlay_proc_open(struct inode *inode, struct file *file)
+{
+	struct proc_overlay_data *od;
+
+	od = kzalloc(sizeof(*od), GFP_KERNEL);
+	if (od == NULL)
+		return -ENOMEM;
+
+	od->id = -1;
+
+	/* save it */
+	file->private_data = od;
+
+	return 0;
+}
+
+static ssize_t overlay_proc_write(struct file *file, const char __user *buf, size_t size, loff_t *ppos)
+{
+	struct proc_overlay_data *od = file->private_data;
+	void *new_buf;
+
+	/* need to alloc? */
+	if (od->size + size > od->alloc) {
+
+		/* start at 256K at first */
+		if (od->alloc == 0)
+			od->alloc = SZ_256K / 2;
+
+		/* double buffer */
+		od->alloc <<= 1;
+		new_buf = kzalloc(od->alloc, GFP_KERNEL);
+		if (new_buf == NULL) {
+			pr_err("%s: failed to grow buffer\n", __func__);
+			od->failed = 1;
+			return -ENOMEM;
+		}
+
+		/* copy all we had previously */
+		memcpy(new_buf, od->buf, od->size);
+
+		/* free old buffer and assign new */
+		kfree(od->buf);
+		od->buf = new_buf;
+	}
+
+	if (unlikely(copy_from_user(od->buf + od->size, buf, size))) {
+		pr_err("%s: fault copying from userspace\n", __func__);
+		return -EFAULT;
+	}
+
+	od->size += size;
+	*ppos += size;
+
+	return size;
+}
+
+static int overlay_proc_release(struct inode *inode, struct file *file)
+{
+	struct proc_overlay_data *od = file->private_data;
+	int id;
+	int err = 0;
+
+	/* perfectly normal when not loading */
+	if (od == NULL)
+		return 0;
+
+	if (od->failed)
+		goto out_free;
+
+	of_fdt_unflatten_tree(od->buf, &od->overlay);
+	if (od->overlay == NULL) {
+		pr_err("%s: failed to unflatten tree\n", __func__);
+		err = -EINVAL;
+		goto out_free;
+	}
+	pr_debug("%s: unflattened OK\n", __func__);
+
+	/* mark it as detached */
+	of_node_set_flag(od->overlay, OF_DETACHED);
+
+	/* perform resolution */
+	err = of_resolve(od->overlay);
+	if (err != 0) {
+		pr_err("%s: Failed to resolve tree\n", __func__);
+		goto out_free;
+	}
+	pr_debug("%s: resolved OK\n", __func__);
+
+	/* now build an overlay info array */
+	err = of_build_overlay_info(od->overlay,
+			&od->ovinfo_cnt, &od->ovinfo);
+	if (err != 0) {
+		pr_err("%s: Failed to build overlay info\n", __func__);
+		goto out_free;
+	}
+
+	pr_debug("%s: built %d overlay segments\n", __func__,
+			od->ovinfo_cnt);
+
+	err = of_overlay(od->ovinfo_cnt, od->ovinfo);
+	if (err != 0) {
+		pr_err("%s: Failed to apply overlay\n", __func__);
+		goto out_free;
+	}
+
+	od->applied = 1;
+
+	mutex_lock(&overlay_lock);
+	idr_preload(GFP_KERNEL);
+	id = idr_alloc(&overlay_idr, od, 0, -1, GFP_KERNEL);
+	idr_preload_end();
+	mutex_unlock(&overlay_lock);
+
+	if (id < 0) {
+		err = id;
+		pr_err("%s: failed to get id for overlay\n", __func__);
+		goto out_free;
+	}
+	od->id = id;
+
+	pr_info("%s: Applied #%d overlay segments @%d\n", __func__,
+			od->ovinfo_cnt, od->id);
+
+	return 0;
+
+out_free:
+	if (od->id != -1)
+		idr_remove(&overlay_idr, od->id);
+	if (od->applied)
+		of_overlay_revert(od->ovinfo_cnt, od->ovinfo);
+	if (od->ovinfo)
+		of_free_overlay_info(od->ovinfo_cnt, od->ovinfo);
+	/* release memory */
+	kfree(od->buf);
+	kfree(od);
+
+	return 0;
+}
+
+static const struct file_operations overlay_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= overlay_proc_open,
+	.write		= overlay_proc_write,
+	.release	= overlay_proc_release,
+};
+
+/*
+ * Supply data on a read from /proc/device-tree-overlay-status
+ */
+static int overlay_status_proc_show(struct seq_file *m, void *v)
+{
+	int err, id;
+	struct proc_overlay_data *od;
+	const char *part_number, *version;
+
+	rcu_read_lock();
+	idr_for_each_entry(&overlay_idr, od, id) {
+		seq_printf(m, "%d: %d bytes", id, od->size);
+		/* TODO Make this standardized? */
+		err = of_property_read_string(od->overlay, "part-number",
+					&part_number);
+		if (err != 0)
+			part_number = NULL;
+		err = of_property_read_string(od->overlay, "version",
+					&version);
+		if (err != 0)
+			version = NULL;
+		if (part_number) {
+			seq_printf(m, " %s", part_number);
+			if (version)
+				seq_printf(m, ":%s", version);
+		}
+		seq_printf(m, "\n");
+	}
+	rcu_read_unlock();
+
+	return 0;
+}
+
+static int overlay_status_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, overlay_status_proc_show, __PDE_DATA(inode));
+}
+
+static ssize_t overlay_status_proc_write(struct file *file, const char __user *buf,
+			     size_t size, loff_t *ppos)
+{
+	struct proc_overlay_data *od;
+	char buffer[PROC_NUMBUF + 1];
+	char *ptr;
+	int id, err, count;
+
+	memset(buffer, 0, sizeof(buffer));
+	count = size;
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+
+	if (copy_from_user(buffer, buf, count)) {
+		err = -EFAULT;
+		goto out;
+	}
+
+	ptr = buffer;
+	if (*ptr != '-') {	/* only removal supported */
+		err = -EINVAL;
+		goto out;
+	}
+	ptr++;
+	err = kstrtoint(strstrip(ptr), 0, &id);
+	if (err)
+		goto out;
+
+	/* find it */
+	mutex_lock(&overlay_lock);
+	od = idr_find(&overlay_idr, id);
+	if (od == NULL) {
+		mutex_unlock(&overlay_lock);
+		err = -EINVAL;
+		goto out;
+	}
+	/* remove it */
+	idr_remove(&overlay_idr, id);
+	mutex_unlock(&overlay_lock);
+
+	err = of_overlay_revert(od->ovinfo_cnt, od->ovinfo);
+	if (err != 0) {
+		pr_err("%s: of_overlay_revert failed\n", __func__);
+		goto out;
+	}
+	/* release memory */
+	of_free_overlay_info(od->ovinfo_cnt, od->ovinfo);
+	kfree(od->buf);
+	kfree(od);
+
+	pr_info("%s: Removed overlay with id %d\n", __func__, id);
+out:
+	return err < 0 ? err : count;
+}
+
+static const struct file_operations overlay_status_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= overlay_status_proc_open,
+	.read		= seq_read,
+	.write		= overlay_status_proc_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+#endif
+
 /*
  * Supply data on a read from /proc/device-tree/node/property.
  */
@@ -239,5 +511,11 @@ void __init proc_device_tree_init(void)
 		return;
 	}
 	proc_device_tree_add_node(root, proc_device_tree);
+#if defined(CONFIG_OF_OVERLAY)
+	proc_device_tree_overlay = proc_create_data("device-tree-overlay",
+			       S_IWUSR, NULL, &overlay_proc_fops, NULL);
+	proc_device_tree_overlay_status = proc_create_data("device-tree-overlay-status",
+			       S_IRUSR| S_IWUSR, NULL, &overlay_status_proc_fops, NULL);
+#endif
 	of_node_put(root);
 }
-- 
1.7.12

