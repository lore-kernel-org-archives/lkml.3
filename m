Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933428AbaFLMCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:02:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60556 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933212AbaFLMCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:02:34 -0400
Date: Thu, 12 Jun 2014 05:02:20 -0700
From: tip-bot for Don Zickus <tipbot@zytor.com>
Message-ID: <tip-7ef807034ef33f8afe33fa7957c73954e8e4f89c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <1400526833-141779-4-git-send-email-dzickus@redhat.com>
References: <1400526833-141779-4-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Update mmap2 interface with protection and flag bits
Git-Commit-ID: 7ef807034ef33f8afe33fa7957c73954e8e4f89c
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

Commit-ID:  7ef807034ef33f8afe33fa7957c73954e8e4f89c
Gitweb:     http://git.kernel.org/tip/7ef807034ef33f8afe33fa7957c73954e8e4f89c
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Mon, 19 May 2014 15:13:49 -0400
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 9 Jun 2014 13:34:45 +0200

perf tools: Update mmap2 interface with protection and flag bits

The kernel piece passes more info now.  Update the perf tool to reflect
that and adjust the synthesized maps to play along.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/1400526833-141779-4-git-send-email-dzickus@redhat.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/event.c   | 23 +++++++++++++++++++++--
 tools/perf/util/event.h   |  2 ++
 tools/perf/util/machine.c |  4 +++-
 tools/perf/util/map.c     |  4 +++-
 tools/perf/util/map.h     |  4 +++-
 5 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 65795b8..ce43cba 100644
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
index d970232..9ba2eb3 100644
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
index 7409ac8..0e5fea9 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1060,6 +1060,8 @@ int machine__process_mmap2_event(struct machine *machine,
 			event->mmap2.pid, event->mmap2.maj,
 			event->mmap2.min, event->mmap2.ino,
 			event->mmap2.ino_generation,
+			event->mmap2.prot,
+			event->mmap2.flags,
 			event->mmap2.filename, type);
 
 	if (map == NULL)
@@ -1105,7 +1107,7 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 
 	map = map__new(&machine->user_dsos, event->mmap.start,
 			event->mmap.len, event->mmap.pgoff,
-			event->mmap.pid, 0, 0, 0, 0,
+			event->mmap.pid, 0, 0, 0, 0, 0, 0,
 			event->mmap.filename,
 			type);
 
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 8ccbb32..25c571f 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -138,7 +138,7 @@ void map__init(struct map *map, enum map_type type,
 
 struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		     u64 pgoff, u32 pid, u32 d_maj, u32 d_min, u64 ino,
-		     u64 ino_gen, char *filename,
+		     u64 ino_gen, u32 prot, u32 flags, char *filename,
 		     enum map_type type)
 {
 	struct map *map = malloc(sizeof(*map));
@@ -157,6 +157,8 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		map->min = d_min;
 		map->ino = ino;
 		map->ino_generation = ino_gen;
+		map->prot = prot;
+		map->flags = flags;
 
 		if ((anon || no_dso) && type == MAP__FUNCTION) {
 			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index ae2d451..7758c72 100644
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
@@ -118,7 +120,7 @@ void map__init(struct map *map, enum map_type type,
 	       u64 start, u64 end, u64 pgoff, struct dso *dso);
 struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		     u64 pgoff, u32 pid, u32 d_maj, u32 d_min, u64 ino,
-		     u64 ino_gen,
+		     u64 ino_gen, u32 prot, u32 flags,
 		     char *filename, enum map_type type);
 struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
 void map__delete(struct map *map);
