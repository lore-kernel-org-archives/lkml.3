Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbaIDHva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 03:51:30 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:47731 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810AbaIDHvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 03:51:14 -0400
X-Original-SENDERIP: 165.186.175.39
X-Original-MAILFROM: gioh.kim@lge.com
From: Gioh Kim <gioh.kim@lge.com>
To: gioh.kim@lge.com, akpm@linux-foundation.org, jack@suse.cz, tytso@mit.edu,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org,
        adilger.kernel@dilger.ca
Cc: minchan@kernel.org, js1304@gmail.com, gunho.lee@lge.com
Subject: [PATCHv4 3/3] jbd/jbd2: use non-movable memory for the jbd superblock
Date: Thu,  4 Sep 2014 16:29:41 +0900
Message-Id: <1409815781-28011-4-git-send-email-gioh.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409815781-28011-1-git-send-email-gioh.kim@lge.com>
References: <1409815781-28011-1-git-send-email-gioh.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A long-lasting buffer-cache can distrub page migration so that
it must be allocated from non-movable area.

The journal_init_inode is creating a buffer-cache for superblock journaling.
The superblock exists until system shutdown so that the buffer-cache
for the superblock would also exist for a long time
and it can distrub page migration.

This patch make the buffer-cache be allocated from non-movable area
not to distrub page migration.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/journal.c  |    2 +-
 fs/jbd2/journal.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 06fe11e..aab8549 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -886,7 +886,7 @@ journal_t * journal_init_inode (struct inode *inode)
 		goto out_err;
 	}
 
-	bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
+	bh = getblk_unmovable(journal->j_dev, blocknr, journal->j_blocksize);
 	if (!bh) {
 		printk(KERN_ERR
 		       "%s: Cannot get buffer for journal superblock\n",
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 67b8e30..65bd3b1 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1237,7 +1237,7 @@ journal_t * jbd2_journal_init_inode (struct inode *inode)
 		goto out_err;
 	}
 
-	bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
+	bh = getblk_unmovable(journal->j_dev, blocknr, journal->j_blocksize);
 	if (!bh) {
 		printk(KERN_ERR
 		       "%s: Cannot get buffer for journal superblock\n",
-- 
1.7.9.5

