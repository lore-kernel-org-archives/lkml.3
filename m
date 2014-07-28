Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaG1I1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:27:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42657 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbaG1I1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:27:14 -0400
Date: Mon, 28 Jul 2014 01:26:19 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-5835eddab6f162b38e9a6a5447a2c3a128637956@git.kernel.org>
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
In-Reply-To: <1406035081-14301-52-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-52-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add thread parameter to vdso__dso_findnew()
Git-Commit-ID: 5835eddab6f162b38e9a6a5447a2c3a128637956
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

Commit-ID:  5835eddab6f162b38e9a6a5447a2c3a128637956
Gitweb:     http://git.kernel.org/tip/5835eddab6f162b38e9a6a5447a2c3a128637956
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Jul 2014 16:18:00 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Jul 2014 17:37:26 -0300

perf tools: Add thread parameter to vdso__dso_findnew()

The thread will be needed to determine the VDSO type.

Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406035081-14301-52-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 4 ++--
 tools/perf/util/map.c     | 4 ++--
 tools/perf/util/map.h     | 3 ++-
 tools/perf/util/vdso.c    | 3 ++-
 tools/perf/util/vdso.h    | 3 ++-
 5 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 65269b8..16bba9f 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1106,7 +1106,7 @@ int machine__process_mmap2_event(struct machine *machine,
 			event->mmap2.ino_generation,
 			event->mmap2.prot,
 			event->mmap2.flags,
-			event->mmap2.filename, type);
+			event->mmap2.filename, type, thread);
 
 	if (map == NULL)
 		goto out_problem;
@@ -1153,7 +1153,7 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
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
