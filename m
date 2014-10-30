Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043AbaJ3GnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:43:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37916 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932975AbaJ3GnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:43:13 -0400
Date: Wed, 29 Oct 2014 23:42:26 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-y6zgaqsvhrf04v57u15e4ybm@git.kernel.org>
Cc: paulus@samba.org, fweisbec@gmail.com, efault@gmx.de,
        linux-kernel@vger.kernel.org, jolsa@redhat.com, peterz@infradead.org,
        adrian.hunter@intel.com, dzickus@redhat.com, dsahern@gmail.com,
        jean.pihet@linaro.org, namhyung@kernel.org, eranian@google.com,
        hpa@zytor.com, acme@redhat.com, tglx@linutronix.de, bp@suse.de,
        mingo@kernel.org
Reply-To: tglx@linutronix.de, mingo@kernel.org, bp@suse.de, hpa@zytor.com,
        acme@redhat.com, jean.pihet@linaro.org, namhyung@kernel.org,
        eranian@google.com, dzickus@redhat.com, peterz@infradead.org,
        adrian.hunter@intel.com, dsahern@gmail.com, efault@gmx.de,
        jolsa@redhat.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        paulus@samba.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Set thread->mg.machine in all places
Git-Commit-ID: 11246c708acdfa9512d7b69c18938810c20fd6ab
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

Commit-ID:  11246c708acdfa9512d7b69c18938810c20fd6ab
Gitweb:     http://git.kernel.org/tip/11246c708acdfa9512d7b69c18938810c20fd6ab
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 21 Oct 2014 17:29:02 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:32:46 -0200

perf tools: Set thread->mg.machine in all places

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
index 34fc7c8..c70b3ff 100644
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
index 2137c45..040a785 100644
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
index 2f83954..6951a9d 100644
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
index c414117..8db9626 100644
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
