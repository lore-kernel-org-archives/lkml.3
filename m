Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaK3MRC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:17:02 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14386 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbaK3MPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:15:37 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/6] UBI: Add initial support for fastmap self checks
Date: Sun, 30 Nov 2014 13:15:23 +0100
Message-Id: <1417349728-9070-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417349728-9070-1-git-send-email-richard@nod.at>
References: <1417349728-9070-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using this debugfs knob fastmap self checks can be controlled.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/debug.c | 11 +++++++++++
 drivers/mtd/ubi/debug.h |  5 +++++
 drivers/mtd/ubi/ubi.h   |  4 ++++
 3 files changed, 20 insertions(+)

diff --git a/drivers/mtd/ubi/debug.c b/drivers/mtd/ubi/debug.c
index 7335c9f..224fed0 100644
--- a/drivers/mtd/ubi/debug.c
+++ b/drivers/mtd/ubi/debug.c
@@ -275,6 +275,8 @@ static ssize_t dfs_file_read(struct file *file, char __user *user_buf,
 		val = d->chk_gen;
 	else if (dent == d->dfs_chk_io)
 		val = d->chk_io;
+	else if (dent == d->dfs_chk_fastmap)
+		val = d->chk_fastmap;
 	else if (dent == d->dfs_disable_bgt)
 		val = d->disable_bgt;
 	else if (dent == d->dfs_emulate_bitflips)
@@ -336,6 +338,8 @@ static ssize_t dfs_file_write(struct file *file, const char __user *user_buf,
 		d->chk_gen = val;
 	else if (dent == d->dfs_chk_io)
 		d->chk_io = val;
+	else if (dent == d->dfs_chk_fastmap)
+		d->chk_fastmap = val;
 	else if (dent == d->dfs_disable_bgt)
 		d->disable_bgt = val;
 	else if (dent == d->dfs_emulate_bitflips)
@@ -406,6 +410,13 @@ int ubi_debugfs_init_dev(struct ubi_device *ubi)
 		goto out_remove;
 	d->dfs_chk_io = dent;
 
+	fname = "chk_fastmap";
+	dent = debugfs_create_file(fname, S_IWUSR, d->dfs_dir, (void *)ubi_num,
+				   &dfs_fops);
+	if (IS_ERR_OR_NULL(dent))
+		goto out_remove;
+	d->dfs_chk_fastmap = dent;
+
 	fname = "tst_disable_bgt";
 	dent = debugfs_create_file(fname, S_IWUSR, d->dfs_dir, (void *)ubi_num,
 				   &dfs_fops);
diff --git a/drivers/mtd/ubi/debug.h b/drivers/mtd/ubi/debug.h
index cba89fc..e99ef37 100644
--- a/drivers/mtd/ubi/debug.h
+++ b/drivers/mtd/ubi/debug.h
@@ -127,4 +127,9 @@ static inline int ubi_dbg_chk_gen(const struct ubi_device *ubi)
 {
 	return ubi->dbg.chk_gen;
 }
+
+static inline int ubi_dbg_chk_fastmap(const struct ubi_device *ubi)
+{
+	return ubi->dbg.chk_fastmap;
+}
 #endif /* !__UBI_DEBUG_H__ */
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 233e742..d3ad165 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -353,6 +353,7 @@ struct ubi_wl_entry;
  *
  * @chk_gen: if UBI general extra checks are enabled
  * @chk_io: if UBI I/O extra checks are enabled
+ * @chk_fastmap: if UBI fastmap extra checks are enabled
  * @disable_bgt: disable the background task for testing purposes
  * @emulate_bitflips: emulate bit-flips for testing purposes
  * @emulate_io_failures: emulate write/erase failures for testing purposes
@@ -360,6 +361,7 @@ struct ubi_wl_entry;
  * @dfs_dir: direntry object of the UBI device debugfs directory
  * @dfs_chk_gen: debugfs knob to enable UBI general extra checks
  * @dfs_chk_io: debugfs knob to enable UBI I/O extra checks
+ * @dfs_chk_fastmap: debugfs knob to enable UBI fastmap extra checks
  * @dfs_disable_bgt: debugfs knob to disable the background task
  * @dfs_emulate_bitflips: debugfs knob to emulate bit-flips
  * @dfs_emulate_io_failures: debugfs knob to emulate write/erase failures
@@ -367,6 +369,7 @@ struct ubi_wl_entry;
 struct ubi_debug_info {
 	unsigned int chk_gen:1;
 	unsigned int chk_io:1;
+	unsigned int chk_fastmap:1;
 	unsigned int disable_bgt:1;
 	unsigned int emulate_bitflips:1;
 	unsigned int emulate_io_failures:1;
@@ -374,6 +377,7 @@ struct ubi_debug_info {
 	struct dentry *dfs_dir;
 	struct dentry *dfs_chk_gen;
 	struct dentry *dfs_chk_io;
+	struct dentry *dfs_chk_fastmap;
 	struct dentry *dfs_disable_bgt;
 	struct dentry *dfs_emulate_bitflips;
 	struct dentry *dfs_emulate_io_failures;
-- 
1.8.4.5

