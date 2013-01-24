Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab3AXUbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:31:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50156 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757Ab3AXUIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:41 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 20/74] perf machine: Introduce struct machines
Date: Thu, 24 Jan 2013 17:07:29 -0300
Message-Id: <1359058103-31645-21-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

That consolidates the grouping of host + guests, isolating a bit more of
functionality now centered on 'perf_session' that can be used
independently in tools that don't need a 'perf_session' instance, but
needs to have all the thread/map/symbol machinery.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-c700rsiphpmzv8klogojpfut@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c   |  4 +--
 tools/perf/builtin-report.c   |  2 +-
 tools/perf/builtin-top.c      |  4 +--
 tools/perf/tests/hists_link.c | 17 +++++-------
 tools/perf/util/header.c      | 12 ++++----
 tools/perf/util/machine.c     | 64 ++++++++++++++++++++++++++++---------------
 tools/perf/util/machine.h     | 32 ++++++++++++++--------
 tools/perf/util/session.c     | 30 ++++++++------------
 tools/perf/util/session.h     | 11 ++------
 9 files changed, 95 insertions(+), 81 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 69e2895..a0b2427 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -571,8 +571,8 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		       "Check /proc/modules permission or run as root.\n");
 
 	if (perf_guest) {
-		machines__process(&session->machines,
-				  perf_event__synthesize_guest_os, tool);
+		machines__process_guests(&session->machines,
+					 perf_event__synthesize_guest_os, tool);
 	}
 
 	if (!opts->target.system_wide)
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 5134acf..13cdf61 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -372,7 +372,7 @@ static int __cmd_report(struct perf_report *rep)
 	if (ret)
 		goto out_delete;
 
-	kernel_map = session->host_machine.vmlinux_maps[MAP__FUNCTION];
+	kernel_map = session->machines.host.vmlinux_maps[MAP__FUNCTION];
 	kernel_kmap = map__kmap(kernel_map);
 	if (kernel_map == NULL ||
 	    (kernel_map->dso->hit &&
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 996b10c..e0ecebd 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -966,10 +966,10 @@ static int __cmd_top(struct perf_top *top)
 	if (perf_target__has_task(&opts->target))
 		perf_event__synthesize_thread_map(&top->tool, top->evlist->threads,
 						  perf_event__process,
-						  &top->session->host_machine);
+						  &top->session->machines.host);
 	else
 		perf_event__synthesize_threads(&top->tool, perf_event__process,
-					       &top->session->host_machine);
+					       &top->session->machines.host);
 	perf_top__start_counters(top);
 	top->session->evlist = top->evlist;
 	perf_session__set_id_hdr_size(top->session);
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 0f1aae3..27860a0 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -75,13 +75,11 @@ static struct {
 	{ "[kernel]", kernel_syms, ARRAY_SIZE(kernel_syms) },
 };
 
-static struct machine *setup_fake_machine(void)
+static struct machine *setup_fake_machine(struct machines *machines)
 {
-	struct rb_root machine_root = RB_ROOT;
-	struct machine *machine;
+	struct machine *machine = machines__find(machines, HOST_KERNEL_ID);
 	size_t i;
 
-	machine = machines__findnew(&machine_root, HOST_KERNEL_ID);
 	if (machine == NULL) {
 		pr_debug("Not enough memory for machine setup\n");
 		return NULL;
@@ -435,6 +433,7 @@ static void print_hists(struct hists *hists)
 int test__hists_link(void)
 {
 	int err = -1;
+	struct machines machines;
 	struct machine *machine = NULL;
 	struct perf_evsel *evsel, *first;
         struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
@@ -452,8 +451,10 @@ int test__hists_link(void)
 	/* default sort order (comm,dso,sym) will be used */
 	setup_sorting(NULL, NULL);
 
+	machines__init(&machines);
+
 	/* setup threads/dso/map/symbols also */
-	machine = setup_fake_machine();
+	machine = setup_fake_machine(&machines);
 	if (!machine)
 		goto out;
 
@@ -492,11 +493,7 @@ int test__hists_link(void)
 out:
 	/* tear down everything */
 	perf_evlist__delete(evlist);
-
-	if (machine) {
-		machine__delete_threads(machine);
-		machine__delete(machine);
-	}
+	machines__exit(&machines);
 
 	return err;
 }
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index bb578d2..fccd69d 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -287,12 +287,12 @@ static int dsos__write_buildid_table(struct perf_header *header, int fd)
 	struct perf_session *session = container_of(header,
 			struct perf_session, header);
 	struct rb_node *nd;
-	int err = machine__write_buildid_table(&session->host_machine, fd);
+	int err = machine__write_buildid_table(&session->machines.host, fd);
 
 	if (err)
 		return err;
 
-	for (nd = rb_first(&session->machines); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
 		err = machine__write_buildid_table(pos, fd);
 		if (err)
@@ -448,9 +448,9 @@ static int perf_session__cache_build_ids(struct perf_session *session)
 	if (mkdir(debugdir, 0755) != 0 && errno != EEXIST)
 		return -1;
 
-	ret = machine__cache_build_ids(&session->host_machine, debugdir);
+	ret = machine__cache_build_ids(&session->machines.host, debugdir);
 
-	for (nd = rb_first(&session->machines); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
 		ret |= machine__cache_build_ids(pos, debugdir);
 	}
@@ -467,9 +467,9 @@ static bool machine__read_build_ids(struct machine *machine, bool with_hits)
 static bool perf_session__read_build_ids(struct perf_session *session, bool with_hits)
 {
 	struct rb_node *nd;
-	bool ret = machine__read_build_ids(&session->host_machine, with_hits);
+	bool ret = machine__read_build_ids(&session->machines.host, with_hits);
 
-	for (nd = rb_first(&session->machines); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
 		ret |= machine__read_build_ids(pos, with_hits);
 	}
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 71fa903..efdb38e 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -91,10 +91,22 @@ void machine__delete(struct machine *machine)
 	free(machine);
 }
 
-struct machine *machines__add(struct rb_root *machines, pid_t pid,
+void machines__init(struct machines *machines)
+{
+	machine__init(&machines->host, "", HOST_KERNEL_ID);
+	machines->guests = RB_ROOT;
+}
+
+void machines__exit(struct machines *machines)
+{
+	machine__exit(&machines->host);
+	/* XXX exit guest */
+}
+
+struct machine *machines__add(struct machines *machines, pid_t pid,
 			      const char *root_dir)
 {
-	struct rb_node **p = &machines->rb_node;
+	struct rb_node **p = &machines->guests.rb_node;
 	struct rb_node *parent = NULL;
 	struct machine *pos, *machine = malloc(sizeof(*machine));
 
@@ -116,18 +128,21 @@ struct machine *machines__add(struct rb_root *machines, pid_t pid,
 	}
 
 	rb_link_node(&machine->rb_node, parent, p);
-	rb_insert_color(&machine->rb_node, machines);
+	rb_insert_color(&machine->rb_node, &machines->guests);
 
 	return machine;
 }
 
-struct machine *machines__find(struct rb_root *machines, pid_t pid)
+struct machine *machines__find(struct machines *machines, pid_t pid)
 {
-	struct rb_node **p = &machines->rb_node;
+	struct rb_node **p = &machines->guests.rb_node;
 	struct rb_node *parent = NULL;
 	struct machine *machine;
 	struct machine *default_machine = NULL;
 
+	if (pid == HOST_KERNEL_ID)
+		return &machines->host;
+
 	while (*p != NULL) {
 		parent = *p;
 		machine = rb_entry(parent, struct machine, rb_node);
@@ -144,7 +159,7 @@ struct machine *machines__find(struct rb_root *machines, pid_t pid)
 	return default_machine;
 }
 
-struct machine *machines__findnew(struct rb_root *machines, pid_t pid)
+struct machine *machines__findnew(struct machines *machines, pid_t pid)
 {
 	char path[PATH_MAX];
 	const char *root_dir = "";
@@ -178,12 +193,12 @@ out:
 	return machine;
 }
 
-void machines__process(struct rb_root *machines,
-		       machine__process_t process, void *data)
+void machines__process_guests(struct machines *machines,
+			      machine__process_t process, void *data)
 {
 	struct rb_node *nd;
 
-	for (nd = rb_first(machines); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&machines->guests); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
 		process(pos, data);
 	}
@@ -203,12 +218,14 @@ char *machine__mmap_name(struct machine *machine, char *bf, size_t size)
 	return bf;
 }
 
-void machines__set_id_hdr_size(struct rb_root *machines, u16 id_hdr_size)
+void machines__set_id_hdr_size(struct machines *machines, u16 id_hdr_size)
 {
 	struct rb_node *node;
 	struct machine *machine;
 
-	for (node = rb_first(machines); node; node = rb_next(node)) {
+	machines->host.id_hdr_size = id_hdr_size;
+
+	for (node = rb_first(&machines->guests); node; node = rb_next(node)) {
 		machine = rb_entry(node, struct machine, rb_node);
 		machine->id_hdr_size = id_hdr_size;
 	}
@@ -313,12 +330,13 @@ struct map *machine__new_module(struct machine *machine, u64 start,
 	return map;
 }
 
-size_t machines__fprintf_dsos(struct rb_root *machines, FILE *fp)
+size_t machines__fprintf_dsos(struct machines *machines, FILE *fp)
 {
 	struct rb_node *nd;
-	size_t ret = 0;
+	size_t ret = __dsos__fprintf(&machines->host.kernel_dsos, fp) +
+		     __dsos__fprintf(&machines->host.user_dsos, fp);
 
-	for (nd = rb_first(machines); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&machines->guests); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
 		ret += __dsos__fprintf(&pos->kernel_dsos, fp);
 		ret += __dsos__fprintf(&pos->user_dsos, fp);
@@ -334,13 +352,13 @@ size_t machine__fprintf_dsos_buildid(struct machine *machine, FILE *fp,
 	       __dsos__fprintf_buildid(&machine->user_dsos, fp, skip, parm);
 }
 
-size_t machines__fprintf_dsos_buildid(struct rb_root *machines, FILE *fp,
+size_t machines__fprintf_dsos_buildid(struct machines *machines, FILE *fp,
 				     bool (skip)(struct dso *dso, int parm), int parm)
 {
 	struct rb_node *nd;
-	size_t ret = 0;
+	size_t ret = machine__fprintf_dsos_buildid(&machines->host, fp, skip, parm);
 
-	for (nd = rb_first(machines); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&machines->guests); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
 		ret += machine__fprintf_dsos_buildid(pos, fp, skip, parm);
 	}
@@ -511,7 +529,7 @@ void machine__destroy_kernel_maps(struct machine *machine)
 	}
 }
 
-int machines__create_guest_kernel_maps(struct rb_root *machines)
+int machines__create_guest_kernel_maps(struct machines *machines)
 {
 	int ret = 0;
 	struct dirent **namelist = NULL;
@@ -560,20 +578,22 @@ failure:
 	return ret;
 }
 
-void machines__destroy_guest_kernel_maps(struct rb_root *machines)
+void machines__destroy_kernel_maps(struct machines *machines)
 {
-	struct rb_node *next = rb_first(machines);
+	struct rb_node *next = rb_first(&machines->guests);
+
+	machine__destroy_kernel_maps(&machines->host);
 
 	while (next) {
 		struct machine *pos = rb_entry(next, struct machine, rb_node);
 
 		next = rb_next(&pos->rb_node);
-		rb_erase(&pos->rb_node, machines);
+		rb_erase(&pos->rb_node, &machines->guests);
 		machine__delete(pos);
 	}
 }
 
-int machines__create_kernel_maps(struct rb_root *machines, pid_t pid)
+int machines__create_kernel_maps(struct machines *machines, pid_t pid)
 {
 	struct machine *machine = machines__findnew(machines, pid);
 
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index e112368..5ac5892 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -47,16 +47,24 @@ int machine__process_event(struct machine *machine, union perf_event *event);
 
 typedef void (*machine__process_t)(struct machine *machine, void *data);
 
-void machines__process(struct rb_root *machines,
-		       machine__process_t process, void *data);
+struct machines {
+	struct machine host;
+	struct rb_root guests;
+};
+
+void machines__init(struct machines *machines);
+void machines__exit(struct machines *machines);
+
+void machines__process_guests(struct machines *machines,
+			      machine__process_t process, void *data);
 
-struct machine *machines__add(struct rb_root *machines, pid_t pid,
+struct machine *machines__add(struct machines *machines, pid_t pid,
 			      const char *root_dir);
-struct machine *machines__find_host(struct rb_root *machines);
-struct machine *machines__find(struct rb_root *machines, pid_t pid);
-struct machine *machines__findnew(struct rb_root *machines, pid_t pid);
+struct machine *machines__find_host(struct machines *machines);
+struct machine *machines__find(struct machines *machines, pid_t pid);
+struct machine *machines__findnew(struct machines *machines, pid_t pid);
 
-void machines__set_id_hdr_size(struct rb_root *machines, u16 id_hdr_size);
+void machines__set_id_hdr_size(struct machines *machines, u16 id_hdr_size);
 char *machine__mmap_name(struct machine *machine, char *bf, size_t size);
 
 int machine__init(struct machine *machine, const char *root_dir, pid_t pid);
@@ -132,17 +140,17 @@ int machine__load_vmlinux_path(struct machine *machine, enum map_type type,
 
 size_t machine__fprintf_dsos_buildid(struct machine *machine, FILE *fp,
 				     bool (skip)(struct dso *dso, int parm), int parm);
-size_t machines__fprintf_dsos(struct rb_root *machines, FILE *fp);
-size_t machines__fprintf_dsos_buildid(struct rb_root *machines, FILE *fp,
+size_t machines__fprintf_dsos(struct machines *machines, FILE *fp);
+size_t machines__fprintf_dsos_buildid(struct machines *machines, FILE *fp,
 				     bool (skip)(struct dso *dso, int parm), int parm);
 
 void machine__destroy_kernel_maps(struct machine *machine);
 int __machine__create_kernel_maps(struct machine *machine, struct dso *kernel);
 int machine__create_kernel_maps(struct machine *machine);
 
-int machines__create_kernel_maps(struct rb_root *machines, pid_t pid);
-int machines__create_guest_kernel_maps(struct rb_root *machines);
-void machines__destroy_guest_kernel_maps(struct rb_root *machines);
+int machines__create_kernel_maps(struct machines *machines, pid_t pid);
+int machines__create_guest_kernel_maps(struct machines *machines);
+void machines__destroy_kernel_maps(struct machines *machines);
 
 size_t machine__fprintf_vmlinux_path(struct machine *machine, FILE *fp);
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index b0bcc32..046b057 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -86,13 +86,12 @@ void perf_session__set_id_hdr_size(struct perf_session *session)
 {
 	u16 id_hdr_size = perf_evlist__id_hdr_size(session->evlist);
 
-	session->host_machine.id_hdr_size = id_hdr_size;
 	machines__set_id_hdr_size(&session->machines, id_hdr_size);
 }
 
 int perf_session__create_kernel_maps(struct perf_session *self)
 {
-	int ret = machine__create_kernel_maps(&self->host_machine);
+	int ret = machine__create_kernel_maps(&self->machines.host);
 
 	if (ret >= 0)
 		ret = machines__create_guest_kernel_maps(&self->machines);
@@ -101,8 +100,7 @@ int perf_session__create_kernel_maps(struct perf_session *self)
 
 static void perf_session__destroy_kernel_maps(struct perf_session *self)
 {
-	machine__destroy_kernel_maps(&self->host_machine);
-	machines__destroy_guest_kernel_maps(&self->machines);
+	machines__destroy_kernel_maps(&self->machines);
 }
 
 struct perf_session *perf_session__new(const char *filename, int mode,
@@ -127,12 +125,11 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 		goto out;
 
 	memcpy(self->filename, filename, len);
-	self->machines = RB_ROOT;
 	self->repipe = repipe;
 	INIT_LIST_HEAD(&self->ordered_samples.samples);
 	INIT_LIST_HEAD(&self->ordered_samples.sample_cache);
 	INIT_LIST_HEAD(&self->ordered_samples.to_free);
-	machine__init(&self->host_machine, "", HOST_KERNEL_ID);
+	machines__init(&self->machines);
 
 	if (mode == O_RDONLY) {
 		if (perf_session__open(self, force) < 0)
@@ -162,12 +159,12 @@ out_delete:
 
 static void perf_session__delete_dead_threads(struct perf_session *session)
 {
-	machine__delete_dead_threads(&session->host_machine);
+	machine__delete_dead_threads(&session->machines.host);
 }
 
 static void perf_session__delete_threads(struct perf_session *session)
 {
-	machine__delete_threads(&session->host_machine);
+	machine__delete_threads(&session->machines.host);
 }
 
 static void perf_session_env__delete(struct perf_session_env *env)
@@ -192,7 +189,7 @@ void perf_session__delete(struct perf_session *self)
 	perf_session__delete_dead_threads(self);
 	perf_session__delete_threads(self);
 	perf_session_env__delete(&self->header.env);
-	machine__exit(&self->host_machine);
+	machines__exit(&self->machines);
 	close(self->fd);
 	free(self);
 	vdso__exit();
@@ -998,7 +995,7 @@ void perf_event_header__bswap(struct perf_event_header *self)
 
 struct thread *perf_session__findnew(struct perf_session *session, pid_t pid)
 {
-	return machine__findnew_thread(&session->host_machine, pid);
+	return machine__findnew_thread(&session->machines.host, pid);
 }
 
 static struct thread *perf_session__register_idle_thread(struct perf_session *self)
@@ -1335,16 +1332,13 @@ int maps__set_kallsyms_ref_reloc_sym(struct map **maps,
 
 size_t perf_session__fprintf_dsos(struct perf_session *self, FILE *fp)
 {
-	return __dsos__fprintf(&self->host_machine.kernel_dsos, fp) +
-	       __dsos__fprintf(&self->host_machine.user_dsos, fp) +
-	       machines__fprintf_dsos(&self->machines, fp);
+	return machines__fprintf_dsos(&self->machines, fp);
 }
 
 size_t perf_session__fprintf_dsos_buildid(struct perf_session *self, FILE *fp,
 					  bool (skip)(struct dso *dso, int parm), int parm)
 {
-	size_t ret = machine__fprintf_dsos_buildid(&self->host_machine, fp, skip, parm);
-	return ret + machines__fprintf_dsos_buildid(&self->machines, fp, skip, parm);
+	return machines__fprintf_dsos_buildid(&self->machines, fp, skip, parm);
 }
 
 size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp)
@@ -1368,7 +1362,7 @@ size_t perf_session__fprintf(struct perf_session *session, FILE *fp)
 	 * FIXME: Here we have to actually print all the machines in this
 	 * session, not just the host...
 	 */
-	return machine__fprintf(&session->host_machine, fp);
+	return machine__fprintf(&session->machines.host, fp);
 }
 
 void perf_session__remove_thread(struct perf_session *session,
@@ -1377,10 +1371,10 @@ void perf_session__remove_thread(struct perf_session *session,
 	/*
 	 * FIXME: This one makes no sense, we need to remove the thread from
 	 * the machine it belongs to, perf_session can have many machines, so
-	 * doing it always on ->host_machine is wrong.  Fix when auditing all
+	 * doing it always on ->machines.host is wrong.  Fix when auditing all
 	 * the 'perf kvm' code.
 	 */
-	machine__remove_thread(&session->host_machine, th);
+	machine__remove_thread(&session->machines.host, th);
 }
 
 struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 57066cb..de4e687 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -30,8 +30,7 @@ struct ordered_samples {
 struct perf_session {
 	struct perf_header	header;
 	unsigned long		size;
-	struct machine		host_machine;
-	struct rb_root		machines;
+	struct machines		machines;
 	struct perf_evlist	*evlist;
 	struct pevent		*pevent;
 	struct events_stats	stats;
@@ -49,7 +48,7 @@ struct perf_tool;
 struct perf_session *perf_session__new(const char *filename, int mode,
 				       bool force, bool repipe,
 				       struct perf_tool *tool);
-void perf_session__delete(struct perf_session *self);
+void perf_session__delete(struct perf_session *session);
 
 void perf_event_header__bswap(struct perf_event_header *self);
 
@@ -78,22 +77,18 @@ void perf_session__remove_thread(struct perf_session *self, struct thread *th);
 static inline
 struct machine *perf_session__find_host_machine(struct perf_session *self)
 {
-	return &self->host_machine;
+	return &self->machines.host;
 }
 
 static inline
 struct machine *perf_session__find_machine(struct perf_session *self, pid_t pid)
 {
-	if (pid == HOST_KERNEL_ID)
-		return &self->host_machine;
 	return machines__find(&self->machines, pid);
 }
 
 static inline
 struct machine *perf_session__findnew_machine(struct perf_session *self, pid_t pid)
 {
-	if (pid == HOST_KERNEL_ID)
-		return &self->host_machine;
 	return machines__findnew(&self->machines, pid);
 }
 
-- 
1.8.1.1.361.gec3ae6e

