Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbaCEPeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:34:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40736 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234AbaCEOYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:24:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 011/131] NFS: Do not set NFS_INO_INVALID_LABEL unless server supports labeled NFS
Date: Wed,  5 Mar 2014 14:22:15 +0000
Message-Id: <1394029455-23128-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit fd1defc257e2b12ab69bc0b379105c00eca4e112 upstream.

Commit aa9c2669626c (NFS: Client implementation of Labeled-NFS) introduces
a performance regression. When nfs_zap_caches_locked is called, it sets
the NFS_INO_INVALID_LABEL flag irrespectively of whether or not the
NFS server supports security labels. Since that flag is never cleared,
it means that all calls to nfs_revalidate_inode() will now trigger
an on-the-wire GETATTR call.

This patch ensures that we never set the NFS_INO_INVALID_LABEL unless the
server advertises support for labeled NFS.
It also causes nfs_setsecurity() to clear NFS_INO_INVALID_LABEL when it
has successfully set the security label for the inode.
Finally it gets rid of the NFS_INO_INVALID_LABEL cruft from nfs_update_inode,
which has nothing to do with labeled NFS.

Reported-by: Neil Brown <neilb@suse.de>
Tested-by: Neil Brown <neilb@suse.de>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/inode.c    | 14 ++++++++++----
 fs/nfs/internal.h |  9 +++++++++
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 941246f..993581f 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -163,17 +163,16 @@ static void nfs_zap_caches_locked(struct inode *inode)
 	if (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)) {
 		nfs_fscache_invalidate(inode);
 		nfsi->cache_validity |= NFS_INO_INVALID_ATTR
-					| NFS_INO_INVALID_LABEL
 					| NFS_INO_INVALID_DATA
 					| NFS_INO_INVALID_ACCESS
 					| NFS_INO_INVALID_ACL
 					| NFS_INO_REVAL_PAGECACHE;
 	} else
 		nfsi->cache_validity |= NFS_INO_INVALID_ATTR
-					| NFS_INO_INVALID_LABEL
 					| NFS_INO_INVALID_ACCESS
 					| NFS_INO_INVALID_ACL
 					| NFS_INO_REVAL_PAGECACHE;
+	nfs_zap_label_cache_locked(nfsi);
 }
 
 void nfs_zap_caches(struct inode *inode)
@@ -265,6 +264,13 @@ nfs_init_locked(struct inode *inode, void *opaque)
 }
 
 #ifdef CONFIG_NFS_V4_SECURITY_LABEL
+static void nfs_clear_label_invalid(struct inode *inode)
+{
+	spin_lock(&inode->i_lock);
+	NFS_I(inode)->cache_validity &= ~NFS_INO_INVALID_LABEL;
+	spin_unlock(&inode->i_lock);
+}
+
 void nfs_setsecurity(struct inode *inode, struct nfs_fattr *fattr,
 					struct nfs4_label *label)
 {
@@ -288,6 +294,7 @@ void nfs_setsecurity(struct inode *inode, struct nfs_fattr *fattr,
 					__func__,
 					(char *)label->label,
 					label->len, error);
+		nfs_clear_label_invalid(inode);
 	}
 }
 
@@ -1579,7 +1586,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 		inode->i_blocks = fattr->du.nfs2.blocks;
 
 	/* Update attrtimeo value if we're out of the unstable period */
-	if (invalid & (NFS_INO_INVALID_ATTR|NFS_INO_INVALID_LABEL)) {
+	if (invalid & NFS_INO_INVALID_ATTR) {
 		nfs_inc_stats(inode, NFSIOS_ATTRINVALIDATE);
 		nfsi->attrtimeo = NFS_MINATTRTIMEO(inode);
 		nfsi->attrtimeo_timestamp = now;
@@ -1592,7 +1599,6 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 		}
 	}
 	invalid &= ~NFS_INO_INVALID_ATTR;
-	invalid &= ~NFS_INO_INVALID_LABEL;
 	/* Don't invalidate the data if we were to blame */
 	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)
 				|| S_ISLNK(inode->i_mode)))
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index f47305e..2365246 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -273,9 +273,18 @@ static inline void nfs4_label_free(struct nfs4_label *label)
 	}
 	return;
 }
+
+static inline void nfs_zap_label_cache_locked(struct nfs_inode *nfsi)
+{
+	if (nfs_server_capable(&nfsi->vfs_inode, NFS_CAP_SECURITY_LABEL))
+		nfsi->cache_validity |= NFS_INO_INVALID_LABEL;
+}
 #else
 static inline struct nfs4_label *nfs4_label_alloc(struct nfs_server *server, gfp_t flags) { return NULL; }
 static inline void nfs4_label_free(void *label) {}
+static inline void nfs_zap_label_cache_locked(struct nfs_inode *nfsi)
+{
+}
 #endif /* CONFIG_NFS_V4_SECURITY_LABEL */
 
 /* proc.c */
-- 
1.9.0

