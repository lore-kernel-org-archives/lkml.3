Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417Ab3D3ARJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 20:17:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:32571 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758062Ab3D3ARH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 20:17:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,576,1363158000"; 
   d="scan'208";a="328563186"
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: [PATCH 2/2] Make batch size for memory accounting configured according to size of memory
Date: Mon, 29 Apr 2013 10:12:29 -0700
Message-Id: <8c9bc7d4646d48154604820a3ec5952ba8949de4.1367254913.git.tim.c.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <c1f9c476a8bd1f5e7049b8ac79af48be61afd8f3.1367254913.git.tim.c.chen@linux.intel.com>
References: <c1f9c476a8bd1f5e7049b8ac79af48be61afd8f3.1367254913.git.tim.c.chen@linux.intel.com>
In-Reply-To: <c1f9c476a8bd1f5e7049b8ac79af48be61afd8f3.1367254913.git.tim.c.chen@linux.intel.com>
References: <c1f9c476a8bd1f5e7049b8ac79af48be61afd8f3.1367254913.git.tim.c.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the per cpu counter's batch size for memory accounting is
configured as twice the number of cpus in the system.  However,
for system with very large memory, it is more appropriate to make it
proportional to the memory size per cpu in the system.

For example, for a x86_64 system with 64 cpus and 128 GB of memory,
the batch size is only 2*64 pages (0.5 MB).  So any memory accounting
changes of more than 0.5MB will overflow the per cpu counter into
the global counter.  Instead, for the new scheme, the batch size
is configured to be 0.4% of the memory/cpu = 8MB (128 GB/64 /256),
which is more inline with the memory size.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 mm/mmap.c  | 13 ++++++++++++-
 mm/nommu.c | 13 ++++++++++++-
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 0db0de1..082836e 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -89,6 +89,7 @@ int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
  * other variables. It can be updated by several CPUs frequently.
  */
 struct percpu_counter vm_committed_as ____cacheline_aligned_in_smp;
+int vm_committed_batchsz ____cacheline_aligned_in_smp;
 
 /*
  * The global memory commitment made in the system can be a metric
@@ -3090,10 +3091,20 @@ void mm_drop_all_locks(struct mm_struct *mm)
 /*
  * initialise the VMA slab
  */
+static inline int mm_compute_batch(void)
+{
+	int nr = num_present_cpus();
+
+	/* batch size set to 0.4% of (total memory/#cpus) */
+	return (int) (totalram_pages/nr) / 256;
+}
+
 void __init mmap_init(void)
 {
 	int ret;
 
-	ret = percpu_counter_init(&vm_committed_as, 0);
+	vm_committed_batchsz = mm_compute_batch();
+	ret = percpu_counter_and_batch_init(&vm_committed_as, 0,
+						&vm_committed_batchsz);
 	VM_BUG_ON(ret);
 }
diff --git a/mm/nommu.c b/mm/nommu.c
index 2f3ea74..a87a99c 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -59,6 +59,7 @@ unsigned long max_mapnr;
 unsigned long num_physpages;
 unsigned long highest_memmap_pfn;
 struct percpu_counter vm_committed_as;
+int vm_committed_batchsz;
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50; /* default is 50% */
 int sysctl_max_map_count = DEFAULT_MAX_MAP_COUNT;
@@ -526,11 +527,21 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 /*
  * initialise the VMA and region record slabs
  */
+static inline int mm_compute_batch(void)
+{
+	int nr = num_present_cpus();
+
+	/* batch size set to 0.4% of (total memory/#cpus) */
+	return (int) (totalram_pages/nr) / 256;
+}
+
 void __init mmap_init(void)
 {
 	int ret;
 
-	ret = percpu_counter_init(&vm_committed_as, 0);
+	vm_committed_batchsz = mm_compute_batch();
+	ret = percpu_counter_and_batch_init(&vm_committed_as, 0,
+			&vm_committed_batchsz);
 	VM_BUG_ON(ret);
 	vm_region_jar = KMEM_CACHE(vm_region, SLAB_PANIC);
 }
-- 
1.7.11.7

