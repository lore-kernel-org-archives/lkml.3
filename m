Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612AbaHHVGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:06:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41300 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933043AbaHHUxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:53:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anand Avati <avati@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 119/259] fuse: ignore entry-timeout on LOOKUP_REVAL
Date: Fri,  8 Aug 2014 13:39:02 -0700
Message-Id: <1407530482-4483-120-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/fuse/dir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index ba60cfd..989dabd 100644
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
1.9.1

