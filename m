Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410AbaGCItX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:49:23 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45938 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298AbaGCIn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:43:26 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 13/23] drbd: debugfs: deal with destructor racing with open of debugfs file
Date: Thu,  3 Jul 2014 10:43:05 +0200
Message-Id: <1404376995-4877-14-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
References: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Try to close the race between open() and debugfs_remove_recursive()
from inside an object destructor.
Once open succeeds, the object should stay around.
Open should not succeed if the object has already reached its destructor.

This may be overkill, but to make that happen, we check for existence of
a parent directory, "stale-ness" of "this" dentry, and serialize
kref_get_unless_zero() on the outermost object relevant for this file
with d_delete() on this dentry (using the parent's i_mutex).

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_debugfs.c | 58 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_debugfs.c b/drivers/block/drbd/drbd_debugfs.c
index d393aee..51c64ec 100644
--- a/drivers/block/drbd/drbd_debugfs.c
+++ b/drivers/block/drbd/drbd_debugfs.c
@@ -177,8 +177,8 @@ static int in_flight_summary_show(struct seq_file *m, void *pos)
 	connection = first_connection(resource);
 	/* This does not happen, actually.
 	 * But be robust and prepare for future code changes. */
-	if (!connection)
-		return 0;
+	if (!connection || !kref_get_unless_zero(&connection->kref))
+		return -ESTALE;
 
 	seq_puts(m, "oldest application requests\n");
 	seq_print_resource_transfer_log_summary(m, resource, connection, jif);
@@ -187,12 +187,62 @@ static int in_flight_summary_show(struct seq_file *m, void *pos)
 	jif = jiffies - jif;
 	if (jif)
 		seq_printf(m, "generated in %d ms\n", jiffies_to_msecs(jif));
+	kref_put(&connection->kref, drbd_destroy_connection);
 	return 0;
 }
 
+/* simple_positive(file->f_dentry) respectively debugfs_positive(),
+ * but neither is "reachable" from here.
+ * So we have our own inline version of it above.  :-( */
+static inline int debugfs_positive(struct dentry *dentry)
+{
+        return dentry->d_inode && !d_unhashed(dentry);
+}
+
+/* make sure at *open* time that the respective object won't go away. */
+static int drbd_single_open(struct file *file, int (*show)(struct seq_file *, void *),
+		                void *data, struct kref *kref,
+				void (*release)(struct kref *))
+{
+	struct dentry *parent;
+	int ret = -ESTALE;
+
+	/* Are we still linked,
+	 * or has debugfs_remove() already been called? */
+	parent = file->f_dentry->d_parent;
+	/* not sure if this can happen: */
+	if (!parent || !parent->d_inode)
+		goto out;
+	/* serialize with d_delete() */
+	mutex_lock(&parent->d_inode->i_mutex);
+	if (!debugfs_positive(file->f_dentry))
+		goto out_unlock;
+	/* Make sure the object is still alive */
+	if (kref_get_unless_zero(kref))
+		ret = 0;
+out_unlock:
+	mutex_unlock(&parent->d_inode->i_mutex);
+	if (!ret) {
+		ret = single_open(file, show, data);
+		if (ret)
+			kref_put(kref, release);
+	}
+out:
+	return ret;
+}
+
 static int in_flight_summary_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, in_flight_summary_show, inode->i_private);
+	struct drbd_resource *resource = inode->i_private;
+	return drbd_single_open(file, in_flight_summary_show, resource,
+				&resource->kref, drbd_destroy_resource);
+}
+
+static int in_flight_summary_release(struct inode *inode, struct file *file)
+{
+	struct drbd_resource *resource = inode->i_private;
+	kref_put(&resource->kref, drbd_destroy_resource);
+	return single_release(inode, file);
 }
 
 static const struct file_operations in_flight_summary_fops = {
@@ -200,7 +250,7 @@ static const struct file_operations in_flight_summary_fops = {
 	.open		= in_flight_summary_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= in_flight_summary_release,
 };
 
 void drbd_debugfs_resource_add(struct drbd_resource *resource)
-- 
1.9.1

