Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab3C1RIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:08:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36333 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786Ab3C1RCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:02:54 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 29/36] perf machine: Detect data vs. text mappings
Date: Thu, 28 Mar 2013 14:02:29 -0300
Message-Id: <1364490156-32064-30-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1364490156-32064-1-git-send-email-acme@infradead.org>
References: <1364490156-32064-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

Leverages the PERF_RECORD_MISC_MMAP_DATA bit in the RECORD_MMAP record
header. When the bit is set then the mapping type is set to
MAP__VARIABLE.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1359040242-8269-17-git-send-email-eranian@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index d77ba86..b2ecad6 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -955,6 +955,7 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	struct thread *thread;
 	struct map *map;
+	enum map_type type;
 	int ret = 0;
 
 	if (dump_trace)
@@ -971,10 +972,17 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 	thread = machine__findnew_thread(machine, event->mmap.pid);
 	if (thread == NULL)
 		goto out_problem;
+
+	if (event->header.misc & PERF_RECORD_MISC_MMAP_DATA)
+		type = MAP__VARIABLE;
+	else
+		type = MAP__FUNCTION;
+
 	map = map__new(&machine->user_dsos, event->mmap.start,
 			event->mmap.len, event->mmap.pgoff,
 			event->mmap.pid, event->mmap.filename,
-			MAP__FUNCTION);
+			type);
+
 	if (map == NULL)
 		goto out_problem;
 
-- 
1.7.1

