Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab3JROje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:39:34 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:16908 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab3JROjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:39:32 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v2 1/4] perf: Fix potential compilation error with some compilers
Date: Fri, 18 Oct 2013 10:38:46 -0400
Message-Id: <1382107129-2010-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1382107129-2010-1-git-send-email-Waiman.Long@hp.com>
References: <1382107129-2010-1-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

