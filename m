Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaB1Rnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:43:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbaB1Rni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:43:38 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 02/19] perf, sort:  Add physid sorting based on mmap2 data
Date: Fri, 28 Feb 2014 12:42:51 -0500
Message-Id: <1393609388-40489-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order for the c2c tool to work correctly, it needs to properly
sort all the records on uniquely identifiable data addresses.  These
unique addresses are converted from virtual addresses provided by the
hardware into a kernel address using an mmap2 record as the decoder.

Once a unique address is converted, we can sort on them based on
various rules.  Then it becomes clear which address are overlapping
with each other across mmap regions or pid spaces.

This patch just creates the rules and inserts the records into a
sort entry for safe keeping until later patches process them.

The general sorting rule is:

o group cpumodes together
o group similar major, minor, inode, inode generation numbers togther
o if (nonzero major/minor number - ie mmap'd areas)
  o sort on data addresses
  o sort on instruction address
  o sort on pid
  o sort on tid
o if cpumode is kernel
  o sort on data addresses
  o sort on instruction address
  o sort on pid
  o sort on tid
o else (private to pid space)
  o sort on pid
  o sort on tid
  o sort on data addresses
  o sort on instruction address

I also hacked in the concept of 'color'.  The purpose of that bit is to
provides hints later when processing these records that indicate a new unique
address has been encountered.  Because later processing only checks the data
addresses, there can be a theoretical scenario that similar sequential data
addresses (when walking the rbtree) could be misinterpreted as overlapping
when in fact they are not.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-report.c |   2 +-
 tools/perf/util/hist.c      |   7 ++-
 tools/perf/util/hist.h      |   1 +
 tools/perf/util/sort.c      | 148 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/sort.h      |   3 +
 5 files changed, 157 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d882b6f..ec797da 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -755,7 +755,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline,"
 		   " dso_to, dso_from, symbol_to, symbol_from, mispredict,"
 		   " weight, local_weight, mem, symbol_daddr, dso_daddr, tlb, "
-		   "snoop, locked, abort, in_tx, transaction"),
+		   "snoop, locked, abort, in_tx, transaction, physid"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 0466efa..ea54db3 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -420,9 +420,10 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 			.map	= al->map,
 			.sym	= al->sym,
 		},
-		.cpu	= al->cpu,
-		.ip	= al->addr,
-		.level	= al->level,
+		.cpu	 = al->cpu,
+		.cpumode = al->cpumode,
+		.ip	 = al->addr,
+		.level	 = al->level,
 		.stat = {
 			.nr_events = 1,
 			.period	= period,
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index a59743f..d226c5b 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -62,6 +62,7 @@ enum hist_column {
 	HISTC_MEM_LVL,
 	HISTC_MEM_SNOOP,
 	HISTC_TRANSACTION,
+	HISTC_PHYSID,
 	HISTC_NR_COLS, /* Last entry */
 };
 
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 635cd8f..0cb43a5 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -977,6 +977,151 @@ struct sort_entry sort_transaction = {
 	.se_width_idx	= HISTC_TRANSACTION,
 };
 
+static int64_t
+sort__physid_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+        u64 l, r;
+        struct map *l_map = left->mem_info->daddr.map;
+        struct map *r_map = right->mem_info->daddr.map;
+
+	/* store all NULL mem maps at the bottom */
+	/* shouldn't even need this check, should have stubs */
+	if (!left->mem_info->daddr.map || !right->mem_info->daddr.map)
+		return 1;
+
+        /* group event types together */
+        if (left->cpumode > right->cpumode) return -1;
+        if (left->cpumode < right->cpumode) return 1;
+
+        if (l_map->maj > r_map->maj) return -1;
+        if (l_map->maj < r_map->maj) return 1;
+
+        if (l_map->min > r_map->min) return -1;
+        if (l_map->min < r_map->min) return 1;
+
+        if (l_map->ino > r_map->ino) return -1;
+        if (l_map->ino < r_map->ino) return 1;
+
+        if (l_map->ino_generation > r_map->ino_generation) return -1;
+        if (l_map->ino_generation < r_map->ino_generation) return 1;
+
+        /*
+         * Addresses with no major/minor numbers are assumed to be
+         * anonymous in userspace.  Sort those on pid then address.
+         *
+         * The kernel and non-zero major/minor mapped areas are
+         * assumed to be unity mapped.  Sort those on address then pid.
+         */
+
+        /* al_addr does all the right addr - start + offset calculations */
+        l = left->mem_info->daddr.al_addr;
+        r = right->mem_info->daddr.al_addr;
+
+        if (l_map->maj || l_map->min || l_map->ino || l_map-> ino_generation) {
+                /* mmapped areas */
+
+                /* hack to mark similar regions, 'right' is new entry */
+                /* entries with same maj/min/ino/inogen are in same address space */
+                right->color = TRUE;
+
+                if (l > r) return -1;
+                if (l < r) return 1;
+
+                /* sorting by iaddr makes calculations easier later */
+                if (left->mem_info->iaddr.al_addr > right->mem_info->iaddr.al_addr) return -1;
+                if (left->mem_info->iaddr.al_addr < right->mem_info->iaddr.al_addr) return 1;
+
+                if (left->thread->pid_ > right->thread->pid_) return -1;
+                if (left->thread->pid_ < right->thread->pid_) return 1;
+
+                if (left->thread->tid > right->thread->tid) return -1;
+                if (left->thread->tid < right->thread->tid) return 1;
+        } else if (left->cpumode == PERF_RECORD_MISC_KERNEL) {
+                /* kernel mapped areas where 'start' doesn't matter */
+
+                /* hack to mark similar regions, 'right' is new entry */
+                /* whole kernel region is in the same address space */
+                right->color = TRUE;
+
+                if (l > r) return -1;
+                if (l < r) return 1;
+
+                /* sorting by iaddr makes calculations easier later */
+                if (left->mem_info->iaddr.al_addr > right->mem_info->iaddr.al_addr) return -1;
+                if (left->mem_info->iaddr.al_addr < right->mem_info->iaddr.al_addr) return 1;
+
+                if (left->thread->pid_ > right->thread->pid_) return -1;
+                if (left->thread->pid_ < right->thread->pid_) return 1;
+
+                if (left->thread->tid > right->thread->tid) return -1;
+                if (left->thread->tid < right->thread->tid) return 1;
+        } else {
+                /* userspace anonymous */
+                if (left->thread->pid_ > right->thread->pid_) return -1;
+                if (left->thread->pid_ < right->thread->pid_) return 1;
+
+                if (left->thread->tid > right->thread->tid) return -1;
+                if (left->thread->tid < right->thread->tid) return 1;
+
+	         /* hack to mark similar regions, 'right' is new entry */
+                /* userspace anonymous address space is contained within pid */
+                right->color = TRUE;
+
+                if (l > r) return -1;
+                if (l < r) return 1;
+
+                /* sorting by iaddr makes calculations easier later */
+                if (left->mem_info->iaddr.al_addr > right->mem_info->iaddr.al_addr) return -1;
+                if (left->mem_info->iaddr.al_addr < right->mem_info->iaddr.al_addr) return 1;
+        }
+
+	/* sanity check the maps; only mmaped areas should have different maps */
+	if ((left->mem_info->daddr.map != right->mem_info->daddr.map) &&
+	     !right->mem_info->daddr.map->maj && !right->mem_info->daddr.map->min)
+		pr_debug("physid_cmp: Similar entries have different maps\n");
+
+        return 0;
+}
+
+static int hist_entry__physid_snprintf(struct hist_entry *he, char *bf,
+					    size_t size, unsigned int width)
+{
+	char buf[256];
+	char *p = buf;
+
+	if (!he->mem_info->daddr.map) {
+        	sprintf(p, "%3x %3x %8lx %8lx %6d %16lx %16lx %16lx %8x\n",
+                        -1,
+                        -1,
+                        -1UL,
+                        -1UL,
+                        he->thread->pid_,
+                        -1UL,
+                        he->mem_info->daddr.addr,
+                        he->mem_info->iaddr.al_addr,
+                        he->cpumode);
+	} else {
+	        sprintf(p, "%3x %3x %8lx %8lx %6d %16lx %16lx %16lx %8x\n",
+                        he->mem_info->daddr.map->maj,
+                        he->mem_info->daddr.map->min,
+                        he->mem_info->daddr.map->ino,
+                        he->mem_info->daddr.map->ino_generation,
+                        he->thread->pid_,
+                        he->mem_info->daddr.map->start,
+                        he->mem_info->daddr.addr,
+                        he->mem_info->iaddr.al_addr,
+                        he->cpumode);
+	}
+	return repsep_snprintf(bf, size, "%-*s", width, buf);
+}
+
+struct sort_entry sort_physid = {
+	.se_header	= "Physid (major, minor, inode, inode generation, pid, start, Data addr, IP, cpumode)",
+	.se_cmp		= sort__physid_cmp,
+	.se_snprintf	= hist_entry__physid_snprintf,
+	.se_width_idx	= HISTC_PHYSID,
+};
+
 struct sort_dimension {
 	const char		*name;
 	struct sort_entry	*entry;
@@ -1023,6 +1168,7 @@ static struct sort_dimension memory_sort_dimensions[] = {
 	DIM(SORT_MEM_TLB, "tlb", sort_mem_tlb),
 	DIM(SORT_MEM_LVL, "mem", sort_mem_lvl),
 	DIM(SORT_MEM_SNOOP, "snoop", sort_mem_snoop),
+	DIM(SORT_MEM_PHYSID, "physid", sort_physid),
 };
 
 #undef DIM
@@ -1182,6 +1328,8 @@ void sort__setup_elide(FILE *output)
 					"tlb", output);
 		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
 					"snoop", output);
+		sort_entry__setup_elide(&sort_physid, symbol_conf.dso_list,
+					"physid", output);
 	}
 
 	/*
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 43e5ff4..eb8cd50 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -87,11 +87,13 @@ struct hist_entry {
 	u64			ip;
 	u64			transaction;
 	s32			cpu;
+	u8			cpumode;
 
 	struct hist_entry_diff	diff;
 
 	/* We are added by hists__add_dummy_entry. */
 	bool			dummy;
+	bool			color;
 
 	/* XXX These two should move to some tree widget lib */
 	u16			row_offset;
@@ -166,6 +168,7 @@ enum sort_type {
 	SORT_MEM_TLB,
 	SORT_MEM_LVL,
 	SORT_MEM_SNOOP,
+	SORT_MEM_PHYSID,
 };
 
 /*
-- 
1.7.11.7

