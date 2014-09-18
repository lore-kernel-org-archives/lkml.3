Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbaIRJEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 05:04:42 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:43419 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbaIRJEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 05:04:39 -0400
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: tom.leiming@gmail.com, axboe@kernel.dk
Cc: kvm@vger.kernel.org, stable@vger.kernel.org, borntraeger@de.ibm.com,
        rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        mst@redhat.com, dahi@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: [PATCH] blk-mq: Avoid race condition with uninitialized requests
Date: Thu, 18 Sep 2014 11:04:31 +0200
Message-Id: <1411031071-40390-2-git-send-email-dahi@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1411031071-40390-1-git-send-email-dahi@linux.vnet.ibm.com>
References: <1411031071-40390-1-git-send-email-dahi@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091809-2966-0000-0000-0000012BAA85
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch should fix the bug reported in https://lkml.org/lkml/2014/9/11/249.

We have to initialize at least the atomic_flags and the cmd_flags when
allocating storage for the requests.

Otherwise blk_mq_timeout_check() might dereference uninitialized pointers when
racing with the creation of a request.

Also move the reset of cmd_flags for the initializing code to the point where a
request is freed. So we will never end up with pending flush request indicators
that might trigger dereferences of invalid pointers in blk_mq_timeout_check().

Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
---
 block/blk-mq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 383ea0c..eed6340 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -203,7 +203,6 @@ __blk_mq_alloc_request(struct blk_mq_alloc_data *data, int rw)
 	if (tag != BLK_MQ_TAG_FAIL) {
 		rq = data->hctx->tags->rqs[tag];
 
-		rq->cmd_flags = 0;
 		if (blk_mq_tag_busy(data->hctx)) {
 			rq->cmd_flags = REQ_MQ_INFLIGHT;
 			atomic_inc(&data->hctx->nr_active);
@@ -258,6 +257,7 @@ static void __blk_mq_free_request(struct blk_mq_hw_ctx *hctx,
 
 	if (rq->cmd_flags & REQ_MQ_INFLIGHT)
 		atomic_dec(&hctx->nr_active);
+	rq->cmd_flags = 0;
 
 	clear_bit(REQ_ATOM_STARTED, &rq->atomic_flags);
 	blk_mq_put_tag(hctx, tag, &ctx->last_tag);
@@ -1404,6 +1404,8 @@ static struct blk_mq_tags *blk_mq_init_rq_map(struct blk_mq_tag_set *set,
 		left -= to_do * rq_size;
 		for (j = 0; j < to_do; j++) {
 			tags->rqs[i] = p;
+			tags->rqs[i]->atomic_flags = 0;
+			tags->rqs[i]->cmd_flags = 0;
 			if (set->ops->init_request) {
 				if (set->ops->init_request(set->driver_data,
 						tags->rqs[i], hctx_idx, i,
-- 
1.8.5.5

