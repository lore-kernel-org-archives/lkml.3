Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765AbaGCIn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:43:56 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45951 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619AbaGCIn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:43:29 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 19/23] drbd: debugfs: add per device data_gen_id
Date: Thu,  3 Jul 2014 10:43:11 +0200
Message-Id: <1404376995-4877-20-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
References: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

The data generation identifiers used to be exposed via sysfs
at /sys/block/drbdX/drbd/meta_data/data_gen_id (out-of-tree),
for advanced policy scripting.
Bring that information over to debugfs.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_debugfs.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/block/drbd/drbd_debugfs.c b/drivers/block/drbd/drbd_debugfs.c
index db70d6c..5c20b18 100644
--- a/drivers/block/drbd/drbd_debugfs.c
+++ b/drivers/block/drbd/drbd_debugfs.c
@@ -760,6 +760,25 @@ static int device_oldest_requests_show(struct seq_file *m, void *ignored)
 	return 0;
 }
 
+static int device_data_gen_id_show(struct seq_file *m, void *ignored)
+{
+	struct drbd_device *device = m->private;
+	struct drbd_md *md;
+	enum drbd_uuid_index idx;
+
+	if (!get_ldev_if_state(device, D_FAILED))
+		return -ENODEV;
+
+	md = &device->ldev->md;
+	spin_lock_irq(&md->uuid_lock);
+	for (idx = UI_CURRENT; idx <= UI_HISTORY_END; idx++) {
+		seq_printf(m, "0x%016llX\n", md->uuid[idx]);
+	}
+	spin_unlock_irq(&md->uuid_lock);
+	put_ldev(device);
+	return 0;
+}
+
 #define drbd_debugfs_device_attr(name)						\
 static int device_ ## name ## _open(struct inode *inode, struct file *file)	\
 {										\
@@ -784,6 +803,7 @@ static const struct file_operations device_ ## name ## _fops = {		\
 drbd_debugfs_device_attr(oldest_requests)
 drbd_debugfs_device_attr(act_log_extents)
 drbd_debugfs_device_attr(resync_extents)
+drbd_debugfs_device_attr(data_gen_id)
 
 void drbd_debugfs_device_add(struct drbd_device *device)
 {
@@ -826,6 +846,8 @@ void drbd_debugfs_device_add(struct drbd_device *device)
 	DCF(oldest_requests);
 	DCF(act_log_extents);
 	DCF(resync_extents);
+	DCF(data_gen_id);
+#undef DCF
 	return;
 
 fail:
-- 
1.9.1

