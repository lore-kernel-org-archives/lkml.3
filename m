Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbaIQNwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 09:52:42 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:40828 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402AbaIQNwk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 09:52:40 -0400
Date: Wed, 17 Sep 2014 21:52:26 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        KVM list <kvm@vger.kernel.org>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org >> Linux Kernel Mailing List" 
	<linux-kernel@vger.kernel.org>
Subject: Re: blk-mq crash under KVM in multiqueue block code (with
 virtio-blk and ext4)
Message-ID: <20140917215226.426f6ce7@tom-ThinkPad-T410>
In-Reply-To: <20140917140034.10125d00@thinkpad-w530>
References: <541178D6.6010303@de.ibm.com>
	<CACVXFVO7Oo9GeagPhejngfoeySxOP4EqWz_GN6kYv2956-Wtxg@mail.gmail.com>
	<541352ED.7030800@de.ibm.com>
	<54193F4F.9060508@de.ibm.com>
	<20140917140034.10125d00@thinkpad-w530>
Organization: Ming
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2014 14:00:34 +0200
David Hildenbrand <dahi@linux.vnet.ibm.com> wrote:

> > >>> Does anyone have an idea?
> > >>> The request itself is completely filled with cc
> > >>
> > >> That is very weird, the 'rq' is got from hctx->tags,  and rq should be
> > >> valid, and rq->q shouldn't have been changed even though it was
> > >> double free or double allocation.
> > >>
> > >>> I am currently asking myself if blk_mq_map_request should protect against softirq here but I cant say for sure,as I have never looked into that code before.
> > >>
> > >> No, it needn't the protection.
> > >>
> > >> Thanks,
> > >>
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe kvm" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > 
> 
> Digging through the code, I think I found a possible cause:
> 
> tags->rqs[..] is not initialized with zeroes (via alloc_pages_node in
> blk-mq.c:blk_mq_init_rq_map()).

Yes, it may cause problem when the request is allocated at the 1st time,
and timeout handler may comes just after the allocation and before its
initialization, then oops triggered because of garbage data in the request. 

--
>From ffd0824b7b686074c2d5d70bc4e6bba3ba56a30c Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@canonical.com>
Date: Wed, 17 Sep 2014 21:00:34 +0800
Subject: [PATCH] blk-mq: initialize request before the 1st allocation

Otherwise the request can be accessed from timeout handler
just after its 1st allocation from tag pool and before
initialization in blk_mq_rq_ctx_init(), so cause oops since
the request is filled up with garbage data.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-mq.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4aac826..d24673f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -514,6 +514,10 @@ struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag)
 {
 	struct request *rq = tags->rqs[tag];
 
+	/* uninitialized request */
+	if (!rq->q || rq->tag == -1)
+		return rq;
+
 	if (!is_flush_request(rq, tag))
 		return rq;
 
@@ -1401,6 +1405,12 @@ static struct blk_mq_tags *blk_mq_init_rq_map(struct blk_mq_tag_set *set,
 		left -= to_do * rq_size;
 		for (j = 0; j < to_do; j++) {
 			tags->rqs[i] = p;
+
+			/* Avoiding early access from timeout handler */
+			tags->rqs[i]->tag = -1;
+			tags->rqs[i]->q = NULL;
+			tags->rqs[i]->cmd_flags = 0;
+
 			if (set->ops->init_request) {
 				if (set->ops->init_request(set->driver_data,
 						tags->rqs[i], hctx_idx, i,
-- 
1.7.9.5





-- 
Ming Lei
