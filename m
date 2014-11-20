Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbaKTHkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:40:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43892 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbaKTHkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:40:07 -0500
Date: Wed, 19 Nov 2014 23:39:46 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-f140373bc904d9541e3f8e985d3810864e34c735@git.kernel.org>
Cc: paulus@samba.org, cjashfor@linux.vnet.ibm.com, jolsa@kernel.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl, dsahern@gmail.com,
        acme@redhat.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        tglx@linutronix.de, rostedt@goodmis.org, hpa@zytor.com,
        fweisbec@gmail.com
Reply-To: paulus@samba.org, cjashfor@linux.vnet.ibm.com, jolsa@kernel.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl, acme@redhat.com,
        linux-kernel@vger.kernel.org, dsahern@gmail.com, rostedt@goodmis.org,
        namhyung@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        fweisbec@gmail.com
In-Reply-To: <1415899263-24820-1-git-send-email-jolsa@kernel.org>
References: <1415899263-24820-1-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Fix ftrace:function event recording
Git-Commit-ID: f140373bc904d9541e3f8e985d3810864e34c735
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

Commit-ID:  f140373bc904d9541e3f8e985d3810864e34c735
Gitweb:     http://git.kernel.org/tip/f140373bc904d9541e3f8e985d3810864e34c735
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Thu, 13 Nov 2014 18:21:03 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 19 Nov 2014 12:33:48 -0300

perf evsel: Fix ftrace:function event recording

Following patch fails (-EINVAL) ftrace:function with enabled user
space callchains:
  cfa77bc4af2c perf: Disallow user-space callchains for function trace events

We need to follow in perf tool itself and explicitly set the
perf_event_attr::exclude_callchain_user flag for ftrace:function
event.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1415899263-24820-1-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 34344ff..f2dc91f 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -658,6 +658,14 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 		attr->mmap_data = track;
 	}
 
+	/*
+	 * We don't allow user space callchains for  function trace
+	 * event, due to issues with page faults while tracing page
+	 * fault handler and its overall trickiness nature.
+	 */
+	if (perf_evsel__is_function_event(evsel))
+		evsel->attr.exclude_callchain_user = 1;
+
 	if (callchain_param.enabled && !evsel->no_aux_samples)
 		perf_evsel__config_callgraph(evsel);
 
