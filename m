Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab3A0Xq4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 18:46:56 -0500
Received: from forward11.mail.yandex.net ([95.108.130.93]:53155 "EHLO
	forward11.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848Ab3A0Xqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 18:46:53 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH] sched/rt: Decrease number of calls of push_rt_task() in push_rt_tasks()
MIME-Version: 1.0
Message-Id: <2016751359330408@web20f.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 28 Jan 2013 03:46:48 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch aims to decrease the number of calls of push_rt_task()
in push_rt_tasks().

It's not necessary to push more than 'num_online_cpus() - 1' tasks.
If just pushed task doesn't leave its new CPU during our local call
of push_rt_tasks() than we won't push another task to the CPU.
If it leave or change priority than it will pull new task by itself.

Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: linux-rt-users <linux-rt-users@vger.kernel.org>
---
 kernel/sched/rt.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 4e8f0f4..edf046d 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1703,8 +1703,10 @@ out:
 
 static void push_rt_tasks(struct rq *rq)
 {
+	int num_cpus = num_online_cpus() - 1;
+
 	/* push_rt_task will return true if it moved an RT */
-	while (push_rt_task(rq))
+	while (push_rt_task(rq) && --num_cpus > 0)
 		;
 }
 
