Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab3JZMYU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 08:24:20 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:64542 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3JZMYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 08:24:19 -0400
Date: Sat, 26 Oct 2013 14:24:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20131026122414.GA25026@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: e4f8eaad70ea186b8da290c99239dce721a34f88 Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

The tree contains three fixes:

 - Two tooling fixes

 - Reversal of the new 'MMAP2' extended mmap record ABI, introduced 
   in this merge window. (Patches were proposed to fix it but it was
   all a bit late and we felt it's safer to just delay the ABI one
   more kernel release and do it right.)

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      perf scripting perl: Fix build error on Fedora 12

Masami Hiramatsu (1):
      perf probe: Fix to initialize fname always before use it

Stephane Eranian (1):
      perf: Disable PERF_RECORD_MMAP2 support


 kernel/events/core.c                               |  4 +++
 tools/perf/util/event.c                            | 30 ++++++++++------------
 tools/perf/util/evsel.c                            |  1 -
 tools/perf/util/probe-finder.c                     |  2 +-
 .../perf/util/scripting-engines/trace-event-perl.c |  2 +-
 5 files changed, 19 insertions(+), 20 deletions(-)

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
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index c09e0a9..f069273 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1357,10 +1357,10 @@ int debuginfo__find_probe_point(struct debuginfo *self, unsigned long addr,
 			goto post;
 		}
 
+		fname = dwarf_decl_file(&spdie);
 		if (addr == (unsigned long)baseaddr) {
 			/* Function entry - Relative line number is 0 */
 			lineno = baseline;
-			fname = dwarf_decl_file(&spdie);
 			goto post;
 		}
 
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index a85e4ae..c0c9795 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -282,7 +282,7 @@ static void perl_process_tracepoint(union perf_event *perf_event __maybe_unused,
 
 	event = find_cache_event(evsel);
 	if (!event)
-		die("ug! no event found for type %" PRIu64, evsel->attr.config);
+		die("ug! no event found for type %" PRIu64, (u64)evsel->attr.config);
 
 	pid = raw_field_value(event, "common_pid", data);
 
