Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbaGVWWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:22:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44331 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756999AbaGVWWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:22:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 004/116] NFS: Don't declare inode uptodate unless all attributes were checked
Date: Tue, 22 Jul 2014 15:20:15 -0700
Message-Id: <1406067727-19683-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 43b6535e717d2f656f71d9bd16022136b781c934 upstream.

Fix a bug, whereby nfs_update_inode() was declaring the inode to be
up to date despite not having checked all the attributes.
The bug occurs because the temporary variable in which we cache
the validity information is 'sanitised' before reapplying to
nfsi->cache_validity.

Reported-by: Kinglong Mee <kinglongmee@gmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfs/inode.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index ebeb94c..a5130f1 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1381,18 +1381,20 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			inode->i_version = fattr->change_attr;
 		}
 	} else if (server->caps & NFS_CAP_CHANGE_ATTR)
-		invalid |= save_cache_validity;
+		nfsi->cache_validity |= save_cache_validity;
 
 	if (fattr->valid & NFS_ATTR_FATTR_MTIME) {
 		memcpy(&inode->i_mtime, &fattr->mtime, sizeof(inode->i_mtime));
 	} else if (server->caps & NFS_CAP_MTIME)
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATTR
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATTR
 				| NFS_INO_REVAL_FORCED);
 
 	if (fattr->valid & NFS_ATTR_FATTR_CTIME) {
 		memcpy(&inode->i_ctime, &fattr->ctime, sizeof(inode->i_ctime));
 	} else if (server->caps & NFS_CAP_CTIME)
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATTR
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATTR
 				| NFS_INO_REVAL_FORCED);
 
 	/* Check if our cached file size is stale */
@@ -1415,7 +1417,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 					(long long)new_isize);
 		}
 	} else
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATTR
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATTR
 				| NFS_INO_REVAL_PAGECACHE
 				| NFS_INO_REVAL_FORCED);
 
@@ -1423,7 +1426,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 	if (fattr->valid & NFS_ATTR_FATTR_ATIME)
 		memcpy(&inode->i_atime, &fattr->atime, sizeof(inode->i_atime));
 	else if (server->caps & NFS_CAP_ATIME)
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATIME
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATIME
 				| NFS_INO_REVAL_FORCED);
 
 	if (fattr->valid & NFS_ATTR_FATTR_MODE) {
@@ -1434,7 +1438,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			invalid |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_ACCESS|NFS_INO_INVALID_ACL;
 		}
 	} else if (server->caps & NFS_CAP_MODE)
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATTR
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATTR
 				| NFS_INO_INVALID_ACCESS
 				| NFS_INO_INVALID_ACL
 				| NFS_INO_REVAL_FORCED);
@@ -1445,7 +1450,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			inode->i_uid = fattr->uid;
 		}
 	} else if (server->caps & NFS_CAP_OWNER)
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATTR
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATTR
 				| NFS_INO_INVALID_ACCESS
 				| NFS_INO_INVALID_ACL
 				| NFS_INO_REVAL_FORCED);
@@ -1456,7 +1462,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			inode->i_gid = fattr->gid;
 		}
 	} else if (server->caps & NFS_CAP_OWNER_GROUP)
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATTR
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATTR
 				| NFS_INO_INVALID_ACCESS
 				| NFS_INO_INVALID_ACL
 				| NFS_INO_REVAL_FORCED);
@@ -1469,7 +1476,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			set_nlink(inode, fattr->nlink);
 		}
 	} else if (server->caps & NFS_CAP_NLINK)
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATTR
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATTR
 				| NFS_INO_REVAL_FORCED);
 
 	if (fattr->valid & NFS_ATTR_FATTR_SPACE_USED) {
-- 
1.9.1

