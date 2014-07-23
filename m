Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbaGWLYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:24:20 -0400
Received: from mga14.intel.com ([192.55.52.115]:46043 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757539AbaGWLYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:24:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,716,1400050800"; 
   d="scan'208";a="565991244"
Message-ID: <53CF9B14.7040408@intel.com>
Date: Wed, 23 Jul 2014 14:23:00 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 46/52] perf tools: Fix the lifetime of the VDSO temporary
 file
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com> <1406035081-14301-47-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1406035081-14301-47-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VDSO temporary file is unlinked when a session is
deleted.  That precludes the possibilities that there
is no session or there is more than one session.
Correctly the vdso belongs to the machine so put the
information on 'struct machine' and get rid of the global
variables.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


V2:
	Initialize vdso_info to NULL in machine_init()

	The change is reflected in the branch here:

		http://git.infradead.org/users/ahunter/linux-perf.git/shortlog/refs/heads/for-acme


 tools/perf/util/machine.c |  4 ++++
 tools/perf/util/machine.h |  3 +++
 tools/perf/util/session.c |  2 --
 tools/perf/util/vdso.c    | 39 +++++++++++++++++++++++++++++----------
 tools/perf/util/vdso.h    |  2 +-
 5 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 5d21792..1732cc1 100644
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
 
@@ -107,6 +110,7 @@ void machine__exit(struct machine *machine)
 	map_groups__exit(&machine->kmaps);
 	dsos__delete(&machine->user_dsos);
 	dsos__delete(&machine->kernel_dsos);
+	vdso__exit(machine);
 	zfree(&machine->root_dir);
 	zfree(&machine->current_tid);
 }
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index f91a7e1..f385f23 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -20,6 +20,8 @@ union perf_event;
 
 extern const char *ref_reloc_sym_names[];
 
+struct vdso_info;
+
 struct machine {
 	struct rb_node	  rb_node;
 	pid_t		  pid;
@@ -29,6 +31,7 @@ struct machine {
 	struct rb_root	  threads;
 	struct list_head  dead_threads;
 	struct thread	  *last_match;
+	struct vdso_info  *vdso_info;
 	struct list_head  user_dsos;
 	struct list_head  kernel_dsos;
 	struct map_groups kmaps;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ca3cd1f..5ad5e12 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -14,7 +14,6 @@
 #include "util.h"
 #include "cpumap.h"
 #include "perf_regs.h"
-#include "vdso.h"
 
 static int perf_session__open(struct perf_session *session)
 {
@@ -176,7 +175,6 @@ void perf_session__delete(struct perf_session *session)
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
-- 
1.8.3.2


