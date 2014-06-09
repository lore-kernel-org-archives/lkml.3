Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbaFIUDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:03:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446AbaFIUDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:03:06 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 14/15] perf tools: Add dcacheline sort
Date: Mon,  9 Jun 2014 22:02:29 +0200
Message-Id: <1402344150-14860-15-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
References: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>

In perf's 'mem-mode', one can get access to a whole bunch of details specific to a
particular sample instruction.  A bunch of those details relate to the data
address.

One interesting thing you can do with data addresses is to convert them into a unique
cacheline they belong too.  Organizing these data cachelines into similar groups and sorting
them can reveal cache contention.

This patch creates an alogorithm based on various sample details that can help group
entries together into data cachelines and allows 'perf report' to sort on it.

The algorithm relies on having proper mmap2 support in the kernel to help determine
if the memory map the data address belongs to is private to a pid or globally shared.

The alogortithm is as follows:

o group cpumodes together
o group entries with discovered maps together
o sort on major, minor, inode and inode generation numbers
o if userspace anon, then sort on pid
o sort on cachelines based on data addresses

The 'dcacheline' sort option in 'perf report' only works in 'mem-mode'.

Sample output:

 #
 # Samples: 206  of event 'cpu/mem-loads/pp'
 # Total weight : 2534
 # Sort order   : dcacheline,pid
 #
 # Overhead       Samples                                                          Data Cacheline       Command:  Pid
 # ........  ............  ......................................................................  ..................
 #
    13.22%             1  [k] 0xffff88042f08ebc0                                                       swapper:    0
     9.27%             1  [k] 0xffff88082e8cea80                                                       swapper:    0
     3.59%             2  [k] 0xffffffff819ba180                                                       swapper:    0
     0.32%             1  [k] arch_trigger_all_cpu_backtrace_handler_na.23901+0xffffffffffffffe0       swapper:    0
     0.32%             1  [k] timekeeper_seq+0xfffffffffffffff8                                        swapper:    0

Note:  Added a '+1' to symlen size in hists__calc_col_len to prevent the next column
from prematurely tabbing over and mis-aligning.  Not sure what the problem is.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/1401208087-181977-8-git-send-email-dzickus@redhat.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Documentation/perf-report.txt |   3 +-
 tools/perf/util/hist.c                   |   2 +
 tools/perf/util/hist.h                   |   1 +
 tools/perf/util/sort.c                   | 107 +++++++++++++++++++++++++++++++
 tools/perf/util/sort.h                   |   1 +
 5 files changed, 113 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 00fbfb6..d2b59af 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -119,7 +119,7 @@ OPTIONS
 
 	If --mem-mode option is used, following sort keys are also available
 	(incompatible with --branch-stack):
-	symbol_daddr, dso_daddr, locked, tlb, mem, snoop.
+	symbol_daddr, dso_daddr, locked, tlb, mem, snoop, dcacheline.
 
 	- symbol_daddr: name of data symbol being executed on at the time of sample
 	- dso_daddr: name of library or module containing the data being executed
@@ -128,6 +128,7 @@ OPTIONS
 	- tlb: type of tlb access for the data at the time of sample
 	- mem: type of memory access for the data at the time of sample
 	- snoop: type of snoop (if any) for the data at the time of sample
+	- dcacheline: the cacheline the data address is on at the time of sample
 
 	And default sort keys are changed to local_weight, mem, sym, dso,
 	symbol_daddr, dso_daddr, snoop, tlb, locked, see '--mem-mode'.
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index d5f47a4..30df618 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -128,6 +128,8 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 			       + unresolved_col_width + 2;
 			hists__new_col_len(hists, HISTC_MEM_DADDR_SYMBOL,
 					   symlen);
+			hists__new_col_len(hists, HISTC_MEM_DCACHELINE,
+					   symlen + 1);
 		} else {
 			symlen = unresolved_col_width + 4 + 2;
 			hists__new_col_len(hists, HISTC_MEM_DADDR_SYMBOL,
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index d2bf035..742f49a 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -72,6 +72,7 @@ enum hist_column {
 	HISTC_MEM_TLB,
 	HISTC_MEM_LVL,
 	HISTC_MEM_SNOOP,
+	HISTC_MEM_DCACHELINE,
 	HISTC_TRANSACTION,
 	HISTC_NR_COLS, /* Last entry */
 };
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 45512ba..1ec57dd 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1,3 +1,4 @@
+#include <sys/mman.h>
 #include "sort.h"
 #include "hist.h"
 #include "comm.h"
@@ -784,6 +785,104 @@ static int hist_entry__snoop_snprintf(struct hist_entry *he, char *bf,
 	return repsep_snprintf(bf, size, "%-*s", width, out);
 }
 
+static inline  u64 cl_address(u64 address)
+{
+	/* return the cacheline of the address */
+	return (address & ~(cacheline_size - 1));
+}
+
+static int64_t
+sort__dcacheline_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	u64 l, r;
+	struct map *l_map, *r_map;
+
+	if (!left->mem_info)  return -1;
+	if (!right->mem_info) return 1;
+
+	/* group event types together */
+	if (left->cpumode > right->cpumode) return -1;
+	if (left->cpumode < right->cpumode) return 1;
+
+	l_map = left->mem_info->daddr.map;
+	r_map = right->mem_info->daddr.map;
+
+	/* if both are NULL, jump to sort on al_addr instead */
+	if (!l_map && !r_map)
+		goto addr;
+
+	if (!l_map) return -1;
+	if (!r_map) return 1;
+
+	if (l_map->maj > r_map->maj) return -1;
+	if (l_map->maj < r_map->maj) return 1;
+
+	if (l_map->min > r_map->min) return -1;
+	if (l_map->min < r_map->min) return 1;
+
+	if (l_map->ino > r_map->ino) return -1;
+	if (l_map->ino < r_map->ino) return 1;
+
+	if (l_map->ino_generation > r_map->ino_generation) return -1;
+	if (l_map->ino_generation < r_map->ino_generation) return 1;
+
+	/*
+	 * Addresses with no major/minor numbers are assumed to be
+	 * anonymous in userspace.  Sort those on pid then address.
+	 *
+	 * The kernel and non-zero major/minor mapped areas are
+	 * assumed to be unity mapped.  Sort those on address.
+	 */
+
+	if ((left->cpumode != PERF_RECORD_MISC_KERNEL) &&
+	    (!(l_map->flags & MAP_SHARED)) &&
+	    !l_map->maj && !l_map->min && !l_map->ino &&
+	    !l_map->ino_generation) {
+		/* userspace anonymous */
+
+		if (left->thread->pid_ > right->thread->pid_) return -1;
+		if (left->thread->pid_ < right->thread->pid_) return 1;
+	}
+
+addr:
+	/* al_addr does all the right addr - start + offset calculations */
+	l = cl_address(left->mem_info->daddr.al_addr);
+	r = cl_address(right->mem_info->daddr.al_addr);
+
+	if (l > r) return -1;
+	if (l < r) return 1;
+
+	return 0;
+}
+
+static int hist_entry__dcacheline_snprintf(struct hist_entry *he, char *bf,
+					  size_t size, unsigned int width)
+{
+
+	uint64_t addr = 0;
+	struct map *map = NULL;
+	struct symbol *sym = NULL;
+	char level = he->level;
+
+	if (he->mem_info) {
+		addr = cl_address(he->mem_info->daddr.al_addr);
+		map = he->mem_info->daddr.map;
+		sym = he->mem_info->daddr.sym;
+
+		/* print [s] for shared data mmaps */
+		if ((he->cpumode != PERF_RECORD_MISC_KERNEL) &&
+		     map && (map->type == MAP__VARIABLE) &&
+		    (map->flags & MAP_SHARED) &&
+		    (map->maj || map->min || map->ino ||
+		     map->ino_generation))
+			level = 's';
+		else if (!map)
+			level = 'X';
+	}
+	return _hist_entry__sym_snprintf(map, sym, addr, level, bf, size,
+					 width);
+}
+
 struct sort_entry sort_mispredict = {
 	.se_header	= "Branch Mispredicted",
 	.se_cmp		= sort__mispredict_cmp,
@@ -876,6 +975,13 @@ struct sort_entry sort_mem_snoop = {
 	.se_width_idx	= HISTC_MEM_SNOOP,
 };
 
+struct sort_entry sort_mem_dcacheline = {
+	.se_header	= "Data Cacheline",
+	.se_cmp		= sort__dcacheline_cmp,
+	.se_snprintf	= hist_entry__dcacheline_snprintf,
+	.se_width_idx	= HISTC_MEM_DCACHELINE,
+};
+
 static int64_t
 sort__abort_cmp(struct hist_entry *left, struct hist_entry *right)
 {
@@ -1043,6 +1149,7 @@ static struct sort_dimension memory_sort_dimensions[] = {
 	DIM(SORT_MEM_TLB, "tlb", sort_mem_tlb),
 	DIM(SORT_MEM_LVL, "mem", sort_mem_lvl),
 	DIM(SORT_MEM_SNOOP, "snoop", sort_mem_snoop),
+	DIM(SORT_MEM_DCACHELINE, "dcacheline", sort_mem_dcacheline),
 };
 
 #undef DIM
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 6de22f8..041f0c9 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -186,6 +186,7 @@ enum sort_type {
 	SORT_MEM_TLB,
 	SORT_MEM_LVL,
 	SORT_MEM_SNOOP,
+	SORT_MEM_DCACHELINE,
 };
 
 /*
-- 
1.8.3.1

