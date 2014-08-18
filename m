Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbaHRKJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:09:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42422 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaHRJdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:33:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anand Avati <avati@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 007/137] fuse: ignore entry-timeout on LOOKUP_REVAL
Date: Mon, 18 Aug 2014 10:31:08 +0100
Message-Id: <1408354398-10226-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anand Avati <avati@redhat.com>

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
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/fuse/dir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index ac00468b93d5..495d446b1911 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -186,7 +186,8 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 	inode = ACCESS_ONCE(entry->d_inode);
 	if (inode && is_bad_inode(inode))
 		return 0;
-	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64())) {
+	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64()) ||
+		 (flags & LOOKUP_REVAL)) {
 		int err;
 		struct fuse_entry_out outarg;
 		struct fuse_req *req;
-- 
1.9.1

