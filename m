Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab3AYMLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:11:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42374 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab3AYMK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:10:58 -0500
Date: Fri, 25 Jan 2013 04:10:36 -0800
From: tip-bot for Tom Zanussi <tom.zanussi@linux.intel.com>
Message-ID: <tip-2de9533d6d61d3086a7079bf142d2bfa374e664e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, tom.zanussi@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, tom.zanussi@linux.intel.com
In-Reply-To: <d2b1b8166a6ca0a36e1f5255b88a8289058ba236.1358527965.git.tom.zanussi@linux.intel.com>
References: <d2b1b8166a6ca0a36e1f5255b88a8289058ba236.1358527965.git.tom.zanussi@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: hook up perf_scripting_context->
 pevent
Git-Commit-ID: 2de9533d6d61d3086a7079bf142d2bfa374e664e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 04:10:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2de9533d6d61d3086a7079bf142d2bfa374e664e
Gitweb:     http://git.kernel.org/tip/2de9533d6d61d3086a7079bf142d2bfa374e664e
Author:     Tom Zanussi <tom.zanussi@linux.intel.com>
AuthorDate: Fri, 18 Jan 2013 13:51:27 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:52 -0300

perf script: hook up perf_scripting_context->pevent

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
 
