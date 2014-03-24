Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbaCXTrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:47:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185AbaCXTfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:35:19 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net, peterz@infradead.org
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com, andi.kleen@intel.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 4/6] perf, sort:  Add physid sorting based on mmap2 data
Date: Mon, 24 Mar 2014 15:34:34 -0400
Message-Id: <1395689676-214799-5-git-send-email-dzickus@redhat.com>
In-Reply-To: <1395689676-214799-1-git-send-email-dzickus@redhat.com>
References: <1395689676-214799-1-git-send-email-dzickus@redhat.com>
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
o if (nonzero major/minor number - ie mmap'd areas)
  o sort on major, minor, inode, inode generation numbers
o else if cpumode is not kernel
  o sort on pid
o sort on data addresses

I also hacked in the concept of 'color'.  The purpose of that bit is to
provides hints later when processing these records that indicate a new unique
address has been encountered.  Because later processing only checks the data
addresses, there can be a theoretical scenario that similar sequential data
addresses (when walking the rbtree) could be misinterpreted as overlapping
when in fact they are not.

Sample output: (perf report --stdio --physid-mode)

    18.93%  [k] 0xffffc900139c40b0  [k] igb_update_stats     kworker/0:1:  257   257      0      0       0  0
     7.63%  [k] 0xffff88082e6cf0a8  [k] watchdog_timer_fn        swapper:    0     0      0      0       0  0
     1.86%  [k] 0xffff88042ef94700  [k] _raw_spin_lock           swapper:    0     0      0      0       0  0
     1.77%  [k] 0xffff8804278afa50  [k] __switch_to              swapper:    0     0      0      0       0  0

V3: split out the sorting into unique entries.  This makes it look
      far less ugly
    create a new 'physid mode' to group all the sorting rules together
      (mimics the mem-mode)

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-report.c |  20 ++-
 tools/perf/util/hist.c      |  27 +++-
 tools/perf/util/hist.h      |   8 ++
 tools/perf/util/sort.c      | 294 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/sort.h      |  13 ++
 5 files changed, 358 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c87412b..093f5ad 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -49,6 +49,7 @@ struct report {
 	bool			show_threads;
 	bool			inverted_callchain;
 	bool			mem_mode;
+	bool			physid_mode;
 	bool			header;
 	bool			header_only;
 	int			max_stack;
@@ -241,7 +242,7 @@ static int process_sample_event(struct perf_tool *tool,
 		ret = report__add_branch_hist_entry(rep, &al, sample, evsel);
 		if (ret < 0)
 			pr_debug("problem adding lbr entry, skipping event\n");
-	} else if (rep->mem_mode == 1) {
+	} else if ((rep->mem_mode == 1) || (rep->physid_mode)) {
 		ret = report__add_mem_hist_entry(rep, &al, sample, evsel);
 		if (ret < 0)
 			pr_debug("problem adding mem entry, skipping event\n");
@@ -746,6 +747,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
 		    "Disable symbol demangling"),
 	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
+	OPT_BOOLEAN(0, "physid-mode", &report.physid_mode, "physid access profile"),
 	OPT_CALLBACK(0, "percent-limit", &report, "percent",
 		     "Don't show entries under that percent", parse_percent_limit),
 	OPT_END()
@@ -817,6 +819,22 @@ repeat:
 			sort_order = "local_weight,mem,sym,dso,symbol_daddr,dso_daddr,snoop,tlb,locked";
 	}
 
+	if (report.physid_mode) {
+		if ((sort__mode == SORT_MODE__BRANCH) ||
+		    (sort__mode == SORT_MODE__MEMORY)) {
+			pr_err("branch or memory and physid mode incompatible\n");
+			goto error;
+		}
+		sort__mode = SORT_MODE__PHYSID;
+
+		/*
+		 * if no sort_order is provided, then specify
+		 * branch-mode specific order
+		 */
+		if (sort_order == default_sort_order)
+			sort_order = "daddr,iaddr,pid,tid,major,minor,inode,inode_gen";
+	}
+
 	if (setup_sorting() < 0) {
 		parse_options_usage(report_usage, options, "s", 1);
 		goto error;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f38590d..81f47ee 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -136,14 +136,34 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 			symlen = dso__name_len(h->mem_info->daddr.map->dso);
 			hists__new_col_len(hists, HISTC_MEM_DADDR_DSO,
 					   symlen);
+			hists__new_col_len(hists, HISTC_PHYSID_DADDR, symlen);
 		} else {
 			symlen = unresolved_col_width + 4 + 2;
 			hists__set_unres_dso_col_len(hists, HISTC_MEM_DADDR_DSO);
+			hists__set_unres_dso_col_len(hists, HISTC_PHYSID_DADDR);
+		}
+
+		if (h->mem_info->iaddr.sym) {
+			symlen = (int)h->mem_info->iaddr.sym->namelen + 4
+			       + unresolved_col_width + 2;
+			hists__new_col_len(hists, HISTC_PHYSID_IADDR, symlen);
+		} else {
+			symlen = unresolved_col_width + 4 + 2;
+			hists__new_col_len(hists, HISTC_PHYSID_IADDR, symlen);
+		}
+		if (h->mem_info->iaddr.map) {
+			symlen = dso__name_len(h->mem_info->iaddr.map->dso);
+			hists__new_col_len(hists, HISTC_PHYSID_IADDR, symlen);
+		} else {
+			symlen = unresolved_col_width + 4 + 2;
+			hists__set_unres_dso_col_len(hists, HISTC_PHYSID_IADDR);
 		}
 	} else {
 		symlen = unresolved_col_width + 4 + 2;
 		hists__new_col_len(hists, HISTC_MEM_DADDR_SYMBOL, symlen);
 		hists__set_unres_dso_col_len(hists, HISTC_MEM_DADDR_DSO);
+		hists__set_unres_dso_col_len(hists, HISTC_PHYSID_DADDR);
+		hists__set_unres_dso_col_len(hists, HISTC_PHYSID_IADDR);
 	}
 
 	hists__new_col_len(hists, HISTC_MEM_LOCKED, 6);
@@ -413,9 +433,10 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
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
index 1f1f513..664d83f 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -71,6 +71,14 @@ enum hist_column {
 	HISTC_MEM_LVL,
 	HISTC_MEM_SNOOP,
 	HISTC_TRANSACTION,
+	HISTC_PHYSID_DADDR,
+	HISTC_PHYSID_IADDR,
+	HISTC_PHYSID_PID,
+	HISTC_PHYSID_TID,
+	HISTC_PHYSID_MAJOR,
+	HISTC_PHYSID_MINOR,
+	HISTC_PHYSID_INODE,
+	HISTC_PHYSID_INODE_GEN,
 	HISTC_NR_COLS, /* Last entry */
 };
 
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 635cd8f..e016fc1 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -977,6 +977,269 @@ struct sort_entry sort_transaction = {
 	.se_width_idx	= HISTC_TRANSACTION,
 };
 
+static int64_t
+sort__physid_daddr_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	u64 l, r;
+	struct map *l_map = left->mem_info->daddr.map;
+	struct map *r_map = right->mem_info->daddr.map;
+
+	/* store all NULL mem maps at the bottom */
+	/* shouldn't even need this check, should have stubs */
+	if (!left->mem_info->daddr.map || !right->mem_info->daddr.map)
+		return 1;
+
+	/* group event types together */
+	if (left->cpumode > right->cpumode) return -1;
+	if (left->cpumode < right->cpumode) return 1;
+
+	/*
+	 * Addresses with no major/minor numbers are assumed to be
+	 * anonymous in userspace.  Sort those on pid then address.
+	 *
+	 * The kernel and non-zero major/minor mapped areas are
+	 * assumed to be unity mapped.  Sort those on address then pid.
+	 */
+
+	if (l_map->maj || l_map->min || l_map->ino || l_map->ino_generation) {
+		/* mmapped areas */
+
+		if (l_map->maj > r_map->maj) return -1;
+		if (l_map->maj < r_map->maj) return 1;
+
+		if (l_map->min > r_map->min) return -1;
+		if (l_map->min < r_map->min) return 1;
+
+		if (l_map->ino > r_map->ino) return -1;
+		if (l_map->ino < r_map->ino) return 1;
+
+		if (l_map->ino_generation > r_map->ino_generation) return -1;
+		if (l_map->ino_generation < r_map->ino_generation) return 1;
+
+	} else if (left->cpumode != PERF_RECORD_MISC_KERNEL) {
+		/* userspace anonymous */
+		if (left->thread->pid_ > right->thread->pid_) return -1;
+		if (left->thread->pid_ < right->thread->pid_) return 1;
+	}
+
+	/* hack to mark similar regions, 'right' is new entry */
+	right->color = TRUE;
+
+	/* al_addr does all the right addr - start + offset calculations */
+	l = left->mem_info->daddr.al_addr;
+	r = right->mem_info->daddr.al_addr;
+
+	if (l > r) return -1;
+	if (l < r) return 1;
+
+	/* sanity check the maps; only mmaped areas should have different maps */
+	if ((left->mem_info->daddr.map != right->mem_info->daddr.map) &&
+	     !right->mem_info->daddr.map->maj && !right->mem_info->daddr.map->min)
+		pr_debug("physid_cmp: Similar entries have different maps\n");
+
+	return 0;
+}
+
+static int hist_entry__physid_daddr_snprintf(struct hist_entry *he, char *bf,
+					    size_t size, unsigned int width)
+{
+	uint64_t addr = 0;
+	struct map *map = NULL;
+	struct symbol *sym = NULL;
+	char level = he->level;
+
+	if (he->mem_info) {
+		addr = he->mem_info->daddr.addr;
+		map = he->mem_info->daddr.map;
+		sym = he->mem_info->daddr.sym;
+
+		/* print [s] for data mmaps */
+		if ((he->cpumode != PERF_RECORD_MISC_KERNEL) &&
+		     map && (map->type == MAP__VARIABLE) &&
+		    (map->maj || map->min || map->ino ||
+		     map->ino_generation))
+			level = 's';
+	}
+
+	return _hist_entry__sym_snprintf(map, sym, addr, level, bf, size,
+					 width);
+}
+
+struct sort_entry sort_physid_daddr = {
+	.se_header	= "Data Address",
+	.se_cmp		= sort__physid_daddr_cmp,
+	.se_snprintf	= hist_entry__physid_daddr_snprintf,
+	.se_width_idx	= HISTC_PHYSID_DADDR,
+};
+
+static int64_t
+sort__physid_iaddr_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	u64 l = left->mem_info->iaddr.al_addr;
+	u64 r = right->mem_info->iaddr.al_addr;
+
+	return r - l;
+}
+
+static int hist_entry__physid_iaddr_snprintf(struct hist_entry *he, char *bf,
+					    size_t size, unsigned int width)
+{
+	uint64_t addr = 0;
+	struct map *map = NULL;
+	struct symbol *sym = NULL;
+	char level = he->level;
+
+	if (he->mem_info) {
+		addr = he->mem_info->iaddr.addr;
+		map = he->mem_info->iaddr.map;
+		sym = he->mem_info->iaddr.sym;
+	}
+
+	return _hist_entry__sym_snprintf(map, sym, addr, level, bf, size,
+					 width);
+}
+
+struct sort_entry sort_physid_iaddr = {
+	.se_header	= "Source Address",
+	.se_cmp		= sort__physid_iaddr_cmp,
+	.se_snprintf	= hist_entry__physid_iaddr_snprintf,
+	.se_width_idx	= HISTC_PHYSID_IADDR,
+};
+
+static int64_t
+sort__physid_pid_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	pid_t l = left->thread->pid_;
+	pid_t r = right->thread->pid_;
+
+	return r - l;
+}
+
+static int hist_entry__physid_pid_snprintf(struct hist_entry *he, char *bf,
+					    size_t size, unsigned int width)
+{
+	const char *comm = thread__comm_str(he->thread);
+	return repsep_snprintf(bf, size, "%*s:%5d", width - 6,
+			       comm ?: "", he->thread->pid_);
+}
+
+struct sort_entry sort_physid_pid = {
+	.se_header	= "Command:  Pid",
+	.se_cmp		= sort__physid_pid_cmp,
+	.se_snprintf	= hist_entry__physid_pid_snprintf,
+	.se_width_idx	= HISTC_PHYSID_PID,
+};
+
+static int64_t
+sort__physid_tid_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	pid_t l = left->thread->tid;
+	pid_t r = right->thread->tid;
+
+	return r - l;
+}
+
+static int hist_entry__physid_tid_snprintf(struct hist_entry *he, char *bf,
+					    size_t size, unsigned int width)
+{
+	return repsep_snprintf(bf, size, "%*d", width, he->thread->tid);
+}
+
+struct sort_entry sort_physid_tid = {
+	.se_header	= "Tid  ",
+	.se_cmp		= sort__physid_tid_cmp,
+	.se_snprintf	= hist_entry__physid_tid_snprintf,
+	.se_width_idx	= HISTC_PHYSID_TID,
+};
+
+static int64_t
+sort__physid_major_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	struct map *l = left->mem_info->daddr.map;
+	struct map *r = right->mem_info->daddr.map;
+
+	return r->maj - l->maj;
+}
+
+static int hist_entry__physid_major_snprintf(struct hist_entry *he, char *bf,
+					    size_t size, unsigned int width)
+{
+	return repsep_snprintf(bf, size, "%*x", width, he->mem_info->daddr.map->maj);
+}
+
+struct sort_entry sort_physid_major = {
+	.se_header	= "Major",
+	.se_cmp		= sort__physid_major_cmp,
+	.se_snprintf	= hist_entry__physid_major_snprintf,
+	.se_width_idx	= HISTC_PHYSID_MAJOR,
+};
+
+static int64_t
+sort__physid_minor_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	struct map *l = left->mem_info->daddr.map;
+	struct map *r = right->mem_info->daddr.map;
+
+	return r->min - l->min;
+}
+
+static int hist_entry__physid_minor_snprintf(struct hist_entry *he, char *bf,
+					    size_t size, unsigned int width)
+{
+	return repsep_snprintf(bf, size, "%*x", width, he->mem_info->daddr.map->min);
+}
+
+struct sort_entry sort_physid_minor = {
+	.se_header	= "Minor",
+	.se_cmp		= sort__physid_minor_cmp,
+	.se_snprintf	= hist_entry__physid_minor_snprintf,
+	.se_width_idx	= HISTC_PHYSID_MINOR,
+};
+
+static int64_t
+sort__physid_inode_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	struct map *l = left->mem_info->daddr.map;
+	struct map *r = right->mem_info->daddr.map;
+
+	return r->ino - l->ino;
+}
+
+static int hist_entry__physid_inode_snprintf(struct hist_entry *he, char *bf,
+					    size_t size, unsigned int width)
+{
+	return repsep_snprintf(bf, size, "%*x", width, he->mem_info->daddr.map->ino);
+}
+
+struct sort_entry sort_physid_inode = {
+	.se_header	= "Inode    ",
+	.se_cmp		= sort__physid_inode_cmp,
+	.se_snprintf	= hist_entry__physid_inode_snprintf,
+	.se_width_idx	= HISTC_PHYSID_INODE,
+};
+
+static int64_t
+sort__physid_inode_gen_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	struct map *l = left->mem_info->daddr.map;
+	struct map *r = right->mem_info->daddr.map;
+
+	return r->ino_generation - l->ino_generation;
+}
+
+static int hist_entry__physid_inode_gen_snprintf(struct hist_entry *he, char *bf,
+					    size_t size, unsigned int width)
+{
+	return repsep_snprintf(bf, size, "%-*x", width, he->mem_info->daddr.map->ino_generation);
+}
+
+struct sort_entry sort_physid_inode_gen = {
+	.se_header	= "Inode Gen",
+	.se_cmp		= sort__physid_inode_gen_cmp,
+	.se_snprintf	= hist_entry__physid_inode_gen_snprintf,
+	.se_width_idx	= HISTC_PHYSID_INODE_GEN,
+};
+
 struct sort_dimension {
 	const char		*name;
 	struct sort_entry	*entry;
@@ -1027,6 +1290,21 @@ static struct sort_dimension memory_sort_dimensions[] = {
 
 #undef DIM
 
+#define DIM(d, n, func) [d - __SORT_PHYSID_MODE] = { .name = n, .entry = &(func) }
+
+static struct sort_dimension physid_sort_dimensions[] = {
+	DIM(SORT_PHYSID_DADDR, "daddr", sort_physid_daddr),
+	DIM(SORT_PHYSID_IADDR, "iaddr", sort_physid_iaddr),
+	DIM(SORT_PHYSID_PID, "pid", sort_physid_pid),
+	DIM(SORT_PHYSID_TID, "tid", sort_physid_tid),
+	DIM(SORT_PHYSID_MAJOR, "major", sort_physid_major),
+	DIM(SORT_PHYSID_MINOR, "minor", sort_physid_minor),
+	DIM(SORT_PHYSID_INODE, "inode", sort_physid_inode),
+	DIM(SORT_PHYSID_INODE_GEN, "inode_gen", sort_physid_inode_gen),
+};
+
+#undef DIM
+
 static void __sort_dimension__add(struct sort_dimension *sd, enum sort_type idx)
 {
 	if (sd->taken)
@@ -1104,6 +1382,22 @@ int sort_dimension__add(const char *tok)
 		return 0;
 	}
 
+	for (i = 0; i < ARRAY_SIZE(physid_sort_dimensions); i++) {
+		struct sort_dimension *sd = &physid_sort_dimensions[i];
+
+		if (strncasecmp(tok, sd->name, strlen(tok)))
+			continue;
+
+		if (sort__mode != SORT_MODE__PHYSID)
+			return -EINVAL;
+
+		if (sd->entry == &sort_physid_daddr)
+			sort__has_sym = 1;
+
+		__sort_dimension__add(sd, i + __SORT_PHYSID_MODE);
+		return 0;
+	}
+
 	return -ESRCH;
 }
 
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 43e5ff4..b1f52a8 100644
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
@@ -133,6 +135,7 @@ enum sort_mode {
 	SORT_MODE__NORMAL,
 	SORT_MODE__BRANCH,
 	SORT_MODE__MEMORY,
+	SORT_MODE__PHYSID,
 };
 
 enum sort_type {
@@ -166,6 +169,16 @@ enum sort_type {
 	SORT_MEM_TLB,
 	SORT_MEM_LVL,
 	SORT_MEM_SNOOP,
+
+	__SORT_PHYSID_MODE,
+	SORT_PHYSID_DADDR = __SORT_PHYSID_MODE,
+	SORT_PHYSID_IADDR,
+	SORT_PHYSID_PID,
+	SORT_PHYSID_TID,
+	SORT_PHYSID_MAJOR,
+	SORT_PHYSID_MINOR,
+	SORT_PHYSID_INODE,
+	SORT_PHYSID_INODE_GEN,
 };
 
 /*
-- 
1.7.11.7

