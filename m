Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab3FMIR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 04:17:27 -0400
Received: from relay.parallels.com ([195.214.232.42]:60275 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab3FMIRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 04:17:25 -0400
Subject: [PATCH] fuse: hold i_mutex in fuse_file_fallocate() - v2
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, bfoster@redhat.com, avati@redhat.com,
        linux-kernel@vger.kernel.org, devel@openvz.org
Date: Thu, 13 Jun 2013 12:16:39 +0400
Message-ID: <20130613081551.11870.77028.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing size of a file on server and local update (fuse_write_update_size)
should be always protected by inode->i_mutex. Otherwise a race like this is
possible:

1. Process 'A' calls fallocate(2) to extend file (~FALLOC_FL_KEEP_SIZE).
fuse_file_fallocate() sends FUSE_FALLOCATE request to the server.
2. Process 'B' calls ftruncate(2) shrinking the file. fuse_do_setattr()
sends shrinking FUSE_SETATTR request to the server and updates local i_size
by i_size_write(inode, outarg.attr.size).
3. Process 'A' resumes execution of fuse_file_fallocate() and calls
fuse_write_update_size(inode, offset + length). But 'offset + length' was
obsoleted by ftruncate from previous step.

Changed in v2 (thanks Brian and Anand for suggestions):
 - made relation between mutex_lock() and fuse_set_nowrite(inode) more
   explicit and clear.
 - updated patch description to use ftruncate(2) in example

Signed-off-by: Maxim V. Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index e570081..35f2810 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2470,13 +2470,16 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 		.mode = mode
 	};
 	int err;
+	bool lock_inode = !(mode & FALLOC_FL_KEEP_SIZE) ||
+			   (mode & FALLOC_FL_PUNCH_HOLE);
 
 	if (fc->no_fallocate)
 		return -EOPNOTSUPP;
 
-	if (mode & FALLOC_FL_PUNCH_HOLE) {
+	if (lock_inode) {
 		mutex_lock(&inode->i_mutex);
-		fuse_set_nowrite(inode);
+		if (mode & FALLOC_FL_PUNCH_HOLE)
+			fuse_set_nowrite(inode);
 	}
 
 	req = fuse_get_req_nopages(fc);
@@ -2511,8 +2514,9 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 	fuse_invalidate_attr(inode);
 
 out:
-	if (mode & FALLOC_FL_PUNCH_HOLE) {
-		fuse_release_nowrite(inode);
+	if (lock_inode) {
+		if (mode & FALLOC_FL_PUNCH_HOLE)
+			fuse_release_nowrite(inode);
 		mutex_unlock(&inode->i_mutex);
 	}
 

