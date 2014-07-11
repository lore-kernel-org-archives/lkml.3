Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaGKUdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 16:33:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:53143 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbaGKUdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 16:33:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,644,1400050800"; 
   d="scan'208";a="542196870"
Subject: [PATCH v4 6/7] sched: add function nr_running_cpu to expose number
 of tasks running on cpu
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <cover.1405074379.git.tim.c.chen@linux.intel.com>
References: <cover.1405074379.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Jul 2014 13:33:04 -0700
Message-ID: <1405110784.2970.655.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function will help a thread decide if it wants to to do work
that can be delayed, to accumulate more tasks for more efficient
batch processing later.

However, if no other tasks are running on the cpu, it can take
advantgae of the available cpu cycles to complete the tasks
for immediate processing to minimize delay, otherwise it will yield.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 include/linux/sched.h | 1 +
 kernel/sched/core.c   | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7cb07fd..0884250 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -168,6 +168,7 @@ extern int nr_threads;
 DECLARE_PER_CPU(unsigned long, process_counts);
 extern int nr_processes(void);
 extern unsigned long nr_running(void);
+extern unsigned long nr_running_cpu(int cpu);
 extern unsigned long nr_iowait(void);
 extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9cae286..d5bb8e6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2283,6 +2283,14 @@ unsigned long nr_running(void)
 	return sum;
 }
 
+unsigned long nr_running_cpu(int cpu)
+{
+	if (cpumask_test_cpu(cpu, cpu_online_mask))
+		return cpu_rq(cpu)->nr_running;
+	else
+		return 0;
+}
+
 unsigned long long nr_context_switches(void)
 {
 	int i;
-- 
1.7.11.7



