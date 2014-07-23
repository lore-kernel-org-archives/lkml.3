Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbaGWCrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:47:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:34285 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981AbaGWCea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:34:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="573975069"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, paulus@samba.org,
        benh@kernel.crashing.org, tony.luck@intel.com, hpa@zytor.com,
        jkosina@suse.cz, rafael.j.wysocki@intel.com, bp@alien8.de,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com,
        "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [RFC PATCH v1 29/70] kernel, sched, core: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:05 -0400
Message-Id: <1406080786-3938-30-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from sched/core.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 kernel/sched/core.c | 55 ++++++++++++++++++++++++-----------------------------
 1 file changed, 25 insertions(+), 30 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index bc1638b..f0aff5f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -459,13 +459,10 @@ hotplug_hrtick(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	int cpu = (int)(long)hcpu;
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		hrtick_clear(cpu_rq(cpu));
 		return NOTIFY_OK;
 	}
@@ -6742,30 +6739,28 @@ static int num_cpus_frozen;	/* used to mark begin/end of suspend/resume */
 static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
 			     void *hcpu)
 {
-	switch (action) {
-	case CPU_ONLINE_FROZEN:
-	case CPU_DOWN_FAILED_FROZEN:
-
-		/*
-		 * num_cpus_frozen tracks how many CPUs are involved in suspend
-		 * resume sequence. As long as this is not the last online
-		 * operation in the resume sequence, just build a single sched
-		 * domain, ignoring cpusets.
-		 */
-		num_cpus_frozen--;
-		if (likely(num_cpus_frozen)) {
-			partition_sched_domains(1, NULL, NULL);
-			break;
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_ONLINE:
+	case CPU_DOWN_FAILED:
+		if (action & CPU_TASKS_FROZEN) {
+			/*
+			 * num_cpus_frozen tracks how many CPUs are involved
+			 * in suspend resume sequence. As long as this is not
+			 * the last online operation in the resume sequence,
+			 * just build a single sched domain, ignoring cpusets.
+			 */
+			num_cpus_frozen--;
+			if (likely(num_cpus_frozen)) {
+				partition_sched_domains(1, NULL, NULL);
+				break;
+			}
 		}
 
 		/*
-		 * This is the last CPU online operation. So fall through and
-		 * restore the original sched domains by considering the
-		 * cpuset configurations.
+		 * This is the last CPU online operation. So restore the
+		 * original sched domains by considering the cpuset
+		 * configurations.
 		 */
-
-	case CPU_ONLINE:
-	case CPU_DOWN_FAILED:
 		cpuset_update_active_cpus(true);
 		break;
 	default:
@@ -6777,13 +6772,13 @@ static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
 static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
 			       void *hcpu)
 {
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
-		cpuset_update_active_cpus(false);
-		break;
-	case CPU_DOWN_PREPARE_FROZEN:
-		num_cpus_frozen++;
-		partition_sched_domains(1, NULL, NULL);
+		if (action & CPU_TASKS_FROZEN) {
+			num_cpus_frozen++;
+			partition_sched_domains(1, NULL, NULL);
+		} else
+			cpuset_update_active_cpus(false);
 		break;
 	default:
 		return NOTIFY_DONE;
-- 
2.0.0.rc2

