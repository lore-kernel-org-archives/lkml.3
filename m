Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab3JHMMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:12:36 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:38717 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab3JHMMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:12:31 -0400
Date: Tue, 8 Oct 2013 14:12:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20131008121223.GA2791@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 1651d120baddf68846188bcdf0ef5350068436cf Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

Various fixlets:

 - On the kernel side:

    - fix a race
    - fix a bug in the handling of the perf ring-buffer data page

 - On the tooling side:

    - fix the handling of certain corrupted perf.data files
    - fix a bug in 'perf probe'
    - fix a bug in 'perf record + perf sched'
    - fix a bug in 'make install'
    - fix a bug in libaudit feature-detection on certain distros

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (2):
      perf tools: Fix libaudit test
      perf tools: Fix installation of libexec components

David Ahern (1):
      perf tools: Add default handler for mmap2 events

Masami Hiramatsu (1):
      perf probe: Fix to find line information for probe list

Namhyung Kim (2):
      perf stat: Set child_pid after perf_evlist__prepare_workload()
      perf session: Fix infinite loop on invalid perf.data file

Peter Zijlstra (2):
      perf: Fix perf_pmu_migrate_context
      perf/x86: Clean up cap_user_time* setting


 arch/x86/kernel/cpu/perf_event.c    | 11 +++------
 include/linux/perf_event.h          | 24 +++++++++++++++++-
 kernel/events/core.c                |  6 ++---
 tools/perf/Makefile                 |  1 +
 tools/perf/builtin-stat.c           |  1 +
 tools/perf/config/feature-tests.mak |  2 +-
 tools/perf/util/dwarf-aux.c         | 25 ++++++++++++++++---
 tools/perf/util/dwarf-aux.h         |  6 ++++-
 tools/perf/util/header.c            | 12 +++++++++
 tools/perf/util/probe-finder.c      | 49 +++++++++++++++++++++++++------------
 tools/perf/util/session.c           |  4 ++-
 11 files changed, 106 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 897783b..9d84491 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1888,10 +1888,7 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 	userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc;
 	userpg->pmc_width = x86_pmu.cntval_bits;
 
-	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
-		return;
-
-	if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
+	if (!sched_clock_stable)
 		return;
 
 	userpg->cap_user_time = 1;
@@ -1899,10 +1896,8 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 	userpg->time_shift = CYC2NS_SCALE_FACTOR;
 	userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
 
-	if (sched_clock_stable && !check_tsc_disabled()) {
-		userpg->cap_user_time_zero = 1;
-		userpg->time_zero = this_cpu_read(cyc2ns_offset);
-	}
+	userpg->cap_user_time_zero = 1;
+	userpg->time_zero = this_cpu_read(cyc2ns_offset);
 }
 
 /*
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 866e85c..c8ba627 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -294,9 +294,31 @@ struct ring_buffer;
  */
 struct perf_event {
 #ifdef CONFIG_PERF_EVENTS
-	struct list_head		group_entry;
+	/*
+	 * entry onto perf_event_context::event_list;
+	 *   modifications require ctx->lock
+	 *   RCU safe iterations.
+	 */
 	struct list_head		event_entry;
+
+	/*
+	 * XXX: group_entry and sibling_list should be mutually exclusive;
+	 * either you're a sibling on a group, or you're the group leader.
+	 * Rework the code to always use the same list element.
+	 *
+	 * Locked for modification by both ctx->mutex and ctx->lock; holding
+	 * either sufficies for read.
+	 */
+	struct list_head		group_entry;
 	struct list_head		sibling_list;
+
+	/*
+	 * We need storage to track the entries in perf_pmu_migrate_context; we
+	 * cannot use the event_entry because of RCU and we want to keep the
+	 * group in tact which avoids us using the other two entries.
+	 */
+	struct list_head		migrate_entry;
+
 	struct hlist_node		hlist_entry;
 	int				nr_siblings;
 	int				group_flags;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index cb4238e..d49a9d2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7234,15 +7234,15 @@ void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
 		perf_remove_from_context(event);
 		unaccount_event_cpu(event, src_cpu);
 		put_ctx(src_ctx);
-		list_add(&event->event_entry, &events);
+		list_add(&event->migrate_entry, &events);
 	}
 	mutex_unlock(&src_ctx->mutex);
 
 	synchronize_rcu();
 
 	mutex_lock(&dst_ctx->mutex);
-	list_for_each_entry_safe(event, tmp, &events, event_entry) {
-		list_del(&event->event_entry);
+	list_for_each_entry_safe(event, tmp, &events, migrate_entry) {
+		list_del(&event->migrate_entry);
 		if (event->state >= PERF_EVENT_STATE_OFF)
 			event->state = PERF_EVENT_STATE_INACTIVE;
 		account_event_cpu(event, dst_cpu);
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3a0ff7f..64c043b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -770,6 +770,7 @@ check: $(OUTPUT)common-cmds.h
 install-bin: all
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
 	$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 	$(INSTALL) $(OUTPUT)perf-archive -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 ifndef NO_LIBPERL
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index f686d5f..5098f14 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -457,6 +457,7 @@ static int __run_perf_stat(int argc, const char **argv)
 			perror("failed to prepare workload");
 			return -1;
 		}
+		child_pid = evsel_list->workload.pid;
 	}
 
 	if (group)
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index d5a8dd4..f793057 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -219,7 +219,7 @@ define SOURCE_LIBAUDIT
 
 int main(void)
 {
-	printf(\"error message: %s\n\", audit_errno_to_name(0));
+	printf(\"error message: %s\", audit_errno_to_name(0));
 	return audit_open();
 }
 endef
diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index e23bde1..7defd77 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -426,7 +426,7 @@ static int __die_search_func_cb(Dwarf_Die *fn_die, void *data)
  * @die_mem: a buffer for result DIE
  *
  * Search a non-inlined function DIE which includes @addr. Stores the
- * DIE to @die_mem and returns it if found. Returns NULl if failed.
+ * DIE to @die_mem and returns it if found. Returns NULL if failed.
  */
 Dwarf_Die *die_find_realfunc(Dwarf_Die *cu_die, Dwarf_Addr addr,
 				    Dwarf_Die *die_mem)
@@ -454,15 +454,32 @@ static int __die_find_inline_cb(Dwarf_Die *die_mem, void *data)
 }
 
 /**
+ * die_find_top_inlinefunc - Search the top inlined function at given address
+ * @sp_die: a subprogram DIE which including @addr
+ * @addr: target address
+ * @die_mem: a buffer for result DIE
+ *
+ * Search an inlined function DIE which includes @addr. Stores the
+ * DIE to @die_mem and returns it if found. Returns NULL if failed.
+ * Even if several inlined functions are expanded recursively, this
+ * doesn't trace it down, and returns the topmost one.
+ */
+Dwarf_Die *die_find_top_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
+				   Dwarf_Die *die_mem)
+{
+	return die_find_child(sp_die, __die_find_inline_cb, &addr, die_mem);
+}
+
+/**
  * die_find_inlinefunc - Search an inlined function at given address
- * @cu_die: a CU DIE which including @addr
+ * @sp_die: a subprogram DIE which including @addr
  * @addr: target address
  * @die_mem: a buffer for result DIE
  *
  * Search an inlined function DIE which includes @addr. Stores the
- * DIE to @die_mem and returns it if found. Returns NULl if failed.
+ * DIE to @die_mem and returns it if found. Returns NULL if failed.
  * If several inlined functions are expanded recursively, this trace
- * it and returns deepest one.
+ * it down and returns deepest one.
  */
 Dwarf_Die *die_find_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
 			       Dwarf_Die *die_mem)
diff --git a/tools/perf/util/dwarf-aux.h b/tools/perf/util/dwarf-aux.h
index 8658d41..b4fe90c 100644
--- a/tools/perf/util/dwarf-aux.h
+++ b/tools/perf/util/dwarf-aux.h
@@ -79,7 +79,11 @@ extern Dwarf_Die *die_find_child(Dwarf_Die *rt_die,
 extern Dwarf_Die *die_find_realfunc(Dwarf_Die *cu_die, Dwarf_Addr addr,
 				    Dwarf_Die *die_mem);
 
-/* Search an inlined function including given address */
+/* Search the top inlined function including given address */
+extern Dwarf_Die *die_find_top_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
+					  Dwarf_Die *die_mem);
+
+/* Search the deepest inlined function including given address */
 extern Dwarf_Die *die_find_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
 				      Dwarf_Die *die_mem);
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ce69901..c3e5a3b 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2768,6 +2768,18 @@ int perf_session__read_header(struct perf_session *session)
 	if (perf_file_header__read(&f_header, header, fd) < 0)
 		return -EINVAL;
 
+	/*
+	 * Sanity check that perf.data was written cleanly; data size is
+	 * initialized to 0 and updated only if the on_exit function is run.
+	 * If data size is still 0 then the file contains only partial
+	 * information.  Just warn user and process it as much as it can.
+	 */
+	if (f_header.data.size == 0) {
+		pr_warning("WARNING: The %s file's data size field is 0 which is unexpected.\n"
+			   "Was the 'perf record' command properly terminated?\n",
+			   session->filename);
+	}
+
 	nr_attrs = f_header.attrs.size / f_header.attr_size;
 	lseek(fd, f_header.attrs.offset, SEEK_SET);
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 371476c..c09e0a9 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1327,8 +1327,8 @@ int debuginfo__find_probe_point(struct debuginfo *self, unsigned long addr,
 				struct perf_probe_point *ppt)
 {
 	Dwarf_Die cudie, spdie, indie;
-	Dwarf_Addr _addr, baseaddr;
-	const char *fname = NULL, *func = NULL, *tmp;
+	Dwarf_Addr _addr = 0, baseaddr = 0;
+	const char *fname = NULL, *func = NULL, *basefunc = NULL, *tmp;
 	int baseline = 0, lineno = 0, ret = 0;
 
 	/* Adjust address with bias */
@@ -1349,27 +1349,36 @@ int debuginfo__find_probe_point(struct debuginfo *self, unsigned long addr,
 	/* Find a corresponding function (name, baseline and baseaddr) */
 	if (die_find_realfunc(&cudie, (Dwarf_Addr)addr, &spdie)) {
 		/* Get function entry information */
-		tmp = dwarf_diename(&spdie);
-		if (!tmp ||
+		func = basefunc = dwarf_diename(&spdie);
+		if (!func ||
 		    dwarf_entrypc(&spdie, &baseaddr) != 0 ||
-		    dwarf_decl_line(&spdie, &baseline) != 0)
+		    dwarf_decl_line(&spdie, &baseline) != 0) {
+			lineno = 0;
 			goto post;
-		func = tmp;
+		}
 
-		if (addr == (unsigned long)baseaddr)
+		if (addr == (unsigned long)baseaddr) {
 			/* Function entry - Relative line number is 0 */
 			lineno = baseline;
-		else if (die_find_inlinefunc(&spdie, (Dwarf_Addr)addr,
-					     &indie)) {
+			fname = dwarf_decl_file(&spdie);
+			goto post;
+		}
+
+		/* Track down the inline functions step by step */
+		while (die_find_top_inlinefunc(&spdie, (Dwarf_Addr)addr,
+						&indie)) {
+			/* There is an inline function */
 			if (dwarf_entrypc(&indie, &_addr) == 0 &&
-			    _addr == addr)
+			    _addr == addr) {
 				/*
 				 * addr is at an inline function entry.
 				 * In this case, lineno should be the call-site
-				 * line number.
+				 * line number. (overwrite lineinfo)
 				 */
 				lineno = die_get_call_lineno(&indie);
-			else {
+				fname = die_get_call_file(&indie);
+				break;
+			} else {
 				/*
 				 * addr is in an inline function body.
 				 * Since lineno points one of the lines
@@ -1377,19 +1386,27 @@ int debuginfo__find_probe_point(struct debuginfo *self, unsigned long addr,
 				 * be the entry line of the inline function.
 				 */
 				tmp = dwarf_diename(&indie);
-				if (tmp &&
-				    dwarf_decl_line(&spdie, &baseline) == 0)
-					func = tmp;
+				if (!tmp ||
+				    dwarf_decl_line(&indie, &baseline) != 0)
+					break;
+				func = tmp;
+				spdie = indie;
 			}
 		}
+		/* Verify the lineno and baseline are in a same file */
+		tmp = dwarf_decl_file(&spdie);
+		if (!tmp || strcmp(tmp, fname) != 0)
+			lineno = 0;
 	}
 
 post:
 	/* Make a relative line number or an offset */
 	if (lineno)
 		ppt->line = lineno - baseline;
-	else if (func)
+	else if (basefunc) {
 		ppt->offset = addr - (unsigned long)baseaddr;
+		func = basefunc;
+	}
 
 	/* Duplicate strings */
 	if (func) {
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 70ffa41..568b750 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -256,6 +256,8 @@ void perf_tool__fill_defaults(struct perf_tool *tool)
 		tool->sample = process_event_sample_stub;
 	if (tool->mmap == NULL)
 		tool->mmap = process_event_stub;
+	if (tool->mmap2 == NULL)
+		tool->mmap2 = process_event_stub;
 	if (tool->comm == NULL)
 		tool->comm = process_event_stub;
 	if (tool->fork == NULL)
@@ -1310,7 +1312,7 @@ int __perf_session__process_events(struct perf_session *session,
 	file_offset = page_offset;
 	head = data_offset - page_offset;
 
-	if (data_offset + data_size < file_size)
+	if (data_size && (data_offset + data_size < file_size))
 		file_size = data_offset + data_size;
 
 	progress_next = file_size / 16;
