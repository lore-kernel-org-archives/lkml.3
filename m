Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760565Ab3HOH5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:57:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53940 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab3HOH5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:57:07 -0400
Date: Thu, 15 Aug 2013 00:56:24 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-611a5ce8aa4cdb2daefbd9bed77ec3b3e9bd00ea@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1375961547-30267-2-git-send-email-adrian.hunter@intel.com>
References: <1375961547-30267-2-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf machine: Add symbol filter to struct machine
Git-Commit-ID: 611a5ce8aa4cdb2daefbd9bed77ec3b3e9bd00ea
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 15 Aug 2013 00:56:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  611a5ce8aa4cdb2daefbd9bed77ec3b3e9bd00ea
Gitweb:     http://git.kernel.org/tip/611a5ce8aa4cdb2daefbd9bed77ec3b3e9bd00ea
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 8 Aug 2013 14:32:20 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 12 Aug 2013 10:31:09 -0300

perf machine: Add symbol filter to struct machine

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
