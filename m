Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbaCDVgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:36:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662AbaCDUCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:02:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Neil Brown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.13 034/172] NFS: Do not set NFS_INO_INVALID_LABEL unless server supports labeled NFS
Date: Tue,  4 Mar 2014 12:01:58 -0800
Message-Id: <20140304200300.815492443@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/inode.c    |   14 ++++++++++----
 fs/nfs/internal.h |    9 +++++++++
 2 files changed, 19 insertions(+), 4 deletions(-)

--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -164,17 +164,16 @@ static void nfs_zap_caches_locked(struct
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
@@ -266,6 +265,13 @@ nfs_init_locked(struct inode *inode, voi
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
@@ -283,6 +289,7 @@ void nfs_setsecurity(struct inode *inode
 					__func__,
 					(char *)label->label,
 					label->len, error);
+		nfs_clear_label_invalid(inode);
 	}
 }
 
@@ -1597,7 +1604,7 @@ static int nfs_update_inode(struct inode
 		inode->i_blocks = fattr->du.nfs2.blocks;
 
 	/* Update attrtimeo value if we're out of the unstable period */
-	if (invalid & (NFS_INO_INVALID_ATTR|NFS_INO_INVALID_LABEL)) {
+	if (invalid & NFS_INO_INVALID_ATTR) {
 		nfs_inc_stats(inode, NFSIOS_ATTRINVALIDATE);
 		nfsi->attrtimeo = NFS_MINATTRTIMEO(inode);
 		nfsi->attrtimeo_timestamp = now;
@@ -1610,7 +1617,6 @@ static int nfs_update_inode(struct inode
 		}
 	}
 	invalid &= ~NFS_INO_INVALID_ATTR;
-	invalid &= ~NFS_INO_INVALID_LABEL;
 	/* Don't invalidate the data if we were to blame */
 	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)
 				|| S_ISLNK(inode->i_mode)))
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -279,9 +279,18 @@ static inline void nfs4_label_free(struc
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


