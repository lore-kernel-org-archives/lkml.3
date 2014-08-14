Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbaHNFRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 01:17:46 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42129 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbaHNFRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 01:17:45 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <53EC466F.6080408@lge.com>
Date: Thu, 14 Aug 2014 14:17:35 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
CC: Minchan Kim <minchan@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        =?EUC-KR?B?wMywx8ij?= <gunho.lee@lge.com>
Subject: [PATCH 3/3] jbd/jbd2: allocate buffer-cache for superblock inode
 in, non-movable area
References: <53EC4531.1000904@lge.com>
In-Reply-To: <53EC4531.1000904@lge.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
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
---
 fs/jbd/journal.c  |    2 +-
 fs/jbd2/journal.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 06fe11e..2ed8aa2 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -886,7 +886,7 @@ journal_t * journal_init_inode (struct inode *inode)
                goto out_err;
        }

-       bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
+       bh = __getblk_nonmovable(journal->j_dev, blocknr, journal->j_blocksize);
        if (!bh) {
                printk(KERN_ERR
                       "%s: Cannot get buffer for journal superblock\n",
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 67b8e30..a618e49 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1237,7 +1237,7 @@ journal_t * jbd2_journal_init_inode (struct inode *inode)
                goto out_err;
        }

-       bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
+       bh = __getblk_nonmovable(journal->j_dev, blocknr, journal->j_blocksize);
        if (!bh) {
                printk(KERN_ERR
                       "%s: Cannot get buffer for journal superblock\n",
--
1.7.9.5

