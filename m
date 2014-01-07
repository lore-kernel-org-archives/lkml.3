Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbaAGAJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:09:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:48538 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757665AbaAGAJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 19:09:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,615,1384329600"; 
   d="scan'208";a="462584900"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Add a sysctl for numa_balancing v2
Date: Mon,  6 Jan 2014 16:08:46 -0800
Message-Id: <1389053326-29462-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

[It turns out the documentation patch was already merged
earlier. So just resending without documentation.]

As discussed earlier, this adds a working sysctl to enable/disable
automatic numa memory balancing at runtime.

This allows to track down performance problems with this
feature and is generally a good idea.

This was possible earlier through debugfs, but only with special
debugging options set. Also fix the boot message.

v2: Remove documentation as the documentation for this
sysctl was already merged earlier.
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/sched/sysctl.h |  4 ++++
 kernel/sched/core.c          | 24 +++++++++++++++++++++++-
 kernel/sysctl.c              |  9 +++++++++
 mm/mempolicy.c               |  2 +-
 4 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index 41467f8..e134535 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -100,4 +100,8 @@ extern int sched_rt_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
 
+extern int sched_numa_balancing(struct ctl_table *table, int write,
+				 void __user *buffer, size_t *lenp,
+				 loff_t *ppos);
+
 #endif /* _SCHED_SYSCTL_H */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a88f4a4..4dc22da 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1763,7 +1763,29 @@ void set_numabalancing_state(bool enabled)
 	numabalancing_enabled = enabled;
 }
 #endif /* CONFIG_SCHED_DEBUG */
-#endif /* CONFIG_NUMA_BALANCING */
+
+#ifdef CONFIG_PROC_SYSCTL
+int sched_numa_balancing(struct ctl_table *table, int write,
+			 void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table t;
+	int err;
+	int state = numabalancing_enabled;
+
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	t = *table;
+	t.data = &state;
+	err = proc_dointvec_minmax(&t, write, buffer, lenp, ppos);
+	if (err < 0)
+		return err;
+	if (write)
+		set_numabalancing_state(state);
+	return err;
+}
+#endif
+#endif
 
 /*
  * fork()/clone()-time setup:
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 34a6047..9e0e790 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -398,6 +398,15 @@ static struct ctl_table kern_table[] = {
 		.mode           = 0644,
 		.proc_handler   = proc_dointvec,
 	},
+	{
+		.procname	= "numa_balancing",
+		.data		= NULL, /* filled in by handler */
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= sched_numa_balancing,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 #endif /* CONFIG_NUMA_BALANCING */
 #endif /* CONFIG_SCHED_DEBUG */
 	{
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0cd2c4d..947293e 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2668,7 +2668,7 @@ static void __init check_numabalancing_enable(void)
 
 	if (nr_node_ids > 1 && !numabalancing_override) {
 		printk(KERN_INFO "Enabling automatic NUMA balancing. "
-			"Configure with numa_balancing= or sysctl");
+			"Configure with numa_balancing= or the kernel.numa_balancing sysctl");
 		set_numabalancing_state(numabalancing_default);
 	}
 }
-- 
1.8.3.1

