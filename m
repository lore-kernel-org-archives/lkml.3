Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242Ab3DAKl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 06:41:26 -0400
Received: from relay.parallels.com ([195.214.232.42]:54711 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab3DAKlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 06:41:22 -0400
Subject: [PATCH 08/14] fuse: Flush files on wb close
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        devel@openvz.org
Date: Mon, 01 Apr 2013 14:41:56 +0400
Message-ID: <20130401104150.19027.45605.stgit@maximpc.sw.ru>
In-Reply-To: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
References: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any write request requires a file handle to report to the userspace. Thus
when we close a file (and free the fuse_file with this info) we have to
flush all the outstanding dirty pages.

filemap_write_and_wait() is enough because every page under fuse writeback
is accounted in ff->count. This delays actual close until all fuse wb is
completed.

In case of "write cache" turned off, the flush is ensured by fuse_vma_close().

Original patch by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 6821e95..5509c0b 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -288,6 +288,12 @@ static int fuse_open(struct inode *inode, struct file *file)
 
 static int fuse_release(struct inode *inode, struct file *file)
 {
+	struct fuse_conn *fc = get_fuse_conn(inode);
+
+	/* see fuse_vma_close() for !writeback_cache case */
+	if (fc->writeback_cache)
+		filemap_write_and_wait(file->f_mapping);
+
 	if (test_bit(FUSE_I_MTIME_UPDATED,
 		     &get_fuse_inode(inode)->state))
 		fuse_flush_mtime(file, true);

