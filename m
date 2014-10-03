Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbaJCWD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:03:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337AbaJCWDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Paulo De Rezende Pinatti <ppinatti@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.16 313/357] blk-mq: Avoid race condition with uninitialized requests
Date: Fri,  3 Oct 2014 14:31:39 -0700
Message-Id: <20141003212942.878351445@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <dahi@linux.vnet.ibm.com>

commit 683d0e126232d898a481daa3a4ca032c2b1a9660 upstream.

This patch should fix the bug reported in
https://lkml.org/lkml/2014/9/11/249.

We have to initialize at least the atomic_flags and the cmd_flags when
allocating storage for the requests.

Otherwise blk_mq_timeout_check() might dereference uninitialized
pointers when racing with the creation of a request.

Also move the reset of cmd_flags for the initializing code to the point
where a request is freed. So we will never end up with pending flush
request indicators that might trigger dereferences of invalid pointers
in blk_mq_timeout_check().

Signed-off-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
Reported-by: Paulo De Rezende Pinatti <ppinatti@linux.vnet.ibm.com>
Tested-by: Paulo De Rezende Pinatti <ppinatti@linux.vnet.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-mq.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -219,7 +219,6 @@ __blk_mq_alloc_request(struct blk_mq_all
 	if (tag != BLK_MQ_TAG_FAIL) {
 		rq = data->hctx->tags->rqs[tag];
 
-		rq->cmd_flags = 0;
 		if (blk_mq_tag_busy(data->hctx)) {
 			rq->cmd_flags = REQ_MQ_INFLIGHT;
 			atomic_inc(&data->hctx->nr_active);
@@ -274,6 +273,7 @@ static void __blk_mq_free_request(struct
 
 	if (rq->cmd_flags & REQ_MQ_INFLIGHT)
 		atomic_dec(&hctx->nr_active);
+	rq->cmd_flags = 0;
 
 	clear_bit(REQ_ATOM_STARTED, &rq->atomic_flags);
 	blk_mq_put_tag(hctx, tag, &ctx->last_tag);
@@ -1411,6 +1411,8 @@ static struct blk_mq_tags *blk_mq_init_r
 		left -= to_do * rq_size;
 		for (j = 0; j < to_do; j++) {
 			tags->rqs[i] = p;
+			tags->rqs[i]->atomic_flags = 0;
+			tags->rqs[i]->cmd_flags = 0;
 			if (set->ops->init_request) {
 				if (set->ops->init_request(set->driver_data,
 						tags->rqs[i], hctx_idx, i,


