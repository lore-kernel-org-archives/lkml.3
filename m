Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbaDOL3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:29:35 -0400
Received: from relay.parallels.com ([195.214.232.42]:54619 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaDOL3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:29:34 -0400
Subject: [PATCH 3/7] fuse: update mtime on open(O_TRUNC) in atomic_o_trunc
 mode
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Date: Tue, 15 Apr 2014 15:29:33 +0400
Message-ID: <20140415112857.11860.18769.stgit@dhcp-10-30-30-94.sw.ru>
In-Reply-To: <20140415112413.11860.1451.stgit@dhcp-10-30-30-94.sw.ru>
References: <20140415112413.11860.1451.stgit@dhcp-10-30-30-94.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of fc->atomic_o_trunc is set, fuse does nothing in fuse_do_setattr()
while handling open(O_TRUNC). Hence, i_mtime must be updated explicitly in
fuse_finish_open(). The patch also adds extra locking encompassing
open(O_TRUNC) operation to avoid races between updating i_mtime and setting
FUSE_I_MTIME_DIRTY flag.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 13f8bde..c2c6df7 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -223,6 +223,10 @@ void fuse_finish_open(struct inode *inode, struct file *file)
 		i_size_write(inode, 0);
 		spin_unlock(&fc->lock);
 		fuse_invalidate_attr(inode);
+		if (fc->writeback_cache) {
+			inode->i_mtime = current_fs_time(inode->i_sb);
+			set_bit(FUSE_I_MTIME_DIRTY, &fi->state);
+		}
 	}
 	if ((file->f_mode & FMODE_WRITE) && fc->writeback_cache)
 		fuse_link_write_file(file);
@@ -232,18 +236,26 @@ int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	int err;
+	bool lock_inode = (file->f_flags & O_TRUNC) &&
+			  fc->atomic_o_trunc &&
+			  fc->writeback_cache;
 
 	err = generic_file_open(inode, file);
 	if (err)
 		return err;
 
+	if (lock_inode)
+		mutex_lock(&inode->i_mutex);
+
 	err = fuse_do_open(fc, get_node_id(inode), file, isdir);
-	if (err)
-		return err;
 
-	fuse_finish_open(inode, file);
+	if (!err)
+		fuse_finish_open(inode, file);
 
-	return 0;
+	if (lock_inode)
+		mutex_unlock(&inode->i_mutex);
+
+	return err;
 }
 
 static void fuse_prepare_release(struct fuse_file *ff, int flags, int opcode)

