Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaGPUGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:06:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbaGPUDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:03:07 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 04/13] perf tools: Add support for text descriptions of events and alias add
Date: Wed, 16 Jul 2014 22:02:40 +0200
Message-Id: <1405540969-18975-5-git-send-email-jolsa@kernel.org>
In-Reply-To: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
References: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Change pmu.c to allow descriptions of events and add interfaces
to add aliases at runtime from another file. To be used by jevents in
a followon patch

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/n/1405123165-22666-3-git-send-email-andi@firstfloor.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/pmu.c | 43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 7a811eb61f75..f9c704628218 100644
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
-- 
1.8.3.1

