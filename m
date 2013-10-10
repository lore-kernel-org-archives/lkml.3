Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab3JJNMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 09:12:05 -0400
Received: from relay.parallels.com ([195.214.232.42]:48350 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab3JJNMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 09:12:01 -0400
Subject: [PATCH 09/11] fuse: fuse_flush() should wait on writeback
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, fengguang.wu@intel.com, devel@openvz.org
Date: Thu, 10 Oct 2013 17:11:54 +0400
Message-ID: <20131010131148.10089.35819.stgit@dhcp-10-30-17-2.sw.ru>
In-Reply-To: <20131010130718.10089.6736.stgit@dhcp-10-30-17-2.sw.ru>
References: <20131010130718.10089.6736.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: StGit/0.16
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
 1 file changed, 9 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 642bd51..f23fc65 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -19,6 +19,7 @@
 #include <linux/falloc.h>
 
 static const struct file_operations fuse_direct_io_file_operations;
+static void fuse_sync_writes(struct inode *inode);
 
 static int fuse_send_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 			  int opcode, struct fuse_open_out *outargp)
@@ -399,6 +400,14 @@ static int fuse_flush(struct file *file, fl_owner_t id)
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

