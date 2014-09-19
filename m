Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbaISLoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:44:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56013 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898AbaISLoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:44:37 -0400
Date: Fri, 19 Sep 2014 04:43:45 -0700
From: tip-bot for Chuansheng Liu <tipbot@zytor.com>
Message-ID: <tip-f6be8af1c95de4a46e325e728900a70ceadb52cf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        luto@amacapital.net, tglx@linutronix.de, chuansheng.liu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        luto@amacapital.net, tglx@linutronix.de, chuansheng.liu@intel.com
In-Reply-To: <1409815075-4180-1-git-send-email-chuansheng.liu@intel.com>
References: <1409815075-4180-1-git-send-email-chuansheng.liu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add new API wake_up_if_idle()
  to wake up the idle cpu
Git-Commit-ID: f6be8af1c95de4a46e325e728900a70ceadb52cf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f6be8af1c95de4a46e325e728900a70ceadb52cf
Gitweb:     http://git.kernel.org/tip/f6be8af1c95de4a46e325e728900a70ceadb52cf
Author:     Chuansheng Liu <chuansheng.liu@intel.com>
AuthorDate: Thu, 4 Sep 2014 15:17:53 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 12:35:14 +0200

sched: Add new API wake_up_if_idle() to wake up the idle cpu

Implementing one new API wake_up_if_idle(), which is used to
wake up the idle CPU.

Suggested-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: daniel.lezcano@linaro.org
Cc: rjw@rjwysocki.net
Cc: linux-pm@vger.kernel.org
Cc: changcheng.liu@intel.com
Cc: xiaoming.wang@intel.com
Cc: souvik.k.chakravarty@intel.com
Cc: chuansheng.liu@intel.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1409815075-4180-1-git-send-email-chuansheng.liu@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |  1 +
 kernel/sched/core.c   | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index dd9eb48..82ff3d6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1024,6 +1024,7 @@ struct sched_domain_topology_level {
 extern struct sched_domain_topology_level *sched_domain_topology;
 
 extern void set_sched_topology(struct sched_domain_topology_level *tl);
+extern void wake_up_if_idle(int cpu);
 
 #ifdef CONFIG_SCHED_DEBUG
 # define SD_INIT_NAME(type)		.name = #type
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 78e5c83..f7c6ed2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1634,6 +1634,25 @@ static void ttwu_queue_remote(struct task_struct *p, int cpu)
 	}
 }
 
+void wake_up_if_idle(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
+
+	if (!is_idle_task(rq->curr))
+		return;
+
+	if (set_nr_if_polling(rq->idle)) {
+		trace_sched_wake_idle_without_ipi(cpu);
+	} else {
+		raw_spin_lock_irqsave(&rq->lock, flags);
+		if (is_idle_task(rq->curr))
+			smp_send_reschedule(cpu);
+		/* Else cpu is not in idle, do nothing here */
+		raw_spin_unlock_irqrestore(&rq->lock, flags);
+	}
+}
+
 bool cpus_share_cache(int this_cpu, int that_cpu)
 {
 	return per_cpu(sd_llc_id, this_cpu) == per_cpu(sd_llc_id, that_cpu);
