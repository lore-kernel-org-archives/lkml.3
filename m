Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3KGPbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:31:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40810 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab3KGPbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:31:35 -0500
Date: Thu, 7 Nov 2013 07:30:44 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-eyfhvoo510a5i10b27dnvm88@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Don'
 t relookup fields by name in each sample
Git-Commit-ID: 77170988ff67fb959602ab4df296ae676f556a59
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 07 Nov 2013 07:30:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  77170988ff67fb959602ab4df296ae676f556a59
Gitweb:     http://git.kernel.org/tip/77170988ff67fb959602ab4df296ae676f556a59
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 6 Nov 2013 16:35:57 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 7 Nov 2013 10:40:47 -0300

perf trace: Don't relookup fields by name in each sample

Instead do the lookups just when creating the tracepoints, initially for
the most common, raw_syscalls:sys_{enter,exit}.

It works by having evsel->priv have a per tracepoint structure with
entries for the fields, for direct access, with the offset and a
function to get the value from the sample, doing the swap if needed.

Using a simple workload that does M millions write syscalls, we go from:

 # perf stat -i -e cycles /tmp/oldperf trace ./sc_hello 100 > /dev/null

 Performance counter stats for '/tmp/oldperf trace ./sc_hello 100':

     8,366,771,459 cycles

       2.668025928 seconds time elapsed

 # perf stat -i -e cycles perf trace ./sc_hello 100 > /dev/null

 Performance counter stats for 'perf trace ./sc_hello 100':

     8,345,187,650 cycles

       2.631748425 seconds time elapsed

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-eyfhvoo510a5i10b27dnvm88@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 199 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 188 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index ee59df3..329b783 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -35,6 +35,189 @@
 # define MADV_UNMERGEABLE	13
 #endif
 
+struct tp_field {
+	int offset;
+	union {
+		u64 (*integer)(struct tp_field *field, struct perf_sample *sample);
+		void *(*pointer)(struct tp_field *field, struct perf_sample *sample);
+	};
+};
+
+#define TP_UINT_FIELD(bits) \
+static u64 tp_field__u##bits(struct tp_field *field, struct perf_sample *sample) \
+{ \
+	return *(u##bits *)(sample->raw_data + field->offset); \
+}
+
+TP_UINT_FIELD(8);
+TP_UINT_FIELD(16);
+TP_UINT_FIELD(32);
+TP_UINT_FIELD(64);
+
+#define TP_UINT_FIELD__SWAPPED(bits) \
+static u64 tp_field__swapped_u##bits(struct tp_field *field, struct perf_sample *sample) \
+{ \
+	u##bits value = *(u##bits *)(sample->raw_data + field->offset); \
+	return bswap_##bits(value);\
+}
+
+TP_UINT_FIELD__SWAPPED(16);
+TP_UINT_FIELD__SWAPPED(32);
+TP_UINT_FIELD__SWAPPED(64);
+
+static int tp_field__init_uint(struct tp_field *field,
+			       struct format_field *format_field,
+			       bool needs_swap)
+{
+	field->offset = format_field->offset;
+
+	switch (format_field->size) {
+	case 1:
+		field->integer = tp_field__u8;
+		break;
+	case 2:
+		field->integer = needs_swap ? tp_field__swapped_u16 : tp_field__u16;
+		break;
+	case 4:
+		field->integer = needs_swap ? tp_field__swapped_u32 : tp_field__u32;
+		break;
+	case 8:
+		field->integer = needs_swap ? tp_field__swapped_u64 : tp_field__u64;
+		break;
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static void *tp_field__ptr(struct tp_field *field, struct perf_sample *sample)
+{
+	return sample->raw_data + field->offset;
+}
+
+static int tp_field__init_ptr(struct tp_field *field, struct format_field *format_field)
+{
+	field->offset = format_field->offset;
+	field->pointer = tp_field__ptr;
+	return 0;
+}
+
+struct syscall_tp {
+	struct tp_field id;
+	union {
+		struct tp_field args, ret;
+	};
+};
+
+static int perf_evsel__init_tp_uint_field(struct perf_evsel *evsel,
+					  struct tp_field *field,
+					  const char *name)
+{
+	struct format_field *format_field = perf_evsel__field(evsel, name);
+
+	if (format_field == NULL)
+		return -1;
+
+	return tp_field__init_uint(field, format_field, evsel->needs_swap);
+}
+
+#define perf_evsel__init_sc_tp_uint_field(evsel, name) \
+	({ struct syscall_tp *sc = evsel->priv;\
+	   perf_evsel__init_tp_uint_field(evsel, &sc->name, #name); })
+
+static int perf_evsel__init_tp_ptr_field(struct perf_evsel *evsel,
+					 struct tp_field *field,
+					 const char *name)
+{
+	struct format_field *format_field = perf_evsel__field(evsel, name);
+
+	if (format_field == NULL)
+		return -1;
+
+	return tp_field__init_ptr(field, format_field);
+}
+
+#define perf_evsel__init_sc_tp_ptr_field(evsel, name) \
+	({ struct syscall_tp *sc = evsel->priv;\
+	   perf_evsel__init_tp_ptr_field(evsel, &sc->name, #name); })
+
+static void perf_evsel__delete_priv(struct perf_evsel *evsel)
+{
+	free(evsel->priv);
+	evsel->priv = NULL;
+	perf_evsel__delete(evsel);
+}
+
+static struct perf_evsel *perf_evsel__syscall_newtp(const char *direction,
+						    void *handler, int idx)
+{
+	struct perf_evsel *evsel = perf_evsel__newtp("raw_syscalls", direction, idx);
+
+	if (evsel) {
+		evsel->priv = malloc(sizeof(struct syscall_tp));
+
+		if (evsel->priv == NULL)
+			goto out_delete;
+
+		if (perf_evsel__init_sc_tp_uint_field(evsel, id))
+			goto out_delete;
+
+		evsel->handler = handler;
+	}
+
+	return evsel;
+
+out_delete:
+	perf_evsel__delete_priv(evsel);
+	return NULL;
+}
+
+#define perf_evsel__sc_tp_uint(evsel, name, sample) \
+	({ struct syscall_tp *fields = evsel->priv; \
+	   fields->name.integer(&fields->name, sample); })
+
+#define perf_evsel__sc_tp_ptr(evsel, name, sample) \
+	({ struct syscall_tp *fields = evsel->priv; \
+	   fields->name.pointer(&fields->name, sample); })
+
+static int perf_evlist__add_syscall_newtp(struct perf_evlist *evlist,
+					  void *sys_enter_handler,
+					  void *sys_exit_handler)
+{
+	int ret = -1;
+	int idx = evlist->nr_entries;
+	struct perf_evsel *sys_enter, *sys_exit;
+
+	sys_enter = perf_evsel__syscall_newtp("sys_enter", sys_enter_handler, idx++);
+	if (sys_enter == NULL)
+		goto out;
+
+	if (perf_evsel__init_sc_tp_ptr_field(sys_enter, args))
+		goto out_delete_sys_enter;
+
+	sys_exit = perf_evsel__syscall_newtp("sys_exit", sys_exit_handler, idx++);
+	if (sys_exit == NULL)
+		goto out_delete_sys_enter;
+
+	if (perf_evsel__init_sc_tp_uint_field(sys_exit, ret))
+		goto out_delete_sys_exit;
+
+	perf_evlist__add(evlist, sys_enter);
+	perf_evlist__add(evlist, sys_exit);
+
+	ret = 0;
+out:
+	return ret;
+
+out_delete_sys_exit:
+	perf_evsel__delete_priv(sys_exit);
+out_delete_sys_enter:
+	perf_evsel__delete_priv(sys_enter);
+	goto out;
+}
+
+
 struct syscall_arg {
 	unsigned long val;
 	struct thread *thread;
@@ -1392,7 +1575,7 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 	void *args;
 	size_t printed = 0;
 	struct thread *thread;
-	int id = perf_evsel__intval(evsel, sample, "id");
+	int id = perf_evsel__sc_tp_uint(evsel, id, sample);
 	struct syscall *sc = trace__syscall_info(trace, evsel, id);
 	struct thread_trace *ttrace;
 
@@ -1407,12 +1590,7 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 	if (ttrace == NULL)
 		return -1;
 
-	args = perf_evsel__rawptr(evsel, sample, "args");
-	if (args == NULL) {
-		fprintf(trace->output, "Problems reading syscall arguments\n");
-		return -1;
-	}
-
+	args = perf_evsel__sc_tp_ptr(evsel, args, sample);
 	ttrace = thread->priv;
 
 	if (ttrace->entry_str == NULL) {
@@ -1445,7 +1623,7 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 	int ret;
 	u64 duration = 0;
 	struct thread *thread;
-	int id = perf_evsel__intval(evsel, sample, "id");
+	int id = perf_evsel__sc_tp_uint(evsel, id, sample);
 	struct syscall *sc = trace__syscall_info(trace, evsel, id);
 	struct thread_trace *ttrace;
 
@@ -1463,7 +1641,7 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 	if (trace->summary)
 		thread__update_stats(ttrace, id, sample);
 
-	ret = perf_evsel__intval(evsel, sample, "ret");
+	ret = perf_evsel__sc_tp_uint(evsel, ret, sample);
 
 	if (id == trace->audit.open_id && ret >= 0 && trace->last_vfs_getname) {
 		trace__set_fd_pathname(thread, ret, trace->last_vfs_getname);
@@ -1675,8 +1853,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 		goto out;
 	}
 
-	if (perf_evlist__add_newtp(evlist, "raw_syscalls", "sys_enter", trace__sys_enter) ||
-		perf_evlist__add_newtp(evlist, "raw_syscalls", "sys_exit", trace__sys_exit))
+	if (perf_evlist__add_syscall_newtp(evlist, trace__sys_enter, trace__sys_exit))
 		goto out_error_tp;
 
 	perf_evlist__add_vfs_getname(evlist);
