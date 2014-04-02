Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268AbaDBUZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:25:55 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42824 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758888AbaDBUN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 19/40] nfs: add memory barriers around NFS_INO_INVALID_DATA and NFS_INO_INVALIDATING
Date: Wed,  2 Apr 2014 22:13:05 +0200
Message-Id: <2d0270ca61c101531d9663fcb1d1b93d0cc9a05b.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4db72b40fdbc706f8957e9773ae73b1574b8c694 upstream.

If the setting of NFS_INO_INVALIDATING gets reordered to before the
clearing of NFS_INO_INVALID_DATA, then another task may hit a race
window where both appear to be clear, even though the inode's pages are
still in need of invalidation. Fix this by adding the appropriate memory
barriers.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfs/dir.c   | 14 +++++++++++---
 fs/nfs/inode.c |  1 +
 fs/nfs/write.c |  1 +
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 4d9f098614bc..140280623348 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -276,6 +276,15 @@ out_eof:
 	return -EBADCOOKIE;
 }
 
+static bool
+nfs_readdir_inode_mapping_valid(struct nfs_inode *nfsi)
+{
+	if (nfsi->cache_validity & (NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA))
+		return false;
+	smp_rmb();
+	return !test_bit(NFS_INO_INVALIDATING, &nfsi->flags);
+}
+
 static
 int nfs_readdir_search_for_cookie(struct nfs_cache_array *array, nfs_readdir_descriptor_t *desc)
 {
@@ -289,9 +298,8 @@ int nfs_readdir_search_for_cookie(struct nfs_cache_array *array, nfs_readdir_des
 			struct nfs_open_dir_context *ctx = desc->file->private_data;
 
 			new_pos = desc->current_index + i;
-			if (ctx->attr_gencount != nfsi->attr_gencount
-			    || (nfsi->cache_validity & (NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA))
-			    || test_bit(NFS_INO_INVALIDATING, &nfsi->flags)) {
+			if (ctx->attr_gencount != nfsi->attr_gencount ||
+			    !nfs_readdir_inode_mapping_valid(nfsi)) {
 				ctx->duped = 0;
 				ctx->attr_gencount = nfsi->attr_gencount;
 			} else if (new_pos < desc->ctx->pos) {
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 12c0fa8ae004..fdeeb28f287b 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1060,6 +1060,7 @@ int nfs_revalidate_mapping(struct inode *inode, struct address_space *mapping)
 	}
 
 	set_bit(NFS_INO_INVALIDATING, bitlock);
+	smp_wmb();
 	nfsi->cache_validity &= ~NFS_INO_INVALID_DATA;
 	spin_unlock(&inode->i_lock);
 	trace_nfs_invalidate_mapping_enter(inode);
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index d69e789f1908..c6aa89f92558 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -915,6 +915,7 @@ static bool nfs_write_pageuptodate(struct page *page, struct inode *inode)
 		goto out;
 	if (nfsi->cache_validity & (NFS_INO_INVALID_DATA|NFS_INO_REVAL_PAGECACHE))
 		return false;
+	smp_rmb();
 	if (test_bit(NFS_INO_INVALIDATING, &nfsi->flags))
 		return false;
 out:
-- 
1.9.1

