Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbaG3MlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:41:15 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36645 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752765AbaG3MP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anand Avati <avati@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 19/94] fuse: ignore entry-timeout on LOOKUP_REVAL
Date: Wed, 30 Jul 2014 14:14:08 +0200
Message-Id: <21861467177cce2d160f15d2c386b5f2076988a9.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anand Avati <avati@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 154210ccb3a871e631bf39fdeb7a8731d98af87b upstream.

The following test case demonstrates the bug:

  sh# mount -t glusterfs localhost:meta-test /mnt/one

  sh# mount -t glusterfs localhost:meta-test /mnt/two

  sh# echo stuff > /mnt/one/file; rm -f /mnt/two/file; echo stuff > /mnt/one/file
  bash: /mnt/one/file: Stale file handle

  sh# echo stuff > /mnt/one/file; rm -f /mnt/two/file; sleep 1; echo stuff > /mnt/one/file

On the second open() on /mnt/one, FUSE would have used the old
nodeid (file handle) trying to re-open it. Gluster is returning
-ESTALE. The ESTALE propagates back to namei.c:filename_lookup()
where lookup is re-attempted with LOOKUP_REVAL. The right
behavior now, would be for FUSE to ignore the entry-timeout and
and do the up-call revalidation. Instead FUSE is ignoring
LOOKUP_REVAL, succeeding the revalidation (because entry-timeout
has not passed), and open() is again retried on the old file
handle and finally the ESTALE is going back to the application.

Fix: if revalidation is happening with LOOKUP_REVAL, then ignore
entry-timeout and always do the up-call.

Signed-off-by: Anand Avati <avati@redhat.com>
Reviewed-by: Niels de Vos <ndevos@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/fuse/dir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 0afbf93f5935..936d40400c56 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -188,7 +188,8 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 	inode = ACCESS_ONCE(entry->d_inode);
 	if (inode && is_bad_inode(inode))
 		goto invalid;
-	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64())) {
+	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64()) ||
+		 (flags & LOOKUP_REVAL)) {
 		int err;
 		struct fuse_entry_out outarg;
 		struct fuse_req *req;
-- 
2.0.1

