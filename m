Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbaI0H0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 03:26:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41211 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbaI0HZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 03:25:57 -0400
Date: Sat, 27 Sep 2014 00:24:55 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-a5c2a4c9561cbbd374231bd341936dae716df9dd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1411594794-7229-1-git-send-email-andi@firstfloor.org>
References: <1411594794-7229-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix perf record as non root with kptr_restrict == 1
Git-Commit-ID: a5c2a4c9561cbbd374231bd341936dae716df9dd
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

Commit-ID:  a5c2a4c9561cbbd374231bd341936dae716df9dd
Gitweb:     http://git.kernel.org/tip/a5c2a4c9561cbbd374231bd341936dae716df9dd
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Wed, 24 Sep 2014 14:39:54 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 26 Sep 2014 10:51:41 -0300

perf tools: Fix perf record as non root with kptr_restrict == 1

Currently perf record always errors out when you run it as non-root with
kptr_restrict == 1, which is often the default.

Make it only warn instead and fix the kernel resolve code to not
segfault later. Profiling works still fine, except kernel symbols are
not resolved.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1411594794-7229-1-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c   | 8 ++++++--
 tools/perf/util/session.c | 2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index ed55819..4af6b27 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -558,13 +558,17 @@ int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 	struct map *map;
 	struct kmap *kmap;
 	int err;
+	union perf_event *event;
+
+	if (machine->vmlinux_maps[0] == NULL)
+		return -1;
+
 	/*
 	 * We should get this from /sys/kernel/sections/.text, but till that is
 	 * available use this, and after it is use this as a fallback for older
 	 * kernels.
 	 */
-	union perf_event *event = zalloc((sizeof(event->mmap) +
-					  machine->id_hdr_size));
+	event = zalloc((sizeof(event->mmap) + machine->id_hdr_size));
 	if (event == NULL) {
 		pr_debug("Not enough memory synthesizing mmap event "
 			 "for kernel modules\n");
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 6d2d50d..883406f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -119,7 +119,7 @@ struct perf_session *perf_session__new(struct perf_data_file *file,
 		 * kernel MMAP event, in perf_event__process_mmap().
 		 */
 		if (perf_session__create_kernel_maps(session) < 0)
-			goto out_delete;
+			pr_warning("Cannot read kernel map\n");
 	}
 
 	if (tool && tool->ordering_requires_timestamps &&
