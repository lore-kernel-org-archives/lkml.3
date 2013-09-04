Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934781Ab3IDOF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:05:59 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:56294 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934628Ab3IDOFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:05:53 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: rwheeler@redhat.com, avati@redhat.com, viro@ZenIV.linux.org.uk
Cc: bfoster@redhat.com, dhowells@redhat.com, eparis@redhat.com,
        raven@themaw.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mszeredi@suse.cz,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 06/10] nfs: use check_submounts_and_drop()
Date: Wed,  4 Sep 2013 16:05:52 +0200
Message-Id: <1378303556-7220-7-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378303556-7220-1-git-send-email-miklos@szeredi.hu>
References: <1378303556-7220-1-git-send-email-miklos@szeredi.hu>
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

