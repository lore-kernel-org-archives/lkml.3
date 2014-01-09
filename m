Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbaAIJWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 04:22:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53425 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbaAIJWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 04:22:10 -0500
X-IronPort-AV: E=Sophos;i="4.95,630,1384272000"; 
   d="scan'208";a="9395603"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, acme@redhat.com
Cc: dsahern@gmail.com, artagnon@gmail.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/7] perf tools: Make the all print_xxx_event functions to return unsigned int.
Date: Thu, 9 Jan 2014 17:19:51 -0500
Message-Id: <e0f3f44a8a190772200b225ba7ac82e8b88efb23.1389305623.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1389305623.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1389305623.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/09 17:21:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/09 17:21:03,
	Serialize complete at 2014/01/09 17:21:03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the most of print_XXX_event() functions are returning void. Then we can
not know whether the printing work is completed well.

This patch change the return type to unsigned int, it means the count of events we
have printed in print_XXX_event() function.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/util/parse-events.c | 76 ++++++++++++++++++++++++------------------
 tools/perf/util/parse-events.h |  8 ++---
 tools/perf/util/pmu.c          | 12 ++++---
 tools/perf/util/pmu.h          |  2 +-
 4 files changed, 56 insertions(+), 42 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 0153435..e2a2066 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1000,22 +1000,23 @@ static const char * const event_type_descriptors[] = {
  * Print the events from <debugfs_mount_point>/tracing/events
  */
 
-void print_tracepoint_events(const char *subsys_glob, const char *event_glob,
-			     bool name_only)
+unsigned int print_tracepoint_events(const char *subsys_glob, const char *event_glob,
+			             bool name_only)
 {
 	DIR *sys_dir, *evt_dir;
 	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
 	char evt_path[MAXPATHLEN];
 	char dir_path[MAXPATHLEN];
+	unsigned int count = 0;
 
 	if (debugfs_valid_mountpoint(tracing_events_path)) {
 		printf("  [ Tracepoints not available: %s ]\n", strerror(errno));
-		return;
+		return count;
 	}
 
 	sys_dir = opendir(tracing_events_path);
 	if (!sys_dir)
-		return;
+		return count;
 
 	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
 		if (subsys_glob != NULL && 
@@ -1035,6 +1036,7 @@ void print_tracepoint_events(const char *subsys_glob, const char *event_glob,
 
 			if (name_only) {
 				printf("%s:%s ", sys_dirent.d_name, evt_dirent.d_name);
+				count++;
 				continue;
 			}
 
@@ -1042,10 +1044,13 @@ void print_tracepoint_events(const char *subsys_glob, const char *event_glob,
 				 sys_dirent.d_name, evt_dirent.d_name);
 			printf("  %-50s [%s]\n", evt_path,
 				event_type_descriptors[PERF_TYPE_TRACEPOINT]);
+			count++;
 		}
 		closedir(evt_dir);
 	}
 	closedir(sys_dir);
+
+	return count;
 }
 
 /*
@@ -1116,11 +1121,12 @@ static bool is_event_supported(u8 type, unsigned config)
 	return ret;
 }
 
-static void __print_events_type(u8 type, struct event_symbol *syms,
-				unsigned max)
+static unsigned int __print_events_type(u8 type, struct event_symbol *syms,
+					unsigned max)
 {
 	char name[64];
 	unsigned i;
+	unsigned int count = 0;
 
 	for (i = 0; i < max ; i++, syms++) {
 		if (!is_event_supported(type, i))
@@ -1133,20 +1139,23 @@ static void __print_events_type(u8 type, struct event_symbol *syms,
 			snprintf(name, sizeof(name), "%s", syms->symbol);
 
 		printf("  %-50s [%s]\n", name, event_type_descriptors[type]);
+		count++;
 	}
+
+	return count;
 }
 
-void print_events_type(u8 type)
+unsigned int print_events_type(u8 type)
 {
 	if (type == PERF_TYPE_SOFTWARE)
-		__print_events_type(type, event_symbols_sw, PERF_COUNT_SW_MAX);
+		return __print_events_type(type, event_symbols_sw, PERF_COUNT_SW_MAX);
 	else
-		__print_events_type(type, event_symbols_hw, PERF_COUNT_HW_MAX);
+		return __print_events_type(type, event_symbols_hw, PERF_COUNT_HW_MAX);
 }
 
-int print_hwcache_events(const char *event_glob, bool name_only)
+unsigned int print_hwcache_events(const char *event_glob, bool name_only)
 {
-	unsigned int type, op, i, printed = 0;
+	unsigned int type, op, i, count = 0;
 	char name[64];
 
 	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
@@ -1170,21 +1179,22 @@ int print_hwcache_events(const char *event_glob, bool name_only)
 				else
 					printf("  %-50s [%s]\n", name,
 					       event_type_descriptors[PERF_TYPE_HW_CACHE]);
-				++printed;
+				count++;
 			}
 		}
 	}
 
-	if (printed)
+	if (count)
 		printf("\n");
-	return printed;
+	return count;
 }
 
-static void print_symbol_events(const char *event_glob, unsigned type,
-				struct event_symbol *syms, unsigned max,
-				bool name_only)
+static unsigned print_symbol_events(const char *event_glob, unsigned type,
+				    struct event_symbol *syms, unsigned max,
+				    bool name_only)
 {
-	unsigned i, printed = 0;
+	unsigned i;
+	unsigned int count = 0;
 	char name[MAX_NAME_LEN];
 
 	for (i = 0; i < max; i++, syms++) {
@@ -1199,6 +1209,7 @@ static void print_symbol_events(const char *event_glob, unsigned type,
 
 		if (name_only) {
 			printf("%s ", syms->symbol);
+			count++;
 			continue;
 		}
 
@@ -1209,35 +1220,35 @@ static void print_symbol_events(const char *event_glob, unsigned type,
 
 		printf("  %-50s [%s]\n", name, event_type_descriptors[type]);
 
-		printed++;
+		count++;
 	}
 
-	if (printed)
+	if (count)
 		printf("\n");
+	return count;
 }
 
 /*
  * Print the help text for the event symbols:
  */
-void print_events(const char *event_glob, bool name_only)
+unsigned int print_events(const char *event_glob, bool name_only)
 {
-	if (!name_only) {
-		printf("\n");
-		printf("List of pre-defined events (to be used in -e):\n");
-	}
+	unsigned int count = 0;
 
-	print_symbol_events(event_glob, PERF_TYPE_HARDWARE,
-			    event_symbols_hw, PERF_COUNT_HW_MAX, name_only);
+	count += print_symbol_events(event_glob, PERF_TYPE_HARDWARE,
+				     event_symbols_hw, PERF_COUNT_HW_MAX,
+				     name_only);
 
-	print_symbol_events(event_glob, PERF_TYPE_SOFTWARE,
-			    event_symbols_sw, PERF_COUNT_SW_MAX, name_only);
+	count += print_symbol_events(event_glob, PERF_TYPE_SOFTWARE,
+				     event_symbols_sw, PERF_COUNT_SW_MAX,
+				     name_only);
 
-	print_hwcache_events(event_glob, name_only);
+	count += print_hwcache_events(event_glob, name_only);
 
-	print_pmu_events(event_glob, name_only);
+	count += print_pmu_events(event_glob, name_only);
 
 	if (event_glob != NULL)
-		return;
+		return count;
 
 	if (!name_only) {
 		printf("  %-50s [%s]\n",
@@ -1256,6 +1267,7 @@ void print_events(const char *event_glob, bool name_only)
 	}
 
 	print_tracepoint_events(NULL, NULL, name_only);
+	return count;
 }
 
 int parse_events__is_hardcoded_term(struct parse_events_term *term)
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index f1cb4c4..bb7d674 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -101,11 +101,11 @@ void parse_events_update_lists(struct list_head *list_event,
 			       struct list_head *list_all);
 void parse_events_error(void *data, void *scanner, char const *msg);
 
-void print_events(const char *event_glob, bool name_only);
-void print_events_type(u8 type);
-void print_tracepoint_events(const char *subsys_glob, const char *event_glob,
+unsigned int print_events(const char *event_glob, bool name_only);
+unsigned int print_events_type(u8 type);
+unsigned int print_tracepoint_events(const char *subsys_glob, const char *event_glob,
 			     bool name_only);
-int print_hwcache_events(const char *event_glob, bool name_only);
+unsigned int print_hwcache_events(const char *event_glob, bool name_only);
 extern int is_valid_tracepoint(const char *event_string);
 
 extern int valid_debugfs_mount(const char *debugfs);
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

