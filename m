Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbaAULkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 06:40:09 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:42582 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbaAULj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 06:39:57 -0500
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
Subject: [RFC PATCH V3 1/2]  null_blk: Null pointer deference problem in alloc_page_buffers
Date: Tue, 21 Jan 2014 16:59:59 +0530
Message-Id: <1390303800-22422-2-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1390303800-22422-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
References: <1390303800-22422-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012111-0928-0000-0000-00000599BD29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 If we load the null_blk module with bs=8k we get following oops:
[ 3819.812190] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[ 3819.812387] IP: [<ffffffff81170aa5>] create_empty_buffers+0x28/0xaf
[ 3819.812527] PGD 219244067 PUD 215a06067 PMD 0
[ 3819.812640] Oops: 0000 [#1] SMP
[ 3819.812772] Modules linked in: null_blk(+)

 Fix that by resetting block size to PAGE_SIZE if it is greater than PAGE_SIZE

Reported-by: Sumanth <sumantk2@linux.vnet.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 drivers/block/null_blk.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index a2e69d2..a01d7f6 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -622,6 +622,11 @@ static int __init null_init(void)
 		irqmode = NULL_IRQ_NONE;
 	}
 #endif
+	if (bs > PAGE_SIZE) {
+		pr_warn("null_blk: invalid block size\n");
+		pr_warn("null_blk: defaults block size to %lu\n", PAGE_SIZE);
+		bs = PAGE_SIZE;
+	}
 
 	if (queue_mode == NULL_Q_MQ && use_per_node_hctx) {
 		if (submit_queues < nr_online_nodes) {
-- 
1.7.11.7

