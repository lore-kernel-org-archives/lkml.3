Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696Ab3FEVQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:16:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932608Ab3FEVNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:13:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Michael L. Semon" <mlsemon35@gmail.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [ 38/44] jfs: fix a couple races
Date: Wed,  5 Jun 2013 14:12:36 -0700
Message-Id: <20130605211225.827453790@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605211221.858177087@linuxfoundation.org>
References: <20130605211221.858177087@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
 


