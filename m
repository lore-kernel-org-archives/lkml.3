Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031811AbaGDXDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 19:03:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760501AbaGDWQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:16:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kinglong Mee <kinglongmee@gmail.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.15 37/66] NFS: Dont declare inode uptodate unless all attributes were checked
Date: Fri,  4 Jul 2014 15:14:36 -0700
Message-Id: <20140704221424.504624219@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/inode.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1575,18 +1575,20 @@ static int nfs_update_inode(struct inode
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
@@ -1608,7 +1610,8 @@ static int nfs_update_inode(struct inode
 					(long long)new_isize);
 		}
 	} else
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATTR
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATTR
 				| NFS_INO_REVAL_PAGECACHE
 				| NFS_INO_REVAL_FORCED);
 
@@ -1616,7 +1619,8 @@ static int nfs_update_inode(struct inode
 	if (fattr->valid & NFS_ATTR_FATTR_ATIME)
 		memcpy(&inode->i_atime, &fattr->atime, sizeof(inode->i_atime));
 	else if (server->caps & NFS_CAP_ATIME)
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATIME
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATIME
 				| NFS_INO_REVAL_FORCED);
 
 	if (fattr->valid & NFS_ATTR_FATTR_MODE) {
@@ -1627,7 +1631,8 @@ static int nfs_update_inode(struct inode
 			invalid |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_ACCESS|NFS_INO_INVALID_ACL;
 		}
 	} else if (server->caps & NFS_CAP_MODE)
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATTR
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATTR
 				| NFS_INO_INVALID_ACCESS
 				| NFS_INO_INVALID_ACL
 				| NFS_INO_REVAL_FORCED);
@@ -1638,7 +1643,8 @@ static int nfs_update_inode(struct inode
 			inode->i_uid = fattr->uid;
 		}
 	} else if (server->caps & NFS_CAP_OWNER)
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATTR
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATTR
 				| NFS_INO_INVALID_ACCESS
 				| NFS_INO_INVALID_ACL
 				| NFS_INO_REVAL_FORCED);
@@ -1649,7 +1655,8 @@ static int nfs_update_inode(struct inode
 			inode->i_gid = fattr->gid;
 		}
 	} else if (server->caps & NFS_CAP_OWNER_GROUP)
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATTR
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATTR
 				| NFS_INO_INVALID_ACCESS
 				| NFS_INO_INVALID_ACL
 				| NFS_INO_REVAL_FORCED);
@@ -1662,7 +1669,8 @@ static int nfs_update_inode(struct inode
 			set_nlink(inode, fattr->nlink);
 		}
 	} else if (server->caps & NFS_CAP_NLINK)
-		invalid |= save_cache_validity & (NFS_INO_INVALID_ATTR
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_ATTR
 				| NFS_INO_REVAL_FORCED);
 
 	if (fattr->valid & NFS_ATTR_FATTR_SPACE_USED) {


