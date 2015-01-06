Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbbAFQEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:04:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755754AbbAFQEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:04:22 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jaxboe@fb.com>, Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] blk-mq: suppress a warning
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 06 Jan 2015 11:04:17 -0500
Message-ID: <x494ms3evzy.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

Is there any reason the following patch from Shaohua didn't go in?  We
are hitting this WARN_ON during hotplug testing, and this patch fixes
the problem.  The previous posting is located here:

http://linux-kernel.2935.n7.nabble.com/patch-blk-mq-suppress-a-warning-td895340.html

Cheers,
Jeff

From: Shaohua Li <shli@kernel.org>

The warning is hit when cpu hotplug is running. After scheduler puts a cpu
online and before blk-mq mapping reinit, a task can queue a request and run the
queue. At that time the cpu isn't in hctx->cpumask, but the cpu is mapped into
hctx 0. When the race happens, hctx->cpumask doesn't set the cpu and
ctx->index_hw/hctx->nr_ctx isn't correct, but it doesn't cause any problem. So
just suppress the warning here.

Signed-off-by: Shaohua Li <shli@kernel.org>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/block/blk-mq.c b/block/blk-mq.c
index da1ab56..491beb7 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -702,7 +702,7 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 	struct list_head *dptr;
 	int queued;
 
-	WARN_ON(!cpumask_test_cpu(raw_smp_processor_id(), hctx->cpumask));
+	WARN_ON(q->mq_ops->map_queue(q, raw_smp_processor_id()) != hctx);
 
 	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
 		return;
