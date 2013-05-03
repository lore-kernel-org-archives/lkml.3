Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933943Ab3ECRPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 13:15:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:28065 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933603Ab3ECRPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 13:15:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,606,1363158000"; 
   d="scan'208";a="307613699"
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ric Mason <ric.masonn@gmail.com>, Simon Jeons <simon.jeons@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: [PATCH v2 2/2] Make batch size for memory accounting configured according to size of memory
Date: Fri,  3 May 2013 03:10:53 -0700
Message-Id: <c95559dd238a811d0ef089b8e3a7a496c48634d8.1367574872.git.tim.c.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <8584b08e57e97ecc4769859b751ad459d038a730.1367574872.git.tim.c.chen@linux.intel.com>
References: <8584b08e57e97ecc4769859b751ad459d038a730.1367574872.git.tim.c.chen@linux.intel.com>
In-Reply-To: <8584b08e57e97ecc4769859b751ad459d038a730.1367574872.git.tim.c.chen@linux.intel.com>
References: <8584b08e57e97ecc4769859b751ad459d038a730.1367574872.git.tim.c.chen@linux.intel.com>
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
 mm/mmap.c  | 11 ++++++++++-
 mm/nommu.c | 11 ++++++++++-
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 0db0de1..6c1fcd09 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -3090,10 +3090,19 @@ void mm_drop_all_locks(struct mm_struct *mm)
 /*
  * initialise the VMA slab
  */
+static int mm_compute_batch(void)
+{
+	int nr = num_online_cpus();
+
+	/* batch size set to 0.4% of (total memory/#cpus) */
+	return (int) (totalram_pages/nr) / 256;
+}
+
 void __init mmap_init(void)
 {
 	int ret;
 
-	ret = percpu_counter_init(&vm_committed_as, 0);
+	ret = percpu_counter_and_batch_init(&vm_committed_as, 0,
+						&mm_compute_batch);
 	VM_BUG_ON(ret);
 }
diff --git a/mm/nommu.c b/mm/nommu.c
index 2f3ea74..2a250d3 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -526,11 +526,20 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 /*
  * initialise the VMA and region record slabs
  */
+static int mm_compute_batch(void)
+{
+	int nr = num_online_cpus();
+
+	/* batch size set to 0.4% of (total memory/#cpus) */
+	return (int) (totalram_pages/nr) / 256;
+}
+
 void __init mmap_init(void)
 {
 	int ret;
 
-	ret = percpu_counter_init(&vm_committed_as, 0);
+	ret = percpu_counter_and_batch_init(&vm_committed_as, 0,
+				&mm_compute_batch);
 	VM_BUG_ON(ret);
 	vm_region_jar = KMEM_CACHE(vm_region, SLAB_PANIC);
 }
-- 
1.7.11.7

