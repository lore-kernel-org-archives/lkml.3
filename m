Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab3KAJaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 05:30:00 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:50088 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab3KAJ35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 05:29:57 -0400
From: Chenggang Qin <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chenggang Qin <chenggang.qin@gmail.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chenggang Qin <chenggang.qcg@taobao.com>
Subject: [PATCH 4/4] perf tools: add the feature to assign analysis interval to perf report
Date: Fri,  1 Nov 2013 17:29:06 +0800
Message-Id: <1383298146-3860-5-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383298146-3860-1-git-send-email-chenggang.qin@gmail.com>
References: <1383298146-3860-1-git-send-email-chenggang.qin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only process the samples whose timestamp is in [start, end).

Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>

---
 tools/perf/util/session.c |   43 +++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 4e9dd66..d50e29e 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -532,6 +532,9 @@ static int flush_sample_queue(struct perf_session *s,
 	bool show_progress = limit == ULLONG_MAX;
 	int ret;
 
+	if (limit > s->tend)
+		limit = s->tend;
+
 	if (!tool->ordered_samples || !limit)
 		return 0;
 
@@ -539,6 +542,9 @@ static int flush_sample_queue(struct perf_session *s,
 		if (session_done())
 			return 0;
 
+		if (iter->timestamp < s->tstart)
+			continue;
+
 		if (iter->timestamp > limit)
 			break;
 
@@ -617,7 +623,26 @@ static int process_finished_round(struct perf_tool *tool,
 				  union perf_event *event __maybe_unused,
 				  struct perf_session *session)
 {
-	int ret = flush_sample_queue(session, tool);
+	int ret = 0;
+
+	/*
+	 * The next round should be processed continue.
+	 * But, this round is skipped.
+	 */
+	if (session->ordered_samples.next_flush < session->tstart) {
+		session->ordered_samples.next_flush = session->ordered_samples.max_timestamp;
+		return ret;
+	}
+
+	/*
+	 * This round & all followed rounds are skipped.
+	 */
+	if (session->ordered_samples.min_timestamp > session->tend) {
+		session->ordered_samples.next_flush = ULLONG_MAX;
+		return ret;
+	}
+
+	ret = flush_sample_queue(session, tool);
 	if (!ret)
 		session->ordered_samples.next_flush = session->ordered_samples.max_timestamp;
 
@@ -1373,6 +1398,14 @@ more:
 		goto out_err;
 	}
 
+	/*
+	 * After process a finished round event:
+	 * The minimal timestamp in os->samples is greater than
+	 * tend, so, the followed  events couldn't be processed.
+	 */
+	if (session->ordered_samples.next_flush == ULLONG_MAX)
+		goto out_err;
+
 	head += size;
 	file_pos += size;
 
@@ -1389,8 +1422,14 @@ more:
 	if (file_pos < file_size)
 		goto more;
 
+	if (session->ordered_samples.max_timestamp < session->tstart)
+		goto out_err;
+
+	if (session->ordered_samples.min_timestamp > session->tend)
+		goto out_err;
+
 	/* do the final flush for ordered samples */
-	session->ordered_samples.next_flush = ULLONG_MAX;
+	session->ordered_samples.next_flush = session->tend;
 	err = flush_sample_queue(session, tool);
 out_err:
 	ui_progress__finish();
-- 
1.7.8.rc2.5.g815b

