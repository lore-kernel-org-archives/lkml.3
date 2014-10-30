Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460AbaJ3Gr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:47:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38167 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758410AbaJ3Gru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:47:50 -0400
Date: Wed, 29 Oct 2014 23:46:48 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-0db15b1e84a59e6e1da5fe6e74c35fe52fa29d92@git.kernel.org>
Cc: fweisbec@gmail.com, adrian.hunter@intel.com, jolsa@redhat.com,
        namhyung@gmail.com, paulus@samba.org, acme@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, eranian@google.com,
        dsahern@gmail.com, tglx@linutronix.de, hpa@zytor.com, mingo@kernel.org
Reply-To: jolsa@redhat.com, adrian.hunter@intel.com, namhyung@gmail.com,
        fweisbec@gmail.com, peterz@infradead.org, eranian@google.com,
        dsahern@gmail.com, tglx@linutronix.de, hpa@zytor.com, mingo@kernel.org,
        paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1414061124-26830-6-git-send-email-adrian.hunter@intel.com>
References: <1414061124-26830-6-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add facility to export data in database-friendly way
Git-Commit-ID: 0db15b1e84a59e6e1da5fe6e74c35fe52fa29d92
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0db15b1e84a59e6e1da5fe6e74c35fe52fa29d92
Gitweb:     http://git.kernel.org/tip/0db15b1e84a59e6e1da5fe6e74c35fe52fa29d92
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 23 Oct 2014 13:45:13 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:32:49 -0200

perf tools: Add facility to export data in database-friendly way

This patch introduces an abstraction for exporting sample data in a
database-friendly way.  The abstraction does not implement the actual
output.  A subsequent patch takes this facility into use for extending
the script interface.

The abstraction is needed because static data like symbols, dsos, comms
etc need to be exported only once.  That means allocating them a unique
identifier and recording it on each structure.  The member 'db_id' is
used for that.  'db_id' is just a 64-bit sequence number.

Exporting centres around the db_export__sample() function which exports
the associated data structures if they have not yet been allocated a
db_id.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1414061124-26830-6-git-send-email-adrian.hunter@intel.com
[ committer note: Stash db_id using symbol_conf.priv_size + symbol__priv() and foo->priv areas ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf    |   2 +
 tools/perf/util/comm.h      |   4 +
 tools/perf/util/db-export.c | 270 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/db-export.h |  86 ++++++++++++++
 tools/perf/util/dso.h       |   5 +
 tools/perf/util/evsel.h     |   2 +
 tools/perf/util/machine.h   |   4 +
 tools/perf/util/thread.h    |   1 +
 8 files changed, 374 insertions(+)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 9c4ced0..3caf7da 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -258,6 +258,7 @@ LIB_H += util/annotate.h
 LIB_H += util/cache.h
 LIB_H += util/callchain.h
 LIB_H += util/build-id.h
+LIB_H += util/db-export.h
 LIB_H += util/debug.h
 LIB_H += util/pmu.h
 LIB_H += util/event.h
@@ -323,6 +324,7 @@ LIB_OBJS += $(OUTPUT)util/annotate.o
 LIB_OBJS += $(OUTPUT)util/build-id.o
 LIB_OBJS += $(OUTPUT)util/config.o
 LIB_OBJS += $(OUTPUT)util/ctype.o
+LIB_OBJS += $(OUTPUT)util/db-export.o
 LIB_OBJS += $(OUTPUT)util/pmu.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
diff --git a/tools/perf/util/comm.h b/tools/perf/util/comm.h
index 51c10ab..71c9c39 100644
--- a/tools/perf/util/comm.h
+++ b/tools/perf/util/comm.h
@@ -12,6 +12,10 @@ struct comm {
 	u64 start;
 	struct list_head list;
 	bool exec;
+	union { /* Tool specific area */
+		void	*priv;
+		u64	db_id;
+	};
 };
 
 void comm__free(struct comm *comm);
diff --git a/tools/perf/util/db-export.c b/tools/perf/util/db-export.c
new file mode 100644
index 0000000..be128b0
--- /dev/null
+++ b/tools/perf/util/db-export.c
@@ -0,0 +1,270 @@
+/*
+ * db-export.c: Support for exporting data suitable for import to a database
+ * Copyright (c) 2014, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#include <errno.h>
+
+#include "evsel.h"
+#include "machine.h"
+#include "thread.h"
+#include "comm.h"
+#include "symbol.h"
+#include "event.h"
+#include "db-export.h"
+
+int db_export__init(struct db_export *dbe)
+{
+	memset(dbe, 0, sizeof(struct db_export));
+	return 0;
+}
+
+void db_export__exit(struct db_export *dbe __maybe_unused)
+{
+}
+
+int db_export__evsel(struct db_export *dbe, struct perf_evsel *evsel)
+{
+	if (evsel->db_id)
+		return 0;
+
+	evsel->db_id = ++dbe->evsel_last_db_id;
+
+	if (dbe->export_evsel)
+		return dbe->export_evsel(dbe, evsel);
+
+	return 0;
+}
+
+int db_export__machine(struct db_export *dbe, struct machine *machine)
+{
+	if (machine->db_id)
+		return 0;
+
+	machine->db_id = ++dbe->machine_last_db_id;
+
+	if (dbe->export_machine)
+		return dbe->export_machine(dbe, machine);
+
+	return 0;
+}
+
+int db_export__thread(struct db_export *dbe, struct thread *thread,
+		      struct machine *machine, struct comm *comm)
+{
+	u64 main_thread_db_id = 0;
+	int err;
+
+	if (thread->db_id)
+		return 0;
+
+	thread->db_id = ++dbe->thread_last_db_id;
+
+	if (thread->pid_ != -1) {
+		struct thread *main_thread;
+
+		if (thread->pid_ == thread->tid) {
+			main_thread = thread;
+		} else {
+			main_thread = machine__findnew_thread(machine,
+							      thread->pid_,
+							      thread->pid_);
+			if (!main_thread)
+				return -ENOMEM;
+			err = db_export__thread(dbe, main_thread, machine,
+						comm);
+			if (err)
+				return err;
+			if (comm) {
+				err = db_export__comm_thread(dbe, comm, thread);
+				if (err)
+					return err;
+			}
+		}
+		main_thread_db_id = main_thread->db_id;
+	}
+
+	if (dbe->export_thread)
+		return dbe->export_thread(dbe, thread, main_thread_db_id,
+					  machine);
+
+	return 0;
+}
+
+int db_export__comm(struct db_export *dbe, struct comm *comm,
+		    struct thread *main_thread)
+{
+	int err;
+
+	if (comm->db_id)
+		return 0;
+
+	comm->db_id = ++dbe->comm_last_db_id;
+
+	if (dbe->export_comm) {
+		err = dbe->export_comm(dbe, comm);
+		if (err)
+			return err;
+	}
+
+	return db_export__comm_thread(dbe, comm, main_thread);
+}
+
+int db_export__comm_thread(struct db_export *dbe, struct comm *comm,
+			   struct thread *thread)
+{
+	u64 db_id;
+
+	db_id = ++dbe->comm_thread_last_db_id;
+
+	if (dbe->export_comm_thread)
+		return dbe->export_comm_thread(dbe, db_id, comm, thread);
+
+	return 0;
+}
+
+int db_export__dso(struct db_export *dbe, struct dso *dso,
+		   struct machine *machine)
+{
+	if (dso->db_id)
+		return 0;
+
+	dso->db_id = ++dbe->dso_last_db_id;
+
+	if (dbe->export_dso)
+		return dbe->export_dso(dbe, dso, machine);
+
+	return 0;
+}
+
+int db_export__symbol(struct db_export *dbe, struct symbol *sym,
+		      struct dso *dso)
+{
+	u64 *sym_db_id = symbol__priv(sym);
+
+	if (*sym_db_id)
+		return 0;
+
+	*sym_db_id = ++dbe->symbol_last_db_id;
+
+	if (dbe->export_symbol)
+		return dbe->export_symbol(dbe, sym, dso);
+
+	return 0;
+}
+
+static struct thread *get_main_thread(struct machine *machine, struct thread *thread)
+{
+	if (thread->pid_ == thread->tid)
+		return thread;
+
+	if (thread->pid_ == -1)
+		return NULL;
+
+	return machine__find_thread(machine, thread->pid_, thread->pid_);
+}
+
+static int db_ids_from_al(struct db_export *dbe, struct addr_location *al,
+			  u64 *dso_db_id, u64 *sym_db_id, u64 *offset)
+{
+	int err;
+
+	if (al->map) {
+		struct dso *dso = al->map->dso;
+
+		err = db_export__dso(dbe, dso, al->machine);
+		if (err)
+			return err;
+		*dso_db_id = dso->db_id;
+
+		if (!al->sym) {
+			al->sym = symbol__new(al->addr, 0, 0, "unknown");
+			if (al->sym)
+				symbols__insert(&dso->symbols[al->map->type],
+						al->sym);
+		}
+
+		if (al->sym) {
+			u64 *db_id = symbol__priv(al->sym);
+
+			err = db_export__symbol(dbe, al->sym, dso);
+			if (err)
+				return err;
+			*sym_db_id = *db_id;
+			*offset = al->addr - al->sym->start;
+		}
+	}
+
+	return 0;
+}
+
+int db_export__sample(struct db_export *dbe, union perf_event *event,
+		      struct perf_sample *sample, struct perf_evsel *evsel,
+		      struct thread *thread, struct addr_location *al)
+{
+	struct export_sample es = {
+		.event = event,
+		.sample = sample,
+		.evsel = evsel,
+		.thread = thread,
+		.al = al,
+	};
+	struct thread *main_thread;
+	struct comm *comm = NULL;
+	int err;
+
+	err = db_export__evsel(dbe, evsel);
+	if (err)
+		return err;
+
+	err = db_export__machine(dbe, al->machine);
+	if (err)
+		return err;
+
+	main_thread = get_main_thread(al->machine, thread);
+	if (main_thread)
+		comm = machine__thread_exec_comm(al->machine, main_thread);
+
+	err = db_export__thread(dbe, thread, al->machine, comm);
+	if (err)
+		return err;
+
+	if (comm) {
+		err = db_export__comm(dbe, comm, main_thread);
+		if (err)
+			return err;
+		es.comm_db_id = comm->db_id;
+	}
+
+	es.db_id = ++dbe->sample_last_db_id;
+
+	err = db_ids_from_al(dbe, al, &es.dso_db_id, &es.sym_db_id, &es.offset);
+	if (err)
+		return err;
+
+	if ((evsel->attr.sample_type & PERF_SAMPLE_ADDR) &&
+	    sample_addr_correlates_sym(&evsel->attr)) {
+		struct addr_location addr_al;
+
+		perf_event__preprocess_sample_addr(event, sample, thread, &addr_al);
+		err = db_ids_from_al(dbe, &addr_al, &es.addr_dso_db_id,
+				     &es.addr_sym_db_id, &es.addr_offset);
+		if (err)
+			return err;
+	}
+
+	if (dbe->export_sample)
+		return dbe->export_sample(dbe, &es);
+
+	return 0;
+}
diff --git a/tools/perf/util/db-export.h b/tools/perf/util/db-export.h
new file mode 100644
index 0000000..b3643e8
--- /dev/null
+++ b/tools/perf/util/db-export.h
@@ -0,0 +1,86 @@
+/*
+ * db-export.h: Support for exporting data suitable for import to a database
+ * Copyright (c) 2014, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#ifndef __PERF_DB_EXPORT_H
+#define __PERF_DB_EXPORT_H
+
+#include <linux/types.h>
+
+struct perf_evsel;
+struct machine;
+struct thread;
+struct comm;
+struct dso;
+struct perf_sample;
+struct addr_location;
+
+struct export_sample {
+	union perf_event	*event;
+	struct perf_sample	*sample;
+	struct perf_evsel	*evsel;
+	struct thread		*thread;
+	struct addr_location	*al;
+	u64			db_id;
+	u64			comm_db_id;
+	u64			dso_db_id;
+	u64			sym_db_id;
+	u64			offset; /* ip offset from symbol start */
+	u64			addr_dso_db_id;
+	u64			addr_sym_db_id;
+	u64			addr_offset; /* addr offset from symbol start */
+};
+
+struct db_export {
+	int (*export_evsel)(struct db_export *dbe, struct perf_evsel *evsel);
+	int (*export_machine)(struct db_export *dbe, struct machine *machine);
+	int (*export_thread)(struct db_export *dbe, struct thread *thread,
+			     u64 main_thread_db_id, struct machine *machine);
+	int (*export_comm)(struct db_export *dbe, struct comm *comm);
+	int (*export_comm_thread)(struct db_export *dbe, u64 db_id,
+				  struct comm *comm, struct thread *thread);
+	int (*export_dso)(struct db_export *dbe, struct dso *dso,
+			  struct machine *machine);
+	int (*export_symbol)(struct db_export *dbe, struct symbol *sym,
+			     struct dso *dso);
+	int (*export_sample)(struct db_export *dbe, struct export_sample *es);
+	u64 evsel_last_db_id;
+	u64 machine_last_db_id;
+	u64 thread_last_db_id;
+	u64 comm_last_db_id;
+	u64 comm_thread_last_db_id;
+	u64 dso_last_db_id;
+	u64 symbol_last_db_id;
+	u64 sample_last_db_id;
+};
+
+int db_export__init(struct db_export *dbe);
+void db_export__exit(struct db_export *dbe);
+int db_export__evsel(struct db_export *dbe, struct perf_evsel *evsel);
+int db_export__machine(struct db_export *dbe, struct machine *machine);
+int db_export__thread(struct db_export *dbe, struct thread *thread,
+		      struct machine *machine, struct comm *comm);
+int db_export__comm(struct db_export *dbe, struct comm *comm,
+		    struct thread *main_thread);
+int db_export__comm_thread(struct db_export *dbe, struct comm *comm,
+			   struct thread *thread);
+int db_export__dso(struct db_export *dbe, struct dso *dso,
+		   struct machine *machine);
+int db_export__symbol(struct db_export *dbe, struct symbol *sym,
+		      struct dso *dso);
+int db_export__sample(struct db_export *dbe, union perf_event *event,
+		      struct perf_sample *sample, struct perf_evsel *evsel,
+		      struct thread *thread, struct addr_location *al);
+
+#endif
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 3c9b391..a316e4a 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -139,6 +139,11 @@ struct dso {
 		struct list_head open_entry;
 	} data;
 
+	union { /* Tool specific area */
+		void	 *priv;
+		u64	 db_id;
+	};
+
 	char		 name[0];
 };
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 163c560..d3854c4 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -54,6 +54,7 @@ struct cgroup_sel;
  * @is_pos: the position (counting backwards) of the event id (PERF_SAMPLE_ID or
  *          PERF_SAMPLE_IDENTIFIER) in a non-sample event i.e. if sample_id_all
  *          is used there is an id sample appended to non-sample events
+ * @priv:   And what is in its containing unnamed union are tool specific
  */
 struct perf_evsel {
 	struct list_head	node;
@@ -73,6 +74,7 @@ struct perf_evsel {
 	union {
 		void		*priv;
 		off_t		id_offset;
+		u64		db_id;
 	};
 	struct cgroup_sel	*cgrp;
 	void			*handler;
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 88ec74e..e8b7779 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -40,6 +40,10 @@ struct machine {
 	u64		  kernel_start;
 	symbol_filter_t	  symbol_filter;
 	pid_t		  *current_tid;
+	union { /* Tool specific area */
+		void	  *priv;
+		u64	  db_id;
+	};
 };
 
 static inline
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 6ef9fe6..d34cf5c 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -23,6 +23,7 @@ struct thread {
 	bool			dead; /* if set thread has exited */
 	struct list_head	comm_list;
 	int			comm_len;
+	u64			db_id;
 
 	void			*priv;
 };
