Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191AbaAaU2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:28:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55435 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824AbaAaU2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 15:28:00 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/12] perf tools: Add kallsyms__get_function_start()
Date: Fri, 31 Jan 2014 17:27:28 -0300
Message-Id: <1391200055-18250-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1391200055-18250-1-git-send-email-acme@infradead.org>
References: <1391200055-18250-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Separate out the logic used to find the start address of the reference
symbol used to track kernel relocation.  kallsyms__get_function_start()
is used in subsequent patches.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1391004884-10334-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 18 +++++++++++++++---
 tools/perf/util/event.h |  3 +++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 1fc1c2f04772..17476df5c7b2 100644
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
index faf6e219be21..66a0c0392863 100644
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
1.8.1.4

