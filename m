Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635Ab3BMKXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 05:23:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39163 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932667Ab3BMKXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 05:23:36 -0500
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: linux-mtd@lists.infradead.org
Cc: kernel@pengutronix.de, artem.bityutskiy@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Subodh Nijsure <snijsure@grid-net.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH RFC 5/5] UBIFS: add ubifs_err() to print error reason
Date: Wed, 13 Feb 2013 11:23:18 +0100
Message-Id: <1360750998-15191-6-git-send-email-mkl@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360750998-15191-1-git-send-email-mkl@pengutronix.de>
References: <1360750998-15191-1-git-send-email-mkl@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Subodh Nijsure <snijsure@grid-net.com>

This patch add ubifs_err() output to some error pathes to tell the user what's
going on.

Signed-off-by: Subodh Nijsure <snijsure@grid-net.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 fs/ubifs/dir.c   |   20 ++++++++++++++++----
 fs/ubifs/xattr.c |   12 ++++++++++--
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 6aa31b5..d0dd7a9 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -282,8 +282,11 @@ static int ubifs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 		goto out_cancel;
 
 	err = ubifs_init_security(dir, inode, &dentry->d_name);
-	if (err)
+	if (err) {
+		ubifs_err("cannot initialize extended attribute, error %d",
+			  err);
 		goto out_cancel;
+	}
 	mutex_unlock(&dir_ui->ui_mutex);
 
 	ubifs_release_budget(c, &req);
@@ -748,8 +751,11 @@ static int ubifs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	}
 
 	err = ubifs_init_security(dir, inode, &dentry->d_name);
-	if (err)
+	if (err) {
+		ubifs_err("cannot initialize extended attribute, error %d",
+			  err);
 		goto out_cancel;
+	}
 	mutex_unlock(&dir_ui->ui_mutex);
 
 	ubifs_release_budget(c, &req);
@@ -828,8 +834,11 @@ static int ubifs_mknod(struct inode *dir, struct dentry *dentry,
 		goto out_cancel;
 
 	err = ubifs_init_security(dir, inode, &dentry->d_name);
-	if (err)
+	if (err) {
+		ubifs_err("cannot initialize extended attribute, error %d",
+			  err);
 		goto out_cancel;
+	}
 	mutex_unlock(&dir_ui->ui_mutex);
 
 	ubifs_release_budget(c, &req);
@@ -908,8 +917,11 @@ static int ubifs_symlink(struct inode *dir, struct dentry *dentry,
 		goto out_cancel;
 
 	err = ubifs_init_security(dir, inode, &dentry->d_name);
-	if (err)
+	if (err) {
+		ubifs_err("cannot initialize extended attribute, error %d",
+			  err);
 		goto out_cancel;
+	}
 	mutex_unlock(&dir_ui->ui_mutex);
 
 	ubifs_release_budget(c, &req);
diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index aa81bd3..380fcc9 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -107,8 +107,11 @@ static int create_xattr(struct ubifs_info *c, struct inode *host,
 				.new_ino_d = ALIGN(size, 8), .dirtied_ino = 1,
 				.dirtied_ino_d = ALIGN(host_ui->data_len, 8) };
 
-	if (host_ui->xattr_cnt >= MAX_XATTRS_PER_INODE)
+	if (host_ui->xattr_cnt >= MAX_XATTRS_PER_INODE) {
+		ubifs_err("ubifs xattr_cnt %d exceeds MAX_XATTR_PER_NODE (%d)",
+			  host_ui->xattr_cnt, MAX_XATTRS_PER_INODE);
 		return -ENOSPC;
+	}
 	/*
 	 * Linux limits the maximum size of the extended attribute names list
 	 * to %XATTR_LIST_MAX. This means we should not allow creating more
@@ -116,8 +119,13 @@ static int create_xattr(struct ubifs_info *c, struct inode *host,
 	 * is artificial for UBIFS, though.
 	 */
 	if (host_ui->xattr_names + host_ui->xattr_cnt +
-					nm->len + 1 > XATTR_LIST_MAX)
+					nm->len + 1 > XATTR_LIST_MAX) {
+		ubifs_err("xattr name list too large %d > %d",
+			  host_ui->xattr_names + host_ui->xattr_cnt +
+			  nm->len + 1,
+			  XATTR_LIST_MAX);
 		return -ENOSPC;
+	}
 
 	err = ubifs_budget_space(c, &req);
 	if (err)
-- 
1.7.10.4

