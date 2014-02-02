Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaBBI4T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 03:56:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41383 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaBBI4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 03:56:14 -0500
Date: Sun, 2 Feb 2014 00:55:53 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-0ae617bedde062003fd70e566e9a2601e273ea0e@git.kernel.org>
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
In-Reply-To: <1391004884-10334-6-git-send-email-adrian.hunter@intel.com>
References: <1391004884-10334-6-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf record: Get ref_reloc_sym from kernel map
Git-Commit-ID: 0ae617bedde062003fd70e566e9a2601e273ea0e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 02 Feb 2014 00:55:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ae617bedde062003fd70e566e9a2601e273ea0e
Gitweb:     http://git.kernel.org/tip/0ae617bedde062003fd70e566e9a2601e273ea0e
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 29 Jan 2014 16:14:40 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 31 Jan 2014 17:21:50 -0300

perf record: Get ref_reloc_sym from kernel map

Now that ref_reloc_sym is set up when the kernel map is created,
'perf record' does not need to pass the symbol names to
perf_event__synthesize_kernel_mmap() which can read the values needed
from ref_reloc_sym directly.

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
Link: http://lkml.kernel.org/r/1391004884-10334-6-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
