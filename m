Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab3AZUEj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 15:04:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092Ab3AZUEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 15:04:35 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/8] perf tools: Change perf_pmu__new_alias function interface
Date: Sat, 26 Jan 2013 21:04:04 +0100
Message-Id: <1359230650-10415-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1359230650-10415-1-git-send-email-jolsa@redhat.com>
References: <1359230650-10415-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing perf_pmu__new_alias interface not to work directly with
FILE object, so it can be reused by other code paths coming in
shortly.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/pmu.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 4c6f9c4..f7852e9 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -95,23 +95,17 @@ static int pmu_format(char *name, struct list_head *format)
 	return 0;
 }
 
-static int perf_pmu__new_alias(struct list_head *list, char *name, FILE *file)
+static int perf_pmu__new_alias(struct list_head *list, char *name, char *data)
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
 
 	INIT_LIST_HEAD(&alias->terms);
-	ret = parse_events_terms(&alias->terms, buf);
+	ret = parse_events_terms(&alias->terms, data);
 	if (ret) {
 		free(alias);
 		return ret;
@@ -137,7 +131,7 @@ static int pmu_aliases_parse(char *dir, struct list_head *head)
 		return -EINVAL;
 
 	while (!ret && (evt_ent = readdir(event_dir))) {
-		char path[PATH_MAX];
+		char path[PATH_MAX], buf[256];
 		char *name = evt_ent->d_name;
 		FILE *file;
 
@@ -150,7 +144,16 @@ static int pmu_aliases_parse(char *dir, struct list_head *head)
 		file = fopen(path, "r");
 		if (!file)
 			break;
-		ret = perf_pmu__new_alias(head, name, file);
+
+		ret = fread(buf, 1, sizeof(buf), file);
+		if (ret == 0) {
+			ret = -EINVAL;
+			break;
+		}
+
+		buf[ret] = 0;
+
+		ret = perf_pmu__new_alias(head, name, buf);
 		fclose(file);
 	}
 
-- 
1.7.11.7

