Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517AbaBUNpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:45:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46975 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225AbaBUMuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jens Axboe <axboe@kernel.dk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 051/121] block: __elv_next_request() shouldn't call into the elevator if bypassing
Date: Fri, 21 Feb 2014 12:47:55 +0000
Message-Id: <1392986945-9693-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 556ee818c06f37b2e583af0363e6b16d0e0270de upstream.

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
Tested-by: Frank Mayhar <fmayhar@google.com>

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 block/blk.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk.h b/block/blk.h
index e837b8f..b3bdeb3 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -96,7 +96,7 @@ static inline struct request *__elv_next_request(struct request_queue *q)
 			q->flush_queue_delayed = 1;
 			return NULL;
 		}
-		if (unlikely(blk_queue_dying(q)) ||
+		if (unlikely(blk_queue_bypass(q)) ||
 		    !q->elevator->type->ops.elevator_dispatch_fn(q, 0))
 			return NULL;
 	}
-- 
1.9.0

