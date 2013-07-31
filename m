Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508Ab3GaKBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 06:01:39 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:51363 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759068Ab3GaKBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 06:01:38 -0400
Message-ID: <51F8E06C.1010408@huawei.com>
Date: Wed, 31 Jul 2013 18:01:16 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Dumazet <edumazet@google.com>
Subject: [PATCH] relay: fix timer madness
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

When I'm using ktap script to tracing all event tracepoints by relay
transport, without this patch, the system will hang in few seconds.

I found the original patch discussion in 2007.
http://marc.info/?l=linux-kernel&m=118544794717162&w=2
(In that mail thread, the patch didn't fix that problem, but it fix
the problem I encountered now)

Changed from origina patch:
 - mod timer interval changed from jiffies+1 to HZ/10, as Ingo suggested.
 - mod timer interval changed from HZ/10 to jiffies + HZ/10, suggested
   by Dan Carpenter, since mod_timer() takes an offset for interval.

Original patch changelog from Ingo in 2007:

  Remove timer calls (!!!) from deep within the tracing infrastructure.
  This was totally bogus code that can cause lockups and worse.
  Poll the buffer every 2 jiffies for now.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Dumazet <edumazet@google.com>
---
 kernel/relay.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index b91488b..42d6de3 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -339,6 +339,10 @@ static void wakeup_readers(unsigned long data)
 {
 	struct rchan_buf *buf = (struct rchan_buf *)data;
 	wake_up_interruptible(&buf->read_wait);
+	/*
+	 * Stupid polling for now:
+	 */
+	mod_timer(&buf->timer, jiffies + HZ / 10);
 }

 /**
@@ -356,6 +360,7 @@ static void __relay_reset(struct rchan_buf *buf, unsigned int init)
 		init_waitqueue_head(&buf->read_wait);
 		kref_init(&buf->kref);
 		setup_timer(&buf->timer, wakeup_readers, (unsigned long)buf);
+		mod_timer(&buf->timer, jiffies + HZ / 10);
 	} else
 		del_timer_sync(&buf->timer);

@@ -739,15 +744,6 @@ size_t relay_switch_subbuf(struct rchan_buf *buf, size_t length)
 		else
 			buf->early_bytes += buf->chan->subbuf_size -
 					    buf->padding[old_subbuf];
-		smp_mb();
-		if (waitqueue_active(&buf->read_wait))
-			/*
-			 * Calling wake_up_interruptible() from here
-			 * will deadlock if we happen to be logging
-			 * from the scheduler (trying to re-grab
-			 * rq->lock), so defer it.
-			 */
-			mod_timer(&buf->timer, jiffies + 1);
 	}

 	old = buf->data;
-- 
1.7.9.7


