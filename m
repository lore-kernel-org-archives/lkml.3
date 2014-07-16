Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaGPUFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:05:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbaGPUDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:03:08 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 05/13] perf tools: Update perf list to output descriptions
Date: Wed, 16 Jul 2014 22:02:41 +0200
Message-Id: <1405540969-18975-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
References: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add support to perf list to print aliases with descriptions.
Support word wrapping for descriptions.
Fix up the sorting code to put aliases with descriptions
last.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/n/1405123165-22666-4-git-send-email-andi@firstfloor.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/pmu.c | 84 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 68 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index f9c704628218..baec0905eef8 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -737,11 +737,51 @@ static char *format_alias_or(char *buf, int len, struct perf_pmu *pmu,
 	return buf;
 }
 
-static int cmp_string(const void *a, const void *b)
+struct pair {
+	char *name;
+	char *desc;
+};
+
+static int cmp_pair(const void *a, const void *b)
+{
+	const struct pair *as = a;
+	const struct pair *bs = b;
+
+	/* Put downloaded event list last */
+	if (!!as->desc != !!bs->desc)
+		return !!as->desc - !!bs->desc;
+	return strcmp(as->name, bs->name);
+}
+
+static void wordwrap(char *s, int start, int max, int corr)
+{
+	int column = start;
+	int n;
+
+	while (*s) {
+		int wlen = strcspn(s, " \t");
+
+		if (column + wlen >= max && column > start) {
+			printf("\n%*s", start, "");
+			column = start + corr;
+		}
+		n = printf("%s%.*s", column > start ? " " : "", wlen, s);
+		if (n <= 0)
+			break;
+		s += wlen;
+		column += n;
+		while (isspace(*s))
+			s++;
+	}
+}
+
+static int get_columns(void)
 {
-	const char * const *as = a;
-	const char * const *bs = b;
-	return strcmp(*as, *bs);
+	/*
+	 * Should ask the terminal with TIOCGWINSZ here, but we
+	 * need the original fd before the pager.
+	 */
+	return 79;
 }
 
 void print_pmu_events(const char *event_glob, bool name_only)
@@ -751,21 +791,24 @@ void print_pmu_events(const char *event_glob, bool name_only)
 	char buf[1024];
 	int printed = 0;
 	int len, j;
-	char **aliases;
+	struct pair *aliases;
+	int numdesc = 0;
+	int columns = get_columns();
 
 	pmu = NULL;
 	len = 0;
 	while ((pmu = perf_pmu__scan(pmu)) != NULL)
 		list_for_each_entry(alias, &pmu->aliases, list)
 			len++;
-	aliases = malloc(sizeof(char *) * len);
+	aliases = malloc(sizeof(struct pair) * len);
 	if (!aliases)
 		return;
 	pmu = NULL;
 	j = 0;
 	while ((pmu = perf_pmu__scan(pmu)) != NULL)
 		list_for_each_entry(alias, &pmu->aliases, list) {
-			char *name = format_alias(buf, sizeof(buf), pmu, alias);
+			char *name = alias->desc ? alias->name :
+				format_alias(buf, sizeof(buf), pmu, alias);
 			bool is_cpu = !strcmp(pmu->name, "cpu");
 
 			if (event_glob != NULL &&
@@ -773,22 +816,31 @@ void print_pmu_events(const char *event_glob, bool name_only)
 			      (!is_cpu && strglobmatch(alias->name,
 						       event_glob))))
 				continue;
-			aliases[j] = name;
-			if (is_cpu && !name_only)
-				aliases[j] = format_alias_or(buf, sizeof(buf),
-							      pmu, alias);
-			aliases[j] = strdup(aliases[j]);
+			aliases[j].name = name;
+			if (is_cpu && !name_only && !alias->desc)
+				aliases[j].name = format_alias_or(buf,
+								  sizeof(buf),
+								  pmu, alias);
+			aliases[j].name = strdup(aliases[j].name);
+			aliases[j].desc = alias->desc;
 			j++;
 		}
 	len = j;
-	qsort(aliases, len, sizeof(char *), cmp_string);
+	qsort(aliases, len, sizeof(struct pair), cmp_pair);
 	for (j = 0; j < len; j++) {
 		if (name_only) {
-			printf("%s ", aliases[j]);
+			printf("%s ", aliases[j].name);
 			continue;
 		}
-		printf("  %-50s [Kernel PMU event]\n", aliases[j]);
-		zfree(&aliases[j]);
+		if (aliases[j].desc) {
+			if (numdesc++ == 0 && printed)
+				printf("\n");
+			printf("  %-50s [", aliases[j].name);
+			wordwrap(aliases[j].desc, 53, columns, 1);
+			printf("]\n");
+		} else
+			printf("  %-50s [Kernel PMU event]\n", aliases[j].name);
+		zfree(&aliases[j].name);
 		printed++;
 	}
 	if (printed)
-- 
1.8.3.1

