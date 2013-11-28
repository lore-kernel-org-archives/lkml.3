Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614Ab3K1UB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 15:01:27 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:43472 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444Ab3K1TzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:55:13 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/34] sysfs, kernfs: add kernfs_ops->seq_{start|next|stop}()
Date: Thu, 28 Nov 2013 14:54:26 -0500
Message-Id: <1385668487-10181-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernfs_ops currently only supports single_open() behavior which is
pretty restrictive.  Add optional callbacks ->seq_{start|next|stop}()
which, when implemented, are invoked for seq_file traversal.  This
allows full seq_file functionality for kernfs users.  This currently
doesn't have any user and doesn't change any behavior.

v2: Refreshed on top of the updated "sysfs, kernfs: prepare read path
    for kernfs".

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c        | 39 ++++++++++++++++++++++++++++-----------
 include/linux/kernfs.h |  9 +++++++--
 2 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 9852450..74e3478 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -146,6 +146,7 @@ static ssize_t sysfs_kf_bin_read(struct sysfs_open_file *of, char *buf,
 static void *kernfs_seq_start(struct seq_file *sf, loff_t *ppos)
 {
 	struct sysfs_open_file *of = sf->private;
+	const struct kernfs_ops *ops;
 
 	/*
 	 * @of->mutex nests outside active ref and is just to ensure that
@@ -155,26 +156,42 @@ static void *kernfs_seq_start(struct seq_file *sf, loff_t *ppos)
 	if (!sysfs_get_active(of->sd))
 		return ERR_PTR(-ENODEV);
 
-	/*
-	 * The same behavior and code as single_open().  Returns !NULL if
-	 * pos is at the beginning; otherwise, NULL.
-	 */
-	return NULL + !*ppos;
+	ops = kernfs_ops(of->sd);
+	if (ops->seq_start) {
+		return ops->seq_start(sf, ppos);
+	} else {
+		/*
+		 * The same behavior and code as single_open().  Returns
+		 * !NULL if pos is at the beginning; otherwise, NULL.
+		 */
+		return NULL + !*ppos;
+	}
 }
 
 static void *kernfs_seq_next(struct seq_file *sf, void *v, loff_t *ppos)
 {
-	/*
-	 * The same behavior and code as single_open(), always terminate
-	 * after the initial read.
-	 */
-	++*ppos;
-	return NULL;
+	struct sysfs_open_file *of = sf->private;
+	const struct kernfs_ops *ops = kernfs_ops(of->sd);
+
+	if (ops->seq_next) {
+		return ops->seq_next(sf, v, ppos);
+	} else {
+		/*
+		 * The same behavior and code as single_open(), always
+		 * terminate after the initial read.
+		 */
+		++*ppos;
+		return NULL;
+	}
 }
 
 static void kernfs_seq_stop(struct seq_file *sf, void *v)
 {
 	struct sysfs_open_file *of = sf->private;
+	const struct kernfs_ops *ops = kernfs_ops(of->sd);
+
+	if (ops->seq_stop)
+		ops->seq_stop(sf, v);
 
 	sysfs_put_active(of->sd);
 	mutex_unlock(&of->mutex);
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index d0912cf..ba993eb 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -37,8 +37,9 @@ struct kernfs_ops {
 	/*
 	 * Read is handled by either seq_file or raw_read().
 	 *
-	 * If seq_show() is present, seq_file path is active.  The behavior
-	 * is equivalent to single_open().  @sf->private points to the
+	 * If seq_show() is present, seq_file path is active.  Other seq
+	 * operations are optional and if not implemented, the behavior is
+	 * equivalent to single_open().  @sf->private points to the
 	 * associated sysfs_open_file.
 	 *
 	 * read() is bounced through kernel buffer and a read larger than
@@ -46,6 +47,10 @@ struct kernfs_ops {
 	 */
 	int (*seq_show)(struct seq_file *sf, void *v);
 
+	void *(*seq_start)(struct seq_file *sf, loff_t *ppos);
+	void *(*seq_next)(struct seq_file *sf, void *v, loff_t *ppos);
+	void (*seq_stop)(struct seq_file *sf, void *v);
+
 	ssize_t (*read)(struct sysfs_open_file *of, char *buf, size_t bytes,
 			loff_t off);
 
-- 
1.8.4.2

