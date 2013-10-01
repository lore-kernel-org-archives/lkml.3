Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab3JAVpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:45:52 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:64658 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab3JAVmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:42:22 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/15] sysfs: add sysfs_open_file_mutex
Date: Tue,  1 Oct 2013 17:41:58 -0400
Message-Id: <1380663729-18243-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380663729-18243-1-git-send-email-tj@kernel.org>
References: <1380663729-18243-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a separate mutex to protect sysfs_open_dirent->buffers list.  This
will allow performing sleepable operations while traversing
sysfs_buffers, which will be renamed to sysfs_open_file.

Note that currently sysfs_open_dirent->buffers list isn't being used
for anything and this patch doesn't make any functional difference.
It will be used to merge regular and bin file supports.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 7dfcc33..499cff8 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -25,15 +25,17 @@
 #include "sysfs.h"
 
 /*
- * There's one sysfs_buffer for each open file and one
- * sysfs_open_dirent for each sysfs_dirent with one or more open
- * files.
+ * There's one sysfs_buffer for each open file and one sysfs_open_dirent
+ * for each sysfs_dirent with one or more open files.
  *
- * filp->private_data points to sysfs_buffer and
- * sysfs_dirent->s_attr.open points to sysfs_open_dirent.  s_attr.open
- * is protected by sysfs_open_dirent_lock.
+ * sysfs_dirent->s_attr.open points to sysfs_open_dirent.  s_attr.open is
+ * protected by sysfs_open_dirent_lock.
+ *
+ * filp->private_data points to sysfs_buffer which is chained at
+ * sysfs_open_dirent->buffers, which is protected by sysfs_open_file_mutex.
  */
 static DEFINE_SPINLOCK(sysfs_open_dirent_lock);
+static DEFINE_MUTEX(sysfs_open_file_mutex);
 
 struct sysfs_open_dirent {
 	atomic_t		refcnt;
@@ -272,6 +274,7 @@ static int sysfs_get_open_dirent(struct sysfs_dirent *sd,
 	struct sysfs_open_dirent *od, *new_od = NULL;
 
  retry:
+	mutex_lock(&sysfs_open_file_mutex);
 	spin_lock_irq(&sysfs_open_dirent_lock);
 
 	if (!sd->s_attr.open && new_od) {
@@ -286,6 +289,7 @@ static int sysfs_get_open_dirent(struct sysfs_dirent *sd,
 	}
 
 	spin_unlock_irq(&sysfs_open_dirent_lock);
+	mutex_unlock(&sysfs_open_file_mutex);
 
 	if (od) {
 		kfree(new_od);
@@ -321,6 +325,7 @@ static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
 	struct sysfs_open_dirent *od = sd->s_attr.open;
 	unsigned long flags;
 
+	mutex_lock(&sysfs_open_file_mutex);
 	spin_lock_irqsave(&sysfs_open_dirent_lock, flags);
 
 	list_del(&buffer->list);
@@ -330,6 +335,7 @@ static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
 		od = NULL;
 
 	spin_unlock_irqrestore(&sysfs_open_dirent_lock, flags);
+	mutex_unlock(&sysfs_open_file_mutex);
 
 	kfree(od);
 }
-- 
1.8.3.1

