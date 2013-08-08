Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965952Ab3HHP0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 11:26:40 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:52154 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965891Ab3HHPZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 11:25:07 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: rwheeler@redhat.com, avati@redhat.com, viro@ZenIV.linux.org.uk
Cc: bfoster@redhat.com, dhowells@redhat.com, eparis@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 5/9] nfs: use check_submounts_and_drop()
Date: Thu,  8 Aug 2013 17:24:46 +0200
Message-Id: <1375975490-18673-6-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375975490-18673-1-git-send-email-miklos@szeredi.hu>
References: <1375975490-18673-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Do have_submounts(), shrink_dcache_parent() and d_drop() atomically.

check_submounts_and_drop() can deal with negative dentries and
non-directories as well.

Non-directories can also be mounted on.  And just like directories we don't
want these to disappear with invalidation.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 fs/nfs/dir.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index e474ca2b..7468735 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1135,14 +1135,13 @@ out_zap_parent:
 	if (inode && S_ISDIR(inode->i_mode)) {
 		/* Purge readdir caches. */
 		nfs_zap_caches(inode);
-		/* If we have submounts, don't unhash ! */
-		if (have_submounts(dentry))
-			goto out_valid;
 		if (dentry->d_flags & DCACHE_DISCONNECTED)
 			goto out_valid;
-		shrink_dcache_parent(dentry);
 	}
-	d_drop(dentry);
+	/* If we have submounts, don't unhash ! */
+	if (check_submounts_and_drop(dentry) != 0)
+		goto out_valid;
+
 	dput(parent);
 	dfprintk(LOOKUPCACHE, "NFS: %s(%s/%s) is invalid\n",
 			__func__, dentry->d_parent->d_name.name,
-- 
1.8.1.4

