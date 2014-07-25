Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760796AbaGYPmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:42:40 -0400
Received: from mail.kernel.org ([198.145.19.201]:35118 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932605AbaGYPiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:38:24 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/27] perf machine: Fix the lifetime of the VDSO temporary file
Date: Fri, 25 Jul 2014 12:36:58 -0300
Message-Id: <1406302629-11790-17-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406302629-11790-1-git-send-email-acme@kernel.org>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

The VDSO temporary file is unlinked when a session is deleted.  That
precludes the possibilities that there is no session or there is more
than one session.

Correctly the vdso belongs to the machine so put the information on
'struct machine' and get rid of the global variables.

Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/53CF9B14.7040408@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c |  4 ++++
 tools/perf/util/machine.h |  3 +++
 tools/perf/util/session.c |  2 --
 tools/perf/util/vdso.c    | 39 +++++++++++++++++++++++++++++----------
 tools/perf/util/vdso.h    |  2 +-
 5 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index a25f3ee1b5b3..65269b8ac186 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -8,6 +8,7 @@
 #include "sort.h"
 #include "strlist.h"
 #include "thread.h"
+#include "vdso.h"
 #include <stdbool.h>
 #include <symbol/kallsyms.h>
 #include "unwind.h"
@@ -23,6 +24,8 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 	INIT_LIST_HEAD(&machine->dead_threads);
 	machine->last_match = NULL;
 
+	machine->vdso_info = NULL;
+
 	machine->kmaps.machine = machine;
 	machine->pid = pid;
 
@@ -105,6 +108,7 @@ void machine__exit(struct machine *machine)
 	map_groups__exit(&machine->kmaps);
 	dsos__delete(&machine->user_dsos);
 	dsos__delete(&machine->kernel_dsos);
+	vdso__exit(machine);
 	zfree(&machine->root_dir);
 	zfree(&machine->current_tid);
 }
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 8771d0cbe9cb..b972824e6294 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -20,6 +20,8 @@ union perf_event;
 
 extern const char *ref_reloc_sym_names[];
 
+struct vdso_info;
+
 struct machine {
 	struct rb_node	  rb_node;
 	pid_t		  pid;
@@ -28,6 +30,7 @@ struct machine {
 	struct rb_root	  threads;
 	struct list_head  dead_threads;
 	struct thread	  *last_match;
+	struct vdso_info  *vdso_info;
 	struct list_head  user_dsos;
 	struct list_head  kernel_dsos;
 	struct map_groups kmaps;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index d3da1055239f..fab5838c06be 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -14,7 +14,6 @@
 #include "util.h"
 #include "cpumap.h"
 #include "perf_regs.h"
-#include "vdso.h"
 
 static int perf_session__open(struct perf_session *session)
 {
@@ -156,7 +155,6 @@ void perf_session__delete(struct perf_session *session)
 	if (session->file)
 		perf_data_file__close(session->file);
 	free(session);
-	vdso__exit();
 }
 
 static int process_event_synth_tracing_data_stub(struct perf_tool *tool
diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index 75245f081b60..fdaccaf67371 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -28,14 +28,17 @@ struct vdso_info {
 	struct vdso_file vdso;
 };
 
-static struct vdso_info vdso_info_ = {
-	.vdso = {
-		.temp_file_name = VDSO__TEMP_FILE_NAME,
-		.dso_name = VDSO__MAP_NAME,
-	},
-};
-
-static struct vdso_info *vdso_info = &vdso_info_;
+static struct vdso_info *vdso_info__new(void)
+{
+	static const struct vdso_info vdso_info_init = {
+		.vdso    = {
+			.temp_file_name = VDSO__TEMP_FILE_NAME,
+			.dso_name = VDSO__MAP_NAME,
+		},
+	};
+
+	return memdup(&vdso_info_init, sizeof(vdso_info_init));
+}
 
 static int find_vdso_map(void **start, void **end)
 {
@@ -105,16 +108,32 @@ static char *get_file(struct vdso_file *vdso_file)
 	return vdso;
 }
 
-void vdso__exit(void)
+void vdso__exit(struct machine *machine)
 {
+	struct vdso_info *vdso_info = machine->vdso_info;
+
+	if (!vdso_info)
+		return;
+
 	if (vdso_info->vdso.found)
 		unlink(vdso_info->vdso.temp_file_name);
+
+	zfree(&machine->vdso_info);
 }
 
 struct dso *vdso__dso_findnew(struct machine *machine)
 {
-	struct dso *dso = dsos__find(&machine->user_dsos, VDSO__MAP_NAME, true);
+	struct vdso_info *vdso_info;
+	struct dso *dso;
+
+	if (!machine->vdso_info)
+		machine->vdso_info = vdso_info__new();
+
+	vdso_info = machine->vdso_info;
+	if (!vdso_info)
+		return NULL;
 
+	dso = dsos__find(&machine->user_dsos, VDSO__MAP_NAME, true);
 	if (!dso) {
 		char *file;
 
diff --git a/tools/perf/util/vdso.h b/tools/perf/util/vdso.h
index 9ab0738b6752..7cf1576863a4 100644
--- a/tools/perf/util/vdso.h
+++ b/tools/perf/util/vdso.h
@@ -15,6 +15,6 @@ static inline bool is_vdso_map(const char *filename)
 struct machine;
 
 struct dso *vdso__dso_findnew(struct machine *machine);
-void vdso__exit(void);
+void vdso__exit(struct machine *machine);
 
 #endif /* __PERF_VDSO__ */
-- 
1.9.3

