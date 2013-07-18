Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934728Ab3GRX2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:28:09 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:53559 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933481Ab3GRX2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:28:07 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf record/top: handle ENODEV on default cycles event
Date: Thu, 18 Jul 2013 17:27:59 -0600
Message-Id: <1374190079-28507-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some systems (e.g., VMs on qemu-0.13 with the default vcpu model) report
an unsupported CPU model:

Performance Events: unsupported p6 CPU model 2 no PMU driver, software events only.

Subsequent invocations of perf fail with:

The sys_perf_event_open() syscall returned with 19 (No such device) for event (cycles).
/bin/dmesg may provide additional information.
No CONFIG_PERF_EVENTS=y kernel support configured?

Add ENODEV to the list of errno's to fallback to cpu-clock.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/evsel.c |    2 +-
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
1.7.10.1

