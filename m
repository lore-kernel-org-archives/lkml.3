Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbaGCIoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:44:04 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45904 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342AbaGCIn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:43:28 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 17/23] drbd: debugfs: add version tag to debugfs files
Date: Thu,  3 Jul 2014 10:43:09 +0200
Message-Id: <1404376995-4877-18-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
References: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Make the first line of debugfs files a version number,
starting now with "v: 0".

If we change content of presentation, we will bump that.
Monitoring or diagnostic scritps that may parse these files
can then easily know when they need to be reviewed.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_debugfs.c | 52 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/block/drbd/drbd_debugfs.c b/drivers/block/drbd/drbd_debugfs.c
index 45b5205..a4d0666 100644
--- a/drivers/block/drbd/drbd_debugfs.c
+++ b/drivers/block/drbd/drbd_debugfs.c
@@ -11,7 +11,13 @@
 #include "drbd_req.h"
 #include "drbd_debugfs.h"
 
+
+/**********************************************************************
+ * Whenever you change the file format, remember to bump the version. *
+ **********************************************************************/
+
 static struct dentry *drbd_debugfs_root;
+static struct dentry *drbd_debugfs_version;
 static struct dentry *drbd_debugfs_resources;
 static struct dentry *drbd_debugfs_minors;
 
@@ -368,6 +374,9 @@ static int in_flight_summary_show(struct seq_file *m, void *pos)
 	if (!connection || !kref_get_unless_zero(&connection->kref))
 		return -ESTALE;
 
+	/* BUMP me if you change the file format/content/presentation */
+	seq_printf(m, "v: %u\n\n", 0);
+
 	seq_puts(m, "oldest bitmap IO\n");
 	seq_print_resource_pending_bitmap_io(m, resource, jif);
 	seq_putc(m, '\n');
@@ -562,6 +571,9 @@ static int callback_history_show(struct seq_file *m, void *ignored)
 	struct drbd_connection *connection = m->private;
 	unsigned long jif = jiffies;
 
+	/* BUMP me if you change the file format/content/presentation */
+	seq_printf(m, "v: %u\n\n", 0);
+
 	seq_puts(m, "n\tage\tcallsite\tfn\n");
 	seq_print_timing_details(m, "worker", connection->w_cb_nr, connection->w_timing_details, jif);
 	seq_print_timing_details(m, "receiver", connection->r_cb_nr, connection->r_timing_details, jif);
@@ -686,6 +698,10 @@ static void resync_dump_detail(struct seq_file *m, struct lc_element *e)
 static int device_resync_extents_show(struct seq_file *m, void *ignored)
 {
 	struct drbd_device *device = m->private;
+
+	/* BUMP me if you change the file format/content/presentation */
+	seq_printf(m, "v: %u\n\n", 0);
+
 	if (get_ldev_if_state(device, D_FAILED)) {
 		lc_seq_printf_stats(m, device->resync);
 		lc_seq_dump_details(m, device->resync, "rs_left flags", resync_dump_detail);
@@ -697,6 +713,10 @@ static int device_resync_extents_show(struct seq_file *m, void *ignored)
 static int device_act_log_extents_show(struct seq_file *m, void *ignored)
 {
 	struct drbd_device *device = m->private;
+
+	/* BUMP me if you change the file format/content/presentation */
+	seq_printf(m, "v: %u\n\n", 0);
+
 	if (get_ldev_if_state(device, D_FAILED)) {
 		lc_seq_printf_stats(m, device->act_log);
 		lc_seq_dump_details(m, device->act_log, "", NULL);
@@ -713,6 +733,9 @@ static int device_oldest_requests_show(struct seq_file *m, void *ignored)
 	struct drbd_request *r1, *r2;
 	int i;
 
+	/* BUMP me if you change the file format/content/presentation */
+	seq_printf(m, "v: %u\n\n", 0);
+
 	seq_puts(m, RQ_HDR);
 	spin_lock_irq(&resource->req_lock);
 	/* WRITE, then READ */
@@ -839,12 +862,36 @@ void drbd_debugfs_peer_device_cleanup(struct drbd_peer_device *peer_device)
 	drbd_debugfs_remove(&peer_device->debugfs_peer_dev);
 }
 
+static int drbd_version_show(struct seq_file *m, void *ignored)
+{
+	seq_printf(m, "# %s\n", drbd_buildtag());
+	seq_printf(m, "VERSION=%s\n", REL_VERSION);
+	seq_printf(m, "API_VERSION=%u\n", API_VERSION);
+	seq_printf(m, "PRO_VERSION_MIN=%u\n", PRO_VERSION_MIN);
+	seq_printf(m, "PRO_VERSION_MAX=%u\n", PRO_VERSION_MAX);
+	return 0;
+}
+
+static int drbd_version_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, drbd_version_show, NULL);
+}
+
+static struct file_operations drbd_version_fops = {
+	.owner = THIS_MODULE,
+	.open = drbd_version_open,
+	.llseek = seq_lseek,
+	.read = seq_read,
+	.release = single_release,
+};
+
 /* not __exit, may be indirectly called
  * from the module-load-failure path as well. */
 void drbd_debugfs_cleanup(void)
 {
 	drbd_debugfs_remove(&drbd_debugfs_resources);
 	drbd_debugfs_remove(&drbd_debugfs_minors);
+	drbd_debugfs_remove(&drbd_debugfs_version);
 	drbd_debugfs_remove(&drbd_debugfs_root);
 }
 
@@ -857,6 +904,11 @@ int __init drbd_debugfs_init(void)
 		goto fail;
 	drbd_debugfs_root = dentry;
 
+	dentry = debugfs_create_file("version", 0444, drbd_debugfs_root, NULL, &drbd_version_fops);
+	if (IS_ERR_OR_NULL(dentry))
+		goto fail;
+	drbd_debugfs_version = dentry;
+
 	dentry = debugfs_create_dir("resources", drbd_debugfs_root);
 	if (IS_ERR_OR_NULL(dentry))
 		goto fail;
-- 
1.9.1

