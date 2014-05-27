Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaE0QaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:30:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbaE0Q3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:29:02 -0400
From: Don Zickus <dzickus@redhat.com>
To: jolsa@redhat.com
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, namhyung@gmail.com,
        eranian@google.com, Andi Kleen <andi@firstfloor.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/7] Revert "perf: Disable PERF_RECORD_MMAP2 support"
Date: Tue, 27 May 2014 12:28:02 -0400
Message-Id: <1401208087-181977-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1401208087-181977-1-git-send-email-dzickus@redhat.com>
References: <1401208087-181977-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 3090ffb5a2515990182f3f55b0688a7817325488.

Re-enable the mmap2 interface as we will have a user soon.

Since things have changed since perf disabled mmap2, small tweaks
to the revert had to be done:

o commit 9d4ecc88 forced (n!=8) to become (n<7)
o a new libunwind test needed updating to use mmap2 interface

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
v2: added a better changelog
    fix a unwind test (thanks Jiri)
---
 kernel/events/core.c            |  4 ----
 tools/perf/tests/dwarf-unwind.c |  2 +-
 tools/perf/util/event.c         | 36 +++++++++++++++++++-----------------
 tools/perf/util/evsel.c         |  1 +
 4 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0711cc9..c793cb0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6882,10 +6882,6 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	if (ret)
 		return -EFAULT;
 
-	/* disabled for now */
-	if (attr->mmap2)
-		return -EINVAL;
-
 	if (attr->__reserved_1)
 		return -EINVAL;
 
diff --git a/tools/perf/tests/dwarf-unwind.c b/tools/perf/tests/dwarf-unwind.c
index 108f0cd..96adb73 100644
--- a/tools/perf/tests/dwarf-unwind.c
+++ b/tools/perf/tests/dwarf-unwind.c
@@ -15,7 +15,7 @@ static int mmap_handler(struct perf_tool *tool __maybe_unused,
 			struct perf_sample *sample __maybe_unused,
 			struct machine *machine)
 {
-	return machine__process_mmap_event(machine, event, NULL);
+	return machine__process_mmap2_event(machine, event, NULL);
 }
 
 static int init_live_machine(struct machine *machine)
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 65795b8..5e7c722 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -178,13 +178,14 @@ int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		return -1;
 	}
 
-	event->header.type = PERF_RECORD_MMAP;
+	event->header.type = PERF_RECORD_MMAP2;
 
 	while (1) {
 		char bf[BUFSIZ];
 		char prot[5];
 		char execname[PATH_MAX];
 		char anonstr[] = "//anon";
+		unsigned int ino;
 		size_t size;
 		ssize_t n;
 
@@ -195,14 +196,15 @@ int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		strcpy(execname, "");
 
 		/* 00400000-0040c000 r-xp 00000000 fd:01 41038  /bin/cat */
-		n = sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %*x:%*x %*u %s\n",
-		       &event->mmap.start, &event->mmap.len, prot,
-		       &event->mmap.pgoff,
-		       execname);
-		/*
- 		 * Anon maps don't have the execname.
- 		 */
-		if (n < 4)
+		n = sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %x:%x %u %s\n",
+		       &event->mmap2.start, &event->mmap2.len, prot,
+		       &event->mmap2.pgoff, &event->mmap2.maj,
+		       &event->mmap2.min,
+		       &ino, execname);
+
+		event->mmap2.ino = (u64)ino;
+
+		if (n < 7)
 			continue;
 		/*
 		 * Just like the kernel, see __perf_event_mmap in kernel/perf_event.c
@@ -223,15 +225,15 @@ int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 			strcpy(execname, anonstr);
 
 		size = strlen(execname) + 1;
-		memcpy(event->mmap.filename, execname, size);
+		memcpy(event->mmap2.filename, execname, size);
 		size = PERF_ALIGN(size, sizeof(u64));
-		event->mmap.len -= event->mmap.start;
-		event->mmap.header.size = (sizeof(event->mmap) -
-					(sizeof(event->mmap.filename) - size));
-		memset(event->mmap.filename + size, 0, machine->id_hdr_size);
-		event->mmap.header.size += machine->id_hdr_size;
-		event->mmap.pid = tgid;
-		event->mmap.tid = pid;
+		event->mmap2.len -= event->mmap.start;
+		event->mmap2.header.size = (sizeof(event->mmap2) -
+					(sizeof(event->mmap2.filename) - size));
+		memset(event->mmap2.filename + size, 0, machine->id_hdr_size);
+		event->mmap2.header.size += machine->id_hdr_size;
+		event->mmap2.pid = tgid;
+		event->mmap2.tid = pid;
 
 		if (process(tool, event, &synth_sample, machine) != 0) {
 			rc = -1;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 5c28d82..21154da 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -659,6 +659,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 		perf_evsel__set_sample_bit(evsel, WEIGHT);
 
 	attr->mmap  = track;
+	attr->mmap2 = track && !perf_missing_features.mmap2;
 	attr->comm  = track;
 
 	if (opts->sample_transaction)
-- 
1.7.11.7

