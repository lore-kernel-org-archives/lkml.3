Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaG1IZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:25:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42542 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaG1IZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:25:32 -0400
Date: Mon, 28 Jul 2014 01:24:24 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-2a03068c5cfa104768703cbefa2e23a6353f8de5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1406035081-14301-45-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-45-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Pass machine to vdso__dso_findnew()
Git-Commit-ID: 2a03068c5cfa104768703cbefa2e23a6353f8de5
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

Commit-ID:  2a03068c5cfa104768703cbefa2e23a6353f8de5
Gitweb:     http://git.kernel.org/tip/2a03068c5cfa104768703cbefa2e23a6353f8de5
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Jul 2014 16:17:53 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Jul 2014 16:45:50 -0300

perf tools: Pass machine to vdso__dso_findnew()

This is preparation for removing the global variables used in vdso.c and
thereby fixing the lifetime of the VDSO temporary file.

Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406035081-14301-45-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 4 ++--
 tools/perf/util/map.c     | 7 ++++---
 tools/perf/util/map.h     | 2 +-
 tools/perf/util/vdso.c    | 7 ++++---
 tools/perf/util/vdso.h    | 4 +++-
 5 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index cfc6910..a25f3ee 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1095,7 +1095,7 @@ int machine__process_mmap2_event(struct machine *machine,
 	else
 		type = MAP__FUNCTION;
 
-	map = map__new(&machine->user_dsos, event->mmap2.start,
+	map = map__new(machine, event->mmap2.start,
 			event->mmap2.len, event->mmap2.pgoff,
 			event->mmap2.pid, event->mmap2.maj,
 			event->mmap2.min, event->mmap2.ino,
@@ -1145,7 +1145,7 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 	else
 		type = MAP__FUNCTION;
 
-	map = map__new(&machine->user_dsos, event->mmap.start,
+	map = map__new(machine, event->mmap.start,
 			event->mmap.len, event->mmap.pgoff,
 			event->mmap.pid, 0, 0, 0, 0, 0, 0,
 			event->mmap.filename,
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 845f627..dffc8dc 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -13,6 +13,7 @@
 #include "build-id.h"
 #include "util.h"
 #include "debug.h"
+#include "machine.h"
 #include <linux/string.h>
 
 const char *map_type__name[MAP__NR_TYPES] = {
@@ -137,7 +138,7 @@ void map__init(struct map *map, enum map_type type,
 	map->erange_warned = false;
 }
 
-struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
+struct map *map__new(struct machine *machine, u64 start, u64 len,
 		     u64 pgoff, u32 pid, u32 d_maj, u32 d_min, u64 ino,
 		     u64 ino_gen, u32 prot, u32 flags, char *filename,
 		     enum map_type type)
@@ -173,9 +174,9 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 
 		if (vdso) {
 			pgoff = 0;
-			dso = vdso__dso_findnew(dsos__list);
+			dso = vdso__dso_findnew(machine);
 		} else
-			dso = __dsos__findnew(dsos__list, filename);
+			dso = __dsos__findnew(&machine->user_dsos, filename);
 
 		if (dso == NULL)
 			goto out_delete;
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 22d13a2..a95e677 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -119,7 +119,7 @@ typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
 
 void map__init(struct map *map, enum map_type type,
 	       u64 start, u64 end, u64 pgoff, struct dso *dso);
-struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
+struct map *map__new(struct machine *machine, u64 start, u64 len,
 		     u64 pgoff, u32 pid, u32 d_maj, u32 d_min, u64 ino,
 		     u64 ino_gen, u32 prot, u32 flags,
 		     char *filename, enum map_type type);
diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index 2905824..da5ba4d 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -11,6 +11,7 @@
 #include "vdso.h"
 #include "util.h"
 #include "symbol.h"
+#include "machine.h"
 #include "linux/string.h"
 #include "debug.h"
 
@@ -90,9 +91,9 @@ void vdso__exit(void)
 		unlink(vdso_file);
 }
 
-struct dso *vdso__dso_findnew(struct list_head *head)
+struct dso *vdso__dso_findnew(struct machine *machine)
 {
-	struct dso *dso = dsos__find(head, VDSO__MAP_NAME, true);
+	struct dso *dso = dsos__find(&machine->user_dsos, VDSO__MAP_NAME, true);
 
 	if (!dso) {
 		char *file;
@@ -103,7 +104,7 @@ struct dso *vdso__dso_findnew(struct list_head *head)
 
 		dso = dso__new(VDSO__MAP_NAME);
 		if (dso != NULL) {
-			dsos__add(head, dso);
+			dsos__add(&machine->user_dsos, dso);
 			dso__set_long_name(dso, file, false);
 		}
 	}
diff --git a/tools/perf/util/vdso.h b/tools/perf/util/vdso.h
index 0f76e7c..9ab0738 100644
--- a/tools/perf/util/vdso.h
+++ b/tools/perf/util/vdso.h
@@ -12,7 +12,9 @@ static inline bool is_vdso_map(const char *filename)
 	return !strcmp(filename, VDSO__MAP_NAME);
 }
 
-struct dso *vdso__dso_findnew(struct list_head *head);
+struct machine;
+
+struct dso *vdso__dso_findnew(struct machine *machine);
 void vdso__exit(void);
 
 #endif /* __PERF_VDSO__ */
