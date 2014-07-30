Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbaG3XXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 19:23:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:2694 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbaG3XXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 19:23:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,768,1400050800"; 
   d="scan'208";a="551562545"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        mingo@kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 03/10] perf, tools, list: Update perf list to output descriptions
Date: Wed, 30 Jul 2014 16:22:43 -0700
Message-Id: <1406762570-16694-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406762570-16694-1-git-send-email-andi@firstfloor.org>
References: <1406762570-16694-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add support to perf list to print aliases with descriptions.
Support word wrapping for descriptions.
Fix up the sorting code to put aliases with descriptions
last.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/pmu.c | 84 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 68 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index f9c7046..baec090 100644
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
1.9.3

