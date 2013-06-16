Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab3FPWIr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:08:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46311 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755554Ab3FPWIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:43 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Michael L. Semon" <mlsemon35@gmail.com>,
        "Dave Kleikamp" <dave.kleikamp@oracle.com>
Date: Sun, 16 Jun 2013 23:01:37 +0100
Message-ID: <lsq.1371420097.408003952@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [25/83] jfs: fix a couple races
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/jfs/inode.c      |    2 +-
 fs/jfs/jfs_logmgr.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -125,7 +125,7 @@ int jfs_write_inode(struct inode *inode,
 {
 	int wait = wbc->sync_mode == WB_SYNC_ALL;
 
-	if (test_cflag(COMMIT_Nolink, inode))
+	if (inode->i_nlink == 0)
 		return 0;
 	/*
 	 * If COMMIT_DIRTY is not set, the inode isn't really dirty.
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1058,7 +1058,8 @@ static int lmLogSync(struct jfs_log * lo
  */
 void jfs_syncpt(struct jfs_log *log, int hard_sync)
 {	LOG_LOCK(log);
-	lmLogSync(log, hard_sync);
+	if (!test_bit(log_QUIESCE, &log->flag))
+		lmLogSync(log, hard_sync);
 	LOG_UNLOCK(log);
 }
 

