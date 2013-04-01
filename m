Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506Ab3DAKlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 06:41:55 -0400
Received: from relay.parallels.com ([195.214.232.42]:54977 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759276Ab3DAKlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 06:41:52 -0400
Subject: [PATCH 11/14] fuse: fuse_flush() should wait on writeback
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        devel@openvz.org
Date: Mon, 01 Apr 2013 14:42:27 +0400
Message-ID: <20130401104223.19027.61392.stgit@maximpc.sw.ru>
In-Reply-To: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
References: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The aim of .flush fop is to hint file-system that flushing its state or caches
or any other important data to reliable storage would be desirable now.
fuse_flush() passes this hint by sending FUSE_FLUSH request to userspace.
However, dirty pages and pages under writeback may be not visible to userspace
yet if we won't ensure it explicitly.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 2409654..7c24f6b 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -18,6 +18,7 @@
 #include <linux/falloc.h>
 
 static const struct file_operations fuse_direct_io_file_operations;
+static void fuse_sync_writes(struct inode *inode);
 
 static int fuse_send_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 			  int opcode, struct fuse_open_out *outargp)
@@ -396,6 +397,14 @@ static int fuse_flush(struct file *file, fl_owner_t id)
 	if (fc->no_flush)
 		return 0;
 
+	err = filemap_write_and_wait(file->f_mapping);
+	if (err)
+		return err;
+
+	mutex_lock(&inode->i_mutex);
+	fuse_sync_writes(inode);
+	mutex_unlock(&inode->i_mutex);
+
 	req = fuse_get_req_nofail_nopages(fc, file);
 	memset(&inarg, 0, sizeof(inarg));
 	inarg.fh = ff->fh;

