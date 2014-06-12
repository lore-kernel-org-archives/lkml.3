Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933849AbaFLMDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:03:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60566 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933101AbaFLMC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:02:57 -0400
Date: Thu, 12 Jun 2014 05:02:36 -0700
From: tip-bot for Don Zickus <tipbot@zytor.com>
Message-ID: <tip-a5a5ba72843dd05f991184d6cb9a4471acce1005@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <1401461382-209586-1-git-send-email-dzickus@redhat.com>
References: <1401461382-209586-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] Revert "perf: Disable PERF_RECORD_MMAP2 support"
Git-Commit-ID: a5a5ba72843dd05f991184d6cb9a4471acce1005
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

Commit-ID:  a5a5ba72843dd05f991184d6cb9a4471acce1005
Gitweb:     http://git.kernel.org/tip/a5a5ba72843dd05f991184d6cb9a4471acce1005
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Fri, 30 May 2014 10:49:42 -0400
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 9 Jun 2014 13:34:46 +0200

Revert "perf: Disable PERF_RECORD_MMAP2 support"

This reverts commit 3090ffb5a2515990182f3f55b0688a7817325488.

Re-enable the mmap2 interface as we will have a user soon.

Since things have changed since perf disabled mmap2, small tweaks
to the revert had to be done:

o commit 9d4ecc88 forced (n!=8) to become (n<7)
o a new libunwind test needed updating to use mmap2 interface

Signed-off-by: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/1401461382-209586-1-git-send-email-dzickus@redhat.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/events/core.c            |  4 ----
 tools/perf/tests/dwarf-unwind.c |  2 +-
 tools/perf/util/event.c         | 34 ++++++++++++++++++++--------------
 tools/perf/util/evsel.c         |  1 +
 4 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index eea1955..cd28335 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6929,10 +6929,6 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
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
index ce43cba..d0281bd 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -179,13 +179,14 @@ int perf_event__synthesize_mmap_events(struct perf_tool *tool,
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
 
@@ -196,15 +197,20 @@ int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		strcpy(execname, "");
 
 		/* 00400000-0040c000 r-xp 00000000 fd:01 41038  /bin/cat */
-		n = sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %*x:%*x %*u %s\n",
-		       &event->mmap.start, &event->mmap.len, prot,
-		       &event->mmap.pgoff,
-		       execname);
+		n = sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %x:%x %u %s\n",
+		       &event->mmap2.start, &event->mmap2.len, prot,
+		       &event->mmap2.pgoff, &event->mmap2.maj,
+		       &event->mmap2.min,
+		       &ino, execname);
+
 		/*
  		 * Anon maps don't have the execname.
  		 */
-		if (n < 4)
+		if (n < 7)
 			continue;
+
+		event->mmap2.ino = (u64)ino;
+
 		/*
 		 * Just like the kernel, see __perf_event_mmap in kernel/perf_event.c
 		 */
@@ -239,15 +245,15 @@ int perf_event__synthesize_mmap_events(struct perf_tool *tool,
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
