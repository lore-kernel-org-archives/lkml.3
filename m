Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335AbaGCKY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:24:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51346 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280AbaGCJUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:20:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 001/198] NFS: Don't declare inode uptodate unless all attributes were checked
Date: Thu,  3 Jul 2014 10:17:24 +0100
Message-Id: <1404379241-8590-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/inode.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 993581f51799..9af113f2b23b 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1485,18 +1485,20 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
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
@@ -1519,7 +1521,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 					(long long)new_isize);
 		}
 	} else
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATTR
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATTR
 				| NFS_INO_REVAL_PAGECACHE
 				| NFS_INO_REVAL_FORCED);
 
@@ -1527,7 +1530,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 	if (fattr->valid & NFS_ATTR_FATTR_ATIME)
 		memcpy(&inode->i_atime, &fattr->atime, sizeof(inode->i_atime));
 	else if (server->caps & NFS_CAP_ATIME)
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATIME
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATIME
 				| NFS_INO_REVAL_FORCED);
 
 	if (fattr->valid & NFS_ATTR_FATTR_MODE) {
@@ -1538,7 +1542,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			invalid |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_ACCESS|NFS_INO_INVALID_ACL;
 		}
 	} else if (server->caps & NFS_CAP_MODE)
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATTR
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATTR
 				| NFS_INO_INVALID_ACCESS
 				| NFS_INO_INVALID_ACL
 				| NFS_INO_REVAL_FORCED);
@@ -1549,7 +1554,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			inode->i_uid = fattr->uid;
 		}
 	} else if (server->caps & NFS_CAP_OWNER)
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATTR
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATTR
 				| NFS_INO_INVALID_ACCESS
 				| NFS_INO_INVALID_ACL
 				| NFS_INO_REVAL_FORCED);
@@ -1560,7 +1566,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			inode->i_gid = fattr->gid;
 		}
 	} else if (server->caps & NFS_CAP_OWNER_GROUP)
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATTR
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATTR
 				| NFS_INO_INVALID_ACCESS
 				| NFS_INO_INVALID_ACL
 				| NFS_INO_REVAL_FORCED);
@@ -1573,7 +1580,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
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

