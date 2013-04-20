Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab3DTHhb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 03:37:31 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:3308 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab3DTHh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 03:37:29 -0400
Message-ID: <517245A4.7050601@huawei.com>
Date: Sat, 20 Apr 2013 15:37:08 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-rt-users@vger.kernel.org>
Subject: [PATCH] relay: fix timer madness
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ingo, Steven, I get this patch from 3.4 preempt-rt patch set, It seems that this patch
fix relayfs bug not only for rt kernel, but also for mainline.

When I'm using below ktap script to tracing all event tracepoints, without this patch,
the system will hang in few seconds, the patch indeed fix the problem as the changelog pointed.

	function eventfun (e) {
        	printf("%d %d\t%s\t%s", cpu(), pid(), execname(), e.annotate)
	}

	kdebug.probe("tp:", eventfun)

	kdebug.probe_end(function () {
        	printf("probe end\n")
	})


This patch is old, I can found the original patch discussion in 2007.
	http://marc.info/?l=linux-kernel&m=118544794717162&w=2
(In that mail thread, the patch didn't fix that problem, but it fix the problem I encountered now)

I hope you can remember this :)

so why we didn't commit this patch into mainline? any concern?

Thanks.

------------------------------------->
Subject: relay: fix timer madness
From: Ingo Molnar <mingo@elte.hu>

remove timer calls (!!!) from deep within the tracing infrastructure.
This was totally bogus code that can cause lockups and worse.
Poll the buffer every 2 jiffies for now.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/relay.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

Index: linux-rt-rebase.q/kernel/relay.c
===================================================================
--- linux-rt-rebase.q.orig/kernel/relay.c
+++ linux-rt-rebase.q/kernel/relay.c
@@ -319,6 +319,10 @@ static void wakeup_readers(unsigned long
 {
 	struct rchan_buf *buf = (struct rchan_buf *)data;
 	wake_up_interruptible(&buf->read_wait);
+	/*
+	 * Stupid polling for now:
+	 */
+	mod_timer(&buf->timer, jiffies + 1);
 }

 /**
@@ -336,6 +340,7 @@ static void __relay_reset(struct rchan_b
 		init_waitqueue_head(&buf->read_wait);
 		kref_init(&buf->kref);
 		setup_timer(&buf->timer, wakeup_readers, (unsigned long)buf);
+		mod_timer(&buf->timer, jiffies + 1);
 	} else
 		del_timer_sync(&buf->timer);

@@ -604,15 +609,6 @@ size_t relay_switch_subbuf(struct rchan_
 		buf->subbufs_produced++;
 		buf->dentry->d_inode->i_size += buf->chan->subbuf_size -
 			buf->padding[old_subbuf];
-		smp_mb();
-		if (waitqueue_active(&buf->read_wait))
-			/*
-			 * Calling wake_up_interruptible() from here
-			 * will deadlock if we happen to be logging
-			 * from the scheduler (trying to re-grab
-			 * rq->lock), so defer it.
-			 */
-			__mod_timer(&buf->timer, jiffies + 1);
 	}

 	old = buf->data;

