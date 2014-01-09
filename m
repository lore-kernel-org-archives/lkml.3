Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbaAIJXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 04:23:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53425 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753868AbaAIJWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 04:22:13 -0500
X-IronPort-AV: E=Sophos;i="4.95,630,1384272000"; 
   d="scan'208";a="9395606"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, acme@redhat.com
Cc: dsahern@gmail.com, artagnon@gmail.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 3/7] perf tools: Improve the message of perf list for unexpected input.
Date: Thu, 9 Jan 2014 17:19:53 -0500
Message-Id: <10613586eec6ecf42e71bef2241b46debb5d7436.1389305623.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1389305623.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1389305623.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/09 17:21:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/09 17:21:05,
	Serialize complete at 2014/01/09 17:21:05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Example:
        # perf list test

        List of pre-defined events (to be used in -e):
        # echo $?
        0

Verification:
        # perf list test

        'test' is not a valid event type, please see the usage below for acceptable ones.
        Usage:
                perf list [hw|sw|cache|tracepoint|pmu|event_glob]
        # echo $?
        255

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/builtin-list.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 011195e..1aac451 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -19,6 +19,7 @@
 int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int i;
+	unsigned int count = 0;
 	const struct option list_options[] = {
 		OPT_END()
 	};
@@ -41,26 +42,27 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 		if (i)
 			putchar('\n');
 		if (strncmp(argv[i], "tracepoint", 10) == 0)
-			print_tracepoint_events(NULL, NULL, false);
+			count += print_tracepoint_events(NULL, NULL, false);
 		else if (strcmp(argv[i], "hw") == 0 ||
 			 strcmp(argv[i], "hardware") == 0)
-			print_events_type(PERF_TYPE_HARDWARE);
+			count += print_events_type(PERF_TYPE_HARDWARE);
 		else if (strcmp(argv[i], "sw") == 0 ||
 			 strcmp(argv[i], "software") == 0)
-			print_events_type(PERF_TYPE_SOFTWARE);
+			count += print_events_type(PERF_TYPE_SOFTWARE);
 		else if (strcmp(argv[i], "cache") == 0 ||
 			 strcmp(argv[i], "hwcache") == 0)
-			print_hwcache_events(NULL, false);
+			count += print_hwcache_events(NULL, false);
 		else if (strcmp(argv[i], "pmu") == 0)
-			print_pmu_events(NULL, false);
+			count += print_pmu_events(NULL, false);
 		else if (strcmp(argv[i], "--raw-dump") == 0)
-			print_events(NULL, true);
+			count += print_events(NULL, true);
 		else {
 			char *sep = strchr(argv[i], ':'), *s;
 			int sep_idx;
 
 			if (sep == NULL) {
-				print_events(argv[i], false);
+				if(!(count += print_events(argv[i], false)))
+					goto err_out;
 				continue;
 			}
 			sep_idx = sep - argv[i];
@@ -69,9 +71,16 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 				return -1;
 
 			s[sep_idx] = '\0';
-			print_tracepoint_events(s, s + sep_idx + 1, false);
+			if (!(count += print_tracepoint_events(s, s + sep_idx + 1, false)))
+				goto err_out;
 			free(s);
 		}
 	}
+
 	return 0;
+
+err_out:
+	pr_info("\n'%s' is not a valid event type, please see the usage below for acceptable ones.\n", argv[i]);
+	pr_info("Usage:\n\t%s\n", list_usage[0]);
+	return -1;
 }
-- 
1.8.2.1

