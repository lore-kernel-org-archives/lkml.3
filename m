Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418AbaJCWcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:32:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834AbaJCW3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:29:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Wang Nan <wangnan0@huawei.com>
Subject: [PATCH 3.10 136/143] ext2: Fix fs corruption in ext2_get_xip_mem()
Date: Fri,  3 Oct 2014 14:35:31 -0700
Message-Id: <20141003213318.556330089@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Wang Nan <wangnan0@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext2/inode.c |    2 ++
 fs/ext2/xip.c   |    1 +
 2 files changed, 3 insertions(+)

--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -632,6 +632,8 @@ static int ext2_get_blocks(struct inode
 	int count = 0;
 	ext2_fsblk_t first_block = 0;
 
+	BUG_ON(maxblocks == 0);
+
 	depth = ext2_block_to_path(inode,iblock,offsets,&blocks_to_boundary);
 
 	if (depth == 0)
--- a/fs/ext2/xip.c
+++ b/fs/ext2/xip.c
@@ -35,6 +35,7 @@ __ext2_get_block(struct inode *inode, pg
 	int rc;
 
 	memset(&tmp, 0, sizeof(struct buffer_head));
+	tmp.b_size = 1 << inode->i_blkbits;
 	rc = ext2_get_block(inode, pgoff, &tmp, create);
 	*result = tmp.b_blocknr;
 


