Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222AbaCRV0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:26:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44431 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933131AbaCRV0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:26:17 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/13] perf tools: Use tid in mmap/mmap2 events to find maps
Date: Tue, 18 Mar 2014 18:25:58 -0300
Message-Id: <1395177965-8879-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1395177965-8879-1-git-send-email-acme@infradead.org>
References: <1395177965-8879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>

Now that we can properly synthesize threads system-wide, make sure the
mmap and mmap2 events use tids instead of pids to locate their maps.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1393429527-167840-3-git-send-email-dzickus@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/hists_link.c | 1 +
 tools/perf/util/machine.c     | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 2b6519e0e36f..7ccbc7b6ae77 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -101,6 +101,7 @@ static struct machine *setup_fake_machine(struct machines *machines)
 			.mmap = {
 				.header = { .misc = PERF_RECORD_MISC_USER, },
 				.pid = fake_mmap_info[i].pid,
+				.tid = fake_mmap_info[i].pid,
 				.start = fake_mmap_info[i].start,
 				.len = 0x1000ULL,
 				.pgoff = 0ULL,
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index d280bf210183..a53cd0b8c151 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1027,7 +1027,7 @@ int machine__process_mmap2_event(struct machine *machine,
 	}
 
 	thread = machine__findnew_thread(machine, event->mmap2.pid,
-					event->mmap2.pid);
+					event->mmap2.tid);
 	if (thread == NULL)
 		goto out_problem;
 
@@ -1075,7 +1075,7 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 	}
 
 	thread = machine__findnew_thread(machine, event->mmap.pid,
-					 event->mmap.pid);
+					 event->mmap.tid);
 	if (thread == NULL)
 		goto out_problem;
 
-- 
1.8.1.4

