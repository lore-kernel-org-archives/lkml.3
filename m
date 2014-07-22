Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbaGVWLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:11:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:26886 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263AbaGVWJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:09:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,712,1400050800"; 
   d="scan'208";a="547426897"
Subject: [PATCH v5 1/7] sched: Add function single_task_running to let a
 task check if it is the only task running on a cpu
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tadeusz Struk <tadeusz.struk@intel.com>, tkhai@yandex.ru,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <cover.1406033477.git.tim.c.chen@linux.intel.com>
References: <cover.1406033477.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Jul 2014 15:09:29 -0700
Message-ID: <1406066969.2970.803.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function will help an async task processing batched jobs from workqueue
decide if it wants to keep processing on more chunks of batched work that
can be delayed, or to accumulate more work for more efficient batched
processing later.

If no other tasks are running on the cpu, it can take advantgae of
the available cpu cycles to complete the existing accumulated work for
immediate processing to minimize delay, otherwise it will yield.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 include/linux/sched.h |  1 +
 kernel/sched/core.c   | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7cb07fd..eefa943 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -168,6 +168,7 @@ extern int nr_threads;
 DECLARE_PER_CPU(unsigned long, process_counts);
 extern int nr_processes(void);
 extern unsigned long nr_running(void);
+extern bool single_task_running(void);
 extern unsigned long nr_iowait(void);
 extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9cae286..03c8675 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2283,6 +2283,18 @@ unsigned long nr_running(void)
 	return sum;
 }
 
+/*
+ * Check if only the current task is running on the cpu.
+ */
+bool single_task_running(void)
+{
+	if (cpu_rq(smp_processor_id())->nr_running == 1)
+		return true;
+	else
+		return false;
+}
+EXPORT_SYMBOL(single_task_running);
+
 unsigned long long nr_context_switches(void)
 {
 	int i;
-- 
1.7.11.7



