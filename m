Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab3KLWBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 17:01:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40217 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366Ab3KLV4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:56:53 -0500
Date: Tue, 12 Nov 2013 13:56:13 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-96695d440242aca871ef8d797bd98d9cbd7ad8a0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <20131112115700.GC4053@ghostprotocols.net>
References: <20131112115700.GC4053@ghostprotocols.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace:
  Separate tp syscall field caching into init routine to be reused
Git-Commit-ID: 96695d440242aca871ef8d797bd98d9cbd7ad8a0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 12 Nov 2013 13:56:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  96695d440242aca871ef8d797bd98d9cbd7ad8a0
Gitweb:     http://git.kernel.org/tip/96695d440242aca871ef8d797bd98d9cbd7ad8a0
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 12 Nov 2013 08:51:45 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Nov 2013 13:00:36 -0300

perf trace: Separate tp syscall field caching into init routine to be reused

We need to set this in evsels coming out of a perf.data file header, not
just for new ones created for live sessions.

So separate the code that caches the syscall entry/exit tracepoint
format fields into a new function that will be used in the next
changeset.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/20131112115700.GC4053@ghostprotocols.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index aeb6296..3fa1dce 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -149,20 +149,32 @@ static void perf_evsel__delete_priv(struct perf_evsel *evsel)
 	perf_evsel__delete(evsel);
 }
 
+static int perf_evsel__init_syscall_tp(struct perf_evsel *evsel, void *handler)
+{
+	evsel->priv = malloc(sizeof(struct syscall_tp));
+	if (evsel->priv != NULL) {
+		if (perf_evsel__init_sc_tp_uint_field(evsel, id))
+			goto out_delete;
+
+		evsel->handler = handler;
+		return 0;
+	}
+
+	return -ENOMEM;
+
+out_delete:
+	free(evsel->priv);
+	evsel->priv = NULL;
+	return -ENOENT;
+}
+
 static struct perf_evsel *perf_evsel__syscall_newtp(const char *direction, void *handler)
 {
 	struct perf_evsel *evsel = perf_evsel__newtp("raw_syscalls", direction);
 
 	if (evsel) {
-		evsel->priv = malloc(sizeof(struct syscall_tp));
-
-		if (evsel->priv == NULL)
+		if (perf_evsel__init_syscall_tp(evsel, handler))
 			goto out_delete;
-
-		if (perf_evsel__init_sc_tp_uint_field(evsel, id))
-			goto out_delete;
-
-		evsel->handler = handler;
 	}
 
 	return evsel;
