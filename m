Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab3JIRcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:32:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56417 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268Ab3JIRcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:32:09 -0400
Date: Wed, 9 Oct 2013 10:31:33 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-6688cc05473b36a0a3d3971e1adf1712919b32eb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        srikar@linux.vnet.ibm.com, aarcange@redhat.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        srikar@linux.vnet.ibm.com, aarcange@redhat.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-47-git-send-email-mgorman@suse.de>
References: <1381141781-10992-47-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] mm: numa: Do not group on RO pages
Git-Commit-ID: 6688cc05473b36a0a3d3971e1adf1712919b32eb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:31:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6688cc05473b36a0a3d3971e1adf1712919b32eb
Gitweb:     http://git.kernel.org/tip/6688cc05473b36a0a3d3971e1adf1712919b32eb
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 7 Oct 2013 11:29:24 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 14:47:53 +0200

mm: numa: Do not group on RO pages

And here's a little something to make sure not the whole world ends up
in a single group.

As while we don't migrate shared executable pages, we do scan/fault on
them. And since everybody links to libc, everybody ends up in the same
group.

Suggested-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1381141781-10992-47-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |  7 +++++--
 kernel/sched/fair.c   |  5 +++--
 mm/huge_memory.c      | 15 +++++++++++++--
 mm/memory.c           | 30 ++++++++++++++++++++++++++----
 4 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b0b343b..ff54385 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1450,13 +1450,16 @@ struct task_struct {
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
 #define tsk_cpus_allowed(tsk) (&(tsk)->cpus_allowed)
 
+#define TNF_MIGRATED	0x01
+#define TNF_NO_GROUP	0x02
+
 #ifdef CONFIG_NUMA_BALANCING
-extern void task_numa_fault(int last_node, int node, int pages, bool migrated);
+extern void task_numa_fault(int last_node, int node, int pages, int flags);
 extern pid_t task_numa_group_id(struct task_struct *p);
 extern void set_numabalancing_state(bool enabled);
 #else
 static inline void task_numa_fault(int last_node, int node, int pages,
-				   bool migrated)
+				   int flags)
 {
 }
 static inline pid_t task_numa_group_id(struct task_struct *p)
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5bd309c..35661b8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1361,9 +1361,10 @@ void task_numa_free(struct task_struct *p)
 /*
  * Got a PROT_NONE fault for a page on @node.
  */
-void task_numa_fault(int last_cpupid, int node, int pages, bool migrated)
+void task_numa_fault(int last_cpupid, int node, int pages, int flags)
 {
 	struct task_struct *p = current;
+	bool migrated = flags & TNF_MIGRATED;
 	int priv;
 
 	if (!numabalancing_enabled)
@@ -1394,7 +1395,7 @@ void task_numa_fault(int last_cpupid, int node, int pages, bool migrated)
 		priv = 1;
 	} else {
 		priv = cpupid_match_pid(p, last_cpupid);
-		if (!priv)
+		if (!priv && !(flags & TNF_NO_GROUP))
 			task_numa_group(p, last_cpupid);
 	}
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index becf92c..7ab4e32 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1285,6 +1285,7 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	int target_nid, last_cpupid = -1;
 	bool page_locked;
 	bool migrated = false;
+	int flags = 0;
 
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_same(pmd, *pmdp)))
@@ -1299,6 +1300,14 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		count_vm_numa_event(NUMA_HINT_FAULTS_LOCAL);
 
 	/*
+	 * Avoid grouping on DSO/COW pages in specific and RO pages
+	 * in general, RO pages shouldn't hurt as much anyway since
+	 * they can be in shared cache state.
+	 */
+	if (!pmd_write(pmd))
+		flags |= TNF_NO_GROUP;
+
+	/*
 	 * Acquire the page lock to serialise THP migrations but avoid dropping
 	 * page_table_lock if at all possible
 	 */
@@ -1343,8 +1352,10 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	spin_unlock(&mm->page_table_lock);
 	migrated = migrate_misplaced_transhuge_page(mm, vma,
 				pmdp, pmd, addr, page, target_nid);
-	if (migrated)
+	if (migrated) {
+		flags |= TNF_MIGRATED;
 		page_nid = target_nid;
+	}
 
 	goto out;
 clear_pmdnuma:
@@ -1362,7 +1373,7 @@ out:
 		page_unlock_anon_vma_read(anon_vma);
 
 	if (page_nid != -1)
-		task_numa_fault(last_cpupid, page_nid, HPAGE_PMD_NR, migrated);
+		task_numa_fault(last_cpupid, page_nid, HPAGE_PMD_NR, flags);
 
 	return 0;
 }
diff --git a/mm/memory.c b/mm/memory.c
index c57efa2..eba846b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3547,6 +3547,7 @@ int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	int last_cpupid;
 	int target_nid;
 	bool migrated = false;
+	int flags = 0;
 
 	/*
 	* The "pte" at this point cannot be used safely without
@@ -3575,6 +3576,14 @@ int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	}
 	BUG_ON(is_zero_pfn(page_to_pfn(page)));
 
+	/*
+	 * Avoid grouping on DSO/COW pages in specific and RO pages
+	 * in general, RO pages shouldn't hurt as much anyway since
+	 * they can be in shared cache state.
+	 */
+	if (!pte_write(pte))
+		flags |= TNF_NO_GROUP;
+
 	last_cpupid = page_cpupid_last(page);
 	page_nid = page_to_nid(page);
 	target_nid = numa_migrate_prep(page, vma, addr, page_nid);
@@ -3586,12 +3595,14 @@ int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	/* Migrate to the requested node */
 	migrated = migrate_misplaced_page(page, vma, target_nid);
-	if (migrated)
+	if (migrated) {
 		page_nid = target_nid;
+		flags |= TNF_MIGRATED;
+	}
 
 out:
 	if (page_nid != -1)
-		task_numa_fault(last_cpupid, page_nid, 1, migrated);
+		task_numa_fault(last_cpupid, page_nid, 1, flags);
 	return 0;
 }
 
@@ -3632,6 +3643,7 @@ static int do_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		int page_nid = -1;
 		int target_nid;
 		bool migrated = false;
+		int flags = 0;
 
 		if (!pte_present(pteval))
 			continue;
@@ -3651,20 +3663,30 @@ static int do_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		if (unlikely(!page))
 			continue;
 
+		/*
+		 * Avoid grouping on DSO/COW pages in specific and RO pages
+		 * in general, RO pages shouldn't hurt as much anyway since
+		 * they can be in shared cache state.
+		 */
+		if (!pte_write(pteval))
+			flags |= TNF_NO_GROUP;
+
 		last_cpupid = page_cpupid_last(page);
 		page_nid = page_to_nid(page);
 		target_nid = numa_migrate_prep(page, vma, addr, page_nid);
 		pte_unmap_unlock(pte, ptl);
 		if (target_nid != -1) {
 			migrated = migrate_misplaced_page(page, vma, target_nid);
-			if (migrated)
+			if (migrated) {
 				page_nid = target_nid;
+				flags |= TNF_MIGRATED;
+			}
 		} else {
 			put_page(page);
 		}
 
 		if (page_nid != -1)
-			task_numa_fault(last_cpupid, page_nid, 1, migrated);
+			task_numa_fault(last_cpupid, page_nid, 1, flags);
 
 		pte = pte_offset_map_lock(mm, pmdp, addr, &ptl);
 	}
