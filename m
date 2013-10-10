Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab3JJNTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 09:19:16 -0400
Received: from relay.parallels.com ([195.214.232.42]:49598 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab3JJNTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 09:19:15 -0400
Subject: [PATCH] fuse: Flush files on wb close -v2
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, fengguang.wu@intel.com, devel@openvz.org
Date: Thu, 10 Oct 2013 17:19:06 +0400
Message-ID: <20131010131839.10462.14075.stgit@dhcp-10-30-17-2.sw.ru>
In-Reply-To: <20131010131102.10089.51081.stgit@dhcp-10-30-17-2.sw.ru>
References: <20131010131102.10089.51081.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
 1 file changed, 6 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index eabe202..b4d4189 100644
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
 

