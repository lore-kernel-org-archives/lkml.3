Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab3L0KGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 05:06:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:8856 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab3L0KGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 05:06:15 -0500
X-IronPort-AV: E=Sophos;i="4.95,559,1384272000"; 
   d="scan'208";a="9336940"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@redhat.com, mingo@kernel.org, dsahern@gmail.com,
        linux-kernel@vger.kernel.org
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>
Subject: [PATCH 6/8] perf tools: Make --raw-dump work as a proper option for perf list.
Date: Fri, 27 Dec 2013 18:03:32 -0500
Message-Id: <3e42f175b64fa2362d90261cd50523b17163c477.1388184724.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1388184724.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1388184724.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/27 18:04:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/27 18:04:55,
	Serialize complete at 2013/12/27 18:04:55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramkumar reported that perf list --raw-dump was broken by 44d742e.
Fix by making raw-dump a proper argument.

Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-list.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index fed6792..ec90d0a 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -19,8 +19,10 @@
 int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int i;
+	bool raw_dump = false;
 	unsigned int count = 0;
 	const struct option list_options[] = {
+		OPT_BOOLEAN(0, "raw-dump", &raw_dump, "raw dump for completion"),
 		OPT_END()
 	};
 	const char * const list_usage[] = {
@@ -34,7 +36,7 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 	setup_pager();
 
 	if (argc == 0) {
-		print_events(NULL, false);
+		print_events(NULL, raw_dump);
 		return 0;
 	}
 
@@ -42,26 +44,24 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 		if (i)
 			putchar('\n');
 		if (strncmp(argv[i], "tracepoint", 10) == 0)
-			count += print_tracepoint_events(NULL, NULL, false);
+			count += print_tracepoint_events(NULL, NULL, raw_dump);
 		else if (strcmp(argv[i], "hw") == 0 ||
 			 strcmp(argv[i], "hardware") == 0)
-			count += print_events_type(PERF_TYPE_HARDWARE);
+			count += print_events_type(PERF_TYPE_HARDWARE, raw_dump);
 		else if (strcmp(argv[i], "sw") == 0 ||
 			 strcmp(argv[i], "software") == 0)
-			count += print_events_type(PERF_TYPE_SOFTWARE);
+			count += print_events_type(PERF_TYPE_SOFTWARE, raw_dump);
 		else if (strcmp(argv[i], "cache") == 0 ||
 			 strcmp(argv[i], "hwcache") == 0)
-			count += print_hwcache_events(NULL, false);
+			count += print_hwcache_events(NULL, raw_dump);
 		else if (strcmp(argv[i], "pmu") == 0)
-			count += print_pmu_events(NULL, false);
-		else if (strcmp(argv[i], "--raw-dump") == 0)
-			count += print_events(NULL, true);
+			count += print_pmu_events(NULL, raw_dump);
 		else {
 			char *sep = strchr(argv[i], ':'), *s;
 			int sep_idx;
 
 			if (sep == NULL) {
-				if(!(count += print_events(argv[i], false)))
+				if(!(count += print_events(argv[i], raw_dump)))
 					goto err_out;
 				continue;
 			}
@@ -71,7 +71,7 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 				return -1;
 
 			s[sep_idx] = '\0';
-			if (!(count += print_tracepoint_events(s, s + sep_idx + 1, false)))
+			if (!(count += print_tracepoint_events(s, s + sep_idx + 1, raw_dump)))
 				goto err_out;
 			free(s);
 		}
-- 
1.8.2.1

