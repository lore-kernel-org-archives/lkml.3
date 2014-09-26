Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbaIZUWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:22:30 -0400
Received: from mail.kernel.org ([198.145.19.201]:52656 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756125AbaIZUUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:20:02 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/10] perf tools: Fix perf record as non root with kptr_restrict == 1
Date: Fri, 26 Sep 2014 17:19:39 -0300
Message-Id: <1411762787-26113-3-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411762787-26113-1-git-send-email-acme@kernel.org>
References: <1411762787-26113-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

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
index ed558191c0b3..4af6b279e34a 100644
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
index 6d2d50dea1d8..883406f4b381 100644
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
-- 
1.9.3

