Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab3LRRXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:23:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542Ab3LRRXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:23:42 -0500
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] block: Stop abusing rq->csd.list in blk-softirq
Date: Wed, 18 Dec 2013 18:23:36 +0100
Message-Id: <1387387418-10005-5-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387387418-10005-1-git-send-email-jack@suse.cz>
References: <1387387418-10005-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abusing rq->csd.list for a list of requests to complete is rather ugly.
Especially since using queuelist should be safe and much cleaner.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/blk-softirq.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 57790c1a97eb..7ea5534096d5 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -30,8 +30,8 @@ static void blk_done_softirq(struct softirq_action *h)
 	while (!list_empty(&local_list)) {
 		struct request *rq;
 
-		rq = list_entry(local_list.next, struct request, csd.list);
-		list_del_init(&rq->csd.list);
+		rq = list_entry(local_list.next, struct request, queuelist);
+		list_del_init(&rq->queuelist);
 		rq->q->softirq_done_fn(rq);
 	}
 }
@@ -45,9 +45,9 @@ static void trigger_softirq(void *data)
 
 	local_irq_save(flags);
 	list = this_cpu_ptr(&blk_cpu_done);
-	list_add_tail(&rq->csd.list, list);
+	list_add_tail(&rq->queuelist, list);
 
-	if (list->next == &rq->csd.list)
+	if (list->next == &rq->queuelist)
 		raise_softirq_irqoff(BLOCK_SOFTIRQ);
 
 	local_irq_restore(flags);
@@ -136,7 +136,7 @@ void __blk_complete_request(struct request *req)
 		struct list_head *list;
 do_local:
 		list = this_cpu_ptr(&blk_cpu_done);
-		list_add_tail(&req->csd.list, list);
+		list_add_tail(&req->queuelist, list);
 
 		/*
 		 * if the list only contains our just added request,
@@ -144,7 +144,7 @@ do_local:
 		 * entries there, someone already raised the irq but it
 		 * hasn't run yet.
 		 */
-		if (list->next == &req->csd.list)
+		if (list->next == &req->queuelist)
 			raise_softirq_irqoff(BLOCK_SOFTIRQ);
 	} else if (raise_blk_irq(ccpu, req))
 		goto do_local;
-- 
1.8.1.4

