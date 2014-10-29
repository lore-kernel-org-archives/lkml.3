Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370AbaJ2OHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:07:10 -0400
Received: from mail.kernel.org ([198.145.19.201]:40956 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933350AbaJ2OHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:07:04 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/25] perf tools: Set thread->mg.machine in all places
Date: Wed, 29 Oct 2014 12:06:14 -0200
Message-Id: <1414591597-2763-3-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414591597-2763-1-git-send-email-acme@kernel.org>
References: <1414591597-2763-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We were setting this only in machine__init(), i.e. for the map_groups that
holds the kernel module maps, not for the one used for a thread's executable
mmaps.

Now we are sure that we can obtain the machine where a thread is by going
via thread->mg->machine, thus we can, in the following patch, make all
codepaths that receive machine _and_ thread, drop the machine one.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-y6zgaqsvhrf04v57u15e4ybm@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 5 ++---
 tools/perf/util/map.c     | 8 ++++----
 tools/perf/util/map.h     | 4 ++--
 tools/perf/util/thread.c  | 2 +-
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 34fc7c8672e4..c70b3ff7b289 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -21,7 +21,7 @@ static void dsos__init(struct dsos *dsos)
 
 int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 {
-	map_groups__init(&machine->kmaps);
+	map_groups__init(&machine->kmaps, machine);
 	RB_CLEAR_NODE(&machine->rb_node);
 	dsos__init(&machine->user_dsos);
 	dsos__init(&machine->kernel_dsos);
@@ -32,7 +32,6 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 
 	machine->vdso_info = NULL;
 
-	machine->kmaps.machine = machine;
 	machine->pid = pid;
 
 	machine->symbol_filter = NULL;
@@ -319,7 +318,7 @@ static void machine__update_thread_pid(struct machine *machine,
 		goto out_err;
 
 	if (!leader->mg)
-		leader->mg = map_groups__new();
+		leader->mg = map_groups__new(machine);
 
 	if (!leader->mg)
 		goto out_err;
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 2137c4596ec7..040a785c857b 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -413,14 +413,14 @@ u64 map__objdump_2mem(struct map *map, u64 ip)
 	return ip + map->reloc;
 }
 
-void map_groups__init(struct map_groups *mg)
+void map_groups__init(struct map_groups *mg, struct machine *machine)
 {
 	int i;
 	for (i = 0; i < MAP__NR_TYPES; ++i) {
 		mg->maps[i] = RB_ROOT;
 		INIT_LIST_HEAD(&mg->removed_maps[i]);
 	}
-	mg->machine = NULL;
+	mg->machine = machine;
 	mg->refcnt = 1;
 }
 
@@ -471,12 +471,12 @@ bool map_groups__empty(struct map_groups *mg)
 	return true;
 }
 
-struct map_groups *map_groups__new(void)
+struct map_groups *map_groups__new(struct machine *machine)
 {
 	struct map_groups *mg = malloc(sizeof(*mg));
 
 	if (mg != NULL)
-		map_groups__init(mg);
+		map_groups__init(mg, machine);
 
 	return mg;
 }
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 2f83954af050..6951a9d42339 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -64,7 +64,7 @@ struct map_groups {
 	int		 refcnt;
 };
 
-struct map_groups *map_groups__new(void);
+struct map_groups *map_groups__new(struct machine *machine);
 void map_groups__delete(struct map_groups *mg);
 bool map_groups__empty(struct map_groups *mg);
 
@@ -150,7 +150,7 @@ void maps__remove(struct rb_root *maps, struct map *map);
 struct map *maps__find(struct rb_root *maps, u64 addr);
 struct map *maps__first(struct rb_root *maps);
 struct map *maps__next(struct map *map);
-void map_groups__init(struct map_groups *mg);
+void map_groups__init(struct map_groups *mg, struct machine *machine);
 void map_groups__exit(struct map_groups *mg);
 int map_groups__clone(struct map_groups *mg,
 		      struct map_groups *parent, enum map_type type);
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index c41411726c7a..8db9626f6835 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -15,7 +15,7 @@ int thread__init_map_groups(struct thread *thread, struct machine *machine)
 	pid_t pid = thread->pid_;
 
 	if (pid == thread->tid || pid == -1) {
-		thread->mg = map_groups__new();
+		thread->mg = map_groups__new(machine);
 	} else {
 		leader = machine__findnew_thread(machine, pid, pid);
 		if (leader)
-- 
1.9.3

