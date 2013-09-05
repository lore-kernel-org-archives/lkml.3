Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935632Ab3IEJpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:45:44 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:38477 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935608Ab3IEJo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:44:57 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 07/11] nfs: use check_submounts_and_drop()
Date: Thu,  5 Sep 2013 11:44:40 +0200
Message-Id: <1378374284-1484-8-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
References: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
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

