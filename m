Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab3L0KG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 05:06:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:8856 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754215Ab3L0KFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 05:05:47 -0500
X-IronPort-AV: E=Sophos;i="4.95,559,1384272000"; 
   d="scan'208";a="9336935"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@redhat.com, mingo@kernel.org, dsahern@gmail.com,
        linux-kernel@vger.kernel.org
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 3/8] perf tools: Make the print_pmu_events funtion to return unsigned int.
Date: Fri, 27 Dec 2013 18:03:29 -0500
Message-Id: <733f85fa9e9c3308dccaec38b583b992df6c4414.1388184724.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1388184724.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1388184724.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/27 18:04:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/27 18:04:53,
	Serialize complete at 2013/12/27 18:04:53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes we need to know how many events have been printed in print_pmu_events.

This patch make this function to return the number of events we have printed.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/util/pmu.c | 20 ++++++++++----------
 tools/perf/util/pmu.h |  2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 56fc10a..99b3a64 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -711,12 +711,12 @@ static int cmp_string(const void *a, const void *b)
 	return strcmp(*as, *bs);
 }
 
-void print_pmu_events(const char *event_glob, bool name_only)
+unsigned int print_pmu_events(const char *event_glob, bool name_only)
 {
 	struct perf_pmu *pmu;
 	struct perf_pmu_alias *alias;
 	char buf[1024];
-	int printed = 0;
+	unsigned int count = 0;
 	int len, j;
 	char **aliases;
 
@@ -727,7 +727,7 @@ void print_pmu_events(const char *event_glob, bool name_only)
 			len++;
 	aliases = malloc(sizeof(char *) * len);
 	if (!aliases)
-		return;
+		return count;
 	pmu = NULL;
 	j = 0;
 	while ((pmu = perf_pmu__scan(pmu)) != NULL)
@@ -750,17 +750,17 @@ void print_pmu_events(const char *event_glob, bool name_only)
 	len = j;
 	qsort(aliases, len, sizeof(char *), cmp_string);
 	for (j = 0; j < len; j++) {
-		if (name_only) {
-			printf("%s ", aliases[j]);
-			continue;
-		}
-		printf("  %-50s [Kernel PMU event]\n", aliases[j]);
+		if (name_only)
+			printf("%s\n", aliases[j]);
+		else
+			printf("  %-50s [Kernel PMU event]\n", aliases[j]);
 		free(aliases[j]);
-		printed++;
+		count++;
 	}
-	if (printed)
+	if (count)
 		printf("\n");
 	free(aliases);
+	return count;
 }
 
 bool pmu_have_event(const char *pname, const char *name)
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 9183380..2987fe2 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -42,7 +42,7 @@ int perf_pmu__format_parse(char *dir, struct list_head *head);
 
 struct perf_pmu *perf_pmu__scan(struct perf_pmu *pmu);
 
-void print_pmu_events(const char *event_glob, bool name_only);
+unsigned int print_pmu_events(const char *event_glob, bool name_only);
 bool pmu_have_event(const char *pname, const char *name);
 
 int perf_pmu__test(void);
-- 
1.8.2.1

