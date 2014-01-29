Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaA2OPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:15:07 -0500
Received: from mga14.intel.com ([143.182.124.37]:53968 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbaA2ONR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:13:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,742,1384329600"; 
   d="scan'208";a="466608378"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 5/9] perf record: Get ref_reloc_sym from kernel map
Date: Wed, 29 Jan 2014 16:14:40 +0200
Message-Id: <1391004884-10334-6-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1391004884-10334-1-git-send-email-adrian.hunter@intel.com>
References: <1391004884-10334-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that ref_reloc_sym is set up when the kernel
map is created, 'perf record' does not need to
pass the symbol names to
perf_event__synthesize_kernel_mmap() which can
read the values needed from ref_reloc_sym directly.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-record.c | 10 ++--------
 tools/perf/util/event.c     | 26 ++++++--------------------
 tools/perf/util/event.h     |  3 +--
 3 files changed, 9 insertions(+), 30 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 3c394bf..af47531 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -287,10 +287,7 @@ static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
 	 * have no _text sometimes.
 	 */
 	err = perf_event__synthesize_kernel_mmap(tool, process_synthesized_event,
-						 machine, "_text");
-	if (err < 0)
-		err = perf_event__synthesize_kernel_mmap(tool, process_synthesized_event,
-							 machine, "_stext");
+						 machine);
 	if (err < 0)
 		pr_err("Couldn't record guest kernel [%d]'s reference"
 		       " relocation symbol.\n", machine->pid);
@@ -457,10 +454,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	}
 
 	err = perf_event__synthesize_kernel_mmap(tool, process_synthesized_event,
-						 machine, "_text");
-	if (err < 0)
-		err = perf_event__synthesize_kernel_mmap(tool, process_synthesized_event,
-							 machine, "_stext");
+						 machine);
 	if (err < 0)
 		pr_err("Couldn't record kernel reference relocation symbol\n"
 		       "Symbol resolution may be skewed if relocation was used (e.g. kexec).\n"
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 17476df..b0f3ca8 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -483,15 +483,13 @@ u64 kallsyms__get_function_start(const char *kallsyms_filename,
 
 int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 				       perf_event__handler_t process,
-				       struct machine *machine,
-				       const char *symbol_name)
+				       struct machine *machine)
 {
 	size_t size;
-	const char *filename, *mmap_name;
-	char path[PATH_MAX];
+	const char *mmap_name;
 	char name_buff[PATH_MAX];
 	struct map *map;
-	u64 start;
+	struct kmap *kmap;
 	int err;
 	/*
 	 * We should get this from /sys/kernel/sections/.text, but till that is
@@ -513,31 +511,19 @@ int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 		 * see kernel/perf_event.c __perf_event_mmap
 		 */
 		event->header.misc = PERF_RECORD_MISC_KERNEL;
-		filename = "/proc/kallsyms";
 	} else {
 		event->header.misc = PERF_RECORD_MISC_GUEST_KERNEL;
-		if (machine__is_default_guest(machine))
-			filename = (char *) symbol_conf.default_guest_kallsyms;
-		else {
-			sprintf(path, "%s/proc/kallsyms", machine->root_dir);
-			filename = path;
-		}
-	}
-
-	start = kallsyms__get_function_start(filename, symbol_name);
-	if (!start) {
-		free(event);
-		return -ENOENT;
 	}
 
 	map = machine->vmlinux_maps[MAP__FUNCTION];
+	kmap = map__kmap(map);
 	size = snprintf(event->mmap.filename, sizeof(event->mmap.filename),
-			"%s%s", mmap_name, symbol_name) + 1;
+			"%s%s", mmap_name, kmap->ref_reloc_sym->name) + 1;
 	size = PERF_ALIGN(size, sizeof(u64));
 	event->mmap.header.type = PERF_RECORD_MMAP;
 	event->mmap.header.size = (sizeof(event->mmap) -
 			(sizeof(event->mmap.filename) - size) + machine->id_hdr_size);
-	event->mmap.pgoff = start;
+	event->mmap.pgoff = kmap->ref_reloc_sym->addr;
 	event->mmap.start = map->start;
 	event->mmap.len   = map->end - event->mmap.start;
 	event->mmap.pid   = machine->pid;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 66a0c03..851fa06 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -214,8 +214,7 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 				   struct machine *machine, bool mmap_data);
 int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 				       perf_event__handler_t process,
-				       struct machine *machine,
-				       const char *symbol_name);
+				       struct machine *machine);
 
 int perf_event__synthesize_modules(struct perf_tool *tool,
 				   perf_event__handler_t process,
-- 
1.7.11.7

