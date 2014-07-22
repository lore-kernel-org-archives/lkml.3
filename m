Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbaGVNWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:22:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:28140 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674AbaGVNVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:21:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="576986418"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 51/52] perf tools: Add thread parameter to vdso__dso_findnew()
Date: Tue, 22 Jul 2014 16:18:00 +0300
Message-Id: <1406035081-14301-52-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The thread will be needed to determine the VDSO
type.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c | 4 ++--
 tools/perf/util/map.c     | 4 ++--
 tools/perf/util/map.h     | 3 ++-
 tools/perf/util/vdso.c    | 3 ++-
 tools/perf/util/vdso.h    | 3 ++-
 5 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 9b9fd26..a431bc9 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1133,7 +1133,7 @@ int machine__process_mmap2_event(struct machine *machine,
 			event->mmap2.ino_generation,
 			event->mmap2.prot,
 			event->mmap2.flags,
-			event->mmap2.filename, type);
+			event->mmap2.filename, type, thread);
 
 	if (map == NULL)
 		goto out_problem;
@@ -1180,7 +1180,7 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 			event->mmap.len, event->mmap.pgoff,
 			event->mmap.pid, 0, 0, 0, 0, 0, 0,
 			event->mmap.filename,
-			type);
+			type, thread);
 
 	if (map == NULL)
 		goto out_problem;
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index dffc8dc..31b8905 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -141,7 +141,7 @@ void map__init(struct map *map, enum map_type type,
 struct map *map__new(struct machine *machine, u64 start, u64 len,
 		     u64 pgoff, u32 pid, u32 d_maj, u32 d_min, u64 ino,
 		     u64 ino_gen, u32 prot, u32 flags, char *filename,
-		     enum map_type type)
+		     enum map_type type, struct thread *thread)
 {
 	struct map *map = malloc(sizeof(*map));
 
@@ -174,7 +174,7 @@ struct map *map__new(struct machine *machine, u64 start, u64 len,
 
 		if (vdso) {
 			pgoff = 0;
-			dso = vdso__dso_findnew(machine);
+			dso = vdso__dso_findnew(machine, thread);
 		} else
 			dso = __dsos__findnew(&machine->user_dsos, filename);
 
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index a95e677..2f83954 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -104,6 +104,7 @@ u64 map__rip_2objdump(struct map *map, u64 rip);
 u64 map__objdump_2mem(struct map *map, u64 ip);
 
 struct symbol;
+struct thread;
 
 /* map__for_each_symbol - iterate over the symbols in the given map
  *
@@ -122,7 +123,7 @@ void map__init(struct map *map, enum map_type type,
 struct map *map__new(struct machine *machine, u64 start, u64 len,
 		     u64 pgoff, u32 pid, u32 d_maj, u32 d_min, u64 ino,
 		     u64 ino_gen, u32 prot, u32 flags,
-		     char *filename, enum map_type type);
+		     char *filename, enum map_type type, struct thread *thread);
 struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
 void map__delete(struct map *map);
 struct map *map__clone(struct map *map);
diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index a9300f8..adca693 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -135,7 +135,8 @@ static struct dso *vdso__new(struct machine *machine, const char *short_name,
 	return dso;
 }
 
-struct dso *vdso__dso_findnew(struct machine *machine)
+struct dso *vdso__dso_findnew(struct machine *machine,
+			      struct thread *thread __maybe_unused)
 {
 	struct vdso_info *vdso_info;
 	struct dso *dso;
diff --git a/tools/perf/util/vdso.h b/tools/perf/util/vdso.h
index be3eb43..af9d692 100644
--- a/tools/perf/util/vdso.h
+++ b/tools/perf/util/vdso.h
@@ -19,8 +19,9 @@ struct dso;
 bool dso__is_vdso(struct dso *dso);
 
 struct machine;
+struct thread;
 
-struct dso *vdso__dso_findnew(struct machine *machine);
+struct dso *vdso__dso_findnew(struct machine *machine, struct thread *thread);
 void vdso__exit(struct machine *machine);
 
 #endif /* __PERF_VDSO__ */
-- 
1.8.3.2

