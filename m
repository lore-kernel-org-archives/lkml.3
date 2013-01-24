Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab3AXUfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:35:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50139 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab3AXUIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 70/74] perf script: hook up perf_scripting_context->pevent
Date: Thu, 24 Jan 2013 17:08:19 -0300
Message-Id: <1359058103-31645-71-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@linux.intel.com>

Running the check-perf-trace scripts causes segfaults in both the Perl
and Python cases:

  # perf script record check-perf-trace
  # perf script -s libexec/perf-core/scripts/python/check-perf-trace.py
  trace_begin
  Segmentation fault (core dumped)

The reason is that the 'pevent' field was added to
perf_scripting_context but it wasn't hooked up with an actual pevent in
either case, so when one of the 'common' fields is accessed (in
util/trace-event-parse.c:get_common_fields()), pevent->events tries to
dereference a NULL pointer.

This sets the pevent field when the scripting context is set up.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Link: http://lkml.kernel.org/r/d2b1b8166a6ca0a36e1f5255b88a8289058ba236.1358527965.git.tom.zanussi@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/scripting-engines/trace-event-perl.c   | 1 +
 tools/perf/util/scripting-engines/trace-event-python.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index f80605e..eacec85 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -292,6 +292,7 @@ static void perl_process_tracepoint(union perf_event *perf_event __maybe_unused,
 	ns = nsecs - s * NSECS_PER_SEC;
 
 	scripting_context->event_data = data;
+	scripting_context->pevent = evsel->tp_format->pevent;
 
 	ENTER;
 	SAVETMPS;
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 14683df..e87aa5d 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -265,6 +265,7 @@ static void python_process_tracepoint(union perf_event *perf_event
 	ns = nsecs - s * NSECS_PER_SEC;
 
 	scripting_context->event_data = data;
+	scripting_context->pevent = evsel->tp_format->pevent;
 
 	context = PyCObject_FromVoidPtr(scripting_context, NULL);
 
-- 
1.8.1.1.361.gec3ae6e

