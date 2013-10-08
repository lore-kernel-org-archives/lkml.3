Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab3JHUpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:45:55 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:42134 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860Ab3JHUpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:45:54 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH] perf: Fix potential compilation error with some compilers
Date: Tue,  8 Oct 2013 16:45:20 -0400
Message-Id: <1381265120-58532-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The building of the perf tool failed in a SLES11 sp3 system with the
following compilation error:

cc1: warnings being treated as errors
util/scripting-engines/trace-event-perl.c: In function
‘perl_process_tracepoint’:
util/scripting-engines/trace-event-perl.c:285: error: format ‘%lu’
expects type ‘long unsigned int’, but argument 2 has type ‘__u64’

This patch replaces PRIu64 which is "lu" by the explicit "llu" to
fix this problem as __u64 is of type "long long unsigned".

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 .../perf/util/scripting-engines/trace-event-perl.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index a85e4ae..d6eb9c5 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -281,8 +281,12 @@ static void perl_process_tracepoint(union perf_event *perf_event __maybe_unused,
 		return;
 
 	event = find_cache_event(evsel);
+	/*
+	 * attr.config is a __u64 which requires "%llu" to avoid compilation
+	 * error/warning with some compilers.
+	 */
 	if (!event)
-		die("ug! no event found for type %" PRIu64, evsel->attr.config);
+		die("ug! no event found for type %llu", evsel->attr.config);
 
 	pid = raw_field_value(event, "common_pid", data);
 
-- 
1.7.1

