Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbaFZQQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:16:00 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:50166 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757629AbaFZQPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:15:14 -0400
X-Yandex-Uniq: 0eff0457-f496-4dac-8850-607134dfaef5
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, dsahern@gmail.com, stfomichev@yandex-team.ru,
        jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] perf trace: add pagefault statistics
Date: Thu, 26 Jun 2014 20:14:27 +0400
Message-Id: <1403799268-1367-5-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403799268-1367-1-git-send-email-stfomichev@yandex-team.ru>
References: <1403799268-1367-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'perf trace' can show summary of events using -S option. This commit
also reports number of major/minor pagefault events in this summary.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/builtin-trace.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 38f3dedcbb4a..73d1266e6303 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1132,6 +1132,7 @@ struct thread_trace {
 	u64		  exit_time;
 	bool		  entry_pending;
 	unsigned long	  nr_events;
+	unsigned long	  pfmaj, pfmin;
 	char		  *entry_str;
 	double		  runtime_ms;
 	struct {
@@ -1803,8 +1804,17 @@ static int trace__pgfault(struct trace *trace,
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	struct addr_location al;
 	char map_type = 'd';
+	struct thread_trace *ttrace;
 
 	thread = machine__findnew_thread(trace->host, sample->pid, sample->tid);
+	ttrace = thread__trace(thread, trace->output);
+	if (ttrace == NULL)
+		return -1;
+
+	if (evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS_MAJ)
+		ttrace->pfmaj++;
+	else
+		ttrace->pfmin++;
 
 	thread__find_addr_location(thread, trace->host, cpumode, MAP__FUNCTION,
 			      sample->ip, &al);
@@ -2347,6 +2357,7 @@ static int trace__fprintf_one_thread(struct thread *thread, void *priv)
 	printed += fprintf(fp, " %s (%d), ", thread__comm_str(thread), thread->tid);
 	printed += fprintf(fp, "%lu events, ", ttrace->nr_events);
 	printed += fprintf(fp, "%.1f%%", ratio);
+	printed += fprintf(fp, ", %lu:%lu faults", ttrace->pfmaj, ttrace->pfmin);
 	printed += fprintf(fp, ", %.3f msec\n", ttrace->runtime_ms);
 	printed += thread__dump_stats(ttrace, trace, fp);
 
-- 
1.9.1

