Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934802Ab3IDOGC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:06:02 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:57132 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934707Ab3IDOFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:05:54 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: rwheeler@redhat.com, avati@redhat.com, viro@ZenIV.linux.org.uk
Cc: bfoster@redhat.com, dhowells@redhat.com, eparis@redhat.com,
        raven@themaw.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mszeredi@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 07/10] sysfs: use check_submounts_and_drop()
Date: Wed,  4 Sep 2013 16:05:53 +0200
Message-Id: <1378303556-7220-8-git-send-email-miklos@szeredi.hu>
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
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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

