Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbaAULkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 06:40:16 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:47483 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448AbaAULj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 06:39:59 -0500
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Matias Bjorling <m@bjorling.me>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, Jeff <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Sumanth <sumantk2@linux.vnet.ibm.com>
Subject: [RFC PATCH V3 2/2] fs : Add sanity checks for block size > PAGE_SIZE
Date: Tue, 21 Jan 2014 17:00:00 +0530
Message-Id: <1390303800-22422-3-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1390303800-22422-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
References: <1390303800-22422-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012111-9332-0000-0000-000002D53CB9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We could hit null pointer dereference error during alloc_page_buffers
in : (1) block size > PAGE_SIZE (2) low memory.
Add sanity check for that.

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 fs/block_dev.c | 1 +
 fs/buffer.c    | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 1e86823..2481d42 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1027,6 +1027,7 @@ void bd_set_size(struct block_device *bdev, loff_t size)
 			break;
 		bsize <<= 1;
 	}
+	BUG_ON(bsize > PAGE_SIZE);
 	bdev->bd_block_size = bsize;
 	bdev->bd_inode->i_blkbits = blksize_bits(bsize);
 }
diff --git a/fs/buffer.c b/fs/buffer.c
index 6024877..b039b15 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1571,6 +1571,12 @@ void create_empty_buffers(struct page *page,
 	struct buffer_head *bh, *head, *tail;
 
 	head = alloc_page_buffers(page, blocksize, 1);
+
+	/*
+ 	 * alloc_page_buffers() could return NULL on (1) bs > PAGE_SIZE
+ 	 * (2) low memory case. Ensure that we don't dereference null ptr
+ 	 */  
+	BUG_ON(!head);
 	bh = head;
 	do {
 		bh->b_state |= b_state;
-- 
1.7.11.7

