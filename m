Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbaIXOxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:53:38 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.95]:49040 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbaIXOxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:53:35 -0400
From: Christoph Jaeger <cj@linux.com>
To: petr@vandrovec.name, akpm@linux-foundation.org, joe@perches.com
Cc: linux-kernel@vger.kernel.org, Christoph Jaeger <cj@linux.com>
Subject: [PATCH RESEND] ncpfs: use list_for_each_entry() for list iteration
Date: Wed, 24 Sep 2014 10:53:24 -0400
Message-Id: <1411570404-13428-1-git-send-email-cj@linux.com>
X-Mailer: git-send-email 1.9.3
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use list_for_each_entry() for the sake of simplicity and readability.

Signed-off-by: Christoph Jaeger <cj@linux.com>
---
 fs/ncpfs/dir.c           |  6 +-----
 fs/ncpfs/ncplib_kernel.h | 14 ++------------
 2 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index 08b8ea8..314e7ad 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -388,7 +388,6 @@ static struct dentry *
 ncp_dget_fpos(struct dentry *dentry, struct dentry *parent, unsigned long fpos)
 {
 	struct dentry *dent = dentry;
-	struct list_head *next;
 
 	if (d_validate(dent, parent)) {
 		if (dent->d_name.len <= NCP_MAXPATHLEN &&
@@ -404,9 +403,7 @@ ncp_dget_fpos(struct dentry *dentry, struct dentry *parent, unsigned long fpos)
 
 	/* If a pointer is invalid, we search the dentry. */
 	spin_lock(&parent->d_lock);
-	next = parent->d_subdirs.next;
-	while (next != &parent->d_subdirs) {
-		dent = list_entry(next, struct dentry, d_u.d_child);
+	list_for_each_entry(dent, &parent->d_subdirs, d_u.d_child) {
 		if ((unsigned long)dent->d_fsdata == fpos) {
 			if (dent->d_inode)
 				dget(dent);
@@ -415,7 +412,6 @@ ncp_dget_fpos(struct dentry *dentry, struct dentry *parent, unsigned long fpos)
 			spin_unlock(&parent->d_lock);
 			goto out;
 		}
-		next = next->next;
 	}
 	spin_unlock(&parent->d_lock);
 	return NULL;
diff --git a/fs/ncpfs/ncplib_kernel.h b/fs/ncpfs/ncplib_kernel.h
index 32c0658..52cb19d 100644
--- a/fs/ncpfs/ncplib_kernel.h
+++ b/fs/ncpfs/ncplib_kernel.h
@@ -188,20 +188,14 @@ static inline void
 ncp_renew_dentries(struct dentry *parent)
 {
 	struct ncp_server *server = NCP_SERVER(parent->d_inode);
-	struct list_head *next;
 	struct dentry *dentry;
 
 	spin_lock(&parent->d_lock);
-	next = parent->d_subdirs.next;
-	while (next != &parent->d_subdirs) {
-		dentry = list_entry(next, struct dentry, d_u.d_child);
-
+	list_for_each_entry(dentry, &parent->d_subdirs, d_u.d_child) {
 		if (dentry->d_fsdata == NULL)
 			ncp_age_dentry(server, dentry);
 		else
 			ncp_new_dentry(dentry);
-
-		next = next->next;
 	}
 	spin_unlock(&parent->d_lock);
 }
@@ -210,16 +204,12 @@ static inline void
 ncp_invalidate_dircache_entries(struct dentry *parent)
 {
 	struct ncp_server *server = NCP_SERVER(parent->d_inode);
-	struct list_head *next;
 	struct dentry *dentry;
 
 	spin_lock(&parent->d_lock);
-	next = parent->d_subdirs.next;
-	while (next != &parent->d_subdirs) {
-		dentry = list_entry(next, struct dentry, d_u.d_child);
+	list_for_each_entry(dentry, &parent->d_subdirs, d_u.d_child) {
 		dentry->d_fsdata = NULL;
 		ncp_age_dentry(server, dentry);
-		next = next->next;
 	}
 	spin_unlock(&parent->d_lock);
 }
-- 
1.9.3

