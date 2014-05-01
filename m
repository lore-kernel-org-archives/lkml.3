Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaEAJ32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:29:28 -0400
Received: from forward8l.mail.yandex.net ([84.201.143.141]:49053 "EHLO
	forward8l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbaEAJ31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:29:27 -0400
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 May 2014 05:29:26 EDT
X-Yandex-Uniq: 3f0d7500-c92f-43c2-a677-b3076b35b665
Authentication-Results: smtp17.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <5362122B.8060305@yandex.ru>
Date: Thu, 01 May 2014 13:21:47 +0400
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [RFC] rtmutex: Do not boost fair tasks each other
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Higher priority does not provide exclusive privilege
of one fair task over the other. In this case priority
boosting looks excess.

On RT patch with enabled PREEMPT_RT_FULL I see a lot of
rt_mutex_setprio() actions like

	120 -> 118
	118 -> 120

They harm RT tasks.

RT patch has lazy preemtion feature, so if idea is we care
about excess preemption inside fair class, we should care
about excess priority inheritance too.

In case of vanila kernel the problem is the same, but there
are no so many rt mutexes. Do I skip anything?

Kirill
---
 kernel/locking/rtmutex.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index aa4dff0..609a57e 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -197,11 +197,14 @@ rt_mutex_dequeue_pi(struct task_struct *task,
struct rt_mutex_waiter *waiter)
  */
 int rt_mutex_getprio(struct task_struct *task)
 {
-	if (likely(!task_has_pi_waiters(task)))
-		return task->normal_prio;
+	if (unlikely(task_has_pi_waiters(task))) {
+		int prio = task_top_pi_waiter(task)->prio;
+
+		if (rt_prio(prio) || dl_prio(prio))
+			return min(prio, task->normal_prio);
+	}

-	return min(task_top_pi_waiter(task)->prio,
-		   task->normal_prio);
+	return task->normal_prio;
 }

 struct task_struct *rt_mutex_get_top_task(struct task_struct *task)
@@ -218,10 +221,14 @@ struct task_struct *rt_mutex_get_top_task(struct
task_struct *task)
  */
 int rt_mutex_check_prio(struct task_struct *task, int newprio)
 {
-	if (!task_has_pi_waiters(task))
-		return 0;
+	if (unlikely(task_has_pi_waiters(task))) {
+		int prio = task_top_pi_waiter(task)->task->prio;

-	return task_top_pi_waiter(task)->task->prio <= newprio;
+		if (rt_prio(prio) || dl_prio(prio))
+			return prio <= newprio;
+	}
+
+	return 0;
 }

 /*
