Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab3LBPU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:20:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab3LBPUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:20:23 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: fix mq request allocation
References: <1385890077-30873-1-git-send-email-tom.leiming@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 02 Dec 2013 10:20:08 -0500
In-Reply-To: <1385890077-30873-1-git-send-email-tom.leiming@gmail.com> (Ming
	Lei's message of "Sun, 1 Dec 2013 17:27:57 +0800")
Message-ID: <x49ob4z700n.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei <tom.leiming@gmail.com> writes:

> blk_mq_alloc_request_pinned() may return NULL request in case of
> !__GFP_WAIT, so cause its callers to derefence NULL pointer for
> releasing current context.
>
> This patch introduces two flags to address the issue.

Hi, Ming,


Good catch, but your patch seems overly complicated.  How about
something like the following (compile-tested only), instead?  Note that
I did not touch blk_make_request, as the put_ctx there seems to
correlate to a get_ctx earlier in the function (not a leaked reference
from __blk_mq_alloc_request).

-Jeff

p.s. Jens, every time I see GFP_ATOMIC|__GFP_WAIT, my head explodes.  Just sayin'.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>


diff --git a/block/blk-mq.c b/block/blk-mq.c
index cdc629c..70fd6f9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -202,10 +202,12 @@ static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
 		if (rq) {
 			blk_mq_rq_ctx_init(q, ctx, rq, rw);
 			break;
-		} else if (!(gfp & __GFP_WAIT))
-			break;
+		}
 
 		blk_mq_put_ctx(ctx);
+		if (!(gfp & __GFP_WAIT))
+			break;
+
 		__blk_mq_run_hw_queue(hctx);
 		blk_mq_wait_for_tags(hctx->tags);
 	} while (1);
@@ -222,7 +224,8 @@ struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
 		return NULL;
 
 	rq = blk_mq_alloc_request_pinned(q, rw, gfp, reserved);
-	blk_mq_put_ctx(rq->mq_ctx);
+	if (rq)
+		blk_mq_put_ctx(rq->mq_ctx);
 	return rq;
 }
 
@@ -235,7 +238,8 @@ struct request *blk_mq_alloc_reserved_request(struct request_queue *q, int rw,
 		return NULL;
 
 	rq = blk_mq_alloc_request_pinned(q, rw, gfp, true);
-	blk_mq_put_ctx(rq->mq_ctx);
+	if (rq)
+		blk_mq_put_ctx(rq->mq_ctx);
 	return rq;
 }
 EXPORT_SYMBOL(blk_mq_alloc_reserved_request);
