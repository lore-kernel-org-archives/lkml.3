Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaFRPCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:02:54 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:44905 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449AbaFRPAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:00:54 -0400
X-Yandex-Uniq: dac920b0-a581-4b4f-bab5-9c42c0393543
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, dsahern@gmail.com, stfomichev@yandex-team.ru,
        jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] perf trace: add pagefault statistics
Date: Wed, 18 Jun 2014 18:59:22 +0400
Message-Id: <1403103565-6388-3-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403103565-6388-1-git-send-email-stfomichev@yandex-team.ru>
References: <1403103565-6388-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/builtin-trace.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 6c7ae048db59..535f0b504950 100644
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
@@ -1798,8 +1799,12 @@ static int trace__pgfault(struct trace *trace,
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	struct addr_location al;
 	char map_type = 'd';
+	struct thread_trace *ttrace;
 
 	thread = machine__findnew_thread(trace->host, sample->pid, sample->tid);
+	ttrace = thread__trace(thread, trace->output);
+	if (ttrace == NULL)
+		return -1;
 
 	thread__find_addr_location(thread, trace->host, cpumode, MAP__FUNCTION,
 			      sample->ip, &al);
@@ -1810,6 +1815,11 @@ static int trace__pgfault(struct trace *trace,
 		evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS_MAJ ?
 		"maj" : "min");
 
+	if (evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS_MAJ)
+		ttrace->pfmaj++;
+	else
+		ttrace->pfmin++;
+
 	if (al.sym)
 		fprintf(trace->output, "[%s+0x%lx]",
 			al.sym->name, al.addr - al.sym->start);
@@ -2343,6 +2353,7 @@ static int trace__fprintf_one_thread(struct thread *thread, void *priv)
 	printed += fprintf(fp, " %s (%d), ", thread__comm_str(thread), thread->tid);
 	printed += fprintf(fp, "%lu events, ", ttrace->nr_events);
 	printed += fprintf(fp, "%.1f%%", ratio);
+	printed += fprintf(fp, ", %lu:%lu faults", ttrace->pfmaj, ttrace->pfmin);
 	printed += fprintf(fp, ", %.3f msec\n", ttrace->runtime_ms);
 	printed += thread__dump_stats(ttrace, trace, fp);
 
-- 
1.8.3.2

