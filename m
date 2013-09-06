Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab3IFMPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 08:15:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53716 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3IFMPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 08:15:01 -0400
Date: Fri, 6 Sep 2013 05:14:35 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-526fd8d4f770d18e99680ff87965e16bb8f1d806@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <20130905091449.GC1100@krava.brq.redhat.com>
References: <20130905091449.GC1100@krava.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf session:
  Separate progress bar update when processing events
Git-Commit-ID: 526fd8d4f770d18e99680ff87965e16bb8f1d806
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 06 Sep 2013 05:14:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  526fd8d4f770d18e99680ff87965e16bb8f1d806
Gitweb:     http://git.kernel.org/tip/526fd8d4f770d18e99680ff87965e16bb8f1d806
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 5 Sep 2013 11:14:50 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 5 Sep 2013 16:19:02 -0300

perf session: Separate progress bar update when processing events

Currently when processing events in the __perf_session__process_events
function we update a progress bar based on the file_size. During the
same processing we update the progress bar from within
flush_sample_queue which is based on number of samples count.

Having 2 different based updates is causing the progress bar to jump
heavily back and forth giving not much usefull info.

Fixing this by keeping only __perf_session__process_events based
progress bar update. And turning on flush_sample_queue progress bar
update only for final flushing.

This reduces the number of time the progress bar update function is
called and it significantly reduces the loading time for TUI, where the
progress bar update takes quite a lot of time.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20130905091449.GC1100@krava.brq.redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1fc0c62..476caa1 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -504,6 +504,7 @@ static int flush_sample_queue(struct perf_session *s,
 	u64 limit = os->next_flush;
 	u64 last_ts = os->last_sample ? os->last_sample->timestamp : 0ULL;
 	unsigned idx = 0, progress_next = os->nr_samples / 16;
+	bool show_progress = limit == ULLONG_MAX;
 	int ret;
 
 	if (!tool->ordered_samples || !limit)
@@ -526,7 +527,7 @@ static int flush_sample_queue(struct perf_session *s,
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
 		list_add(&iter->list, &os->sample_cache);
-		if (++idx >= progress_next) {
+		if (show_progress && (++idx >= progress_next)) {
 			progress_next += os->nr_samples / 16;
 			ui_progress__update(idx, os->nr_samples,
 					    "Processing time ordered events...");
