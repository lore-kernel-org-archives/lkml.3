Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933714AbaCQPmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 11:42:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933197AbaCQPmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 11:42:24 -0400
Date: Mon, 17 Mar 2014 11:41:59 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@google.com, jmario@redhat.com, jolsa@redhat.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, lwoodman@redhat.com
Subject: Re: perf MMAP2 interface and COW faults
Message-ID: <20140317154159.GI25953@redhat.com>
References: <20140313200352.GU25953@redhat.com>
 <20140314111705.GU27965@twins.programming.kicks-ass.net>
 <20140317153747.GH25953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317153747.GH25953@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 11:37:47AM -0400, Don Zickus wrote:
> On Fri, Mar 14, 2014 at 12:17:05PM +0100, Peter Zijlstra wrote:
> > On Thu, Mar 13, 2014 at 04:03:52PM -0400, Don Zickus wrote:
> > > Hi Peter,
> > > 
> > > So we found another corner case with MMAP2 interface.  I don't think it is
> > > a big hurdle to overcome, just wanted a suggestion.
> > > 
> > > Joe ran specjbb2013 (which creates about 10,000 java threads across 9
> > > processes) and our c2c tool turned up some cacheline collision data on
> > > libjvm.so.  This didn't make sense because you shouldn't be able to write
> > > to a shared library.
> > > 
> > > Even worse, our tool said it affected all the java process and a majority
> > > of the threads.  Which again didn't make sense because this shared library
> > > should be local to each pid's memory.
> > > 
> > > Anyway, what we determined is that the shared library had mmap data that
> > > was non-zero (because it was backed by a file, libjvm.so).  So the
> > > assumption was if the major, minor, inode and inode generation numbers
> > > were non-zero, this memory segment was shared across processes.
> > > 
> > > So perf setup its map files for the mmap area and then started sampling data
> > > addresses.  A few hundred HITMs were to a virtual address that fell into
> > > the libjvm.so memory segment (which was assumed to be mmap'd across
> > > processes).
> > > 
> > > Coalescing all the data suggested that multiple pids/tids were contending
> > > for a cacheline in a shared library.
> > > 
> > > After talking with Larry Woodman, we realized when you write to a 'data' or
> > > 'bss' segment of a shared library, you incur a COW fault that maps to an
> > > anonymous page in the pid's memory.  However, perf doesn't see this.
> > > 
> > > So when all the tids start writing to this 'data' or 'bss' segment they
> > > generate HITMs within their pid (which is fine).  However the tool thinks
> > > it affects other pids (which is not fine).
> > > 
> > > My question is, how can our tool determine if a virtual address is private
> > > to a pid or not?  Originally it had to have a zero for maj, min, ino, and
> > > ino gen.  But for file map'd libraries this doesn't always work because we
> > > don't see COW faults in perf (and we may not want too :-) ).
> > > 
> > > Is there another technique we can use?  Perhaps during the reading of
> > > /proc/<pid>/maps, if the protection is marked 'p' for private, we just tell
> > > the sort algorithm to sort locally to the process but a 's' for shared can
> > > be sorted globally based on data addresses?
> > > 
> > > Or something else that tells us that a virtual address has changed its
> > > mapping?  Thoughts?
> > 
> > Very good indeed; we're missing the protection and flags bits.
> > 
> > How about something like the below; with that you can solve your problem
> > by looking at mmap2.flags & MAP_PRIVATE.
> 
> Yes this seemed to work.  I attached a slight update to your patch (one
> that compiles :-) ).  And I will reply to this thread with the tool
> changes I used to verify this (in case I did that piece wrong).

And here is the perf tool changes I did to utilize this.  Of course this
is based on reverting 3090ffb5a2515990182f3f55b0688a7817325488.

Cheers,
Don

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index b02f3b4..bad58fc 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -1,4 +1,5 @@
 #include <linux/types.h>
+#include <sys/mman.h>
 #include "event.h"
 #include "debug.h"
 #include "machine.h"
@@ -213,6 +214,21 @@ int perf_event__synthesize_mmap_events(struct perf_tool *tool,
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
@@ -613,12 +629,15 @@ size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp)
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
index c8b0fdd..986931e 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1040,6 +1040,8 @@ int machine__process_mmap2_event(struct machine *machine,
 			event->mmap2.pid, event->mmap2.maj,
 			event->mmap2.min, event->mmap2.ino,
 			event->mmap2.ino_generation,
+			event->mmap2.prot,
+			event->mmap2.flags,
 			event->mmap2.filename, type);
 
 	if (map == NULL)
@@ -1085,7 +1087,7 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 
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
