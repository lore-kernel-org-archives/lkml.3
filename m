Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaCLKMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:12:53 -0400
Received: from smtp03.stone-is.org ([87.238.162.6]:35423 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaCLKMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:12:52 -0400
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <5320331F.7060601@acm.org>
Date: Wed, 12 Mar 2014 11:12:47 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Alexander Gordeev <agordeev@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Shaohua Li <shli@fusionio.com>,
        Mike Christie <MChristie@fusionio.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] percpu_ida: Handle out-of-tags gracefully
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wait until a tag becomes available instead of giving up when
running out of tags temporarily. This patch fixes the following
kernel bug:

------------[ cut here ]------------
kernel BUG at lib/percpu_ida.c:81!
invalid opcode: 0000 [#1] SMP
RIP: 0010:[<ffffffff8120f00e>]  [<ffffffff8120f00e>] percpu_ida_alloc+0x33e/0x370
Call Trace:
 [<ffffffff811ef95f>] blk_mq_get_tag+0x2f/0x50
 [<ffffffff811ed79c>] blk_mq_alloc_rq.isra.17+0x1c/0x90
 [<ffffffff811eeb9b>] blk_mq_alloc_request_pinned+0x9b/0x110
 [<ffffffff811ef4c6>] blk_mq_make_request+0x426/0x480
 [<ffffffff811e28f0>] generic_make_request+0xc0/0x110
 [<ffffffff811e29ab>] submit_bio+0x6b/0x140
 [<ffffffff8117aabb>] _submit_bh+0x13b/0x220
 [<ffffffff8117d70f>] block_read_full_page+0x1ff/0x300
 [<ffffffff81181128>] blkdev_readpage+0x18/0x20
 [<ffffffff811067b7>] __do_page_cache_readahead+0x277/0x280
 [<ffffffff81106d1d>] force_page_cache_readahead+0x8d/0xc0
 [<ffffffff81106d9b>] page_cache_sync_readahead+0x4b/0x50
 [<ffffffff810fdf05>] generic_file_aio_read+0x4c5/0x700
 [<ffffffff8118147b>] blkdev_aio_read+0x4b/0x70
 [<ffffffff8114a28a>] do_sync_read+0x5a/0x90
 [<ffffffff8114a8cb>] vfs_read+0x9b/0x160
 [<ffffffff8114b389>] SyS_read+0x49/0xa0
 [<ffffffff81416049>] tracesys+0xd0/0xd5
---[ end trace cdd1a8a7968266cf ]---

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Alexander Gordeev <agordeev@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
---
 lib/percpu_ida.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index 93d145e..56b5067 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -73,7 +73,7 @@ static inline void steal_tags(struct percpu_ida *pool,
 		if (cpu >= nr_cpu_ids) {
 			cpu = cpumask_first(&pool->cpus_have_tags);
 			if (cpu >= nr_cpu_ids)
-				BUG();
+				break;
 		}
 
 		pool->cpu_last_stolen = cpu;
-- 
1.8.4.5

