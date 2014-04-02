Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958AbaDBUSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:18:18 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42854 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758921AbaDBUNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 14/40] nfs: defer inode_dio_done call until size update is done
Date: Wed,  2 Apr 2014 22:13:00 +0200
Message-Id: <cebe8f0ce211feb8c404d789950809fd20bac709.1396469191.git.jslaby@suse.cz>
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

commit 2a009ec98cce440c0992fc9a2353e96cdb0b048b upstream.

We need to have the I/O fully finished before telling the truncate code
that we are done.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfs/direct.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index df06e6b1952e..2adc0094cde8 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -227,21 +227,27 @@ static void nfs_direct_complete(struct nfs_direct_req *dreq, bool write)
 {
 	struct inode *inode = dreq->inode;
 
-	if (dreq->iocb) {
+	if (dreq->iocb && write) {
 		loff_t pos = dreq->iocb->ki_pos + dreq->count;
+
+		spin_lock(&inode->i_lock);
+		if (i_size_read(inode) < pos)
+			i_size_write(inode, pos);
+		spin_unlock(&inode->i_lock);
+	}
+
+	if (write) {
+		nfs_zap_mapping(inode, inode->i_mapping);
+		inode_dio_done(inode);
+	}
+
+	if (dreq->iocb) {
 		long res = (long) dreq->error;
 		if (!res)
 			res = (long) dreq->count;
-
-		if (write) {
-			spin_lock(&inode->i_lock);
-			if (i_size_read(inode) < pos)
-				i_size_write(inode, pos);
-			spin_unlock(&inode->i_lock);
-		}
-
 		aio_complete(dreq->iocb, res, 0);
 	}
+
 	complete_all(&dreq->completion);
 
 	nfs_direct_req_release(dreq);
@@ -484,12 +490,6 @@ out:
 	return result;
 }
 
-static void nfs_inode_dio_write_done(struct inode *inode)
-{
-	nfs_zap_mapping(inode, inode->i_mapping);
-	inode_dio_done(inode);
-}
-
 #if IS_ENABLED(CONFIG_NFS_V3) || IS_ENABLED(CONFIG_NFS_V4)
 static void nfs_direct_write_reschedule(struct nfs_direct_req *dreq)
 {
@@ -605,7 +605,6 @@ static void nfs_direct_write_schedule_work(struct work_struct *work)
 			nfs_direct_write_reschedule(dreq);
 			break;
 		default:
-			nfs_inode_dio_write_done(dreq->inode);
 			nfs_direct_complete(dreq, true);
 	}
 }
@@ -622,7 +621,6 @@ static void nfs_direct_write_schedule_work(struct work_struct *work)
 
 static void nfs_direct_write_complete(struct nfs_direct_req *dreq, struct inode *inode)
 {
-	nfs_inode_dio_write_done(inode);
 	nfs_direct_complete(dreq, true);
 }
 #endif
-- 
1.9.1

