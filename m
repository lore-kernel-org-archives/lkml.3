Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161180AbaDPSua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:50:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:33971 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323AbaDPSuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:50:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,873,1389772800"; 
   d="scan'208";a="494327694"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: acme@infradead.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 02/10] perf, tools: Add support for text descriptions of events and alias add
Date: Wed, 16 Apr 2014 11:49:24 -0700
Message-Id: <1397674172-30959-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1397674172-30959-1-git-send-email-andi@firstfloor.org>
References: <1397674172-30959-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Change pmu.c to allow descriptions of events and add interfaces
to add aliases. Used in the next patch.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/pmu.c | 79 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 54 insertions(+), 25 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 00a7dcb..cc888d9 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -14,6 +14,7 @@
 
 struct perf_pmu_alias {
 	char *name;
+	char *desc;
 	struct list_head terms;
 	struct list_head list;
 	char unit[UNIT_MAX_LEN+1];
@@ -171,17 +172,12 @@ error:
 	return -1;
 }
 
-static int perf_pmu__new_alias(struct list_head *list, char *dir, char *name, FILE *file)
+static int __perf_pmu__new_alias(struct list_head *list, char *name,
+				 char *dir, char *desc, char *val)
 {
 	struct perf_pmu_alias *alias;
-	char buf[256];
 	int ret;
 
-	ret = fread(buf, 1, sizeof(buf), file);
-	if (ret == 0)
-		return -EINVAL;
-	buf[ret] = 0;
-
 	alias = malloc(sizeof(*alias));
 	if (!alias)
 		return -ENOMEM;
@@ -190,24 +186,45 @@ static int perf_pmu__new_alias(struct list_head *list, char *dir, char *name, FI
 	alias->scale = 1.0;
 	alias->unit[0] = '\0';
 
-	ret = parse_events_terms(&alias->terms, buf);
+	ret = parse_events_terms(&alias->terms, val);
 	if (ret) {
+		pr_err("Cannot parse alias %s: %d\n", val, ret);
 		free(alias);
 		return ret;
 	}
 
 	alias->name = strdup(name);
-	/*
-	 * load unit name and scale if available
-	 */
-	perf_pmu__parse_unit(alias, dir, name);
-	perf_pmu__parse_scale(alias, dir, name);
 
+	if (dir) {
+		/*
+		 * load unit name and scale if available
+		 */
+		perf_pmu__parse_unit(alias, dir, name);
+		perf_pmu__parse_scale(alias, dir, name);
+	}
+
+	alias->desc = desc ? strdup(desc) : NULL;
 	list_add_tail(&alias->list, list);
 
 	return 0;
 }
 
+static int perf_pmu__new_alias(struct list_head *list,
+			       char *dir,
+			       char *name,
+			       FILE *file)
+{
+	char buf[256];
+	int ret;
+
+	ret = fread(buf, 1, sizeof(buf), file);
+	if (ret == 0)
+		return -EINVAL;
+	buf[ret] = 0;
+
+	return __perf_pmu__new_alias(list, name, dir, NULL, buf);
+}
+
 /*
  * Process all the sysfs attributes located under the directory
  * specified in 'dir' parameter.
@@ -734,21 +751,24 @@ void print_pmu_events(const char *event_glob, bool name_only)
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
@@ -756,22 +776,31 @@ void print_pmu_events(const char *event_glob, bool name_only)
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
1.8.5.3

