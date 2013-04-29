Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab3D3AQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 20:16:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:30739 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757115Ab3D3AQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 20:16:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,576,1363158000"; 
   d="scan'208";a="328563135"
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: [PATCH 1/2] Make the batch size of the percpu_counter configurable
Date: Mon, 29 Apr 2013 10:12:28 -0700
Message-Id: <c1f9c476a8bd1f5e7049b8ac79af48be61afd8f3.1367254913.git.tim.c.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there is a single, global, variable (percpu_counter_batch) that
controls the batch sizes for every 'struct percpu_counter' on the system.

However, there are some applications, e.g. memory accounting where it is
more appropriate to scale the batch size according to the memory size.
This patch adds the infrastructure to be able to change the batch sizes
for each individual instance of 'struct percpu_counter'.

I have chosen to implement the added field of batch as a pointer
(by default point to percpu_counter_batch) instead
of a static value.  The reason is the percpu_counter initialization
can be called when we only have boot cpu and not all cpus are online.
and percpu_counter_batch value have yet to be udpated with a
call to compute_batch_value function.

Thanks to Dave Hansen and Andi Kleen for their comments and suggestions.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 include/linux/percpu_counter.h | 20 +++++++++++++++++++-
 lib/percpu_counter.c           | 23 ++++++++++++++++++++++-
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index d5dd465..5ca7df5 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -22,6 +22,7 @@ struct percpu_counter {
 	struct list_head list;	/* All percpu_counters are on a list */
 #endif
 	s32 __percpu *counters;
+	int *batch ____cacheline_aligned_in_smp;
 };
 
 extern int percpu_counter_batch;
@@ -40,11 +41,22 @@ void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
 s64 __percpu_counter_sum(struct percpu_counter *fbc);
+void __percpu_counter_batch_resize(struct percpu_counter *fbc, int *batch);
 int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs);
 
+static inline int percpu_counter_and_batch_init(struct percpu_counter *fbc,
+			s64 amount, int *batch)
+{
+	int ret = percpu_counter_init(fbc, amount);
+
+	if (batch && !ret)
+		__percpu_counter_batch_resize(fbc, batch);
+	return ret;
+}
+
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
-	__percpu_counter_add(fbc, amount, percpu_counter_batch);
+	__percpu_counter_add(fbc, amount, *fbc->batch);
 }
 
 static inline s64 percpu_counter_sum_positive(struct percpu_counter *fbc)
@@ -95,6 +107,12 @@ static inline int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
 	return 0;
 }
 
+static inline int percpu_counter_and_batch_init(struct percpu_counter *fbc,
+			s64 amount, int *batch)
+{
+	return percpu_counter_init(fbc, amount);
+}
+
 static inline void percpu_counter_destroy(struct percpu_counter *fbc)
 {
 }
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index ba6085d..a75951e 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -116,6 +116,7 @@ int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
 	lockdep_set_class(&fbc->lock, key);
 	fbc->count = amount;
 	fbc->counters = alloc_percpu(s32);
+	fbc->batch = &percpu_counter_batch;
 	if (!fbc->counters)
 		return -ENOMEM;
 
@@ -131,6 +132,26 @@ int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
 }
 EXPORT_SYMBOL(__percpu_counter_init);
 
+void __percpu_counter_batch_resize(struct percpu_counter *fbc, int *batch)
+{
+	unsigned long flags;
+	int cpu;
+
+	if (!batch)
+		return;
+
+	raw_spin_lock_irqsave(&fbc->lock, flags);
+	for_each_online_cpu(cpu) {
+		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
+		fbc->count += *pcount;
+		*pcount = 0;
+	}
+	*batch = max(*batch, percpu_counter_batch);
+	fbc->batch = batch;
+	raw_spin_unlock_irqrestore(&fbc->lock, flags);
+}
+EXPORT_SYMBOL(__percpu_counter_batch_resize);
+
 void percpu_counter_destroy(struct percpu_counter *fbc)
 {
 	if (!fbc->counters)
@@ -196,7 +217,7 @@ int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
 
 	count = percpu_counter_read(fbc);
 	/* Check to see if rough count will be sufficient for comparison */
-	if (abs(count - rhs) > (percpu_counter_batch*num_online_cpus())) {
+	if (abs(count - rhs) > ((*fbc->batch)*num_online_cpus())) {
 		if (count > rhs)
 			return 1;
 		else
-- 
1.7.11.7

