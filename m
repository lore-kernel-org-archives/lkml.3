Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964864Ab3GCSlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:41:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13537 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291Ab3GCSlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:07 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=N4YN5WMJYVMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=dfm9lNyCN4wA:10 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=pQFG53Joc4AfjvbZiugA:9 a=7DSvI1NPTFQA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184052.673060454@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Michael L. Semon" <mlsemon35@gmail.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [049/141] jfs: fix a couple races
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0049-jfs-fix-a-couple-races.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

[ Upstream commit 73aaa22d5ffb2630456bac2f9a4ed9b81d0d7271 ]

This patch fixes races uncovered by xfstests testcase 068.

One race is the result of jfs_sync() trying to write a sync point to the
journal after it has been frozen (or possibly in the process). Since
freezing sync's the journal, there is no need to write a sync point so
we simply want to return.

The second involves jfs_write_inode() being called on a deleted inode.
It calls jfs_flush_journal which is held up by the jfs_commit thread
doing the final iput on the same deleted inode, which itself is
waiting for the I_SYNC flag to be cleared. jfs_write_inode need not
do anything when i_nlink is zero, which is the easy fix.

Reported-by: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/jfs/inode.c      |    2 +-
 fs/jfs/jfs_logmgr.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 4692bf3..7e54dfd 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -125,7 +125,7 @@ int jfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	int wait = wbc->sync_mode == WB_SYNC_ALL;
 
-	if (test_cflag(COMMIT_Nolink, inode))
+	if (inode->i_nlink == 0)
 		return 0;
 	/*
 	 * If COMMIT_DIRTY is not set, the inode isn't really dirty.
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 2eb952c..cbe48ea 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1058,7 +1058,8 @@ static int lmLogSync(struct jfs_log * log, int hard_sync)
  */
 void jfs_syncpt(struct jfs_log *log, int hard_sync)
 {	LOG_LOCK(log);
-	lmLogSync(log, hard_sync);
+	if (!test_bit(log_QUIESCE, &log->flag))
+		lmLogSync(log, hard_sync);
 	LOG_UNLOCK(log);
 }
 
-- 
1.7.10.4


