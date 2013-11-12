Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab3KLV6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:58:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40310 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644Ab3KLV6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:58:15 -0500
Date: Tue, 12 Nov 2013 13:57:33 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-48095b721ca54ffa70427185c00473530f4aef06@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, acme@ghostprotocols.net,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        acme@ghostprotocols.net, efault@gmx.de, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <5281DFE5.3000909@intel.com>
References: <5281DFE5.3000909@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tests: Handle throttle events in '
 object code reading' test
Git-Commit-ID: 48095b721ca54ffa70427185c00473530f4aef06
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 12 Nov 2013 13:57:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48095b721ca54ffa70427185c00473530f4aef06
Gitweb:     http://git.kernel.org/tip/48095b721ca54ffa70427185c00473530f4aef06
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 12 Nov 2013 09:59:33 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Nov 2013 16:37:54 -0300

perf tests: Handle throttle events in 'object code reading' test

Unhandled events cause an error that fails the test, fix it.

Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/5281DFE5.3000909@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/code-reading.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 6d9dc19..85d4919 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -275,8 +275,19 @@ static int process_event(struct machine *machine, struct perf_evlist *evlist,
 	if (event->header.type == PERF_RECORD_SAMPLE)
 		return process_sample_event(machine, evlist, event, state);
 
-	if (event->header.type < PERF_RECORD_MAX)
-		return machine__process_event(machine, event, NULL);
+	if (event->header.type == PERF_RECORD_THROTTLE ||
+	    event->header.type == PERF_RECORD_UNTHROTTLE)
+		return 0;
+
+	if (event->header.type < PERF_RECORD_MAX) {
+		int ret;
+
+		ret = machine__process_event(machine, event, NULL);
+		if (ret < 0)
+			pr_debug("machine__process_event failed, event type %u\n",
+				 event->header.type);
+		return ret;
+	}
 
 	return 0;
 }
