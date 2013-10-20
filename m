Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab3JTTcS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 15:32:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52625 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab3JTTcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 15:32:15 -0400
Date: Sun, 20 Oct 2013 12:31:21 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-3090ffb5a2515990182f3f55b0688a7817325488@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        jolsa@redhat.com, ak@linux.intel.com, dsahern@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        jolsa@redhat.com, dsahern@gmail.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20131017173215.GA8820@quad>
References: <20131017173215.GA8820@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Disable PERF_RECORD_MMAP2 support
Git-Commit-ID: 3090ffb5a2515990182f3f55b0688a7817325488
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 20 Oct 2013 12:31:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3090ffb5a2515990182f3f55b0688a7817325488
Gitweb:     http://git.kernel.org/tip/3090ffb5a2515990182f3f55b0688a7817325488
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 17 Oct 2013 19:32:15 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 17 Oct 2013 16:27:14 -0300

perf: Disable PERF_RECORD_MMAP2 support

For now, we disable the extended MMAP record support (MMAP2).

We have identified cases where it would not report the correct mapping
information, clone(VM_CLONE) but with separate pids.  We will revisit
the support once we find a solution for this case.

The patch changes the kernel to return EINVAL if attr->mmap2 is set. The
patch also modifies the perf tool to use regular PERF_RECORD_MMAP for
synthetic events and it also prevents the tool from requesting
attr->mmap2 mode because the kernel would reject it.

The support will be revisited once the kenrel interface is updated.

In V2, we reduce the patch to the strict minimum.

In V3, we avoid calling perf_event_open() with mmap2 set because we know
it will fail and require fallback retry.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131017173215.GA8820@quad
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/events/core.c    |  4 ++++
 tools/perf/util/event.c | 30 +++++++++++++-----------------
 tools/perf/util/evsel.c |  1 -
 3 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d49a9d2..953c143 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6767,6 +6767,10 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
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
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 0ce9feb..9f1ef9b 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -678,7 +678,6 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		attr->sample_type	|= PERF_SAMPLE_WEIGHT;
 
 	attr->mmap  = track;
-	attr->mmap2 = track && !perf_missing_features.mmap2;
 	attr->comm  = track;
 
 	/*
