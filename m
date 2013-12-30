Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab3L3CfB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 21:35:01 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59652 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753119Ab3L3CfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 21:35:00 -0500
X-IronPort-AV: E=Sophos;i="4.95,571,1384272000"; 
   d="scan'208";a="9348171"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, acme@redhat.com
Cc: mingo@kernel.org, dsahern@gmail.com, artagnon@gmail.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/8] perf tools: Make the print_pmu_events funtion to return unsigned int.
Date: Mon, 30 Dec 2013 10:26:37 -0500
Message-Id: <52353637cf8005cef5f3eaa605121426ef49f557.1388416837.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1388416837.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1388416837.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/30 10:27:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/30 10:27:58,
	Serialize complete at 2013/12/30 10:27:58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes we need to know how many events have been printed in print_pmu_events.

This patch make this function to return the number of events we have printed.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/util/pmu.c | 12 +++++++-----
 tools/perf/util/pmu.h |  2 +-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 0934d64..331dc2c 100644
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
@@ -752,15 +752,17 @@ void print_pmu_events(const char *event_glob, bool name_only)
 	for (j = 0; j < len; j++) {
 		if (name_only) {
 			printf("%s ", aliases[j]);
+			count++;
 			continue;
 		}
 		printf("  %-50s [Kernel PMU event]\n", aliases[j]);
 		zfree(&aliases[j]);
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

