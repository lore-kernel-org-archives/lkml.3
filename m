Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab3LPDJR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 22:09:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:44388 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab3LPDJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 22:09:15 -0500
X-IronPort-AV: E=Sophos;i="4.95,492,1384272000"; 
   d="scan'208,223";a="9265791"
Message-ID: <52AF2537.1030007@cn.fujitsu.com>
Date: Mon, 16 Dec 2013 11:07:19 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf list: fix --raw-dump
References: <1386756980-23121-1-git-send-email-artagnon@gmail.com> <52A8D2DA.7050409@gmail.com> <CALkWK0ksAB1xkaCR5jxaN-4n1KL3yQACp_62=ijmFZjj8KNuew@mail.gmail.com>
In-Reply-To: <CALkWK0ksAB1xkaCR5jxaN-4n1KL3yQACp_62=ijmFZjj8KNuew@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/16 11:08:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/16 11:08:48,
	Serialize complete at 2013/12/16 11:08:48
Content-Type: multipart/mixed;
 boundary="------------040602070800020008040208"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040602070800020008040208
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

On 12/12/2013 02:34 AM, Ramkumar Ramachandra wrote:
> David Ahern wrote:
>> Why not make raw_dump a proper argument?
> Sure, that'd work too. I was thinking of a minimal way to fix the
> problem myself.

Hi Ramkumar and David,
     If this argument is only used for perf complement, how about make 
it hidden to user? Please refer https://lkml.org/lkml/2013/12/12/52 and 
https://lkml.org/lkml/2013/12/12/53 The two patches make --raw-dump used 
internally but hidden in output of '-h'.

     If you think we should expose it to user, I think we should make it 
work as an option rather than an argument, and make the output of it 
more readable,
how about the patch attached in this mail?

Example:
     # ./perf list cache --raw-dump
     L1-dcache-loads
     L1-dcache-load-misses
     L1-dcache-stores
     L1-dcache-store-misses
     L1-dcache-prefetch-misses
     L1-icache-load-misses
     LLC-loads
     LLC-stores
     LLC-prefetches
     dTLB-loads
     dTLB-load-misses
     dTLB-stores
     dTLB-store-misses
     iTLB-loads
     iTLB-load-misses
     branch-loads
     branch-load-misses




--------------040602070800020008040208
Content-Transfer-Encoding: 7bit
Content-Type: text/x-patch;
 name="0001-perf-list-Fix-raw-dump-arg.patch"
Content-Disposition: attachment;
 filename="0001-perf-list-Fix-raw-dump-arg.patch"

>From 7bd20eb147783e0c1e659b3bceeebb75aad8436c Mon Sep 17 00:00:00 2001
From: David Ahern <dsahern@gmail.com>
Date: Wed, 11 Dec 2013 14:00:20 -0700
Subject: [PATCH] perf list: Fix raw-dump arg

Ramkumar reported that perf list --raw-dump was broken by 44d742e.
Fix by making raw-dump a proper option.

Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-list.c      | 23 +++++++++++------------
 tools/perf/util/parse-events.c | 19 +++++++++++--------
 tools/perf/util/parse-events.h |  2 +-
 tools/perf/util/pmu.c          |  2 +-
 4 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 011195e..9cf12f2 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -19,7 +19,9 @@
 int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int i;
+	bool raw_dump = false;
 	const struct option list_options[] = {
+		OPT_BOOLEAN(0, "raw-dump", &raw_dump, "raw dump for completion"),
 		OPT_END()
 	};
 	const char * const list_usage[] = {
@@ -27,13 +29,12 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 		NULL
 	};
 
-	argc = parse_options(argc, argv, list_options, list_usage,
-			     PARSE_OPT_STOP_AT_NON_OPTION);
+	argc = parse_options(argc, argv, list_options, list_usage, 0);
 
 	setup_pager();
 
 	if (argc == 0) {
-		print_events(NULL, false);
+		print_events(NULL, raw_dump);
 		return 0;
 	}
 
@@ -41,26 +42,24 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 		if (i)
 			putchar('\n');
 		if (strncmp(argv[i], "tracepoint", 10) == 0)
-			print_tracepoint_events(NULL, NULL, false);
+			print_tracepoint_events(NULL, NULL, raw_dump);
 		else if (strcmp(argv[i], "hw") == 0 ||
 			 strcmp(argv[i], "hardware") == 0)
-			print_events_type(PERF_TYPE_HARDWARE);
+			print_events_type(PERF_TYPE_HARDWARE, raw_dump);
 		else if (strcmp(argv[i], "sw") == 0 ||
 			 strcmp(argv[i], "software") == 0)
-			print_events_type(PERF_TYPE_SOFTWARE);
+			print_events_type(PERF_TYPE_SOFTWARE, raw_dump);
 		else if (strcmp(argv[i], "cache") == 0 ||
 			 strcmp(argv[i], "hwcache") == 0)
-			print_hwcache_events(NULL, false);
+			print_hwcache_events(NULL, raw_dump);
 		else if (strcmp(argv[i], "pmu") == 0)
-			print_pmu_events(NULL, false);
-		else if (strcmp(argv[i], "--raw-dump") == 0)
-			print_events(NULL, true);
+			print_pmu_events(NULL, raw_dump);
 		else {
 			char *sep = strchr(argv[i], ':'), *s;
 			int sep_idx;
 
 			if (sep == NULL) {
-				print_events(argv[i], false);
+				print_events(argv[i], raw_dump);
 				continue;
 			}
 			sep_idx = sep - argv[i];
@@ -69,7 +68,7 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 				return -1;
 
 			s[sep_idx] = '\0';
-			print_tracepoint_events(s, s + sep_idx + 1, false);
+			print_tracepoint_events(s, s + sep_idx + 1, raw_dump);
 			free(s);
 		}
 	}
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 969cb8f..ded4a4e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1034,7 +1034,7 @@ void print_tracepoint_events(const char *subsys_glob, const char *event_glob,
 				continue;
 
 			if (name_only) {
-				printf("%s:%s ", sys_dirent.d_name, evt_dirent.d_name);
+				printf("%s:%s\n", sys_dirent.d_name, evt_dirent.d_name);
 				continue;
 			}
 
@@ -1117,7 +1117,7 @@ static bool is_event_supported(u8 type, unsigned config)
 }
 
 static void __print_events_type(u8 type, struct event_symbol *syms,
-				unsigned max)
+				unsigned max, bool name_only)
 {
 	char name[64];
 	unsigned i;
@@ -1132,16 +1132,19 @@ static void __print_events_type(u8 type, struct event_symbol *syms,
 		else
 			snprintf(name, sizeof(name), "%s", syms->symbol);
 
-		printf("  %-50s [%s]\n", name, event_type_descriptors[type]);
+		if (name_only)
+            printf("  %-50s\n", name);
+        else
+            printf("  %-50s [%s]\n", name, event_type_descriptors[type]);
 	}
 }
 
-void print_events_type(u8 type)
+void print_events_type(u8 type, bool name_only)
 {
 	if (type == PERF_TYPE_SOFTWARE)
-		__print_events_type(type, event_symbols_sw, PERF_COUNT_SW_MAX);
+		__print_events_type(type, event_symbols_sw, PERF_COUNT_SW_MAX, name_only);
 	else
-		__print_events_type(type, event_symbols_hw, PERF_COUNT_HW_MAX);
+		__print_events_type(type, event_symbols_hw, PERF_COUNT_HW_MAX, name_only);
 }
 
 int print_hwcache_events(const char *event_glob, bool name_only)
@@ -1166,7 +1169,7 @@ int print_hwcache_events(const char *event_glob, bool name_only)
 					continue;
 
 				if (name_only)
-					printf("%s ", name);
+					printf("%s\n", name);
 				else
 					printf("  %-50s [%s]\n", name,
 					       event_type_descriptors[PERF_TYPE_HW_CACHE]);
@@ -1198,7 +1201,7 @@ static void print_symbol_events(const char *event_glob, unsigned type,
 			continue;
 
 		if (name_only) {
-			printf("%s ", syms->symbol);
+			printf("%s\n", syms->symbol);
 			continue;
 		}
 
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index f1cb4c4..8f991e2 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -102,7 +102,7 @@ void parse_events_update_lists(struct list_head *list_event,
 void parse_events_error(void *data, void *scanner, char const *msg);
 
 void print_events(const char *event_glob, bool name_only);
-void print_events_type(u8 type);
+void print_events_type(u8 type, bool name_only);
 void print_tracepoint_events(const char *subsys_glob, const char *event_glob,
 			     bool name_only);
 int print_hwcache_events(const char *event_glob, bool name_only);
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 56fc10a..1c57356 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -751,7 +751,7 @@ void print_pmu_events(const char *event_glob, bool name_only)
 	qsort(aliases, len, sizeof(char *), cmp_string);
 	for (j = 0; j < len; j++) {
 		if (name_only) {
-			printf("%s ", aliases[j]);
+			printf("%s\n", aliases[j]);
 			continue;
 		}
 		printf("  %-50s [Kernel PMU event]\n", aliases[j]);
-- 
1.8.2.1


--------------040602070800020008040208--
