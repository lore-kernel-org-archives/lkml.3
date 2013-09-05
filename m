Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965113Ab3IEJpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:45:36 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:64557 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935603Ab3IEJoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:44:55 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, David Howells <dhowells@redhat.com>
Subject: [PATCH 05/11] afs: use check_submounts_and_drop()
Date: Thu,  5 Sep 2013 11:44:38 +0200
Message-Id: <1378374284-1484-6-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
References: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Do have_submounts(), shrink_dcache_parent() and d_drop() atomically.

check_submounts_and_drop() can deal with negative dentries as well.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: David Howells <dhowells@redhat.com>
---
 fs/afs/dir.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 34494fb..0b74d31 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -685,16 +685,12 @@ not_found:
 	spin_unlock(&dentry->d_lock);
 
 out_bad:
-	if (dentry->d_inode) {
-		/* don't unhash if we have submounts */
-		if (have_submounts(dentry))
-			goto out_skip;
-	}
+	/* don't unhash if we have submounts */
+	if (check_submounts_and_drop(dentry) != 0)
+		goto out_skip;
 
 	_debug("dropping dentry %s/%s",
 	       parent->d_name.name, dentry->d_name.name);
-	shrink_dcache_parent(dentry);
-	d_drop(dentry);
 	dput(parent);
 	key_put(key);
 
-- 
1.8.1.4

