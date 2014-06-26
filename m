Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbaFZJLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:11:11 -0400
Received: from fgwmail2.fujitsu.co.jp ([164.71.1.135]:57080 "EHLO
	fgwmail2.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbaFZJLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:11:08 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <53ABE393.1010506@jp.fujitsu.com>
Date: Thu, 26 Jun 2014 18:10:43 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 3/8] cputime: introduce account_idle_and_iowait
References: <53ABE28F.6010402@jp.fujitsu.com>
In-Reply-To: <53ABE28F.6010402@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current account_idle_time() cannot process mixed cputime which
contain both of idle cputime and iowait cputime.

So introduce new account_idle_and_iowait() to do paranoid work.
Following patches will add users of this new function.

Not-Tested-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 kernel/sched/cputime.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index a028604..283e011 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -240,14 +240,36 @@ void account_steal_time(cputime_t cputime)
 }
 
 /*
+ * Account for idle and iowait time in a dulation.
+ * @idle_enter: time stamp at idle entry
+ * @iowait_exit: time stamp when nr_iowait dropped to 0
+ * @idle_exit: time stamp at idle exit
+ */
+void account_idle_and_iowait(cputime_t idle_enter, cputime_t iowait_exit, cputime_t idle_exit)
+{
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
+	struct rq *rq = this_rq();
+
+	if (rq->nr_iowait > 0 || iowait_exit > idle_exit) {
+		cpustat[CPUTIME_IOWAIT] += (__force u64) idle_exit - idle_enter;
+	} else if (iowait_exit > idle_enter) {
+		cpustat[CPUTIME_IOWAIT] += (__force u64) iowait_exit - idle_enter;
+		cpustat[CPUTIME_IDLE] += (__force u64) idle_exit - iowait_exit;
+	} else {
+		cpustat[CPUTIME_IDLE] += (__force u64) idle_exit - idle_enter;
+	}
+}
+
+/*
  * Account for idle time.
- * @cputime: the cpu time spent in idle wait
+ * @cputime: the cpu time spent in idle wait (sometimes include iowait time)
  */
 void account_idle_time(cputime_t cputime)
 {
 	u64 *cpustat = kcpustat_this_cpu->cpustat;
 	struct rq *rq = this_rq();
 
+	/* FIXME */
 	if (rq->nr_iowait > 0)
 		cpustat[CPUTIME_IOWAIT] += (__force u64) cputime;
 	else
-- 
1.7.1


