Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab3ARTvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:51:46 -0500
Received: from mga03.intel.com ([143.182.124.21]:18655 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492Ab3ARTvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:51:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,494,1355126400"; 
   d="scan'208";a="245739356"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: acme@redhat.com
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 3/4] perf tools: hook up perf_scripting_context->pevent
Date: Fri, 18 Jan 2013 13:51:27 -0600
Message-Id: <d2b1b8166a6ca0a36e1f5255b88a8289058ba236.1358527965.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1358527965.git.tom.zanussi@linux.intel.com>
References: <cover.1358527965.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1358527965.git.tom.zanussi@linux.intel.com>
References: <cover.1358527965.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running the check-perf-trace scripts causes segfaults in both the Perl
and Python cases:

  # perf script record check-perf-trace
  # perf script -s libexec/perf-core/scripts/python/check-perf-trace.py
  trace_begin
  Segmentation fault (core dumped)

The reason is that the 'pevent' field was added to
perf_scripting_context but it wasn't hooked up with an actual pevent
in either case, so when one of the 'common' fields is accessed (in
util/trace-event-parse.c:get_common_fields()), pevent->events tries to
dereference a NULL pointer.

This sets the pevent field when the scripting context is set up.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
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
1.7.11.4

