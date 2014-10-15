Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbaJOKDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:03:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54285 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbaJOKDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:03:44 -0400
Date: Wed, 15 Oct 2014 03:02:54 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-kzchpz0l1mhrsfpkirz086m2@git.kernel.org>
Cc: peterz@infradead.org, jean.pihet@linaro.org, eranian@google.com,
        namhyung@kernel.org, acme@redhat.com, paulus@samba.org, hpa@zytor.com,
        fweisbec@gmail.com, jolsa@redhat.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de, mingo@kernel.org,
        linux-kernel@vger.kernel.org, dzickus@redhat.com, efault@gmx.de,
        bp@suse.de
Reply-To: hpa@zytor.com, fweisbec@gmail.com, jean.pihet@linaro.org,
        peterz@infradead.org, eranian@google.com, acme@redhat.com,
        namhyung@kernel.org, paulus@samba.org, efault@gmx.de,
        dzickus@redhat.com, bp@suse.de, jolsa@redhat.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, mingo@kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf session: Don't count per evsel events
Git-Commit-ID: c2329ade22844054f4dce79fb9358d8f9f0421a5
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

Commit-ID:  c2329ade22844054f4dce79fb9358d8f9f0421a5
Gitweb:     http://git.kernel.org/tip/c2329ade22844054f4dce79fb9358d8f9f0421a5
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 10 Oct 2014 15:12:15 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 10 Oct 2014 15:15:32 -0300

perf session: Don't count per evsel events

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
index 1d42354..66cae50 100644
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
