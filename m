Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab3GJCUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 22:20:37 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:41073 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab3GJCUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 22:20:36 -0400
Message-ID: <51DCC48E.8050003@huawei.com>
Date: Wed, 10 Jul 2013 10:18:54 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Dumazet <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH V2] relay: fix timer madness
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I'm using ktap script to tracing all event tracepoints by relay
transport, without this patch, the system will hang in few seconds.

I found the original patch discussion in 2007.
http://marc.info/?l=linux-kernel&m=118544794717162&w=2
(In that mail thread, the patch didn't fix that problem, but it fix
the problem I encountered now)

Changed from v1:
mod timer interval changed from jiffies+1 to HZ/10, as Ingo suggested.

Original patch changelog from Ingo in 2007:

Remove timer calls (!!!) from deep within the tracing infrastructure.
This was totally bogus code that can cause lockups and worse.
Poll the buffer every 2 jiffies for now.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/relay.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index b91488b..87af4ce 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -339,6 +339,10 @@ static void wakeup_readers(unsigned long data)
 {
 	struct rchan_buf *buf = (struct rchan_buf *)data;
 	wake_up_interruptible(&buf->read_wait);
+	/*
+	 * Stupid polling for now:
+	 */
+	mod_timer(&buf->timer, HZ / 10);
 }

 /**
@@ -356,6 +360,7 @@ static void __relay_reset(struct rchan_buf *buf, unsigned int init)
 		init_waitqueue_head(&buf->read_wait);
 		kref_init(&buf->kref);
 		setup_timer(&buf->timer, wakeup_readers, (unsigned long)buf);
+		mod_timer(&buf->timer, HZ / 10);
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


