Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaBBIzx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 03:55:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41348 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaBBIzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 03:55:44 -0500
Date: Sun, 2 Feb 2014 00:55:21 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-29b596b57426831fce92cd0ebb01c77627616fdf@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1391004884-10334-3-git-send-email-adrian.hunter@intel.com>
References: <1391004884-10334-3-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Add kallsyms__get_function_start()
Git-Commit-ID: 29b596b57426831fce92cd0ebb01c77627616fdf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 02 Feb 2014 00:55:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29b596b57426831fce92cd0ebb01c77627616fdf
Gitweb:     http://git.kernel.org/tip/29b596b57426831fce92cd0ebb01c77627616fdf
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 29 Jan 2014 16:14:37 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 31 Jan 2014 17:21:47 -0300

perf tools: Add kallsyms__get_function_start()

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
