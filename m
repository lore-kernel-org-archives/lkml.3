Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbaGZTmi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:42:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbaGZTNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anand Avati <avati@redhat.com>, Niels de Vos <ndevos@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [PATCH 3.15 013/109] fuse: ignore entry-timeout on LOOKUP_REVAL
Date: Sat, 26 Jul 2014 12:01:35 -0700
Message-Id: <20140726190224.229400902@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -198,7 +198,8 @@ static int fuse_dentry_revalidate(struct
 	inode = ACCESS_ONCE(entry->d_inode);
 	if (inode && is_bad_inode(inode))
 		goto invalid;
-	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64())) {
+	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64()) ||
+		 (flags & LOOKUP_REVAL)) {
 		int err;
 		struct fuse_entry_out outarg;
 		struct fuse_req *req;


