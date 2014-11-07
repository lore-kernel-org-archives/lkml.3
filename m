Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaKGFdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:33:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57923 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbaKGFcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:32:50 -0500
Date: Thu, 6 Nov 2014 21:32:29 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-daa01794a4a36a1da1b09a529adec0c8c0b94ab2@git.kernel.org>
Cc: jolsa@kernel.org, acme@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, dsahern@gmail.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        cjashfor@linux.vnet.ibm.com, mingo@kernel.org, namhyung@kernel.org,
        paulus@samba.org
Reply-To: mingo@kernel.org, cjashfor@linux.vnet.ibm.com, namhyung@kernel.org,
        paulus@samba.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        fweisbec@gmail.com, dsahern@gmail.com, a.p.zijlstra@chello.nl,
        acme@redhat.com, jolsa@kernel.org, tglx@linutronix.de, hpa@zytor.com
In-Reply-To: <1415098538-1512-1-git-send-email-jolsa@kernel.org>
References: <1415098538-1512-1-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Do not call pevent_free_format when deleting tracepoint
Git-Commit-ID: daa01794a4a36a1da1b09a529adec0c8c0b94ab2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  daa01794a4a36a1da1b09a529adec0c8c0b94ab2
Gitweb:     http://git.kernel.org/tip/daa01794a4a36a1da1b09a529adec0c8c0b94ab2
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Tue, 4 Nov 2014 11:55:38 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 6 Nov 2014 17:47:14 -0300

perf evsel: Do not call pevent_free_format when deleting tracepoint

The libtraceevent library's main handle 'struct pevent' holds pointers
of every event that was added to it via functions:

  pevent_parse_format
  pevent_parse_event

We can't release struct event_format (call pevent_free_format)
separately, because that breaks that pointers array mentioned above and
another add_event call could end up with segfault.

All added events are released within the handle cleanup in pevent_free.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1415098538-1512-1-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 2f9e680..12b4396 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -853,8 +853,6 @@ void perf_evsel__exit(struct perf_evsel *evsel)
 	perf_evsel__free_id(evsel);
 	close_cgroup(evsel->cgrp);
 	zfree(&evsel->group_name);
-	if (evsel->tp_format)
-		pevent_free_format(evsel->tp_format);
 	zfree(&evsel->name);
 	perf_evsel__object.fini(evsel);
 }
