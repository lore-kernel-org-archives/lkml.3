Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab3FKLAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:00:04 -0400
Received: from relay.parallels.com ([195.214.232.42]:54842 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab3FKLAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:00:01 -0400
Subject: [PATCH] fuse: hold i_mutex in fuse_file_fallocate()
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, bfoster@redhat.com, avati@redhat.com,
        linux-kernel@vger.kernel.org, devel@openvz.org
Date: Tue, 11 Jun 2013 14:59:24 +0400
Message-ID: <20130611105714.24455.38409.stgit@maximpc.sw.ru>
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
2. Process 'B' performs ordinary buffered write(2) with a length big enough
to extend the file beyond "offset + length" of fallocate call.
3. Process 'A' resumes execution of fuse_file_fallocate() and calls
fuse_write_update_size(inode, offset + length). But 'offset + length' was
obsoleted by write from previous step.

Signed-off-by: Maxim V. Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index e570081..8dfbf7d 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2470,14 +2470,16 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 		.mode = mode
 	};
 	int err;
+	bool lock_inode = !(mode & FALLOC_FL_KEEP_SIZE) ||
+			   (mode & FALLOC_FL_PUNCH_HOLE);
 
 	if (fc->no_fallocate)
 		return -EOPNOTSUPP;
 
-	if (mode & FALLOC_FL_PUNCH_HOLE) {
+	if (lock_inode)
 		mutex_lock(&inode->i_mutex);
+	if (mode & FALLOC_FL_PUNCH_HOLE)
 		fuse_set_nowrite(inode);
-	}
 
 	req = fuse_get_req_nopages(fc);
 	if (IS_ERR(req)) {
@@ -2511,10 +2513,10 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 	fuse_invalidate_attr(inode);
 
 out:
-	if (mode & FALLOC_FL_PUNCH_HOLE) {
+	if (mode & FALLOC_FL_PUNCH_HOLE)
 		fuse_release_nowrite(inode);
+	if (lock_inode)
 		mutex_unlock(&inode->i_mutex);
-	}
 
 	return err;
 }

