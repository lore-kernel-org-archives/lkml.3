Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965171Ab3IEJpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:45:42 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:33556 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935606Ab3IEJo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:44:56 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/11] gfs2: use check_submounts_and_drop()
Date: Thu,  5 Sep 2013 11:44:39 +0200
Message-Id: <1378374284-1484-7-git-send-email-miklos@szeredi.hu>
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
CC: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/dentry.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/gfs2/dentry.c b/fs/gfs2/dentry.c
index f2448ab..d3a5d4e 100644
--- a/fs/gfs2/dentry.c
+++ b/fs/gfs2/dentry.c
@@ -93,12 +93,9 @@ invalid_gunlock:
 	if (!had_lock)
 		gfs2_glock_dq_uninit(&d_gh);
 invalid:
-	if (inode && S_ISDIR(inode->i_mode)) {
-		if (have_submounts(dentry))
-			goto valid;
-		shrink_dcache_parent(dentry);
-	}
-	d_drop(dentry);
+	if (check_submounts_and_drop(dentry) != 0)
+		goto valid;
+
 	dput(parent);
 	return 0;
 
-- 
1.8.1.4

