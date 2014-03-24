Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbaCXTrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:47:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbaCXTfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:35:18 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net, peterz@infradead.org
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com, andi.kleen@intel.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/6] perf: Update mmap2 interface with protection and flag bits
Date: Mon, 24 Mar 2014 15:34:32 -0400
Message-Id: <1395689676-214799-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1395689676-214799-1-git-send-email-dzickus@redhat.com>
References: <1395689676-214799-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel piece passes more info now.  Update the perf tool to reflect
that and adjust the synthesized maps to play along.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/util/event.c   | 23 +++++++++++++++++++++--
 tools/perf/util/event.h   |  2 ++
 tools/perf/util/machine.c |  4 +++-
 tools/perf/util/map.c     |  4 +++-
 tools/perf/util/map.h     |  4 +++-
 5 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 9d12aa6..6b8646c 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -1,4 +1,5 @@
 #include <linux/types.h>
+#include <sys/mman.h>
 #include "event.h"
 #include "debug.h"
 #include "hist.h"
@@ -212,6 +213,21 @@ int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		else
 			event->header.misc = PERF_RECORD_MISC_GUEST_USER;
 
+		/* map protection and flags bits */
+		event->mmap2.prot = 0;
+		event->mmap2.flags = 0;
+		if (prot[0] == 'r')
+			event->mmap2.prot |= PROT_READ;
+		if (prot[1] == 'w')
+			event->mmap2.prot |= PROT_WRITE;
+		if (prot[2] == 'x')
+			event->mmap2.prot |= PROT_EXEC;
+
+		if (prot[3] == 's')
+			event->mmap2.flags |= MAP_SHARED;
+		else
+			event->mmap2.flags |= MAP_PRIVATE;
+
 		if (prot[2] != 'x') {
 			if (!mmap_data || prot[0] != 'r')
 				continue;
@@ -612,12 +628,15 @@ size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp)
 size_t perf_event__fprintf_mmap2(union perf_event *event, FILE *fp)
 {
 	return fprintf(fp, " %d/%d: [%#" PRIx64 "(%#" PRIx64 ") @ %#" PRIx64
-			   " %02x:%02x %"PRIu64" %"PRIu64"]: %c %s\n",
+			   " %02x:%02x %"PRIu64" %"PRIu64"]: %c%c%c%c %s\n",
 		       event->mmap2.pid, event->mmap2.tid, event->mmap2.start,
 		       event->mmap2.len, event->mmap2.pgoff, event->mmap2.maj,
 		       event->mmap2.min, event->mmap2.ino,
 		       event->mmap2.ino_generation,
-		       (event->header.misc & PERF_RECORD_MISC_MMAP_DATA) ? 'r' : 'x',
+		       (event->mmap2.prot & PROT_READ) ? 'r' : '-',
+		       (event->mmap2.prot & PROT_WRITE) ? 'w' : '-',
+		       (event->mmap2.prot & PROT_EXEC) ? 'x' : '-',
+		       (event->mmap2.flags & MAP_SHARED) ? 's' : 'p',
 		       event->mmap2.filename);
 }
 
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 38457d4..96bd19c 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -27,6 +27,8 @@ struct mmap2_event {
 	u32 min;
 	u64 ino;
 	u64 ino_generation;
+	u32 prot;
+	u32 flags;
 	char filename[PATH_MAX];
 };
 
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index a53cd0b..f3cf46f 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1041,6 +1041,8 @@ int machine__process_mmap2_event(struct machine *machine,
 			event->mmap2.pid, event->mmap2.maj,
 			event->mmap2.min, event->mmap2.ino,
 			event->mmap2.ino_generation,
+			event->mmap2.prot,
+			event->mmap2.flags,
 			event->mmap2.filename, type);
 
 	if (map == NULL)
@@ -1086,7 +1088,7 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 
 	map = map__new(&machine->user_dsos, event->mmap.start,
 			event->mmap.len, event->mmap.pgoff,
-			event->mmap.pid, 0, 0, 0, 0,
+			event->mmap.pid, 0, 0, 0, 0, 0, 0,
 			event->mmap.filename,
 			type);
 
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 39cd2d0..f98f8fe 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -51,7 +51,7 @@ void map__init(struct map *map, enum map_type type,
 
 struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		     u64 pgoff, u32 pid, u32 d_maj, u32 d_min, u64 ino,
-		     u64 ino_gen, char *filename,
+		     u64 ino_gen, u32 prot, u32 flags, char *filename,
 		     enum map_type type)
 {
 	struct map *map = malloc(sizeof(*map));
@@ -69,6 +69,8 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		map->min = d_min;
 		map->ino = ino;
 		map->ino_generation = ino_gen;
+		map->prot = prot;
+		map->flags = flags;
 
 		if ((anon || no_dso) && type == MAP__FUNCTION) {
 			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index f00f058..8cd0cff 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -35,6 +35,8 @@ struct map {
 	bool			referenced;
 	bool			erange_warned;
 	u32			priv;
+	u32			prot;
+	u32			flags;
 	u64			pgoff;
 	u64			reloc;
 	u32			maj, min; /* only valid for MMAP2 record */
@@ -106,7 +108,7 @@ void map__init(struct map *map, enum map_type type,
 	       u64 start, u64 end, u64 pgoff, struct dso *dso);
 struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		     u64 pgoff, u32 pid, u32 d_maj, u32 d_min, u64 ino,
-		     u64 ino_gen,
+		     u64 ino_gen, u32 prot, u32 flags,
 		     char *filename, enum map_type type);
 struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
 void map__delete(struct map *map);
-- 
1.7.11.7

