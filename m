Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbbA2IVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:21:48 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50963 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbbA2IJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:09:58 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 05/42] perf tools: Set attr.task bit for a tracking event
Date: Thu, 29 Jan 2015 17:06:46 +0900
Message-Id: <1422518843-25818-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf_event_attr.task bit is to track task (fork and exit) events
but it missed to be set by perf_evsel__config().  While it was not a
problem in practice since setting other bits (comm/mmap) ended up
being in same result, it'd be good to set it explicitly anyway.

The attr->task is to track task related events (fork/exit) only but
other meta events like comm and mmap[2] also needs the task events.
So setting attr->comm and/or attr->mmap causes the kernel emits the
task events anyway.  So the attr->task is only meaningful when other
bits are off but I'd like to set it for completeness.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evsel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 1d826d63bc20..ea51a90e20a0 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -709,6 +709,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	if (opts->sample_weight)
 		perf_evsel__set_sample_bit(evsel, WEIGHT);
 
+	attr->task  = track;
 	attr->mmap  = track;
 	attr->mmap2 = track && !perf_missing_features.mmap2;
 	attr->comm  = track;
-- 
2.2.2

