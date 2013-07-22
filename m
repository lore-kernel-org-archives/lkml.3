Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354Ab3GVUWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:22:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52050 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab3GVUWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:22:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/11] perf evsel: Handle ENODEV on default cycles event
Date: Mon, 22 Jul 2013 17:22:30 -0300
Message-Id: <1374524559-9839-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374524559-9839-1-git-send-email-acme@infradead.org>
References: <1374524559-9839-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Some systems (e.g., VMs on qemu-0.13 with the default vcpu model) report
an unsupported CPU model:

Performance Events: unsupported p6 CPU model 2 no PMU driver, software events only.

Subsequent invocations of perf fail with:

The sys_perf_event_open() syscall returned with 19 (No such device) for event (cycles).
/bin/dmesg may provide additional information.
No CONFIG_PERF_EVENTS=y kernel support configured?

Add ENODEV to the list of errno's to fallback to cpu-clock.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1374190079-28507-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a635461..8bed0c1 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1482,7 +1482,7 @@ out:
 bool perf_evsel__fallback(struct perf_evsel *evsel, int err,
 			  char *msg, size_t msgsize)
 {
-	if ((err == ENOENT || err == ENXIO) &&
+	if ((err == ENOENT || err == ENXIO || err == ENODEV) &&
 	    evsel->attr.type   == PERF_TYPE_HARDWARE &&
 	    evsel->attr.config == PERF_COUNT_HW_CPU_CYCLES) {
 		/*
-- 
1.8.1.4

