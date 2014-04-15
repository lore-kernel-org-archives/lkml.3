Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaDONes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:34:48 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:61961 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752462AbaDONcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:32:52 -0400
X-IronPort-AV: E=Sophos;i="4.97,863,1389715200"; 
   d="scan'208";a="29292485"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <rostedt@goodmis.org>, <fweisbec@gmail.com>, <mingo@redhat.com>,
        <peterz@infradead.org>, <acme@ghostprotocols.net>
CC: <linux-kernel@vger.kernel.org>, Dongsheng <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 3/8] sched/wait: Use __add_wait_queue{_tail}_exclusive() as possible.
Date: Tue, 15 Apr 2014 21:32:52 +0900
Message-ID: <c232d92d5d70daf9b2c58486dc5a182f95edd951.1397562542.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng <yangds.fnst@cn.fujitsu.com>

There is already a function in include/linux/wait.h to cover the
'exclusive' usage. So we can use it in sched/wait.c to replace
the opened implementation of it.

Signed-off-by: Dongsheng <yangds.fnst@cn.fujitsu.com>
---
 kernel/sched/wait.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 283750e..b04827e 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -38,9 +38,8 @@ void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
 	unsigned long flags;
 
 	trace_sched_wait(current);
-	wait->flags |= WQ_FLAG_EXCLUSIVE;
 	spin_lock_irqsave(&q->lock, flags);
-	__add_wait_queue_tail(q, wait);
+	__add_wait_queue_tail_exclusive(q, wait);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 EXPORT_SYMBOL(add_wait_queue_exclusive);
@@ -192,10 +191,9 @@ prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state)
 	unsigned long flags;
 
 	trace_sched_wait(current);
-	wait->flags |= WQ_FLAG_EXCLUSIVE;
 	spin_lock_irqsave(&q->lock, flags);
 	if (list_empty(&wait->task_list))
-		__add_wait_queue_tail(q, wait);
+		__add_wait_queue_tail_exclusive(q, wait);
 	set_current_state(state);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
-- 
1.8.2.1

