Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaEMQvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:51:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbaEMQtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:49:25 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net, peterz@infradead.org
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, namhyung@gmail.com,
        eranian@google.com, Andi Kleen <andi@firstfloor.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 6/6] perf: Add dcacheline sort
Date: Tue, 13 May 2014 12:48:17 -0400
Message-Id: <1399999697-65875-7-git-send-email-dzickus@redhat.com>
In-Reply-To: <1399999697-65875-1-git-send-email-dzickus@redhat.com>
References: <1399999697-65875-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/Documentation/perf-report.txt |   3 +-
 tools/perf/builtin-report.c              |   2 +-
 tools/perf/util/hist.h                   |   1 +
 tools/perf/util/sort.c                   | 105 +++++++++++++++++++++++++++++++
 tools/perf/util/sort.h                   |   1 +
 5 files changed, 110 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index bea1c83..9115d02 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -100,7 +100,7 @@ OPTIONS
 
 	If --mem-mode option is used, following sort keys are also available
 	(incompatible with --branch-stack):
-	symbol_daddr, dso_daddr, locked, tlb, mem, snoop.
+	symbol_daddr, dso_daddr, locked, tlb, mem, snoop, dcacheline.
 
 	- symbol_daddr: name of data symbol being executed on at the time of sample
 	- dso_daddr: name of library or module containing the data being executed
@@ -109,6 +109,7 @@ OPTIONS
 	- tlb: type of tlb access for the data at the time of sample
 	- mem: type of memory access for the data at the time of sample
 	- snoop: type of snoop (if any) for the data at the time of sample
+	- dcacheline: the cacheline the data address is on at the time of sample
 
 	And default sort keys are changed to local_weight, mem, sym, dso,
 	symbol_daddr, dso_daddr, snoop, tlb, locked, see '--mem-mode'.
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 89c9528..387459f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -702,7 +702,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline,"
 		   " dso_to, dso_from, symbol_to, symbol_from, mispredict,"
 		   " weight, local_weight, mem, symbol_daddr, dso_daddr, tlb, "
-		   "snoop, locked, abort, in_tx, transaction"),
+		   "snoop, locked, abort, in_tx, transaction, dcacheline"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 38c3e87..14d1dc1 100644
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
index 635cd8f..0e91ba9 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1,3 +1,4 @@
+#include <sys/mman.h>
 #include "sort.h"
 #include "hist.h"
 #include "comm.h"
@@ -764,6 +765,102 @@ static int hist_entry__snoop_snprintf(struct hist_entry *he, char *bf,
 	return repsep_snprintf(bf, size, "%-*s", width, out);
 }
 
+#define CACHE_LINESIZE       64
+#define CLINE_OFFSET_MSK     (CACHE_LINESIZE - 1)
+#define CLADRS(a)            ((a) & ~(CLINE_OFFSET_MSK))
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
+	l = CLADRS(left->mem_info->daddr.al_addr);
+	r = CLADRS(right->mem_info->daddr.al_addr);
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
+		addr = CLADRS(he->mem_info->daddr.al_addr);
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
@@ -856,6 +953,13 @@ struct sort_entry sort_mem_snoop = {
 	.se_width_idx	= HISTC_MEM_SNOOP,
 };
 
+struct sort_entry sort_mem_dcacheline = {
+	.se_header	= "Data Cacheline         ",
+	.se_cmp		= sort__dcacheline_cmp,
+	.se_snprintf	= hist_entry__dcacheline_snprintf,
+	.se_width_idx	= HISTC_MEM_DCACHELINE,
+};
+
 static int64_t
 sort__abort_cmp(struct hist_entry *left, struct hist_entry *right)
 {
@@ -1023,6 +1127,7 @@ static struct sort_dimension memory_sort_dimensions[] = {
 	DIM(SORT_MEM_TLB, "tlb", sort_mem_tlb),
 	DIM(SORT_MEM_LVL, "mem", sort_mem_lvl),
 	DIM(SORT_MEM_SNOOP, "snoop", sort_mem_snoop),
+	DIM(SORT_MEM_DCACHELINE, "dcacheline", sort_mem_dcacheline),
 };
 
 #undef DIM
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 22cf912..460ec9c 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -167,6 +167,7 @@ enum sort_type {
 	SORT_MEM_TLB,
 	SORT_MEM_LVL,
 	SORT_MEM_SNOOP,
+	SORT_MEM_DCACHELINE,
 };
 
 /*
-- 
1.7.11.7

