Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640Ab3LFXTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:19:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48867 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559Ab3LFXTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:19:48 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 103/152] mm: numa: return the number of base pages altered by protection changes
Date: Fri,  6 Dec 2013 15:10:27 -0800
Message-Id: <1386371476-2477-104-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 72403b4a0fbdf433c1fe0127e49864658f6f6468 upstream.

Commit 0255d4918480 ("mm: Account for a THP NUMA hinting update as one
PTE update") was added to account for the number of PTE updates when
marking pages prot_numa.  task_numa_work was using the old return value
to track how much address space had been updated.  Altering the return
value causes the scanner to do more work than it is configured or
documented to in a single unit of work.

This patch reverts that commit and accounts for the number of THP
updates separately in vmstat.  It is up to the administrator to
interpret the pair of values correctly.  This is a straight-forward
operation and likely to only be of interest when actively debugging NUMA
balancing problems.

The impact of this patch is that the NUMA PTE scanner will scan slower
when THP is enabled and workloads may converge slower as a result.  On
the flip size system CPU usage should be lower than recent tests
reported.  This is an illustrative example of a short single JVM specjbb
test

specjbb
                       3.12.0                3.12.0
                      vanilla      acctupdates
TPut 1      26143.00 (  0.00%)     25747.00 ( -1.51%)
TPut 7     185257.00 (  0.00%)    183202.00 ( -1.11%)
TPut 13    329760.00 (  0.00%)    346577.00 (  5.10%)
TPut 19    442502.00 (  0.00%)    460146.00 (  3.99%)
TPut 25    540634.00 (  0.00%)    549053.00 (  1.56%)
TPut 31    512098.00 (  0.00%)    519611.00 (  1.47%)
TPut 37    461276.00 (  0.00%)    474973.00 (  2.97%)
TPut 43    403089.00 (  0.00%)    414172.00 (  2.75%)

              3.12.0      3.12.0
             vanillaacctupdates
User         5169.64     5184.14
System        100.45       80.02
Elapsed       252.75      251.85

Performance is similar but note the reduction in system CPU time.  While
this showed a performance gain, it will not be universal but at least
it'll be behaving as documented.  The vmstats are obviously different but
here is an obvious interpretation of them from mmtests.

                                3.12.0      3.12.0
                               vanillaacctupdates
NUMA page range updates        1408326    11043064
NUMA huge PMD updates                0       21040
NUMA PTE updates               1408326      291624

"NUMA page range updates" == nr_pte_updates and is the value returned to
the NUMA pte scanner.  NUMA huge PMD updates were the number of THP
updates which in combination can be used to calculate how many ptes were
updated from userspace.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Alex Thorlton <athorlton@sgi.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/vm_event_item.h |  1 +
 mm/mprotect.c                 | 10 +++++++---
 mm/vmstat.c                   |  1 +
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index fce0a27..84f4d96 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -40,6 +40,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
 #ifdef CONFIG_NUMA_BALANCING
 		NUMA_PTE_UPDATES,
+		NUMA_HUGE_PTE_UPDATES,
 		NUMA_HINT_FAULTS,
 		NUMA_HINT_FAULTS_LOCAL,
 		NUMA_PAGE_MIGRATE,
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 16a42b2..4c35eb8 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -136,6 +136,7 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 	unsigned long next;
 	unsigned long pages = 0;
 	bool all_same_node;
+	unsigned long nr_huge_updates = 0;
 
 	pmd = pmd_offset(pud, addr);
 	do {
@@ -148,9 +149,10 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 						newprot, prot_numa);
 
 				if (nr_ptes) {
-					if (nr_ptes == HPAGE_PMD_NR)
-						pages++;
-
+					if (nr_ptes == HPAGE_PMD_NR) {
+						pages += HPAGE_PMD_NR;
+						nr_huge_updates++;
+					}
 					continue;
 				}
 			}
@@ -171,6 +173,8 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 			change_pmd_protnuma(vma->vm_mm, addr, pmd);
 	} while (pmd++, addr = next, addr != end);
 
+	if (nr_huge_updates)
+		count_vm_numa_events(NUMA_HUGE_PTE_UPDATES, nr_huge_updates);
 	return pages;
 }
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 9800306..1071ca6 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -776,6 +776,7 @@ const char * const vmstat_text[] = {
 
 #ifdef CONFIG_NUMA_BALANCING
 	"numa_pte_updates",
+	"numa_huge_pte_updates",
 	"numa_hint_faults",
 	"numa_hint_faults_local",
 	"numa_pages_migrated",
-- 
1.8.3.2

