Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161244Ab3BAKzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:55:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52139 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161064Ab3BAKzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:55:08 -0500
Date: Fri, 1 Feb 2013 02:54:34 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-717e263fc354d53d0961e952b779d14a42c8ea66@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1358845787-1350-17-git-send-email-namhyung@kernel.org>
References: <1358845787-1350-17-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  Show group description when event group is enabled
Git-Commit-ID: 717e263fc354d53d0961e952b779d14a42c8ea66
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 01 Feb 2013 02:54:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  717e263fc354d53d0961e952b779d14a42c8ea66
Gitweb:     http://git.kernel.org/tip/717e263fc354d53d0961e952b779d14a42c8ea66
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 22 Jan 2013 18:09:44 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 Jan 2013 13:07:48 -0300

perf report: Show group description when event group is enabled

When using event group viewer, it's better to show the group description
rather than the leader information alone.

If a leader did not contain any member, it's a non-group event.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1358845787-1350-17-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c    | 15 +++++++++++++++
 tools/perf/ui/browsers/hists.c | 25 +++++++++++++++++++++++++
 tools/perf/ui/gtk/hists.c      | 14 +++++++++++---
 tools/perf/util/evsel.c        | 25 +++++++++++++++++++++++++
 tools/perf/util/evsel.h        |  8 ++++++++
 5 files changed, 84 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 9cc768e..ce518c4 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -299,6 +299,21 @@ static size_t hists__fprintf_nr_sample_events(struct hists *self,
 	char unit;
 	unsigned long nr_samples = self->stats.nr_events[PERF_RECORD_SAMPLE];
 	u64 nr_events = self->stats.total_period;
+	struct perf_evsel *evsel = hists_to_evsel(self);
+	char buf[512];
+	size_t size = sizeof(buf);
+
+	if (symbol_conf.event_group && evsel->nr_members > 1) {
+		struct perf_evsel *pos;
+
+		perf_evsel__group_desc(evsel, buf, size);
+		evname = buf;
+
+		for_each_group_member(pos, evsel) {
+			nr_samples += pos->hists.stats.nr_events[PERF_RECORD_SAMPLE];
+			nr_events += pos->hists.stats.total_period;
+		}
+	}
 
 	nr_samples = convert_unit(nr_samples, &unit);
 	ret = fprintf(fp, "# Samples: %lu%c", nr_samples, unit);
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 167f770..20ccd57 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1189,6 +1189,21 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 	const struct thread *thread = hists->thread_filter;
 	unsigned long nr_samples = hists->stats.nr_events[PERF_RECORD_SAMPLE];
 	u64 nr_events = hists->stats.total_period;
+	struct perf_evsel *evsel = hists_to_evsel(hists);
+	char buf[512];
+	size_t buflen = sizeof(buf);
+
+	if (symbol_conf.event_group && evsel->nr_members > 1) {
+		struct perf_evsel *pos;
+
+		perf_evsel__group_desc(evsel, buf, buflen);
+		ev_name = buf;
+
+		for_each_group_member(pos, evsel) {
+			nr_samples += pos->hists.stats.nr_events[PERF_RECORD_SAMPLE];
+			nr_events += pos->hists.stats.total_period;
+		}
+	}
 
 	nr_samples = convert_unit(nr_samples, &unit);
 	printed = scnprintf(bf, size,
@@ -1585,6 +1600,16 @@ static void perf_evsel_menu__write(struct ui_browser *browser,
 	ui_browser__set_color(browser, current_entry ? HE_COLORSET_SELECTED :
 						       HE_COLORSET_NORMAL);
 
+	if (symbol_conf.event_group && evsel->nr_members > 1) {
+		struct perf_evsel *pos;
+
+		ev_name = perf_evsel__group_name(evsel);
+
+		for_each_group_member(pos, evsel) {
+			nr_events += pos->hists.stats.nr_events[PERF_RECORD_SAMPLE];
+		}
+	}
+
 	nr_events = convert_unit(nr_events, &unit);
 	printed = scnprintf(bf, sizeof(bf), "%lu%c%s%s", nr_events,
 			   unit, unit == ' ' ? "" : " ", ev_name);
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 9c02c4c..1e764a8 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -270,10 +270,18 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 		const char *evname = perf_evsel__name(pos);
 		GtkWidget *scrolled_window;
 		GtkWidget *tab_label;
+		char buf[512];
+		size_t size = sizeof(buf);
 
-		if (symbol_conf.event_group &&
-		    !perf_evsel__is_group_leader(pos))
-			continue;
+		if (symbol_conf.event_group) {
+			if (!perf_evsel__is_group_leader(pos))
+				continue;
+
+			if (pos->nr_members > 1) {
+				perf_evsel__group_desc(pos, buf, size);
+				evname = buf;
+			}
+		}
 
 		scrolled_window = gtk_scrolled_window_new(NULL, NULL);
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index baa26dd..94e7404 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -434,6 +434,31 @@ const char *perf_evsel__name(struct perf_evsel *evsel)
 	return evsel->name ?: "unknown";
 }
 
+const char *perf_evsel__group_name(struct perf_evsel *evsel)
+{
+	return evsel->group_name ?: "anon group";
+}
+
+int perf_evsel__group_desc(struct perf_evsel *evsel, char *buf, size_t size)
+{
+	int ret;
+	struct perf_evsel *pos;
+	const char *group_name = perf_evsel__group_name(evsel);
+
+	ret = scnprintf(buf, size, "%s", group_name);
+
+	ret += scnprintf(buf + ret, size - ret, " { %s",
+			 perf_evsel__name(evsel));
+
+	for_each_group_member(pos, evsel)
+		ret += scnprintf(buf + ret, size - ret, ", %s",
+				 perf_evsel__name(pos));
+
+	ret += scnprintf(buf + ret, size - ret, " }");
+
+	return ret;
+}
+
 /*
  * The enable_on_exec/disabled value strategy:
  *
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3717139..8512f6a 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -114,6 +114,8 @@ extern const char *perf_evsel__sw_names[PERF_COUNT_SW_MAX];
 int __perf_evsel__hw_cache_type_op_res_name(u8 type, u8 op, u8 result,
 					    char *bf, size_t size);
 const char *perf_evsel__name(struct perf_evsel *evsel);
+const char *perf_evsel__group_name(struct perf_evsel *evsel);
+int perf_evsel__group_desc(struct perf_evsel *evsel, char *buf, size_t size);
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads);
@@ -267,4 +269,10 @@ static inline int perf_evsel__group_idx(struct perf_evsel *evsel)
 {
 	return evsel->idx - evsel->leader->idx;
 }
+
+#define for_each_group_member(_evsel, _leader) 					\
+for ((_evsel) = list_entry((_leader)->node.next, struct perf_evsel, node); 	\
+     (_evsel) && (_evsel)->leader == (_leader);					\
+     (_evsel) = list_entry((_evsel)->node.next, struct perf_evsel, node))
+
 #endif /* __PERF_EVSEL_H */
