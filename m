Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196AbaDBUO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:14:58 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42883 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758943AbaDBUNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 05/40] nfs: use IS_ROOT not DCACHE_DISCONNECTED
Date: Wed,  2 Apr 2014 22:12:51 +0200
Message-Id: <5ad410c5e34aad12e2523f25b32314791b823631.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a3f432bfd06a4ec3b812e32d3266e0d1ad75d008 upstream.

This check was added by Al Viro with
d9e80b7de91db05c1c4d2e5ebbfd70b3b3ba0e0f "nfs d_revalidate() is too
trigger-happy with d_drop()", with the explanation that we don't want to
remove the root of a disconnected tree, which will still be included on
the s_anon list.

But DCACHE_DISCONNECTED does *not* actually identify dentries that are
disconnected from the dentry tree or hashed on s_anon.  IS_ROOT() is the
way to do that.

Also add a comment from Al's commit to remind us why this check is
there.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfs/dir.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index e81a1cae81b5..d0325d7db643 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1139,7 +1139,13 @@ out_zap_parent:
 	if (inode && S_ISDIR(inode->i_mode)) {
 		/* Purge readdir caches. */
 		nfs_zap_caches(inode);
-		if (dentry->d_flags & DCACHE_DISCONNECTED)
+		/*
+		 * We can't d_drop the root of a disconnected tree:
+		 * its d_hash is on the s_anon list and d_drop() would hide
+		 * it from shrink_dcache_for_unmount(), leading to busy
+		 * inodes on unmount and further oopses.
+		 */
+		if (IS_ROOT(dentry))
 			goto out_valid;
 	}
 	/* If we have submounts, don't unhash ! */
-- 
1.9.1

