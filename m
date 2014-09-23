Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbaIWClM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:41:12 -0400
Received: from mail.kernel.org ([198.145.19.201]:38686 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860AbaIWClI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:41:08 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Wang Nan <wangnan0@huawei.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 44/45] ext2: Fix fs corruption in ext2_get_xip_mem()
Date: Tue, 23 Sep 2014 10:31:46 +0800
Message-Id: <1411439507-30391-44-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Cc: Wang Nan <wangnan0@huawei.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/ext2/inode.c |    2 ++
 fs/ext2/xip.c   |    1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 740cad8..6a7c483 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -614,6 +614,8 @@ static int ext2_get_blocks(struct inode *inode,
 	int count = 0;
 	ext2_fsblk_t first_block = 0;
 
+	BUG_ON(maxblocks == 0);
+
 	depth = ext2_block_to_path(inode,iblock,offsets,&blocks_to_boundary);
 
 	if (depth == 0)
diff --git a/fs/ext2/xip.c b/fs/ext2/xip.c
index 1c33128..e98171a 100644
--- a/fs/ext2/xip.c
+++ b/fs/ext2/xip.c
@@ -35,6 +35,7 @@ __ext2_get_block(struct inode *inode, pgoff_t pgoff, int create,
 	int rc;
 
 	memset(&tmp, 0, sizeof(struct buffer_head));
+	tmp.b_size = 1 << inode->i_blkbits;
 	rc = ext2_get_block(inode, pgoff, &tmp, create);
 	*result = tmp.b_blocknr;
 
-- 
1.7.9.5

