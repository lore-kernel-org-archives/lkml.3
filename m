Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030589AbaGRNKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:10:43 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17511 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030524AbaGRNKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:10:38 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 101/170] mm, pcp: allow restoring percpu_pagelist_fraction default
Date: Fri, 18 Jul 2014 14:11:46 +0200
Message-Id: <e77551fdee75c30780804b9f64e23d6c090cf42b.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7cd2b0a34ab8e4db971920eef8982f985441adfb upstream.

Oleg reports a division by zero error on zero-length write() to the
percpu_pagelist_fraction sysctl:

    divide error: 0000 [#1] SMP DEBUG_PAGEALLOC
    CPU: 1 PID: 9142 Comm: badarea_io Not tainted 3.15.0-rc2-vm-nfs+ #19
    Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
    task: ffff8800d5aeb6e0 ti: ffff8800d87a2000 task.ti: ffff8800d87a2000
    RIP: 0010: percpu_pagelist_fraction_sysctl_handler+0x84/0x120
    RSP: 0018:ffff8800d87a3e78  EFLAGS: 00010246
    RAX: 0000000000000f89 RBX: ffff88011f7fd000 RCX: 0000000000000000
    RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000010
    RBP: ffff8800d87a3e98 R08: ffffffff81d002c8 R09: ffff8800d87a3f50
    R10: 000000000000000b R11: 0000000000000246 R12: 0000000000000060
    R13: ffffffff81c3c3e0 R14: ffffffff81cfddf8 R15: ffff8801193b0800
    FS:  00007f614f1e9740(0000) GS:ffff88011f440000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
    CR2: 00007f614f1fa000 CR3: 00000000d9291000 CR4: 00000000000006e0
    Call Trace:
      proc_sys_call_handler+0xb3/0xc0
      proc_sys_write+0x14/0x20
      vfs_write+0xba/0x1e0
      SyS_write+0x46/0xb0
      tracesys+0xe1/0xe6

However, if the percpu_pagelist_fraction sysctl is set by the user, it
is also impossible to restore it to the kernel default since the user
cannot write 0 to the sysctl.

This patch allows the user to write 0 to restore the default behavior.
It still requires a fraction equal to or larger than 8, however, as
stated by the documentation for sanity.  If a value in the range [1, 7]
is written, the sysctl will return EINVAL.

This successfully solves the divide by zero issue at the same time.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Oleg Drokin <green@linuxhacker.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 Documentation/sysctl/vm.txt |  3 ++-
 kernel/sysctl.c             |  3 +--
 mm/page_alloc.c             | 40 ++++++++++++++++++++++++++++------------
 3 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 79a797eb3e87..138fe437bba0 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -664,7 +664,8 @@ The batch value of each per cpu pagelist is also updated as a result.  It is
 set to pcp->high/4.  The upper limit of batch is (PAGE_SHIFT * 8)
 
 The initial value is zero.  Kernel does not use this value at boot time to set
-the high water marks for each per cpu page list.
+the high water marks for each per cpu page list.  If the user writes '0' to this
+sysctl, it will revert to this default behavior.
 
 ==============================================================
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 2a9db916c3f5..167741003616 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -138,7 +138,6 @@ static unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
 static int minolduid;
-static int min_percpu_pagelist_fract = 8;
 
 static int ngroups_max = NGROUPS_MAX;
 static const int cap_last_cap = CAP_LAST_CAP;
@@ -1287,7 +1286,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(percpu_pagelist_fraction),
 		.mode		= 0644,
 		.proc_handler	= percpu_pagelist_fraction_sysctl_handler,
-		.extra1		= &min_percpu_pagelist_fract,
+		.extra1		= &zero,
 	},
 #ifdef CONFIG_MMU
 	{
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a6bf980f5dd0..83aaa49bcba7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -69,6 +69,7 @@
 
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
+#define MIN_PERCPU_PAGELIST_FRACTION	(8)
 
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DEFINE_PER_CPU(int, numa_node);
@@ -4079,7 +4080,7 @@ static void __meminit zone_init_free_lists(struct zone *zone)
 	memmap_init_zone((size), (nid), (zone), (start_pfn), MEMMAP_EARLY)
 #endif
 
-static int __meminit zone_batchsize(struct zone *zone)
+static int zone_batchsize(struct zone *zone)
 {
 #ifdef CONFIG_MMU
 	int batch;
@@ -4195,8 +4196,8 @@ static void pageset_set_high(struct per_cpu_pageset *p,
 	pageset_update(&p->pcp, high, batch);
 }
 
-static void __meminit pageset_set_high_and_batch(struct zone *zone,
-		struct per_cpu_pageset *pcp)
+static void pageset_set_high_and_batch(struct zone *zone,
+				       struct per_cpu_pageset *pcp)
 {
 	if (percpu_pagelist_fraction)
 		pageset_set_high(pcp,
@@ -5789,23 +5790,38 @@ int percpu_pagelist_fraction_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	struct zone *zone;
-	unsigned int cpu;
+	int old_percpu_pagelist_fraction;
 	int ret;
 
+	mutex_lock(&pcp_batch_high_lock);
+	old_percpu_pagelist_fraction = percpu_pagelist_fraction;
+
 	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
-	if (!write || (ret < 0))
-		return ret;
+	if (!write || ret < 0)
+		goto out;
+
+	/* Sanity checking to avoid pcp imbalance */
+	if (percpu_pagelist_fraction &&
+	    percpu_pagelist_fraction < MIN_PERCPU_PAGELIST_FRACTION) {
+		percpu_pagelist_fraction = old_percpu_pagelist_fraction;
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* No change? */
+	if (percpu_pagelist_fraction == old_percpu_pagelist_fraction)
+		goto out;
 
-	mutex_lock(&pcp_batch_high_lock);
 	for_each_populated_zone(zone) {
-		unsigned long  high;
-		high = zone->managed_pages / percpu_pagelist_fraction;
+		unsigned int cpu;
+
 		for_each_possible_cpu(cpu)
-			pageset_set_high(per_cpu_ptr(zone->pageset, cpu),
-					 high);
+			pageset_set_high_and_batch(zone,
+					per_cpu_ptr(zone->pageset, cpu));
 	}
+out:
 	mutex_unlock(&pcp_batch_high_lock);
-	return 0;
+	return ret;
 }
 
 int hashdist = HASHDIST_DEFAULT;
-- 
2.0.0

