Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaG1I0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:26:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42613 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaG1I0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:26:37 -0400
Date: Mon, 28 Jul 2014 01:25:21 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-d027b64001b21328cc92d35c6444e1a7a926ea76@git.kernel.org>
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
In-Reply-To: <53CF9B14.7040408@intel.com>
References: <53CF9B14.7040408@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf machine:
  Fix the lifetime of the VDSO temporary file
Git-Commit-ID: d027b64001b21328cc92d35c6444e1a7a926ea76
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

Commit-ID:  d027b64001b21328cc92d35c6444e1a7a926ea76
Gitweb:     http://git.kernel.org/tip/d027b64001b21328cc92d35c6444e1a7a926ea76
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 23 Jul 2014 14:23:00 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Jul 2014 17:14:39 -0300

perf machine: Fix the lifetime of the VDSO temporary file

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
index a25f3ee..65269b8 100644
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
index 8771d0c..b972824 100644
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
index d3da105..fab5838 100644
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
index 75245f0..fdaccaf 100644
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
index 9ab0738..7cf1576 100644
--- a/tools/perf/util/vdso.h
+++ b/tools/perf/util/vdso.h
@@ -15,6 +15,6 @@ static inline bool is_vdso_map(const char *filename)
 struct machine;
 
 struct dso *vdso__dso_findnew(struct machine *machine);
-void vdso__exit(void);
+void vdso__exit(struct machine *machine);
 
 #endif /* __PERF_VDSO__ */
