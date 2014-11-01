Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbaKAXBN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:01:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60078 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470AbaKAWj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jan Kara" <jack@suse.cz>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.645068768@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 099/102] ext2: Fix fs corruption in ext2_get_xip_mem()
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 7ba3ec5749ddb61f79f7be17b5fd7720eebc52de upstream.

Commit 8e3dffc651cb "Ext2: mark inode dirty after the function
dquot_free_block_nodirty is called" unveiled a bug in __ext2_get_block()
called from ext2_get_xip_mem(). That function called ext2_get_block()
mistakenly asking it to map 0 blocks while 1 was intended. Before the
above mentioned commit things worked out fine by luck but after that commit
we started returning that we allocated 0 blocks while we in fact
allocated 1 block and thus allocation was looping until all blocks in
the filesystem were exhausted.

Fix the problem by properly asking for one block and also add assertion
in ext2_get_blocks() to catch similar problems.

Reported-and-tested-by: Andiry Xu <andiry.xu@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext2/inode.c | 2 ++
 fs/ext2/xip.c   | 1 +
 2 files changed, 3 insertions(+)

--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -619,6 +619,8 @@ static int ext2_get_blocks(struct inode
 	int count = 0;
 	ext2_fsblk_t first_block = 0;
 
+	BUG_ON(maxblocks == 0);
+
 	depth = ext2_block_to_path(inode,iblock,offsets,&blocks_to_boundary);
 
 	if (depth == 0)
--- a/fs/ext2/xip.c
+++ b/fs/ext2/xip.c
@@ -37,6 +37,7 @@ __ext2_get_block(struct inode *inode, pg
 	int rc;
 
 	memset(&tmp, 0, sizeof(struct buffer_head));
+	tmp.b_size = 1 << inode->i_blkbits;
 	rc = ext2_get_block(inode, pgoff, &tmp, create);
 	*result = tmp.b_blocknr;
 

