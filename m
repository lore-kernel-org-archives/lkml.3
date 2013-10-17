Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab3JQO2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:28:40 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:58740 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081Ab3JQO2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:28:38 -0400
Date: Thu, 17 Oct 2013 16:28:39 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, ak@linux.intel.com, dsahern@gmail.com,
        jolsa@redhat.com, acme@redhat.com, hughd@google.com
Subject: [PATCH v2] perf: disable PERF_RECORD_MMAP2 support
Message-ID: <20131017142839.GA8482@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For now, we disable the extended MMAP record support (MMAP2).
We have identified cases where it would not report the correct
mapping information, clone(VM_CLONE) but with separate pids.
We will revisit the support once we find a solution for this case.

The patch changes the kernel to return EINVAL if attr->mmap2
is set. The patch also modifies the perf tool to use regular PERF_RECORD_MMAP
for synthetic events and it also prevents the tool from requesting attr->mmap2
mode because the kernel would reject it.

The support will be revisited once the kenrel interface is updated.

In V2, we reduce the patch to the strict minimum.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 kernel/events/core.c    |    4 ++++
 tools/perf/util/event.c |   30 +++++++++++++-----------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index c716385..5bd7fe4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6773,6 +6773,10 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	if (ret)
 		return -EFAULT;
 
+	/* disabled for now */
+	if (attr->mmap2)
+		return -EINVAL;
+
 	if (attr->__reserved_1)
 		return -EINVAL;
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 9b393e7..63df031 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -187,7 +187,7 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		return -1;
 	}
 
-	event->header.type = PERF_RECORD_MMAP2;
+	event->header.type = PERF_RECORD_MMAP;
 	/*
 	 * Just like the kernel, see __perf_event_mmap in kernel/perf_event.c
 	 */
@@ -198,7 +198,6 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		char prot[5];
 		char execname[PATH_MAX];
 		char anonstr[] = "//anon";
-		unsigned int ino;
 		size_t size;
 		ssize_t n;
 
@@ -209,13 +208,10 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		strcpy(execname, "");
 
 		/* 00400000-0040c000 r-xp 00000000 fd:01 41038  /bin/cat */
-		n = sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %x:%x %u %s\n",
-		       &event->mmap2.start, &event->mmap2.len, prot,
-		       &event->mmap2.pgoff, &event->mmap2.maj,
-		       &event->mmap2.min,
-		       &ino, execname);
-
-		event->mmap2.ino = (u64)ino;
+		n = sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %*x:%*x %*u %s\n",
+		       &event->mmap.start, &event->mmap.len, prot,
+		       &event->mmap.pgoff,
+		       execname);
 
 		if (n != 8)
 			continue;
@@ -227,15 +223,15 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 			strcpy(execname, anonstr);
 
 		size = strlen(execname) + 1;
-		memcpy(event->mmap2.filename, execname, size);
+		memcpy(event->mmap.filename, execname, size);
 		size = PERF_ALIGN(size, sizeof(u64));
-		event->mmap2.len -= event->mmap.start;
-		event->mmap2.header.size = (sizeof(event->mmap2) -
-					(sizeof(event->mmap2.filename) - size));
-		memset(event->mmap2.filename + size, 0, machine->id_hdr_size);
-		event->mmap2.header.size += machine->id_hdr_size;
-		event->mmap2.pid = tgid;
-		event->mmap2.tid = pid;
+		event->mmap.len -= event->mmap.start;
+		event->mmap.header.size = (sizeof(event->mmap) -
+					(sizeof(event->mmap.filename) - size));
+		memset(event->mmap.filename + size, 0, machine->id_hdr_size);
+		event->mmap.header.size += machine->id_hdr_size;
+		event->mmap.pid = tgid;
+		event->mmap.tid = pid;
 
 		if (process(tool, event, &synth_sample, machine) != 0) {
 			rc = -1;
-- 
1.7.9.5

