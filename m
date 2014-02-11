Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbaBKUzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:55:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbaBKTF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:05:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Mel Gorman <mgorman@suse.de>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.13 062/120] numa: add a sysctl for numa_balancing
Date: Tue, 11 Feb 2014 11:05:03 -0800
Message-Id: <20140211184825.388910627@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Kleen <ak@linux.intel.com>

commit 54a43d54988a3731d644fdeb7a1d6f46b4ac64c7 upstream.

Add a working sysctl to enable/disable automatic numa memory balancing
at runtime.

This allows us to track down performance problems with this feature and
is generally a good idea.

This was possible earlier through debugfs, but only with special
debugging options set.  Also fix the boot message.

[akpm@linux-foundation.org: s/sched_numa_balancing/sysctl_numa_balancing/]
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/sched/sysctl.h |    4 ++++
 kernel/sched/core.c          |   24 +++++++++++++++++++++++-
 kernel/sysctl.c              |    9 +++++++++
 mm/mempolicy.c               |    2 +-
 4 files changed, 37 insertions(+), 2 deletions(-)

--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -100,4 +100,8 @@ extern int sched_rt_handler(struct ctl_t
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
 
+extern int sysctl_numa_balancing(struct ctl_table *table, int write,
+				 void __user *buffer, size_t *lenp,
+				 loff_t *ppos);
+
 #endif /* _SCHED_SYSCTL_H */
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1763,7 +1763,29 @@ void set_numabalancing_state(bool enable
 	numabalancing_enabled = enabled;
 }
 #endif /* CONFIG_SCHED_DEBUG */
-#endif /* CONFIG_NUMA_BALANCING */
+
+#ifdef CONFIG_PROC_SYSCTL
+int sysctl_numa_balancing(struct ctl_table *table, int write,
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
+		.proc_handler	= sysctl_numa_balancing,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 #endif /* CONFIG_NUMA_BALANCING */
 #endif /* CONFIG_SCHED_DEBUG */
 	{
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2668,7 +2668,7 @@ static void __init check_numabalancing_e
 
 	if (nr_node_ids > 1 && !numabalancing_override) {
 		printk(KERN_INFO "Enabling automatic NUMA balancing. "
-			"Configure with numa_balancing= or sysctl");
+			"Configure with numa_balancing= or the kernel.numa_balancing sysctl");
 		set_numabalancing_state(numabalancing_default);
 	}
 }


