Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbaGQTxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 15:53:22 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:54860 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833AbaGQTwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 15:52:45 -0400
From: Aditya Kali <adityakali@google.com>
To: tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        mingo@redhat.com
Cc: containers@lists.linux-foundation.org, Aditya Kali <adityakali@google.com>
Subject: [PATCH 1/5] kernfs: Add API to get generate relative kernfs path
Date: Thu, 17 Jul 2014 12:52:07 -0700
Message-Id: <1405626731-12220-2-git-send-email-adityakali@google.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1405626731-12220-1-git-send-email-adityakali@google.com>
References: <adityakali-cgroupns>
 <1405626731-12220-1-git-send-email-adityakali@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new function kernfs_path_from_node() generates and returns
kernfs path of a given kernfs_node relative to a given parent
kernfs_node.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 fs/kernfs/dir.c        | 51 ++++++++++++++++++++++++++++++++++++++++----------
 include/linux/kernfs.h |  3 +++
 2 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index a693f5b..2224f08 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -44,14 +44,22 @@ static int kernfs_name_locked(struct kernfs_node *kn, char *buf, size_t buflen)
 	return strlcpy(buf, kn->parent ? kn->name : "/", buflen);
 }
 
-static char * __must_check kernfs_path_locked(struct kernfs_node *kn, char *buf,
-					      size_t buflen)
+static char * __must_check kernfs_path_from_node_locked(
+	struct kernfs_node *kn_root,
+	struct kernfs_node *kn,
+	char *buf,
+	size_t buflen)
 {
 	char *p = buf + buflen;
 	int len;
 
 	*--p = '\0';
 
+	if (kn == kn_root) {
+		*--p = '/';
+		return p;
+	}
+
 	do {
 		len = strlen(kn->name);
 		if (p - buf < len + 1) {
@@ -63,6 +71,8 @@ static char * __must_check kernfs_path_locked(struct kernfs_node *kn, char *buf,
 		memcpy(p, kn->name, len);
 		*--p = '/';
 		kn = kn->parent;
+		if (kn == kn_root)
+			break;
 	} while (kn && kn->parent);
 
 	return p;
@@ -92,26 +102,47 @@ int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen)
 }
 
 /**
- * kernfs_path - build full path of a given node
+ * kernfs_path_from_node - build path of node @kn relative to @kn_root.
+ * @kn_root: parent kernfs_node relative to which we need to build the path
  * @kn: kernfs_node of interest
- * @buf: buffer to copy @kn's name into
+ * @buf: buffer to copy @kn's path into
  * @buflen: size of @buf
  *
- * Builds and returns the full path of @kn in @buf of @buflen bytes.  The
- * path is built from the end of @buf so the returned pointer usually
+ * Builds and returns @kn's path relative to @kn_root. @kn_root is expected to
+ * be parent of @kn at some level. If this is not true or if @kn_root is NULL,
+ * then full path of @kn is returned.
+ * The path is built from the end of @buf so the returned pointer usually
  * doesn't match @buf.  If @buf isn't long enough, @buf is nul terminated
  * and %NULL is returned.
  */
-char *kernfs_path(struct kernfs_node *kn, char *buf, size_t buflen)
+char *kernfs_path_from_node(struct kernfs_node *kn_root, struct kernfs_node *kn,
+			    char *buf, size_t buflen)
 {
 	unsigned long flags;
 	char *p;
 
 	spin_lock_irqsave(&kernfs_rename_lock, flags);
-	p = kernfs_path_locked(kn, buf, buflen);
+	p = kernfs_path_from_node_locked(kn_root, kn, buf, buflen);
 	spin_unlock_irqrestore(&kernfs_rename_lock, flags);
 	return p;
 }
+EXPORT_SYMBOL_GPL(kernfs_path_from_node);
+
+/**
+ * kernfs_path - build full path of a given node
+ * @kn: kernfs_node of interest
+ * @buf: buffer to copy @kn's name into
+ * @buflen: size of @buf
+ *
+ * Builds and returns the full path of @kn in @buf of @buflen bytes.  The
+ * path is built from the end of @buf so the returned pointer usually
+ * doesn't match @buf.  If @buf isn't long enough, @buf is nul terminated
+ * and %NULL is returned.
+ */
+char *kernfs_path(struct kernfs_node *kn, char *buf, size_t buflen)
+{
+	return kernfs_path_from_node(NULL, kn, buf, buflen);
+}
 EXPORT_SYMBOL_GPL(kernfs_path);
 
 /**
@@ -145,8 +176,8 @@ void pr_cont_kernfs_path(struct kernfs_node *kn)
 
 	spin_lock_irqsave(&kernfs_rename_lock, flags);
 
-	p = kernfs_path_locked(kn, kernfs_pr_cont_buf,
-			       sizeof(kernfs_pr_cont_buf));
+	p = kernfs_path_from_node_locked(NULL, kn, kernfs_pr_cont_buf,
+					 sizeof(kernfs_pr_cont_buf));
 	if (p)
 		pr_cont("%s", p);
 	else
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 20f4935..1627341 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -257,6 +257,9 @@ static inline bool kernfs_ns_enabled(struct kernfs_node *kn)
 }
 
 int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen);
+char * __must_check kernfs_path_from_node(struct kernfs_node *root_kn,
+					  struct kernfs_node *kn, char *buf,
+					  size_t buflen);
 char * __must_check kernfs_path(struct kernfs_node *kn, char *buf,
 				size_t buflen);
 void pr_cont_kernfs_name(struct kernfs_node *kn);
-- 
2.0.0.526.g5318336

