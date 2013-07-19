Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966015Ab3GSH60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:58:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35671 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965887Ab3GSHuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:50:44 -0400
Date: Fri, 19 Jul 2013 00:50:32 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-dc098b35b56f83ae088e4291a4e389a6ff126965@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1366480949-32292-2-git-send-email-andi@firstfloor.org>
References: <1366480949-32292-2-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf list: List kernel supplied event aliases
Git-Commit-ID: dc098b35b56f83ae088e4291a4e389a6ff126965
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:50:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc098b35b56f83ae088e4291a4e389a6ff126965
Gitweb:     http://git.kernel.org/tip/dc098b35b56f83ae088e4291a4e389a6ff126965
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 20 Apr 2013 11:02:29 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:53:53 -0300

perf list: List kernel supplied event aliases

List the kernel supplied pmu event aliases in perf list

It's better when the users can actually see them.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1366480949-32292-2-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-list.txt |  4 +-
 tools/perf/builtin-list.c              |  3 ++
 tools/perf/util/parse-events.c         |  5 ++-
 tools/perf/util/pmu.c                  | 73 ++++++++++++++++++++++++++++++++++
 tools/perf/util/pmu.h                  |  3 ++
 5 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index d1e39dc..826f3d6 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -8,7 +8,7 @@ perf-list - List all symbolic event types
 SYNOPSIS
 --------
 [verse]
-'perf list' [hw|sw|cache|tracepoint|event_glob]
+'perf list' [hw|sw|cache|tracepoint|pmu|event_glob]
 
 DESCRIPTION
 -----------
@@ -104,6 +104,8 @@ To limit the list use:
   'subsys_glob:event_glob' to filter by tracepoint subsystems such as sched,
   block, etc.
 
+. 'pmu' to print the kernel supplied PMU events.
+
 . If none of the above is matched, it will apply the supplied glob to all
   events, printing the ones that match.
 
diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 1948ece..e79f423 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -13,6 +13,7 @@
 
 #include "util/parse-events.h"
 #include "util/cache.h"
+#include "util/pmu.h"
 
 int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 {
@@ -37,6 +38,8 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 			else if (strcmp(argv[i], "cache") == 0 ||
 				 strcmp(argv[i], "hwcache") == 0)
 				print_hwcache_events(NULL, false);
+			else if (strcmp(argv[i], "pmu") == 0)
+				print_pmu_events(NULL, false);
 			else if (strcmp(argv[i], "--raw-dump") == 0)
 				print_events(NULL, true);
 			else {
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index a5076f4..2c460ed 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1110,6 +1110,8 @@ int print_hwcache_events(const char *event_glob, bool name_only)
 		}
 	}
 
+	if (printed)
+		printf("\n");
 	return printed;
 }
 
@@ -1164,11 +1166,12 @@ void print_events(const char *event_glob, bool name_only)
 
 	print_hwcache_events(event_glob, name_only);
 
+	print_pmu_events(event_glob, name_only);
+
 	if (event_glob != NULL)
 		return;
 
 	if (!name_only) {
-		printf("\n");
 		printf("  %-50s [%s]\n",
 		       "rNNN",
 		       event_type_descriptors[PERF_TYPE_RAW]);
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 1d1862d..bc9d806 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -564,3 +564,76 @@ void perf_pmu__set_format(unsigned long *bits, long from, long to)
 	for (b = from; b <= to; b++)
 		set_bit(b, bits);
 }
+
+static char *format_alias(char *buf, int len, struct perf_pmu *pmu,
+			  struct perf_pmu_alias *alias)
+{
+	snprintf(buf, len, "%s/%s/", pmu->name, alias->name);
+	return buf;
+}
+
+static char *format_alias_or(char *buf, int len, struct perf_pmu *pmu,
+			     struct perf_pmu_alias *alias)
+{
+	snprintf(buf, len, "%s OR %s/%s/", alias->name, pmu->name, alias->name);
+	return buf;
+}
+
+static int cmp_string(const void *a, const void *b)
+{
+	const char * const *as = a;
+	const char * const *bs = b;
+	return strcmp(*as, *bs);
+}
+
+void print_pmu_events(const char *event_glob, bool name_only)
+{
+	struct perf_pmu *pmu;
+	struct perf_pmu_alias *alias;
+	char buf[1024];
+	int printed = 0;
+	int len, j;
+	char **aliases;
+
+	pmu = NULL;
+	len = 0;
+	while ((pmu = perf_pmu__scan(pmu)) != NULL)
+		list_for_each_entry(alias, &pmu->aliases, list)
+			len++;
+	aliases = malloc(sizeof(char *) * len);
+	if (!aliases)
+		return;
+	pmu = NULL;
+	j = 0;
+	while ((pmu = perf_pmu__scan(pmu)) != NULL)
+		list_for_each_entry(alias, &pmu->aliases, list) {
+			char *name = format_alias(buf, sizeof(buf), pmu, alias);
+			bool is_cpu = !strcmp(pmu->name, "cpu");
+
+			if (event_glob != NULL &&
+			    !(strglobmatch(name, event_glob) ||
+			      (!is_cpu && strglobmatch(alias->name,
+						       event_glob))))
+				continue;
+			aliases[j] = name;
+			if (is_cpu && !name_only)
+				aliases[j] = format_alias_or(buf, sizeof(buf),
+							      pmu, alias);
+			aliases[j] = strdup(aliases[j]);
+			j++;
+		}
+	len = j;
+	qsort(aliases, len, sizeof(char *), cmp_string);
+	for (j = 0; j < len; j++) {
+		if (name_only) {
+			printf("%s ", aliases[j]);
+			continue;
+		}
+		printf("  %-50s [Kernel PMU event]\n", aliases[j]);
+		free(aliases[j]);
+		printed++;
+	}
+	if (printed)
+		printf("\n");
+	free(aliases);
+}
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index d17b565..6b2cbe2 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -3,6 +3,7 @@
 
 #include <linux/bitops.h>
 #include <linux/perf_event.h>
+#include <stdbool.h>
 
 enum {
 	PERF_PMU_FORMAT_VALUE_CONFIG,
@@ -40,5 +41,7 @@ int perf_pmu__format_parse(char *dir, struct list_head *head);
 
 struct perf_pmu *perf_pmu__scan(struct perf_pmu *pmu);
 
+void print_pmu_events(const char *event_glob, bool name_only);
+
 int perf_pmu__test(void);
 #endif /* __PMU_H */
