Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759014AbaDBUSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:18:22 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42856 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758918AbaDBUNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 15/40] nfs: increment i_dio_count for reads, too
Date: Wed,  2 Apr 2014 22:13:01 +0200
Message-Id: <343bb4c592b0ae4d7d66af004593fff68d6a3f39.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 1f90ee27461e31a1c18e5d819f6ea6f5c7304b16 upstream.

i_dio_count is used to protect dio access against truncate.  We want
to make sure there are no dio reads pending either when doing a
truncate.  I suspect on plain NFS things might work even without
this, but once we use a pnfs layout driver that access backing devices
directly things will go bad without the proper synchronization.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfs/direct.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 2adc0094cde8..af5f3ffcb157 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -236,10 +236,10 @@ static void nfs_direct_complete(struct nfs_direct_req *dreq, bool write)
 		spin_unlock(&inode->i_lock);
 	}
 
-	if (write) {
+	if (write)
 		nfs_zap_mapping(inode, inode->i_mapping);
-		inode_dio_done(inode);
-	}
+
+	inode_dio_done(inode);
 
 	if (dreq->iocb) {
 		long res = (long) dreq->error;
@@ -420,6 +420,7 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
 					      loff_t pos, bool uio)
 {
 	struct nfs_pageio_descriptor desc;
+	struct inode *inode = dreq->inode;
 	ssize_t result = -EINVAL;
 	size_t requested_bytes = 0;
 	unsigned long seg;
@@ -428,6 +429,7 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
 			     &nfs_direct_read_completion_ops);
 	get_dreq(dreq);
 	desc.pg_dreq = dreq;
+	atomic_inc(&inode->i_dio_count);
 
 	for (seg = 0; seg < nr_segs; seg++) {
 		const struct iovec *vec = &iov[seg];
@@ -447,6 +449,7 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
 	 * generic layer handle the completion.
 	 */
 	if (requested_bytes == 0) {
+		inode_dio_done(inode);
 		nfs_direct_req_release(dreq);
 		return result < 0 ? result : -EIO;
 	}
-- 
1.9.1

