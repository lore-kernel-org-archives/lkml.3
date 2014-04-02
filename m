Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213AbaDBUSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:18:14 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42861 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758928AbaDBUNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 13/40] nfs: fix size updates for aio writes
Date: Wed,  2 Apr 2014 22:12:59 +0200
Message-Id: <aca53e4e90058d5c711efdce3ba00fd9ca7d52e3.1396469191.git.jslaby@suse.cz>
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

commit 9811cd57f4c6b5b60ec104de68a88303717e3106 upstream.

nfs_file_direct_write only updates the inode size if it succeeded and
returned the number of bytes written.  But in the AIO case nfs_direct_wait
turns the return value into -EIOCBQUEUED and we skip the size update.

Instead the aio completion path should updated it, which this patch
does.  The implementation is a little hacky because there is no obvious
way to find out we are called for a write in nfs_direct_complete.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfs/direct.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 91ff089d3412..df06e6b1952e 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -223,12 +223,23 @@ out:
  * Synchronous I/O uses a stack-allocated iocb.  Thus we can't trust
  * the iocb is still valid here if this is a synchronous request.
  */
-static void nfs_direct_complete(struct nfs_direct_req *dreq)
+static void nfs_direct_complete(struct nfs_direct_req *dreq, bool write)
 {
+	struct inode *inode = dreq->inode;
+
 	if (dreq->iocb) {
+		loff_t pos = dreq->iocb->ki_pos + dreq->count;
 		long res = (long) dreq->error;
 		if (!res)
 			res = (long) dreq->count;
+
+		if (write) {
+			spin_lock(&inode->i_lock);
+			if (i_size_read(inode) < pos)
+				i_size_write(inode, pos);
+			spin_unlock(&inode->i_lock);
+		}
+
 		aio_complete(dreq->iocb, res, 0);
 	}
 	complete_all(&dreq->completion);
@@ -273,7 +284,7 @@ static void nfs_direct_read_completion(struct nfs_pgio_header *hdr)
 	}
 out_put:
 	if (put_dreq(dreq))
-		nfs_direct_complete(dreq);
+		nfs_direct_complete(dreq, false);
 	hdr->release(hdr);
 }
 
@@ -435,7 +446,7 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
 	}
 
 	if (put_dreq(dreq))
-		nfs_direct_complete(dreq);
+		nfs_direct_complete(dreq, false);
 	return 0;
 }
 
@@ -595,7 +606,7 @@ static void nfs_direct_write_schedule_work(struct work_struct *work)
 			break;
 		default:
 			nfs_inode_dio_write_done(dreq->inode);
-			nfs_direct_complete(dreq);
+			nfs_direct_complete(dreq, true);
 	}
 }
 
@@ -612,7 +623,7 @@ static void nfs_direct_write_schedule_work(struct work_struct *work)
 static void nfs_direct_write_complete(struct nfs_direct_req *dreq, struct inode *inode)
 {
 	nfs_inode_dio_write_done(inode);
-	nfs_direct_complete(dreq);
+	nfs_direct_complete(dreq, true);
 }
 #endif
 
-- 
1.9.1

