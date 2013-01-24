Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab3AXTJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:09:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33255 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab3AXTJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:09:00 -0500
Date: Thu, 24 Jan 2013 11:08:25 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-mktq5fy2h5z7jyeqvvf5mbc8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Adopt fprintf routine from '
 perf evlist'
Git-Commit-ID: 0698aeddcfe0c2514af1d012082665a3bb55d01b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 11:08:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0698aeddcfe0c2514af1d012082665a3bb55d01b
Gitweb:     http://git.kernel.org/tip/0698aeddcfe0c2514af1d012082665a3bb55d01b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 10 Dec 2012 18:17:08 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 11 Dec 2012 17:19:53 -0300

perf evsel: Adopt fprintf routine from 'perf evlist'

So that we can print all the details when debugging other tools,
when we have just evlists and evsels, not a perf.data file.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-mktq5fy2h5z7jyeqvvf5mbc8@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-evlist.c | 81 ++-------------------------------------------
 tools/perf/util/evsel.c     | 77 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evsel.h     |  8 +++++
 3 files changed, 87 insertions(+), 79 deletions(-)

diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index c20f1dc..1312a5e 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -15,39 +15,6 @@
 #include "util/parse-options.h"
 #include "util/session.h"
 
-struct perf_attr_details {
-	bool freq;
-	bool verbose;
-};
-
-static int comma_printf(bool *first, const char *fmt, ...)
-{
-	va_list args;
-	int ret = 0;
-
-	if (!*first) {
-		ret += printf(",");
-	} else {
-		ret += printf(":");
-		*first = false;
-	}
-
-	va_start(args, fmt);
-	ret += vprintf(fmt, args);
-	va_end(args);
-	return ret;
-}
-
-static int __if_print(bool *first, const char *field, u64 value)
-{
-	if (value == 0)
-		return 0;
-
-	return comma_printf(first, " %s: %" PRIu64, field, value);
-}
-
-#define if_print(field) __if_print(&first, #field, pos->attr.field)
-
 static int __cmd_evlist(const char *file_name, struct perf_attr_details *details)
 {
 	struct perf_session *session;
@@ -57,52 +24,8 @@ static int __cmd_evlist(const char *file_name, struct perf_attr_details *details
 	if (session == NULL)
 		return -ENOMEM;
 
-	list_for_each_entry(pos, &session->evlist->entries, node) {
-		bool first = true;
-
-		printf("%s", perf_evsel__name(pos));
-
-		if (details->verbose || details->freq) {
-			comma_printf(&first, " sample_freq=%" PRIu64,
-				     (u64)pos->attr.sample_freq);
-		}
-
-		if (details->verbose) {
-			if_print(type);
-			if_print(config);
-			if_print(config1);
-			if_print(config2);
-			if_print(size);
-			if_print(sample_type);
-			if_print(read_format);
-			if_print(disabled);
-			if_print(inherit);
-			if_print(pinned);
-			if_print(exclusive);
-			if_print(exclude_user);
-			if_print(exclude_kernel);
-			if_print(exclude_hv);
-			if_print(exclude_idle);
-			if_print(mmap);
-			if_print(comm);
-			if_print(freq);
-			if_print(inherit_stat);
-			if_print(enable_on_exec);
-			if_print(task);
-			if_print(watermark);
-			if_print(precise_ip);
-			if_print(mmap_data);
-			if_print(sample_id_all);
-			if_print(exclude_host);
-			if_print(exclude_guest);
-			if_print(__reserved_1);
-			if_print(wakeup_events);
-			if_print(bp_type);
-			if_print(branch_sample_type);
-		}
-
-		putchar('\n');
-	}
+	list_for_each_entry(pos, &session->evlist->entries, node)
+		perf_evsel__fprintf(pos, details, stdout);
 
 	perf_session__delete(session);
 	return 0;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 2492d32..643df4b 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1228,3 +1228,80 @@ u64 perf_evsel__intval(struct perf_evsel *evsel, struct perf_sample *sample,
 
 	return 0;
 }
+
+static int comma_fprintf(FILE *fp, bool *first, const char *fmt, ...)
+{
+	va_list args;
+	int ret = 0;
+
+	if (!*first) {
+		ret += fprintf(fp, ",");
+	} else {
+		ret += fprintf(fp, ":");
+		*first = false;
+	}
+
+	va_start(args, fmt);
+	ret += vfprintf(fp, fmt, args);
+	va_end(args);
+	return ret;
+}
+
+static int __if_fprintf(FILE *fp, bool *first, const char *field, u64 value)
+{
+	if (value == 0)
+		return 0;
+
+	return comma_fprintf(fp, first, " %s: %" PRIu64, field, value);
+}
+
+#define if_print(field) printed += __if_fprintf(fp, &first, #field, evsel->attr.field)
+
+int perf_evsel__fprintf(struct perf_evsel *evsel,
+			struct perf_attr_details *details, FILE *fp)
+{
+	bool first = true;
+	int printed = fprintf(fp, "%s", perf_evsel__name(evsel));
+
+	if (details->verbose || details->freq) {
+		printed += comma_fprintf(fp, &first, " sample_freq=%" PRIu64,
+					 (u64)evsel->attr.sample_freq);
+	}
+
+	if (details->verbose) {
+		if_print(type);
+		if_print(config);
+		if_print(config1);
+		if_print(config2);
+		if_print(size);
+		if_print(sample_type);
+		if_print(read_format);
+		if_print(disabled);
+		if_print(inherit);
+		if_print(pinned);
+		if_print(exclusive);
+		if_print(exclude_user);
+		if_print(exclude_kernel);
+		if_print(exclude_hv);
+		if_print(exclude_idle);
+		if_print(mmap);
+		if_print(comm);
+		if_print(freq);
+		if_print(inherit_stat);
+		if_print(enable_on_exec);
+		if_print(task);
+		if_print(watermark);
+		if_print(precise_ip);
+		if_print(mmap_data);
+		if_print(sample_id_all);
+		if_print(exclude_host);
+		if_print(exclude_guest);
+		if_print(__reserved_1);
+		if_print(wakeup_events);
+		if_print(bp_type);
+		if_print(branch_sample_type);
+	}
+
+	fputc('\n', fp);
+	return ++printed;
+}
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 5c08977..9cb8a02 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -243,4 +243,12 @@ static inline bool perf_evsel__is_group_leader(const struct perf_evsel *evsel)
 {
 	return evsel->leader == evsel;
 }
+
+struct perf_attr_details {
+	bool freq;
+	bool verbose;
+};
+
+int perf_evsel__fprintf(struct perf_evsel *evsel,
+			struct perf_attr_details *details, FILE *fp);
 #endif /* __PERF_EVSEL_H */
