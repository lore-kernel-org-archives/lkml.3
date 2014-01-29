Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaA2U0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 15:26:40 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:49558 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaA2U0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 15:26:39 -0500
Date: Wed, 29 Jan 2014 15:26:33 -0500
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Frank Mayhar <fmayhar@google.com>
Subject: [PATCH] block: __elv_next_request() shouldn't call into the elevator
 if bypassing
Message-ID: <20140129202633.GQ30842@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

request_queue bypassing is used to suppress higher-level function of a
request_queue so that they can be switched, reconfigured and shut
down.  A request_queue does the followings while bypassing.

* bypasses elevator and io_cq association and queues requests directly
  to the FIFO dispatch queue.

* bypasses block cgroup request_list lookup and always uses the root
  request_list.

Once confirmed to be bypassing, specific elevator and block cgroup
policy implementations can assume that nothing is in flight for them
and perform various operations which would be dangerous otherwise.

Such confirmation is acheived by short-circuiting all new requests
directly to the dispatch queue and waiting for all the requests which
were issued before to finish.  Unfortunately, while the request
allocating and draining sides were properly handled, we forgot to
actually plug the request dispatch path.  Even after bypassing mode is
confirmed, if the attached driver tries to fetch a request and the
dispatch queue is empty, __elv_next_request() would invoke the current
elevator's elevator_dispatch_fn() callback.  As all in-flight requests
were drained, the elevator wouldn't contain any request but once
bypass is confirmed we don't even know whether the elevator is even
there.  It might be in the process of being switched and half torn
down.

Frank Mayhar reports that this actually happened while switching
elevators, leading to an oops.

Let's fix it by making __elv_next_request() avoid invoking the
elevator_dispatch_fn() callback if the queue is bypassing.  It already
avoids invoking the callback if the queue is dying.  As a dying queue
is guaranteed to be bypassing, we can simply replace blk_queue_dying()
check with blk_queue_bypass().

Reported-by: Frank Mayhar <fmayhar@google.com>
References: http://lkml.kernel.org/g/1390319905.20232.38.camel@bobble.lax.corp.google.com
Cc: stable@vger.kernel.org
---
Hello,

Sorry about the delay.  Frank, if your test is still holding up, can
you please reply with Tested-by?

Thanks!

 block/blk.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk.h b/block/blk.h
index c90e1d8..d23b415 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -113,7 +113,7 @@ static inline struct request *__elv_next_request(struct request_queue *q)
 			q->flush_queue_delayed = 1;
 			return NULL;
 		}
-		if (unlikely(blk_queue_dying(q)) ||
+		if (unlikely(blk_queue_bypass(q)) ||
 		    !q->elevator->type->ops.elevator_dispatch_fn(q, 0))
 			return NULL;
 	}
