Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbaLIP7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 10:59:23 -0500
Received: from xavier.telenet-ops.be ([195.130.132.52]:36196 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbaLIP7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 10:59:22 -0500
Message-ID: <54871C59.3050903@acm.org>
Date: Tue, 09 Dec 2014 16:59:21 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Christoph Hellwig <hch@lst.de>, Robert Elliott <elliott@hp.com>,
        Ming Lei <ming.lei@canonical.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] blk-mq: Use all available hardware queues
References: <54871BD0.8020305@acm.org>
In-Reply-To: <54871BD0.8020305@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suppose that a system has two CPU sockets, three cores per socket,
that it does not support hyperthreading and that four hardware
queues are provided by a block driver. With the current algorithm
this will lead to the following assignment of CPU cores to hardware
queues:

  HWQ 0: 0 1
  HWQ 1: 2 3
  HWQ 2: 4 5
  HWQ 3: (none)

This patch changes the queue assignment into:

  HWQ 0: 0 1
  HWQ 1: 2
  HWQ 2: 3 4
  HWQ 3: 5

In other words, this patch has the following three effects:
- All four hardware queues are used instead of only three.
- CPU cores are spread more evenly over hardware queues. For the
  above example the range of the number of CPU cores associated
  with a single HWQ is reduced from [0..2] to [1..2].
- If the number of HWQ's is a multiple of the number of CPU sockets
  it is now guaranteed that all CPU cores associated with a single
  HWQ reside on the same CPU socket.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Alexander Gordeev <agordeev@redhat.com>
---
 block/blk-mq-cpumap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 1065d7c..8e56455 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -17,7 +17,7 @@
 static int cpu_to_queue_index(unsigned int nr_cpus, unsigned int nr_queues,
 			      const int cpu)
 {
-	return cpu / ((nr_cpus + nr_queues - 1) / nr_queues);
+	return cpu * nr_queues / nr_cpus;
 }
 
 static int get_first_sibling(unsigned int cpu)
-- 
2.1.2

