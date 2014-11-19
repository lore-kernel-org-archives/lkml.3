Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaKSOLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:11:55 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:58728 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaKSOLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:11:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] isofs: avoid unused function warning
Date: Wed, 19 Nov 2014 15:11:24 +0100
Message-ID: <1744765.FITJHBjs5L@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:RaZMrmf7fNBACi7L2Vs8BIb8Gqs3mxW7TWRQZhbUQz1
 POnughnRmnwwUn35s16AhAttPo57enNoqnDCokav0phTtskqYk
 ekKmqZ6VBA9Y+kIzzpMuw/1NyIcxf56U6g060O5FiuIgJUXEGa
 V2+xb0xzODKXUgSTYLoBavkDB+mZmSm1kLlEiSzZ6laWjRRwo/
 MAgNJtO6IpsJ1E+OecS19/QNd6PAVdgGquBSgfzGzkCgce6oT+
 xRa7iFEZN4QZT2BfQlp97MYsdcGu6Ffbp+OO+qiWuspjDe07xo
 HWRbMSjr5YmysxBIoczUXFjLYaXsjnzPyGmoZrho+7aTXf2RMj
 vUt5hVhzEzrnvVM7h/nQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the isofs_hash() function removed, isofs_hash_ms() is the only user
of isofs_hash_common(), but it's defined inside of an #ifdef, which triggers
this gcc warning in ARM axm55xx_defconfig starting with v3.18-rc3:

fs/isofs/inode.c:177:1: warning: 'isofs_hash_common' defined but not used [-Wunused-function]

This patch moves the function inside of the same #ifdef section to avoid that
warning, which seems the best compromise of a relatively harmless patch for
a late -rc.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: b0afd8e5db7b ("isofs: don't bother with ->d_op for normal case")
---

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index fe839b915116..d67a16f2a45d 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -174,27 +174,6 @@ struct iso9660_options{
  * Compute the hash for the isofs name corresponding to the dentry.
  */
 static int
-isofs_hash_common(struct qstr *qstr, int ms)
-{
-	const char *name;
-	int len;
-
-	len = qstr->len;
-	name = qstr->name;
-	if (ms) {
-		while (len && name[len-1] == '.')
-			len--;
-	}
-
-	qstr->hash = full_name_hash(name, len);
-
-	return 0;
-}
-
-/*
- * Compute the hash for the isofs name corresponding to the dentry.
- */
-static int
 isofs_hashi_common(struct qstr *qstr, int ms)
 {
 	const char *name;
@@ -263,6 +242,27 @@ isofs_dentry_cmpi(const struct dentry *parent, const struct dentry *dentry,
 }
 
 #ifdef CONFIG_JOLIET
+/*
+ * Compute the hash for the isofs name corresponding to the dentry.
+ */
+static int
+isofs_hash_common(struct qstr *qstr, int ms)
+{
+	const char *name;
+	int len;
+
+	len = qstr->len;
+	name = qstr->name;
+	if (ms) {
+		while (len && name[len-1] == '.')
+			len--;
+	}
+
+	qstr->hash = full_name_hash(name, len);
+
+	return 0;
+}
+
 static int
 isofs_hash_ms(const struct dentry *dentry, struct qstr *qstr)
 {
