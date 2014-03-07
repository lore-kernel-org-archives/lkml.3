Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaCGNjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:39:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:41106 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbaCGNjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:39:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,607,1389772800"; 
   d="scan'208";a="468389988"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] [RFC] perf: Fix a race between ring_buffer_detach() and ring_buffer_wakeup()
Date: Fri,  7 Mar 2014 15:38:46 +0200
Message-Id: <1394199526-6400-1-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is more of a problem description than an actual bugfix, but currently
ring_buffer_detach() can kick in while ring_buffer_wakeup() is traversing
the ring buffer's event list, leading to cpu stalls.

What this patch does is crude, but fixes the problem, which is: one rcu
grace period has to elapse between ring_buffer_detach() and subsequent
ring_buffer_attach(), otherwise either the attach will fail or the wakeup
will misbehave. Also, making it a call_rcu() callback will make it race
with attach().

Another solution that I see is to check for list_empty(&event->rb_entry)
before wake_up_all() in ring_buffer_wakeup() and restart the list
traversal if it is indeed empty, but that is ugly too as there will be
extra wakeups on some events.

Anything that I'm missing here? Any better ideas?

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/events/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 661951a..bce41e0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3861,7 +3861,7 @@ static void ring_buffer_attach(struct perf_event *event,
 
 	spin_lock_irqsave(&rb->event_lock, flags);
 	if (list_empty(&event->rb_entry))
-		list_add(&event->rb_entry, &rb->event_list);
+		list_add_rcu(&event->rb_entry, &rb->event_list);
 	spin_unlock_irqrestore(&rb->event_lock, flags);
 }
 
@@ -3873,9 +3873,11 @@ static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb)
 		return;
 
 	spin_lock_irqsave(&rb->event_lock, flags);
-	list_del_init(&event->rb_entry);
+	list_del_rcu(&event->rb_entry);
 	wake_up_all(&event->waitq);
 	spin_unlock_irqrestore(&rb->event_lock, flags);
+	synchronize_rcu();
+	INIT_LIST_HEAD(&event->rb_entry);
 }
 
 static void ring_buffer_wakeup(struct perf_event *event)
-- 
1.9.0

