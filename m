Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbaJNVFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:05:30 -0400
Received: from mail.kernel.org ([198.145.19.201]:44656 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810AbaJNVFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:05:25 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 08/24] perf session: Don't count per evsel events
Date: Tue, 14 Oct 2014 18:04:17 -0300
Message-Id: <1413320673-5784-9-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413320673-5784-1-git-send-email-acme@kernel.org>
References: <1413320673-5784-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

PERF_RECORD_SAMPLE was not being counted here and is the only per-evsel
thing anyway, the other events were not mapping to a evsel.

With this we don't require that evsels used with a perf_session need to
have space for hists, like the ones in annotate, report, top.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-kzchpz0l1mhrsfpkirz086m2@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1d423548862f..66cae50b5c4c 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -813,22 +813,6 @@ int perf_session__deliver_event(struct perf_session *session,
 	dump_event(session, event, file_offset, sample);
 
 	evsel = perf_evlist__id2evsel(session->evlist, sample->id);
-	if (evsel != NULL && event->header.type != PERF_RECORD_SAMPLE) {
-		/*
-		 * XXX We're leaving PERF_RECORD_SAMPLE unnacounted here
-		 * because the tools right now may apply filters, discarding
-		 * some of the samples. For consistency, in the future we
-		 * should have something like nr_filtered_samples and remove
-		 * the sample->period from total_sample_period, etc, KISS for
-		 * now tho.
-		 *
-		 * Also testing against NULL allows us to handle files without
-		 * attr.sample_id_all and/or without PERF_SAMPLE_ID. In the
-		 * future probably it'll be a good idea to restrict event
-		 * processing via perf_session to files with both set.
-		 */
-		hists__inc_nr_events(evsel__hists(evsel), event->header.type);
-	}
 
 	machine = perf_session__find_machine_for_cpumode(session, event,
 							 sample);
-- 
1.9.3

