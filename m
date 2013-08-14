Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760308Ab3HNS1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:27:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34388 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760268Ab3HNSZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:25:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/21] perf machine: Add symbol filter to struct machine
Date: Wed, 14 Aug 2013 15:25:05 -0300
Message-Id: <1376504715-28107-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376504715-28107-1-git-send-email-acme@infradead.org>
References: <1376504715-28107-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

The symbol filter needs to be applied machine-wide, so add it to struct
machine.

Currently tools pass the symbol filter as a parameter to various
map-related functions.  However a need to load a map can occur anywhere
in the code, at which point the filter is needed.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375961547-30267-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 20 ++++++++++++++++++++
 tools/perf/util/machine.h |  5 +++++
 2 files changed, 25 insertions(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 6fcc358..4c7e0a28 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -25,6 +25,8 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 	machine->kmaps.machine = machine;
 	machine->pid = pid;
 
+	machine->symbol_filter = NULL;
+
 	machine->root_dir = strdup(root_dir);
 	if (machine->root_dir == NULL)
 		return -ENOMEM;
@@ -95,6 +97,7 @@ void machines__init(struct machines *machines)
 {
 	machine__init(&machines->host, "", HOST_KERNEL_ID);
 	machines->guests = RB_ROOT;
+	machines->symbol_filter = NULL;
 }
 
 void machines__exit(struct machines *machines)
@@ -118,6 +121,8 @@ struct machine *machines__add(struct machines *machines, pid_t pid,
 		return NULL;
 	}
 
+	machine->symbol_filter = machines->symbol_filter;
+
 	while (*p != NULL) {
 		parent = *p;
 		pos = rb_entry(parent, struct machine, rb_node);
@@ -133,6 +138,21 @@ struct machine *machines__add(struct machines *machines, pid_t pid,
 	return machine;
 }
 
+void machines__set_symbol_filter(struct machines *machines,
+				 symbol_filter_t symbol_filter)
+{
+	struct rb_node *nd;
+
+	machines->symbol_filter = symbol_filter;
+	machines->host.symbol_filter = symbol_filter;
+
+	for (nd = rb_first(&machines->guests); nd; nd = rb_next(nd)) {
+		struct machine *machine = rb_entry(nd, struct machine, rb_node);
+
+		machine->symbol_filter = symbol_filter;
+	}
+}
+
 struct machine *machines__find(struct machines *machines, pid_t pid)
 {
 	struct rb_node **p = &machines->guests.rb_node;
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 5bb6244..603ffba 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -29,6 +29,7 @@ struct machine {
 	struct list_head  kernel_dsos;
 	struct map_groups kmaps;
 	struct map	  *vmlinux_maps[MAP__NR_TYPES];
+	symbol_filter_t	  symbol_filter;
 };
 
 static inline
@@ -51,6 +52,7 @@ typedef void (*machine__process_t)(struct machine *machine, void *data);
 struct machines {
 	struct machine host;
 	struct rb_root guests;
+	symbol_filter_t symbol_filter;
 };
 
 void machines__init(struct machines *machines);
@@ -68,6 +70,9 @@ struct machine *machines__findnew(struct machines *machines, pid_t pid);
 void machines__set_id_hdr_size(struct machines *machines, u16 id_hdr_size);
 char *machine__mmap_name(struct machine *machine, char *bf, size_t size);
 
+void machines__set_symbol_filter(struct machines *machines,
+				 symbol_filter_t symbol_filter);
+
 int machine__init(struct machine *machine, const char *root_dir, pid_t pid);
 void machine__exit(struct machine *machine);
 void machine__delete_dead_threads(struct machine *machine);
-- 
1.8.1.4

