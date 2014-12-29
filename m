Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbaL2Oub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 09:50:31 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30952 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaL2OuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 09:50:10 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-46-54a16a1f00af
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-mm@kvack.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/4] kernfs: use kstrdup_const for node name allocation
Date: Mon, 29 Dec 2014 15:48:28 +0100
Message-id: <1419864510-24834-3-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1419864510-24834-1-git-send-email-a.hajda@samsung.com>
References: <1419864510-24834-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJMWRmVeSWpSXmKPExsVy+t/xq7ryWQtDDHq3CljcWneO1eLyrjls
	FvfW/Ge1WHvkLrsDi8emT5PYPfq2rGL0+LxJLoA5issmJTUnsyy1SN8ugSvj79YrbAVP+Svu
	9Mxga2C8x9PFyMkhIWAicf/vXUYIW0ziwr31bF2MXBxCAksZJX7/+ckM4fQxSfTcPwdWxSag
	KfF38002EFsEqOPjmctARRwczAIlErfOioGEhQW8JaY3zGIFsVkEVCWaOi+wg9i8As4Sez93
	sUEsk5M4eWwyK0grp4CLxN+uOJCwEFDJzyVT2Ccw8i5gZFjFKJpamlxQnJSea6hXnJhbXJqX
	rpecn7uJERIgX3YwLj5mdYhRgINRiYc34cSCECHWxLLiytxDjBIczEoivNKWC0OEeFMSK6tS
	i/Lji0pzUosPMTJxcEo1MCodSpjtPOGdiN2yID3L3meCPB3Lc7Jmuc6vZl5/2M7rruv9HG0H
	31S5yh9XZ9++mLc19oLh9i9LAlc3XCwMbdsRsVzg5J9HOS/+s8p4qjHW8wftavPNlJ22TKx3
	QccyNTtV/vU1p1f81ArfVWZkXPl7vv/azA0zlwWzn7E+1Ntpuzh0J7fMLiWW4oxEQy3mouJE
	AFN02uXuAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs frequently performs duplication of strings located
in read-only memory section. Replacing kstrdup by kstrdup_const
allows to avoid such operations.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 fs/kernfs/dir.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 37989f0..259e92a 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -408,7 +408,7 @@ void kernfs_put(struct kernfs_node *kn)
 	if (kernfs_type(kn) == KERNFS_LINK)
 		kernfs_put(kn->symlink.target_kn);
 	if (!(kn->flags & KERNFS_STATIC_NAME))
-		kfree(kn->name);
+		kfree_const(kn->name);
 	if (kn->iattr) {
 		if (kn->iattr->ia_secdata)
 			security_release_secctx(kn->iattr->ia_secdata,
@@ -502,12 +502,12 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 					     const char *name, umode_t mode,
 					     unsigned flags)
 {
-	char *dup_name = NULL;
+	const char *dup_name = NULL;
 	struct kernfs_node *kn;
 	int ret;
 
 	if (!(flags & KERNFS_STATIC_NAME)) {
-		name = dup_name = kstrdup(name, GFP_KERNEL);
+		name = dup_name = kstrdup_const(name, GFP_KERNEL);
 		if (!name)
 			return NULL;
 	}
@@ -534,7 +534,7 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
  err_out2:
 	kmem_cache_free(kernfs_node_cache, kn);
  err_out1:
-	kfree(dup_name);
+	kfree_const(dup_name);
 	return NULL;
 }
 
@@ -1260,7 +1260,7 @@ int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 	/* rename kernfs_node */
 	if (strcmp(kn->name, new_name) != 0) {
 		error = -ENOMEM;
-		new_name = kstrdup(new_name, GFP_KERNEL);
+		new_name = kstrdup_const(new_name, GFP_KERNEL);
 		if (!new_name)
 			goto out;
 	} else {
@@ -1293,7 +1293,7 @@ int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 	kernfs_link_sibling(kn);
 
 	kernfs_put(old_parent);
-	kfree(old_name);
+	kfree_const(old_name);
 
 	error = 0;
  out:
-- 
1.9.1

