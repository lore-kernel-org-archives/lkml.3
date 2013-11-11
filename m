Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab3KKUX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:23:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43956 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3KKUWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:22:52 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/10] perf evsel: Remove idx parm from constructor
Date: Mon, 11 Nov 2013 17:22:25 -0300
Message-Id: <1384201353-23863-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384201353-23863-1-git-send-email-acme@infradead.org>
References: <1384201353-23863-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Most uses of the evsel constructor are followed by a call to
perf_evlist__add with an idex of evlist->nr_entries, so make rename
the current constructor to perf_evsel__new_idx and remove the need
for passing the constructor for the common case.

We still need the new_idx variant because the way groups are handled,
with evsel->nr_members holding the number of entries in an evlist,
partitioning the evlist into sublists inside a single linked list.

This asks for a clarifying refactoring, but for now simplify the non
parser cases, so that tool writers don't have to bother with evsel idx
setting.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-zy9tskx6jqm2rmw7468zze2a@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c                | 13 +++++--------
 tools/perf/tests/evsel-tp-sched.c         |  4 ++--
 tools/perf/tests/mmap-basic.c             |  2 +-
 tools/perf/tests/open-syscall-all-cpus.c  |  2 +-
 tools/perf/tests/open-syscall-tp-fields.c |  2 +-
 tools/perf/tests/open-syscall.c           |  2 +-
 tools/perf/tests/sw-clock.c               |  2 +-
 tools/perf/util/evlist.c                  |  9 +++++----
 tools/perf/util/evsel.c                   |  4 ++--
 tools/perf/util/evsel.h                   | 15 +++++++++++++--
 tools/perf/util/header.c                  |  4 ++--
 tools/perf/util/parse-events.c            |  6 +++---
 12 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 329b7832b5da..68943cad70d4 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -149,10 +149,9 @@ static void perf_evsel__delete_priv(struct perf_evsel *evsel)
 	perf_evsel__delete(evsel);
 }
 
-static struct perf_evsel *perf_evsel__syscall_newtp(const char *direction,
-						    void *handler, int idx)
+static struct perf_evsel *perf_evsel__syscall_newtp(const char *direction, void *handler)
 {
-	struct perf_evsel *evsel = perf_evsel__newtp("raw_syscalls", direction, idx);
+	struct perf_evsel *evsel = perf_evsel__newtp("raw_syscalls", direction);
 
 	if (evsel) {
 		evsel->priv = malloc(sizeof(struct syscall_tp));
@@ -186,17 +185,16 @@ static int perf_evlist__add_syscall_newtp(struct perf_evlist *evlist,
 					  void *sys_exit_handler)
 {
 	int ret = -1;
-	int idx = evlist->nr_entries;
 	struct perf_evsel *sys_enter, *sys_exit;
 
-	sys_enter = perf_evsel__syscall_newtp("sys_enter", sys_enter_handler, idx++);
+	sys_enter = perf_evsel__syscall_newtp("sys_enter", sys_enter_handler);
 	if (sys_enter == NULL)
 		goto out;
 
 	if (perf_evsel__init_sc_tp_ptr_field(sys_enter, args))
 		goto out_delete_sys_enter;
 
-	sys_exit = perf_evsel__syscall_newtp("sys_exit", sys_exit_handler, idx++);
+	sys_exit = perf_evsel__syscall_newtp("sys_exit", sys_exit_handler);
 	if (sys_exit == NULL)
 		goto out_delete_sys_enter;
 
@@ -1824,8 +1822,7 @@ static size_t trace__fprintf_thread_summary(struct trace *trace, FILE *fp);
 
 static void perf_evlist__add_vfs_getname(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = perf_evsel__newtp("probe", "vfs_getname",
-						     evlist->nr_entries);
+	struct perf_evsel *evsel = perf_evsel__newtp("probe", "vfs_getname");
 	if (evsel == NULL)
 		return;
 
diff --git a/tools/perf/tests/evsel-tp-sched.c b/tools/perf/tests/evsel-tp-sched.c
index 9b98c1554833..4774f7fbb758 100644
--- a/tools/perf/tests/evsel-tp-sched.c
+++ b/tools/perf/tests/evsel-tp-sched.c
@@ -32,7 +32,7 @@ static int perf_evsel__test_field(struct perf_evsel *evsel, const char *name,
 
 int test__perf_evsel__tp_sched_test(void)
 {
-	struct perf_evsel *evsel = perf_evsel__newtp("sched", "sched_switch", 0);
+	struct perf_evsel *evsel = perf_evsel__newtp("sched", "sched_switch");
 	int ret = 0;
 
 	if (evsel == NULL) {
@@ -63,7 +63,7 @@ int test__perf_evsel__tp_sched_test(void)
 
 	perf_evsel__delete(evsel);
 
-	evsel = perf_evsel__newtp("sched", "sched_wakeup", 0);
+	evsel = perf_evsel__newtp("sched", "sched_wakeup");
 
 	if (perf_evsel__test_field(evsel, "comm", 16, true))
 		ret = -1;
diff --git a/tools/perf/tests/mmap-basic.c b/tools/perf/tests/mmap-basic.c
index a7232c204eb9..d64ab79c6d35 100644
--- a/tools/perf/tests/mmap-basic.c
+++ b/tools/perf/tests/mmap-basic.c
@@ -65,7 +65,7 @@ int test__basic_mmap(void)
 		char name[64];
 
 		snprintf(name, sizeof(name), "sys_enter_%s", syscall_names[i]);
-		evsels[i] = perf_evsel__newtp("syscalls", name, i);
+		evsels[i] = perf_evsel__newtp("syscalls", name);
 		if (evsels[i] == NULL) {
 			pr_debug("perf_evsel__new\n");
 			goto out_free_evlist;
diff --git a/tools/perf/tests/open-syscall-all-cpus.c b/tools/perf/tests/open-syscall-all-cpus.c
index b0657a9ccda6..5fecdbd2f5f7 100644
--- a/tools/perf/tests/open-syscall-all-cpus.c
+++ b/tools/perf/tests/open-syscall-all-cpus.c
@@ -26,7 +26,7 @@ int test__open_syscall_event_on_all_cpus(void)
 
 	CPU_ZERO(&cpu_set);
 
-	evsel = perf_evsel__newtp("syscalls", "sys_enter_open", 0);
+	evsel = perf_evsel__newtp("syscalls", "sys_enter_open");
 	if (evsel == NULL) {
 		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
 		goto out_thread_map_delete;
diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
index 524b221b829b..41cc0badb74b 100644
--- a/tools/perf/tests/open-syscall-tp-fields.c
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -27,7 +27,7 @@ int test__syscall_open_tp_fields(void)
 		goto out;
 	}
 
-	evsel = perf_evsel__newtp("syscalls", "sys_enter_open", 0);
+	evsel = perf_evsel__newtp("syscalls", "sys_enter_open");
 	if (evsel == NULL) {
 		pr_debug("%s: perf_evsel__newtp\n", __func__);
 		goto out_delete_evlist;
diff --git a/tools/perf/tests/open-syscall.c b/tools/perf/tests/open-syscall.c
index befc0671f95d..c1dc7d25f38c 100644
--- a/tools/perf/tests/open-syscall.c
+++ b/tools/perf/tests/open-syscall.c
@@ -15,7 +15,7 @@ int test__open_syscall_event(void)
 		return -1;
 	}
 
-	evsel = perf_evsel__newtp("syscalls", "sys_enter_open", 0);
+	evsel = perf_evsel__newtp("syscalls", "sys_enter_open");
 	if (evsel == NULL) {
 		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
 		goto out_thread_map_delete;
diff --git a/tools/perf/tests/sw-clock.c b/tools/perf/tests/sw-clock.c
index 6e2b44ec0749..73c5c37cb27b 100644
--- a/tools/perf/tests/sw-clock.c
+++ b/tools/perf/tests/sw-clock.c
@@ -42,7 +42,7 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
 		return -1;
 	}
 
-	evsel = perf_evsel__new(&attr, 0);
+	evsel = perf_evsel__new(&attr);
 	if (evsel == NULL) {
 		pr_debug("perf_evsel__new\n");
 		goto out_free_evlist;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b939221efd8d..99dc58e5dcc3 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -117,6 +117,8 @@ void perf_evlist__delete(struct perf_evlist *evlist)
 void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry)
 {
 	list_add_tail(&entry->node, &evlist->entries);
+	entry->idx = evlist->nr_entries;
+
 	if (!evlist->nr_entries++)
 		perf_evlist__set_id_pos(evlist);
 }
@@ -165,7 +167,7 @@ int perf_evlist__add_default(struct perf_evlist *evlist)
 
 	event_attr_init(&attr);
 
-	evsel = perf_evsel__new(&attr, 0);
+	evsel = perf_evsel__new(&attr);
 	if (evsel == NULL)
 		goto error;
 
@@ -190,7 +192,7 @@ static int perf_evlist__add_attrs(struct perf_evlist *evlist,
 	size_t i;
 
 	for (i = 0; i < nr_attrs; i++) {
-		evsel = perf_evsel__new(attrs + i, evlist->nr_entries + i);
+		evsel = perf_evsel__new_idx(attrs + i, evlist->nr_entries + i);
 		if (evsel == NULL)
 			goto out_delete_partial_list;
 		list_add_tail(&evsel->node, &head);
@@ -249,9 +251,8 @@ perf_evlist__find_tracepoint_by_name(struct perf_evlist *evlist,
 int perf_evlist__add_newtp(struct perf_evlist *evlist,
 			   const char *sys, const char *name, void *handler)
 {
-	struct perf_evsel *evsel;
+	struct perf_evsel *evsel = perf_evsel__newtp(sys, name);
 
-	evsel = perf_evsel__newtp(sys, name, evlist->nr_entries);
 	if (evsel == NULL)
 		return -1;
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 5280820ed389..f95653a639a6 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -168,7 +168,7 @@ void perf_evsel__init(struct perf_evsel *evsel,
 	perf_evsel__calc_id_pos(evsel);
 }
 
-struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
+struct perf_evsel *perf_evsel__new_idx(struct perf_event_attr *attr, int idx)
 {
 	struct perf_evsel *evsel = zalloc(sizeof(*evsel));
 
@@ -219,7 +219,7 @@ out:
 	return format;
 }
 
-struct perf_evsel *perf_evsel__newtp(const char *sys, const char *name, int idx)
+struct perf_evsel *perf_evsel__newtp_idx(const char *sys, const char *name, int idx)
 {
 	struct perf_evsel *evsel = zalloc(sizeof(*evsel));
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 64ec8e1a7a28..0178233abd64 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -96,8 +96,19 @@ struct thread_map;
 struct perf_evlist;
 struct perf_record_opts;
 
-struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx);
-struct perf_evsel *perf_evsel__newtp(const char *sys, const char *name, int idx);
+struct perf_evsel *perf_evsel__new_idx(struct perf_event_attr *attr, int idx);
+
+static inline struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr)
+{
+	return perf_evsel__new_idx(attr, 0);
+}
+
+struct perf_evsel *perf_evsel__newtp_idx(const char *sys, const char *name, int idx);
+
+static inline struct perf_evsel *perf_evsel__newtp(const char *sys, const char *name)
+{
+	return perf_evsel__newtp_idx(sys, name, 0);
+}
 
 struct event_format *event_format__new(const char *sys, const char *name);
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 26d9520a0c1b..369c03648f88 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2797,7 +2797,7 @@ int perf_session__read_header(struct perf_session *session)
 			perf_event__attr_swap(&f_attr.attr);
 
 		tmp = lseek(fd, 0, SEEK_CUR);
-		evsel = perf_evsel__new(&f_attr.attr, i);
+		evsel = perf_evsel__new(&f_attr.attr);
 
 		if (evsel == NULL)
 			goto out_delete_evlist;
@@ -2916,7 +2916,7 @@ int perf_event__process_attr(struct perf_tool *tool __maybe_unused,
 			return -ENOMEM;
 	}
 
-	evsel = perf_evsel__new(&event->attr.attr, evlist->nr_entries);
+	evsel = perf_evsel__new(&event->attr.attr);
 	if (evsel == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c90e55cf7e82..6de6f89c2a61 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -277,7 +277,7 @@ static int __add_event(struct list_head *list, int *idx,
 
 	event_attr_init(attr);
 
-	evsel = perf_evsel__new(attr, (*idx)++);
+	evsel = perf_evsel__new_idx(attr, (*idx)++);
 	if (!evsel)
 		return -ENOMEM;
 
@@ -378,7 +378,7 @@ static int add_tracepoint(struct list_head *list, int *idx,
 {
 	struct perf_evsel *evsel;
 
-	evsel = perf_evsel__newtp(sys_name, evt_name, (*idx)++);
+	evsel = perf_evsel__newtp_idx(sys_name, evt_name, (*idx)++);
 	if (!evsel)
 		return -ENOMEM;
 
@@ -1097,7 +1097,7 @@ static bool is_event_supported(u8 type, unsigned config)
 		.threads = { 0 },
 	};
 
-	evsel = perf_evsel__new(&attr, 0);
+	evsel = perf_evsel__new(&attr);
 	if (evsel) {
 		ret = perf_evsel__open(evsel, NULL, &tmap.map) >= 0;
 		perf_evsel__delete(evsel);
-- 
1.8.1.4

