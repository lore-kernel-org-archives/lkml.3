Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaHDNbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:31:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:56877 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbaHDNbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:31:35 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] perf: do poll_wait() before checking condition in perf_poll()
Date: Mon,  4 Aug 2014 15:31:08 +0200
Message-Id: <1407159068-1478-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.1
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One should first enqueue to the waitqueue and then check for the
condition. If the condition gets true after mutex_unlock() but before
poll_wait() then we lose it and would have wait for another wakeup.

This has been like this since v2.6.31-rc1 commit c7138f37f9 ("perf_counter:
fix perf_poll()"). Before that it was slightly worse. I guess we get enough
wakeups so if we miss here one it doesn't really matter. It is still a
bad example.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
I haven't Cc stable@vger.kernel.org since nobody cared about this  since
day one.

 kernel/events/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 6b17ac1..4aa3375 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3528,6 +3528,7 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 	struct ring_buffer *rb;
 	unsigned int events = POLL_HUP;
 
+	poll_wait(file, &event->waitq, wait);
 	/*
 	 * Pin the event->rb by taking event->mmap_mutex; otherwise
 	 * perf_event_set_output() can swizzle our rb and make us miss wakeups.
@@ -3537,9 +3538,6 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 	if (rb)
 		events = atomic_xchg(&rb->poll, 0);
 	mutex_unlock(&event->mmap_mutex);
-
-	poll_wait(file, &event->waitq, wait);
-
 	return events;
 }
 
-- 
2.0.1

