Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaAXPJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:09:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:26769 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbaAXPJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:09:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,713,1384329600"; 
   d="scan'208";a="471901169"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/8] perf tools: Add kallsyms__get_function_start()
Date: Fri, 24 Jan 2014 17:10:12 +0200
Message-Id: <1390576218-1463-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1390576218-1463-1-git-send-email-adrian.hunter@intel.com>
References: <1390576218-1463-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out the logic used to find the start
address of the reference symbol used to track
kernel relocation.  kallsyms__get_function_start()
is used in subsequent patches.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/event.c | 18 +++++++++++++++---
 tools/perf/util/event.h |  3 +++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 1fc1c2f..17476df 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -470,6 +470,17 @@ static int find_symbol_cb(void *arg, const char *name, char type,
 	return 1;
 }
 
+u64 kallsyms__get_function_start(const char *kallsyms_filename,
+				 const char *symbol_name)
+{
+	struct process_symbol_args args = { .name = symbol_name, };
+
+	if (kallsyms__parse(kallsyms_filename, &args, find_symbol_cb) <= 0)
+		return 0;
+
+	return args.start;
+}
+
 int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 				       perf_event__handler_t process,
 				       struct machine *machine,
@@ -480,13 +491,13 @@ int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 	char path[PATH_MAX];
 	char name_buff[PATH_MAX];
 	struct map *map;
+	u64 start;
 	int err;
 	/*
 	 * We should get this from /sys/kernel/sections/.text, but till that is
 	 * available use this, and after it is use this as a fallback for older
 	 * kernels.
 	 */
-	struct process_symbol_args args = { .name = symbol_name, };
 	union perf_event *event = zalloc((sizeof(event->mmap) +
 					  machine->id_hdr_size));
 	if (event == NULL) {
@@ -513,7 +524,8 @@ int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 		}
 	}
 
-	if (kallsyms__parse(filename, &args, find_symbol_cb) <= 0) {
+	start = kallsyms__get_function_start(filename, symbol_name);
+	if (!start) {
 		free(event);
 		return -ENOENT;
 	}
@@ -525,7 +537,7 @@ int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 	event->mmap.header.type = PERF_RECORD_MMAP;
 	event->mmap.header.size = (sizeof(event->mmap) -
 			(sizeof(event->mmap.filename) - size) + machine->id_hdr_size);
-	event->mmap.pgoff = args.start;
+	event->mmap.pgoff = start;
 	event->mmap.start = map->start;
 	event->mmap.len   = map->end - event->mmap.start;
 	event->mmap.pid   = machine->pid;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index faf6e21..66a0c03 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -279,4 +279,7 @@ size_t perf_event__fprintf_mmap2(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_task(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf(union perf_event *event, FILE *fp);
 
+u64 kallsyms__get_function_start(const char *kallsyms_filename,
+				 const char *symbol_name);
+
 #endif /* __PERF_RECORD_H */
-- 
1.7.11.7

