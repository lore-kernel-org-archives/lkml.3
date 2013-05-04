Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934395Ab3EDBBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 21:01:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4282 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763888Ab3EDBAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 21:00:19 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=qG7RpOPRgB0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=OCyYj56mPHQA:10 a=KKAkSRfTAAAA:8 a=UPm3pfgAAAAA:8 a=JfrnYn6hAAAA:8 a=VnNF1IyMAAAA:8 a=NVWPg5iwp2uxMJHX2t0A:9 a=WwgC8nHKvroA:10 a=mOio7EKfaG4A:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130504010017.042282567@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 03 May 2013 21:00:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, Josh Triplett <josh@joshtriplett.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RT 5/6] sched: Add is_idle_task() to handle invalidated uses of idle_cpu()
References: <20130504005955.061874443@goodmis.org>
Content-Disposition: inline; filename=0005-sched-Add-is_idle_task-to-handle-invalidated-uses-of.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Commit 908a3283 (Fix idle_cpu()) invalidated some uses of idle_cpu(),
which used to say whether or not the CPU was running the idle task,
but now instead says whether or not the CPU is running the idle task
in the absence of pending wakeups.  Although this new implementation
gives a better answer to the question "is this CPU idle?", it also
invalidates other uses that were made of idle_cpu().

This commit therefore introduces a new is_idle_task() API member
that determines whether or not the specified task is one of the
idle tasks, allowing open-coded "->pid == 0" sequences to be replaced
by something more meaningful.

Suggested-by: Josh Triplett <josh@joshtriplett.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/sched.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 41c0979..dddabbb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2163,6 +2163,14 @@ extern int sched_setscheduler(struct task_struct *, int,
 extern int sched_setscheduler_nocheck(struct task_struct *, int,
 				      const struct sched_param *);
 extern struct task_struct *idle_task(int cpu);
+/**
+ * is_idle_task - is the specified task an idle task?
+ * @tsk: the task in question.
+ */
+static inline bool is_idle_task(struct task_struct *p)
+{
+	return p->pid == 0;
+}
 extern struct task_struct *curr_task(int cpu);
 extern void set_curr_task(int cpu, struct task_struct *p);
 
-- 
1.7.10.4


