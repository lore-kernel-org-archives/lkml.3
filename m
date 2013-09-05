Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935649Ab3IEJpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:45:47 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:52237 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935609Ab3IEJo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:44:58 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz
Subject: [PATCH 08/11] sysfs: use check_submounts_and_drop()
Date: Thu,  5 Sep 2013 11:44:41 +0200
Message-Id: <1378374284-1484-9-git-send-email-miklos@szeredi.hu>
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
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/sysfs/dir.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index e068e74..fde8856 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -297,7 +297,6 @@ static int sysfs_dentry_delete(const struct dentry *dentry)
 static int sysfs_dentry_revalidate(struct dentry *dentry, unsigned int flags)
 {
 	struct sysfs_dirent *sd;
-	int is_dir;
 	int type;
 
 	if (flags & LOOKUP_RCU)
@@ -341,18 +340,15 @@ out_bad:
 	 * is performed at its new name the dentry will be readded
 	 * to the dcache hashes.
 	 */
-	is_dir = (sysfs_type(sd) == SYSFS_DIR);
 	mutex_unlock(&sysfs_mutex);
-	if (is_dir) {
-		/* If we have submounts we must allow the vfs caches
-		 * to lie about the state of the filesystem to prevent
-		 * leaks and other nasty things.
-		 */
-		if (have_submounts(dentry))
-			goto out_valid;
-		shrink_dcache_parent(dentry);
-	}
-	d_drop(dentry);
+
+	/* If we have submounts we must allow the vfs caches
+	 * to lie about the state of the filesystem to prevent
+	 * leaks and other nasty things.
+	 */
+	if (check_submounts_and_drop(dentry) != 0)
+		goto out_valid;
+
 	return 0;
 }
 
-- 
1.8.1.4

