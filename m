Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaIXVkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:40:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:11834 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbaIXVkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:40:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,591,1406617200"; 
   d="scan'208";a="596390022"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        mingo@kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, tools: Fix perf record as non root with kptr_restrict == 1
Date: Wed, 24 Sep 2014 14:39:54 -0700
Message-Id: <1411594794-7229-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Currently perf record always errors out when you run it as non-root
with kptr_restrict == 1, which is often the default.

Make it only warn instead and fix the kernel resolve code
to not segfault later. Profiling works still fine, except
kernel symbols are not resolved.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
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
-- 
1.9.3

