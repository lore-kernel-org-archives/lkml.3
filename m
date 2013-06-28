Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab3F1Swf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:52:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41506 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab3F1Sw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:52:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 018/105] jfs: fix a couple races
Date: Fri, 28 Jun 2013 11:50:40 -0700
Message-Id: <1372445527-24414-19-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

commit 73aaa22d5ffb2630456bac2f9a4ed9b81d0d7271 upstream.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/jfs/inode.c      | 2 +-
 fs/jfs/jfs_logmgr.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index b7dc47b..77554b6 100644
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
1.8.1.2

