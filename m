Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaAMLhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 06:37:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:39271 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbaAMLhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 06:37:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,652,1384329600"; 
   d="scan'208";a="457858220"
Date: Mon, 13 Jan 2014 19:37:41 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] writeback data corruption fix
Message-ID: <20140113113741.GA23623@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull a writeback fix, it has been in linux-next for one month.

The following changes since commit 374b105797c3d4f29c685f3be535c35f5689b30e:

  Linux 3.13-rc3 (2013-12-06 09:34:04 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git tags/writeback-fixes

for you to fetch changes up to f9b0e058cbd04ada76b13afffa7e1df830543c24:

  writeback: Fix data corruption on NFS (2013-12-14 04:21:26 +0800)

----------------------------------------------------------------
fix data corruption on NFS writeback

----------------------------------------------------------------
Jan Kara (1):
      writeback: Fix data corruption on NFS

 fs/fs-writeback.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 1f4a10e..e0259a1 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -516,13 +516,16 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 	}
 	WARN_ON(inode->i_state & I_SYNC);
 	/*
-	 * Skip inode if it is clean. We don't want to mess with writeback
-	 * lists in this function since flusher thread may be doing for example
-	 * sync in parallel and if we move the inode, it could get skipped. So
-	 * here we make sure inode is on some writeback list and leave it there
-	 * unless we have completely cleaned the inode.
+	 * Skip inode if it is clean and we have no outstanding writeback in
+	 * WB_SYNC_ALL mode. We don't want to mess with writeback lists in this
+	 * function since flusher thread may be doing for example sync in
+	 * parallel and if we move the inode, it could get skipped. So here we
+	 * make sure inode is on some writeback list and leave it there unless
+	 * we have completely cleaned the inode.
 	 */
-	if (!(inode->i_state & I_DIRTY))
+	if (!(inode->i_state & I_DIRTY) &&
+	    (wbc->sync_mode != WB_SYNC_ALL ||
+	     !mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK)))
 		goto out;
 	inode->i_state |= I_SYNC;
 	spin_unlock(&inode->i_lock);
