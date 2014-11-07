Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaKGWES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 17:04:18 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:49250 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaKGWEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 17:04:15 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Clark Williams <williams@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] blk-mq: use get_cpu/put_cpu instead of preempt_disable/preempt_enable
Date: Fri,  7 Nov 2014 23:04:00 +0100
Message-Id: <1415397840-18041-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415397840-18041-1-git-send-email-pbonzini@redhat.com>
References: <1415397840-18041-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk-mq is using preempt_disable/enable in order to ensure that the
queue runners are placed on the right CPU.  This does not work with
the RT patches, because __blk_mq_run_hw_queue takes a non-raw
spinlock with the preemption-disabled region.  If there is contention
on the lock, this violates the rules for preemption-disabled regions.

While this should be easily fixable within the RT patches just by doing
migrate_disable/enable, we can do better and document _why_ this
particular region runs with disabled preemption.  After the previous
patch, it is trivial to switch it to get/put_cpu; the RT patches then
can change it to get_cpu_light, which lets virtio-blk run under RT
kernels.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Clark Williams <williams@redhat.com>
Tested-by: Clark Williams <williams@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/blk-mq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c6192ba78950..a958851d9dd2 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -829,14 +829,14 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
 		return;
 
 	if (!async) {
-		preempt_disable();
-		if (cpumask_test_cpu(smp_processor_id(), hctx->cpumask)) {
+		int cpu = get_cpu();
+		if (cpumask_test_cpu(cpu, hctx->cpumask)) {
 			__blk_mq_run_hw_queue(hctx);
-			preempt_enable();
+			put_cpu();
 			return;
 		}
 
-		preempt_enable();
+		put_cpu();
 	}
 
 	if (hctx->queue->nr_hw_queues == 1)
-- 
2.1.0

