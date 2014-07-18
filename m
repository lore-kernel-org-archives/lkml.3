Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161127AbaGRNPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:15:38 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17824 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934054AbaGRNPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:15:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 036/170] NFS: Don't declare inode uptodate unless all attributes were checked
Date: Fri, 18 Jul 2014 14:10:41 +0200
Message-Id: <9b8a9bf75003800ba4143b8b6c53bb41e57d00f9.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <trond.myklebust@primarydata.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 43b6535e717d2f656f71d9bd16022136b781c934 upstream.

Fix a bug, whereby nfs_update_inode() was declaring the inode to be
up to date despite not having checked all the attributes.
The bug occurs because the temporary variable in which we cache
the validity information is 'sanitised' before reapplying to
nfsi->cache_validity.

Reported-by: Kinglong Mee <kinglongmee@gmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfs/inode.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index fdeeb28f287b..7f5799d098fd 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1540,18 +1540,20 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
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
@@ -1574,7 +1576,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 					(long long)new_isize);
 		}
 	} else
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATTR
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATTR
 				| NFS_INO_REVAL_PAGECACHE
 				| NFS_INO_REVAL_FORCED);
 
@@ -1582,7 +1585,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 	if (fattr->valid & NFS_ATTR_FATTR_ATIME)
 		memcpy(&inode->i_atime, &fattr->atime, sizeof(inode->i_atime));
 	else if (server->caps & NFS_CAP_ATIME)
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATIME
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATIME
 				| NFS_INO_REVAL_FORCED);
 
 	if (fattr->valid & NFS_ATTR_FATTR_MODE) {
@@ -1593,7 +1597,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			invalid |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_ACCESS|NFS_INO_INVALID_ACL;
 		}
 	} else if (server->caps & NFS_CAP_MODE)
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATTR
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATTR
 				| NFS_INO_INVALID_ACCESS
 				| NFS_INO_INVALID_ACL
 				| NFS_INO_REVAL_FORCED);
@@ -1604,7 +1609,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			inode->i_uid = fattr->uid;
 		}
 	} else if (server->caps & NFS_CAP_OWNER)
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATTR
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATTR
 				| NFS_INO_INVALID_ACCESS
 				| NFS_INO_INVALID_ACL
 				| NFS_INO_REVAL_FORCED);
@@ -1615,7 +1621,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			inode->i_gid = fattr->gid;
 		}
 	} else if (server->caps & NFS_CAP_OWNER_GROUP)
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATTR
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATTR
 				| NFS_INO_INVALID_ACCESS
 				| NFS_INO_INVALID_ACL
 				| NFS_INO_REVAL_FORCED);
@@ -1628,7 +1635,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			set_nlink(inode, fattr->nlink);
 		}
 	} else if (server->caps & NFS_CAP_NLINK)
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATTR
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATTR
 				| NFS_INO_REVAL_FORCED);
 
 	if (fattr->valid & NFS_ATTR_FATTR_SPACE_USED) {
-- 
2.0.0

