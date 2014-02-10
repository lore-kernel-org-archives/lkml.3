Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaBJRa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:30:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbaBJRaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:30:25 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 03/21] Revert "perf: Disable PERF_RECORD_MMAP2 support"
Date: Mon, 10 Feb 2014 12:28:58 -0500
Message-Id: <1392053356-23024-4-git-send-email-dzickus@redhat.com>
In-Reply-To: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 3090ffb5a2515990182f3f55b0688a7817325488.

With the introduction of the c2c tools, we now have a user of MMAP2

Signed-off-by: Don Zickus <dzickus@redhat.com>

---
 kernel/events/core.c    |  4 ----
 tools/perf/util/event.c | 36 +++++++++++++++++++-----------------
 tools/perf/util/evsel.c |  1 +
 3 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 56003c6..f18cbb8 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6832,10 +6832,6 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	if (ret)
 		return -EFAULT;
 
-	/* disabled for now */
-	if (attr->mmap2)
-		return -EINVAL;
-
 	if (attr->__reserved_1)
 		return -EINVAL;
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index b0f3ca8..086c7c8 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -201,13 +201,14 @@ int perf_event__synthesize_mmap_events(struct perf_tool *tool,
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
 
@@ -218,14 +219,15 @@ int perf_event__synthesize_mmap_events(struct perf_tool *tool,
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
@@ -246,15 +248,15 @@ int perf_event__synthesize_mmap_events(struct perf_tool *tool,
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
index 55407c5..65db757 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -640,6 +640,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 		perf_evsel__set_sample_bit(evsel, WEIGHT);
 
 	attr->mmap  = track;
+	attr->mmap2 = track && !perf_missing_features.mmap2;
 	attr->comm  = track;
 
 	if (opts->sample_transaction)
-- 
1.7.11.7

