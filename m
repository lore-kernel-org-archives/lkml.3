Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935224AbaGXKUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:20:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54723 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382AbaGXJrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 027/128] mm, pcp: allow restoring percpu_pagelist_fraction default
Date: Thu, 24 Jul 2014 10:44:36 +0100
Message-Id: <1406195177-8656-28-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rientjes <rientjes@google.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 Documentation/sysctl/vm.txt |  3 ++-
 kernel/sysctl.c             |  3 +--
 mm/page_alloc.c             | 40 ++++++++++++++++++++++++++++------------
 3 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 36ecc26c7433..d958ed640cee 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -656,7 +656,8 @@ The batch value of each per cpu pagelist is also updated as a result.  It is
 set to pcp->high/4.  The upper limit of batch is (PAGE_SHIFT * 8)
 
 The initial value is zero.  Kernel does not use this value at boot time to set
-the high water marks for each per cpu page list.
+the high water marks for each per cpu page list.  If the user writes '0' to this
+sysctl, it will revert to this default behavior.
 
 ==============================================================
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8515e5f93fc4..134216d752df 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -138,7 +138,6 @@ static unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
 static int minolduid;
-static int min_percpu_pagelist_fract = 8;
 
 static int ngroups_max = NGROUPS_MAX;
 static const int cap_last_cap = CAP_LAST_CAP;
@@ -1293,7 +1292,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(percpu_pagelist_fraction),
 		.mode		= 0644,
 		.proc_handler	= percpu_pagelist_fraction_sysctl_handler,
-		.extra1		= &min_percpu_pagelist_fract,
+		.extra1		= &zero,
 	},
 #ifdef CONFIG_MMU
 	{
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4b545f5595e4..6a2b267a521f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -68,6 +68,7 @@
 
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
+#define MIN_PERCPU_PAGELIST_FRACTION	(8)
 
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DEFINE_PER_CPU(int, numa_node);
@@ -3988,7 +3989,7 @@ static void __meminit zone_init_free_lists(struct zone *zone)
 	memmap_init_zone((size), (nid), (zone), (start_pfn), MEMMAP_EARLY)
 #endif
 
-static int __meminit zone_batchsize(struct zone *zone)
+static int zone_batchsize(struct zone *zone)
 {
 #ifdef CONFIG_MMU
 	int batch;
@@ -4104,8 +4105,8 @@ static void pageset_set_high(struct per_cpu_pageset *p,
 	pageset_update(&p->pcp, high, batch);
 }
 
-static void __meminit pageset_set_high_and_batch(struct zone *zone,
-		struct per_cpu_pageset *pcp)
+static void pageset_set_high_and_batch(struct zone *zone,
+				       struct per_cpu_pageset *pcp)
 {
 	if (percpu_pagelist_fraction)
 		pageset_set_high(pcp,
@@ -5689,23 +5690,38 @@ int percpu_pagelist_fraction_sysctl_handler(ctl_table *table, int write,
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
1.9.1

