Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaIJATL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 20:19:11 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:35704 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaIJATA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 20:19:00 -0400
Subject: [PATCH 2/2] block: return error if too many reserved tags are
	requested
To: axboe@kernel.dk, elliott@hp.com, hch@lst.de, linux-kernel@vger.kernel.org
From: Robert Elliott <relliott@beardog.cce.hp.com>
Date: Tue, 09 Sep 2014 19:18:07 -0500
Message-ID: <20140910001806.9294.35884.stgit@beardog.cce.hp.com>
In-Reply-To: <20140910001417.9294.40414.stgit@beardog.cce.hp.com>
References: <20140910001417.9294.40414.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

Make blk_mq_alloc_tag_set return an error if set->reserved_tags
is greater than BLK_MQ_MAX_DEPTH minus the minimum number of
tags, since:
* set->queue_depth is truncated to that value
* set->reserved_tags needs to be less than set->queue_depth

Signed-off-by: Robert Elliott <elliott@hp.com>
---
 block/blk-mq.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c49fe00..dc2970d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1936,16 +1936,18 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 		return -EINVAL;
 	if (!set->queue_depth)
 		return -EINVAL;
+	if (set->reserved_tags > BLK_MQ_MAX_DEPTH - BLK_MQ_TAG_MIN)
+		return -EINVAL;
 	if (set->queue_depth < set->reserved_tags + BLK_MQ_TAG_MIN)
 		return -EINVAL;
 
 	if (!set->nr_hw_queues || !set->ops->queue_rq || !set->ops->map_queue)
 		return -EINVAL;
 
-	if (set->queue_depth > BLK_MQ_MAX_DEPTH) {
+	if (set->queue_depth > BLK_MQ_MAX_DEPTH - set->reserved_tags) {
+		set->queue_depth = BLK_MQ_MAX_DEPTH - set->reserved_tags;
 		pr_info("blk-mq: reduced tag depth to %u\n",
-			BLK_MQ_MAX_DEPTH);
-		set->queue_depth = BLK_MQ_MAX_DEPTH;
+			set->queue_depth);
 	}
 
 	set->tags = kmalloc_node(set->nr_hw_queues *

