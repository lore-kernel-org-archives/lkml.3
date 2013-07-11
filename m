Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab3GKQSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:18:50 -0400
Received: from relay.parallels.com ([195.214.232.42]:40502 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735Ab3GKQSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:18:49 -0400
Subject: [PATCH 08/16] fuse: Flush files on wb close -v2
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, miklos@szeredi.hu, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, devel@openvz.org
Date: Thu, 11 Jul 2013 20:18:42 +0400
Message-ID: <20130711161617.29434.51569.stgit@maximpc.sw.ru>
In-Reply-To: <20130629174458.20175.11065.stgit@maximpc.sw.ru>
References: <20130629174458.20175.11065.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Emelyanov <xemul@openvz.org>

Any write request requires a file handle to report to the userspace. Thus
when we close a file (and free the fuse_file with this info) we have to
flush all the outstanding dirty pages.

filemap_write_and_wait() is enough because every page under fuse writeback
is accounted in ff->count. This delays actual close until all fuse wb is
completed.

In case of "write cache" turned off, the flush is ensured by fuse_vma_close().

Changed in v2:
 - updated patch to be applied smoothly on top of
   "Trust kernel i_mtime only -v2".

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 09a9eeb..3778de1 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -291,6 +291,12 @@ static int fuse_open(struct inode *inode, struct file *file)
 
 static int fuse_release(struct inode *inode, struct file *file)
 {
+	struct fuse_conn *fc = get_fuse_conn(inode);
+
+	/* see fuse_vma_close() for !writeback_cache case */
+	if (fc->writeback_cache)
+		filemap_write_and_wait(file->f_mapping);
+
 	if (test_bit(FUSE_I_MTIME_DIRTY, &get_fuse_inode(inode)->state))
 		fuse_flush_mtime(file, true);
 

